# React Native and Expo Standard

This standard extends the Core Development Standard, TypeScript Standard, and React Standard. It defines the React Native and Expo conventions for projects that follow this development system.

## Primary Principle

React Native features should use the same predictable organization and simple state principles as React web features, while following native platform conventions.

Use direct, local feature code for feature behavior. Centralize only application-wide UI behavior that must be available across unrelated screens.

## Feature Structure

Use the same canonical feature structure as the React web project.

Use `src/features/` as the root for feature code. Equivalent React Native features must follow the same layout consistently.

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
        └── users-screen.tsx
```

Keep feature-specific components, hooks, API calls, and types inside the feature. Move code to shared locations only after there is a real cross-feature use case.

Do not create alternative feature structures or additional layers for one screen without an approved architectural reason.

## Navigation

Use Expo Router for application navigation.

Route files define routing and compose screens. Keep feature business logic and complex screen UI in the feature folder rather than placing it in route files.

```text
app/
└── users/
    └── index.tsx

src/
└── features/
    └── users/
        └── users-screen.tsx
```

Do not introduce React Navigation alongside Expo Router without explicit approval.

Use Expo Router's established route, parameter, layout, and navigation patterns. Do not build a parallel custom navigation abstraction.

When the app has session-based authentication, protect route groups centrally in the root navigator or root layout. Do not repeat session redirects and route-access checks inside individual feature screens.

## Root Application Composition

Mount application-wide providers once in the root layout. The root composition owns the application boundary, server-state provider, navigation theme, and global UI surfaces.

```text
Error boundary
→ TanStack Query provider
→ navigation/theme provider
→ root navigator
→ global loader provider
→ toast provider
→ dialog and confirmation-dialog providers
```

Do not mount a second query provider, theme provider, toast provider, dialog provider, or global loader inside a feature.

Global UI providers render the surfaces that are controlled by the temporary global UI store. Feature screens trigger those surfaces through store actions; they do not render duplicate global toasts or dialogs locally.

## Styling

Use React Native `StyleSheet` for component styling.

```tsx
const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  header: {
    marginBottom: 16,
  },
  actions: {
    flexDirection: 'row',
    gap: 8,
  },
});

export const UsersScreen = () => {
  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text>Users</Text>
      </View>

      <View style={styles.actions} />
    </View>
  );
};
```

Keep a component's styles in the same file when they are small and specific to that component.

Extract styles only when the style definition is genuinely large, independent, or reused by multiple current components. Do not create separate style files merely to reduce file length.

Use short, role-based style names such as `container`, `header`, `content`, `actions`, `title`, `list`, `item`, or `footer`.

Use `StyleSheet.create` for static styles. When a value depends on runtime state, theme, or props, apply that small dynamic value alongside the named static style:

```tsx
<View style={[styles.divider, { backgroundColor: colors.lightGrey }]} />
```

Do not move static style objects into JSX. Keep dynamic style values narrow; if the dynamic style becomes substantial, use a clear conditional named style or revise the component structure.

Do not introduce styled-components, NativeWind, or another styling system alongside `StyleSheet` without explicit approval.

Keep shared visual tokens, such as colors, spacing, typography, and border radii, in one approved theme source. Use those tokens from `StyleSheet` definitions and dynamic theme values rather than repeat raw visual values throughout feature components.

## Components and Hooks

Follow the React Standard for component extraction and custom hooks.

Extract a component when it owns independent meaningful behavior or is clearly reused. Extract a hook when behavior is reused or when it makes an otherwise difficult-to-follow parent component clear.

Do not split a screen into many small presentational components only to reduce the line count.

Use platform-specific files such as `.ios.tsx` or `.android.tsx` only when platform behavior or layout genuinely differs. Do not fork files for minor visual differences that can be handled clearly in one component.

## Local and Global State

Use local state for isolated screen and component behavior by default.

Use Zustand as the default global client-state store for new React Native projects. Adding it to a concrete project still requires the project's explicit dependency approval and `STACK.md` entry.

Use the project's approved global state store for application-wide UI state that must be controlled or triggered across unrelated screens, including:

- modals;
- bottom sheets;
- toasts;
- global overlays;
- other application-level UI surfaces.

Split global client state by lifecycle:

- **temporary state**: toasts, dialogs, confirmation dialogs, global loaders, and other UI state that must disappear when the app restarts;
- **persistent state**: only durable client data with a real restart requirement, such as an authenticated session.

Do not persist temporary UI state, server-state cache, form values, or incidental screen state by default.

The global UI state should expose a clear, direct API for opening, closing, and configuring these surfaces. Keep each UI surface's current payload and visibility state explicit.

Do not place ordinary feature form state, server state, temporary input state, or isolated component toggles into the global store.

Keep a modal, bottom sheet, or similar UI element local only when it is truly isolated to one feature and does not need to be triggered, coordinated, or persisted beyond that feature's scope.

Read global state through narrow selector hooks so a component subscribes only to the state and actions it uses. Do not make ordinary components consume a combined, whole-store object.

Do not introduce another state-management library without approval. Record Zustand and any persistence choice in `STACK.md`.

## Server State and Forms

Use TanStack Query for server state, API queries, mutations, caching, and invalidation, following the React Standard.

Keep each feature's API functions, query keys, query options, mutation options, invalidation, and feature-level success/error feedback in the feature's `api/` location. Screens and components consume those options with `useQuery` and `useMutation`.

```ts
export const usersQuery = () =>
  queryOptions({
    queryKey: ['users'],
    queryFn: getUsers,
  });
```

Configure the shared `QueryClient` once at the application root. Retry count, stale time, polling, offline persistence, and cache persistence are project-level decisions; do not copy them between projects by default.

Use Formik and Yup for forms. Do not mirror Formik field values in individual local `useState` hooks.

Use the established native form components and error-display pattern of the project. Do not create a new form framework or generic field abstraction without a concrete current need and approval.

## Native UI Components

Build project UI components internally rather than introducing a general-purpose React Native UI component library.

Create a shared UI component only when it has multiple real current usages or belongs to an approved page, section, layout, or design-system pattern.

Do not add React Native Paper, NativeBase, Tamagui, or another UI library without explicit approval.

Keep feature-specific UI inside the feature rather than prematurely promoting it to a shared component.

## API Boundary

Keep the app's HTTP client in one shared API boundary. Feature `api/` files call that client; they do not configure independent clients or duplicate request interceptors.

When the project uses access tokens with refresh tokens, implement token attachment, single-flight refresh, session clearing, and redirect to sign-in in the shared API boundary. Do not implement refresh logic in individual feature requests.

Do not add token refresh behavior when the selected authentication architecture does not use refresh tokens.

## OTA Updates

Expo applications using EAS Update must implement OTA checking in one root-level `useExpoUpdate` hook, invoked once from the root layout.

The hook must:

1. check for an update when the application starts;
2. subscribe to every `AppState` `change` event and check again on each event;
3. prevent overlapping checks with a local in-flight ref;
4. call `checkForUpdateAsync`, then `fetchUpdateAsync` and `reloadAsync` only when an update is available;
5. handle failure without breaking the running app and log it through the project's logging approach;
6. unsubscribe from the app-state listener on cleanup.

```ts
const isCheckingRef = useRef(false);

const subscription = AppState.addEventListener('change', () => {
  void fetchForUpdate();
});
```

Do not run OTA checks from feature screens or create multiple app-state listeners for updates.

Document the Expo update URL, runtime-version policy, and release-channel strategy in the mobile project's `STACK.md` or an ADR. OTA updates must stay compatible with the installed native runtime.

## Native Platform Capabilities

Use Expo modules and existing approved project dependencies for native capabilities.

Before adding a new Expo module, native library, permission, background task, or platform configuration:

1. explain why it is required;
2. verify whether an existing capability already covers the need;
3. wait for developer approval;
4. record any accepted platform-level decision in the project documentation when it affects architecture or permissions.

Do not add permissions, fallback flows, or device-specific behavior for hypothetical cases.

## Final Check

Before completing a React Native or Expo change, verify:

1. Does the feature live under `src/features/` and follow the canonical structure?
2. Does navigation use Expo Router without a parallel navigation layer?
3. Are app-wide providers mounted exactly once in the root layout?
4. Does styling use `StyleSheet`, concise role-based style names, and only narrow dynamic overrides?
5. Is the state local unless it belongs to temporary or persistent global state with a real cross-screen need?
6. Are modals, bottom sheets, and toasts coordinated through temporary Zustand state when they need cross-screen control?
7. Does server state use feature-owned TanStack Query options and do forms use Formik and Yup?
8. Does an Expo/EAS app use the required root-level OTA update flow?
9. Did the change avoid new UI libraries, state libraries, and speculative native configuration?

If not, simplify the implementation or request approval before proceeding.
