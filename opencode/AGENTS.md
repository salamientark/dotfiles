# OpenCode Agent Guidelines

## Build/Lint/Test Commands
- No npm/bun scripts defined - this is a configuration repository
- Testing: Use existing TypeScript/Zod patterns from node_modules for reference
- Single test: No specific test runner - check individual files manually

## Code Style Guidelines
- **Language**: TypeScript/Markdown configuration files
- **Imports**: Use standard ES6 imports, prefer named exports
- **Formatting**: 2-space indentation, no trailing semicolons (based on package structure)
- **Types**: Explicit TypeScript types, leverage Zod for runtime validation
- **Naming**: camelCase for variables/functions, kebab-case for file names
- **Files**: Markdown files use snake_case with .md extension

## Error Handling
- Configuration errors should be descriptive and actionable
- Use proper JSON schema validation for opencode.json

## Project Structure
- `/agent/` - Contains pedagogical AI agents and prompts
- Main config files: `opencode.json`, `package.json`
- Follow existing agent naming patterns: `pedagogical_*`

## Code Review Standards
- Follow flake8 standards for Python (when applicable)
- Use pedagogical approach - guide through Socratic questioning
- Never output corrected code directly - explain concepts instead