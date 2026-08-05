---
description: "TypeScript, JavaScript, React, and Astro conventions not covered by linting or formatting tools."
applyTo: "**/*.{ts,tsx,js,jsx,mjs,mts,astro}"
---

# TypeScript / JavaScript / React / Astro

## Tooling boundary

- Formatting and linting rules are owned by the configured tooling; do not
  restate them here.
- Keep this file focused on semantics, architecture, and behavior.

## TypeScript

- Target ES2022+ and use ES modules (`import`/`export`); avoid CommonJS.
- Avoid `any`; prefer `unknown` plus narrowing.
- Use interfaces for object shapes, type aliases for unions and intersections,
  and discriminated unions for state transitions.
- Prefer `readonly`, `const`, and immutable data structures.
- Use `Partial`, `Pick`, `Omit`, and `Record` to express intent rather than
  falling back to bare object shapes.

## JavaScript and async

- Prefer `async`/`await`; wrap logic in `try`/`catch` with structured error
  handling.
- Use `const` by default; use `let` only when reassignment is needed, and avoid
  `var`.
- Prefer optional chaining, nullish coalescing, and destructuring over manual
  truthiness checks.
- Use strict equality (`===`) and avoid implicit type coercion.

## React

- Use function components and hooks by default.
- Prefix hooks with `use`; follow the rules of hooks and keep them at the top of
  the component.
- Import React types separately when needed (`import type { ... } from 'react'`)
  and type return values explicitly when useful.
- Keep components focused and composable; prefer composition over inheritance.
- Use `useMemo`, `useCallback`, or `React.memo` only when a profiler or real
  render-path evidence shows they help.

## Astro

- Use `.astro` files for server-rendered content and add framework components
  only for true interactivity.
- Prefer default static rendering and add hydration only when it is necessary.
- Use `ClientRouter` for view transitions when the app needs them.
- Prefer the Content Layer API for content collections and refresh generated
  types with `astro sync`.
- Keep client-side JavaScript minimal and intentional.

## Cross-cutting guidance

- Add tests for new logic and prefer behavior tests over implementation tests.
- Keep error states visible for users and avoid hidden failures.
- Favor simple, composable solutions over premature abstractions.
