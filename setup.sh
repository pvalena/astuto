#!/bin/bash

set -e
bash -n "$0"

RPMS=(
coreutils
cpio
git
libxml2-devel
libxslt-devel
nano
nodejs
postgresql
redhat-rpm-config
ruby
ruby-devel
sed
shadow-utils
sqlite
strace
sudo
tmux
util-linux
which
xz
yarnpkg
zlib-devel
zsh
)

GEMS=(
administrate
bundler
foreman
concurrent-ruby
i18n
concurrent-ruby
i18n
thread_safe
tzinfo
minitest
zeitwerk
activesupport
rack
rack-test
nokogiri
webpacker
`tr -s ' ' < Gemfile \
  | sed -e 's/^\s*//' \
  | grep -E '^\s*gem ' \
  | cut -d"," -f1 \
  | cut -d"'" -f2 \
  | grep -v '^gem '`
)

set -xe

sudo dnf install -y 'dnf-command(copr)'
sudo dnf copr enable -y 'pvalena/rubygems'

sudo dnf group install "C Development Tools and Libraries" -y
sudo dnf install -y ${RPMS[@]}

set +e

PKGS="$(echo ${GEMS[@]} | tr -s ' ' '\n' | xargs -i echo "rubygem({})")"
sudo dnf install -y --skip-broken $PKGS

echo ${GEMS[@]} | tr -s ' ' '\n' | xargs -i bash -c "set -x; gem info '{}' -q | grep -q '^{} ' && exit 0; gem install '{}' || exit 255"
