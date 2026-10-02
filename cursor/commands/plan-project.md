# Plan Project

Create or update the project planning documentation. Do not write application code, install dependencies, or make architecture changes in source files.

First follow `01-project-context.mdc` to load the canonical standards, inspect the current repository, and read existing `.ai/` documentation. Reuse decisions already made in the conversation. Then determine which of these are missing or unresolved:

1. product goal, users, scope, and non-goals;
2. applications and system boundaries;
3. approved stack and dependency choices;
4. authentication, authorization, data, storage, and external services;
5. canonical folder and file structures;
6. error handling, logging, testing, deployment, and environment strategy.

For every material decision that is not known, present 2–3 reasonable options with concise tradeoffs and wait for developer approval. Do not choose the architecture independently.

Create or update reviewable drafts of only these project documents as needed, recording unresolved decisions as `TBD`:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- `.ai/CURRENT.md`
- `.ai/decisions/ADR-<number>-<title>.md` for accepted architecture decisions

Use `.ai/templates/`. Never treat example folders or packages as approved selections. Record each app's root path and framework in `STACK.md`, including monorepo boundaries, and record verified package-manager and validation commands. Remove irrelevant example sections.

For project and ADR attribution fields, resolve the name under `01-project-context.mdc`'s Documentation Identity rule. A Git-derived name identifies the request record only; it never substitutes for explicit approval.

Summarize scope, stack, structure, and blocking questions. Mark documents approved only after explicit developer approval of the presented revision. Do not bootstrap application code during this command.
