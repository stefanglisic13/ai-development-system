---
description: Independently review a feature phase for correctness and scope without modifying files.
argument-hint: <feature-name> [phase-<number>]
context: fork
---

# Review Scope

Review the feature phase named with this command for correctness and scope. Do not modify source files, documentation, dependencies, or git state.

This review runs in a forked context without the implementation conversation. Judge the diff and the document, not the implementer's explanation.

Read:

- the project context required by the project-context rule;
- `.ai/features/<feature-name>/FEATURE.md`, including the phase baseline, `Verification`, and `Deviations`;
- `git status --short`, the staged and unstaged diffs, relevant untracked files, and the commits since the baseline.

Separate changes that existed before the baseline from the phase under review. If the baseline or attribution is unclear, say so; do not blame unrelated changes on the feature or recommend deleting them.

Run the affected app's typecheck, lint, and build from `.ai/STACK.md` yourself when they are available and have no side effects. Report a check as passed only if you ran it.

Return short bullets under these headings, writing `None` where there are no findings:

## Correctness

Findings with file and line: acceptance criteria not met, broken contracts, missing access checks, wrong state transitions, lost errors, failed checks. Check behavior even when every changed file was planned. No stylistic preferences.

## Scope

- Recorded deviations: accept the small adjacent ones; flag any that needed approval (dependency, schema, API contract, architecture or structure, product behavior).
- Unrecorded work: files, dependencies, tests, abstractions, refactors, validation, or fallbacks that are neither planned nor recorded.

## Standards

Conflicts with `.ai/STRUCTURE.md`, `.ai/STACK.md`, relevant ADRs, and the applicable framework standard.

## Recommendation

One of `Ready`, `Needs correctness correction`, `Needs scope correction`, or `Needs developer decision`, with the smallest correction required. `Ready` requires the phase's completion check and its checks to pass; state any verification you could not perform.
