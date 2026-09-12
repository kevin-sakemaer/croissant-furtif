---
name: 4-design
description: Designs the UI/UX for selected issues if required (wireframes, user flow, component states) or determines that no UI/UX is needed, then marks the issue as 'ready-to-spec'. Use this skill when shaping user interface and interaction patterns.
---

# Skill: 4-design

This skill takes an issue that has been selected (`label: selected`), assesses whether user interface or user experience work is required, designs the visual and interaction specifications (or explicitly documents the absence of UI need), and transitions the issue to `ready-to-spec`.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Identify the Selected Issue
Locate issues tagged with `selected`:

```bash
gh issue list --label "selected"
```

If multiple issues exist or a specific issue number is passed, view its full description and refinement notes:

```bash
gh issue view <id> --comments
```

### Step 2: Determine UI/UX Requirement
Check the refinement notes:
- **UI/UX Needed**: The feature involves user-facing pages, dialogs, forms, components, CLI interactive flows, or visual layouts.
- **No UI/UX Needed**: The feature is pure backend, data processing, architectural refactor, or headless automation.

---

### Step 3A: When UI/UX is Needed
Produce a detailed UI/UX specification covering:

1. **User Flow & Navigation**:
   - Entry point, intermediate actions, exit point.
   - User feedback at each step.
2. **Layout & Wireframes**:
   - Structured screen hierarchy (header, main panel, sidebar, footer).
   - Component layout (ASCII wireframe or Mermaid diagram).
3. **Component States**:
   - **Default / Populated**: How standard data looks.
   - **Empty State**: What the user sees when no data exists (with call-to-action).
   - **Loading State**: Skeletons, spinners, or progress indicators.
   - **Error State**: In-line validation, toast alerts, or recovery options.
4. **Responsive & Accessibility (a11y)**:
   - Mobile vs desktop layout changes.
   - Keyboard navigation and ARIA attributes.

Post the design spec directly to the issue:

```bash
gh issue comment <id> --body "### 🎨 UI/UX Design Specification

#### User Flow
<Description or Mermaid flowchart>

#### Layout & Wireframe
\`\`\`text
<ASCII wireframe or layout diagram>
\`\`\`

#### State Specifications
- **Empty State**: <Details>
- **Loading State**: <Details>
- **Error States**: <Details>

#### Interaction & Accessibility
- **Interactions**: <Hover, clicks, transitions>
- **Accessibility**: <Keyboard, aria-labels, contrast>"
```

---

### Step 3B: When UI/UX is NOT Needed
Post an explicit waiver comment on the issue:

```bash
gh issue comment <id> --body "### 🎨 UI/UX Design Specification
**Status**: Skipped (Headless / Backend / Architectural issue)
No visual UI/UX design is required for this scope."
```

---

### Step 4: Ensure Label Exists & Transition
Create the `ready-to-spec` label if it does not exist:

```bash
gh label create ready-to-spec --description "Design phase complete or exempt, ready for technical specification" --color "D93F0B" --force
```

Add the label to the issue:

```bash
gh issue edit <id> --add-label "ready-to-spec"
```

### Step 5: Verify
Confirm the updated state:

```bash
gh issue view <id>
```
