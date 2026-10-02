# Project Structure

Status: Draft

Revision: 1

Approved revision: Not approved

Approval reference:

## Purpose

This document is the source of truth for repository structure. New code must follow it. Do not invent new folders, layers, or naming patterns without an approved architecture change.

## Repository Tree

<!-- Replace with the approved high-level tree. Do not create apps/, packages/, or example files just because they appear in a template. src/ is relative to each app root. Remove unused application sections. -->

```text
project/
├── .ai/
├── .cursor/
└── <approved application locations>
```

## Backend Feature Structure

<!-- Define the canonical NestJS feature structure used by every backend module. -->

```text
users/
├── dto/
│   └── users.dto.ts
├── entities/
│   └── user.entity.ts
├── users.controller.ts
├── users.module.ts
└── users.service.ts
```

## React Feature Structure

<!-- Define the canonical web feature structure under the web app's src/features/. Names below describe roles, not a command to generate unused hook/component files. -->

```text
users/
├── api/
├── components/
├── hooks/
├── types/
└── users-page.tsx
```

## React Native Feature Structure

<!-- Define the canonical mobile feature structure under the mobile app's src/features/. Remove this section if no mobile app exists. -->

```text
users/
├── api/
├── components/
├── hooks/
├── types/
└── users-screen.tsx
```

## Shared Code

<!-- Define the permitted shared locations and exactly what may be promoted there. -->

## Naming Rules

<!-- Record names that differ from the global standard, if any. -->

## Forbidden Structures

<!-- List folders, layers, or patterns that must not be introduced in this project. -->
