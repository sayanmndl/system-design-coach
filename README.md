# system-design-coach

A Claude Code skill that turns any system-design interview prompt into a self-contained, interactive HTML coaching page — with the right specialized coach picked automatically, live research, architecture-evolution diagrams (Mermaid), and bad/good/great teaching blocks throughout.

## What it does

Ask anything like:

- "Design Twitter timeline"
- "Design a feature store for a 500-engineer ML org"
- "Design YouTube ranking"
- "Design vLLM-style LLM inference infra"
- "LLD a parking lot"

The skill:

1. **Routes** the prompt to one of four specialized coach prompts:
   - `System_Design_Coach.md` — general distributed / backend
   - `AI_System_Design_Coach.md` — applied ML, GenAI, RAG, ranking, agents
   - `AI_Infra_System_Design_Coach.md` — feature store, serving, training, GPU, LLM infra
   - `Low_Level_System_Design_Coach.md` — OOD / class design / machine coding
2. **Researches** the question via WebSearch + WebFetch (HelloInterview, eng blogs, papers) to reduce hallucination.
3. **Renders** a single self-contained HTML page (`output/<slug>.html`) with a sticky TOC, 7–10 timed sections summing to ~40 minutes, Mermaid architecture diagrams that *evolve* across versions, bad/good/great cards, and an interviewer follow-up block.
4. **Opens** the file in your default browser. The chat reply itself is only ~4 lines (route, what was researched, file path, follow-up offer) — the answer lives in the HTML.

## Install

**macOS / Linux:**

```bash
curl -fsSL https://raw.githubusercontent.com/sayanmndl/system-design-coach/main/install.sh | bash
```

**Windows (PowerShell):**

```powershell
iwr https://raw.githubusercontent.com/sayanmndl/system-design-coach/main/install.ps1 -UseBasicParsing | iex
```

Both installers fetch the latest `main`, extract just `skills/system-design-coach/`, and drop it into `~/.claude/skills/system-design-coach/`. An existing install is backed up to `<dest>.bak.<timestamp>` before being replaced.

Environment overrides (both scripts): `SDC_REPO`, `SDC_REF`, `SDC_DEST`.

### Manual install

If you'd rather not pipe to `bash`, clone and symlink:

```bash
git clone https://github.com/sayanmndl/system-design-coach.git
ln -s "$PWD/system-design-coach/skills/system-design-coach" ~/.claude/skills/system-design-coach
```

Or drop into a single project's `.claude/skills/`:

```bash
cp -r system-design-coach/skills/system-design-coach .claude/skills/
```

The skill auto-triggers on system-design-style phrasing — no slash command needed.

## Layout

```
skills/system-design-coach/
├── SKILL.md                     # router prompt — classify, load, research, render
├── references/
│   ├── System_Design_Coach.md           # general distributed coach
│   ├── AI_System_Design_Coach.md        # applied ML / GenAI coach
│   ├── AI_Infra_System_Design_Coach.md  # ML infra / AI platform coach
│   └── Low_Level_System_Design_Coach.md # LLD / OOD coach
└── assets/
    └── coaching-template.html   # canonical HTML scaffold (Mermaid, TOC, BGG cards)
```

## Why HTML instead of staged chat replies

The four underlying coach prompts use a "checkpointed 40-minute walkthrough" model — answer one section, wait for confirmation, then the next. That works in chat but loses the architecture-evolution story.

This skill collapses that into a single HTML page where:

- All 7–10 sections are visible at once with a sticky TOC for navigation.
- The architecture diagram literally *evolves* (`v1 → v2 → final`) with captions explaining what changed and why.
- Bad/good/great decisions are styled cards instead of bare bullets.
- Mermaid handles flowcharts, sequence diagrams, class diagrams, and state machines — all from a CDN, no build step.

## License

MIT — see `LICENSE`.
