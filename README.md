# AI Development System

Reusable development standards, project documentation templates, and Cursor workflows for building applications with AI assistance.

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
└── cursor/
    ├── rules/
    └── commands/
```

## Use in a New Project

Initialize a concrete project with the setup script, then commit the generated context and Cursor configuration with its source code:

```sh
./scripts/init-project.sh ../my-app --typescript --react --nestjs
```

Available stack options are `--typescript`, `--react`, `--react-native`, and `--nestjs`. The script never overwrites an existing file.

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
│   └── features/
└── .cursor/
    ├── rules/
    └── commands/
```

Every project receives these Cursor rules:

- `00-core.mdc`
- `01-project-context.mdc`

Then add only the framework rules used by that project:

- `10-typescript.mdc`
- `20-react.mdc`
- `21-react-native.mdc`
- `30-nestjs.mdc`

See [cursor/README.md](./cursor/README.md) for the adapter structure.

## Workflow

### 1. Plan the project

Run `/plan-project` in Cursor.

The command creates or updates the project source of truth:

- product scope and non-goals;
- architecture and decisions;
- approved stack;
- canonical folder structure;
- active work state.

It must request approval for unresolved material decisions rather than choosing them independently.

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

The agent must read project context, the approved feature, and the plan. It may not redesign the solution, add unplanned files or dependencies, refactor unrelated code, or add tests automatically.

### 5. Review scope

Run `/review-scope <feature-name>` before committing.

The command compares the current git diff to the approved feature and plan, highlighting unexpected files, unplanned work, architecture violations, and possible overengineering.

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
| `/implement-feature` | Yes | No | Only approved files | No |
| `/review-scope` | No | No | No | No |

## Current Standards

- [Core Development Standard](./core/core-development.md)
- [TypeScript Standard](./frameworks/typescript.md)
- [React Standard](./frameworks/react.md)
- [React Native and Expo Standard](./frameworks/react-native.md)
- [NestJS Standard](./frameworks/nestjs.md)
