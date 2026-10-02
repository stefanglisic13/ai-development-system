# Cursor Adapter

This directory contains the Cursor-specific adapter for this development system.

When initializing a concrete project, copy its contents into the project's `.cursor/` directory:

```text
project/
├── .cursor/
│   ├── commands/
│   └── rules/
└── .ai/
    ├── ARCHITECTURE.md
    ├── CURRENT.md
    ├── PROJECT.md
    ├── STACK.md
    ├── STRUCTURE.md
    ├── decisions/
    └── features/
```

Copy only the framework rules that apply to the project:

- `10-typescript.mdc` for TypeScript projects;
- `20-react.mdc` for React web projects;
- `21-react-native.mdc` for React Native and Expo projects;
- `30-nestjs.mdc` for NestJS projects.

`00-core.mdc` and `01-project-context.mdc` belong in every initialized project.

The command files become `/plan-project`, `/plan-feature`, `/plan-implementation`, `/implement-feature`, and `/review-scope` in Cursor chat.
