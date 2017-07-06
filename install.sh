#!/bin/bash

set -e

if [[ $EUID -eq 0 ]]; then
   echo "This script should not be run as root." 1>&2
   exit 1
fi

read -p "If you are on a slow connection executing this script with caffeinate is recommended (caffeinate -is ./install.sh)"

# Ask for the administrator password upfront.
sudo -v

VALID_INPUT=0;

while [ $VALID_INPUT -eq 0 ]
do
	read -r -p "MacBook (mb) or Mac mini (mm)? " MAC
	if [[ "$MAC" = "mb" ]]
	then
			echo "MacBook selected. (Hostname: Aperture)"
			sudo scutil --set HostName Aperture
			sudo scutil --set ComputerName Aperture
			sudo scutil --set LocalHostName Aperture
			VALID_INPUT=1;
	elif [[ "$MAC" = "mm" ]]
	then
			echo "Mac mini selected. (Hostname: Abstergo)"
			sudo scutil --set HostName Abstergo
			sudo scutil --set ComputerName Abstergo
			sudo scutil --set LocalHostName Abstergo
			VALID_INPUT=1;
	fi
done

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Installing command line tools
xcode-select --install || echo "Xcode command line tools already installed"
read -p "Press Enter when either the command line tools or Xcode are installed"
command -v clang >/dev/null 2>&1 || { echo "Command line tools aren't installed"; exit 1; }

# Installing brew if not
command -v brew >/dev/null 2>&1 || { ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

# Copy zshrc
cp .zshrc ~/

# Installing antigen
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
touch ~/.hushlogin

# Unhide library
chflags nohidden ~/Library/

# Defaults
# Don't write .DS_Store files to network drives and external storage media
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
defaults write com.apple.ImageCapture disableHotPlug -bool true
# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Trackpad: enable tap to click for the login screen
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Save screenshots in PNG format
defaults write com.apple.screencapture type -string "png"
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.menuextra.battery ShowPercent -bool true
# Crash reports as notifications
defaults write com.apple.CrashReporter UseUNC 1
# Disable MissionControl
defaults write com.apple.dashboard mcx-disabled -boolean true
# Use plain text in TextEdit
defaults write com.apple.TextEdit RichText -int 0

# Finder
defaults write com.apple.finder ShowPathbar -bool true
# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Safari
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 50

# HyperDock
defaults write de.bahoom.HyperDock disclaimer_accepted -int 1
defaults write de.bahoom.HyperDock itunes_preview_ratings -int 0
defaults write de.bahoom.HyperDock move_windows -int 0
defaults write de.bahoom.HyperDock license_accepted -int 1
defaults write de.bahoom.HyperDock keyboard_arrange -int 0

# Spotlight
defaults write com.apple.Spotlight showedLearnMore -int 1

# iTerm2
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1

# Disable Time Machine
sudo tmutil disablelocal

# Copy spectacle config
mkdir -p ~/Library/Application\ Support/Spectacle
cp Shortcuts.json ~/Library/Application\ Support/Spectacle

# Install Brewfile
brew bundle --file=BaseBrewfile || echo "Some packages could not be installed."

if [[ "$MAC" = "mb" ]]
then
		brew bundle --file=MacBookBrewfile
elif [[ "$MAC" = "mm" ]]
then
		brew bundle --file=MacMiniBrewfile
fi

# Use zsh as default shell
sudo python -c 'if not "/usr/local/bin/zsh" in open("/etc/shells").read(): open("/etc/shells", "a").write("/usr/local/bin/zsh\n")'
chsh -s /usr/local/bin/zsh

# Install rustup
curl https://sh.rustup.rs -sSf > rustup.sh
chmod +x rustup.sh
./rustup.sh -y
rm rustup.sh

echo "Additional drivers in Dropbox, install manually."

# Apply changes with reboot
read -p "Press Enter to restart (Crtl+C to skip)"
sudo reboot
