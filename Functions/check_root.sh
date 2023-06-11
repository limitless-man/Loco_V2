# Check for root privileges
function check_root() {
  if [ "$EUID" -ne 0 ]
  then
    echo "Please run as root"
    exit
  fi
}
