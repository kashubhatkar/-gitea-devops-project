# Gitea Local Setup Automation

## Objective

Automate the process of building and running Gitea locally without manually executing each command.

## Requirements

The script:

- Checks required tools
- Displays dependency versions
- Verifies the Gitea project directory
- Builds Gitea from source
- Verifies the Gitea binary
- Checks whether port 3000 is available
- Starts the Gitea web server
- Displays the local URL
- Provides error handling and status messages
- Does not use Docker
- Does not use user-specific hard-coded paths

## How to Run

From the Gitea project directory:

```bash
chmod +x setup.sh
./setup.sh
