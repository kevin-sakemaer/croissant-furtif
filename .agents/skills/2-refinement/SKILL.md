---
name: 2-refinement
description: Refines GitHub issues labeled 'ideation', deepens their requirements, assesses technical feasibility, and transitions their label to 'refined'. Use this skill to clarify and qualify raw ideas into structured initiatives.
---

# Skill: 2-refinement

This skill takes raw issues marked with the `ideation` label, conducts a thorough technical and functional refinement, documents detailed boundaries and acceptance criteria, and transitions the label to `refined`.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: List Issues Awaiting Refinement
Find all issues that are in the `ideation` stage:

```bash
gh issue list --label "ideation"
```

If an issue ID is provided by the user, target that issue. If none is specified, list the available issues and ask the user which one to refine, or proceed to refine the pending ones.

### Step 2: Read Issue Context
Examine the targeted issue:

```bash
gh issue view <id> --comments
```

### Step 3: Conduct Refinement Analysis
Analyze the issue across 4 critical pillars:
1. **Scope Boundaries**:
   - What is strictly **In-Scope**?
   - What is explicitly **Out-of-Scope** (to prevent scope creep)?
2. **Technical Feasibility & Architecture**:
   - What architectural decisions or stack choices are involved?
   - What existing systems, dependencies, or APIs are affected?
   - What are the major technical uncertainties or risks?
3. **User Experience & Interaction**:
   - Who is the primary actor?
   - What is the user journey or workflow impact?
   - Does this require visual UI/UX design (Step 4) or is it headless/backend-only?
4. **Acceptance Criteria & Edge Cases**:
   - Clear, testable acceptance criteria (Given/When/Then or checklist).
   - Known edge cases and failure modes.

### Step 4: Ensure Label Exists
Create or update the `refined` label:

```bash
gh label create refined --description "Refined and structured issue ready for prioritization" --color "0075CA" --force
```

### Step 5: Post Refinement & Transition Labels
Update the issue on GitHub:
1. Post the refinement findings as a structured comment:

```bash
gh issue comment <id> --body "### 🔍 Refinement Summary

#### Scope
- **In-Scope**: <Key inclusions>
- **Out-of-Scope**: <Explicit exclusions>

#### Technical Considerations
- **Stack & Architecture Impact**: <Impact notes>
- **Risks & Unknowns**: <Identified risks>
- **UI/UX Needed**: <Yes / No>

#### Detailed Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>
- [ ] <Criterion 3>

#### Complexity Assessment
- **Estimated Effort**: <S / M / L>"
```

2. Swap the labels from `ideation` to `refined`:

```bash
gh issue edit <id> --remove-label "ideation" --add-label "refined"
```

### Step 6: Verify
Confirm the updated state of the issue:

```bash
gh issue view <id>
```
