# Plan Feature

Plan the requested feature. Do not write application code, install dependencies, refactor, or create implementation files.

First read:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- `.ai/CURRENT.md`
- relevant ADRs
- similar existing code and the relevant feature modules.

Create or update `.ai/features/<feature-name>/FEATURE.md` using the approved template.

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

Do not make an undecided product or architectural decision. Present options and tradeoffs, then wait for developer approval. Do not mark the feature approved until all blocking questions are resolved.
