---
applyTo: "**/.git/**"
---

# Git Commit & Project Management Standards

## Commit Message Guidelines (Conventional Commits)

Structure your commit messages as:
```text
<type>(optional scope): <short description>

[optional body, concise and focused on rationale or context]

[optional footer(s)]
```

- The subject line must be concise (≤ 72 characters), imperative, and describe the main change.
- The body is **optional** and should be used only for brief context, rationale, or to explain *why* (not *what*).
- **Do not** provide a full changelog in the commit body.
- If you need to describe multiple changes, split them into atomic commits.
- Use detailed bullet lists or grouped change descriptions only in Pull Request descriptions or release notes.

### Allowed `<type>` values:
- `feat`: Introduces a new feature
- `fix`: Patches a bug
- `docs`: Documentation changes only
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code changes that neither fix a bug nor add a feature
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (e.g., build scripts, dependencies)
- `ci`: Continuous integration-related changes
- `build`: Changes that affect the build system or dependencies

### Examples:
- `feat(layout): add PageLayout component`
- `refactor: remove unused Welcome and Layout components`
- `style: update NavCard styles`
- `chore: configure TypeScript and Deno`

#### Example of a good commit body:
```text
refactor(structure): remove unused Welcome and Layout components

These components were no longer referenced after the new page structure was introduced.
```

### Breaking Changes:
- Use `!` after the type or scope: `feat!: drop Node 14 support`
- Or include a `BREAKING CHANGE:` footer in the commit body

**Do Not:**
- List every file or sub-change in the commit message.
- Combine unrelated changes in a single commit.
- Use generic summaries like "update project" or "misc changes".
- Use bullet lists or changelog-style bodies in commits.

## Atomic Commits
- Each commit should represent **one logical change**.
- Avoid bundling unrelated changes in a single commit.
- Use **interactive staging** (`git add -p`) to split changes when needed.

## Pull Request (PR) Guidelines
- PR titles should follow the same format as commit messages.
- Keep PRs **focused and small**; prefer multiple PRs over one large one.
- Use the PR description to provide a detailed summary or bullet list of all changes.
- Always link related issues using `Closes #<issue-number>` or `Fixes #<issue-number>`.
- Request reviews from relevant team members.
- Use draft PRs for work-in-progress to gather early feedback.

## Issue Management
- Write clear, descriptive titles and summaries.
- Use labels to categorize (e.g., `bug`, `enhancement`, `question`).
- Break large tasks into smaller, actionable issues.
- Assign issues to owners and set milestones when applicable.
- Use checklists to track progress within an issue.

## Branching Strategy
- Use descriptive branch names:  
  `feature/login-form`, `bugfix/user-crash`, `chore/update-deps`
- Prefer short-lived branches and delete them after merging.
- Rebase before merging to keep history clean (unless using squash merges).