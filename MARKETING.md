# Marketing copy for no-cant

<!--
  Drafted in Phase 5.5 per the create-claude-plugin marketing rubric.
  Ship by copy-pasting; edit freely before you do.
-->

## Launch tweet

shipped no-cant — a Claude Code plugin that catches "I can't do that" in Claude's replies and forces a 4-move reframe: name the constraint, list what IS possible, surface tradeoffs, recommend one.

chief-of-staff posture, not refusal posture.

`/plugin install no-cant@codyhxyz-plugins`

🙅 by @you

## Alt tweets

- Tired of Claude saying "I can't"? Same. So I wrote a Stop hook that greps for it and blocks the turn until Claude reframes into options + tradeoffs + a recommendation. One hook, one skill, self-contained. github.com/codyhxyz/no-cant

- "Can't" is almost never true impossibility. It's "the naive approach failed" or "the tool's not there." no-cant (new Claude Code plugin) intercepts those replies and makes Claude name the actual constraint + propose adjacent moves. github.com/codyhxyz/no-cant

- new Claude plugin: no-cant. Stop hook scans the last assistant turn for can't/cannot → emits block → Claude reinvokes a bundled reframe skill. Four moves: constraint, options, tradeoffs, recommendation. 150 lines total. github.com/codyhxyz/no-cant

<!--
  OG card (1200×630 social-preview for Twitter / Slack / iMessage / LinkedIn):

  Run the `og-card` skill to generate one. It interviews you for tagline /
  subtitle / accent / theme, writes marketing/og.config.mjs, and rasterizes
  assets/og.png via @resvg/resvg-js. Ask Claude:

      "make an og card for this plugin"

  After rendering, upload assets/og.png manually at:
      https://github.com/codyhxyz/no-cant/settings → Social preview → Edit
  (GitHub has no API for this slot.)
-->
