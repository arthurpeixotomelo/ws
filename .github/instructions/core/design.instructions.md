---
description: "Trimmed design, architecture, and performance principles for everyday coding work."
applyTo: "**"
---

# Design & Architecture

## Default behavior

- **Pre-release codebase**: never preserve backward compatibility; break freely
  when needed.
- **Fail fast**: validate inputs at boundaries and raise typed errors early.
- **YAGNI / KISS**: add abstractions and features only when needed; prefer the
  obvious solution.

## Code shape

- One level of indentation per method; extract helpers to flatten nested logic.
- Prefer early returns and guard clauses over `else`.
- Keep call chains short; avoid deep object-graph traversal in one line.
- Use descriptive names; avoid abbreviations.
- Keep entities small: roughly 50 lines or fewer per class, 10 methods or fewer,
  and no more than two instance fields unless the abstraction truly needs more.
- Domain classes should tell, not ask: avoid getters/setters where behavior can
  be expressed directly.

## Architecture

- Keep core logic free of framework-specific imports; isolate external systems
  behind interfaces or adapters.
- Inject dependencies such as clients, config, and loggers rather than
  hard-wiring them.
- Prefer immutable data and avoid mutating shared state.
- Give each module, function, and class a single clear responsibility.
- Design for extension, not constant rework.

## Errors & logging

- Handle failures in a consistent way and return a predictable error shape.
- Log structured events; never log secrets, tokens, or personal data.
- Add trace IDs to cross-boundary operations.

## Performance

- Measure first; profile before optimizing.
- Optimize the common path rather than rare edge cases.
- Avoid O(n²) or worse; review nested loops and recursive hotspots.
- Batch database and network calls; avoid N+1 patterns.
- Use non-blocking I/O and connection pools for hot paths.
- Cache only hot, non-volatile, non-sensitive data and invalidate it
  deliberately.
- Paginate or stream large responses rather than returning oversized payloads.

## Data modeling

- Use 3NF for operational databases and a star schema for analytics.
- Every table needs a primary key and audit columns such as `created_at` and
  `updated_at`.
- Enforce foreign keys and index foreign keys plus frequent filter columns.
- Use singular snake_case names such as `customer` and `order_id`.

## APIs & releases

- Version endpoints when they are public or shared (`/v1/...`).
- Keep configuration in environment variables or config files instead of
  hard-coding it.
