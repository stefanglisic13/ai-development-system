# Plan Feature

Plan the requested feature. Do not write application code, install dependencies, refactor, or create implementation files.

First follow `01-project-context.mdc` to load applicable canonical standards, then read:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- `.ai/CURRENT.md`
- relevant ADRs
- similar existing code and the relevant feature modules.

Create or update `.ai/features/<feature-name>/FEATURE.md` using `.ai/templates/FEATURE.md`. Use a kebab-case feature name. Save as Draft while decisions are being reviewed.

Resolve `Requested by` and `Requested on` under `01-project-context.mdc`'s Documentation Identity rule. Keep request attribution separate from later approval attribution.

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
