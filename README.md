# AI Development System

Reusable development standards, project documentation templates, and Cursor and Claude Code workflows for building applications with AI assistance.

The system separates four concerns:

1. **Global standards** — how AI should write and reason about code.
2. **Framework standards** — conventions for TypeScript, React, React Native/Expo, and NestJS.
3. **Project context** — product scope, architecture, stack, structure, decisions, and current state inside each project.
4. **Feature workflow** — planning, approval, implementation, and scope review as separate steps.

The goal is predictable, linear development: no speculative abstractions, unnecessary files, unapproved dependencies, automatic tests, or out-of-scope refactoring.

## Repository Structure

```text
ai-development-system/
├── core/
│   └── core-development.md
├── frameworks/
│   ├── typescript.md
│   ├── react.md
│   ├── react-native.md
│   └── nestjs.md
├── templates/
│   ├── PROJECT.md
│   ├── ARCHITECTURE.md
│   ├── STRUCTURE.md
│   ├── STACK.md
│   ├── ADR.md
│   ├── FEATURE.md
│   ├── PLAN.md
│   └── CURRENT.md
├── cursor/
│   ├── rules/
│   └── commands/
├── claude/
│   ├── rules/
│   └── commands/
└── scripts/
    └── init-project.sh
```

## Use in a New Project

Initialize a concrete project with the setup script, then commit the generated context and agent configuration with its source code:

```sh
./scripts/init-project.sh ../my-app --typescript --react --nestjs            # Cursor
./scripts/init-project.sh ../my-app --typescript --react --nestjs --claude   # Claude Code
./scripts/init-project.sh ../my-app --typescript --react --cursor --claude   # both
```

Available stack options are `--typescript`, `--react`, `--react-native`, and `--nestjs`. Agent options are `--cursor` and `--claude`; without either, only the Cursor adapter is installed. Both adapters can be installed together and share the same `.ai/` context. The script never overwrites an existing file.

For an Expo app use `--typescript --react-native`; for a full monorepo include all applicable frameworks. Framework paths are resolved within each app, so record the app roots during `/plan-project`. The script installs documentation only: it does not install dependencies or scaffold apps. Use an existing project directory; managed destination symlinks are rejected before writing.

The generated project structure is:

```text
project/
├── .ai/
│   ├── PROJECT.md
│   ├── ARCHITECTURE.md
│   ├── STRUCTURE.md
│   ├── STACK.md
│   ├── CURRENT.md
│   ├── decisions/
│   ├── features/
│   ├── templates/       # all templates, including project planning
│   └── standards/       # full core and selected framework standards
├── .cursor/             # with --cursor or by default
│   ├── rules/
│   └── commands/
└── .claude/             # with --claude
    ├── rules/
    └── commands/
```

Every installed adapter receives the core rules `00-core` and `01-project-context`, then only the framework rules used by that project: `10-typescript`, `20-react`, `21-react-native`, `30-nestjs`. Cursor rules use `.mdc`; Claude Code rules use `.md`.

See [cursor/README.md](./cursor/README.md) and [claude/README.md](./claude/README.md) for the adapter structure.

## How Context Is Loaded

`core/` and `frameworks/` are the canonical standards. Initialization copies them into `.ai/standards/`; Cursor and Claude Code rules route the agent to these full documents. There is no separately maintained framework summary to drift out of sync. Native installations include React's shared principles while native styling and navigation override web rules.

The always-applied context rule selects relevant standards using the app map and the task, including planning before code exists. Precedence is: explicit developer request, approved project decisions, applicable framework standard, core defaults. Existing compatible code patterns remain relevant; conflicts are surfaced rather than silently migrated.

Cursor selects framework rules by description; Claude Code loads every installed `.claude/rules/` file at session start, so only the selected framework rules are installed.

Rules and slash commands are prompt instructions, not a technical guarantee of compliance. Review the resulting code and the rules the agent shows as applied (in Claude Code, `/memory`). Sources: [Cursor rules](https://cursor.com/docs/rules), [Claude Code memory](https://docs.claude.com/en/docs/claude-code/memory).

## Workflow

### 1. Plan the project

Run `/plan-project` in Cursor or Claude Code.

The command creates or updates the project source of truth:

- product scope and non-goals;
- architecture and decisions;
- approved stack;
- canonical folder structure;
- active work state.

It writes reviewable drafts using `.ai/templates/`, asks about unresolved material decisions, then records explicit approval of the presented revision. Placeholder content is never treated as an approved architecture. Approved project documents and `STACK.md` list the app map, dependencies, and actual validation commands.

### 2. Plan a feature

Run `/plan-feature <feature-name>`.

This produces `.ai/features/<feature-name>/FEATURE.md` with requirements, non-goals, expected file changes, allowed new files, dependencies, and open questions.

Approve the feature before implementation planning.

### 3. Plan implementation

Run `/plan-implementation <feature-name>`.

This produces `PLAN.md`, broken into explicit phases with exact files and changes. It records new dependencies, new abstractions, database changes, and new files as either a concrete list or `None`.

Approve the plan before coding.

### 4. Implement one approved phase

Run `/implement-feature <feature-name> phase-<number>`.

The agent must read project context, the approved feature, and the plan. It may install dependencies already explicitly approved there, using the planned manifest and lockfile changes. It may not redesign the solution, add unplanned files or dependencies, refactor unrelated code, or add tests automatically. Approval and implementation progress are separate: `In Progress` does not require reapproval of unchanged scope.

### 5. Review scope

Run `/review-scope <feature-name>` before committing.

The command checks scope and correctness against the recorded phase baseline, including staged, unstaged, untracked, and already committed phase changes. It distinguishes pre-existing changes and verifies acceptance criteria; approved filenames alone do not establish correctness.

For small explicit fixes or documentation edits, a direct task is sufficient. Do not create FEATURE/PLAN files mechanically for every change.

## Documentation Roles

| Document | Purpose |
| --- | --- |
| `PROJECT.md` | Product goal, scope, users, and non-goals. |
| `ARCHITECTURE.md` | System boundaries, data flow, infrastructure, logging, and architectural constraints. |
| `STRUCTURE.md` | Exact repository and feature folder patterns. |
| `STACK.md` | Approved technology choices and prohibited alternatives. |
| `ADR-*.md` | Accepted architecture decisions and rejected alternatives. |
| `FEATURE.md` | The definition and approved approach for one feature. |
| `PLAN.md` | The approved, phased implementation plan for one feature. |
| `CURRENT.md` | Compact record of active work, next work, and relevant temporary context. |

## Rules of Authority

| Mode | May write code? | May decide architecture? | May add files? | May add dependencies? |
| --- | --- | --- | --- | --- |
| `/plan-project` | No | Proposes only | Documentation only | Proposes only |
| `/plan-feature` | No | Proposes only | Documentation only | Proposes only |
| `/plan-implementation` | No | No redesign | Documentation only | No |
| `/implement-feature` | Yes | No | Only approved files and progress bookkeeping | Only explicitly approved |
| `/review-scope` | No | No | No | No |

## Update an Existing Installation

Rerunning the initializer fills missing files and reports differing files without overwriting them. It is not an automatic upgrade command.

Review `.ai/standards/` against this repo's `core/` and selected `frameworks/`, `.cursor/` against `cursor/rules/` and `cursor/commands/`, and `.claude/` against `claude/rules/` and `claude/commands/`. To add Claude Code to an existing Cursor installation, rerun the initializer with the same stack options plus `--claude`. Apply the desired changes together and inspect the diff. Keep project-specific scope, decisions, feature plans, approval history, and local customizations. `.ai/templates/` may be updated independently of already-filled project documents.

For installations created before full standards were copied, rerun initialization first, then review and replace the old summarized Cursor rules with the current context adapters. Without updating `01-project-context.mdc`, old projects will not require loading the full standards.

## Verification of This System

Run `bash -n scripts/init-project.sh` and `git diff --check`. Smoke-check initialization in a temporary directory for a single backend, a native app, and a mixed monorepo, with the default adapter, `--claude`, and `--cursor --claude`. Re-run to confirm idempotence and preservation of custom files; invalid arguments or destination collisions must fail before creating files.

These checks verify file delivery and instruction consistency. Actual agent compliance still needs a real Cursor and Claude Code feature run. No dependency installation, application build, or deployment is performed by the initializer.

## Current Standards

- [Core Development Standard](./core/core-development.md)
- [TypeScript Standard](./frameworks/typescript.md)
- [React Standard](./frameworks/react.md)
- [React Native and Expo Standard](./frameworks/react-native.md)
- [NestJS Standard](./frameworks/nestjs.md)
