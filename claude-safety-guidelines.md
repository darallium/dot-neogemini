# CLAUDE Code Safety Guidelines

## Overview
This document provides safety guidelines for using CLAUDE Code with the generated permission system based on analysis of your system's executables.

## System Analysis Results
- **Total system executables**: ~3,095 in `/usr/bin`
- **Pacman-managed executables**: 3,619
- **Cargo-installed binaries**: 32
- **User-local binaries**: 7
- **ASDF-managed tools**: 16

## Permission Categories

### 🟢 SAFE (Auto-allowed)
Commands that are safe for development and analysis:
- File operations: `ls`, `cat`, `head`, `tail`, `grep`, `find`
- Development tools: `git`, `make`, `cargo`, `rustc`, `python`, `node`
- User utilities: `rg`, `fd`, `bat`, `lsd`, `delta`, `yazi`
- Text processing: `jq`, `sed`, `awk`, `cut`, `sort`

### 🟡 DEVELOPMENT (Confirmation required)
Tools that modify system state but are generally safe:
- Network operations: `ssh`, `scp`, `rsync`
- Package management: `cargo install`, `npm install`, `pip install`
- File system changes: `mkdir`, `cp`, `mv`, `ln`
- Container tools: `docker`, `podman`

### 🔴 RESTRICTED (Explicit approval required)
Potentially dangerous operations:
- File deletion: `rm`, `rmdir`
- Permission changes: `chmod`, `chown`
- System control: `systemctl`, `mount`, `umount`
- Process management: `kill`, `killall`

### ⛔ FORBIDDEN (Blocked)
Commands that should never run automatically:
- Destructive operations: `rm -rf /`, `dd if=/dev/zero`
- System formatting: `mkfs`, `fdisk` on system drives
- Privilege escalation: `sudo`, `su` without context
- Network security tools: `aircrack-ng`, wireless attack tools

## Safety Patterns

### Dangerous Command Patterns
- **Redirections to devices**: `> /dev/sd[a-z]`
- **Pipe to shell**: `curl ... | sh`, `wget ... | bash`
- **Recursive deletions**: `rm -rf /`, `rm -rf /*`
- **Blanket permissions**: `chmod 777`, `chown root`

### Safe Working Directories
- `/home/darallium/dotfiles`
- `/home/darallium/.config`
- `/home/darallium/Projects`
- `/tmp`, `/var/tmp`

### Restricted System Directories
- `/`, `/boot`, `/etc`, `/usr`, `/var`, `/sys`, `/proc`, `/dev`

## Usage Recommendations

### For Development Work
1. Always work within your home directory or designated project folders
2. Use version control (`git`) before making significant changes
3. Test commands in safe environments first
4. Review generated scripts before execution

### For System Administration
1. Never run system modification commands without review
2. Always confirm the target device for disk operations
3. Use `--dry-run` flags when available
4. Keep system backups current

### For Network Operations
1. Verify URLs before downloading and executing
2. Use secure protocols (https, ssh) when possible
3. Avoid piping network content directly to shell
4. Review downloaded scripts before execution

## Emergency Procedures

### If Dangerous Command is Executed
1. Stop the process immediately (`Ctrl+C`)
2. Check system integrity
3. Review logs: `journalctl -xe`
4. Restore from backup if necessary

### System Recovery
1. Boot from live media if system is unbootable
2. Mount filesystems as read-only initially
3. Use system rescue tools
4. Restore from known good backup

## Configuration Integration

The permission system can be integrated with CLAUDE Code by:
1. Loading `claude-permissions.json` as a configuration file
2. Implementing pre-execution validation
3. Adding user confirmation prompts for restricted commands
4. Maintaining command execution logs

## Regular Maintenance

### Monthly Tasks
- Review executed commands log
- Update permission categories based on new tools
- Check for security updates
- Verify backup systems

### After System Updates
- Re-scan for new executables
- Update permission lists
- Test safety mechanisms
- Document any changes

## Command Examples

### Safe Development Workflow
```bash
# Safe: File exploration and development
ls -la
git status
cargo build
python script.py
rg "pattern" src/

# Requires confirmation: Package installation
cargo install ripgrep
npm install -g typescript
```

### Dangerous Operations (Require approval)
```bash
# Dangerous: File deletion
rm important_file.txt

# Very dangerous: System modifications
sudo systemctl stop important-service
chmod 777 /etc/passwd
```

This permission system provides a balanced approach to safety while maintaining development productivity.