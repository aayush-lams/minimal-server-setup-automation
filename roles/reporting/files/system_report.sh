#!/bin/bash
# System Documentation Script

REPORT_FILE="/home/asur/system_report.txt"
SITE_DIR="/var/www"

{
    echo "========================================="
    echo "SYSTEM REPORT - $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Hostname: $(hostname)"
    echo "========================================="
    echo ""

    echo "=== SITE STRUCTURE ==="
    if [ -d "$SITE_DIR" ]; then
        tree "$SITE_DIR" 2>/dev/null || ls -la "$SITE_DIR"
    else
        echo "$SITE_DIR does not exist"
    fi
    echo ""

    echo "=== BLOCK DEVICES ==="
    lsblk
    echo ""

    echo "=== DISK USAGE ==="
    df -h
    echo ""

    echo "=== MEMORY USAGE ==="
    free -m
    echo ""

    echo "=== RUNNING PROCESSES ==="
    ps aux --sort=-%cpu | head -20
    echo ""

    echo "=== TOP PROCESSES (Batch Mode) ==="
    top -bn1 | head -20
    echo ""

    echo "=== LISTENING PORTS ==="
    ss -tulpn 2>/dev/null || netstat -tulpn 2>/dev/null
    echo ""

    echo "=== SYSTEM USERS ==="
    cat /etc/passwd | grep -E "^(asur|guest|root)" || echo "Users not found"
    echo ""

    echo "=== SUDO CONFIGURATION ==="
    cat /etc/sudoers | grep -v "^#" | grep -v "^$" || echo "No sudo rules"
    echo ""

    echo "=== FAILED LOGIN ATTEMPTS ==="
    journalctl -u sshd --since "7 days ago" | grep "Failed password" | tail -10 || echo "No failed attempts"
    echo ""

    echo "========================================="
    echo "END OF REPORT"
    echo "========================================="

} | tee -a "$REPORT_FILE"

echo "Report appended to: $REPORT_FILE"
