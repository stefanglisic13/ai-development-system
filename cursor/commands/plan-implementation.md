# Plan Implementation

Create an implementation plan for an approved feature. Do not write application code, install dependencies, refactor, or create implementation files.

First follow `01-project-context.mdc` to load applicable standards, then read the approved feature document, relevant `.ai/` project documentation, related ADRs, and existing similar code.

If the feature is not approved or has unresolved blocking questions, stop and explain what approval is required.

Create or update `.ai/features/<feature-name>/PLAN.md` using `.ai/templates/PLAN.md`. Keep approval separate from progress, and reference the approved feature revision. Do not mark your own proposed plan approved.

The plan must:

- state exact implementation scope and explicit exclusions;
- restate relevant architectural constraints and existing patterns;
- list every new dependency, abstraction, database change, and new file, or `None`;
- divide implementation into small ordered phases;
- list exact files and precise changes for each phase;
- list only required verification steps; tests are not automatic;
- include the deviation rule requiring approval before any unplanned change.

Use only as many phases as the feature needs. Include manifest/lockfile, config, generated/scaffold files, and documentation changes in the file list when needed. A scaffold phase may specify an exact destination and expected generator output that must be inspected before acceptance; it does not authorize rewriting unrelated files. Add phase completion criteria and exact available verification commands.

Do not redesign the feature. If the approved feature document is insufficient, report the smallest missing decision and wait for approval.
