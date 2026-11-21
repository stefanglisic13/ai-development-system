# Core Development Standard

Write the simplest code that completely satisfies the current request. A developer must be able to follow a feature's whole execution flow by reading it top to bottom, without jumping between helpers, layers, and files. Every rule below serves that goal.

Precedence: the developer's explicit request, approved project decisions in `.ai/`, the applicable framework standard, then this standard. Examples and unfilled templates are not decisions.

## Scope

- Change only what the request needs. Refactors, renames, cleanups, and reorganizations of unrelated code make the diff harder to review and are separate tasks.
- Report a problem you notice outside the scope; do not fix it.
- A small adjacent change the request cannot work without (an import, a type, a call site, a config entry) is part of the request. Make it and name it in the summary.
- Preserve changes already in the working tree. Never remove someone else's work to make a diff match a plan.

## Structure

- Follow the project's existing structure and patterns, even where a generic best practice differs. A codebase is predictable only when equivalent things look the same; a better pattern in one feature makes the whole harder to read. If an existing pattern conflicts with the request, report the conflict instead of migrating silently.
- Equivalent features have the same files with the same roles, named after the feature in kebab-case: `auth.service.ts`, not `authentication-user-login-processing.service.ts`. The folder is part of the name. Framework-required names such as `_layout.tsx` stay.
- Create a file when the project structure expects it, the responsibility is genuinely separate, or the code has several real usages. Do not create one to make another file shorter: files and functions have no size limit, and one long linear function reads better than many small ones spread across the codebase.
- In a monorepo, apply each framework standard only to its own app. `src/` is relative to that app's root.

## Logic and Abstractions

- Keep feature logic inside the feature, in the order it runs: what comes in, what is checked, what is calculated, what is stored, what is returned. Nobody should open several files to learn how one value is computed.
- Extract a shared helper only for real reuse, such as date or currency formatting and shared parsing. Logic used in one place stays in that place.
- Add a base class, generic service or repository, factory, adapter, wrapper, strategy, or extra layer only when the architecture already requires it or a concrete current use exists. An abstraction built for a hypothetical future costs readability today and usually guesses that future wrong.
- Backend: linear and explicit. Global mechanisms are for cross-cutting concerns only (authentication and authorization guards, middleware, interceptors, logging).
- Frontend: reuse presentation more freely (layouts, shared UI, hooks, form components) when it simplifies the component tree. Feature code holds the feature-specific logic and configuration.

```ts
async createBooking(input: CreateBookingDto) {
  const hotel = await this.findHotel(input.hotelId);

  if (!hotel) {
    throw new NotFoundException('Hotel not found');
  }

  if (hotel.capacity - hotel.reservedRooms < input.rooms) {
    throw new BadRequestException('Not enough available rooms');
  }

  const booking = await this.bookingRepository.save({
    ...input,
    totalPrice: input.rooms * hotel.pricePerRoom,
  });

  return { id: booking.id, totalPrice: booking.totalPrice } satisfies BookingResponseDto;
}
```

## Failures and Validation

- Handle failures that can realistically happen. A guard or fallback for a state the application contract rules out hides bugs and buries the real flow. If you are unsure whether a case can occur, ask.
- Always keep validation of untrusted input at the boundary, authorization, and the integrity checks the feature requires. TypeScript types do not validate external data.
- Handle an error where the code can add context, translate it, recover, or compensate, close to the operation that failed, so the reader sees what can fail and what is returned. Preserve the known status and the original cause; never turn a failure into a success or a blanket `500`. One layer logs each failure.
- Use the framework's errors. Add a custom error class only for a concrete benefit.

## TypeScript

- Prefer explicit, simple types. Entities, API responses, request payloads, and domain models are always typed. Use enums for finite domains.
- A property is optional only when it is optional in the business model or API contract, never to silence a compiler error.
- Use generics, conditional types, and mapped types only for a concrete problem. `any` is acceptable for an isolated value that cannot reasonably be typed, never for entities or API responses.

## Comments

Comment the business meaning, a non-obvious calculation, or why an unusual implementation exists. Do not narrate what the code already says.

## Dependencies

A new dependency needs the developer's approval, because each one is a long-term maintenance and security cost. First check whether an existing dependency or a reasonable amount of plain code solves the problem, then explain the benefit and wait. Approval already given in the conversation or in an approved feature document counts; do not ask twice. Install with the project's package manager and update its lockfile.

## Tests and Verification

- Tests follow the project's testing policy in `.ai/ARCHITECTURE.md`. Where no policy is recorded, write tests only when requested or planned, and say so when a change is risky enough to deserve one.
- Verification is part of every change. Run the affected app's typecheck, lint, and build from `.ai/STACK.md`, plus existing tests that cover the change. Fix the failures you caused. Report failures that existed before and checks that could not run. Never state that a check passed when it was not run.
- Read a command before running it. Avoid commands that autofix unrelated files, call external services, or change data.

## Decisions

Product and architecture decisions belong to the developer. When the work needs one that has not been made (a new dependency, layer, global abstraction, folder structure, infrastructure choice, schema change outside the scope, or unusual defensive behavior), give 2–3 options with short tradeoffs and wait. Routine implementation details inside the approved scope need no approval.

When unsure between a sophisticated and a simple solution, choose the simple one. When unsure whether to add something, do not add it.
