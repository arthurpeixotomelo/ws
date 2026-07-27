---
description: 'Guidelines for TypeScript and JavaScript development, targeting ES2022+.'
applyTo: '**/*.{ts,tsx,js,jsx,mjs,mts}'
---

# TypeScript & JavaScript Development

## Core Intent

- **Target**: TypeScript 5.x / ES2022+.
- **Modules**: Use pure ES modules (`import/export`). Avoid CommonJS (`require`).
- **Style**: Prefer readable, explicit solutions. Keep functions focused and short.
- **Architecture**: Respect existing patterns. Extend abstractions before inventing new ones.

## Naming & Style

- **Naming**:
  - **PascalCase**: Classes, Interfaces, Enums, Types, React Components.
  - **camelCase**: Variables, functions, methods, filenames (except React components).
  - **kebab-case**: Directory names, package names, CSS classes.
  - **UPPER_SNAKE_CASE**: Constants, environment variables.
- **Formatting**:
  - 2 spaces indentation.
  - Single quotes for strings.
  - No semicolons (unless required by linter).
  - No trailing commas.
- **Imports**: Group by source: Standard Libs -> Third Party -> Local.

## TypeScript Guidelines

- **Strictness**: Avoid `any`. Use `unknown` + narrowing.
- **Types**:
  - Use **Interfaces** for data structures and definitions.
  - Use **Type Aliases** for unions and simple shapes.
  - Use **Discriminated Unions** for state machines/events.
- **Immutability**: Prefer `readonly`, `const`, and immutable data structures.
- **Utils**: Use `Partial`, `Pick`, `Omit`, `Record` to express intent.

## JavaScript Guidelines (for non-TS files)

- **JSDoc**: Add JSDoc to public APIs if types are missing.
- **Modern JS**: Use optional chaining (`?.`), nullish coalescing (`??`), and destructuring.
- **Safety**: Avoid type coercion. Use strict equality (`===`).

## Best Practices

- **Async**: Always use `async/await`. Wrap in `try/catch` with structured error handling.
- **Functions**: Prefer arrow functions (except for top-level exports if preferred).
- **Variables**: Use `const` by default, `let` only when mutation is needed. Never `var`.
- **Side Effects**: Avoid side effects in shared modules. Initialize logic in functions/components.
- **Dependencies**: Lazy-load heavy dependencies.

## React Specifics (Language Level)

- **Types**:
  - Import types separately: `import type { ... } from 'react'`.
  - Explicitly type return values (`ReactNode`).
  - Use Interfaces for Props.
- **Components**:
  - Functional components with hooks.
  - `export default function` for components.
  - Named exports for hooks/utilities.
- **Hooks**:
  - Prefix with `use`.
  - Follow rules of hooks.
  - Group at top of component.

## Testing Expectations

- Add unit tests for new logic.
- Use the project's testing framework (Vitest/Playwright).
- Avoid brittle timing assertions.
