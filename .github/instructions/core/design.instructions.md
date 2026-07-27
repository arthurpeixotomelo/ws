---
description: 'Comprehensive design principles covering architecture, code quality, and data modeling.'
applyTo: '**'
---

# Design & Architecture Principles

## Core Patterns & Principles 🧭

- 🔄 **Modular/Hexagonal Architecture (Ports & Adapters):** Split core business logic from external systems via well-defined interfaces.
- 🎯 **Single Responsibility Principle (SRP):** Each module, function, or class should have one clear responsibility.
- 🔍 **Separation of Concerns:** Keep business logic, API integrations, and presentation in separate modules.
- 🚪 **Open/Closed Principle:** Design modules to be open for extension but closed for modification.
- 💉 **Dependency Injection:** Inject dependencies (loggers, clients, config) where possible to improve testability and flexibility.
- ❄️ **Immutability:** Prefer immutable data structures and avoid mutating shared state.
- ⚡ **Fail Fast & Defensive Programming:** Validate inputs and fail early with clear errors.
- 🛠️ **Configuration as Code:** Store all configuration in environment variables or config files, never in code.
- 🐣 **YAGNI (You Aren’t Gonna Need It):** Don’t add features or abstractions until they are needed.
- 🤓 **KISS (Keep It Simple, Stupid):** Prefer simple, straightforward solutions over complex ones.
- 📚 **Documentation-Driven Development:** Write or update documentation as you design new features or refactor code.
- 🛡️ **Centralized Error Handling & Logging:** Handle errors in a consistent way and use structured logging, avoiding sensitive data leaks.
- 🔄 **Consistent Error & Response Formats:** Ensure handlers and utilities return errors and responses uniformly.
- 🔺 **Test Pyramid:** Favor more unit tests than integration tests, and more integration tests than end-to-end tests. Keep tests fast and focused.
- **Pre-release App**: This application is currently in pre-release. It is not intended for production use and may contain bugs or incomplete features. **NEVER** account for backwards-compatibility in this codebase. If you need to make a change that breaks backwards compatibility, do so without hesitation, since this version WILL NOT be used in production.

## Code-Level Design Principles (Object Calisthenics)

1. **One Level of Indentation per Method**: Ensure methods are simple. Extract methods to reduce nesting.
2. **Don't Use the ELSE Keyword**: Use early returns and guard clauses. Fail fast.
3. **Wrap Primitives and Strings**: Encapsulate primitives in value objects (e.g., `Age`, `Email`) to provide context and behavior.
4. **First Class Collections**: Encapsulate collections in classes. A class with a collection should contain no other member variables.
5. **One Dot per Line**: Follow the Law of Demeter. Avoid chaining method calls that reach deep into object graphs.
6. **Don't Abbreviate**: Use meaningful names. Avoid `U`, `N`, etc.
7. **Keep Entities Small**: Max 50 lines per class, 10 methods. Single responsibility.
8. **No Classes with More Than Two Instance Variables**: Encourages high cohesion. (Loggers/Services don't count).
9. **No Getters/Setters in Domain Classes**: Tell, Don't Ask. Use private constructors and static factory methods.

## Data Architecture & Modeling

### Data Modeling Principles
- **Star Schema (Dimensional Modeling)**:
  - **Dimension Tables**: Descriptive entities (Products, Customers). Surrogate keys. Wide and shallow.
  - **Fact Tables**: Measurable events (Sales). Foreign keys + measures. Narrow and deep.
  - **Relationships**: One-to-Many (Dim -> Fact). Avoid Many-to-Many and Bi-directional filtering.
- **Normalization**: 3NF for operational DBs. Star Schema for analytics.
- **Naming**: Singular tables/columns (`customer`, `order_id`). Snake_case.

### Database Standards
- **Primary Keys**: Mandatory for every table (`id`).
- **Audit Columns**: `created_at`, `updated_at`.
- **Constraints**: NOT NULL by default. Enforce Foreign Keys.
- **Indexing**: Index FKs and frequent query columns. Avoid over-indexing.
- **File Organization**: `db/{migrations,seeds,schema}/`.

### SQL Development
- **Style**: Uppercase keywords (SELECT, WHERE). Consistent indentation.
- **Query Structure**: Explicit JOINs. SARGable WHERE clauses.
- **Stored Procedures**: Parameterize queries. Handle transactions.

### Power BI & Analytical Specifics
- **Date Tables**: Dedicated Date dimension with hierarchy.
- **SCD**: Type 1 (Overwrite) or Type 2 (History) as needed.
- **Performance**: Import Mode (optimize types/columns) vs DirectQuery (optimize source indexes).

## API Strategy 🛣️

- 📜 **Versioning & Deprecation:** Embed version (e.g., `v1`) in endpoint paths or headers.
- 🤝 **Contract-First Testing & API Governance:** Use Pact/contract tests; publish breaking-change calendars.

## Security 🔒

- ⚙️ **OAuth 2.0 & Least Privilege:** Request only needed scopes; rotate tokens.
- 🔍 **Supply-Chain Security:** SBOM, dependency scans, block critical CVEs.
- 🏷️ **Immutable Releases:** Build once, deploy everywhere.
- 📝 **Verify & Throttle:** Validate signatures, rate limits, circuit breakers.
- 🧰 **Defensive Coding:** SAST in CI, log security events.

## Resilience & Observability 🔭

- 🔁 **Retries & Backoff:** Handle transient failures.
- 🔎 **Distributed Tracing:** OpenTelemetry for full flows.
- 💥 **Chaos Engineering:** Regular fault injection.
- 🎯 **SLOs:** Monitor metrics against budgets.
- 🏷️ **Log Correlation:** Trace IDs for all actions.

## DevOps & CI/CD ⚙️

- 🤖 **GitHub Actions:** Automate lint/test/scan.
- 🌐 **IaC:** Terraform/Pulumi for infrastructure.

## Integration Patterns 🔗

- 🔔 **Webhooks:** Subscribe minimally.
- 🔄 **Event-Driven:** Publish to message brokers.
- 🪄 **Saga Patterns:** Orchestrate multi-step workflows.

## Virtual Collaboration & Workflow 🌐

- 📖 **Living Documentation:** Design docs in repo.
- 🚩 **Feature Flags:** Gradual rollouts.

## Data Management & Compliance 📊

- 🗑️ **Retention:** Automate purges.
- 🔐 **Encryption:** At-rest and in-transit.

## Governance & Team Flow ⚖️

- 🌿 **Branching:** Trunk-based development.
- 🗂️ **ADRs:** Record architectural decisions.
