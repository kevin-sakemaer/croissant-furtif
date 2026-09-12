---
name: 9-review-frontend
description: Conducts an expert code review of frontend Pull Requests according to chosen UI stack standards, assesses responsiveness, accessibility, state management, component isolation, and submits approval or change requests using the GitHub CLI. Use this skill to ensure high frontend quality.
---

# Skill: 9-review-frontend

This skill acts as a specialized senior frontend reviewer, assessing pull requests tagged `review-frontend` for UI/UX fidelity, component quality, responsive behavior, accessibility (a11y), state management, and test coverage using the GitHub CLI.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: List PRs Awaiting Frontend Review
Find open PRs waiting for review:

```bash
gh pr list --label "review-frontend"
```

If a PR number is provided, focus directly on that PR.

### Step 2: Inspect PR Diff & Context
Retrieve full context and code diff:

```bash
gh pr view <pr-id>
gh pr diff <pr-id>
```

Identify the linked issue from the PR body and check the initial UI/UX design (Step 3) and frontend specs (Step 4):

```bash
gh issue view <issue-id> --comments
```

### Step 3: Senior Frontend Review Checklist
Evaluate the code against 6 core frontend standards:

1. **Design & UX Fidelity**:
   - Does the implementation faithfully reproduce the layouts and wireframes from Step 3?
   - Are all specified interaction states present (Empty, Loading, Error, Success)?
2. **Component Architecture & Clean Code**:
   - Are components modular, well-scoped, and cohesive?
   - Are TypeScript types / interfaces properly defined for props and API payloads?
3. **State Management & Reactivity**:
   - Is state scoped appropriately (local vs shared store)?
   - Are there redundant state synchronizations or unnecessary re-renders?
4. **Error Handling & Resilience**:
   - Does the UI handle network timeouts, HTTP 4xx, and 5xx errors gracefully?
   - Are user-friendly error messages displayed?
5. **Accessibility (a11y) & Responsiveness**:
   - Is semantic HTML used (`<button>`, `<main>`, `<nav>`, `<form>`)?
   - Are aria-labels and focus outlines preserved for keyboard users?
   - Does layout adapt smoothly across mobile, tablet, and desktop breakpoints?
6. **Automated Test Quality & Build**:
   - Are critical user interactions covered by component tests?
   - Does the production build succeed without lint or type errors?

---

### Step 4A: If Changes Are Required
Submit a change request on GitHub:

```bash
gh pr review <pr-id> --request-changes --body "### ⚠️ Frontend Review Feedback

The following items need adjustment before approval:

1. **<Category>**: <Explanation and suggested improvement>
2. **<Category>**: <Explanation and suggested improvement>

Please update the branch in your worktree and push changes."
```

---

### Step 4B: If Code is Approved
1. Ensure the `frontend-approved` label exists:

```bash
gh label create frontend-approved --description "Frontend PR reviewed and approved" --color "0E8A16" --force
```

2. Submit approval review:

```bash
gh pr review <pr-id> --approve --body "### ✅ Frontend Review Approved

- [x] UI/UX design fidelity verified against Step 3 specs.
- [x] API integration and state management verified.
- [x] Accessibility (a11y) and responsive layout verified.
- [x] Automated tests and production build passing.

Ready to merge via \`10-merge-frontend\`."
```

3. Add label to PR:

```bash
gh pr edit <pr-id> --add-label "frontend-approved"
```

### Step 5: Verify
Confirm the review status:

```bash
gh pr view <pr-id>
```
The PR is ready for `10-merge-frontend`.
