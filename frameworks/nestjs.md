# NestJS Standard

This standard extends the Core Development Standard and TypeScript Standard. It defines the default NestJS architecture for projects that follow this development system.

## Primary Principle

Each feature module should be predictable and self-contained. A developer should be able to enter any feature folder and immediately find the same core responsibilities and follow the business flow without unnecessary indirection.

Prefer a clear flow from controller to service to TypeORM repository. Do not add layers between them unless the approved project architecture explicitly requires one.

## Required Feature Structure

Every feature module uses the following structure:

This is the business-feature template. Shared infrastructure modules such as email or logging use only their approved responsibilities; do not invent database tables or HTTP endpoints just to fill the template.

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

The folder and file names must use the feature name as their base.

Equivalent modules must follow this same structure, even when a particular file is currently small. Do not omit, rename, or introduce alternative layers for an individual module without an explicit architectural decision.

The responsibilities are:

- `*.module.ts`: declares the module, imports, controllers, providers, and TypeORM entities;
- `*.controller.ts`: exposes HTTP endpoints, applies guards and endpoint-level authorization, receives request DTOs, and returns response DTOs;
- `*.service.ts`: contains the feature's business flow, validation, calculations, persistence orchestration, and error handling;
- `dto/*.dto.ts`: contains all request and response DTO classes for that feature;
- `entities/*.entity.ts`: contains the TypeORM entity for that feature.

Do not create `repositories/`, `use-cases/`, `handlers/`, `managers/`, `mappers/`, `factories/`, `interfaces/`, or similar folders unless the project architecture is explicitly changed and approved.

## Modules

Every feature has its own NestJS module.

Register the feature's controller, service, and TypeORM entity directly in that module.

```ts
@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService],
})
export class UsersModule {}
```

Keep module configuration direct and local. Do not introduce dynamic modules or generic registration helpers for ordinary feature modules.

## Controllers

Controllers are responsible for the HTTP boundary.

Controllers should:

- define routes, HTTP methods, and HTTP response codes;
- receive and pass request DTOs to the service;
- apply authentication and authorization guards;
- use authorization decorators required by the endpoint;
- return the response DTO or service result defined by the API contract.

Keep controllers thin. Do not place business calculations, database queries, or feature-specific processing in a controller.

Apply authorization at the controller or endpoint level through existing guards and decorators.

```ts
@UseGuards(AuthGuard, RolesGuard)
@Roles(UserRole.ADMIN)
@Post()
create(@Body() dto: CreateUserDto) {
  return this.usersService.create(dto);
}
```

Do not duplicate authorization checks inside services unless the operation can be called outside the protected HTTP controller boundary or the existing project architecture requires it.

Controller guards must cover resource ownership or tenant access where required, not just the user's role. Query data within the authorized resource scope. If the required resource information is only available inside the operation, keep that check at the service data boundary; never omit it to keep the controller thin.

Do not introduce a new guard, decorator, permission system, or authorization abstraction without approval.

## Services

Services own the feature's business flow.

Keep the primary flow linear and visible in the service:

```text
receive input
→ load required data
→ validate realistic business conditions
→ calculate or transform values
→ create, update, or remove data
→ return the response DTO
```

Prefer direct, explicit operations over chains of helpers and generic abstractions.

A service may be long when its code belongs to the same feature and the flow remains readable. Do not extract private helpers merely to reduce line count.

Use a private method only when it represents a genuinely independent responsibility or a repeated operation within the feature. Keep it in the service unless it has multiple real consumers or has become sufficiently complex to require its own approved file.

## TypeORM Access

Inject the TypeORM repository directly into the feature service.

```ts
constructor(
  @InjectRepository(User)
  private readonly userRepository: Repository<User>,
) {}
```

Use the repository directly for the feature's persistence operations.

Do not add a custom repository layer, data-access service, generic repository, or repository wrapper.

Keep database queries understandable and close to the business operation that uses them. Extract a shared query only when there is a concrete current reuse case.

Load relations explicitly for each use case. A repository query should declare only the relations that its service operation needs.

```ts
const booking = await this.bookingRepository.findOne({
  where: { id },
  relations: ['hotel', 'guest'],
});
```

Do not rely on eager relation loading or load broad relation graphs by default. Add a relation only when the current operation uses it.

## DTOs and API Responses

Each feature keeps its request and response DTO classes in one DTO file:

```text
users/dto/users.dto.ts
```

The file may contain related request DTOs and response DTOs for that feature:

```ts
export class CreateUserDto {
  @IsEmail()
  email: string;
}

export class UpdateUserDto {
  @IsOptional()
  @IsEmail()
  email?: string;
}

export class UserResponseDto {
  id: string;
  email: string;
}
```

Use class-based DTOs. Add only validation that is required by the endpoint contract or a realistic input failure case.

Never return a TypeORM entity directly from an API endpoint.

Map an entity to its response DTO explicitly in the service or controller where the response is produced. Keep simple mapping local:

```ts
return {
  id: user.id,
  email: user.email,
  status: user.status,
};
```

Do not introduce separate mapper files, mapper services, generic mapping functions, or serialization layers for ordinary response mapping.

When several operations in the same feature return the same response contract, a local service method may map the entity to its response DTO. Keep that method in the feature service and use it only for a real repeated response shape.

```ts
private toUserResponseDto(user: User): UserResponseDto {
  return {
    id: user.id,
    email: user.email,
    status: user.status,
  };
}
```

List public fields explicitly. Do not spread an entity and hide selected properties with `undefined`. A DTO annotation alone does not remove runtime fields. Use an explicit return type or `satisfies ResponseDto` at the response boundary while preserving inference for local functions.

## Entities

Every feature defines its TypeORM entity in its entity file.

Entities describe persistence, relations, and database-level constraints. They are not API response models.

Keep entity-specific database details in the entity. Do not move business flows into entity methods or introduce rich domain-model patterns unless explicitly approved by the project architecture.

Use enums for finite database and business states when appropriate, following the TypeScript Standard.

## Validation and Errors

Every NestJS project should register one global `ValidationPipe` for HTTP request DTOs. The default configuration should:

- transform request values into their DTO types;
- whitelist declared DTO properties;
- reject unknown request properties;
- return one consistent, client-readable validation error format.

```ts
app.useGlobalPipes(
  new ValidationPipe({
    transform: true,
    whitelist: true,
    forbidNonWhitelisted: true,
  }),
);
```

Keep the global validation behavior in the application bootstrap or a dedicated application configuration file. Do not weaken or override it for one endpoint without a documented compatibility reason.

Validate request-shape constraints in DTOs through this pipeline.

`transform: true` is not arbitrary field coercion. Declare needed conversions and nested validation explicitly according to the installed validation libraries. The example uses Nest's default error format; customize the error format only when the approved client contract requires it.

Validate business rules in the service at the point where the required data is available.

Handle realistic failure cases explicitly and close to the operation that can fail. Use built-in NestJS HTTP exceptions when sufficient:

```ts
if (!user) {
  throw new NotFoundException('User not found');
}
```

Do not create custom exception classes without a concrete project-level need.

Use `try/catch` around meaningful processing boundaries where logging or a clearer operation-level error is needed. Do not wrap every repository call or allow failures to travel through unexplained layers.

## External Service Boundaries

When an operation changes local database state and calls an external service, keep the full flow explicit in the feature service:

```text
validate business conditions
→ create or record local pending state when needed
→ call external service inside a narrow try/catch boundary
→ persist successful external result
→ return the response DTO
```

Use a temporary local state, such as `INITIALIZING` or `PENDING`, only when the feature genuinely needs to represent an operation that has started but is not yet complete.

The `try/catch` should cover the external boundary and its immediate dependent writes, not the entire service method. If a failed external call leaves a temporary local record or state that must not remain, perform the smallest explicit compensation before returning a meaningful error.

Distinguish a failed remote operation from a successful remote operation followed by a failed local write. Do not delete the only local record of a remote resource that may already exist. Preserve known identifiers and use the feature's approved recovery behavior; a database rollback cannot undo a remote API call.

Do not add generic saga, workflow, retry, queue, or transaction abstractions for a single external call unless the approved architecture requires them.

## Configuration

Use NestJS `ConfigService` for configuration inside modules and services.

Keep direct `process.env` access in the application bootstrap, environment configuration, or dedicated config layer. Do not spread direct environment access through feature services.

Do not introduce new environment variables without approval and a documented project-level reason.

## Logging and Exception Filters

Projects should have one established global exception filter and logging approach.

The global exception filter is responsible for consistent error logging and consistent HTTP error formatting. It should log useful context without exposing secrets, tokens, credentials, or sensitive personal data.

Feature services remain responsible for throwing meaningful framework exceptions and handling known operation-level failures. A global filter does not replace clear local error handling.

Do not add logging independently to every method. Log meaningful events and failures using the project's existing logger and established logging format.

Do not introduce a new logging library or monitoring provider without approval.

## Database Changes

Treat schema changes as explicit feature work.

When a feature requires an entity change, relation, index, migration, or data transformation:

1. include it in the feature plan;
2. follow the project's existing TypeORM migration convention;
3. do not make unrelated schema improvements at the same time.

Do not add indexes, constraints, cascade rules, eager relations, or database hooks for hypothetical future cases.

When a current business invariant must survive concurrent requests, enforce it with the relevant database constraint. Use a local TypeORM transaction for writes that must succeed together; use its transaction manager for all participating writes. No generic transaction layer is needed. Do not hold a database transaction across a slow external API call by default.

## Final Check

Before completing a NestJS change, verify:

1. Does the feature use the established module structure?
2. Is the controller limited to the HTTP and authorization boundary?
3. Is the business flow clear and local in the service?
4. Is TypeORM accessed directly from the service?
5. Are request and response contracts represented by feature DTO classes?
6. Is the response DTO explicit rather than a returned entity?
7. Did the change avoid new layers, dependencies, and speculative validation?
8. Are expected failures handled or logged at a clear boundary?

If a proposed change fails any of these checks, simplify it or request approval before proceeding.
