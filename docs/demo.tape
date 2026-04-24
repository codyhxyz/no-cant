# VHS tape for never-say-never hero demo.
# Render: ${CLAUDE_PLUGIN_ROOT}/scripts/record-demo.sh <plugin-path>
# Or directly: vhs docs/demo.tape

Output docs/hero.gif

Set Theme "Dracula"
Set FontSize 15
Set Width 1180
Set Height 680
Set Padding 24
Set TypingSpeed 0ms
Set PlaybackSpeed 1.0

Hide
Type "clear"
Enter 1
Show
Sleep 400ms

Type "bash docs/demo.sh"
Enter 1
Sleep 11s
