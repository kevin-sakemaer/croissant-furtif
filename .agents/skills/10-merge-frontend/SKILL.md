---
name: 10-merge-frontend
description: Merges approved frontend Pull Requests into main, cleans up the associated Git worktree, verifies the automatic closure of the linked GitHub issue, and marks the feature delivery cycle as complete using GitHub CLI. Use this skill when finalizing full-stack feature delivery.
---

# Skill: 10-merge-frontend

This skill verifies that a frontend Pull Request is approved (`label: frontend-approved`), checks CI status, merges the PR into `main` using GitHub CLI (which automatically closes the parent issue via `Closes #<id>`), removes the Git worktree, and verifies that the parent issue is closed without orphaned tags.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Locate Approved Frontend PR
Find PRs ready for merge:

```bash
gh pr list --label "frontend-approved"
```

### Step 2: Check CI & Approval Status
Verify that review approvals and CI status are green:

```bash
gh pr view <pr-id>
gh pr checks <pr-id>
```

Identify the target issue number referenced in the PR body (e.g., `Closes #<id>`).

### Step 3: Merge the Pull Request
Execute the merge and delete the remote branch:

```bash
gh pr merge <pr-id> --squash --delete-branch
```

Because the PR body contains `Closes #<id>`, GitHub automatically closes the linked issue upon merging.

### Step 4: Synchronize Local Repository
Update local `main` branch:

```bash
git checkout main
git pull origin main
```

### Step 5: Clean Up Git Worktree
Remove the frontend worktree to keep the workspace clean:

```bash
git worktree list
git worktree remove .worktrees/issue-<id>-frontend --force
git worktree prune
```

### Step 6: Verify Issue Closure & Clean Tags
Confirm that the linked issue has been closed automatically:

```bash
gh issue view <id>
```

If the issue still has any lingering stage tag (e.g. `dev-frontend`), clean it up so only closed status remains:

```bash
gh issue edit <id> --remove-label "dev-frontend"
```

Post a final confirmation comment on the closed issue:

```bash
gh issue comment <id> --body "🎉 **Full-Stack Feature Delivered & Closed**
- **Backend PR**: Merged
- **Frontend PR**: Merged (#<pr-id>)
- **Main Branch**: Synchronized and updated
- **Worktrees**: Cleaned up

Feature cycle completed successfully."
```

### Step 7: Final Status Check
Confirm clean workspace state:

```bash
git status
git worktree list
```
The full SDLC cycle for this feature is complete!
