#!/bin/sh

log_color() {
  color_code="$1"
  shift
  printf "\033[${color_code}m%s\033[0m\n" "$*" >&2
}

log_red() {
  log_color "0;31" "$@"
}

log_blue() {
  log_color "0;34" "$@"
}

log_check() {
  log_blue "✅" "$@"
}

log_task() {
  log_blue "🔃" "$@"
}

log_action() {
  log_red "📝" "$@"
}

log_error() {
  log_red "❌" "$@"
}

error() {
  log_error "$@"
  exit 1
}


# Check if the script is being run as root
if [ "$(id -u)" != "0" ]; then
  log_task "This script must be run as root. I repeat this script with 'sudo'."
  sudo sh "$0" "$@"  # run this script again with sudo
  exit 0
fi

if [ -n "${CODESPACES}" ] && [ -x "$(command -v node)" ]; then
  log_task "Begin codespace bootstrapping..."
  sudo sh "./codespace.sh"
  exit 0
fi