#!/usr/bin/env bash
# Stop hook: scans last assistant turn for "can't" / "cannot" / "can not".
# If found, blocks stop and instructs Claude to invoke the reframe skill
# to shift from constraint thinking to chief-of-staff problem-solving.
#
# Code/quote-aware: strips fenced code blocks, inline code spans, and
# blockquote lines before matching, so meta-references to the word
# inside ` or ``` or > don't false-trigger.
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

# Extract last assistant message's text-content, concatenated (raw, with newlines preserved).
last_text=$(jq -rs '
  map(select(.type == "assistant"))
  | last
  | (.message.content // [])
  | map(select(.type == "text") | .text)
  | join("\n")
' < "$transcript" 2>/dev/null)

[ -z "$last_text" ] && exit 0

# Strip markdown contexts where the model is almost always *referencing*
# the word rather than refusing:
#   1. Fenced code blocks (```...```), including indented fences.
#   2. Inline code spans (`...`).
#   3. Blockquote lines (lines starting with optional whitespace then `>`).
# Also strip single-quoted string literals and double-quoted phrases that
# are explicitly about the word (e.g. \"can't\" in a description).
cleaned=$(printf '%s' "$last_text" | awk '
    BEGIN { in_fence = 0 }
    /^[[:space:]]*```/ { in_fence = !in_fence; next }
    in_fence { next }
    /^[[:space:]]*>/ { next }
    { print }
' | sed -E '
    s/`[^`]*`//g
    s/"[^"]*"//g
    s/'\''[^'\'']*'\''//g
')

[ -z "$cleaned" ] && exit 0

# Match can't / cant / cannot / can not (case-insensitive, word-boundary-ish).
# Excludes intra-word matches (e.g. "scanty" does not trigger on "cant").
if printf '%s' "$cleaned" | grep -qiE "(^|[^[:alnum:]])(can'?t|cannot|can not)([^[:alnum:]]|$)"; then
    jq -n '{
      decision: "block",
      reason: "Detected \"can'\''t\" / \"cannot\" in your reply (outside code/quoted contexts). Invoke the high-agency-mode:reframe skill via the Skill tool to reframe the constraint as a chief-of-staff would — identify what IS possible, propose concrete alternatives with tradeoffs, then continue. Do not simply restate the refusal."
    }'
    exit 0
fi

exit 0
