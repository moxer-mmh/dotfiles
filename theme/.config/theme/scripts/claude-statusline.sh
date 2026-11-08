#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# claude-statusline.sh — Claude Code status line, themed from the dotfiles
# colour system.
#
# Wired up via ~/.claude/settings.json:
#   "statusLine": { "type": "command",
#                   "command": "~/.config/theme/scripts/claude-statusline.sh",
#                   "padding": 0 }
#
# Claude Code pipes a JSON session snapshot on stdin and renders whatever we
# print to stdout. Colours are sourced live from ~/.config/theme/colors, so an
# `apply-theme.sh <theme>` switch is picked up on the next render with no
# re-generation step.
#
# LAYOUT
#   Everything worth showing is ~190 columns at full detail, so on a narrow
#   terminal it will not fit one line. Default behaviour is a single line that
#   overflows: groups are packed left to right and whatever doesn't fit spills
#   onto a second line. A wide terminal gets exactly one line; a narrow one
#   grows a second only for the remainder. Nothing is dropped.
#
#   SL_LEVEL additionally trades detail for width (0 full .. 3 essentials) if
#   you'd rather abbreviate than wrap — see build().
#
# BUDGET
#   Runs on every render, so: jq (payload), git status, git worktree list,
#   awk (transcript scan). Compaction retries are pure string work — no extra
#   subprocesses, because all data is gathered before the first build.
# ---------------------------------------------------------------------------

set -uo pipefail
shopt -s extglob

# --- knobs -----------------------------------------------------------------
SL_LINES="${SL_LINES:-auto}"   # auto = one line, overflow wraps | 1 = never wrap
                               # 2 = fixed split (identity / telemetry)
SL_LEVEL="${SL_LEVEL:-0}"      # detail: 0 full .. 3 essentials (see build())
SL_ICONS="${SL_ICONS:-nerd}"   # nerd | ascii
SL_BAR_WIDTH="${SL_BAR_WIDTH:-10}"
SL_WIDTH="${SL_WIDTH:-}"       # force a column budget; empty = auto-detect
# Used when the width can't be detected. Must be finite: an unbounded line is
# not "unwrapped", it's silently truncated at the terminal edge, which hides
# every group on the right (activity, quota). Wrapping is the lesser evil.
SL_FALLBACK_WIDTH="${SL_FALLBACK_WIDTH:-120}"
SL_DEBUG="${SL_DEBUG:-}"       # non-empty = dump payload + env for diagnosis

PAYLOAD="$(cat)"

# ---------------------------------------------------------------------------
# Palette — mirror apply-theme.sh's source order, fall back to space-station.
# ---------------------------------------------------------------------------
COLOR_FG="#e0e1e5";      COLOR_FG_DIM="#b4a7d6"
COLOR_PRIMARY="#8844ff"; COLOR_SECONDARY="#00aaff"
COLOR_ACCENT="#00ff88";  COLOR_WARN="#ffaa00"
COLOR_CRIT="#ff0088";    COLOR_PINK="#ff44aa"

_colors_dir="$HOME/.config/theme/colors"
# shellcheck disable=SC1090,SC1091
[[ -r "$_colors_dir/current.conf" ]]        && . "$_colors_dir/current.conf"
# shellcheck disable=SC1090,SC1091
[[ -r "$_colors_dir/user-overrides.conf" ]] && . "$_colors_dir/user-overrides.conf"

# hex "#rrggbb" -> 24-bit truecolor SGR. Pure builtin, no subprocess.
fg() { local h=${1#\#}; printf '\033[38;2;%d;%d;%dm' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"; }

C_DIR=$(fg "$COLOR_PRIMARY");   C_GIT=$(fg "$COLOR_SECONDARY")
C_MODEL=$(fg "$COLOR_ACCENT");  C_WARN=$(fg "$COLOR_WARN")
C_CRIT=$(fg "$COLOR_CRIT");     C_DIM=$(fg "$COLOR_FG_DIM")
C_FG=$(fg "$COLOR_FG");         C_PINK=$(fg "$COLOR_PINK")
R=$'\033[0m'; B=$'\033[1m'

# ---------------------------------------------------------------------------
# Icons
# ---------------------------------------------------------------------------
if [[ $SL_ICONS == nerd ]]; then
  I_DIR=""  I_GIT=""  I_MODEL="󰚩" I_STYLE="󰋼" I_MODE=""
  I_CTX="󰍛"  I_COST=""  I_TIME=""  I_SKILL="󰓹" I_AGENT="󰀉"
  I_FAST="󰓅"  I_THINK="󰧑" I_WT=""  I_PR=""   I_QUOTA="󰄉"
  I_WARN=""  I_TOOL=""  I_MCP=""  I_PLUGIN=""
else
  I_DIR="dir"  I_GIT="git" I_MODEL="@"  I_STYLE="style" I_MODE="mode"
  I_CTX="ctx"  I_COST="$"  I_TIME="t"   I_SKILL="sk"    I_AGENT="ag"
  I_FAST="F"   I_THINK="T" I_WT="wt"    I_PR="pr"       I_QUOTA="q"
  I_WARN="!"   I_TOOL="tl" I_MCP="mcp"  I_PLUGIN="pl"
fi

# ---------------------------------------------------------------------------
# Payload -> shell vars.
#
# Fields are joined with U+001F (unit separator) rather than @tsv: tab is an
# IFS *whitespace* character, so bash collapses runs of tabs and silently
# shifts every field after an empty one. 0x1f is non-whitespace, so empty
# fields survive as empty. Order here is locked to the read below.
# Field set verified against the Claude Code 2.1.233 status-line snapshot.
# ---------------------------------------------------------------------------
read_payload() {
  printf '%s' "$PAYLOAD" | jq -r '
    [ (.workspace.current_dir // ""),
      (.workspace.project_dir // ""),
      (.model.display_name // "Claude"),
      (.output_style.name // ""),
      (.permission_mode // ""),
      (.context_window.total_input_tokens // 0),
      (.context_window.context_window_size // 0),
      (.context_window.used_percentage // 0),
      (.cost.total_cost_usd // 0),
      (.cost.total_duration_ms // 0),
      (.cost.total_lines_added // 0),
      (.cost.total_lines_removed // 0),
      (.exceeds_200k_tokens // false),
      (.fast_mode // false),
      (.thinking.enabled // false),
      (.effort.level // ""),
      (.vim.mode // ""),
      (.rate_limits.five_hour.used_percentage // -1),
      (.rate_limits.seven_day.used_percentage // -1),
      (.transcript_path // ""),
      (.worktree.name // ""),
      (.worktree.branch // ""),
      (.worktree.original_branch // ""),
      (.worktree.path // ""),
      (.pr.number // ""),
      (.pr.review_state // ""),
      (.session_name // "")
    ] | map(tostring) | join("\u001f")' 2>/dev/null
}

if command -v jq >/dev/null 2>&1; then
  IFS=$'\x1f' read -r CWD PROJ MODEL STYLE MODE TOK_IN CTX_SIZE CTX_PCT \
    COST DUR_MS ADDED REMOVED OVER_200K FAST THINK EFFORT VIM \
    Q5H Q7D TRANSCRIPT WT_NAME WT_BRANCH WT_ORIG WT_PATH \
    PR_NUM PR_STATE SESSION_NAME < <(read_payload)
fi

# Degrade to something useful rather than blank if jq is missing/failed.
: "${CWD:=$PWD}" "${MODEL:=Claude}" "${CTX_PCT:=0}" "${CTX_SIZE:=0}" "${TOK_IN:=0}"
: "${COST:=0}" "${DUR_MS:=0}" "${ADDED:=0}" "${REMOVED:=0}" "${MODE:=}" "${STYLE:=}"
: "${OVER_200K:=false}" "${FAST:=false}" "${THINK:=false}" "${EFFORT:=}" "${VIM:=}"
: "${Q5H:=-1}" "${Q7D:=-1}" "${TRANSCRIPT:=}" "${PROJ:=}" "${SESSION_NAME:=}"
: "${WT_NAME:=}" "${WT_BRANCH:=}" "${WT_ORIG:=}" "${WT_PATH:=}"
: "${PR_NUM:=}" "${PR_STATE:=}"

[[ -d $CWD ]] || CWD="$PWD"

# ---------------------------------------------------------------------------
# Helpers (builtin-only)
# ---------------------------------------------------------------------------
int() { local v=${1%%.*}; [[ $v =~ ^-?[0-9]+$ ]] && printf '%s' "$v" || printf '0'; }

human() {   # 1234 -> 1.2k, 1234567 -> 1.2M
  local n; n=$(int "${1:-0}")
  if   (( n >= 1000000 )); then printf '%d.%dM' $((n/1000000)) $(( (n%1000000)/100000 ))
  elif (( n >= 1000 ));    then printf '%d.%dk' $((n/1000))    $(( (n%1000)/100 ))
  else printf '%d' "$n"; fi
}

human_short() {   # 1234 -> 1k, 1234567 -> 1M  (no decimal)
  local n; n=$(int "${1:-0}")
  if   (( n >= 1000000 )); then printf '%dM' $((n/1000000))
  elif (( n >= 1000 ));    then printf '%dk' $((n/1000))
  else printf '%d' "$n"; fi
}

dur() {     # ms -> 4s / 12m30s / 2h05m
  local ms s; ms=$(int "${1:-0}"); s=$((ms/1000))
  if   (( s >= 3600 )); then printf '%dh%02dm' $((s/3600)) $(( (s%3600)/60 ))
  elif (( s >= 60 ));   then printf '%dm%02ds' $((s/60))   $((s%60))
  else printf '%ds' "$s"; fi
}

dur_short() {   # ms -> 4s / 12m / 2h  (largest unit only)
  local ms s; ms=$(int "${1:-0}"); s=$((ms/1000))
  if   (( s >= 3600 )); then printf '%dh' $((s/3600))
  elif (( s >= 60 ));   then printf '%dm' $((s/60))
  else printf '%ds' "$s"; fi
}

# Colour ramp for a 0-100 fill: green -> pink -> amber -> red.
ramp() {
  local p=$1
  if   (( p >= 90 )); then printf '%s' "$C_CRIT"
  elif (( p >= 75 )); then printf '%s' "$C_WARN"
  elif (( p >= 50 )); then printf '%s' "$C_PINK"
  else printf '%s' "$C_MODEL"; fi
}

bar() {
  local p=$1 w=${2:-$SL_BAR_WIDTH} filled i out=""
  (( p < 0 )) && p=0; (( p > 100 )) && p=100
  filled=$(( p * w / 100 ))
  for (( i = 0; i < w; i++ )); do
    (( i < filled )) && out+="█" || out+="░"
  done
  printf '%s' "$out"
}

# Visible length: strip SGR sequences, count what's left. Nerd Font glyphs are
# single-cell in every terminal this targets, so character count == columns.
# Result lands in $VISLEN rather than stdout — this is called once per group per
# render, and command substitution would fork a subshell every time.
VISLEN=0
vislen() { local s=${1//$'\033'\[*([0-9;])m/}; VISLEN=${#s}; }

# Render a comma-separated id list as "@a,@b,+3". Plugin namespaces are dropped
# for display (everything-claude-code:code-reviewer -> code-reviewer) since the
# prefix is the same for every entry and eats the width names need.
# Result lands in $NAMES_OUT to avoid a subshell fork per call.
NAMES_OUT=""
name_list() {
  local list=$1 max=${2:-3} sigil=${3:-@} oIFS=$IFS
  local -a arr; local n out="" i=0
  NAMES_OUT=""
  [[ -z $list ]] && return
  IFS=','; arr=($list); IFS=$oIFS
  for n in "${arr[@]}"; do
    (( i++ ))
    if (( i > max )); then out+=",+$(( ${#arr[@]} - max ))"; break; fi
    [[ -n $out ]] && out+=","
    out+="${sigil}${n##*:}"
  done
  NAMES_OUT=$out
}

# ---------------------------------------------------------------------------
# Layout primitives.
#
# The SL_ prefix on the accumulators is load-bearing: bash reserves a special
# variable named GROUPS (the caller's group IDs) and silently discards
# assignments to it, so a plain `GROUPS=()` renders `id -G` instead of a status
# line. SL_SPLIT records where line 1 ends when SL_LINES=2.
# ---------------------------------------------------------------------------
SL_ITEMS=(); SL_GROUPS=(); SL_SPLIT=0

# Sentinel group meaning "start a new line here regardless of remaining width".
# Used so the who-did-the-work names get a line of their own instead of being
# tacked onto whatever the telemetry groups happened to leave over.
BRK=$'\001'
forcebreak() { SL_GROUPS+=("$BRK"); }

item() { [[ -n ${1:-} ]] && SL_ITEMS+=("$1"); }

endgroup() {
  local out="" s
  (( ${#SL_ITEMS[@]} )) || return 0
  for s in "${SL_ITEMS[@]}"; do [[ -n $out ]] && out+="  "; out+="$s"; done
  SL_ITEMS=()
  [[ -n $out ]] && SL_GROUPS+=("$out")
}

# join_groups <start> <count> <sep>
join_groups() {
  local start=$1 count=$2 sep=$3 out="" i end=$(( $1 + $2 ))
  for (( i = start; i < end && i < ${#SL_GROUPS[@]}; i++ )); do
    [[ ${SL_GROUPS[i]} == "$BRK" ]] && continue    # breaks are a wrap-mode concept
    [[ -n $out ]] && out+="$sep"
    out+="${SL_GROUPS[i]}"
  done
  printf '%s' "$out"
}

# ---------------------------------------------------------------------------
# build <level> — populate SL_GROUPS at a given compaction level.
#
#   0  full detail
#   1  abbreviate: short model, no context bar, coarse duration, terse quota
#   2  drop context: PR state, worktree, style, tools, skills, quota
#   3  essentials only: where, what, context %, mode
#
# Runs in the current shell (not a subshell) so the arrays survive for the
# emit step.
# ---------------------------------------------------------------------------
build() {
  local L=$1
  SL_ITEMS=(); SL_GROUPS=(); SL_SPLIT=0

  # ---- group: where ----
  local dir_label="${CWD##*/}"
  if (( L < 2 )) && [[ -n $PROJ && $CWD == "$PROJ"/* ]]; then
    dir_label="${PROJ##*/}/${CWD#"$PROJ"/}"
  fi
  item "${C_DIR}${B}${I_DIR} ${dir_label}${R}"

  if [[ -n $BRANCH ]]; then
    local g="${C_GIT}${I_GIT} ${BRANCH}${R}"
    (( DIRTY  > 0 )) && g+="${C_WARN}*${DIRTY}${R}"
    (( AHEAD  > 0 )) && g+=" ${C_MODEL}⇡${AHEAD}${R}"
    (( BEHIND > 0 )) && g+=" ${C_CRIT}⇣${BEHIND}${R}"
    item "$g"
  fi

  # Worktree: name + the branch it was cut from, plus sibling count.
  if (( L < 2 )) && [[ -n $WT_LABEL ]]; then
    local w="${C_PINK}${I_WT} ${WT_LABEL}${R}"
    (( L < 1 )) && [[ -n $WT_ORIG && $WT_ORIG != "$BRANCH" ]] && w+="${C_DIM}←${WT_ORIG}${R}"
    (( WT_TOTAL > 1 )) && w+=" ${C_DIM}${WT_TOTAL}${R}"
    item "$w"
  elif (( L < 2 )) && (( WT_TOTAL > 1 )); then
    item "${C_DIM}${I_WT} ${WT_TOTAL}${R}"
  fi

  if (( L < 3 )) && [[ -n $PR_NUM ]]; then
    local p="${C_PINK}${I_PR} #${PR_NUM}${R}"
    # GitHub's review states are shouty and long; a glyph carries the signal.
    if (( L < 2 )); then
      case $PR_STATE in
        APPROVED)          p+=" ${C_MODEL}✓${R}" ;;
        CHANGES_REQUESTED) p+=" ${C_CRIT}✗${R}" ;;
        REVIEW_REQUIRED)   p+=" ${C_WARN}◦${R}" ;;
        COMMENTED)         p+=" ${C_DIM}▪${R}" ;;
      esac
    fi
    item "$p"
  fi
  endgroup

  # ---- group: what ----
  # "Opus 5 (1M context)" is mostly padding; keep the tier, mark the 1M window.
  local mname="$MODEL"
  if (( L >= 1 )); then
    mname="${MODEL%% (*}"
    [[ $MODEL == *1M* ]] && mname+=" 1M"
  fi
  local m="${C_MODEL}${B}${I_MODEL} ${mname}${R}"
  [[ $FAST  == true ]] && m+=" ${C_WARN}${I_FAST}${R}"
  [[ $THINK == true ]] && m+=" ${C_PINK}${I_THINK}${R}"
  (( L < 2 )) && [[ -n $EFFORT ]] && m+=" ${C_DIM}${EFFORT}${R}"
  item "$m"
  endgroup

  # ---- group: how ----
  (( L < 2 )) && [[ -n $STYLE && $STYLE != default ]] \
    && item "${C_DIM}${I_STYLE} ${STYLE}${R}"

  if [[ -n $MODE && $MODE != default ]]; then
    local mc ml
    case $MODE in
      plan)              mc="$C_GIT"  ml="plan" ;;
      acceptEdits)       mc="$C_WARN" ml="accept-edits"; (( L >= 1 )) && ml="accept" ;;
      bypassPermissions) mc="$C_CRIT" ml="bypass" ;;
      *)                 mc="$C_DIM"  ml="$MODE" ;;
    esac
    item "${mc}${I_MODE} ${ml}${R}"
  fi

  (( L < 1 )) && [[ -n $VIM ]] && item "${C_DIM}${VIM}${R}"
  (( L < 1 )) && [[ -n $SESSION_NAME ]] && item "${C_DIM}${SESSION_NAME}${R}"
  endgroup

  SL_SPLIT=${#SL_GROUPS[@]}   # ── line 1 ends here in two-line mode ──

  # ---- group: context budget (the number that predicts compaction) ----
  if (( CTX_SIZE_I > 0 )); then
    local cr; cr=$(ramp "$CP")
    local ctx="${cr}${I_CTX} "
    (( L < 1 )) && ctx+="$(bar "$CP") "
    ctx+="${CP}%${R}"
    if   (( L < 1 )); then ctx+=" ${C_DIM}$(human "$TOK_IN")/$(human "$CTX_SIZE")${R}"
    elif (( L < 3 )); then ctx+=" ${C_DIM}$(human_short "$TOK_IN")${R}"
    fi
    [[ $OVER_200K == true ]] && ctx+=" ${C_CRIT}${I_WARN}${R}"
    item "$ctx"
  fi
  endgroup

  # ---- group: spend ----
  (( L < 3 )) && item "${C_DIM}${I_COST} \$${COST_FMT}${R}"
  if   (( L < 1 )); then item "${C_DIM}${I_TIME} $(dur "$DUR_MS")${R}"
  elif (( L < 2 )); then item "${C_DIM}${I_TIME} $(dur_short "$DUR_MS")${R}"
  fi
  endgroup

  # ---- group: session activity (used / available) ----
  (( L < 3 )) && (( A || D )) && item "${C_MODEL}+${A}${R} ${C_CRIT}-${D}${R}"
  (( L < 2 )) && (( TOOLS > 0 )) && item "${C_DIM}${I_TOOL} ${TOOLS}${R}"
  if (( L < 3 )); then
    # used/available reads better than a bare count: "0/2230 skills" says the
    # registry is loaded and simply unused, where a hidden item says nothing.
    local sc="$C_DIM"; (( SKILLS    > 0 )) && sc="$C_PINK"
    local ac="$C_DIM"; (( SUBAGENTS > 0 )) && ac="$C_GIT"
    local mc2="$C_DIM"; (( MCPCALLS > 0 )) && mc2="$C_MODEL"
    item "${sc}${I_SKILL} ${SKILLS}${C_DIM}/${SKILLS_AVAIL}${R}"
    item "${ac}${I_AGENT} ${SUBAGENTS}${C_DIM}/${AGENTS_AVAIL}${R}"
    (( L < 2 )) && item "${mc2}${I_MCP} ${MCPCALLS}${C_DIM}/${MCP_AVAIL}${R}"
    (( L < 1 )) && item "${C_DIM}${I_PLUGIN} ${PLUGINS_AVAIL}${R}"
  fi
  endgroup

  # ---- group: plan quota ----
  if (( L < 2 )) && (( q5 >= 0 || q7 >= 0 )); then
    local q="${C_DIM}${I_QUOTA}${R}"
    if (( L < 1 )); then
      (( q5 >= 0 )) && q+=" $(ramp "$q5")5h ${q5}%${R}"
      (( q7 >= 0 )) && q+=" $(ramp "$q7")7d ${q7}%${R}"
    else
      (( q5 >= 0 )) && q+=" $(ramp "$q5")${q5}${R}"
      (( q7 >= 0 )) && q+="${C_DIM}/${R}$(ramp "$q7")${q7}%${R}"
    fi
    item "$q"
  fi
  endgroup

  # ---- group: who actually did the work ----
  # Given a line of their own via forcebreak, so they read as a roster rather
  # than as the tail of whatever the telemetry groups spilled.
  if (( L < 2 )) && [[ -n $AGENT_NAMES$SKILL_NAMES$MCP_NAMES ]]; then
    forcebreak
    if [[ -n $AGENT_NAMES ]]; then
      name_list "$AGENT_NAMES" 3 "@"; item "${C_GIT}${I_AGENT} ${NAMES_OUT}${R}"
    fi
    if [[ -n $SKILL_NAMES ]]; then
      name_list "$SKILL_NAMES" 3 "/"; item "${C_PINK}${I_SKILL} ${NAMES_OUT}${R}"
    fi
    if [[ -n $MCP_NAMES ]]; then
      name_list "$MCP_NAMES" 3 "";   item "${C_MODEL}${I_MCP} ${NAMES_OUT}${R}"
    fi
  fi
  endgroup
}

# ---------------------------------------------------------------------------
# Gather everything build() needs (all subprocesses happen here, once).
# ---------------------------------------------------------------------------
BRANCH=""; AHEAD=0; BEHIND=0; DIRTY=0; IN_REPO=0
if GIT_RAW=$(git -C "$CWD" --no-optional-locks status --porcelain=v2 --branch 2>/dev/null); then
  IN_REPO=1
  while IFS= read -r line; do
    case $line in
      '# branch.head '*) BRANCH="${line#\# branch.head }" ;;
      '# branch.ab '*)
        ab="${line#\# branch.ab }"; AHEAD="${ab%% *}"; BEHIND="${ab##* }"
        AHEAD="${AHEAD#+}"; BEHIND="${BEHIND#-}" ;;
      [12u?]*) (( DIRTY++ )) ;;
    esac
  done <<< "$GIT_RAW"
fi
[[ $BRANCH == "(detached)" ]] && BRANCH=""

WT_TOTAL=0; WT_LABEL="${WT_NAME:-}"
if (( IN_REPO )); then
  WT_CURRENT=""
  while IFS= read -r line; do
    case $line in
      'worktree '*)
        (( WT_TOTAL++ ))
        p="${line#worktree }"
        [[ $CWD == "$p" || $CWD == "$p"/* ]] && WT_CURRENT="${p##*/}"
        ;;
    esac
  done < <(git -C "$CWD" --no-optional-locks worktree list --porcelain 2>/dev/null)
  # Fall back to the checkout dir name when Claude Code didn't name the worktree.
  [[ -z $WT_LABEL && $WT_TOTAL -gt 1 && -n $WT_CURRENT && $WT_CURRENT != "${PROJ##*/}" ]] \
    && WT_LABEL="$WT_CURRENT"
fi

CP=$(int "$CTX_PCT"); CTX_SIZE_I=$(int "$CTX_SIZE")
A=$(int "$ADDED");    D=$(int "$REMOVED")
q5=$(int "$Q5H");     q7=$(int "$Q7D")
printf -v COST_FMT '%.2f' "${COST:-0}" 2>/dev/null || COST_FMT="0.00"

# --- transcript scan --------------------------------------------------------
# Counts alone ("2 agents") don't tell you *which*, so this also collects the
# distinct names in first-use order: subagent types, skill ids, MCP servers.
# One awk pass over the session transcript does all of it.
TOOLS=0; SKILLS=0; SUBAGENTS=0; MCPCALLS=0
AGENT_NAMES=""; SKILL_NAMES=""; MCP_NAMES=""
if [[ -n $TRANSCRIPT && -r $TRANSCRIPT ]]; then
  SIZE=$(stat -c %s "$TRANSCRIPT" 2>/dev/null || echo 0)
  # Guard against a pathological transcript stalling every render.
  if (( SIZE < 64000000 )); then
    IFS=$'\x1f' read -r TOOLS SKILLS SUBAGENTS MCPCALLS \
                        AGENT_NAMES SKILL_NAMES MCP_NAMES < <(
      awk '
        # Collect every distinct value of "<key>":"<value>" on this line,
        # preserving first-seen order.
        function grab(key, seen, order,    pat, plen, s, v) {
          pat = "\"" key "\":\""; plen = length(pat); s = $0
          while (match(s, pat "[^\"]*\"")) {
            v = substr(s, RSTART + plen, RLENGTH - plen - 1)
            if (!(v in seen)) { seen[v] = 1; order[++n[key]] = v }
            s = substr(s, RSTART + RLENGTH)
          }
        }
        function joinarr(order, cnt,   i, out) {
          for (i = 1; i <= cnt; i++) out = (out == "" ? "" : out ",") order[i]
          return out
        }
        {
          t += gsub(/"type":"tool_use"/, "")
          s += gsub(/"name":"Skill"/, "")
          a += gsub(/"name":"(Agent|Task)"/, "")
          m += gsub(/"name":"mcp__/, "")
          grab("subagent_type", aseen, aord)
          grab("skill", sseen, sord)
          # MCP tools are named mcp__<server>__<tool>; keep the server.
          line = $0
          while (match(line, /"name":"mcp__[^"]*"/)) {
            v = substr(line, RSTART + 8, RLENGTH - 9)
            split(v, parts, "__"); srv = parts[2]
            if (srv != "" && !(srv in mseen)) { mseen[srv] = 1; mord[++mc] = srv }
            line = substr(line, RSTART + RLENGTH)
          }
        }
        END {
          printf "%d\037%d\037%d\037%d\037%s\037%s\037%s", t, s, a, m,
                 joinarr(aord, n["subagent_type"]),
                 joinarr(sord, n["skill"]),
                 joinarr(mord, mc)
        }' "$TRANSCRIPT" 2>/dev/null
    )
  fi
fi
: "${TOOLS:=0}" "${SKILLS:=0}" "${SUBAGENTS:=0}" "${MCPCALLS:=0}"
: "${AGENT_NAMES:=}" "${SKILL_NAMES:=}" "${MCP_NAMES:=}"

# --- registry sizes: agents / skills / MCP servers / plugins ----------------
# These change only when you install something, and the skills walk alone costs
# ~200ms across 127 plugins — far too slow to repeat on every render. One cache
# file holds all four, refreshed every 10 minutes.
REG_CACHE="${XDG_RUNTIME_DIR:-/tmp}/claude-statusline-registry.count"
AGENTS_AVAIL=""; SKILLS_AVAIL=""; MCP_AVAIL=""; PLUGINS_AVAIL=""
if [[ -r $REG_CACHE ]]; then
  CACHE_AGE=$(( ${EPOCHSECONDS:-0} - $(stat -c %Y "$REG_CACHE" 2>/dev/null || echo 0) ))
  (( CACHE_AGE < 600 )) && \
    IFS=' ' read -r AGENTS_AVAIL SKILLS_AVAIL MCP_AVAIL PLUGINS_AVAIL < "$REG_CACHE"
fi
if [[ -z $AGENTS_AVAIL ]]; then
  # The plugin cache accumulates temp_git_*/temp_subdir_* clone leftovers and
  # .git trees; counting those inflates every total (plugins read 481 instead of
  # 120). Prune them rather than filtering after the walk, so we don't pay to
  # descend into them either.
  _prune=( \( -name 'temp_*' -o -name '.git' \) -prune -o )
  # '*/agents/*.md' only — a bare '*agents*' also swallows READMEs from any
  # plugin whose name merely contains "agents".
  AGENTS_AVAIL=$(find "$HOME/.claude/agents" "$HOME/.claude/plugins/cache" \
                      "${_prune[@]}" -type f -path '*/agents/*.md' -print 2>/dev/null | wc -l)
  SKILLS_AVAIL=$(find "$HOME/.claude/skills" "$HOME/.claude/plugins/cache" \
                      "${_prune[@]}" -type f -name 'SKILL.md' -print 2>/dev/null | wc -l)
  # mcpServers appears at top level and per-project, hence the recursive scan.
  MCP_AVAIL=$(jq -r '[.. | objects | select(has("mcpServers")) | .mcpServers | keys[]]
                     | unique | length' "$HOME/.claude.json" 2>/dev/null)
  # Authoritative installed list — cheaper and more accurate than a dir count.
  PLUGINS_AVAIL=$(jq -r '.plugins | length' \
                     "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null)
  printf '%s %s %s %s\n' "${AGENTS_AVAIL:-0}" "${SKILLS_AVAIL:-0}" \
         "${MCP_AVAIL:-0}" "${PLUGINS_AVAIL:-0}" > "$REG_CACHE" 2>/dev/null
fi
: "${AGENTS_AVAIL:=0}" "${SKILLS_AVAIL:=0}" "${MCP_AVAIL:=0}" "${PLUGINS_AVAIL:=0}"

# ---------------------------------------------------------------------------
# Column budget. Claude Code runs us with stdout on a pipe, so COLUMNS is
# usually unset and tput reads the wrong thing — /dev/tty is the reliable
# source. Unknown width means "don't compact", not "compact hard".
# ---------------------------------------------------------------------------
term_width() {
  local w="${SL_WIDTH:-}"
  [[ -z $w && -n ${COLUMNS:-} ]] && w="$COLUMNS"
  if [[ -z $w ]]; then
    # The redirect must be wrapped in a group whose stderr is already pointed at
    # /dev/null: when /dev/tty is absent the *shell* reports the failed redirect,
    # so a trailing 2>/dev/null on stty alone still leaks to our stderr.
    w=$( { stty size < /dev/tty; } 2>/dev/null ) && w="${w##* }" || w=""
  fi
  [[ $w =~ ^[0-9]+$ && $w -gt 0 ]] || w="$SL_FALLBACK_WIDTH"
  printf '%s' "$w"
}
WIDTH=$(term_width)

# SL_DEBUG=1 dumps the raw payload and what we derived from it. Useful for
# checking whether Claude Code actually exposes a usable terminal width, since
# a wrong guess silently truncates the right-hand groups.
if [[ -n $SL_DEBUG ]]; then
  {
    printf 'width=%s (COLUMNS=%s SL_WIDTH=%s fallback=%s)\n' \
           "$WIDTH" "${COLUMNS:-unset}" "${SL_WIDTH:-unset}" "$SL_FALLBACK_WIDTH"
    printf 'tty=%s\n' "$( { stty size < /dev/tty; } 2>&1 )"
    printf 'tools=%s skills=%s subagents=%s mcpcalls=%s\n' \
           "$TOOLS" "$SKILLS" "$SUBAGENTS" "$MCPCALLS"
    printf 'agents=[%s] skillnames=[%s] mcp=[%s]\n' \
           "$AGENT_NAMES" "$SKILL_NAMES" "$MCP_NAMES"
    printf 'registry: agents=%s skills=%s mcp=%s plugins=%s\n' \
           "$AGENTS_AVAIL" "$SKILLS_AVAIL" "$MCP_AVAIL" "$PLUGINS_AVAIL"
    printf 'payload:\n%s\n' "$PAYLOAD"
  } > "${XDG_RUNTIME_DIR:-/tmp}/claude-statusline.debug" 2>/dev/null
fi

# ---------------------------------------------------------------------------
# Emit
# ---------------------------------------------------------------------------
SEP="${C_DIM}  │  ${R}"; SEPW=5

# Greedy pack: fill the line to the terminal edge, spill the remainder onto the
# next one. Groups are the unit — wrapping mid-group would split e.g. a branch
# from its dirty count. One line whenever it fits, two only when it must.
pack_and_print() {
  local line="" linew=0 g gw i
  for (( i = 0; i < ${#SL_GROUPS[@]}; i++ )); do
    g="${SL_GROUPS[i]}"
    if [[ $g == "$BRK" ]]; then
      [[ -n $line ]] && { printf '%s\n' "$line"; line=""; linew=0; }
      continue
    fi
    vislen "$g"; gw=$VISLEN
    if [[ -z $line ]]; then
      line="$g"; linew=$gw
    elif (( WIDTH > 0 && linew + SEPW + gw > WIDTH )); then
      printf '%s\n' "$line"          # spill
      line="$g"; linew=$gw
    else
      line+="${SEP}${g}"; linew=$(( linew + SEPW + gw ))
    fi
  done
  [[ -n $line ]] && printf '%s\n' "$line"
}

build "$SL_LEVEL"

case $SL_LINES in
  1)  # force everything onto one line, terminal may truncate
      printf '%s\n' "$(join_groups 0 "${#SL_GROUPS[@]}" "$SEP")" ;;
  2)  # fixed semantic split: identity above, telemetry below
      printf '%s\n' "$(join_groups 0 "$SL_SPLIT" "$SEP")"
      printf '%s\n' "$(join_groups "$SL_SPLIT" "${#SL_GROUPS[@]}" "$SEP")" ;;
  *)  pack_and_print ;;
esac
