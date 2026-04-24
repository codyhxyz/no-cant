<!-- auto:start — rewritten by scripts/sync-readme.sh from plugin.json; do not hand-edit between these markers -->
<h1 align="center">never-say-never</h1>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href=".claude-plugin/plugin.json"><img src="https://img.shields.io/github/package-json/v/codyhxyz/never-say-never?filename=.claude-plugin%2Fplugin.json&label=version" alt="Version"></a>
  <a href="https://claude.com/product/claude-code"><img src="https://img.shields.io/badge/built_for-Claude%20Code-d97706" alt="Built for Claude Code"></a>
</p>

<p align="center"><b>Catches "can't" in Claude's replies and forces a high-agency reframe.</b></p>

<p align="center">
  <img src="docs/hero.gif" alt="never-say-never demo" width="900">
</p>
<!-- auto:end -->

Claude reaching for "I can't do that" is almost always shorthand for *I don't have the tool*, *the user hasn't authorized this*, *the naive approach fails*, or *it's out of scope* — none of which are true impossibility. This plugin catches those replies before they land and forces a four-move reframe: name the actual constraint, list what IS possible, surface tradeoffs, recommend one. Chief-of-staff posture, not refusal posture.

## Quick Start

<!-- auto:start-install — rewritten by scripts/sync-readme.sh -->
### Option 1 — install from the codyhxyz-plugins marketplace *(recommended)*

```
/plugin marketplace add codyhxyz/codyhxyz-plugins
/plugin install never-say-never@codyhxyz-plugins
```

### Option 2 — install directly from this repo

```
/plugin marketplace add codyhxyz/never-say-never
/plugin install never-say-never@never-say-never
```

### Option 3 — local smoke test

```bash
git clone https://github.com/codyhxyz/never-say-never
claude --plugin-dir ./never-say-never
```
<!-- auto:end-install -->

## Try it — watch the hook fire

Ask Claude something it's likely to refuse on first instinct:

> "Write me a script that monitors the network traffic of a specific process without any privileged access."

> "Modify this read-only file."

> "Run a command that would take longer than the session timeout."

If Claude replies with "I can't…", the Stop hook intercepts, and the next turn reframes from the constraint side: what's the *mechanical* reason, what adjacent moves respect it, which one is recommended.

## Why never-say-never?

- **Forces forward progress.** "Can't" ends conversations; reframes continue them. The hook pushes Claude into options mode every time.
- **Catches it at the gate.** No need to notice the refusal yourself — the Stop hook reads the last assistant message and fires automatically.
- **Self-contained.** Bundles its own `reframe` skill; no dependency on any other plugin.
- **Narrow surface.** One hook + one skill. Uninstall in one command if it misfires on your workflow.

## How it works

On every `Stop` event, `hooks/detect-cant.sh` reads the transcript path from stdin, extracts the concatenated text of the last `type: "assistant"` message, and greps for word-bounded `can'?t` / `cannot` / `can not` (case-insensitive). On a match it emits `{"decision":"block","reason":"..."}` — Claude Code blocks the stop and feeds the reason back, instructing Claude to invoke `never-say-never:reframe` via the Skill tool before replying again. `stop_hook_active=true` is respected so the hook never loops.

## Examples

<details>
<summary><b>Example 1</b> — "I can't access files outside the workspace"</summary>

<br>

**Before (hook absent):** *"I can't read `~/secrets/api_keys.env` — it's outside my workspace."*

**After (hook fires):**

> **Constraint:** The sandbox policy prevents reads outside the current project root.
>
> **Options:**
> 1. Copy the needed keys into a `.env.local` inside the project — I read it, you delete it after. (Cost: temporary duplication.)
> 2. Export the values to env vars in your shell before launching Claude — I read via `env`. (Cost: session-scoped.)
> 3. Pass the keys inline in your prompt — I use them without writing to disk. (Cost: keys appear in transcript.)
>
> **Recommend:** #2 — no disk leak, no transcript leak, reversible.
>
> Your call?

</details>

<details>
<summary><b>Example 2</b> — "I can't parallelize this — the library isn't thread-safe"</summary>

<br>

**Before:** *"I can't speed this up — pandas isn't thread-safe."*

**After:**

> **Constraint:** The pandas operations you're chaining hold the GIL and block true threading.
>
> **Options:**
> 1. Switch to `multiprocessing.Pool` — bypasses GIL at the cost of IPC overhead (~100ms startup per worker).
> 2. Port the hot loop to `polars` — native parallelism, 10× faster here, requires rewriting ~40 lines.
> 3. Vectorize the two `.apply()` calls into native ops — no parallelism but 3× faster, 20-minute edit.
>
> **Recommend:** #3 first (cheapest verifiable win), then #2 if still too slow.
>
> Your call?

</details>

## Contributing

Issues and PRs welcome. See `.github/CONTRIBUTING.md`. If `never-say-never` misfires on valid refusals (genuine safety/legality constraints), file it with the transcript excerpt — that's a bug in the detection regex or the reframe guidance.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
