# Project Context Rules

Project documentation in `.ai/` is the source of truth for project-specific decisions.

## Required Standard Loading

Before planning, editing, or reviewing, determine the affected app from the request and the app paths recorded in `STACK.md`/`STRUCTURE.md`. Read the installed canonical standards for that scope:

- all work: `.ai/standards/core/core-development.md`;
- TypeScript: `.ai/standards/frameworks/typescript.md`;
- React web: `.ai/standards/frameworks/react.md`;
- React Native/Expo: shared sections of `react.md` plus `.ai/standards/frameworks/react-native.md`, which overrides web-only behavior;
- NestJS: `.ai/standards/frameworks/nestjs.md`.

These reads are required even if no framework rule is loaded or no source files exist yet. During project planning, inspect the installed standards and user request to establish the app map. Do not apply web `Container` styling to native `.tsx` files. If a needed standard is absent, report the missing installation instead of claiming to have followed it.

## Authority and Approval

Follow the explicit developer request, approved project decisions/ADRs, applicable framework standard, then core defaults. Preserve existing compatible patterns; ask only about unresolved material conflicts. Templates and reference repositories are evidence, not approval.

Draft documents may be written during planning. Mark them approved only after explicit approval of that revision in the conversation; record a short approval reference. Approval remains valid during implementation and is not lost when progress changes to `In Progress`. A material change to scope, architecture, or dependencies requires renewed approval of the changed portion.

For small explicitly requested fixes or documentation edits, work within that request without creating a feature lifecycle. Use the full workflow for new features or material architecture changes. Do not demand a feature plan for read-only questions.

Before planning or implementing work, read the relevant files:

- `.ai/PROJECT.md` for product scope and non-goals;
- `.ai/ARCHITECTURE.md` for system boundaries and technical decisions;
- `.ai/STRUCTURE.md` for required folders, files, and naming;
- `.ai/STACK.md` for approved technologies and dependency choices;
- `.ai/CURRENT.md` for active work and temporary constraints;
- relevant `.ai/decisions/ADR-*.md` files;
- relevant `.ai/features/<feature>/FEATURE.md` and `PLAN.md` files.

Treat approved documentation as binding. Do not redesign approved architecture during implementation.

## Documentation Identity

When creating or updating a request or approval record, resolve the person's display name in this order:

1. a name explicitly provided in the current conversation;
2. the non-empty result of `git config --get user.name`, run from the project root;
3. `Unknown` if neither is available.

Use that name in `Requested by` and `Approved by` fields. Git identity is a convenience for attribution, not evidence of approval: mark a document approved only after an explicit approval message. Do not use `git log` to infer the requester or approver, because an earlier commit may belong to someone else. Do not record the Git email address unless the developer explicitly requests it. When Git supplied the name, append ` (from Git config)` so the source is clear. Do not rewrite historical records merely because the current Git identity differs.

If documentation is missing, `/plan-project` may create drafts from installed templates and repository evidence. Mark unknowns `TBD` and absent applications `Not applicable`. Only unresolved decisions that affect the requested implementation block coding; unrelated blank sections do not.

When implementation follows an approved feature plan:

- implement only the requested phase;
- change only the files and create only the files listed in the plan;
- install only dependencies explicitly approved in the plan; include manifest and lockfile changes in the planned files;
- do not add tests, refactors, or abstractions not explicitly approved;
- stop and request approval if the plan must change.

Phase progress and verification updates to its `PLAN.md` and `.ai/CURRENT.md` are authorized bookkeeping; do not alter approved scope or decisions while updating progress.
