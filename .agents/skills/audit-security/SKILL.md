---
name: audit-security
description: Conducts comprehensive periodic security audits across the codebase, dependencies, configurations, and secret leaks, and reports findings as GitHub issues with label 'security'. Use this skill periodically or on-demand to safeguard project security.
---

# Skill: audit-security

This skill operates as a specialized security expert. It performs static security scans, audits third-party dependencies, searches for leaked credentials or secrets, evaluates configuration files against OWASP standards, and creates GitHub issues with the `security` label.

> **Constraint**: Uses exclusively standard `git` and GitHub CLI (`gh`) commands, and native stack audit tools. No custom scripts.

---

## Workflow Steps

### Step 1: Scan for Leaked Credentials & Sensitive Data
Search the repository for accidental secret leaks using native `git grep`:

```bash
# Check for common secret keywords in code
git grep -i -E "(password|secret|api_key|token|private_key|auth_token)\s*[:=]" -- ':!.agents' ':!*.md'

# Inspect recent commit messages and diffs for accidental credentials
git log -n 10 -p -- '*.env*' '*secret*' '*config*'
```

Ensure no private keys (`.pem`, `.key`, `id_rsa`), `.env` files, or production secrets are committed.

### Step 2: Audit Third-Party Dependencies
Detect the project ecosystem and run the native vulnerability scanner if dependencies exist:
- **Node / JavaScript / TypeScript**:
  ```bash
  npm audit --json || npm audit
  ```
- **Python**:
  ```bash
  pip-audit || pip check
  ```
- **Rust**:
  ```bash
  cargo audit
  ```
- **Go**:
  ```bash
  govulncheck ./...
  ```

Identify CVEs, high/critical severity advisories, and outdated dependencies with known vulnerabilities.

### Step 3: Configuration & Code Security Review
Inspect configuration files, route handlers, and data access patterns:
1. **CORS & Headers**: Check for wildcards (`Access-Control-Allow-Origin: *`) with credentials, missing Content-Security-Policy (CSP), or missing HTTPS enforcement.
2. **Injection Risks**: Verify query parameterization (preventing SQL/NoSQL injection) and command execution sanitization.
3. **Authentication & Authorization**: Verify that protected endpoints enforce role checks and valid session tokens.
4. **Data Exposure**: Check that stack traces or sensitive database errors are never returned to clients.

### Step 4: Ensure GitHub Label Exists
Create or update the `security` label:

```bash
gh label create security --description "Security vulnerability or audit finding" --color "B60205" --force
```

### Step 5: Open GitHub Issues for Security Vulnerabilities
For each identified risk or vulnerability, open a dedicated GitHub issue:

```bash
gh issue create \
  --title "[SECURITY] <Vulnerability Summary>" \
  --label "security" \
  --body "## 🚨 Vulnerability Description
<Detailed explanation of the vulnerability and attack vector>

## Severity Assessment
- **Severity**: <Critical / High / Medium / Low>
- **Affected Component**: \`<file or package path>\`
- **Reference**: <CVE ID, CWE, or OWASP category>

## Evidence / Reproduction
\`\`\`text
<Relevant code snippet, dependency log, or command output>
\`\`\`

## Recommended Remediation
- [ ] <Specific fix step 1>
- [ ] <Specific fix step 2>

---
*Note: This security issue enters the workflow via \`2-refinement\`. A human can apply a priority tag (e.g. \`priority:high\`) to force its implementation ahead of others in \`5-dev-backend\`.*"
```

### Step 6: Summary and Next Actions
List all open security issues:

```bash
gh issue list --label "security"
```

Notify the user of the findings. These issues will automatically be prioritized over `ideation` in `3-selection`.
