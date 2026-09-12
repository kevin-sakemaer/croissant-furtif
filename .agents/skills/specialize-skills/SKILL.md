---
name: specialize-skills
description: Reads ARCHITECTURE.md and customizes backend/frontend dev, review, and security skills with exact CLI commands, test runners, linters, and technology-specific checklists. Use this skill once architecture and tech stack choices are documented.
---

# Skill: specialize-skills

This skill reads the confirmed architectural and technological choices from `ARCHITECTURE.md` and dynamically tailors the project's development, review, and security skills to match the exact stack. This ensures that every subsequent cycle operates with specialized commands, framework idioms, and senior review standards.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Read and Validate `ARCHITECTURE.md`
Inspect `ARCHITECTURE.md` at the project root:

- Verify that the stack has been finalized and that entries are not marked as *À définir*.
- Extract the following attributes:
  - **Backend**: Language, Web framework, Database, ORM, Test runner command, Linter command.
  - **Frontend**: Language, UI framework, Styling solution, State library, Test runner command, Linter command, Build command.
  - **Security**: Specific vulnerability scanner for the chosen ecosystem.

If the file is still a blank template, prompt the user to complete the architecture selection cycle first.

---

### Step 2: Specialize Backend Skills

#### 1. Update `5-dev-backend/SKILL.md`:
- Configure Step 4 & Step 5 with the exact build, test, and lint commands:
  - Example (Node/TypeScript): `npm run test:backend`, `npx eslint src/backend`
  - Example (Go): `go test -v ./...`, `golangci-lint run`
  - Example (Python): `pytest tests/`, `ruff check .`
  - Example (Rust): `cargo test`, `cargo clippy`
- Document database migration commands (e.g. `npx prisma migrate dev`, `alembic upgrade head`, etc.).

#### 2. Update `6-review-backend/SKILL.md`:
- Adapt the senior backend review checklist to target idiomatic patterns of the chosen language and framework:
  - **Go**: Goroutine leaks, channel deadlocks, context propagation, error wrapping.
  - **Node/TypeScript**: Event loop blocking, unhandled promise rejections, strict type assertions, connection pooling.
  - **Python**: Async/await thread blocking, type hint completeness (`mypy`), SQL query N+1 in ORM.
  - **Rust**: Unnecessary `.unwrap()`, memory leaks with `Rc`/`Arc`, trait ergonomics.

---

### Step 3: Specialize Frontend Skills

#### 1. Update `8-dev-frontend/SKILL.md`:
- Configure Step 3 & Step 4 with the exact frontend test, lint, and build commands:
  - Example: `npm test`, `npm run build`, `npm run typecheck`
- Include conventions for component layout and styling integration (e.g. Tailwind classes, CSS modules, design tokens).

#### 2. Update `9-review-frontend/SKILL.md`:
- Adapt the senior frontend review checklist to the chosen framework:
  - **React/Next.js**: Hook dependency arrays, Server vs Client components (`"use client"`), unnecessary re-renders, Next.js routing conventions.
  - **Vue/Nuxt**: Composition API best practices, reactive props destructuring, SSR hydration mismatches.
  - **Svelte/SvelteKit**: Store subscriptions, `$state` runes, load functions.
  - **Tailwind / UI**: Responsive utility consistency, dark mode compatibility, Radix/ARIA compliance.

---

### Step 4: Specialize Security Audit Skill
Update `audit-security/SKILL.md`:
- Set the primary vulnerability command in Step 2 to the exact tool matching the ecosystem:
  - `npm audit` (Node)
  - `pip-audit` (Python)
  - `cargo audit` (Rust)
  - `govulncheck ./...` (Go)

---

### Step 5: Verify Changes & Commit
1. Check the modifications made to the skills:

```bash
git diff .agents/skills/
```

2. Commit the specialized skills to version control:

```bash
git add .agents/skills/
git commit -m "chore(skills): specialize dev and review skills for chosen tech stack"
```

3. Confirm to the user:
The skills are now fully configured for the selected stack. All future feature cycles (`1-ideation` -> `11-merge-frontend`) will run with exact commands and senior-level specialized reviews.
