# Gemini MCP Configuration

This folder contains example configurations for Model Context Protocol (MCP) with Gemini.

## Structure

- `settings.json`: Example configuration file for Context7 MCP servers

## Usage

### Global Installation

1. Create the Gemini configuration folder if it doesn't exist:
   ```bash
   mkdir -p ~/.gemini
   ```

2. Copy the `settings.json` file to your Gemini folder:
   ```bash
   cp settings.json ~/.gemini/settings.json
   ```

3. Set the `CONTEXT7_TOKEN` environment variable:
   ```bash
   export CONTEXT7_TOKEN="your-context7-api-key"
   ```

4. Launch Gemini and it will automatically use the MCP configuration:
   ```bash
   gemini "Your question here"
   ```

### Per-project Installation

To use a project-specific MCP configuration:

1. Create a `.gemini` folder in your project root:
   ```bash
   mkdir -p /path/to/your/project/.gemini
   ```

2. Copy the `settings.json` file to that folder:
   ```bash
   cp settings.json /path/to/your/project/.gemini/settings.json
   ```

3. Set the environment variable and run Gemini from the project directory:
   ```bash
   cd /path/to/your/project
   export CONTEXT7_TOKEN="your-context7-api-key"
   gemini "Your question here"
   ```

## Available MCP Configurations

### Context7

Provides access to the Context7 API via HTTP.

- **URL**: `https://mcp.context7.com/mcp`
- **Authentication**: `CONTEXT7_API_KEY` header
- **Required headers**:
  - `CONTEXT7_API_KEY`: Your Context7 API key
  - `Accept`: `application/json, text/event-stream`

## Security

- The `CONTEXT7_TOKEN` variable must be set in your environment
- Never commit your `settings.json` file with hardcoded API keys
- Use environment variables for all sensitive data

## Documentation

For more details on configuring MCPs with Gemini and Claude, see the [DEVELOPER_GUIDE.md](../DEVELOPER_GUIDE.md#mcp-configuration-model-context-protocol).
