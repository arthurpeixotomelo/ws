---
description: "Global guidance for GitHub Copilot code generation with concise provenance and tool-first behavior."
applyTo: "**"
---

# GitHub Copilot General Instructions

- Before making non-trivial changes, inspect the relevant repository
  instructions and tools, then record them in a short "Used Instructions & Docs"
  block.
- Prefer repository tools and verified commands over inline shell snippets.
- For new features or cross-cutting changes, propose a short plan when the scope
  is unclear and ask for confirmation if needed.
- Keep changes scoped and explain the implementation approach briefly.
- When a change affects tests, run the relevant checks before finishing.
- If a rule is tool-enforceable (formatting, linting, typing, commit checks),
  prefer hooks or linters over repeating it in prompt text.

## Required response shape

Include a brief "Used Instructions & Docs" section with:

- `used_instructions`: relevant repository instruction files
- `external_docs`: any external references consulted
- `tools`: the tools used to inspect or verify the change
- `assumptions`: any missing context or constraints
