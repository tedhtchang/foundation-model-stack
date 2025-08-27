# Fork Management Guide

This guide will help you work with your fork of the Foundation Model Stack repository effectively.

## Quick Start

If you're working with a fork of `foundation-model-stack/foundation-model-stack`, use these scripts to set up and maintain your fork:

1. **Initial Setup**: `./scripts/setup_fork.sh`
2. **Sync with Upstream**: `./scripts/sync_fork.sh`

## Detailed Instructions

### Setting Up Your Fork

After cloning your fork, run the setup script to configure the upstream remote:

```bash
./scripts/setup_fork.sh
```

This script will:
- Add the upstream repository as a remote named "upstream"
- Fetch the latest changes from upstream
- Show you the current status of your fork

### Keeping Your Fork in Sync

To sync your fork with the latest changes from upstream:

```bash
./scripts/sync_fork.sh
```

Options:
- `--branch BRANCH` or `-b BRANCH`: Sync from a specific upstream branch (default: main)
- `--force` or `-f`: Force sync even with uncommitted changes
- `--help` or `-h`: Show help

Examples:
```bash
# Sync with upstream main branch
./scripts/sync_fork.sh

# Sync with a specific branch
./scripts/sync_fork.sh --branch develop

# Force sync (ignoring uncommitted changes)
./scripts/sync_fork.sh --force
```

### Development Workflow

1. **Start with a synced fork**:
   ```bash
   ./scripts/sync_fork.sh
   ```

2. **Create a feature branch**:
   ```bash
   git checkout -b feature/my-awesome-feature
   ```

3. **Make your changes and commit**:
   ```bash
   git add .
   git commit -m "Add awesome feature"
   ```

4. **Push to your fork**:
   ```bash
   git push origin feature/my-awesome-feature
   ```

5. **Create a Pull Request** on GitHub to the upstream repository

### Advanced Scenarios

#### Working with Multiple Branches

To sync a specific branch from upstream:
```bash
git checkout my-branch
./scripts/sync_fork.sh --branch upstream-branch-name
```

#### Resolving Conflicts

If you have conflicts during sync:

1. **For merge conflicts**:
   ```bash
   # Resolve conflicts in your editor
   git add resolved-files
   git commit
   ```

2. **For rebase conflicts**:
   ```bash
   # Resolve conflicts in your editor
   git add resolved-files
   git rebase --continue
   ```

#### Checking Fork Status

To see how your fork compares to upstream without syncing:
```bash
git fetch upstream
git log --oneline --graph --decorate --all
```

### Manual Commands

If you prefer to work without the scripts, here are the manual commands:

#### Add upstream remote (one-time setup):
```bash
git remote add upstream https://github.com/foundation-model-stack/foundation-model-stack.git
```

#### Sync with upstream:
```bash
git fetch upstream
git checkout main
git merge upstream/main
```

#### Rebase instead of merge:
```bash
git fetch upstream
git checkout main
git rebase upstream/main
```

### Troubleshooting

#### "Upstream remote not found"
Run the setup script: `./scripts/setup_fork.sh`

#### "You have uncommitted changes"
Either commit your changes or use the `--force` flag: `./scripts/sync_fork.sh --force`

#### "Upstream branch not found"
Check available branches: `git branch -r | grep upstream/`

#### Merge conflicts
Resolve conflicts manually and continue with `git commit` (for merge) or `git rebase --continue` (for rebase)

### Best Practices

1. **Always sync before starting new work**
2. **Use feature branches for all changes**
3. **Keep your main branch clean** (only synced upstream changes)
4. **Regularly sync to avoid large conflicts**
5. **Test your changes locally before pushing**

### Contributing Back

When you're ready to contribute your changes back to the upstream repository:

1. Ensure your fork is synced with upstream
2. Push your feature branch to your fork
3. Create a Pull Request on GitHub
4. Follow the project's contribution guidelines

For more information about contributing, see the main [README.md](../README.md) file.