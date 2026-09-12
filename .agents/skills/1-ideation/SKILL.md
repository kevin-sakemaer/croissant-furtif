---
name: 1-ideation
description: Proposes 3 distinct, high-impact ideas aligned with VISION.md and creates GitHub issues tagged with the 'ideation' label using the GitHub CLI. In bootstrap mode (new project), focuses on technology and architectural choices. In product mode, strictly analyzes what has already been built to propose immediately actionable, incremental next steps without long prerequisite chains.
---

# Skill: 1-ideation

This skill inspects `VISION.md`, checks the repository's current state, and detects whether the project is in **Bootstrap Phase** (empty/new project awaiting technology & architecture selection) or **Product Phase** (stack established, proposing features).

> [!IMPORTANT]
> **Règle d'Incrémentalité Pragmatique (Product Mode)** :
> L'idéation doit obligatoirement s'ancrer dans ce qui est **déjà développé et mergé**. Elle ne doit jamais proposer de fonctionnalités théoriques déconnectées du terrain ou nécessitant 40 étapes préalables. Chaque proposition doit constituer **le prochain incrément logique**, directement réalisable lors du cycle suivant sur la base existante.

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
     👉 **Phase Active = Product Mode (Features & Évolutions Incrémentales)**

---

### Step 2: Inspect Current Codebase & Recent Deliveries (Product Mode)
Before formulating any new ideas in Product Mode, audit what is already live:

```bash
# 1. Check recent merges and commits
git log -n 10 --oneline
gh pr list --state merged --limit 10

# 2. Check recently closed issues
gh issue list --state closed --limit 10

# 3. Check currently open issues to avoid duplicate proposals
gh issue list --state open --limit 20
```

Inspect the existing codebase structure:
- What data models and DB tables are already created?
- What backend endpoints are active?
- What UI views/components are rendered and functional?

---

### Step 3A: Formulation in Bootstrap Mode (Projet Neuf)
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

### Step 3B: Formulation in Product Mode (Incrément Immédiat)
Formulate 3 ideas that directly build upon the existing code without intermediate blockers:

1. **Immediate Logical Next Step (Feature)**:
   - Builds directly on top of already implemented APIs, views, or data models.
   - Requires zero speculative prerequisites; deliverable in a single SDLC cycle.
2. **Architecture / Refinement of Existing Work**:
   - Hardens, optimizes, or cleans up code that was just delivered (performance, edge cases, developer tooling).
3. **UX / Flow Enhancement**:
   - Improves usability, polish, error states, or user feedback on features that already exist in the UI.

#### Strict Filtering Criteria:
- ❌ **Reject**: "Castles in the air" (ideas requiring new infrastructure, unbuilt auth layers, or multiple unreleased milestones).
- ✅ **Accept**: Vertical, end-to-end increments that provide tangible value to the user or developer right now.

---

### Step 4: Ensure GitHub Label Exists
Create or update the `ideation` label:

```bash
gh label create ideation --description "Idea proposed from VISION.md (architecture or feature)" --color "EDEDED" --force
```

---

### Step 5: Create GitHub Issues
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
  --title "<Title of Next Incremental Idea>" \
  --label "ideation" \
  --body "## Context & Motivation
<Why this idea is the next logical step and how it aligns with VISION.md>

## Foundations Already in Place
- **Builds Upon**: <Link or reference to existing components, endpoints, or closed PRs>
- **Immediate Feasibility**: <Why this can be developed right now without blocker>

## Proposed Scope
<What will be delivered in this cycle>

## Expected Impact
<Value for users, developers, or architecture>

## Initial Acceptance Criteria
- [ ] <Criterion 1>
- [ ] <Criterion 2>"
```

Repeat for all 3 proposals.

---

### Step 6: Verify and Report
List the created issues with their numbers and titles:

```bash
gh issue list --label "ideation" --limit 10
```

Present the 3 proposals clearly to the user, highlighting their direct feasibility on top of existing code for the next refinement step.
