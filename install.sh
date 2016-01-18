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

# Install Brewfile
brew bundle install

# Copy zshrc
cp .zshrc ~/

# Installing antigen
mkdir ~/.antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen/antigen.zsh 
touch ~/.hushlogin

# Use zsh as default shell
sudo python -c 'if not "/usr/local/bin/zsh" in open("/etc/shells").read(): open("/etc/shells", "a").write("/usr/local/bin/zsh\n")'
chsh -s /usr/local/bin/zsh

# Unhide library
chflags nohidden ~/Library/

# Enable right click and tap
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool YES

# Some defaults
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


# Bottom right screen -> Show Desktop
defaults write com.apple.dock wvous-br-corner -int 4

# Disable Time Machine
sudo tmutil disablelocal

# Apply changes with reboot
read -p "Press Enter to restart"
sudo reboot
