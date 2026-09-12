---
name: 7-merge-backend
description: Merges approved backend Pull Requests into main, cleans up the associated Git worktree, and advances the parent issue stage tag to 'dev-frontend'. Use this skill when finalizing backend delivery.
---

# Skill: 7-merge-backend

This skill verifies that a backend Pull Request is approved (`label: backend-approved`), confirms CI status, merges the PR into `main` using GitHub CLI, tears down the isolated Git worktree, and transitions the parent issue stage tag from `dev-backend` to `dev-frontend`.

> **Strict Tagging Rule**: An issue must carry **exactly ONE stage tag at a time** (`ideation` -> `refined` -> `ready-to-spec` -> `spec-approved` -> `dev-backend` -> `dev-frontend`).

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Locate Approved Backend PR
List PRs ready for merge:

```bash
gh pr list --label "backend-approved"
```

### Step 2: Check CI & Approval Status
Verify that review approvals and any CI checks pass:

```bash
gh pr view <pr-id>
gh pr checks <pr-id>
```

Ensure the PR is in a mergeable state and that no blocking conflicts exist.

### Step 3: Merge the Pull Request
Execute the merge and delete the remote branch:

```bash
gh pr merge <pr-id> --squash --delete-branch
```

### Step 4: Synchronize Local Repository
Update local `main` branch:

```bash
git checkout main
git pull origin main
```

### Step 5: Clean Up Git Worktree
Remove the backend worktree to keep the workspace clean and release resources:

```bash
git worktree list
git worktree remove .worktrees/issue-<id>-backend --force
git worktree prune
```

### Step 6: Transition Issue Stage Tag to `dev-frontend`
Extract the issue ID linked to the PR. Ensure `dev-frontend` label exists and swap the stage tag:

```bash
gh label create dev-frontend --description "Stage 7: Backend merged, ready for frontend development" --color "0075CA" --force
gh issue edit <id> --remove-label "dev-backend" --add-label "dev-frontend"
```

Post the progress update on the issue:

```bash
gh issue comment <id> --body "🚀 **Backend Successfully Merged**
Pull Request #<pr-id> has been merged into \`main\`.
All backend schemas, APIs, and business rules are now integrated.

Next step: Skill \`8-dev-frontend\` can now build the user interface against the integrated backend."
```

### Step 7: Verify Clean State
Confirm local repository state:

```bash
git status
git worktree list
```
