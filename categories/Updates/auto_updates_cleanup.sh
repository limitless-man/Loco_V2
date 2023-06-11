function auto_updates_cleanup() {
    system_cleanup
    restore_unattended_default
    configure_autoupdates
    logrotate
}
