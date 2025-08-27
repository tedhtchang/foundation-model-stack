#!/bin/bash

# Foundation Model Stack Fork Sync Script
# This script helps keep your fork in sync with the upstream repository

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
UPSTREAM_BRANCH="main"
FORCE_SYNC=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --branch|-b)
            UPSTREAM_BRANCH="$2"
            shift 2
            ;;
        --force|-f)
            FORCE_SYNC=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --branch, -b BRANCH    Upstream branch to sync from (default: main)"
            echo "  --force, -f            Force sync even if there are uncommitted changes"
            echo "  --help, -h             Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

echo -e "${BLUE}Foundation Model Stack Fork Sync${NC}"
echo "================================================"
echo

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}Error: Not in a git repository${NC}"
    exit 1
fi

# Check if upstream remote exists
if ! git remote | grep -q "^upstream$"; then
    echo -e "${RED}Error: Upstream remote not found${NC}"
    echo "Please run ./scripts/setup_fork.sh first"
    exit 1
fi

# Check for uncommitted changes
if [[ $FORCE_SYNC == false ]] && ! git diff-index --quiet HEAD --; then
    echo -e "${RED}Error: You have uncommitted changes${NC}"
    echo "Please commit or stash your changes, or use --force to ignore this warning"
    git status --porcelain
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current)

# Fetch from upstream
echo -e "${BLUE}Fetching from upstream...${NC}"
git fetch upstream

# Check if the upstream branch exists
if ! git show-ref --verify --quiet "refs/remotes/upstream/$UPSTREAM_BRANCH"; then
    echo -e "${RED}Error: Upstream branch '$UPSTREAM_BRANCH' not found${NC}"
    echo "Available upstream branches:"
    git branch -r | grep upstream/
    exit 1
fi

# Get ahead/behind counts
AHEAD=$(git rev-list --count upstream/$UPSTREAM_BRANCH..$CURRENT_BRANCH 2>/dev/null || echo "0")
BEHIND=$(git rev-list --count $CURRENT_BRANCH..upstream/$UPSTREAM_BRANCH 2>/dev/null || echo "0")

echo
echo -e "${BLUE}Sync status:${NC}"
echo "Current branch: $CURRENT_BRANCH"
echo "Upstream branch: $UPSTREAM_BRANCH"
echo "Commits ahead of upstream: $AHEAD"
echo "Commits behind upstream: $BEHIND"

if [[ $BEHIND -eq 0 ]]; then
    echo -e "${GREEN}✓ Your branch is up to date with upstream${NC}"
    exit 0
fi

echo
if [[ $AHEAD -gt 0 ]]; then
    echo -e "${YELLOW}Warning: Your branch has $AHEAD commits ahead of upstream${NC}"
    echo "This will create a merge commit or you can rebase instead"
    echo
    read -p "How do you want to sync? (m)erge, (r)ebase, or (c)ancel: " -n 1 -r
    echo
    case $REPLY in
        [Mm])
            echo -e "${BLUE}Merging upstream changes...${NC}"
            git merge upstream/$UPSTREAM_BRANCH
            ;;
        [Rr])
            echo -e "${BLUE}Rebasing on upstream changes...${NC}"
            git rebase upstream/$UPSTREAM_BRANCH
            ;;
        *)
            echo "Sync cancelled"
            exit 0
            ;;
    esac
else
    echo -e "${BLUE}Fast-forwarding to upstream...${NC}"
    git merge --ff-only upstream/$UPSTREAM_BRANCH
fi

echo -e "${GREEN}✓ Fork sync complete!${NC}"

# Show updated status
NEW_AHEAD=$(git rev-list --count upstream/$UPSTREAM_BRANCH..$CURRENT_BRANCH 2>/dev/null || echo "0")
NEW_BEHIND=$(git rev-list --count $CURRENT_BRANCH..upstream/$UPSTREAM_BRANCH 2>/dev/null || echo "0")

echo
echo -e "${BLUE}Updated status:${NC}"
echo "Commits ahead of upstream: $NEW_AHEAD"
echo "Commits behind upstream: $NEW_BEHIND"

if [[ $NEW_AHEAD -gt 0 ]]; then
    echo
    echo -e "${YELLOW}To push your changes to your fork:${NC}"
    echo "git push origin $CURRENT_BRANCH"
fi