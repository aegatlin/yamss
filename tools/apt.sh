apt__prepare() {
  message 'apt__prepare'
}

apt__setup() {
  message 'apt__setup'

  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes

  # dependencies for java, kotlin, etc
  apt_helper_install jq unzip coreutils

  # dependencies for erlang, elixir, etc
  apt_helper_install libssl-dev libncurses5-dev unzip

  # dependencies for postgres
  apt_helper_install libreadline-dev build-essential

  # command line tools I like
  apt_helper_install mosh net-tools nmap
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
