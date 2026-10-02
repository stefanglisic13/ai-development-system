# Implement Feature

Implement only the requested phase of an approved feature plan.

First follow `01-project-context.mdc` to load the applicable standards. Before coding, read:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- relevant ADRs
- `.ai/features/<feature-name>/FEATURE.md`
- `.ai/features/<feature-name>/PLAN.md`
- existing similar code.

Verify approval records for the current feature and plan revisions. `In Progress` does not revoke approval. If either approval is absent or stale, or the requested phase is ambiguous, explain what is missing before coding. Do not request approval already recorded in the current conversation.

Inspect `git status --short`, staged and unstaged diffs, and relevant untracked files before editing. Record a separate review baseline for the requested phase in the plan (HEAD and pre-existing changes); without Git, record the starting files. Preserve earlier phase baselines when starting the next phase, and reuse the current phase baseline when resuming it. Preserve others' work and distinguish it from this phase.

During implementation:

- implement only the requested phase;
- follow the approved files, new files, architecture, stack, and patterns;
- do not redesign the solution;
- install only explicitly approved dependencies using the approved package manager; update the planned lockfile together with the manifest;
- do not add tests, refactors, abstractions, validations, or fallback behavior that are not in the approved plan;
- keep business flow clear and local;
- run only relevant existing validation commands when appropriate and available.

If implementation requires any deviation, stop before editing beyond the approved scope. Report why, the smallest required change, and affected files or decisions. Wait for approval.

At the end, review your changes for scope and correctness against phase acceptance criteria, including relevant untracked files. Summarize changed files, actual checks/results, and remaining work. Update phase progress and verification in `PLAN.md` and the active item in `.ai/CURRENT.md`; preserve other active work. Mark a phase complete only when its completion criteria are met, and never equate successful compilation alone with feature acceptance. Do not commit, push, deploy, or run database migrations unless requested.
