---
name: 1-ideation
description: Proposes 3 distinct, high-impact ideas aligned with VISION.md and creates GitHub issues tagged with the 'ideation' label using the GitHub CLI. Use this skill when brainstorming improvements, new features, or architectural enhancements for the project.
---

# Skill: 1-ideation

This skill inspects `VISION.md` at the project root, formulates 3 diverse and strategic ideas aligned with the project vision, and publishes them as GitHub issues tagged with the `ideation` label.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Read Project Vision
Inspect the project vision file at the root:
- Check if `VISION.md` exists.
- If `VISION.md` is missing, notify the user that `VISION.md` should be defined first, or ask for the guiding principles before proceeding.
- Read and extract the core objectives, target users, value proposition, and technical preferences from `VISION.md`.

### Step 2: Formulate 3 Diverse Ideas
Generate 3 distinct, high-value ideas that directly serve the vision. Diversify the categories across:
1. **Feature / User Value**: A direct capability that solves a user need or expands functionality.
2. **Architecture / Code Quality**: Structural improvements, modularity, performance, or stack standardization.
3. **Workflow / Process / UX**: Simplification of the user journey, UI clarity, or developer workflow enhancement.

Each idea must have:
- A clear, descriptive title.
- Motivation & alignment with `VISION.md`.
- Proposed scope and high-level deliverables.
- Initial success criteria / definition of value.

### Step 3: Ensure GitHub Label Exists
Create or update the `ideation` label using `gh`:

```bash
gh label create ideation --description "Raw idea proposed from VISION.md" --color "EDEDED" --force
```

### Step 4: Create GitHub Issues
Publish each idea as a separate GitHub issue using `gh issue create`:

```bash
gh issue create \
  --title "<Title of Idea 1>" \
  --label "ideation" \
  --body "## Context & Motivation
<Why this idea matters and how it aligns with VISION.md>

## Proposed Scope
<What will be delivered>

## Expected Impact
<Value for users, developers, or architecture>

## Initial Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>"
```

Repeat for Idea 2 and Idea 3.

### Step 5: Verify and Report
List the created issues with their numbers and URLs:

```bash
gh issue list --label "ideation" --limit 10
```

Present the 3 created issues clearly to the user, highlighting their numbers (e.g. `#1`, `#2`, `#3`) for the next refinement step.
