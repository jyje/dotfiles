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

check_and_install() {
  # Loop through the list of package names
  for package in "$@"
  do
    # Check if the package is installed
    if ! dpkg-query -W --showformat='${Status}\n' "$package" | grep "installed" > /dev/null; then
      # If the package is not installed, install it
      log_task "$package is not installed... intall now"
      sudo apt-get -qq -y install "$package"
    fi
  done
}

# Check if the script is being run as root
if [ "$(id -u)" != "0" ]; then
  log_task "This script must be run as root. I repeat this script with 'sudo'."
  sudo sh "$0" "$@"  # run this script again with sudo
  exit 0
fi

# log_check "Become 'root' and do basic configuration"
# sudo timedatectl set-timezone Asia/Seoul
sudo apt-get -qq update

check_and_install jq

log_check "Update archives and repos"
new_archive_url="mirror.kakao.com"
sudo sed -i "s#http://[^/]*\.com/#http://$new_archive_url/#g" /etc/apt/sources.list
sudo apt-get -qq update

check_and_install curl zsh 

if ! [ -d "$HOME/.oh-my-zsh" ]; then
  log_task "omz is not installed... intall now"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# log_task "Update archives and repos"

if ! [ -f "${HOME}/.p10k.zsh" ]; then
  log_task "p10k is not installed... intall now"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi
