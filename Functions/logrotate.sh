# This function creates a logrotate configuration file for the unattended-upgrades log.
# It uses a heredoc to generate the configuration file and writes it to the
# /etc/logrotate.d/unattended-upgrades file.
# The configuration specifies that the log file should be rotated daily, with up to 7
# compressed backups kept, and empty log files should not generate a notification.
# The resulting file is owned by root and can only be created with sudo privileges.
function logrotate() {
  sudo bash -c "cat <<EOF > /etc/logrotate.d/unattended-upgrades
    /var/log/unattended-upgrades/unattended-upgrades.log {
        daily
        missingok
        rotate 7
        compress
        delaycompress
        notifempty
    }
EOF"
}