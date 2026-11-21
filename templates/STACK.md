# Stack

Status: Draft

<!-- Status: Draft | Approved (<name>, YYYY-MM-DD). Never infer approval from filled sections. -->

## Application Map

<!-- List each actual app root and framework: e.g. apps/web → React web, apps/mobile → React Native/Expo, apps/api → NestJS. Examples are not architecture decisions. For a single app use its actual root. -->

TBD

## Local Commands

<!-- Package manager, lockfile, and runtime version, then one line per command for each app: install, dev, typecheck, lint, build, test. Typecheck, lint, and build run after every change. Note autofix or external-service side effects. Mark a missing command `Unavailable`; never invent scripts. -->

## Backend

<!-- Framework, language, ORM, database, validation, authentication, logging, storage, and other approved backend technology. -->

## Web

<!-- Framework, routing, state, server-state, forms, validation, styling, and approved UI technology. -->

## Mobile

<!-- Expo/React Native version, routing, state, server-state, forms, validation, and styling. Remove this section if no mobile app exists. -->

## Infrastructure

<!-- Hosting, database provider, storage, monitoring, CI/CD, and other platform services. -->

## Approved Dependencies

<!-- List important approved packages and why the project uses each one. -->

## Chosen Alternatives

<!-- Record selected technology and alternatives that must not be introduced without an explicit architecture change.

Example:
- Server state: TanStack Query. Do not introduce RTK Query or SWR.
- Web styling: styled-components. Do not introduce Tailwind or CSS Modules.
- Mobile styling: StyleSheet. Do not introduce NativeWind or styled-components.
-->

## Enforced by Tooling

<!-- Rules checked by a tool instead of text, one line each: `<rule> — <tool and config file>`. Candidates: the prohibited alternatives above through ESLint `no-restricted-imports` (built in, no plugin); import boundaries between features and layers; file naming (needs a lint plugin, which is a dependency to approve); TypeScript `strict`; package installs through agent permissions. Do not restate an enforced rule elsewhere in `.ai/`. -->

## Dependency Policy

New dependencies require developer approval. Before proposing one, verify that the approved stack or an existing dependency does not already solve the problem.

Approval in an approved feature document counts; do not request the same approval again. Framework defaults describe the proposed stack, not permission to install every listed library.
