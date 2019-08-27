#!/usr/bin/env bash

# install brew if it doesn't exist
[[ $(command -v "brew") ]] || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install bitbar if it doesn't exist
[[ -d /Applications/BitBar.app ]] || brew cask install bitbar

bitbar_dir=~/bitbar-plugins

mkdir -p $bitbar_dir

# writes plugin directory
defaults write com.matryer.Bitbar pluginsDirectory "$bitbar_dir"

ln -s $(pwd)/vpn /usr/local/bin/vpn

cp bitbar-plugins/* $bitbar_dir/