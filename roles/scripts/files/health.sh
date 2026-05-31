#!/bin/sh

guest_user="guest"
auditor_dir="/home/$guest_user/webadmin"
mkdir -p "$auditor_dir"

health_log_file="$auditor_dir/daily_health.log"
datetime="$(date +%Y-%m-%d_%H%M%S)"

{
    printf "\n\n===== Daily Health Status for host : %s at date : %s =====\n\n" "$(hostname)" "$datetime"

    echo "Uptime: $(uptime -p)"
    echo "----------------------------------------"

    echo "CPU Load Average: $(awk '{print "1-Min: " $1 " | 5-Min: " $2 " | 15-Min: " $3}' /proc/loadavg)"
    echo "----------------------------------------"

    echo "Memory Usage:"
    free -m
    echo "----------------------------------------"

    echo "Disk Usage:"
    df -h
    echo "----------------------------------------"

    echo "Nginx Status: $(systemctl is-active nginx)"
    echo "----------------------------------------"

    echo "Failed login attempts: $(grep -i "failed" /var/log/auth.log 2>/dev/null | wc -l)"
    echo "----------------------------------------"

    echo "Tail of Nginx error logs:"
    tail -n 5 /var/log/nginx/error.log

} | tee -a "$health_log_file"
