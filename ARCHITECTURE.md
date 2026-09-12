# Architecture & Stack Technique

Ce document sert de source de vérité unique pour les choix technologiques et architecturaux du projet.
Il est initialisé lors de la phase de **Bootstrap** (via les skills `1-ideation` -> `2-refinement` -> `3-selection` -> `5-specification`) et sert de référence au skill `specialize-skills` pour configurer les outils et checklists des agents.

---

## 🎯 Statut du Socle Technique
*Statut actuel : Validé et en cours de déploiement (Option Zig + Svelte 5).*

---

## ⚙️ 1. Back-end Stack

| Élément | Choix Technologique | Justification / Notes |
| :--- | :--- | :--- |
| **Langage & Runtime** | **Zig 0.15+** | Performances natives extrêmes, allocateurs mémoires explicites (`std.heap.ArenaAllocator`), binaire autonome sans runtime externe. |
| **Framework Web** | **Zig Native Standard Library / httpz** | Relais aveugle léger (*dumb relay*), zéro dépendance lourde, transport WebSocket & HTTP épuré. |
| **Base de Données** | **In-Memory Volatile (Zero Persistence)** | Pas de base de données disque. Tables de hachage volatiles (`std.StringHashMap`) en mémoire vive avec purge TTL automatique et écrasement physique `@memset` (Burn-on-Read). |
| **ORM / Accès Données**| **Aucun** | Le serveur n'a aucune persistance et ne manipule que des enveloppes chiffrées opaques sans inspection. |
| **Validation Schéma** | **Zig Structs & `std.json`** | Désérialisation stricte des enveloppes `{ type, room, payload, nonce }`. |
| **Framework de Tests** | **`zig build test`** | Commande : `cd server && zig build test` |
| **Linter & Formatter** | **`zig fmt`** | Commande : `cd server && zig fmt --check src/` |

---

## 🖥️ 2. Front-end Stack

| Élément | Choix Technologique | Justification / Notes |
| :--- | :--- | :--- |
| **Langage** | **TypeScript 5+** | Typage strict pour l'orchestration des flux cryptographiques et de l'état de l'application. |
| **Framework UI** | **Svelte 5** | Réactivité native via les Runes (`$state`, `$derived`), compilation sans Virtual DOM, bundle ultra-compact (< 20KB). |
| **Composants & CSS** | **Tailwind CSS v4** | Utilitaire CSS ultra-rapide et responsive, sans surcharge de runtime. |
| **State Management** | **Svelte Stores / Runes + IndexedDB** | Gestion d'état locale éphémère et trousseau local chiffré. |
| **Client Cryptographique & Relais**| **Web Crypto API native + WebSocket** | Chiffrement ECDH X25519 & AES-256-GCM natif navigateur, client WebSocket léger. |
| **Framework de Tests** | **Vitest + @testing-library/svelte** | Commande : `cd client && pnpm test` |
| **Linter & Formatter** | **Biome** | Commande : `cd client && npx @biomejs/biome check .` |

---

## 📁 3. Structure du Répertoire & Conventions

```text
croissant-furtif/
├── .agents/skills/      # Compétences du workflow SDLC
├── client/              # Application Frontend Svelte 5 (UI, Web Crypto API, client WebSocket)
│   ├── src/
│   │   ├── lib/
│   │   │   ├── crypto/  # Primitives cryptographiques Web Crypto API
│   │   │   └── relay/   # Client WebSocket vers le relais
│   │   ├── App.svelte
│   │   └── main.ts
│   ├── package.json
│   └── vite.config.ts
├── server/              # Serveur Backend Relais Aveugle en Zig 0.15+
│   ├── src/
│   │   ├── main.zig     # Point d'entrée exécutable du serveur relais
│   │   ├── root.zig     # Bibliothèque du relais
│   │   ├── session.zig  # Gestion mémoire volatile des salons & Burn-on-Read
│   │   └── relay.zig    # Traitement des paquets et enveloppes opaques
│   ├── build.zig
│   └── build.zig.zon
├── docs/                # Documentation technique
├── ARCHITECTURE.md      # Ce document (source de vérité technique)
├── README.md            # Présentation générale
└── VISION.md            # Vision produit et stratégique
```

---

## 🛡️ 4. Outils Qualité & Sécurité

- **Scanner de Vulnérabilités & Audit Mémoire** : `git grep -iE 'TODO|FIXME|allocator.leak' server/` & `cd client && pnpm audit`
- **Vérification Statique** : `cd server && zig build test` & `cd client && pnpm check`
