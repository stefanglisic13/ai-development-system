# Implement Feature

Implement only the requested phase of an approved feature plan.

Before coding, read:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- relevant ADRs
- `.ai/features/<feature-name>/FEATURE.md`
- `.ai/features/<feature-name>/PLAN.md`
- existing similar code.

If the feature or implementation plan is not approved, or the requested phase is ambiguous, do not code. Explain what is missing and wait for approval.

During implementation:

- implement only the requested phase;
- follow the approved files, new files, architecture, stack, and patterns;
- do not redesign the solution;
- do not add dependencies, tests, refactors, abstractions, validations, or fallback behavior that are not in the approved plan;
- keep business flow clear and local;
- run only relevant existing validation commands when appropriate and available.

If implementation requires any deviation, stop before editing beyond the approved scope. Report why, the smallest required change, and affected files or decisions. Wait for approval.

At the end, summarize changed files, checks run, and any remaining work. Update `.ai/CURRENT.md` and the feature plan only to reflect actual completed work.
