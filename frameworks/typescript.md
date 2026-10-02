# TypeScript Standard

This standard extends the Core Development Standard. It defines how TypeScript should be used in projects that follow this development system.

## Primary Principle

Use TypeScript to make business data, contracts, and application flows clear. Do not use sophisticated type-system features merely to make code look more generic or reusable.

Prefer simple, explicit types that make the code easy to read at the location where it is used.

## Type Declarations

Use `type` as the default way to declare application data shapes.

```ts
type User = {
  id: string;
  email: string;
  status: UserStatus;
};
```

Do not introduce interfaces by default. Use them only when a specific framework or library requires an interface, or when their extension behavior is concretely useful in the current code.

Do not create types simply because a value exists. Create a type when it describes an important business entity, API contract, request payload, response payload, or a repeated meaningful structure.

## Domain and API Contracts

Always type:

- business entities;
- API request payloads;
- API response payloads;
- important function inputs and outputs when inference does not clearly communicate the contract;
- data passed between application layers.

Do not leave important entities, API responses, or business payloads as `any`.

Use a dedicated response DTO or response type for API output. Do not return database entities directly, even when the current entity appears safe to expose.

The response contract should make public fields explicit and prevent accidental exposure when an entity later gains internal fields.

## Backend DTOs

Use classes for both request and response NestJS DTOs. Frontend contracts use `type`; do not require frontend code to import backend runtime decorators.

Request DTO classes should own input validation through the existing NestJS validation approach.

```ts
export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsEnum(UserStatus)
  status: UserStatus;
}
```

Create only the validation required by the endpoint contract and realistic input failures. Do not add speculative validation rules.

Response DTOs should expose only the fields that belong to the API contract.

```ts
export class UserResponseDto {
  id: string;
  email: string;
  status: UserStatus;
}
```

Do not create generic DTO mappers or serialization layers unless the project architecture already uses them or there is a concrete current need.

Keep simple mapping close to the service or controller where the response is produced.

## Enums

Use `enum` for finite, meaningful business domains such as statuses, roles, permissions, and lifecycle states.

```ts
export enum UserStatus {
  ACTIVE = 'ACTIVE',
  INACTIVE = 'INACTIVE',
}
```

Prefer enums over string unions for these domains so the intent is discoverable and the set of valid values has one clear home.

Do not introduce an enum for one-off values or values that do not represent a stable domain.

## Optionality and Nullability

Mark a property optional only when it is genuinely optional in the business model or API contract.

Do not use optional properties, `null`, or `undefined` to bypass an incomplete model or silence TypeScript errors.

Make absence explicit when it is a real state:

```ts
type UserProfile = {
  displayName: string;
  avatarUrl: string | null;
};
```

Use the convention already established by the project consistently. Do not mix `null` and `undefined` for the same kind of absence without a reason.

## Type Assertions

Avoid type assertions (`as`) by default.

Use an assertion only when TypeScript cannot reasonably infer information that is already guaranteed by a verified runtime contract, framework API, or controlled boundary.

Before using an assertion:

1. Prefer a correct type definition.
2. Prefer narrowing with a clear runtime check when the value is uncertain.
3. Keep the assertion local and as narrow as possible when it is unavoidable.

Never use `as` merely to silence an error, pretend uncertain data is valid, or bypass a missing type design.

Avoid double assertions such as `value as unknown as SomeType` unless explicitly approved.

`as const` for literal inference and `satisfies` for contract checking are allowed: they do not pretend an uncertain value has a different shape. Use them only where they simplify the code.

## `any` and Unknown Data

Do not use `any` as the default type.

`any` is acceptable only for an isolated boundary where the value genuinely cannot be reasonably typed yet, and it should not spread into important entities or API contracts.

When data is untrusted or its shape is genuinely unknown, prefer `unknown` and narrow it where the data is processed.

Do not introduce elaborate type guards for unlikely cases. Add a guard when the boundary is real and the data needs validation or safe access.

## Function Types

Let TypeScript infer return types when the result is clear from a local implementation.

```ts
const getTotalPrice = (quantity: number, unitPrice: number) => quantity * unitPrice;
```

Add an explicit return type when it clarifies a meaningful public contract, prevents an unintended return value, or is required by an established project convention.

```ts
async findById(id: string): Promise<User | null> {
  return this.userRepository.findOneBy({ id });
}
```

Do not add return types mechanically to every local function if inference is clearer.

Type inputs when their meaning is not already clear from the surrounding framework contract or a typed object.

## Generics and Advanced Types

Use generics only when they simplify a concrete, current implementation.

Avoid unnecessary:

- generic utility types;
- conditional types;
- mapped types;
- recursive types;
- overloaded function signatures;
- type-level abstractions.

Do not turn a simple feature-specific operation into a generic type utility for hypothetical reuse.

Prefer a direct, readable type over a clever reusable type.

## Naming

Use names that describe the business meaning of the data.

Prefer:

```ts
type CreateBookingInput = {
  hotelId: string;
  roomCount: number;
};
```

over vague names such as `Data`, `Payload`, `Result`, or `Object` when a more specific business name is available.

Use a consistent suffix only when it helps identify a real role:

- `Dto` for NestJS DTO classes;
- `ResponseDto` for backend response DTO classes;
- `Input` for a non-HTTP application input shape;
- `Params` for route or function parameters when appropriate.

Do not encode every usage detail into a type name.

## Final Check

Before adding or changing TypeScript types, ask:

1. Does this make the business contract clearer?
2. Is this type needed by the current feature or existing architecture?
3. Is the type simpler than the alternative?
4. Does this avoid exposing untyped or internal API data?
5. Am I using a type assertion or advanced type only because the model is incomplete?

If the answer to the second question is no, do not add it.
