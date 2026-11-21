---
description: Create or update the project planning documentation in .ai/.
argument-hint: [notes]
---

# Plan Project

Create or update the project documentation in `.ai/`. Do not write application code, install dependencies, or change source files.

Read the installed standards, the repository, and the existing `.ai/` documents. Reuse decisions already made in the conversation. Then find what is missing or undecided:

1. product goal, users, scope, and non-goals;
2. applications and system boundaries;
3. stack and dependency choices;
4. authentication, authorization, data, storage, and external services;
5. folder and file structure;
6. error handling, logging, deployment, and environments;
7. testing policy: what is tested, with which tool, and by which command, or explicitly `None`;
8. check commands per app: typecheck, lint, build, and existing tests.

For each undecided material choice, present 2–3 options with short tradeoffs and wait. Do not choose the architecture yourself.

For each convention a tool can check (prohibited alternative libraries, import boundaries between features and layers, file naming, TypeScript strictness), propose enforcing it with the project's linter or compiler configuration instead of documenting it as text. Record the outcome under `Enforced by Tooling` in `STACK.md`. Applying the configuration is a separate implementation task, and a lint plugin is a dependency that needs approval.

Write drafts of only the documents that need a change, from `.ai/templates/`, marking undecided items `TBD`:

- `.ai/PROJECT.md`, `.ai/ARCHITECTURE.md`, `.ai/STRUCTURE.md`, `.ai/STACK.md`, `.ai/CURRENT.md`;
- `.ai/decisions/ADR-<number>-<title>.md` for an accepted architecture decision that needs its alternatives recorded.

Record each app's root path and framework in `STACK.md`, and only check commands you verified exist. Delete template sections and example folders that do not apply; an example is never an approved choice.

Finish with a few bullets: scope, stack, structure, and `Open` decisions. Set `Status: Approved (<name>, YYYY-MM-DD)` on a document only after the developer approves it.
