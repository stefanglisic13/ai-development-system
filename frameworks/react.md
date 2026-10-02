# React Standard

This standard extends the Core Development Standard and TypeScript Standard. It defines the default React architecture and implementation style for projects that follow this development system.

Scope: web React applications. React Native reuses component, hook, state, forms, query, and API principles; its own standard replaces web markup, styling, navigation, and runtime behavior.

## Primary Principle

React code should make it easy to understand what a screen renders, where its state lives, how it fetches data, and which parts are reusable.

Prefer a small number of clear components with local feature logic over deeply fragmented component trees and speculative abstraction.

Reuse presentation patterns and behavior when that makes a feature simpler. Do not extract components, hooks, or configuration layers merely because they could be reused in the future.

## Feature Structure

Use `src/features/` as the root for feature code. Every equivalent React feature must follow the same structure consistently.

The default structure is:

```text
src/
└── features/
    └── users/
        ├── api/
        │   └── users.api.ts
        ├── components/
        │   └── users-form.tsx
        ├── hooks/
        │   └── use-users.ts
        ├── types/
        │   └── users.types.ts
        └── users-page.tsx
```

Route files should remain route adapters. Keep feature screens, feature logic, API calls, and complex feature UI under `src/features/`, rather than embedding them in route definitions.

Feature folders should have predictable locations for:

- the screen or main feature component;
- feature-specific UI components;
- feature-specific hooks;
- feature API calls and query hooks;
- feature-specific types.

Do not add folders such as `utils`, `helpers`, `constants`, `services`, `models`, `providers`, `contexts`, or `state` to a single feature unless they belong to the established project structure or a concrete current need is approved.

## Root Application Composition

Mount application-wide providers once at the application root. The root composition owns the error boundary, TanStack Query provider, theme provider, router, and global UI surfaces such as toasts, dialogs, confirmation dialogs, and global loaders.

Do not mount duplicate global providers inside individual features.

When the application has session-based authentication, protect routes centrally in the router. Do not repeat session redirects and route-access checks in individual pages.

## Components

Keep a component in its parent file when it is small, only serves that parent, and does not own meaningful independent behavior.

Extract a component into its own file only when at least one of these is true:

- it owns its own meaningful state, effects, event handling, or processing;
- it is clearly used in more than one place.

Do not split JSX into many small files just to reduce the line count of a parent component.

Do not create generic components, render-prop APIs, compound components, wrappers, or configuration-driven UI unless the current project already uses that pattern or there are real current consumers.

Use shared page templates, section templates, layouts, and UI components when they are established by the project. Feature code should contain the feature-specific composition, state, and configuration.

## Styling and Component Markup

Use `styled-components` for React component styling.

Each rendered component root must use a styled wrapper named `Container`. The rendered `Container` must have a meaningful, unique `id` in kebab-case.

For repeated instances, use a stable instance suffix (for example `user-card-${user.id}`), or a caller-provided unique id. Do not repeat a fixed DOM id for every list item or generate a random id during render. Define styled wrappers at module scope. Route adapters, providers, and components returning `null` do not need an extra DOM wrapper. Choose a semantic element that preserves valid HTML.

```tsx
const Container = styled.section`
  .header {
    display: flex;
    justify-content: space-between;
  }

  .content {
    margin-top: 16px;
  }

  .actions {
    display: flex;
    gap: 8px;
  }
`;

export const UsersPage = () => {
  return (
    <Container id="users-page">
      <header className="header">
        <h1>Users</h1>
      </header>

      <main className="content">...</main>

      <footer className="actions">...</footer>
    </Container>
  );
};
```

Style internal elements through classes nested inside `Container`.

Keep selectors scoped to owned markup. Use direct-child selectors where a nested component may also use `.header`, `.content`, or another short class; do not accidentally style a child component's internals.

Class names should usually be one meaningful word describing the element's role or position, such as `header`, `content`, `actions`, `title`, `list`, `item`, `form`, `footer`, or `sidebar`.

Do not create verbose class names that repeat the feature or component context already expressed by the `Container` id and file location.

Prefer:

```tsx
<Container id="users-page">
  <section className="content" />
  <div className="actions" />
</Container>
```

over:

```tsx
<Container id="users-page">
  <section className="users-page-main-content-section" />
  <div className="users-page-bottom-action-buttons" />
</Container>
```

Use a compound class name only when one word would make the role unclear. Keep it short and role-based, such as `empty-state` or `filter-row`.

Keep a component's styles close to the component. Do not create a separate styles file only to move a small `Container` declaration out of the component file.

Do not introduce CSS Modules, Tailwind, inline style objects, or another styling system alongside `styled-components` without explicit approval.

Keep shared visual tokens, such as colors, spacing, typography, breakpoints, and border radii, in one approved theme source. Styled components should consume those tokens rather than repeat raw visual values throughout feature components.

Create a shared UI primitive, page template, or layout only after it has multiple real current usages or is an approved application-wide foundation. Do not turn every local component into a design-system component.

## Component State and Logic

Use local component state by default.

Keep state as close as possible to the component that uses it. Lift it only when multiple rendered descendants need the same state.

Use global state only for genuinely global application state, such as authenticated user context, application-wide settings, or a state that must be shared across unrelated feature trees.

Do not put feature-local form state, server data, UI toggles, or temporary screen state into a global store.

Use Zustand as the default global client-state store for new React projects. Adding it to a concrete project still requires the project's explicit dependency approval and `STACK.md` entry.

Split global client state by lifecycle:

- **temporary state**: global toasts, dialogs, confirmation dialogs, loaders, and other state that must disappear on refresh;
- **persistent state**: only durable client data with a real reload requirement, such as a user session.

Persistence does not select credential storage. Follow the approved authentication design; do not automatically serialize tokens into browser storage. Wait for required state hydration before deciding authenticated routes, and clear user-scoped queries and UI state when the session ends or changes.

Do not persist temporary UI state, server-state cache, form data, or incidental page state by default.

Read Zustand through narrow selector hooks so a component subscribes only to the state and actions it uses. Do not make ordinary components consume a combined, whole-store object.

Keep event handlers and simple transformations in the component when that makes the flow clear. Do not extract them automatically into helpers.

## Hooks

Extract a custom hook when:

- the behavior is used in more than one component; or
- the parent component's state, effects, and event logic have become difficult to follow, and the hook creates a clearer boundary.

The hook must have a clear responsibility. Do not create hooks only to move a few lines of local state out of a component.

Feature-specific hooks remain in that feature's `hooks/` folder. Promote a hook to shared code only after there is a real cross-feature use case.

Avoid hooks that silently coordinate unrelated concerns or hide the primary behavior of a screen.

## Server State and API Calls

Use TanStack Query for server state, queries, mutations, loading states, caching, and invalidation.

Keep each feature's API functions, query keys, query options, mutation options, invalidation, and feature-level success/error feedback in the feature's `api/` location. Screens and components consume those options with `useQuery` and `useMutation`.

```ts
export const getUsers = async (): Promise<UserResponseDto[]> => {
  const response = await apiClient.get<UserResponseDto[]>('/users');

  return response.data;
};

export const usersQuery = () =>
  queryOptions({
    queryKey: ['users'],
    queryFn: getUsers,
  });
```

Use `queryOptions` and `mutationOptions` when they make a feature's query contract reusable without introducing a new abstraction layer.

Use stable, understandable query keys. Invalidate or update only the queries affected by a completed mutation.

Include every input that changes the returned data in the query key (for example resource id, filters, page, or tenant). Keep feedback in one owner to prevent duplicate toasts; caller-specific navigation stays at the screen or hook boundary.

Do not duplicate server state in local state or a global store unless there is a specific UI reason that cannot be handled by TanStack Query.

Configure the shared `QueryClient` once at the application root. Retry count, stale time, polling, offline behavior, and cache persistence are project-level decisions; do not copy them between projects by default.

Do not introduce another data-fetching library or a generic API abstraction without approval.

## API Boundary

Keep the application's HTTP client in one shared API boundary. Feature `api/` files call that client; they do not configure independent clients or duplicate request interceptors.

When the selected authentication architecture uses access and refresh tokens, keep token attachment, single-flight refresh, session clearing, and redirect to sign-in in that shared API boundary. Do not implement refresh behavior inside individual feature requests.

A shared refresh promise represents the token refresh only. Each waiting request retries its own original request once; clear the promise after success or failure and do not send the refresh request back through the same refresh loop. Session expiry must use the same cleanup path as logout.

Do not add refresh-token behavior when the application does not use that authentication architecture.

## Forms

Use Formik and Yup for forms.

Do not create separate local `useState` for each form field alongside Formik state.

Keep the form schema, initial values, submit handling, and visible fields close to the feature form component when that makes the flow easy to read.

Extract schema or form configuration only when it is genuinely reused or the form component would otherwise become difficult to understand.

Use Yup validation for real user-input requirements. Do not add speculative, unusually strict, or redundant validation rules.

```ts
const validationSchema = Yup.object({
  email: Yup.string().email('Enter a valid email address').required('Email is required'),
});
```

The submit flow should be direct:

```text
Formik submit
→ TanStack Query mutation
→ display expected success or error state
→ invalidate or update affected query data
```

Do not introduce a generic form engine, form-wrapper abstraction, or custom validation framework without explicit approval.

## Types and Props

Follow the TypeScript Standard.

Type component props and important API data explicitly. Keep feature-specific types in the feature's approved `types/` location when they are shared within the feature or describe meaningful business data.

Do not create a separate type file for a type used once and naturally understood beside the component or API function.

Use specific prop names that communicate business purpose. Avoid broad prop bags, opaque configuration objects, and `any` for component contracts.

## Effects

Use `useEffect` only for real side effects, such as subscribing to an external system, synchronizing a browser API, or responding to a value outside React's normal render flow.

Do not use `useEffect` for simple derived values, straightforward event handling, or fetching that TanStack Query should own.

Do not add `useMemo` or `useCallback` by default. Use them only when there is a demonstrated rendering, referential-stability, or expensive-computation need.

## Error and Loading States

Make realistic loading, empty, success, and failure states visible where the user needs feedback.

Use the project's established error display pattern. Do not create a new notification, error-boundary, fallback, or retry abstraction for an individual feature without approval.

Do not add fallback behavior for impossible or highly unlikely states. Handle realistic API and user-input failures clearly.

## Final Check

Before completing a React change, verify:

1. Does the feature live under `src/features/` and follow the canonical folder structure?
2. Did a component or hook move to its own file only for a clear current reason?
3. Are app-wide providers mounted only at the application root?
4. Is local state used before considering temporary or persistent global Zustand state?
5. Is TanStack Query the only server-state mechanism, with query behavior owned by the feature `api/` location?
6. Does a form use Formik and Yup without duplicate local field state?
7. Are API contracts and important props typed?
8. Did the change avoid speculative components, hooks, abstractions, validation, and dependencies?

If not, simplify the implementation or ask for approval before proceeding.
