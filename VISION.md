# Croissant Furtif 🥐🥷 — Vision Produit

> **Boussole stratégique et technique du projet.**  
> Ce document définit la vision à long terme, les principes non négociables, ainsi que la trajectoire du premier produit phare : **Croissant Furtif Chat**.

---

## 🎯 1. La Vision Globale : L'Écosystème Zero-Knowledge

La confidentialité numérique ne doit plus être un compromis réservé aux experts en cryptographie ni dépendre de la bonne foi d'hébergeurs tiers. 

**Croissant Furtif** a pour mission de bâtir une suite d'outils numériques grand public et professionnels fondée sur le paradigme **Zero-Knowledge (ZK)** :
> *« Ce que le serveur ne possède pas, il ne peut ni le fuiter, ni le vendre, ni se le faire saisir. »*

### Feuille de route modulaire de la suite ZK :
1. **Étape 1 (Fondation & Flagship)** : **Croissant Furtif Chat** — Messagerie instantanée éphémère et décentralisée chiffrée de bout en bout, sans compte ni numéro de téléphone.
2. **Étape 2 (Expansion Produits)** :
   * **Croissant Furtif Vault / Drop** : Partage éphémère et sécurisé de secrets, tokens et documents avec auto-destruction (*burn-on-read*).
   * **Croissant Furtif Notes & Workspace** : Prise de notes et organisation collaborative synchronisées de façon chiffrée.
   * **SDK / Micro-services ZK réutilisables** : Extraction des briques cryptographiques client-side pour propulser d'autres cas d'usage (ex. facturation confidentielle, coffres-forts partagés).

---

## 💬 2. Produit Phare #1 : Croissant Furtif Chat

### 2.1 Proposition de Valeur Unique (UVP)
Une messagerie web instantanée, ultra-légère, accessible en un clic sans installation, garantissant un **anonymat total** et une **étanchéité cryptographique absolue** :
* **Zéro identifiant centralisé** : Ni numéro de téléphone, ni adresse email requise.
* **Chiffrement E2E Zero-Knowledge** : Les clés privées ne quittent jamais le navigateur.
* **Furtivité & Éphémérité** : Les messages s'auto-détruisent et le serveur n'est qu'un relais aveugle sans mémoire persistante.

### 2.2 Personas Cibles
* **L'utilisateur soucieux de sa vie privée** : Souhaite échanger avec ses pairs sans que ses métadonnées soient collectées, vendues ou profilées.
* **Les professionnels de la sécurité, développeurs et juristes** : Besoin d'un canal jetable instantané pour échanger des identifiants, tokens, clés privées ou informations confidentielles sans laisser de trace sur des serveurs tiers.
* **L'utilisateur occasionnel "No-Friction"** : Veut ouvrir une discussion privée avec un contact sans l'obliger à télécharger une application lourde ou à créer un compte.

---

## ⚙️ 3. Piliers Architecturaux et Principes Techniques

Pour que les agents autonomes puissent concevoir et implémenter les fonctionnalités de manière cohérente, les principes suivants sont stricts et immuables :

### A. Chiffrement Client-First (Web Crypto API)
* Toutes les opérations cryptographiques (génération de paires de clés asymétriques ECDH / X25519, chiffrement symétrique AES-256-GCM) sont exécutées côté client via les API natives standard du navigateur.
* **Interdiction absolue** de faire transiter une clé privée, une phrase secrète ou un message en clair par le réseau.

### B. Le Serveur comme « Relais Aveugle » (*Dumb Relay*)
* Le backend ne connaît ni le contenu des messages, ni l'identité réelle des utilisateurs.
* Rôle du backend : acheminer des blobs de données chiffrées opaques via WebSockets / SSE / WebRTC signalling, et gérer des boîtes aux lettres temporaires en mémoire vive avec TTL (Time To Live).
* Aucune conservation d'historique en base de données sur le serveur.

### C. Gestion des Contacts & Identité Furtive
* L'identité d'un utilisateur est son empreinte cryptographique publique.
* L'invitation et l'appairage se font par **lien furtif** (le secret d'échange réside dans le fragment d'URL `#hash`, jamais transmis au serveur) ou par **QR Code** en face-à-face.
* Le carnet de contacts et l'historique de session sont stockés localement sur le poste client (ex. `IndexedDB` chiffré).

### D. Bouton de Panique & Purge Instantanée
* En cas de besoin, l'utilisateur dispose d'un mécanisme de suppression d'urgence effaçant instantanément toutes les clés locales, sessions et historiques de l'appareil.

---

## 🗺️ 4. Périmètre Fonctionnel

### 📦 MVP (Minimum Viable Product)
- [ ] **Génération d'identité locale** : Création instantanée d'un profil anonyme et de son trousseau de clés au lancement de l'application.
- [ ] **Lien d'invitation furtif 1-to-1** : Création d'une conversation par URL partageable avec clé partagée dans le hash d'URL.
- [ ] **Messagerie temps réel chiffrée** : Envoi et réception de messages chiffrés de bout en bout (AES-GCM) relayés par WebSockets.
- [ ] **Auto-destruction des messages** : Paramétrage d'un délai d'expiration (TTL) et purge automatique dès lecture (*burn-on-read*).
- [ ] **Carnet de contacts local** : Sauvegarde locale des contacts et vérification des empreintes de clés.

### 🚀 Phase 2 (Évolutions du Tchat)
- [ ] **Salons de groupe chiffrés** (protocole multi-destinataires).
- [ ] **Partage de pièces jointes éphémères** chiffrées par morceaux (*chunk streaming*).
- [ ] **Appels audio P2P chiffrés** via WebRTC avec signalisation ZK.
- [ ] **Export / Import chiffré du trousseau** pour synchronisation manuelle entre appareils.

### 🌐 Phase 3 (Expansion de la Suite ZK)
- [ ] **Croissant Furtif Vault** : Module dédié au partage de secrets et credentials jetables à durée de vie contrôlée.
- [ ] **SDK Cryptographique open-source** : Packaging des briques client pour réutilisation par des tiers.

---

## 📊 5. Critères de Succès & Métriques Clés

* **Sécurité & Zero-Knowledge** : 100 % des tests d'interception réseau confirment que seuls des payloads chiffrés transitent ; aucune clé privée n'est jamais exposée.
* **Rapidité d'accès** : Temps d'initialisation d'une session de tchat < 2 secondes (sans compte ni onboarding fastidieux).
* **Fiabilité du relais** : Acheminement temps réel des messages < 150 ms en conditions normales de réseau.
* **Intégrité du code** : Découpage strict entre le relais backend et l'interface frontend, facilitant les revues de code automatisées et les audits de sécurité.
