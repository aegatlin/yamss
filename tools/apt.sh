apt__prepare() {
  message 'apt__prepare'
}

apt__setup() {
  message 'apt__setup'

  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes

  apt_helper_install jq unzip coreutils # java & kotlin
  apt_helper_install libssl-dev libncurses5-dev unzip # erlang & elixir
  apt_helper_install libreadline-dev build-essential # postgres
  apt_helper_install net-tools nmap # cool tools I like
}

apt__augment() {
  message 'apt__augment'
}

apt__bootstrap() {
  message 'apt__bootstrap'
}

# Warning from apt itself:
# WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
apt_helper_install() {
  for package in "$@"; do
    if ! apt list --installed | grep -q "$package"; then
      sudo apt install --assume-yes "$package"
    fi
  done
}
