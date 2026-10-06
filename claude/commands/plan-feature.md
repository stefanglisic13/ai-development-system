---
description: Plan a feature in .ai/features/<feature-name>/FEATURE.md without writing code.
argument-hint: <feature-name> [description]
---

# Plan Feature

Feature and request: $ARGUMENTS

Plan the requested feature. Do not write application code, install dependencies, refactor, or create implementation files.

First follow `.claude/rules/01-project-context.md` to load applicable canonical standards, then read:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- `.ai/CURRENT.md`
- relevant ADRs
- similar existing code and the relevant feature modules.

Create or update `.ai/features/<feature-name>/FEATURE.md` using `.ai/templates/FEATURE.md`. Use a kebab-case feature name. Save as Draft while decisions are being reviewed.

Resolve `Requested by` and `Requested on` under `.claude/rules/01-project-context.md`'s Documentation Identity rule. Keep request attribution separate from later approval attribution.

The feature document must define:

- goal and user flow;
- concrete requirements and explicit non-goals;
- existing patterns and ADRs it must follow;
- approved architectural approach;
- API, database, storage, and integration changes;
- expected existing files to change;
- every expected new file and why it is needed;
- new dependencies, or `None`;
- acceptance criteria;
- open questions.

Do not make an undecided product or architectural decision. Present options and tradeoffs for missing choices. Resolved questions alone do not constitute approval: record explicit developer approval of the feature revision before marking it approved.
