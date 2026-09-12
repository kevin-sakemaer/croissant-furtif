# Architecture & Stack Technique

Ce document sert de source de vérité unique pour les choix technologiques et architecturaux du projet.
Il est initialisé lors de la phase de **Bootstrap** (via les skills `1-ideation` -> `2-refinement` -> `3-selection` -> `5-specification`) et sert de référence au skill `specialize-skills` pour configurer les outils et checklists des agents.

---

## 🎯 Statut du Socle Technique
*Statut actuel : En attente du premier cycle d'idéation et de sélection d'architecture.*

---

## ⚙️ 1. Back-end Stack

| Élément | Choix Technologique | Justification / Notes |
| :--- | :--- | :--- |
| **Langage & Runtime** | *À définir* (ex: TypeScript / Node, Go, Python) | |
| **Framework Web** | *À définir* (ex: Fastify, Express, Gin, FastAPI) | |
| **Base de Données** | *À définir* (ex: PostgreSQL, SQLite, Redis) | |
| **ORM / Accès Données**| *À définir* (ex: Prisma, Drizzle, GORM, SQLAlchemy)| |
| **Validation Schéma** | *À définir* (ex: Zod, TypeBox, Pydantic) | |
| **Framework de Tests** | *À définir* (ex: Vitest, Jest, `go test`, Pytest) | Commande : `<test-command>` |
| **Linter & Formatter** | *À définir* (ex: ESLint, Biome, Ruff, Golangci) | Commande : `<lint-command>` |

---

## 🖥️ 2. Front-end Stack

| Élément | Choix Technologique | Justification / Notes |
| :--- | :--- | :--- |
| **Langage** | *À définir* (ex: TypeScript) | |
| **Framework UI** | *À définir* (ex: React, Next.js, Vue, Svelte) | |
| **Composants & CSS** | *À définir* (ex: Tailwind CSS, Radix UI, Shadcn) | |
| **State Management** | *À définir* (ex: Zustand, TanStack Query, Redux) | |
| **Client HTTP / API** | *À définir* (ex: Fetch natif, Axios, orval) | |
| **Framework de Tests** | *À définir* (ex: Vitest + Testing Library, Playwright)| Commande : `<test-command>` |
| **Linter & Formatter** | *À définir* (ex: ESLint, Prettier, Biome) | Commande : `<lint-command>` |

---

## 📁 3. Structure du Répertoire & Conventions

```text
croissant-furtif/
├── .agents/skills/      # Compétences du workflow SDLC
├── docs/                # Documentation technique
├── ...                  # Code source (arborescence définie lors du choix de stack)
├── ARCHITECTURE.md      # Ce document (source de vérité technique)
├── README.md            # Présentation générale
└── VISION.md            # Vision produit et stratégique
```

---

## 🛡️ 4. Outils Qualité & Sécurité

- **Scanner de Vulnérabilités** : `<security-audit-command>` (ex: `npm audit`, `pip-audit`, `govulncheck`)
- **Vérification Statique** : `<typecheck-command>` (ex: `tsc --noEmit`, `mypy`)
