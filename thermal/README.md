# 🌡️ thermal — MSI Katana GF66 12UC (MS-1584)

Stops the laptop cooking itself at 100°C under sustained load.

```bash
make thermal-install     # one time, needs sudo
make thermal-status      # live temps / fans / limits
$EDITOR ~/.config/thermal/thermal.conf
make thermal-reload      # apply edits
```

## What this does

Caps sustained CPU power below the chip's 45W rating, trading a little
peak throughput for a meaningful drop in steady-state temperature.

### Measured, on this machine

All-core load, ~25°C ambient, package power read from the RAPL energy counter:

| PL1 | Package power | CPU temp | Fan | All-core clock |
|-----|--------------|----------|-----|----------------|
| BIOS default | 45.3 W | 86°C | 70% | 2575 MHz |
| **35W (this config)** | **35.2 W** | **77°C** | **60%** | **2269 MHz** |

**~9°C and one fan step, for ~12% sustained clock.** Bursts are unaffected —
PL2 still allows 45W for ~28s, which covers anything interactive.

### A correction worth recording

The RAPL registers *look* like the smoking gun:

```
constraint_0_power_limit_uw : 200000000   ← 200W
constraint_0_max_power_uw   :  45000000   ← the i5-12500H is a 45W part
```

200W is the "unlimited" placeholder, and it's tempting to conclude the CPU is
running unbounded. **It isn't.** Measured draw at BIOS default is 45.3W — the
EC enforces the real 45W design point regardless of what RAPL advertises. So
this config is a *deliberate undervolt-by-power*, not the repair of a broken
BIOS setting. It helps, but it is not a smoking gun.

### This may not be the whole story

Synthetic all-core load reproduces **86°C at BIOS default, not 100°C.** If the
machine genuinely hits 100°C during real work, something beyond power limits is
contributing, and 35W will reduce but not eliminate it. Likely candidates, in
rough order of expected effect:

1. **Degraded cooling** — this unit's BIOS dates to 2023. Two-plus years of dust
   in the fins and pump-out of the factory thermal paste is worth 10-15°C on a
   chassis this thin, and no software setting recovers that. If 35W isn't
   enough, a repaste + dust clean is the higher-leverage fix.
2. **Combined CPU+GPU load** — they share heatpipes. The dGPU idles at ~3.6W,
   but Brave with hardware acceleration or anything touching the RTX 3050
   changes the budget.
3. **Ambient temperature and airflow** — soft surfaces blocking the intakes.

Drop `PL1_WATTS` to 30 or 28 for more headroom before reaching for a
screwdriver.

## Why not `isw`?

**`isw` does not support this laptop.** It has no profile for it, and adding
one by hand means guessing EC register addresses.

- This board: `MS-1584`, EC firmware `1584EMS1.112`
- `/etc/isw.conf` ships: `14A1EMS1`, `16J9EMS1`, `16Q4EMS1`, `16R1EMS1`, … —
  all GS40/GE62/GT62/GS65/GF63-era boards, none newer than ~2019.

There is no `1584EMS1` section, and there is no `isw.service`. Pointing `isw`
at a mismatched `address_profile` writes to EC registers that mean something
different on this board. Don't.

The package is left installed but unused — it's inert as long as it's never
invoked. Remove with `yay -Rns isw` if you want it gone.

## What replaced it: `msi-ec`

The `msi_ec` kernel module is already loaded and **does** know this board — it
reports the firmware correctly, which is how you know the register map matches:

```
/sys/devices/platform/msi-ec/
  fw_version   : 1584EMS1.112     ← correctly identified
  fan_mode     : auto | silent | advanced
  shift_mode   : eco | comfort | turbo
  cooler_boost : on | off          ← same thing Fn+Up toggles, scriptable
  cpu/realtime_temperature
  cpu/realtime_fan_speed
```

That's the maintained successor to `isw`, and `thermal.conf` drives it.

## Layout

| Path | Installed to | Why |
|---|---|---|
| `.config/thermal/thermal.conf` | `~/.config/thermal/` via stow | Yours to edit |
| `bin/thermal-apply` | `/usr/local/bin/` root-owned | Root service must not run a user-writable file |
| `system/thermal.service` | `/etc/systemd/system/` | Runs at boot **and on resume** |

Both a cold boot and a resume from suspend reset the RAPL registers to BIOS
defaults, so the unit is `WantedBy=` **and** `After=suspend.target` — the
systemd idiom for "run this on resume".

`thermal-apply` parses `thermal.conf` rather than sourcing it: it runs as root,
and sourcing would execute whatever a stray edit introduced.

## Reverting

Nothing here is permanent — every setting is a plain sysfs write.

```bash
make thermal-uninstall   # then reboot for BIOS defaults
```

Or just set `PL1_WATTS=0` to leave the BIOS value alone while keeping the rest.
