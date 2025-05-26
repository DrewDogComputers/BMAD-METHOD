# AGENTS Instructions

This repository hosts the BMAD Method agent assets. The instructions below mirror
those used in the `OS_candidate` project so the BMAD Agent can be integrated with
Operator Shell.

## Building the Agent

1. Ensure Node.js is installed.
2. From the project root, run `node build-web-agent.js` to generate the
   `build/` directory. The script bundles personas, tasks and templates for the
   web orchestrator.
3. After changing any file in `bmad-agent/`, rerun the build script to confirm
   it completes without errors.

## Development Guidelines

- Keep commits focused and descriptive.
- Maintain code formatting using your preferred tooling.
- If tests or lint commands are added, run them before committing.

## Operator Shell Agent

A temporary persona `operator-shell.ide.md` is provided for use with Operator
Shell via the Roo extension in VS Code.

1. Copy the entire `bmad-agent` folder to your Operator Shell project root.
2. Load `ide-bmad-orchestrator.md` as a custom mode in Roo.
3. The orchestrator can become the "Operator Shell" agent defined in the new
   persona file.

Refer to `docs/instruction.md` for more details on using the BMAD Method.
