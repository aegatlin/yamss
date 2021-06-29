apt__prepare() {
  ensure_command apt
}

apt__setup() {
  apt install curl
  apt install git
  apt install net-tools
  apt install nmap
}

apt__augment() { :; }

apt__bootstrap() { :; }
