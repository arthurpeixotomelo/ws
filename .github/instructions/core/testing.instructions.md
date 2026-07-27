---
description: 'Comprehensive testing strategy and guidelines covering unit, integration, and E2E testing with Vitest and Playwright.'
applyTo: '**/*.{spec,test}.{ts,js,py,mts,mjs}'
---

# Testing Strategy & Guidelines

## Overview

This document outlines the testing strategy, principles, and tool-specific guidelines for ensuring code quality and reliability. It covers unit and integration testing with Vitest, and End-to-End (E2E) testing with Playwright.

## Core Testing Philosophy

- **Tests Validate Design**: If tests are hard to write, the design likely needs improvement (high coupling, low cohesion).
- **Test Pyramid**: Prioritize unit tests for logic, integration tests for component interaction, and E2E tests for critical user flows.
- **Design Principles**: Tests should reinforce SRP, loose coupling, and explicit dependencies.
- **Don't Modify for Testing**: NEVER change original code solely to make it easier to test; instead, refactor for better design which inherently improves testability.

## Vitest (Unit & Integration)

### General Guidelines
- **Scope**: Use Vitest for unit testing functions/classes and integration testing of modules.
- **Coverage**: Write tests for all new features, bug fixes, edge cases, and error handling.
- **Async**: Always use `async/await` for asynchronous code.
- **Mocking**: Use dependency injection where possible; mock external services/modules only when necessary for isolation.

### Coding Standards
- **Structure**: Use `describe` blocks to group related tests and `it` or `test` for individual test cases.
- **Assertions**: Use Vitest's built-in assertions.
- **Setup/Teardown**: Use `beforeEach`, `afterEach`, `beforeAll`, `afterAll` for test lifecycle management.

## Playwright (End-to-End)

### General Guidelines
- **Locators**: Prioritize user-facing, role-based locators (`get_by_role`, `get_by_label`, `get_by_text`) for resilience and accessibility.
- **Assertions**: Use auto-retrying web-first assertions (e.g., `expect(locator).to_have_text()`). Avoid `to_be_visible()` unless specifically testing visibility changes.
- **Timeouts**: Rely on Playwright's built-in auto-waiting. Avoid hard-coded waits.
- **Clarity**: Use descriptive test titles stating intent. Comments should explain complex logic, not simple actions.
- **Isolation**: Each test should be independent. Use fixtures/hooks for setup (e.g., logging in, navigating).

### Python Specifics
- **Imports**: `from playwright.sync_api import Page, expect`
- **Fixtures**: Use `page: Page` fixture. Use `pytest` fixtures for shared setup.
- **Naming**: Files: `test_<feature>.py`. Functions: `def test_feature_works(page: Page):`.
- **Execution**: Run with `pytest`.

### TypeScript Specifics
- **Imports**: `import { test, expect } from '@playwright/test';`
- **Structure**: Group with `test.describe()`. Use `test.step()` for logical grouping within tests.
- **Naming**: Files: `<feature>.spec.ts`.
- **Snapshots**: Use `toMatchAriaSnapshot` for accessible structure verification.
- **Execution**: Run with `npx playwright test`.

## Best Practices

### Do's
- **Do** use descriptive test names that explain *what* is being tested and *expected outcome*.
- **Do** test behavior, not implementation details.
- **Do** clean up resources (DB records, files) after tests.

### Don'ts
- **Don't** use fragile locators like XPath or CSS selectors coupled to styling.
- **Don't** share mutable state between tests.
- **Don't** comment out failing tests; fix them or skip with a reason.
