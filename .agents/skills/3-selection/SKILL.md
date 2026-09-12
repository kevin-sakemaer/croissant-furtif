---
name: 3-selection
description: Reviews refined issues, evaluates priority based on value and feasibility, and selects the next initiative to enter the delivery pipeline (label 'selected'). Use this skill when deciding which feature or task to work on next.
---

# Skill: 3-selection

This skill reviews all issues that have completed refinement (`label: refined`), evaluates their strategic value against `VISION.md`, presents a clear comparative summary, and formally selects the next item to enter the active delivery pipeline by adding the `selected` label.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: List Refined Issues
Retrieve all issues currently in the `refined` state:

```bash
gh issue list --label "refined"
```

If no issues are labeled `refined`, notify the user that issues need to pass through `2-refinement` first.

### Step 2: Analyze Candidate Initiatives
For each refined issue, read its details and comments:

```bash
gh issue view <id> --comments
```

Evaluate candidates across:
- **Strategic Impact**: How closely does it advance the core goals in `VISION.md`?
- **Effort / Complexity**: Ratio of deliverable value to effort (S / M / L).
- **Prerequisites & Dependencies**: Does it unblock other key features or require previous foundation work?
- **Quick Win vs High Impact**: Balanced sequencing.

### Step 3: Present Comparative Assessment
Synthesize candidate issues in a concise comparative matrix for the user:

| Issue # | Title | Complexity | Strategic Value | Recommendation |
| :--- | :--- | :--- | :--- | :--- |
| `#...` | `<Title>` | `S / M / L` | `High / Med` | *(e.g. Recommended: unblocks X)* |

If the user has specified which issue they want, proceed with that issue. Otherwise, present the recommendation and request confirmation.

### Step 4: Ensure Label Exists
Create or update the `selected` label:

```bash
gh label create selected --description "Prioritized issue selected for active delivery" --color "5319E7" --force
```

### Step 5: Mark Selected Issue
Apply the `selected` label and post a tracking comment:

```bash
gh issue edit <id> --add-label "selected"
gh issue comment <id> --body "🎯 **Selected for Active Development**
This issue has been prioritized for the current delivery cycle.
- **Status**: Prioritized
- **Next Step**: Skill \`4-design\` (if UI/UX is required) or \`5-specification\`."
```

### Step 6: Verify
Confirm the updated issue status:

```bash
gh issue view <id>
```
