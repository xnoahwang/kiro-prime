---
description: Project-specific context and conventions
inclusion: manual
---

# Project Context

## Stack

**Languages:**
- (e.g., TypeScript, Python, Rust)

**Frameworks:**
- (e.g., React, FastAPI, Axum)

**Key Libraries:**
- (e.g., Tailwind, SQLAlchemy, Tokio)

**Build Tools:**
- (e.g., Vite, Poetry, Cargo)

**Testing:**
- (e.g., Vitest, pytest, cargo test)

## Architecture

**Structure:**
- (e.g., monorepo, microservices, layered)

**Key Directories:**
- `src/` - 
- `tests/` - 
- `docs/` - 

**Conventions:**
- Naming: (e.g., camelCase for JS, snake_case for Python)
- File organization: (e.g., feature folders, type folders)
- Import order: (e.g., external, internal, relative)

## Development Workflow

**Local Setup:**
```bash
# Installation
npm install / pip install -r requirements.txt / cargo build

# Development server
npm run dev / uvicorn main:app --reload / cargo run

# Tests
npm test / pytest / cargo test

# Linting
npm run lint / ruff check / cargo clippy
```

**Git Workflow:**
- Branch naming: `feature/`, `fix/`, `refactor/`
- Commit message format: (e.g., Conventional Commits)
- PR requirements: (e.g., tests pass, reviewed)

## Known Constraints

**Performance:**
- (e.g., API response must be < 200ms)

**Security:**
- (e.g., all user input sanitized, HTTPS only)

**Compatibility:**
- (e.g., Node 18+, Python 3.11+, MSRV 1.70)

## Common Tasks

**Adding a new feature:**
1. Create feature branch
2. Add tests first (TDD)
3. Implement feature
4. Update docs
5. Submit PR

**Fixing a bug:**
1. Write failing test reproducing the bug
2. Fix the bug
3. Verify test passes
4. Update relevant docs

## Decision Log

*Keep major architectural decisions here for future reference.*

**2024-01-15:** Chose FastAPI over Flask for async support
**2024-02-03:** Migrated from REST to GraphQL for better frontend flexibility

## Notes

*Any project-specific gotchas, workarounds, or context worth remembering.*
