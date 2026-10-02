# Plan Project

Create or update the project planning documentation. Do not write application code, install dependencies, or make architecture changes in source files.

First inspect the current repository and read any existing `.ai/` documentation. Then determine which of these are missing or unresolved:

1. product goal, users, scope, and non-goals;
2. applications and system boundaries;
3. approved stack and dependency choices;
4. authentication, authorization, data, storage, and external services;
5. canonical folder and file structures;
6. error handling, logging, testing, deployment, and environment strategy.

For every material decision that is not known, present 2–3 reasonable options with concise tradeoffs and wait for developer approval. Do not choose the architecture independently.

After approval, create or update only these project documents as needed:

- `.ai/PROJECT.md`
- `.ai/ARCHITECTURE.md`
- `.ai/STRUCTURE.md`
- `.ai/STACK.md`
- `.ai/CURRENT.md`
- `.ai/decisions/ADR-<number>-<title>.md` for accepted architecture decisions

Use the repository's approved templates. Clearly mark unresolved decisions. Summarize the final project scope, chosen stack, canonical structure, and remaining open questions.
