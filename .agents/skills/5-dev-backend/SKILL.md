---
name: 5-dev-backend
description: Selects the next appropriate 'spec-approved' issue (honoring human-placed priority tags first), develops backend features in an isolated git worktree, runs tests, and opens a Pull Request labeled 'review-backend'. Use this skill when initiating backend implementation.
---

# Skill: 5-dev-backend

This skill inspects all issues in `spec-approved` state, selects the next priority (respecting human-assigned priority tags first, otherwise selecting the one making the most immediate sense), switches the issue stage tag to `dev-backend`, develops the backend in an isolated Git worktree, runs tests, and opens a Pull Request.

> **Strict Tagging Rule**: An issue must carry **exactly ONE stage tag at a time** (`ideation` -> `refined` -> `ready-to-spec` -> `spec-approved` -> `dev-backend` -> `dev-frontend`). The only other permitted tags are human-assigned priority tags (e.g. `priority`, `priority:high`) placed by humans to force an issue ahead of others.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Select the Target `spec-approved` Issue
List all issues ready for development:

```bash
gh issue list --label "spec-approved"
```

#### Selection Hierarchy:
1. **Human Priority Override**: Check if any `spec-approved` issue has a human-placed priority tag (e.g. `priority`, `priority:high`, `priority:urgent`). If present, that issue **MUST be selected immediately**.
2. **Immediate Logical Sense**: If no human priority tag is set, select the `spec-approved` issue that makes the most sense right now (highest immediate value, foundational building block, unblocking other work).

#### Mutually Exclusive Bootstrap Cleanup:
If the selected issue is a bootstrap architecture choice (`[Bootstrap Architecture]` in title), close all competing open architecture proposals:

```bash
# List other open bootstrap issues
gh issue list --search "[Bootstrap Architecture] in:title state:open" --json number,title

# Close competing alternatives
gh issue close <other_id> --comment "Closed in favor of selected architecture #<id>." --reason "not planned"
```

### Step 2: Transition Issue Stage Tag to `dev-backend`
Ensure the `dev-backend` label exists and swap stage tags (remove `spec-approved`, add `dev-backend`):

```bash
gh label create dev-backend --description "Stage 5: Backend feature in active development" --color "D4C5F9" --force
gh issue edit <id> --remove-label "spec-approved" --add-label "dev-backend"
```

Read the technical specifications (specifically **Part 1: Backend Specification**):

```bash
gh issue view <id> --comments
```

### Step 3: Prepare Git Worktree
1. Fetch latest commits from remote:

```bash
git fetch origin
```

2. Create a clean, isolated worktree for the backend feature branch:

```bash
git worktree add -b feat/issue-<id>-backend .worktrees/issue-<id>-backend HEAD
```

*(Note: If `origin/main` is tracking remote, use `origin/main` instead of `HEAD`).*

### Step 4: Implement Backend in the Worktree
Operate exclusively inside `.worktrees/issue-<id>-backend`:
- Detect project backend stack (or read `ARCHITECTURE.md`).
- Implement data structures, models, repositories, and business logic.
- Implement endpoints/handlers matching the exact request/response schemas specified in Step 4.
- Implement input validation, error handling, and authorization rules.

### Step 5: Run Automated Tests
Execute backend unit and integration tests inside the worktree using the stack's native test runner (e.g., `npm test`, `go test ./...`, `pytest`, `cargo test`):
- Ensure all new and existing tests pass.
- Verify code formatting and linting.

### Step 6: Commit and Push
Stage and commit changes inside the worktree:

```bash
git -C .worktrees/issue-<id>-backend add .
git -C .worktrees/issue-<id>-backend commit -m "feat(backend): implement <feature summary> (refs #<id>)"
git -C .worktrees/issue-<id>-backend push -u origin feat/issue-<id>-backend
```

### Step 7: Create Backend Pull Request
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

### Step 8: Update Issue and Notify
Post an update on the parent issue:

```bash
gh issue comment <id> --body "⚙️ **Backend Development Complete**
Pull Request submitted for review: branch \`feat/issue-<id>-backend\`.
Next step: Skill \`6-review-backend\`."
```
