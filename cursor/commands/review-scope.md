# Review Scope

Review the current git diff against the approved feature and implementation plan. Do not modify source files, documentation, dependencies, or git state.

Read:

- `.ai/features/<feature-name>/FEATURE.md`
- `.ai/features/<feature-name>/PLAN.md`
- relevant `.ai/` project documentation and ADRs;
- the current git diff and changed-file list.

Return a concise scope review with these sections:

## Scope Compliance

State whether the diff implements only the requested plan phase.

## Files

Compare expected changed files and new files with actual files. List unexpected files and explain why each is out of scope or requires review.

## Unplanned Work

Identify unplanned dependencies, tests, abstractions, refactors, validation, fallbacks, schema changes, and global changes.

## Architecture and Pattern Compliance

Check the diff against `.ai/STRUCTURE.md`, `.ai/STACK.md`, relevant ADRs, and the applicable framework rules.

## Recommendation

Give one of: `Ready`, `Needs scope correction`, or `Needs developer decision`.

Do not edit the diff. Be specific about the smallest necessary correction.
