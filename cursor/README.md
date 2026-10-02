# Cursor Adapter

Use `scripts/init-project.sh` from the system repository. Copying only this directory is insufficient: the adapters require full standards and templates under `.ai/`.

## Installed Context

- `.ai/standards/core/core-development.md`: canonical core.
- `.ai/standards/frameworks/`: selected framework standards.
- `.ai/templates/`: all planning templates.
- `.ai/PROJECT.md`, `ARCHITECTURE.md`, `STRUCTURE.md`, `STACK.md`, `CURRENT.md`: project-owned context.
- `.ai/features/` and `.ai/decisions/`: feature plans and decisions.

## Rule Loading

`00-core.mdc` and `01-project-context.mdc` always apply. The latter requires reading relevant standards based on the app map and task, including when planning a new app with no source files.

Framework adapters are context pointers, not duplicate rule sets:

- `10-typescript.mdc`: TypeScript.
- `20-react.mdc`: web React only.
- `21-react-native.mdc`: React Native/Expo, with shared React principles.
- `30-nestjs.mdc`: NestJS backend only.

Framework adapters have descriptions for relevance-based loading. Do not use a global `**/*.tsx` web rule in a mixed web/mobile repo: extension alone cannot distinguish the two. The always-applied context router requires the appropriate document reads whether or not a framework adapter is selected.

In `STACK.md`, record each app's framework and root path. Native overrides web markup and styling. Keep full standards authoritative instead of adding another summary to these adapters.

## Commands

The installed Markdown files expose `/plan-project`, `/plan-feature`, `/plan-implementation`, `/implement-feature`, and `/review-scope`.

Approval comes from explicit developer messages and is recorded by revision, separately from progress. Planning can write drafts; implementation may install already-approved dependencies; review does not mutate files.

See the main README for the workflow and preservation-based upgrade instructions.

Format references: [Cursor rules](https://cursor.com/docs/rules) and [Cursor commands](https://docs.cursor.com/en/agent/chat/commands).
