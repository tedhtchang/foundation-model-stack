#!/bin/bash

# Foundation Model Stack Fork Setup Script
# This script helps configure your fork to properly track the upstream repository

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
UPSTREAM_REPO="foundation-model-stack/foundation-model-stack"
UPSTREAM_URL="https://github.com/${UPSTREAM_REPO}.git"

echo -e "${BLUE}Foundation Model Stack Fork Setup${NC}"
echo "================================================"
echo

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if upstream remote already exists
if git remote | grep -q "^upstream$"; then
    echo -e "${YELLOW}Upstream remote already exists. Current configuration:${NC}"
    git remote -v | grep upstream
    echo
    read -p "Do you want to update the upstream remote? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git remote set-url upstream "$UPSTREAM_URL"
        echo -e "${GREEN}✓ Updated upstream remote URL${NC}"
    else
        echo "Skipping upstream remote update"
    fi
else
    # Add upstream remote
    echo -e "${BLUE}Adding upstream remote...${NC}"
    git remote add upstream "$UPSTREAM_URL"
    echo -e "${GREEN}✓ Added upstream remote${NC}"
fi

# Fetch upstream
echo -e "${BLUE}Fetching from upstream...${NC}"
git fetch upstream

# Show current branch and upstream status
echo
echo -e "${BLUE}Current repository status:${NC}"
echo "Current branch: $(git branch --show-current)"
echo "Remotes:"
git remote -v

echo
echo -e "${BLUE}Available upstream branches:${NC}"
git branch -r | grep upstream/ | head -5

echo
echo -e "${GREEN}✓ Fork setup complete!${NC}"
echo
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Sync with upstream: ./scripts/sync_fork.sh"
echo "2. Create a new feature branch: git checkout -b feature/my-feature"
echo "3. Make your changes and commit them"
echo "4. Push to your fork: git push origin feature/my-feature"
echo "5. Create a pull request on GitHub"