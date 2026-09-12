---
name: 9-dev-frontend
description: Develops frontend features in an isolated git worktree integrating with the merged backend, adheres to UI/UX designs and technical specs, runs frontend tests, and opens a Pull Request with 'Closes #<id>' using GitHub CLI. Use this skill when building client-side views and components.
---

# Skill: 9-dev-frontend

This skill implements the frontend user interface and client logic in an isolated Git worktree based on the merged backend, following the UI/UX design (Step 4) and frontend specifications (Step 5). It verifies the implementation with automated tests and opens a Pull Request configured to automatically close the parent issue upon merge (`Closes #<id>`).

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Identify the Issue and Specifications
Check the target issue for design and frontend technical specifications:

```bash
gh issue view <id> --comments
```

Carefully review:
- **UI/UX Design**: Screens, layouts, responsive behavior, and states (loading, error, empty, nominal).
- **Frontend Technical Specs**: Component breakdown, state management, and backend endpoints to call.

### Step 2: Prepare Git Worktree
1. Ensure the latest commits (including the merged backend) are fetched:

```bash
git fetch origin
```

2. Create a clean, isolated worktree for the frontend feature branch based on the updated `main`:

```bash
git worktree add -b feat/issue-<id>-frontend .worktrees/issue-<id>-frontend origin/main
```

*(Note: If working locally without remote tracking yet, use `main` directly).*

### Step 3: Implement Frontend in the Worktree
Operate strictly inside `.worktrees/issue-<id>-frontend`:
- Detect the frontend framework and tooling (e.g. React, Next.js, Vue, Svelte, Tailwind CSS, etc.).
- Build components matching the structure and states designed in Step 4.
- Implement API service integration connecting to the backend endpoints verified in Step 8.
- Handle all state transitions gracefully (loading indicators, error alerts, empty states, success confirmation).
- Ensure accessible markup (semantic HTML, keyboard navigation, aria-labels).

### Step 4: Run Automated Tests & Build
Execute frontend tests, linting, and build check inside the worktree (e.g. `npm test`, `npm run lint`, `npm run build`):
- Ensure component tests pass.
- Verify that the production build completes without errors or broken imports.

### Step 5: Commit and Push
Stage and commit changes inside the worktree with a clear message referencing the issue:

```bash
git -C .worktrees/issue-<id>-frontend add .
git -C .worktrees/issue-<id>-frontend commit -m "feat(frontend): implement <feature summary> (closes #<id>)"
git -C .worktrees/issue-<id>-frontend push -u origin feat/issue-<id>-frontend
```

### Step 6: Create Frontend Pull Request
1. Ensure the `review-frontend` label exists:

```bash
gh label create review-frontend --description "Frontend PR awaiting technical review" --color "FBCA04" --force
```

2. Create the Pull Request with `Closes #<id>` so GitHub will automatically close the issue upon merge:

```bash
gh pr create \
  --title "feat(frontend): <feature title> (#<id>)" \
  --body "## Summary
Frontend implementation for issue #<id>.

Closes #<id>

## Deliverables
- [x] UI/UX components matching designs (Step 4)
- [x] Integration with backend APIs (Step 8)
- [x] Responsive layout & accessibility verified
- [x] Automated tests and build passing

## Verification
- Test suite passing. Ready for frontend review." \
  --base main \
  --head feat/issue-<id>-frontend \
  --label "review-frontend"
```

### Step 7: Update Issue and Notify
Post an update on the parent issue:

```bash
gh issue comment <id> --body "🖥️ **Frontend Development Complete**
Pull Request submitted for review: branch \`feat/issue-<id>-frontend\`.
Next step: Skill \`10-review-frontend\`."
```
