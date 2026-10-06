# Claude Code Adapter

Install with `scripts/init-project.sh <project> ... --claude`. Copying only this directory is insufficient: the adapters require full standards and templates under `.ai/`.

## Installed Context

- `.ai/standards/core/core-development.md`: canonical core.
- `.ai/standards/frameworks/`: selected framework standards.
- `.ai/templates/`: all planning templates.
- `.ai/PROJECT.md`, `ARCHITECTURE.md`, `STRUCTURE.md`, `STACK.md`, `CURRENT.md`: project-owned context.
- `.ai/features/` and `.ai/decisions/`: feature plans and decisions.
- `.claude/rules/`: project rules loaded by Claude Code.
- `.claude/commands/`: workflow slash commands.

## Rule Loading

Claude Code loads every Markdown file in `.claude/rules/` as project memory at session start, alongside any `CLAUDE.md`. The rules have no `paths` frontmatter, so all installed rules apply unconditionally. The initializer does not create or modify `CLAUDE.md`; keep project-specific notes there if you use one.

`00-core.md` and `01-project-context.md` are always installed. Framework rules are installed only for the selected stack and are context pointers, not duplicate rule sets:

- `10-typescript.md`: TypeScript.
- `20-react.md`: web React only.
- `21-react-native.md`: React Native/Expo, with shared React principles.
- `30-nestjs.md`: NestJS backend only.

Claude Code has no description-based rule selection like Cursor. Each framework rule states which app it applies to, and `01-project-context.md` routes the agent to the correct full standard using the app map in `STACK.md`. Keep full standards authoritative instead of adding another summary to these adapters.

Run `/memory` in Claude Code to confirm which rule files are loaded.

## Commands

The installed Markdown files expose `/plan-project`, `/plan-feature`, `/plan-implementation`, `/implement-feature`, and `/review-scope`. Arguments are passed through `$ARGUMENTS`, for example `/implement-feature user-login phase-1`.

Approval comes from explicit developer messages and is recorded by revision, separately from progress. Planning can write drafts; implementation may install already-approved dependencies; review does not mutate files.

## Keeping Adapters in Sync

Rule and command bodies mirror `cursor/` apart from frontmatter, rule file references, and the arguments line. When changing one adapter, apply the same change to the other.

See the main README for the workflow and preservation-based upgrade instructions.

Format references: [Claude Code memory](https://docs.claude.com/en/docs/claude-code/memory) and [Claude Code slash commands](https://docs.claude.com/en/docs/claude-code/slash-commands).
