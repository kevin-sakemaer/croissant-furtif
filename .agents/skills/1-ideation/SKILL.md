---
name: 1-ideation
description: Proposes 3 distinct, high-impact ideas aligned with VISION.md and creates GitHub issues tagged with the 'ideation' label using the GitHub CLI. In bootstrap mode (new project), focuses on technology and architectural choices. Use this skill when initiating ideation or looking for the next improvements for the project.
---

# Skill: 1-ideation

This skill inspects `VISION.md` and detects whether the project is in **Bootstrap Phase** (empty/new project awaiting technology & architecture selection) or **Product Phase** (stack established, proposing features). It formulates 3 high-impact proposals and creates corresponding GitHub issues tagged `ideation`.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Read Project Vision & Detect Phase
1. Inspect `VISION.md` at the project root:
   - Check if `VISION.md` exists. If missing, prompt to define it first.
   - Extract core goals, product purpose, performance requirements, and user expectations.
2. Check `ARCHITECTURE.md`:
   - If `ARCHITECTURE.md` does not exist or still indicates `*Statut actuel : En attente du premier cycle d'idéation*`:
     👉 **Phase Active = Bootstrap Mode (Choix de Stack & Architecture)**
   - If `ARCHITECTURE.md` has confirmed and specified technologies:
     👉 **Phase Active = Product Mode (Features & Évolutions)**

---

### Step 2A: Formulation in Bootstrap Mode (Projet Neuf)
When no stack is confirmed yet, the 3 proposals **MUST focus on architectural and technological foundations**:

- **Proposition 1**: Stack option 1 (e.g., focused on high performance and minimal footprint).
- **Proposition 2**: Stack option 2 (e.g., focused on developer velocity, type safety, and rich ecosystem).
- **Proposition 3**: Stack option 3 (e.g., modern lightweight or specialized stack matching the specific domain of `VISION.md`).

Each stack proposition must articulate:
- Backend language, framework, database, and test suite.
- Frontend framework, UI toolkit, and state management.
- Directory layout (monorepo vs decoupled folders).
- Strengths and trade-offs regarding the objectives in `VISION.md`.

---

### Step 2B: Formulation in Product Mode (Socle Établi)
When the stack is already documented in `ARCHITECTURE.md`, formulate 3 ideas across:
1. **Feature / User Value**: Direct functional capability for the user.
2. **Architecture / Refactoring**: Modular improvement or performance optimization on the chosen stack.
3. **Workflow / UX**: Simplification of user interaction or developer tooling.

---

### Step 3: Ensure GitHub Label Exists
Create or update the `ideation` label:

```bash
gh label create ideation --description "Idea proposed from VISION.md (architecture or feature)" --color "EDEDED" --force
```

---

### Step 4: Create GitHub Issues
Publish each proposal as a separate issue using `gh issue create`:

#### In Bootstrap Mode:
```bash
gh issue create \
  --title "Architecture & Stack: <Option Name>" \
  --label "ideation" \
  --body "## 🏗️ Architecture & Technology Proposal
**Focus**: <Summary of the stack approach>

## Recommended Technologies
- **Backend**: <Language, Web Framework, DB, ORM, Test runner>
- **Frontend**: <Language, UI Framework, Styling, State, Test runner>
- **Tooling**: <Package manager, Linters, Monorepo/Structure>

## Alignment with VISION.md
<Why this stack serves the vision goals>

## Pros & Cons
- **Pros**: <Advantages>
- **Cons / Risks**: <Trade-offs>

## Acceptance Criteria
- [ ] Document final decision in \`ARCHITECTURE.md\`
- [ ] Run \`specialize-skills\` to adapt workflow to chosen stack"
```

#### In Product Mode:
```bash
gh issue create \
  --title "<Title of Idea>" \
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

Repeat for all 3 proposals.

---

### Step 5: Verify and Report
List the created issues with their numbers and titles:

```bash
gh issue list --label "ideation" --limit 10
```

Present the 3 proposals clearly to the user, highlighting their numbers for the next refinement step.
