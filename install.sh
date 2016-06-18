#!/bin/bash

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Copy zshrc and default shell fix
cp .zshrc ~/
cp .bashrc ~/

# Installing antigen
mkdir ~/.antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen/antigen.zsh
touch ~/.hushlogin

# Install z
mkdir ~/.z-stuff
git clone https://github.com/rupa/z ~/.z-stuff

# Install similar packages to the ones avaliable on brew
sudo apt-get install zsh nginx build-essential nmap unrar tree

# Recent nodejs versions aren't avaliabe in the Ubuntu 14.04 repos
curl -sL https://deb.nodesource.com/setup | sudo bash -
sudo apt-get install nodejs

# Change shell to zsh
sudo chsh -s /bin/zsh

