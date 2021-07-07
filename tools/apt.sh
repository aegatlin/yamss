apt__prepare() {
  ensure_command apt
}

apt__setup() {
  sudo apt update --assume-yes
  sudo apt upgrade --assume-yes
  # redundant packages do no harm, and grouping them is useful
  local packages=()

  # java/kotlin dependencies
  packages+=(jq unzip coreutils)

  # erlang/elixir dependencies
  packages+=(libssl-dev libncurses5-dev unzip)

  # postgres dependencies
  packages+=(libreadline-dev build-essential)

  # my packages
  packages+=(net-tools nmap)

  f() { sudo apt install --assume-yes "$1"; }
  for_each f "${packages[@]}"
}

apt__augment() { :; }

apt__bootstrap() { :; }
