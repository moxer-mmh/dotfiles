#!/bin/bash
set -euo pipefail

main() {
    if ! command -v nmcli &>/dev/null; then
        printf '{"text": "󰌿", "class": "disconnected", "tooltip": "nmcli not found"}\n'
        return
    fi

    local vpn_line
    vpn_line=$(nmcli connection show --active 2>/dev/null \
        | grep -i vpn \
        | head -1 \
        || true)

    if [[ -n "$vpn_line" ]]; then
        # Extract connection name (first column)
        local vpn_name
        vpn_name=$(echo "$vpn_line" | awk '{print $1}')
        vpn_name="${vpn_name//\"/\\\"}"
        printf '{"text": "󰌾 %s", "class": "connected", "tooltip": "VPN: %s"}\n' \
            "$vpn_name" "$vpn_name"
    else
        printf '{"text": "󰌿", "class": "disconnected", "tooltip": "VPN: Not connected"}\n'
    fi
}

main
