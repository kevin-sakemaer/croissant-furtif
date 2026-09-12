---
name: 4-specification
description: Writes comprehensive technical specifications for ready-to-spec issues, cleanly decoupling Backend and Frontend scopes, and advances the issue to 'spec-approved' by swapping the stage tag. Use this skill to define APIs, data models, component architectures, and test criteria before coding.
---

# Skill: 4-specification

This skill takes an issue in `ready-to-spec` state, writes exhaustive technical specifications decoupled into two distinct parts (**Backend** and **Frontend**), and advances the issue to `spec-approved`.

> **Strict Tagging Rule**: An issue must carry **exactly ONE stage tag at a time** (`ideation` -> `refined` -> `ready-to-spec` -> `spec-approved` -> `dev-backend` -> `dev-frontend`). The previous stage tag (`ready-to-spec`) is removed when adding `spec-approved`.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands. No custom scripts.

---

## Workflow Steps

### Step 1: Locate the Issue
Find issues ready for technical specification:

```bash
gh issue list --label "ready-to-spec"
```

Read the complete issue history, including refinement and design notes:

```bash
gh issue view <id> --comments
```

### Step 2: Formulate Decoupled Specifications

Construct the specification with two distinct sections so they can be handled independently by backend and frontend development skills:

#### Part A: Backend Technical Specification
- **Data Models & Entities**: Field names, types, constraints, relations, and persistence requirements.
- **API Contracts**:
  - HTTP Method & Path (e.g. `POST /api/v1/resource`)
  - Request Headers & Body JSON schema
  - Response codes (200, 201, 400, 401, 404, 500) and Response JSON schema
- **Business Logic & Validation**: Strict validation rules, domain logic, edge cases.
- **Security & Authorization**: Required permissions, rate limiting, sanitization.
- **Testing Requirements**: Minimum unit test coverage, integration tests, fixture requirements.

#### Part B: Frontend Technical Specification
- **Component Architecture**: Component tree, hierarchy, and props definitions.
- **State Management**: Local state, global store, async data fetching, and cache invalidation.
- **API Integration**: How endpoints specified in Part A are consumed and handled.
- **UI State Bindings**: Mapping API states (loading, success, error) to the UI components defined in Step 3.
- **Client-Side Validation**: Form rules, instant feedback, masking.
- **Testing Requirements**: Component rendering tests, user event tests.

### Step 3: Ensure Label Exists
Create or update the `spec-approved` label:

```bash
gh label create spec-approved --description "Stage 4: Specifications written and approved, ready for backend development" --color "0E8A16" --force
```

### Step 4: Publish Specifications & Single Stage Tag Transition
Post the complete specification as a structured comment on the issue:

```bash
gh issue comment <id> --body "### 📐 Technical Specifications

---

#### ⚙️ Part 1: Backend Specification
- **Data Model**: <Entities / DB Schemas>
- **Endpoints & Contracts**:
  - \`<METHOD> <PATH>\`: Request/Response formats
- **Business Rules**: <Logic details>
- **Error Handling**: <Error codes and structures>
- **Test Plan**: <Unit & integration tests required>

---

#### 🖥️ Part 2: Frontend Specification
- **Component Tree**: <Hierarchy and reusable components>
- **State & Data Fetching**: <State management details>
- **API Consumption**: <How Part 1 APIs are called>
- **UI States**: <Binding to loading/error/empty designs>
- **Test Plan**: <Component & interaction tests required>"
```

Swap the stage tag (remove `ready-to-spec`, add `spec-approved`):

```bash
gh issue edit <id> --remove-label "ready-to-spec" --add-label "spec-approved"
```

### Step 5: Verify
Confirm the updated status:

```bash
gh issue view <id>
```
The issue is now ready for `5-dev-backend`.
