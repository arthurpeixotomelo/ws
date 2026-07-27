---
applyTo: "**/*.py"
---

# Python Coding Standards

## Naming Conventions
- Use **kebab-case** for directories.
- Use **PascalCase** for class names.
- Use **snake_case** for filenames, variables, functions, and methods.
- Use **UPPER_SNAKE_CASE** for environment variables and constants.
- Prefix **private members** with a single underscore (`_`).

## Formatting Rules
- Use **single quotes** for strings (`'example'`).
- **No trailing commas** in lists, tuples, dicts, or function arguments.
- Indentation must be **4 spaces**.
- Limit lines to **90 characters**.
- Use **blank lines** to separate functions and classes.

## Best Practices
- Avoid **unused variables and imports**.
- Avoid **non-idiomatic comparisons** (e.g., use `is None` instead of `== None`).
- Prefer **explicit over implicit** be clear in your code.
- Avoid **magic numbers or strings** use named constants.
- Use **list comprehensions** instead of `map()` or `filter()` when clearer.
- Avoid **mutable default arguments** in functions.
- Group imports: **standard library**, then **third-party**, then **local**.
- Keep functions **short and focused** one task per function.
- Use **type hints** for function signatures and variable annotations.
- Use **f-strings** for string formatting.