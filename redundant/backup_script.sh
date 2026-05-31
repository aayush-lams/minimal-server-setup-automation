#!/bin/sh

working_dir='/var/backups/web'

sudo mkdir -p "$working_dir"

datetime="$(date +%Y-%m-%d_%H%M%S)"
backup_file="$working_dir/backup-$datetime.tar.gz"
target_dir='/var/www/asur_site'
backup_log_file='/var/log/backup.log'

#check paths
echo "Working in: $working_dir | Creating: $backup_file | Target: $target_dir"
# #tar the file
sudo tar -czvf  "$backup_file" "$target_dir"
# #check if tar -eq empty
tar -tzf "$backup_file" > /dev/null 2>&1

exit_code=$?

# #check result and write to log file
if [ $exit_code -ne 0 ]; then
    echo "Error: Archive is corrupted or creation failed!"
    echo "backup status : $datetime : Failed (Exit Code $exit_code)" | sudo tee -a "$backup_log_file" > dev/null
    echo "wrote to backup log file: $backup_log_file"
    exit 1
else
    echo "Success: Archive verified cleanely."
    echo "backup status : $datetime : Success" | sudo tee -a "$backup_log_file" > /dev/null
    echo "wrote to backup log file: $backup_log_file"
fi

# #gen checksum file
sha256sum "$backup_file" | sudo tee -a "$working_dir/checksum.txt" >/dev/null
echo "created check sum file"

# #delete older than 7 days tar files
find "$working_dir" -name "backup-*.tar.gz" -mtime +7 -delete
echo "deleted the old files"

exit 0
