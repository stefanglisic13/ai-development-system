# Plan Implementation

Create an implementation plan for an approved feature. Do not write application code, install dependencies, refactor, or create implementation files.

First read the approved feature document, relevant `.ai/` project documentation, related ADRs, and existing similar code.

If the feature is not approved or has unresolved blocking questions, stop and explain what approval is required.

Create or update `.ai/features/<feature-name>/PLAN.md` using the approved template.

The plan must:

- state exact implementation scope and explicit exclusions;
- restate relevant architectural constraints and existing patterns;
- list every new dependency, abstraction, database change, and new file, or `None`;
- divide implementation into small ordered phases;
- list exact files and precise changes for each phase;
- list only required verification steps; tests are not automatic;
- include the deviation rule requiring approval before any unplanned change.

Do not redesign the feature. If the approved feature document is insufficient, report the smallest missing decision and wait for approval.
