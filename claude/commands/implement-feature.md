---
description: Implement one phase of an approved feature document.
argument-hint: <feature-name> [phase-<number>]
---

# Implement Feature

Implement the phase named with this command. If no phase is named, implement the next phase that is not done.

Read the project context required by the project-context rule, `.ai/features/<feature-name>/FEATURE.md`, and the existing code of similar features.

Before editing:

- Confirm the document says `Status: Approved`. If it does not, or the phase is ambiguous, say what is missing and stop. Do not ask again for approval already given in this conversation.
- Inspect `git status --short` and the staged and unstaged diffs. Record the phase baseline in the document once and do not overwrite it when resuming.

Implement under the rules in the project-context rule, Implementing an Approved Feature: follow the plan, make small adjacent deviations and record them, stop for the listed material changes.

When the code is written:

1. Run typecheck, lint, and build for the affected app with the commands in `.ai/STACK.md`, plus existing tests that cover the change and the checks listed in the document.
2. Fix failures caused by this phase and run the checks again. Report failures that existed before the phase; do not fix them here.
3. Review your own diff against the phase's completion check and the feature's acceptance criteria. A build that compiles is not acceptance.
4. Update the phase status, `Verification`, and `Deviations` in the document, and the item in `.ai/CURRENT.md`.

Mark the phase `Done` only when its checks pass. If a check cannot run, record `Not run` with the reason and leave the phase `In progress`.

Finish with a short summary: changed files, check results, deviations, remaining work. Do not commit, push, deploy, or run database migrations unless asked.
