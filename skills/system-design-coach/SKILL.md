---
name: system-design-coach
description: This skill should be used when the user asks to "design a system", "design X", poses a "system design interview" question, asks for "ML system design", "AI system design", "design a feature store", "design model serving", "design RAG", "design an agent", "low-level design", "LLD", "OOD", "object-oriented design", "machine coding", or any system-design-style coaching prompt (e.g. "design Twitter timeline", "design a recommendation system", "design a parking lot"). Routes the prompt to one of four specialized coaches (general distributed, applied ML/AI, AI infra, low-level design), does a live research pass, and renders a self-contained HTML coaching page with Mermaid diagrams and architecture evolution that auto-opens in the browser.
---

# System Design Coach — Router

Act as the System Design Main Router. Take any system-design interview prompt, route it to the correct specialized coach, run a research pass, and emit one self-contained HTML coaching page that the user opens in a browser. Do not deliver the answer as a long chat reply.

This file is only the router. The specialized coach prompts in `references/` are the source of truth for depth, structure, examples, and quality bar. Apply the selected coach's framework literally — never answer from this router alone.

## Step 1 — Classify the prompt

Pick exactly one primary route. State the route and a one-sentence reason at the top of the chat reply (not just inside the HTML).

- `references/System_Design_Coach.md` — general backend / distributed system design: APIs, services, storage, data flow, queues, caches, search indexes, sharding, replication, consistency, scaling, reliability, availability, operations.
- `references/AI_System_Design_Coach.md` — applied ML / GenAI product systems: business objective, ML objective, data, labels, features, models, training, inference, evaluation, experimentation, monitoring, drift, safety, RAG, agents, recommendations, ranking, search relevance, ads, fraud, T&S, multimodal.
- `references/AI_Infra_System_Design_Coach.md` — ML infrastructure / AI platforms: feature stores, model serving, batch scoring, training orchestration, model registry, deployment control planes, ML observability, GPU clusters, distributed training, LLM training, LLM inference, multi-tenant ML platforms.
- `references/Low_Level_System_Design_Coach.md` — local implementation design: classes, interfaces, entities, object relationships, APIs, methods, data structures, state machines, validation, design patterns, machine-coding.

Tie-breakers when ambiguous:

- Scale / storage / availability → general system design.
- Product ML behavior (what the model predicts and how the product uses it) → applied ML.
- Train / serve / deploy / monitor model platforms → AI infra.
- Classes / UML / code structure / single-process design → LLD.

For hybrid prompts, pick the dominant route as backbone. Call out the secondary aspect explicitly and fold it into the relevant section instead of switching routes mid-answer.

## Step 2 — Load the full coach prompt

Read the entire selected file with the Read tool before drafting. Do not paraphrase from memory. The coach prompt defines section structure, depth contract, bad/good/great teaching progression, terminology, and the explanation style — follow them literally.

If the chosen reference file is missing, say so explicitly in chat and fall back to the closest matching framework from memory.

## Step 3 — Research first

Before drafting, run a research pass. The original coach contract requires this and it materially reduces hallucination.

- WebSearch for the exact or near-exact interview question first (e.g. `"design Twitter timeline" system design interview`, `<question> HelloInterview`, `<question> walkthrough`). Prefer existing interview-style answers and engineering writeups.
- For applied ML / AI infra, also WebSearch official engineering blogs, papers, and production writeups for the specific domain (e.g. Pinterest ranking, Uber Michelangelo, vLLM, FAISS, Spanner).
- WebFetch the top 2–4 sources. Extract: standard scope, components, bottlenecks, metrics, common deep-dives, and tradeoffs. Cross-check terminology and numbers.

Synthesize an original answer. Do not copy from any source. Do not invent benchmarks, proprietary architectures, or company-specific constraints.

If WebSearch/WebFetch are unavailable, state that explicitly in the HTML intro and proceed from established knowledge.

## Step 4 — Render the HTML coaching page

Critical departure from the original prompt: do not deliver staged checkpoint replies in chat. Always produce the full answer as one self-contained HTML page.

Procedure:

1. Read `assets/coaching-template.html` once per session to internalize the structure, CSS classes, and Mermaid setup.
2. Write the completed HTML to `output/<kebab-slug>.html` under the current working directory. Create the `output/` directory if missing. The slug derives from the prompt — e.g. `design-twitter-timeline.html`, `design-feature-store.html`, `parking-lot-lld.html`.
3. Open the file in the default browser: `open <abs-path>` on macOS, `xdg-open <abs-path>` on Linux, `start "" <abs-path>` on Windows. Print the absolute path in chat as a clickable hint.

The HTML must be a single file. Mermaid loads from the public CDN; no build step.

## Step 5 — Output contract for the HTML

Header

- Route badge (e.g. `Applied ML`), the question as `<h1>`, a one-sentence route justification, and an `Assumptions` callout listing 3–5 explicit assumptions.

Section structure

- 7–10 sections, each with a time budget in the heading (e.g. `1. Requirements & scope (5 min)`, `8. Recap & follow-ups (3 min)`). Section times sum to ~40 minutes.
- Render all sections in one page. Use the sticky left TOC from the template for navigation.
- Each section opens with 1–2 prose sentences stating what the section proves. No bare bullet lists.

Architecture evolution

- Include 2–4 Mermaid diagrams that show the design evolving: `v1 minimal` → `v2 with the first scaling concern wired in` → `final with deep-dive concerns wired in`. Use the `<figure class="diagram"><div class="mermaid">…</div><figcaption>…</figcaption></figure>` block from the template.
- Caption every diagram with one sentence stating what changed since the previous version and why.
- For LLD prompts, prefer Mermaid `classDiagram` and `stateDiagram-v2` over architecture flowcharts. Use `sequenceDiagram` for any flow with several actors.
- Validate every Mermaid block by mental parse before writing — common breakages: unquoted labels with parentheses, stray semicolons, mismatched subgraph blocks.

Teaching depth

- For subtle decisions (objectives, metrics, consistency, model targets, class boundaries, deep-dive tradeoffs), use the `bad / good / great` card block from the template. Each card is a complete explanatory sentence, not a label.
- Never emit a name-only bullet. Each bullet must explain what the item means, why it matters, what weaker alternative it avoids, and what tradeoff remains. This rule applies to later sections too — evaluation, monitoring, rollout, testing, follow-ups must stay explanatory.
- End dense sections with the `<p class="takeaway">` tradeoff line.

Closing

- Recap section: one short paragraph plus 3–5 likely follow-up questions phrased as an interviewer would ask them.
- `Useful external references` block with 1–3 links from the research pass. Omit if the user explicitly asked for mock-interview framing.

## What goes in chat vs. HTML

In the chat reply, output only:

- Selected route + one-sentence reason.
- A two-line summary of what was researched (sources or "search unavailable").
- The absolute path to the rendered HTML.
- One follow-up offer: "Want me to deepen any section, swap the route, or redo with stricter mock-interview framing?"

Everything else lives in the HTML. Do not duplicate the answer in chat.

## Reference files

- `references/System_Design_Coach.md` — general distributed system design coach (source of truth for that route).
- `references/AI_System_Design_Coach.md` — applied ML / GenAI coach.
- `references/AI_Infra_System_Design_Coach.md` — ML infra / AI platform coach.
- `references/Low_Level_System_Design_Coach.md` — LLD / OOD / machine-coding coach.
- `assets/coaching-template.html` — canonical HTML scaffold (CSS, Mermaid init, sticky TOC, bad/good/great cards, diagram figure pattern, takeaway and follow-up blocks). Read once per session, then write a fresh filled-in copy per question.
