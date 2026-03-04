# Guide de Contribution

Merci de vouloir contribuer à ce projet ! Ce document décrit les bonnes pratiques et la vision pour les développements futurs.

## 🎯 Vision du projet

**ai-sandbox** est un bac à sable permettant d'explorer rapidement les outils IA (Gemini, Claude, Qwen, OpenCode) dans un environnement reproductible et observable.

### Principes directeurs

- **Simplicité** : Configuration minimale pour démarrer rapidement
- **Reproductibilité** : Même environnement sur toutes les machines
- **Observabilité** : Stack complète pour monitorer les expériences
- **Extensibilité** : Facile d'ajouter de nouveaux outils et services
- **Sécurité** : Utilisateur non-root, pas de credentials en dur

## 🔧 Bonnes pratiques

### Environnement de développement

#### Setup standard avec Docker Desktop

1. **Cloner et setup**
   ```bash
   git clone <repo>
   cd ai-docker
   ```

2. **Lancer l'environnement complet**
   ```bash
   make launch
   ```

3. **Vérifier que tous les services sont up**
   ```bash
   docker-compose ps
   ```

#### Setup alternatif avec Colima

Si vous utilisez Colima au lieu de Docker Desktop :

**macOS**
```bash
# S'assurer que Colima est en cours d'exécution
colima start

# Puis procéder comme ci-dessus
git clone <repo>
cd ai-docker
make launch
```

**Linux**
```bash
# Démarrer Colima
colima start

# Vérifier la connexion
docker ps

# Puis lancer le projet
git clone <repo>
cd ai-docker
make launch
```

**Troubleshooting Colima**

Si les volumes ne se montent pas correctement :
```bash
# Vérifier le statut de Colima
colima status

# Redémarrer Colima
colima stop
colima start

# Relancer les conteneurs
docker-compose restart
```

Si Colima n'a pas assez de ressources :
```bash
# Éditer la config (~/.colima/default/colima.yml)
# et augmenter cpu, memory, disk
colima edit

# Appliquer les changements
colima restart
```

#### Configuration des secrets

**⚠️ Important** : Avant de lancer l'environnement, configurez vos secrets dans un fichier `.env` dédié.

1. **Créer la structure de dossiers** :
   ```bash
   mkdir -p secrets
   ```

2. **Créer le fichier `.env`** :
   ```bash
   cat > secrets/.env << EOF
   GITHUB_TOKEN=votre_token_github_ici
   EOF
   ```

3. **Vérifications** :
   - Le dossier `secrets/` est dans `.gitignore`
   - Le fichier `.env` ne sera jamais commité
   - Docker Compose charge automatiquement ce fichier

### Modifications des services

- **Dockerfile** : Limiter à l'installation des essentiels
  - Toujours utiliser des versions spécifiques (pas de `latest`)
  - Nettoyer les caches après apt-get/npm
  - Maintenir la couche de sécurité (utilisateur non-root)

- **docker-compose.yml** : 
  - Documenter chaque variable d'environnement
  - Utiliser des ports cohérents (4xxx = internes, 3xxx-9xxx = accès)
  - Garder les dépendances explicites (`depends_on`)

- **Configurations** :
  - YAML : 2 espaces d'indentation
  - Commenter les configurations optionnelles
  - Utiliser des fichiers séparés pour chaque composant (observability/)

### Code et commits

#### 🚫 Workflow Git : NO PUSH ON MAIN

**⚠️ Règle importante** : Ne JAMAIS pousser directement sur `main`. Toutes les modifications doivent passer par une **feature branch** et une **Pull Request**.

#### Procédure standard

**1️⃣ Créer une feature branch**

Créez une branche avec un nom descriptif basé sur votre feature :

```bash
git checkout -b feature/sandbox-postgres
```

Exemples de noms :
- `feature/add-mcp-servers` : Ajout de nouvelles fonctionnalités
- `fix/prometheus-scrape` : Correction de bug
- `docs/update-readme` : Documentation
- `chore/update-dependencies` : Maintenance

**2️⃣ Faire vos modifications**

Modifiez les fichiers nécessaires (Dockerfile, docker-compose.yml, configs, etc.)

**3️⃣ Commit avec message clair**

```bash
git add .
git commit -m "feat: add postgres service with healthcheck"
```

Messages de commit recommandés :
```
feat: ajouter support MCP server Claude
fix: corriger endpoint Prometheus
docs: mettre à jour README observabilité
chore: mettre à jour Ollama vers latest
```

Format : Utiliser le format conventionnel (feat:, fix:, docs:, chore:)

**4️⃣ Pousser votre branche**

```bash
git push origin feature/sandbox-postgres
```

**5️⃣ Créer une Pull Request (PR)**

- Allez sur GitHub
- Créez une PR depuis votre branche vers `main`
- Décrivez clairement vos changements
- Référencez les issues si applicable
- Attendez l'auto-merge après review/CI

**6️⃣ Mettre à jour votre main local**

Une fois votre PR mergée :

```bash
git checkout main
git pull origin main
```

#### Checklist avant de pousser

- [ ] Code testé localement avec `docker-compose up`
- [ ] Messages de commit clairs et conventionnels
- [ ] README mis à jour si nécessaire
- [ ] Variables d'environnement documentées
- [ ] Pas de secrets ou credentials dans le code
- [ ] Images Docker utilisent des versions spécifiques
- [ ] Pas de fichiers de workspace commitados (`.gitignore` respecté)

### Documentation

- Mettre à jour le README si changement d'architecture
- Documenter les nouvelles variables d'environnement
- Expliquer les choix techniques dans les comentaires

## � Configuration MCP actuelle

### MCP GitHub pour Claude

Le projet supporte actuellement le MCP (Model Context Protocol) GitHub pour étendre les capacités de Claude.

#### Structure des données

- **Dossier `ai-cli-data/`** : Contient la configuration persistée des MCPs et données des CLIs IA
  - Automatiquement monté en volume dans `docker-compose.yml`
  - **⚠️ Important** : Ce dossier est dans `.gitignore` pour éviter de pousser des secrets
  - La configuration est sauvegardée dans `.claude.json`

#### Installation d'un MCP

1. Créer le dossier `ai-cli-data` (si pas déjà fait)
2. Lancer le conteneur : `make shell`
3. Installer le MCP GitHub :
   ```bash
   claude mcp add --transport http github \
     "https://api.githubcopilot.com/mcp" \
     -H "Authorization: Bearer $GITHUB_TOKEN"
   ```

#### Sécurité

- Ne jamais commiter le dossier `ai-cli-data/`
- Utiliser des tokens GitHub personnels avec permissions minimales
- Vérifier que `.gitignore` contient bien `ai-cli-data/`

## �🚀 Évolutions futures

### Phase 1 : Support MCP Servers complet

**MCP** (Model Context Protocol) offre une standardisation pour les outils IA.

#### Tâches prévues

1. **Configuration Claude MCP**
   - Ajouter support des MCP servers Claude dans le Dockerfile
   - Créer un dossier `mcp-servers/` avec configurations
   - Intégrer les serveurs standards : `git`, `github`, `web-search`, etc.

   ```dockerfile
   # À ajouter au Dockerfile
   RUN npm install -g @anthropic-ai/mcp
   COPY mcp-servers/ /workspace/mcp-servers/
   ```

2. **Configuration Gemini MCP** (si disponible)
   - Suivre les évolutions de Google sur MCP
   - Implémenter les adaptateurs si nécessaire

3. **Structure des MCP servers**
   ```
   mcp-servers/
   ├── git/
   │   ├── config.json
   │   └── README.md
   ├── github/
   │   ├── config.json
   │   └── README.md
   ├── web-search/
   │   ├── config.json
   │   └── README.md
   └── README.md (index de tous les servers)
   ```

### Phase 2 : Observabilité avancée

- **Traces distribuées** : Décommenter les sections `traces` dans `otel-collector-config.yaml`
  - Ajouter Tempo pour le stockage des traces
  - Intégrer Jaeger UI pour la visualisation
  
- **Logs centralisés** : Décommenter les sections `logs`
  - Ajouter Loki pour le stockage
  - Intégrer dans Grafana

- **Dashboards pré-configurés** : 
  - Dashboard des métriques IA (tokens, latence, coûts)
  - Dashboard de santé des services
  - Dashboard des traces de requêtes

### Phase 3 : Intégration avancée

- **Support de multiples APIs IA** :
  - OpenAI (ChatGPT, GPT-4)
  - Hugging Face
  - Mistral AI
  - LLaMA via Ollama
  
- **Framework de testing** :
  - Tests d'intégration pour chaque CLI
  - Benchmarks de performance
  - Validation des outputs

- **Exemples complets** :
  - Projets exemple pour chaque IA
  - Patterns réutilisables
  - Notebook Jupyter intégrés

### Phase 4 : Productionisation

- **Sécurité renforcée** :
  - Secrets management (Vault/Doppler)
  - Network policies
  - Audit logging

- **Performance** :
  - Optimisation des images Docker
  - Cache optimisé pour Ollama
  - Resource limits configurables

- **CI/CD** :
  - Github Actions pour tests
  - Scan de sécurité (trivy, snyk)
  - Versioning automatique


## 📋 Checklist pour une PR

- [ ] Code testé localement avec `make launch`
- [ ] Messages de commit clairs et conventionnels
- [ ] README mis à jour si nécessaire
- [ ] Variables d'environnement documentées
- [ ] Pas de secrets ou credentials dans le code
- [ ] Images Docker utilisent des versions spécifiques
- [ ] Pas de fichiers de workspace commitados (`.gitignore` respecté)

## 🐛 Signaler un bug

Créez une issue avec :
- Description claire du bug
- Étapes de reproduction
- Résultat attendu vs. résultat obtenu
- Output de `docker-compose ps`

## 💡 Proposer une amélioration

Créez une discussion ou issue avec :
- Description de l'amélioration
- Cas d'usage / contexte
- Solution proposée (si applicable)

## 📞 Questions ?

N'hésite pas à ouvrir une issue ou une discussion pour clarifier points.

---

## Roadmap détaillée (next steps)

| Phase | Tâche | Priorité | Estimé |
|-------|-------|----------|--------|
| 1 | MCP Servers Claude config | Haute | 2-3j |
| 1 | Tests d'intégration CLI | Haute | 1-2j |
| 2 | Traces distribuées (Tempo) | Moyenne | 2-3j |
| 2 | Logs centralisés (Loki) | Moyenne | 2-3j |
| 3 | Support OpenAI | Moyenne | 1-2j |
| 3 | Exemples et documentations | Basse | 3-5j |
| 4 | Secrets management | Basse | 2-3j |

---

**Merci pour ta contribution !** 🎉

