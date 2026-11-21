# AI Development System

Development standards, project documentation templates, and Claude Code workflows for building applications with AI assistance.

The goal is predictable, linear code: no speculative abstractions, unnecessary files, unapproved dependencies, or out-of-scope refactoring, and every change verified before it is called done.

| Part | What it is |
| --- | --- |
| Core standard | How the agent writes code. Always loaded. |
| Framework standards | TypeScript, React, React Native/Expo, NestJS. Read for the affected app. |
| Project context | `.ai/`: scope, architecture, stack, structure, decisions, current state. |
| Workflow | Plan a feature, approve it, implement per phase with checks, review independently. |

## Repository Structure

```text
ai-development-system/
├── core/core-development.md   # core standard, installed as rule 00-core
├── frameworks/                # framework standards
├── claude/
│   ├── rules/                 # installed to .claude/rules/
│   ├── commands/              # installed to .claude/commands/
│   └── settings.json
├── templates/                 # .ai/ document templates
└── scripts/
    ├── init-project.sh
    └── install.sh
```

## Install

```sh
./scripts/init-project.sh ../my-app --typescript --react --nestjs
```

Without a local clone, from the project root:

```sh
curl -fsSL https://raw.githubusercontent.com/stefanglisic13/ai-development-system/main/scripts/install.sh \
  | bash -s -- --typescript --react
```

`AI_DEV_SYSTEM_REF` selects a branch or tag. For a private repository set `AI_DEV_SYSTEM_REPO` to the SSH URL and run a local copy of `install.sh`.

Stack options: `--typescript`, `--react`, `--react-native`, `--nestjs`. The script installs documentation and agent configuration only: no packages, no application code.

```text
project/
├── .ai/
│   ├── PROJECT.md  ARCHITECTURE.md  STRUCTURE.md  STACK.md  CURRENT.md
│   ├── decisions/
│   ├── features/<feature-name>/FEATURE.md
│   ├── templates/
│   └── standards/frameworks/
└── .claude/                   # rules/, commands/, settings.json
```

## Update

```sh
./scripts/init-project.sh ../my-app --update
```

`--update` detects the installed stack and overwrites system-owned files (rules, commands, `.ai/standards/`, `.ai/templates/`). It never overwrites project-owned files: `.ai/*.md`, `features/`, `decisions/`, and `.claude/settings.json`. Review the diff afterwards. Do not edit system-owned files in a project; change them here.

Without `--update`, existing files are preserved and differing ones are reported.

## Workflow

Small fixes, documentation edits, and questions need no document: ask for them directly.

| Step | Command | Result |
| --- | --- | --- |
| 1 | `/plan-project` | Drafts of the `.ai/` project documents; undecided choices presented as options. |
| 2 | `/plan-feature <name>` | One `FEATURE.md`: requirements, approach, decisions, and phases with files. No code. |
| 3 | Approve | `Status: Approved (<name>, date)`. |
| 4 | `/implement-feature <name> [phase-<n>]` | One phase, then typecheck, lint, and build. |
| 5 | `/review-scope <name> [phase-<n>]` | Correctness and scope review that does not modify files. |

What the workflow holds the agent to:

- **Decisions belong to the developer.** Undecided product or architecture choices come back as 2–3 options. Decisions are recorded as one line with a status (`Open`, `Confirmed`, `Changed`, `Rejected`), never as quoted conversation.
- **The plan is a plan, not a fence.** Small adjacent changes are made and recorded under `Deviations`. A new dependency, schema or migration change, API contract change, architecture or structure change, or different product behavior stops for approval.
- **A phase is done when its checks pass.** Typecheck, lint, and build run for every phase and are recorded as one line each. Tests follow the project's testing policy in `ARCHITECTURE.md`, decided during `/plan-project`.
- **Review is independent.** `/review-scope` runs in a forked context without the implementation conversation.
- **Documents are short.** Bullets, one fact per line, written for a developer, no repetition across documents.

## Enforcement

Rules and commands are prompt instructions, not guarantees. Whatever a tool can check should be checked by the tool:

- `.claude/settings.json` makes Claude Code ask for confirmation before package installs. It is project-owned after creation; extend it per project.
- `/plan-project` proposes lint and compiler enforcement for conventions that allow it: prohibited alternative libraries (ESLint `no-restricted-imports`), import boundaries between features and layers, file naming, TypeScript `strict`. Approved enforcement is listed under `Enforced by Tooling` in `STACK.md` and is not restated as text.
- Typecheck, lint, and build after every phase catch the rest.

## Changing This System

Every rule costs context on every task, and a long rule list is followed less reliably than a short one.

- Add a rule only after seeing the agent make that mistake in a real task. State the reason in the rule.
- Prefer a tool check to a rule when one is possible.
- Before keeping a larger change, run the same real feature through `/plan-feature` and `/implement-feature` in two worktrees of one project, one on the current version and one on the changed version. Compare: files changed outside the plan, stops for approval, failed checks, size of the generated documents, and how much you had to correct by hand.
- Remove a rule when the agent behaves the same without it.

Verify the scripts with `bash -n scripts/init-project.sh` and a run into a temporary directory: fresh install, rerun, and `--update` after changing a system file.

## Standards

- [Core](./core/core-development.md)
- [TypeScript](./frameworks/typescript.md)
- [React](./frameworks/react.md)
- [React Native and Expo](./frameworks/react-native.md)
- [NestJS](./frameworks/nestjs.md)
