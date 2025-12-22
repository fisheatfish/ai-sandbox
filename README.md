# AI Docker Sandbox

Une sandbox Docker complète pour les développeurs qui souhaitent explorer et expérimenter avec les outils IA modernes : **Gemini**, **Claude** et **Qwen**.

## 🎯 Objectif

Ce repository fournit un environnement de développement isolé, pré-configuré et reproductible pour :
- Expérimenter avec les APIs et CLIs de Google Gemini, Anthropic Claude et Alibaba Qwen
- Développer des applications IA sans poluer votre machine locale
- Tester des configurations complexes et des intégrations
- Bénéficier d'une observabilité complète de vos expériences

## 📋 Contenu

### Services principaux

- **ai-sandbox** : Conteneur principal Node.js 20 avec les CLIs Gemini et Claude pré-installés
- **Ollama** : Support des modèles LLM locaux (si besoin de modèles open-source)
- **OpenTelemetry Collector** : Collecte centralisée des métriques et traces
- **Prometheus** : Stockage et requêtes des métriques
- **Grafana** : Visualisation et dashboards des métriques

### Outils installés dans ai-sandbox

```dockerfile
- Node.js 20
- @google/gemini-cli (CLI Gemini)
- @anthropic-ai/claude-code (CLI Claude)
- @qwen-code/qwen-code (CLI Qwen)
- Git
- Python 3 + pip
- curl
```

## 🚀 Démarrage rapide

### Prérequis

- **Docker et Docker Compose** installés
- Clés API pour Gemini et/ou Claude configurées

#### Option 1 : Docker Desktop (Recommandé)

- **macOS** : https://www.docker.com/products/docker-desktop
- **Linux** : https://docs.docker.com/engine/install/
- **Windows** : https://www.docker.com/products/docker-desktop (avec WSL 2)

#### Option 2 : Colima (Alternative Open Source)

Si vous ne pouvez pas installer Docker Desktop, **Colima** est une excellente alternative légère et open-source. Vous pouvez suivre [ce tuto](https://blog.stephane-robert.info/post/colima/)

### Lancer l'environnement

#### 0️⃣ Configurer les secrets (première fois uniquement)

Créez un dossier `secrets` et un fichier `.env` pour stocker vos clés API de manière sécurisée :

```bash
# Créer le dossier secrets
mkdir -p secrets

# Créer le fichier .env avec vos clés API
cat > secrets/.env << EOF
# Clés API pour les outils IA
GITHUB_TOKEN=votre_token_github_ici
EOF
```

**🔒 Sécurité** : Le dossier `secrets/` est automatiquement ignoré par Git. Ne partagez jamais ce fichier.

#### 1️⃣ Créer le dossier workspace (première fois uniquement)

Avant de lancer les services, créez un dossier `workspace` à la racine du projet. C'est là que vous mettrez tous vos projets IA :

```bash
# Depuis la racine du projet
mkdir -p workspace
```

Ce dossier sera automatiquement monté en volume dans le conteneur `ai-sandbox` sur `/workspace`. Vous pourrez y accéder et y créer vos projets.

#### 2️⃣ Construire l'image (première fois uniquement)

La première fois que vous lancez l'environnement, vous devez construire l'image Docker `ai-sandbox` :

```bash
docker build -t ai-sandbox .
```

Cette étape n'est nécessaire que lors de la première utilisation ou après des modifications du Dockerfile.

#### 3️⃣ Lancer les services

```bash
docker-compose up -d
```

Cela démarre tous les services. Pour entrer dans le conteneur ai-sandbox :

```bash
docker exec -it ai-sandbox bash
```

### Alias pratique (Optionnel)

Pour simplifier l'accès au conteneur, créez un alias `ai-sandbox` qui lance l'environnement et entre dans le conteneur en une seule commande.

#### Pour Bash

Ajoutez cette ligne à votre fichier `~/.bashrc` :

```bash
alias ai-sandbox='cd ~/Documents/ai-docker && docker-compose up -d && docker exec -it ai-sandbox bash'
```

Puis rechargez la configuration :

```bash
source ~/.bashrc
```

#### Pour Zsh

Ajoutez cette ligne à votre fichier `~/.zshrc` :

```bash
alias ai-sandbox='cd ~/Documents/ai-docker && docker-compose up -d && docker exec -it ai-sandbox bash'
```

Puis rechargez la configuration :

```bash
source ~/.zshrc
```

#### Utilisation

Ensuite, il vous suffit de taper :

```bash
ai-sandbox
```

Et vous serez automatiquement :
1. ✅ Dans le bon répertoire du projet
2. ✅ Tous les services (Ollama, Prometheus, Grafana, etc.) seront lancés
3. ✅ Connecté au conteneur ai-sandbox

**💡 Astuce** : Adaptez le chemin `~/Documents/Projects/ai-docker` à votre propre chemin d'installation si différent.

## �️ Utilisation rapide

### Accéder aux interfaces

- **Grafana** (dashboards) : http://localhost:3000
- **Prometheus** (métriques) : http://localhost:9090
- **Ollama** (LLMs locaux) : http://localhost:11434

### Utiliser les CLIs IA

```bash
# Depuis le conteneur ai-sandbox

# Gemini
gemini --help

# Claude
claude-code --help

# Qwen
qwen-code --help
```

## 📚 Documentation complète

| Document | Contenu |
|----------|---------|
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | Configuration MCP, architecture, configuration détaillée, troubleshooting |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Guide de contribution, workflow Git, bonnes pratiques, roadmap |

Pour approfondir : **Consultez le [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md)** qui couvre :
- ✅ Configuration MCP pour Claude + GitHub
- ✅ Observabilité détaillée (OpenTelemetry, Prometheus, Grafana)
- ✅ Configuration avancée
- ✅ Cas d'usage (Gemini, Claude, Qwen, Ollama)
- ✅ Troubleshooting

## 🤝 Contribution

Pour contribuer à ce projet, consultez [CONTRIBUTING.md](CONTRIBUTING.md) qui explique :
- ✅ Workflow Git (feature branches, PR, etc.)
- ✅ Bonnes pratiques
- ✅ Roadmap future

## ❓ Questions rapides

**Comment ajouter une clé API ?**
Créez un fichier `.env` à la racine et chargez-le dans docker-compose.yml.

**Comment persister mes données entre sessions ?**
Le dossier `/workspace` est automatiquement monté en volume.

**Comment monitorer mes expériences ?**
Activez la télémétrie dans docker-compose.yml et utilisez Grafana.

**Besoin d'aide ?** → Consultez le [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md#troubleshooting).

## 📝 Licence

[À définir selon vos préférences]

---

**Prêt ?** 🚀 Lancez `docker-compose up -d` et commencez à explorer l'IA !
