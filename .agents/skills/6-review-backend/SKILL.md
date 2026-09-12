---
name: 6-review-backend
description: Conducts an expert code review of backend Pull Requests according to the chosen stack best practices, inspects diffs, evaluates security, performance, test coverage, and submits approval or change requests using the GitHub CLI. Use this skill to ensure high code quality on backend PRs.
---

# Skill: 6-review-backend

This skill acts as a specialized senior backend reviewer for the chosen project stack, rigorously examining diffs on PRs labeled `review-backend`, ensuring adherence to specifications, security, performance, and test coverage, and recording the review verdict on GitHub.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: List PRs Awaiting Backend Review
Find open PRs waiting for review:

```bash
gh pr list --label "review-backend"
```

If a PR number is specified, focus on that PR.

### Step 2: Inspect PR Diff & Context
Retrieve full context and code diff:

```bash
gh pr view <pr-id>
gh pr diff <pr-id>
```

Identify the linked issue from the PR description and check the initial specifications:

```bash
gh issue view <issue-id> --comments
```

### Step 3: Senior Backend Review Checklist
Evaluate the code against 6 core backend standards:

1. **Specification Adherence**:
   - Are all endpoints, routes, methods, and payloads identical to the specs written in Step 4?
   - Are all response codes and error formats aligned?
2. **Security & Input Validation**:
   - Is all external input strictly validated and sanitized?
   - Are there any injection risks (SQL, NoSQL, command, path traversal)?
   - Are secrets or sensitive credentials kept out of the codebase?
3. **Data Integrity & Persistence**:
   - Are database transactions or migrations properly structured?
   - Are relations, keys, indexes, or constraints correctly configured?
4. **Performance & Resource Management**:
   - Are there N+1 query patterns or unbounded queries?
   - Are connections and file descriptors properly closed/pooled?
5. **Error Handling & Observability**:
   - Are errors caught and translated into clean HTTP/API responses?
   - Are unhandled exceptions properly guarded against?
6. **Automated Test Quality**:
   - Are unit and integration tests comprehensive?
   - Are happy paths, boundary values, and error cases tested?

---

### Step 4A: If Changes Are Required
Submit a change request on GitHub:

```bash
gh pr review <pr-id> --request-changes --body "### ⚠️ Backend Review Feedback

The following points must be addressed before approval:

1. **<Issue Category>**: <Explanation and recommended fix>
2. **<Issue Category>**: <Explanation and recommended fix>

Please update the branch in your worktree and push changes."
```

---

### Step 4B: If Code is Approved
1. Ensure the `backend-approved` label exists:

```bash
gh label create backend-approved --description "Backend PR reviewed and approved" --color "0E8A16" --force
```

2. Submit approval review:

```bash
gh pr review <pr-id> --approve --body "### ✅ Backend Review Approved

- [x] Conforms to technical specifications (Step 4).
- [x] Input validation and error handling verified.
- [x] Security and performance checks satisfied.
- [x] Automated test coverage verified.

Ready to merge via \`7-merge-backend\`."
```

3. Add label to PR:

```bash
gh pr edit <pr-id> --add-label "backend-approved"
```

### Step 5: Verify
Confirm the review status:

```bash
gh pr view <pr-id>
```
The PR is ready for `7-merge-backend`.
