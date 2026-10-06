---
description: Review a feature phase diff for scope and correctness without modifying files.
argument-hint: <feature-name> [phase-<number>]
---

# Review Scope

Feature and phase: $ARGUMENTS

Review both scope and correctness of the requested feature/phase. Do not modify source files, documentation, dependencies, or git state. Load applicable canonical standards through `.claude/rules/01-project-context.md` first.

Read:

- `.ai/features/<feature-name>/FEATURE.md`
- `.ai/features/<feature-name>/PLAN.md`
- relevant `.ai/` project documentation and ADRs;
- the plan's baseline and phase, `git status --short`, staged and unstaged diffs, and relevant untracked file contents;
- changes since the recorded baseline if phase work has already been committed.

Distinguish pre-existing unrelated changes from the phase under review. An empty unstaged diff is not proof of completion. If attribution or the baseline is unclear, state that limit; do not blame unrelated changes on this feature or recommend deleting them.

Return a concise scope review with these sections:

## Scope Compliance

State whether the diff implements only the requested plan phase.

## Files

Compare expected changed files and new files with actual files. List unexpected files and explain why each is out of scope or requires review.

## Unplanned Work

Identify unplanned dependencies, tests, abstractions, refactors, validation, fallbacks, schema changes, and global changes.

## Architecture and Pattern Compliance

Check the diff against `.ai/STRUCTURE.md`, `.ai/STACK.md`, relevant ADRs, and the applicable framework rules.

## Correctness

First report actionable correctness findings with file/line evidence: acceptance criteria, contracts, access checks, state transitions, error handling, and executed verification. Check implementation behavior even when all changed filenames are approved. Do not invent findings for stylistic preferences or claim checks were run if they were only inspected.

## Recommendation

Give one of: `Ready`, `Needs scope correction`, `Needs correctness correction`, or `Needs developer decision`.

Use `Needs correctness correction` when behavior is wrong even though scope is correct. `Ready` requires the reviewed phase criteria and required checks to be satisfied; disclose any remaining verification limitation.

Do not edit the diff. Be specific about the smallest necessary correction.
