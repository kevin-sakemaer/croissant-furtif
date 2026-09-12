---
name: 6-dev-backend
description: Develops backend features in an isolated git worktree according to specifications, runs backend tests, and opens a Pull Request referencing the GitHub issue with label 'review-backend'. Use this skill when implementing backend logic and APIs.
---

# Skill: 6-dev-backend

This skill implements the backend scope for a specified issue (`label: spec-approved`) inside an isolated Git worktree, runs the automated test suite, pushes the feature branch, and opens a Pull Request linked to the issue.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Find the Target Issue
Locate issues ready for development:

```bash
gh issue list --label "spec-approved"
```

Read the technical specifications (specifically **Part 1: Backend Specification**):

```bash
gh issue view <id> --comments
```

### Step 2: Prepare Git Worktree
1. Fetch latest commits from remote:

```bash
git fetch origin
```

2. Create a clean, isolated worktree for the backend feature branch:

```bash
git worktree add -b feat/issue-<id>-backend .worktrees/issue-<id>-backend HEAD
```

*(Note: If `origin/main` is tracking remote, use `origin/main` instead of `HEAD`).*

### Step 3: Implement Backend in the Worktree
Operate exclusively inside `.worktrees/issue-<id>-backend`:
- Detect project backend stack (e.g. Node/TypeScript, Go, Python, Rust, etc.) by inspecting existing files in the worktree.
- Implement data structures, models, repositories, and business logic.
- Implement endpoints/handlers matching the exact request/response schemas specified in Step 5.
- Implement input validation, error handling, and authorization rules.

### Step 4: Run Automated Tests
Execute backend unit and integration tests inside the worktree using the stack's native test runner (e.g., `npm test`, `go test ./...`, `pytest`, `cargo test`):
- Ensure all new and existing tests pass.
- Verify code formatting and linting.

### Step 5: Commit and Push
Stage and commit changes inside the worktree:

```bash
git -C .worktrees/issue-<id>-backend add .
git -C .worktrees/issue-<id>-backend commit -m "feat(backend): implement <feature summary> (refs #<id>)"
git -C .worktrees/issue-<id>-backend push -u origin feat/issue-<id>-backend
```

### Step 6: Create Backend Pull Request
1. Ensure the `review-backend` label exists:

```bash
gh label create review-backend --description "Backend PR awaiting technical review" --color "FBCA04" --force
```

2. Open the Pull Request linking it to the issue:

```bash
gh pr create \
  --title "feat(backend): <feature title> (#<id>)" \
  --body "## Summary
Backend implementation for issue #<id>.

Related to #<id>

## Backend Deliverables
- [x] Data models and schemas
- [x] Endpoints and business logic
- [x] Unit and integration tests

## Verification
- Automated tests passing. Ready for backend review." \
  --base main \
  --head feat/issue-<id>-backend \
  --label "review-backend"
```

### Step 7: Update Issue and Notify
Post an update on the parent issue:

```bash
gh issue comment <id> --body "⚙️ **Backend Development Complete**
Pull Request submitted for review: branch \`feat/issue-<id>-backend\`.
Next step: Skill \`7-review-backend\`."
```
