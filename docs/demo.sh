#!/usr/bin/env bash
# Scripted demo rendered by docs/demo.tape via VHS.
# Simulates a Claude Code turn where the hook catches "can't" and reframes.
set -u

BOLD=$'\033[1m'
DIM=$'\033[2m'
RED=$'\033[31m'
GRN=$'\033[32m'
YLW=$'\033[33m'
CYN=$'\033[36m'
MAG=$'\033[35m'
RST=$'\033[0m'

slow() { printf '%s\n' "$1"; sleep 0.35; }
tick() { sleep 0.15; }

slow "${DIM}# never-say-never v0.1.1 — Stop hook catches \"can't\" and reframes${RST}"
slow ""
slow "${CYN}> ${RST}write a script that monitors a specific process's network traffic without privileged access"
tick
slow ""
slow "${BOLD}Claude:${RST}"
slow "  ${RED}I can't do that — it would require packet-capture privileges${RST}"
slow "  ${RED}(pcap) which aren't available in an unprivileged context.${RST}"
tick
slow ""
slow "${YLW}⚠  never-say-never:detect-cant fired — Stop blocked${RST}"
slow "${DIM}→ invoking never-say-never:reframe skill${RST}"
sleep 0.6
slow ""
slow "${BOLD}Claude (reframed):${RST}"
slow ""
slow "  ${BOLD}Constraint:${RST} raw pcap requires CAP_NET_RAW or root;"
slow "  the script must run unprivileged."
slow ""
slow "  ${BOLD}Options:${RST}"
slow "    1. Poll ${MAG}/proc/\$pid/net/tcp${RST} + netstat deltas — no root, ~1Hz resolution."
slow "    2. ${MAG}bpftrace${RST} via a pre-signed setuid binary — ns granularity, one-time setup."
slow "    3. Launch process in a net-namespace + tcpdump pipe — heavier, fully isolated."
slow ""
slow "  ${BOLD}Recommend:${RST} #1. Zero privilege, trivial to ship, fine for most monitoring."
slow ""
slow "  ${DIM}Your call?${RST}"
sleep 1.2
slow ""
slow "${GRN}✓ reframe delivered — constraint named, 3 options, 1 recommendation${RST}"
sleep 1
