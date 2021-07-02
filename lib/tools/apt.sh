apt__prepare() {
  ensure_command apt
  apt update --assume-yes
  apt upgrade --assume-yes
}

apt__setup() {
  # packages tmux depends on to build correctly
  apt install --assume-yes libevent-dev
  apt install --assume-yes ncurses-dev
  apt install --assume-yes build-essential
  apt install --assume-yes bison
  apt install --assume-yes pkg-config
  apt install --assume-yes zip
  apt install --assume-yes unzip
  apt install --assume-yes automake

  # my packages
  apt install --assume-yes net-tools
  apt install --assume-yes nmap
}

apt__augment() { :; }

apt__bootstrap() { :; }
