#!/bin/bash

# Fork Management Demo Script
# This script demonstrates the fork management features

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Foundation Model Stack Fork Management Demo${NC}"
echo "========================================================="
echo

echo -e "${YELLOW}This demo shows the fork management capabilities added to this repository${NC}"
echo

echo -e "${GREEN}1. Fork Setup Script:${NC}"
echo "   ./scripts/setup_fork.sh"
echo "   - Configures upstream remote for your fork"
echo "   - Fetches latest upstream changes"
echo "   - Shows repository status"
echo

echo -e "${GREEN}2. Fork Sync Script:${NC}"
echo "   ./scripts/sync_fork.sh [options]"
echo "   - Syncs your fork with upstream changes"
echo "   - Supports merge or rebase strategies"
echo "   - Has safety checks for uncommitted changes"
echo "   - Options:"
echo "     --branch BRANCH: Sync from specific upstream branch"
echo "     --force: Ignore uncommitted changes warning"
echo "     --help: Show help message"
echo

echo -e "${GREEN}3. Documentation:${NC}"
echo "   FORK_MANAGEMENT.md - Comprehensive fork management guide"
echo "   README.md - Updated with fork management section"
echo "   scripts/README.md - Documents the new scripts"
echo

echo -e "${GREEN}4. Current Remote Configuration:${NC}"
if git remote | grep -q "^upstream$"; then
    echo "   ✓ Upstream remote configured:"
    git remote -v | grep upstream | sed 's/^/     /'
else
    echo "   ⚠ Upstream remote not configured. Run ./scripts/setup_fork.sh"
fi

echo

echo -e "${GREEN}5. Current Fork Status:${NC}"
if git remote | grep -q "^upstream$"; then
    git fetch upstream >/dev/null 2>&1 || true
    CURRENT_BRANCH=$(git branch --show-current)
    AHEAD=$(git rev-list --count upstream/main..$CURRENT_BRANCH 2>/dev/null || echo "?")
    BEHIND=$(git rev-list --count $CURRENT_BRANCH..upstream/main 2>/dev/null || echo "?")
    echo "   Current branch: $CURRENT_BRANCH"
    echo "   Commits ahead of upstream/main: $AHEAD"
    echo "   Commits behind upstream/main: $BEHIND"
else
    echo "   Run ./scripts/setup_fork.sh to see fork status"
fi

echo
echo -e "${BLUE}Example Workflow:${NC}"
echo "1. Clone your fork: git clone https://github.com/YOUR_USERNAME/foundation-model-stack.git"
echo "2. Setup fork: ./scripts/setup_fork.sh"
echo "3. Sync with upstream: ./scripts/sync_fork.sh"
echo "4. Create feature branch: git checkout -b feature/my-feature"
echo "5. Make changes, commit, and push to your fork"
echo "6. Create pull request on GitHub"

echo
echo -e "${YELLOW}For detailed instructions, see: FORK_MANAGEMENT.md${NC}"