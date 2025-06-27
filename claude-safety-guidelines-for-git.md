# CLAUDE Code Git Safety Guidelines

## Overview
This document provides comprehensive safety guidelines for Git operations when using CLAUDE Code, based on analysis of all 194+ Git commands and their potential risks.

## Git Command Analysis Results
- **Total Git commands analyzed**: 194 commands and aliases
- **Safe operations**: 45+ read-only and basic development commands
- **Development operations**: 35+ commands requiring confirmation
- **Restricted operations**: 40+ potentially dangerous commands
- **Forbidden operations**: 25+ extremely dangerous commands

## Permission Categories

### 🟢 SAFE (Auto-allowed)
Commands safe for read-only operations and information gathering:

#### Information & Status
- `git status`, `git log`, `git show`, `git diff`, `git blame`
- `git ls-files`, `git ls-tree`, `git ls-remote`, `git describe`
- `git branch --list`, `git tag --list`, `git remote -v`
- `git config --list`, `git reflog show`, `git help`

#### Analysis & Verification
- `git fsck`, `git count-objects`, `git verify-pack`
- `git check-ref-format`, `git check-attr`, `git check-ignore`
- `git grep`, `git cherry`, `git merge-base`

#### Dry-run Operations
- `git add --dry-run`, `git push --dry-run`, `git clean --dry-run`
- `git merge --dry-run`, `git rebase --dry-run`, `git gc --dry-run`

### 🟡 DEVELOPMENT (Confirmation required)
Normal development operations requiring user confirmation:

#### Basic Workflow
- `git add`, `git commit`, `git commit -m`, `git commit --amend`
- `git checkout`, `git switch`, `git restore`, `git mv`
- `git branch`, `git tag`, `git merge`, `git pull`, `git fetch`

#### Repository Management
- `git clone`, `git init`, `git remote add`, `git remote set-url`
- `git stash`, `git cherry-pick`, `git revert`, `git rebase`
- `git reset --soft`, `git reset --mixed`

#### Configuration
- `git config --add`, `git config --set`, `git config --unset`
- `git submodule add`, `git submodule update`, `git worktree add`

### 🔴 RESTRICTED (Explicit approval required)
Operations that can cause data loss or significant changes:

#### File Operations
- `git clean`, `git clean -f`, `git clean -fd`
- `git rm`, `git rm -f`, `git rm -r`
- `git reset --hard`, `git reset --merge`

#### Branch Management
- `git branch -d`, `git branch -D`, `git branch -f`
- `git tag -d`, `git tag -f`
- `git remote remove`, `git remote prune`

#### History Modification
- `git reflog delete`, `git reflog expire`
- `git filter-branch`, `git replace`
- `git push --force`, `git push --force-with-lease`

### ⛔ FORBIDDEN (Blocked)
Extremely dangerous operations that should never run automatically:

#### Destructive Operations
- `git clean -ffx`, `git rm -rf *`, `git rm -rf .`
- `git reset --hard HEAD~`, `git reset --hard origin/master`
- `git push --force origin master`, `git push --delete origin master`

#### System-level Changes
- `git config --global user.email`, `git config --system core.hooksPath`
- `git daemon`, `git daemon --export-all`
- `git fast-import`, `git cvsserver`, `git svn`

#### Bulk Operations
- `git branch -D master`, `git tag -d v*`
- `git reflog expire --expire=now --all`
- `git submodule foreach --recursive git clean -ffxd`

## Dangerous Patterns Analysis

### Destructive Reset Patterns
```bash
# DANGEROUS: Hard resets to arbitrary commits
git reset --hard HEAD~5        # Loses 5 commits permanently
git reset --hard origin/master # May lose local work
git reset --hard <commit-hash> # Destructive without backup

# SAFER ALTERNATIVES:
git stash                      # Save current work
git reset --soft HEAD~5       # Keep changes in staging
git reset --mixed HEAD~5      # Keep changes in working directory
```

### Forced Push Operations
```bash
# EXTREMELY DANGEROUS:
git push --force origin master           # Can overwrite others' work
git push -f origin main                  # Same danger as above
git push --delete origin important-branch # Deletes remote branch

# SAFER ALTERNATIVES:
git push --force-with-lease origin feature-branch  # Safer force push
git push --dry-run origin feature-branch          # Test first
git pull --rebase origin master                   # Integrate changes first
```

### Bulk Deletion Patterns
```bash
# DANGEROUS:
git clean -ffxd              # Removes ALL untracked files and directories
git rm -rf *                 # Removes all tracked files
git reflog expire --all      # Deletes all reflog history
git prune --expire=now       # Removes all unreachable objects immediately

# SAFER ALTERNATIVES:
git clean -n                 # Preview what would be deleted
git clean -i                 # Interactive deletion
git stash -u                 # Stash untracked files instead
```

### Configuration Risks
```bash
# DANGEROUS:
git config --global user.email malicious@example.com  # Identity theft
git config --system core.hooksPath /malicious/path    # Hook injection
git config receive.denyNonFastForwards false          # Disables safety

# SAFER ALTERNATIVES:
git config user.email your-email@example.com          # Local config only
git config --list                                     # Review current config
git config --unset dangerous.setting                  # Remove risky settings
```

## Branch Protection Guidelines

### Protected Branches
Never allow destructive operations on these branches:
- `main`, `master`, `develop`, `staging`, `production`
- `release/*`, `hotfix/*`, `v*.*.*`

### Safe Branch Patterns
These branches are generally safer for experiments:
- `feature/*`, `bugfix/*`, `experimental/*`, `test/*`
- `personal/*`, `draft/*`, `wip/*`

### Branch Safety Rules
```bash
# SAFE: Working on feature branches
git checkout -b feature/new-implementation
git commit -m "Add new feature"
git push origin feature/new-implementation

# DANGEROUS: Directly modifying main branches
git checkout main
git reset --hard HEAD~5  # NEVER DO THIS ON MAIN
git push --force origin main  # EXTREMELY DANGEROUS
```

## Repository Context Safety

### Safe Repository Types
- Personal development projects
- Feature branches and experiments
- Local testing repositories
- Forked repositories

### Restricted Repository Types
- Shared team repositories
- Main/master branches
- Release repositories
- CI/CD repositories

### Forbidden Repository Types
- Production repositories
- System configuration repositories
- Bare repositories with hooks
- External/third-party repositories

## Command Modifier Analysis

### Safe Flags (Always allowed)
- `--dry-run`, `-n`: Preview operations
- `--verbose`, `-v`: Detailed output
- `--help`: Documentation
- `--list`: List items
- `--show-current`: Display current state

### Dangerous Flags (Require approval)
- `--force`, `-f`: Override safety checks
- `--hard`: Destructive reset
- `--aggressive`: Intensive operations
- `--all`: Bulk operations
- `--delete`, `-D`: Deletion operations

### Restricted Flags (Generally forbidden)
- `--system`: System-wide configuration
- `--global`: Global configuration changes
- `--exec`: Execute arbitrary commands
- `--shared`: Shared repository setup

## Recovery Procedures

### Common Git Disasters and Recovery

#### 1. Accidental Hard Reset
```bash
# Problem: git reset --hard HEAD~5
# Recovery:
git reflog show HEAD
git reset --hard HEAD@{1}  # Go back to before the reset
```

#### 2. Deleted Branch
```bash
# Problem: git branch -D important-feature
# Recovery:
git reflog show --all | grep important-feature
git checkout -b important-feature <commit-hash>
```

#### 3. Force Push Disaster
```bash
# Problem: git push --force origin master
# Recovery (if others haven't pulled yet):
git reflog show origin/master
git push --force-with-lease origin <previous-commit>:master
```

#### 4. Accidentally Cleaned Files
```bash
# Problem: git clean -fd
# Recovery: Git clean operations are NOT recoverable
# Prevention: Always use git clean -n first
```

#### 5. Wrong Commit Author
```bash
# Problem: Committed with wrong identity
# Recovery:
git commit --amend --reset-author
git rebase -i HEAD~N --exec "git commit --amend --reset-author --no-edit"
```

## Safety Integration Recommendations

### Pre-execution Validation
1. **Repository State Check**: Verify clean working directory
2. **Branch Protection**: Prevent operations on protected branches  
3. **Remote Safety**: Validate remote repository URLs
4. **Backup Creation**: Auto-create reflog backups for dangerous operations

### Post-execution Monitoring
1. **Operation Logging**: Record all Git commands executed
2. **Change Detection**: Monitor for unexpected repository changes
3. **Safety Metrics**: Track dangerous operation frequency
4. **Recovery Assistance**: Provide recovery suggestions for failures

### Configuration Recommendations
```bash
# Set up safer Git defaults
git config --global push.default simple
git config --global pull.rebase true
git config --global rebase.autoStash true
git config --global core.autocrlf input
git config --global init.defaultBranch main

# Enable safety features
git config --global advice.pushNonFastForward true
git config --global advice.statusHints true
git config --global advice.commitBeforeMerge true
```

## Best Practices for CLAUDE Code Integration

### 1. Always Use Dry Run First
For any potentially destructive operation:
```bash
git clean -n        # Instead of git clean -f
git push --dry-run  # Before git push --force
git merge --dry-run # Before git merge
```

### 2. Create Safety Checkpoints  
Before dangerous operations:
```bash
git stash push -m "Safety checkpoint before operation"
git tag safety-checkpoint-$(date +%Y%m%d-%H%M%S)
```

### 3. Prefer Safer Alternatives
```bash
# Instead of git reset --hard
git stash && git reset --soft

# Instead of git push --force  
git push --force-with-lease

# Instead of git clean -f
git clean -i  # Interactive mode
```

### 4. Regular Repository Health Checks
```bash
git status --porcelain
git log --oneline -n 10
git reflog --oneline -n 10
git fsck --no-dangling
```

## Emergency Procedures

### If Dangerous Command Executed
1. **Stop immediately**: Use Ctrl+C if still running
2. **Check damage**: `git status`, `git log --oneline`
3. **Use reflog**: `git reflog show HEAD`
4. **Restore if possible**: `git reset --hard HEAD@{N}`
5. **Contact team**: If shared repository affected

### Repository Recovery Steps
1. **Assess the situation**: What command was run?
2. **Check reflog**: `git reflog show --all`
3. **Look for backups**: Check for stashes, tags, other branches
4. **Restore from remote**: `git fetch origin && git reset --hard origin/branch`
5. **Last resort**: Restore from file system backup

## Integration Checklist

### For CLAUDE Code Implementation
- [ ] Load `claude-git-permissions.json` configuration
- [ ] Implement command categorization system
- [ ] Add pre-execution validation hooks
- [ ] Create confirmation prompts for restricted operations
- [ ] Block forbidden operations completely
- [ ] Log all git operations with timestamps
- [ ] Provide recovery suggestions for failed operations
- [ ] Monitor repository health after operations

### Security Considerations
- [ ] Validate repository ownership before operations
- [ ] Check for hooks that might execute malicious code
- [ ] Verify remote URLs are safe
- [ ] Prevent operations on system directories
- [ ] Block execution of Git aliases that might be dangerous
- [ ] Monitor for suspicious configuration changes

This comprehensive safety system provides multiple layers of protection while maintaining development productivity. The key is progressive permission levels: safe operations run automatically, development operations require confirmation, restricted operations need explicit approval, and forbidden operations are completely blocked.