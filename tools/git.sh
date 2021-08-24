git__prepare() {
  message 'git__prepare'
}

git__setup() {
  message 'git__setup'
}

git__augment() {
  message 'git__augment'

  ensure_config_dir git
  config_put git/config
}

git__bootstrap() {
  message 'git__bootstrap'
}
