#!/bin/sh

working_dir='/var/backups/web'

mkdir -p "$working_dir"

datetime="$(date +%Y-%m-%d_%H%M%S)"
backup_file="$working_dir/backup-$datetime.tar.gz"
target_dir='/var/www/asur_site'
backup_log_file='/var/log/backup.log'

echo "Working in: $working_dir | Creating: $backup_file | Target: $target_dir"
tar -czvf "$backup_file" "$target_dir"
tar -tzf "$backup_file" > /dev/null 2>&1

exit_code=$?

if [ $exit_code -ne 0 ]; then
    echo "Error: Archive is corrupted or creation failed!"
    echo "backup status : $datetime : Failed (Exit Code $exit_code)" | tee -a "$backup_log_file" > /dev/null
    echo "wrote to backup log file: $backup_log_file"
    exit 1
else
    echo "Success: Archive verified cleanely."
    echo "backup status : $datetime : Success" | tee -a "$backup_log_file" > /dev/null
    echo "wrote to backup log file: $backup_log_file"
fi

sha256sum "$backup_file" | tee -a "$working_dir/checksum.txt" >/dev/null
echo "created check sum file"

find "$working_dir" -name "backup-*.tar.gz" -mtime +7 -delete
echo "deleted the old files"

exit 0
