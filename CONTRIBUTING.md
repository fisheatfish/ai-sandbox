# Guide de Contribution

Merci de vouloir contribuer à ce projet ! Ce document décrit les bonnes pratiques et la vision pour les développements futurs.

## 🎯 Vision du projet

**ai-docker** est un sandbox pour développeurs permettant d'explorer rapidement les outils IA (Gemini, Claude) dans un environnement reproductible et observable.

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
   docker-compose up -d
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
docker-compose up -d
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
docker-compose up -d
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

- **Messages de commit clairs** :
  ```
  feat: ajouter support MCP server Claude
  fix: corriger endpoint Prometheus
  docs: mettre à jour README observabilité
  chore: mettre à jour Ollama vers latest
  ```

- **Format** : Utiliser le format conventionnel (feat:, fix:, docs:, chore:)

- **Tests** :
  - Vérifier que `docker-compose up` lance sans erreurs
  - Tester l'accès aux CLIs : `gemini --help`, `claude-code --help`
  - Vérifier l'observabilité (Prometheus scrape, Grafana accessible)

### Documentation

- Mettre à jour le README si changement d'architecture
- Documenter les nouvelles variables d'environnement
- Expliquer les choix techniques dans les comentaires

## 🚀 Évolutions futures

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

- [ ] Code testé localement avec `docker-compose up`
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

