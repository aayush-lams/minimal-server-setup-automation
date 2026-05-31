# scripts

Deploys backup and health check scripts with cron jobs.

- **backup.sh** — Archives `/var/www/asur_site` to `/var/backups/web/`, verifies
  the archive, writes to `/var/log/backup.log`, creates a checksum, and prunes
  backups older than 7 days.
- **health.sh** — Logs system health (uptime, CPU, memory, disk, Nginx status,
  failed logins, Nginx error log tail) to `/home/guest/webadmin/daily_health.log`.

## Cron jobs

| Schedule | Script |
|----------|--------|
| Daily 02:00 | `backup.sh` |
| Daily 07:00 | `health.sh` |
| @reboot | `health.sh` (60s delay) |

All run as `asur`.
