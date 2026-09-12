---
name: 3-selection
description: Evaluates and selects the next development priority using a strict hierarchy (bug > security > ideation), marks the chosen issue with label 'selected', and triggers the active delivery pipeline. Use this skill when deciding what to work on next.
---

# Skill: 3-selection

This skill evaluates candidates for the next delivery cycle according to a strict, non-negotiable priority order:
$$\mathbf{bug} \succ \mathbf{security} \succ \mathbf{ideation}$$

It inspects open issues across these tiers, presents the prioritized queue to the user, and transitions the selected issue to `selected` to trigger design and specification.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Query Issues by Strict Priority Tier

Execute queries sequentially in order of urgency:

#### Tier 1 (Highest Priority): Open Bugs
```bash
gh label create bug --description "Something isn't working" --color "D73A4A" --force
gh issue list --label "bug" --state open
```
> If any unresolved `bug` exists, it **MUST be prioritized** before security findings and before any feature or ideation ticket.

#### Tier 2 (High Priority): Open Security Vulnerabilities
If no blocking bugs are pending, inspect security issues:

```bash
gh label create security --description "Security vulnerability or audit finding" --color "B60205" --force
gh issue list --label "security" --state open
```
> If unresolved `security` issues exist, they **take precedence** over all items originating from `ideation`.

#### Tier 3 (Normal Priority): Refined Ideation Initiatives
If no open bugs and no security vulnerabilities require immediate resolution, inspect refined ideation issues:

```bash
gh issue list --label "refined" --state open
```

---

### Step 2: Formulate Prioritized Recommendation

Based on the highest active tier:
1. **If Tier 1 (Bug) is active**:
   - Recommend fixing the critical or oldest active bug.
   - Explain why features are held until stability is restored.
2. **If Tier 2 (Security) is active**:
   - Recommend remediating the highest severity vulnerability (Critical > High > Medium).
   - Explain the security threat model.
3. **If Tier 3 (Ideation) is active**:
   - Compare candidates across strategic value in `VISION.md`, complexity (S/M/L), and architectural impact.

Present the selection table to the user:

| Tier | Issue # | Type | Title | Urgency / Impact | Recommendation |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `Tier 1` | `#...` | `bug` | `<Title>` | `Critical` | *(e.g. Priority 1 - Bug)* |
| `Tier 2` | `#...` | `security` | `<Title>` | `High` | *(e.g. Priority 2 - Security)* |
| `Tier 3` | `#...` | `ideation` | `<Title>` | `Strategic` | *(e.g. Next feature)* |

Confirm with the user or proceed with the top-tier priority.

---

### Step 3: Ensure Label Exists
Create or update the `selected` label:

```bash
gh label create selected --description "Prioritized issue selected for active delivery" --color "5319E7" --force
```

### Step 4: Mark Selected Issue
Apply the `selected` label and post a tracking comment documenting the priority tier:

```bash
gh issue edit <id> --add-label "selected"
gh issue comment <id> --body "🎯 **Selected for Active Development**
- **Priority Tier**: <Tier 1 (Bug) / Tier 2 (Security) / Tier 3 (Ideation)>
- **Status**: Prioritized for current delivery cycle
- **Next Step**: Skill \`4-design\` (if UI/UX is required) or \`5-specification\`."
```

### Step 5: Verify
Confirm the updated issue status:

```bash
gh issue view <id>
```
