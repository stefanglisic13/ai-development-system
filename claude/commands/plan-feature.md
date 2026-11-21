---
description: Plan a feature and its implementation phases in one document, without writing code.
argument-hint: <feature-name> [description]
---

# Plan Feature

Plan the feature named with this command. Do not write application code, install dependencies, or create implementation files.

Read the project context required by the project-context rule, then the existing code of similar features.

Create or update `.ai/features/<feature-name>/FEATURE.md` from `.ai/templates/FEATURE.md`, with a kebab-case feature name and `Status: Draft`. The one document holds both the feature definition and its implementation plan:

- goal, requirements, and non-goals;
- the technical approach, including the patterns and ADRs it follows and any API or data changes;
- new dependencies, database changes, and new abstractions, each as a list or `None`;
- decisions, each with a status;
- ordered phases, each with its files, the change to each file, and a completion check;
- the checks to run.

Size the plan to the feature: a small feature has one phase, and no phase exists only to fill the template. List files from the code you read, including manifests, lockfiles, config, and generated output where they change.

For a product or architecture choice that has not been made, record it as `Open`, present 2–3 options with short tradeoffs, and wait. Do not choose it yourself.

Finish with a short summary of the approach and the `Open` decisions. Set `Status: Approved (<name>, YYYY-MM-DD)` only after the developer approves the document.
