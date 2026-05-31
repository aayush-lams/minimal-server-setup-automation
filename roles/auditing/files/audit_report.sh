#!/bin/bash
# Weekly audit report for auditor

REPORT="/home/guest/audit_report_$(date +%Y%m%d).txt"

{
    echo "AUDIT REPORT - $(date)"
    echo "================================"
    echo ""
    echo "=== Recent User Changes ==="
    ausearch -k user_modification --start -7d 2>/dev/null | head -50
    echo ""
    echo "=== Recent Sudo Changes ==="
    ausearch -k sudo_modification --start -7d 2>/dev/null | head -20
    echo ""
    echo "=== Failed Login Attempts ==="
    lastb | head -20
    echo ""
    echo "=== Current Logged-in Users ==="
    who
    echo ""
    echo "=== Sudo Commands Executed ==="
    journalctl -u sudo --since -7d | tail -30
} > "$REPORT"

chmod 640 "$REPORT"
chown guest:guest "$REPORT"

echo "Audit report generated: $REPORT"
