# Stack

Status: Draft

Revision: 1

Approved revision: Not approved

Approval reference:

## Application Map

<!-- List each actual app root and framework: e.g. apps/web → React web, apps/mobile → React Native/Expo, apps/api → NestJS. Examples are not architecture decisions. For a single app use its actual root. -->

TBD

## Local Commands

<!-- Record the existing/approved package manager, version, lockfile, runtime version, and exact commands per app: install, dev, typecheck, build, lint, existing tests. Note autofix or external-service side effects. Mark unavailable commands as unavailable; never invent scripts. -->

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

## Dependency Policy

New dependencies require developer approval. Before proposing one, verify that the approved stack or an existing dependency does not already solve the problem.

Approval in a feature/implementation plan counts; do not request the same approval again. Framework defaults describe the proposed stack, not permission to install every listed library.
