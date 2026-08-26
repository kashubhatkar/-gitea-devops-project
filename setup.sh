#!/bin/bash

# ==========================================
# Gitea Local Setup Script
# ==========================================

set -u

echo "=========================================="
echo "       Gitea Local Setup"
echo "=========================================="

# ------------------------------------------
# 1. Check required tools
# ------------------------------------------

echo ""
echo "[1/7] Checking required tools..."

REQUIRED_TOOLS=("go" "git" "make" "ss")

for tool in "${REQUIRED_TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "[OK] $tool is installed"
    else
        echo "[ERROR] $tool is not installed"
        echo "Please install $tool and run the script again."
        exit 1
    fi
done

# ------------------------------------------
# 2. Display dependency versions
# ------------------------------------------

echo ""
echo "[2/7] Checking dependency versions..."

echo "Go:"
go version

echo "Git:"
git --version

echo "Make:"
make --version | head -n 1

# ------------------------------------------
# 3. Verify Gitea project directory
# ------------------------------------------

echo ""
echo "[3/7] Verifying Gitea project directory..."

if [ ! -f "go.mod" ]; then
    echo "[ERROR] go.mod was not found."
    echo "Please run this script from the Gitea project directory."
    exit 1
fi

if [ ! -f "Makefile" ]; then
    echo "[ERROR] Makefile was not found."
    echo "Please run this script from the Gitea project directory."
    exit 1
fi

echo "[OK] Gitea project directory verified."

# ------------------------------------------
# 4. Build Gitea
# ------------------------------------------

echo ""
echo "[4/7] Building Gitea from source..."

if make build; then
    echo "[OK] Gitea build completed successfully."
else
    echo "[ERROR] Gitea build failed."
    exit 1
fi

# ------------------------------------------
# 5. Verify Gitea binary
# ------------------------------------------

echo ""
echo "[5/7] Verifying Gitea binary..."

if [ -f "./gitea" ] && [ -x "./gitea" ]; then
    echo "[OK] Gitea binary was created successfully."
    echo "Binary: $(pwd)/gitea"
else
    echo "[ERROR] Gitea binary was not created."
    exit 1
fi

# ------------------------------------------
# 6. Check port 3000
# ------------------------------------------

echo ""
echo "[6/7] Checking whether port 3000 is available..."

if ss -ltn | grep -q ':3000 '; then
    echo "[ERROR] Port 3000 is already in use."
    echo "Please stop the application using port 3000 and try again."
    exit 1
else
    echo "[OK] Port 3000 is available."
fi

# ------------------------------------------
# 7. Start Gitea
# ------------------------------------------

echo ""
echo "[7/7] Starting Gitea web server..."

./gitea web &
GITEA_PID=$!

sleep 3

if kill -0 "$GITEA_PID" >/dev/null 2>&1; then
    echo "[OK] Gitea web server started successfully."
    echo ""
    echo "=========================================="
    echo " Gitea is running!"
    echo " URL: http://localhost:3000"
    echo " PID: $GITEA_PID"
    echo "=========================================="
else
    echo "[ERROR] Gitea failed to start."
    exit 1
fi
