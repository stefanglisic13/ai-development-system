# Core Development Standard

## 1. Primary Principle

Code should be simple, predictable, and easy to follow.

Prefer a straightforward implementation over a more abstract or theoretically more scalable one.

The developer must be able to understand the full execution flow without jumping unnecessarily between multiple files, abstractions, helpers, or layers.

Do not optimize for hypothetical future requirements.

Do not introduce complexity unless the current requirement clearly justifies it.

## 2. Scope Discipline

Always implement only what was explicitly requested.

Do not:

- refactor unrelated code;
- clean up unrelated files;
- rename unrelated variables;
- reorganize folders;
- introduce abstractions because they may be useful later;
- add tests unless explicitly requested;
- add extra validation for hypothetical cases;
- introduce dependencies without approval.

A feature implementation and a refactoring task are separate tasks.

If something outside the requested scope appears problematic, mention it separately instead of changing it.

## 3. Project Architecture

Every project should have a predictable and consistent architecture.

Equivalent feature folders should follow the same structure.

When entering any feature or module folder, the expected files and responsibilities should be immediately recognizable.

```text
auth/
├── auth.module.ts
├── auth.controller.ts
├── auth.service.ts
├── auth.types.ts
└── auth.dto.ts
```

Do not invent a different structure for individual features unless there is a concrete technical reason.

Architecture consistency has higher priority than introducing a theoretically better pattern for a single feature.

## 4. File Creation

Prefer the established file structure of the project.

Do not create a new file simply to make existing files smaller.

Large files are acceptable when all code belongs to the same context and the execution flow remains understandable.

A new file is justified when:

- the project architecture explicitly expects that file;
- the responsibility is genuinely separate;
- the implementation is sufficiently large or complex to obscure the main flow;
- a reusable concern has multiple real usages.

Do not split logic only because a file has many lines.

Functions or helpers that grow to several hundred lines and represent a distinct concern may be extracted.

File count should remain predictable across equivalent features.

## 5. Locality of Logic

Keep feature-specific logic close to where it is used.

Prefer:

```text
service
  → validation
  → calculation
  → database operation
  → result
```

Over:

```text
service
  → generic helper
  → abstraction
  → factory
  → utility
  → mapper
  → repository
  → result
```

When reading a backend service, the main business flow should be visible directly in that service.

Avoid forcing the developer to open several files simply to understand how a value is calculated.

## 6. Helpers and Utilities

Create shared helpers only when there is a real reuse case.

Good shared helper examples include:

- date formatting;
- currency formatting;
- common string formatting;
- reusable parsing;
- genuinely shared transformations.

Do not extract a calculation into a helper merely because it can technically be extracted.

If logic belongs specifically to one feature and is used in one place, keep it local to that feature.

Prefer readability of the complete execution flow over artificial reduction of file size.

## 7. Abstractions

Use abstractions conservatively.

Avoid introducing:

- base classes;
- generic repositories;
- generic services;
- factories;
- adapters;
- wrappers;
- strategy patterns;
- unnecessary interfaces;
- utility layers.

Only introduce them when there is an existing architectural requirement or a concrete current use case.

Do not create abstractions for hypothetical future reuse.

### Backend

Backend code should favor:

- linear execution;
- local business logic;
- explicit operations;
- easy traceability.

Global concerns are appropriate for:

- authentication guards;
- authorization guards;
- global middleware;
- global interceptors;
- logging infrastructure;
- shared infrastructure concerns.

Feature-specific business logic should usually remain within the feature.

Avoid excessive centralization because it makes the execution flow harder to trace.

### Frontend

Frontend code should reuse presentation and behavior more aggressively when React naturally benefits from it.

Reusable concepts may include:

- page templates;
- section templates;
- layouts;
- shared UI components;
- reusable hooks;
- wrappers;
- common form components.

Feature code should contain primarily the feature-specific logic and configuration.

Reuse should simplify the UI implementation, not make the component hierarchy difficult to understand.

## 8. Defensive Programming

Handle realistic failure cases.

Do not implement defensive checks for highly unlikely or impossible states unless explicitly approved.

Before adding unusual guards, ask whether that scenario is expected to occur.

Prefer:

```ts
if (!user) {
  throw new NotFoundException('User not found');
}
```

When the case is realistic.

Avoid chains of defensive checks created only because a value could theoretically be malformed despite the application contract guaranteeing otherwise.

Do not silently add fallback behavior for impossible states.

## 9. Error Handling

Handle errors close to the operation where they occur.

Prefer explicit `try/catch` blocks around meaningful processing boundaries when knowing where the operation failed is important.

Avoid unnecessarily propagating errors through many layers before handling them.

Error handling should make the failure location easy to identify.

A developer reading the relevant service should be able to understand:

- what operation can fail;
- where it is handled;
- what error is returned.

Do not create custom error classes unless they provide a concrete benefit.

Use existing framework errors where sufficient.

## 10. Dependencies

Never install or introduce a new dependency without explicit developer approval.

Before suggesting a dependency:

1. Check whether an existing dependency already solves the problem.
2. Check whether the implementation can reasonably be done without an additional dependency.
3. Explain why the dependency is beneficial.
4. Wait for approval before installing it.

Do not introduce competing libraries for functionality already covered by the existing stack.

## 11. TypeScript

TypeScript should improve clarity without introducing unnecessary complexity.

Prefer explicit, simple types.

Business entities, API responses, important request payloads, and domain models should always be typed.

```ts
type User = {
  id: string;
  email: string;
  status: UserStatus;
};
```

Enums are acceptable and encouraged where they clearly represent a finite domain.

Optional properties should only be optional when they are genuinely optional in the business model or API contract.

Do not mark fields optional simply to make TypeScript errors disappear.

Avoid excessive:

- generics;
- conditional types;
- mapped types;
- type-level abstractions.

Only use them when they solve a concrete problem.

`any` should not be the default, but it is acceptable for isolated cases where the value genuinely cannot be reasonably typed.

Never leave important entities or API responses as `any`.

Prefer understandable TypeScript over sophisticated TypeScript.

## 12. Comments

Code should primarily be self-explanatory.

Comments should explain business meaning rather than restating implementation details.

Good:

```ts
// Calculates how many seats remain available for the selected shift.
```

Bad:

```ts
// Subtract reserved seats from total seats.
const availableSeats = totalSeats - reservedSeats;
```

Use comments when they help explain:

- business rules;
- non-obvious calculations;
- product-specific behavior;
- why an unusual implementation exists.

Avoid comments that merely narrate the code.

## 13. Tests

Do not add tests unless they are explicitly requested.

Tests are not an automatic part of feature implementation.

Do not create:

- unit tests;
- integration tests;
- fixtures;
- test helpers;
- mocks.

Only create them when the task specifically includes testing.

If a change appears risky enough that testing should be considered, mention it separately rather than automatically implementing tests.

## 14. Naming

Use kebab-case for file names where applicable.

Files inside a feature should use the feature name as their base.

```text
auth/
├── auth.module.ts
├── auth.service.ts
├── auth.controller.ts
└── auth.types.ts
```

Prefer:

```text
auth.service.ts
```

Over:

```text
authentication-user-login-processing.service.ts
```

File names should communicate their role without trying to describe every internal responsibility.

Folder context is part of the file name's meaning.

## 15. Function and File Size

There is no arbitrary maximum size for functions or files.

Do not split code solely because:

- a function is long;
- a file has many lines;
- another style guide recommends smaller units.

Split code when doing so genuinely improves readability or separates an independent responsibility.

A larger linear function can be preferable to multiple small functions that force the reader to jump around the codebase.

Readability of the complete flow is more important than minimizing line count.

## 16. Implementation Style

Prefer linear code.

```ts
async createBooking(input: CreateBookingDto) {
  const hotel = await this.findHotel(input.hotelId);

  if (!hotel) {
    throw new NotFoundException('Hotel not found');
  }

  const availableRooms = hotel.capacity - hotel.reservedRooms;

  if (availableRooms < input.rooms) {
    throw new BadRequestException('Not enough available rooms');
  }

  const booking = this.bookingRepository.create({
    ...input,
    totalPrice: input.rooms * hotel.pricePerRoom,
  });

  return this.bookingRepository.save(booking);
}
```

Avoid unnecessarily transforming simple flows into multiple abstractions.

The main implementation should make it obvious:

- what comes in;
- what is checked;
- what is calculated;
- what is stored or changed;
- what is returned.

## 17. Decision Authority

Do not make architectural or product decisions independently.

When an implementation requires a decision that is not already defined:

1. Identify the decision.
2. Explain why it is needed.
3. Present reasonable options.
4. Describe relevant tradeoffs.
5. Wait for developer approval.

Do not silently select a solution.

This especially applies to:

- new dependencies;
- new architectural layers;
- changes to folder structure;
- new global abstractions;
- new infrastructure;
- unusual defensive handling;
- database schema changes outside the requested scope.

## 18. Existing Code Has Priority

Before implementing a feature, inspect similar existing features.

Follow the established project pattern unless explicitly instructed otherwise.

Do not replace existing architectural conventions with generic industry best practices.

Consistency within the project has priority.

If the existing architecture conflicts with the requested feature, explain the conflict instead of silently redesigning the architecture.

## 19. Overengineering Check

Before adding something, ask:

1. Is this required by the task?
2. Is this required by the existing architecture?
3. Is there a real current use case?
4. Does this make the execution flow easier to understand?
5. Would the feature still work correctly without it?

If the answer to the first three questions is no, do not add it.

Prefer the smallest implementation that completely satisfies the current requirement.

## 20. Final Implementation Rule

When uncertain between:

- a more sophisticated solution;
- a simpler solution that satisfies the requirement;

Choose the simpler solution.

When uncertain whether something should be added, do not add it.

When a decision belongs to the developer, ask or propose rather than deciding independently.
