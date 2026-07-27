---
description: 'Global guidelines for GitHub Copilot code generation, ensuring alignment with repository instructions and explicit context provenance for each action'
applyTo: '**'
---

# GitHub Copilot General Instructions

Core instructions for maintaining code quality, consistency, and architectural alignment across all code generation tasks.

## Project Context

- **Purpose**: Ensure generated changes are informed by repository instruction files and documentation, and that the agent records what it used.
- **Scope**: Global guidance applied before any code generation or modification.
- **Integration**: Works with `.github/instructions/*` files, agent modes, and external context tools (e.g., contextDocs, mcp) when available.

## Context & Applied Instructions

Before making code changes, the agent MUST enumerate the instruction files, docs, and external context sources consulted for the task. This makes it easy to test whether the LLM had the expected inputs and prevents silent assumptions.

- Required content: a concise "Used Instructions & Docs" section to precede any implementation summary or change.
- Required fields (one-line list or YAML block preferred):
  - used_instructions: list of repository instruction files consulted (paths)
  - external_docs: list of external documentation sources retrieved (URLs or tool names)
  - tools: list of context tools used to gather docs (e.g., contextDocs, mcp)
  - assumptions: brief list of any assumptions made due to missing context

Example (markdown block):

```yaml
# Used Instructions & Docs:
used_instructions: 
 - .github/instructions/markdown.instructions.md
 - .github/instructions/javascript.instructions.md
external_docs: https://nodejs.org/..., https://drizzle-orm/llms-full.txt]  
 - https://nodejs.org/...
 - https://drizzle-orm/llms-full.txt
tools: 
 - contextDocs
assumptions: 
 - "No repo-level architecture file found; assumed Node+Hono default structure"
```

Behavior when items are missing:
- Routine edits / small refactors: agent should list missing guidance, state assumptions, and may proceed after confirmation or if user explicitly requested the change.
- New features, major architecture changes, or unclear requirements: agent should NOT proceed automatically. Instead, it should propose a minimal plan and ask to confirm.
- Agents should avoid failing silently — if a critical instruction file is expected but unavailable, make that explicit in the "Used Instructions & Docs" block and ask the user how to proceed.

## General Instructions

- Always search for repository instruction files and relevant docs before implementing non-trivial changes.
- Treat a relevant `.instructions.md` file as the primary guide for routine language/framework decisions.
- Prefer explicitness in naming and API design; align with the project's style and design-principles instruction when present.
- When external libraries are involved, retrieve and reference up-to-date docs (list them under external_docs).
- Record provenance: every actionable output must include the "Used Instructions & Docs" block shown above.

## Prefer Tools over Inline Terminal Commands

- When performing actions that require running scripts, tests, or file operations, prefer invoking repository tools (e.g. `runCommands`, `terminal`, `search/replace` tools, `git` tool integrations) instead of embedding long shell code blocks in the response.
- Always:
  - Identify the specific tool to call and include a one-line rationale (e.g., "run tests with `pnpm test` using runCommands to capture structured output").
  - Provide the exact command, working directory, and any environment variables in a "Tool Invocation" template (see below).
  - Log the tool used under `tools:` in the "Used Instructions & Docs" block.
- Tool Invocation template (use when calling a tool programmatically):

```yaml
tool: runCommands
command: pnpm test
cwd: node/fin-hub
env:
  CI: 'true'
reason: "Run unit tests as part of verification"
```

- Fallback: if the required tool is not available in the environment, list that explicitly in `assumptions:` and propose a minimal manual command the user can run, asking for confirmation before proceeding.
- Avoid multi-file inline search-and-replace in freeform text. Instead, either:
  - Use a repository patch tool (push_files / edit) to apply precise diffs, or
  - Propose a concise, auditable script and trigger it via the terminal tool with clear rollback instructions.
- Rationale: using tools reduces fragile iteration loops caused by pasted shell commands, produces structured output, and enables auditing and replayability.

## Code Generation Requirements

- Proceed to code generation when:
  - For routine changes: relevant instruction file(s) were found and listed, and the agent's confidence is documented.
  - For new features or cross-cutting changes: either an architecture/implementation plan exists or the user explicitly approves the agent's proposed plan.
- Always include the "Used Instructions & Docs" block in PR descriptions, change summaries, or top of generated files when applicable.

## Implementation Summary & Reasoning

- For each action, produce a short implementation summary showing how the referenced instruction files informed decisions.
- Include an explicit list of instruction files and docs used (paths and URLs) plus the short reasoning for why each was applied.
- Example summary (after the used-instructions block):
  - Implementation approach: "Create X using pattern Y from .github/instructions/..."  
  - Reasoning: "Applied performance and design-principles files because this change touches hot paths and public APIs."

## Example Output Template (required in agent responses for code changes)

```yaml
# Used Instructions & Docs:
used_instructions:
  - .github/instructions/markdown.instructions.md
  - .github/instructions/design-principles.instructions.md
external_docs:
  - https://nodejs.org/...
tools:
  - contextDocs
assumptions:
  - "No repo README describing architecture; assumed microservice with REST API"
```
Followed by a 2–4 sentence Implementation Summary and the code patch or file contents.

## Always Output

- The agent must always include the "Used Instructions & Docs" block when performing code generation or repo-wide documentation work.
- When asked to produce documentation or plans, use `.github/instructions/markdown.instructions.md` conventions for structure and diagram placement.

## Instruction File Hierarchy

When generating code, apply instructions in this order (higher priority = applied last, can override earlier rules):

1. **Foundational Principles** (`.github/instructions/core/*.instructions.md`)
   - Design & architecture patterns, performance optimization, testing strategy
   - Applies to all code regardless of language or framework
   
2. **Language-Specific** (`.github/instructions/lang/*.instructions.md`)
   - Language idioms, standard library usage, type systems
   - Builds on foundational principles with language-specific patterns
   
3. **Library/Framework/Tool-Specific** (`.github/instructions/libs/*.instructions.md`)
   - Framework conventions, library APIs, tool-specific workflows
   - Most specific layer; assumes foundational + language context

**Conflict Resolution:**
- More specific layers override general ones (libs > lang > core)
- More specific `applyTo` patterns win over generic patterns
- Explicit user requests override all instructions
- When conflicts remain, list them in "Used Instructions & Docs" and ask user to clarify

**Example**: For a React TypeScript component:
- Apply `core/design.instructions.md` (SRP, modularity)
- Apply `lang/typescript.instructions.md` (types, immutability)
- Apply `libs/react.instructions.md` (hooks, component patterns)