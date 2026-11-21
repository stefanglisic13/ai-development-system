# Project Context

`.ai/` holds this project's decisions. Approved documents are binding: do not redesign approved architecture during implementation. Templates and reference repositories are evidence, not approval.

## What to Read

Before planning, editing, or reviewing, find the affected app in `.ai/STACK.md` and read what the task touches:

- `.ai/STACK.md` for the app map, approved technology, and check commands;
- `.ai/STRUCTURE.md` for folders, files, and naming;
- `.ai/ARCHITECTURE.md` and `.ai/PROJECT.md` when the task touches boundaries, data, or product scope;
- `.ai/CURRENT.md`, relevant `.ai/decisions/ADR-*.md`, and the feature document;
- the framework standard for that app, in full, even before source files exist:
  - TypeScript: `.ai/standards/frameworks/typescript.md`;
  - React web: `.ai/standards/frameworks/react.md`;
  - React Native/Expo: the shared sections of `react.md`, then `.ai/standards/frameworks/react-native.md`, which overrides web-only behavior;
  - NestJS: `.ai/standards/frameworks/nestjs.md`.

File extension does not determine the framework; the app map does. If a needed standard is not installed, say so instead of claiming to have followed it.

## Workflow

- Small explicit fix, documentation edit, or question: do it directly, with no feature document.
- New feature or material architecture change: `/plan-feature`, developer approval, `/implement-feature` per phase, `/review-scope`.
- Missing project documentation: `/plan-project` drafts it. Mark unknowns `TBD`. Only an unresolved decision that affects the requested work blocks coding.

## Approval

- Drafts may be written during planning. Set `Status: Approved (<name>, YYYY-MM-DD)` only after the developer explicitly approves the document in the conversation. Filled sections and resolved decisions are not approval.
- Approval stays valid during implementation. A material change to scope, architecture, dependencies, or data needs approval of the changed part.
- `<name>` is the name given in the conversation, otherwise `git config --get user.name`.

## Implementing an Approved Feature

- Implement only the requested phase, following the document's approach and file list.
- The file list is a plan, not a fence. When the phase cannot work without a small adjacent change (another call site, a type, a config entry, a file the plan missed), make it and record it as one line under `Deviations`.
- Stop and ask before a change that was not approved and is one of: a new dependency, a database schema or migration change, a new or changed API contract, a change to architecture or folder structure, or different product behavior or scope.
- A phase is complete only when its checks pass (see the core standard, Tests and Verification). Record each check as one line under `Verification`.
- Updating phase status, `Verification`, `Deviations`, and `.ai/CURRENT.md` is bookkeeping and needs no approval.

## Documentation Style

Write `.ai/` documents and end-of-task summaries for a developer who needs the facts fast:

- bullets and short fragments, not prose; one fact per line;
- state what changes and what was decided, not background, reasoning narratives, or restated requirements;
- no filler and no repetition across sections or documents; link instead of copying;
- delete sections that do not apply; write `None` only where a template asks for it;
- record outcomes, not conversation: never quote or paraphrase what someone said or wrote.

Record each decision as one line with a formal status:

```text
- <decision> — Open
- <decision> — Confirmed (<name>, YYYY-MM-DD)
- <new decision> — Changed (<name>, YYYY-MM-DD; was: <previous decision>)
- <decision> — Rejected (<name>, YYYY-MM-DD)
```

## Tooling Over Prose

A convention that lint, typecheck, or agent permissions can check belongs in that tool, where it is enforced on every change. When you find such a convention kept only as text, propose the tool configuration as a decision. Rules listed under `Enforced by Tooling` in `.ai/STACK.md` are not restated elsewhere in `.ai/`.
