#!/bin/bash

read -p "If you are on a slow connection executing this script with caffeinate is recommended (caffeinate -is ./install.sh)"

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Installing command line tools
xcode-select --install
read -p "Press Enter when either the command line tools or Xcode are installed"
command -v clang >/dev/null 2>&1 || { echo "Command line tools aren't installed"; exit 1; }

# Installing brew if not
command -v brew >/dev/null 2>&1 || { ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

# Copy zshrc
cp .zshrc ~/

# Installing antigen
mkdir ~/.antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen/antigen.zsh
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
# Bottom right screen -> Show Desktop
defaults write com.apple.dock wvous-br-corner -int 4
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
defaults write com.apple.menuextra.battery ShowPercent -bool true
# Enable right click and tap with two fingers
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true

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
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Time Machine
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Dock
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 50

# iTunes
defaults write com.apple.iTunes disableAppleMusic -int 1
defaults write com.apple.iTunes disableMusicStore -int 1
defaults write com.apple.iTunes disableArtistConnect -int 1
defaults write com.apple.iTunes disablePodcasts -int 0
defaults write com.apple.iTunes disableRadio -int 1
defaults write com.apple.iTunes doesAccountArtistListHaveSharePermission -int 1
defaults write com.apple.iTunes disableSharedMusic -int 0

# HyperDock
defaults write de.bahoom.HyperDock disclaimer_accepted -int 1
defaults write de.bahoom.HyperDock itunes_preview_ratings -int 1
defaults write de.bahoom.HyperDock move_windows -int 0
defaults write de.bahoom.HyperDock license_accepted -int 1
defaults write de.bahoom.HyperDock keyboard_arrange -int 0

# Spotlight
defaults write com.apple.Spotlight showedLearnMore -int 1

# iTerm2
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Disable Time Machine
sudo tmutil disablelocal

# Install Brewfile
brew bundle install

# Use zsh as default shell
sudo python -c 'if not "/usr/local/bin/zsh" in open("/etc/shells").read(): open("/etc/shells", "a").write("/usr/local/bin/zsh\n")'
chsh -s /usr/local/bin/zsh

# Install App Store apps
apps=("1114363220" "937984704" "497799835" "409201541" "409183694" "515113678")
# TermHere, Amphetamine, Xcode, Pages, Keynote, Solitaire

for app in "${apps[@]}"
do
	if [[ $(mas list | grep "$app") ]]; then
		echo "App $app already installed."
	else
		mas install "$app"
	fi
done

# Apply changes with reboot
read -p "Press Enter to restart (Crtl+C to skip)"
sudo reboot
