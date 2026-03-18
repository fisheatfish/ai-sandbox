# Security Policy

## Reporting a Vulnerability

If you discover a security vulnerability in this project, please report it responsibly:

1. **Do NOT open a public issue.**
2. Email the maintainers or use [GitHub's private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability).
3. Include a description, steps to reproduce, and potential impact.

We will acknowledge receipt within 48 hours and aim to provide a fix within 7 days for critical issues.

## Scope

This project runs AI agents inside Docker containers. The following are in scope:

- Container escape vulnerabilities
- Secrets leaking outside the sandbox
- Misconfigurations that expose host resources
- Dependency vulnerabilities in the Docker image

## Best Practices for Users

- **Never use production API keys** in the sandbox
- **Rotate keys** regularly and set expiration dates
- **Use fine-grained tokens** with minimal permissions
- **Set spending limits** on API accounts
- Review the [README security warning](README.md) before use
