#!/usr/bin/env bash
# Stop hook: scans last assistant turn for "can't" / "cannot" / "can not".
# If found, blocks stop and instructs Claude to invoke the reframe skill
# to shift from constraint thinking to chief-of-staff problem-solving.
#
# This hook does not loop: it exits clean when stop_hook_active=true.

set -u

input=$(cat)

# Avoid re-firing within the same stop cycle.
active=$(printf '%s' "$input" | jq -r '.stop_hook_active // false')
[ "$active" = "true" ] && exit 0

transcript=$(printf '%s' "$input" | jq -r '.transcript_path // ""')
[ -z "$transcript" ] && exit 0
[ ! -f "$transcript" ] && exit 0

# Extract last assistant message's text-content, concatenated.
last_text=$(jq -rs '
  map(select(.type == "assistant"))
  | last
  | (.message.content // [])
  | map(select(.type == "text") | .text)
  | join(" ")
' < "$transcript" 2>/dev/null)

[ -z "$last_text" ] && exit 0

# Match can't / cant / cannot / can not (case-insensitive, word-boundary-ish).
# Excludes intra-word matches (e.g. "scanty" won't trigger on "cant").
if printf '%s' "$last_text" | grep -qiE "(^|[^[:alnum:]])(can'?t|cannot|can not)([^[:alnum:]]|$)"; then
    jq -n '{
      decision: "block",
      reason: "Detected \"can'\''t\" / \"cannot\" in your reply. Invoke the never-say-never:reframe skill via the Skill tool to reframe the constraint as a chief-of-staff would — identify what IS possible, propose concrete alternatives with tradeoffs, then continue. Do not simply restate the refusal."
    }'
    exit 0
fi

exit 0
