# Configuration Gemini MCP

Ce dossier contient des exemples de configuration pour les Model Context Protocol (MCP) avec Gemini.

## Structure

- `settings.json` : Fichier de configuration d'exemple pour les serveurs MCP Context7

## Utilisation

### Installation globale

1. Créez le dossier de configuration Gemini s'il n'existe pas :
   ```bash
   mkdir -p ~/.gemini
   ```

2. Copiez le fichier `settings.json` dans votre dossier Gemini :
   ```bash
   cp settings.json ~/.gemini/settings.json
   ```

3. Définissez la variable d'environnement `CONTEXT7_TOKEN` :
   ```bash
   export CONTEXT7_TOKEN="votre-clé-api-context7"
   ```

4. Lancez Gemini et il utilisera automatiquement la configuration MCP :
   ```bash
   gemini "Votre question ici"
   ```

### Installation par projet

Pour utiliser une configuration MCP spécifique à un projet :

1. Créez un dossier `.gemini` dans la racine de votre projet :
   ```bash
   mkdir -p /chemin/vers/votre/projet/.gemini
   ```

2. Copiez le fichier `settings.json` dans ce dossier :
   ```bash
   cp settings.json /chemin/vers/votre/projet/.gemini/settings.json
   ```

3. Définissez la variable d'environnement et exécutez Gemini depuis le répertoire du projet :
   ```bash
   cd /chemin/vers/votre/projet
   export CONTEXT7_TOKEN="votre-clé-api-context7"
   gemini "Votre question ici"
   ```

## Configuration MCP disponibles

### Context7

Fournit l'accès à l'API Context7 via HTTP.

- **URL** : `https://mcp.context7.com/mcp`
- **Authentification** : Header `CONTEXT7_API_KEY`
- **En-têtes requis** : 
  - `CONTEXT7_API_KEY` : Votre clé API Context7
  - `Accept` : `application/json, text/event-stream`

## Sécurité

- La variable `CONTEXT7_TOKEN` doit être définie dans votre environnement
- Ne commitez jamais votre fichier `settings.json` avec des clés d'API en dur
- Utilisez des variables d'environnement pour toutes les données sensibles

## Documentation

Pour plus de détails sur la configuration des MCP avec Gemini et Claude, consultez le [DEVELOPER_GUIDE.md](../DEVELOPER_GUIDE.md#-configuration-mcp-model-context-protocol).
