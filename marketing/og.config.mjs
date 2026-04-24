// marketing/og.config.mjs — configuration for the og-card skill.
//
// Edit these fields, then run:
//   ${CLAUDE_PLUGIN_ROOT}/skills/og-card/scripts/render.sh marketing/og.config.mjs
//
// Output lands at `assets/og.png` (1200×630, the standard social-preview size
// used by Twitter / Slack / iMessage / LinkedIn / GitHub's social-preview slot).

export default {
  name: "never-say-never",
  label: "Claude plugin",
  taglineLine1: "Never say never.",
  taglineLine2: "",
  subtitle: "Stop hook that catches \"can't\" in Claude's replies and forces a high-agency reframe.",
  footer: "github.com/codyhxyz/never-say-never",
  theme: "dark",
  accent: "#f97316",
};
