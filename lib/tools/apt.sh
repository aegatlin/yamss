apt__prepare() {
  ensure_command apt
  apt update --assume-yes
  apt upgrade --assume-yes
}

apt__setup() {
  apt install --assume-yes make
  apt install --assume-yes automake
  apt install --assume-yes zip
  apt install --assume-yes net-tools
  apt install --assume-yes nmap
}

apt__augment() { :; }

apt__bootstrap() { :; }
