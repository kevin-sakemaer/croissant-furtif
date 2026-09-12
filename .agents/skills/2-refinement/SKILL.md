---
name: 2-refinement
description: Refines GitHub issues (ideation, security findings, or bugs), deepens requirements and root causes, assesses technical feasibility, and marks them as 'refined'. Use this skill to clarify and qualify any raw issue into a structured initiative.
---

# Skill: 2-refinement

This skill takes raw issues — whether from `ideation`, `security` audits, or `bug` reports — and conducts a thorough technical and functional refinement. It documents boundaries, acceptance criteria, attack vectors or reproduction steps, and marks the issue with the `refined` label without losing its type identity.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: List Issues Awaiting Refinement
Check for pending issues across all categories:

```bash
# Check raw ideation issues
gh issue list --label "ideation"

# Check security findings awaiting refinement
gh issue list --label "security"

# Check bug reports awaiting refinement
gh issue list --label "bug"
```

If an issue ID is provided, target that issue directly.

### Step 2: Read Issue Context
Examine the targeted issue and its discussion history:

```bash
gh issue view <id> --comments
```

### Step 3: Conduct Tailored Refinement Analysis

Adapt the refinement depth to the issue type:

#### A. For `ideation` issues:
1. **Scope Boundaries**: In-scope vs explicitly out-of-scope.
2. **Immediate Feasibility & Prerequisites**: Does this issue build directly on already merged code? If it requires multiple unbuilt foundations or a 40-step prerequisite chain, de-scope or break it down into the immediate, standalone next brick.
3. **Technical Feasibility**: Architecture decisions, affected components, dependencies.
4. **UI/UX Need**: Is design required (Step 4) or is it headless?
5. **Acceptance Criteria**: Testable user stories and edge cases.

#### B. For `security` issues:
1. **Threat Model & Severity**: Attack vector, CVSS / severity rating, affected endpoints/files.
2. **Blast Radius**: What data or permissions could be compromised?
3. **Remediation Strategy**: Code patch, dependency upgrade, or configuration hardening.
4. **Validation Test**: How to verify the vulnerability is mitigated without regression.

#### C. For `bug` issues:
1. **Reproduction Steps**: Exact inputs, environment, and sequence to trigger the bug.
2. **Expected vs Actual Behavior**: Clear delta.
3. **Root Cause Analysis**: Probable failure point in code or state.
4. **Acceptance Criteria**: Regression test criteria.

---

### Step 4: Ensure Label Exists
Create or update the `refined` label:

```bash
gh label create refined --description "Refined and structured issue ready for prioritization" --color "0075CA" --force
```

### Step 5: Post Refinement & Update Labels
1. Post the refinement findings as a structured comment:

```bash
gh issue comment <id> --body "### 🔍 Refinement Summary

#### Problem / Scope Definition
- **In-Scope**: <Key items>
- **Out-of-Scope**: <Explicit exclusions>

#### Technical Analysis
- **Root Cause / Architecture**: <Details>
- **UI/UX Needed**: <Yes / No>
- **Security / Stability Impact**: <Assessment>

#### Detailed Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>
- [ ] <Criterion 3>

#### Complexity Assessment
- **Estimated Effort**: <S / M / L>"
```

2. Update labels (Strict Single Stage Tag Rule):
Remove the previous stage tag and add `refined`. Do NOT touch any human-assigned priority tag (e.g. `priority`, `priority:high`):

```bash
gh issue edit <id> --remove-label "ideation" --add-label "refined"
```

If the issue had a temporary intake tag (like a raw `security` or `bug` tag from audit/reporting), remove it as well so only `refined` (plus any human priority tag) remains:

```bash
gh issue edit <id> --remove-label "bug,security,ideation" --add-label "refined"
```

### Step 6: Verify
Confirm the updated state of the issue:

```bash
gh issue view <id>
```
