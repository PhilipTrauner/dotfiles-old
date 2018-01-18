#!/bin/bash

set -e

if [[ $EUID -eq 0 ]]; then
	echo "This script should not be run as root." 1>&2
	exit 1
fi

COLOR='\033[0;33m'
END='\033[0m\n' # No Color
DEVICE_SPECIFIC=false

read -p "If you are on a slow connection executing this script with caffeinate is recommended (caffeinate -isd ./install.sh)"

# Ask for the administrator password upfront.
sudo -v

if system_profiler SPHardwareDataType | grep -q "Mac mini"; then
		MAC='mm'
elif system_profiler SPHardwareDataType | grep -q "MacBook Pro"; then
		MAC='mb'
else
	printf "${COLOR}Unrecognized Mac type${END}"
	exit 1
fi

read -r -p "Apply device specific settings? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	DEVICE_SPECIFIC=true
fi


if [[ "$MAC" = "mb" ]]
then
	echo "MacBook detected."
	if [ "$DEVICE_SPECIFIC" = true ] ; then
		printf "${COLOR}Setting hostname: Aperture${END}"
		sudo scutil --set HostName Aperture
		sudo scutil --set ComputerName Aperture
		sudo scutil --set LocalHostName Aperture
	fi
elif [[ "$MAC" = "mm" ]]
then
	echo "Mac mini detected."
	if [ "$DEVICE_SPECIFIC" = true ] ; then
		printf "${COLOR}Setting hostname: Abstergo${END}"
		sudo scutil --set HostName Abstergo
		sudo scutil --set ComputerName Abstergo
		sudo scutil --set LocalHostName Abstergo
		printf "${COLOR}Disabling energy saving${END}"
		sudo pmset -a displaysleep 0 womp 1 disksleep 1 autorestart 1 powernap 1
	fi
fi

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

printf "${COLOR}Installing command line tools${END}"
xcode-select --install || echo "Xcode command line tools already installed"
read -p "Press Enter when either the command line tools or Xcode are installed"
command -v clang >/dev/null 2>&1 || { echo "Command line tools aren't installed"; exit 1; }

printf "${COLOR}Installing brew${END}"
command -v brew >/dev/null 2>&1 || { ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }

printf "${COLOR}Automatically load keys into ssh-agent${END}"
mkdir -p ~/.ssh
cat > ~/.ssh/config <<EOF
Host *
	AddKeysToAgent yes
	UseKeychain yes
	IdentityFile ~/.ssh/id_rsa
EOF

printf "${COLOR}Overriding .zshrc${END}"
# Copy zshrc
cp .zshrc ~/

printf "${COLOR}Installing antigen${END}"
mkdir -p ~/.antigen
curl -L git.io/antigen > ~/.antigen/antigen.zsh
touch ~/.hushlogin

printf "${COLOR}Unhiding ~/Library${END}"
chflags nohidden ~/Library/

printf "${COLOR}Creating Developer folder${END}"
[[ -d ~/Developer ]] || mkdir ~/Developer

printf "${COLOR}Setting defaults${END}"
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
defaults write de.bahoom.HyperDock resize_windows -int 0
defaults write de.bahoom.HyperDock window_snapping_delay_near -float 0.2
defaults write de.bahoom.HyperDock titlebar_scroll_arrange -int 0

# Spotify Notifications
defaults write io.citruspi.Spotify-Notifications iconSelection -int 2
defaults write io.citruspi.Spotify-Notifications playpausenotifs -int 1

# Spotlight
defaults write com.apple.Spotlight showedLearnMore -int 1

# iTerm2
defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -int 1

printf "${COLOR}Disabling Time Machine${END}"
# Disable Time Machine
sudo tmutil disable

printf "${COLOR}Overriding Spectacle config${END}"
mkdir -p ~/Library/Application\ Support/Spectacle
cp Shortcuts.json ~/Library/Application\ Support/Spectacle

printf "${COLOR}Installing BaseBrewfile${END}"
brew bundle --file=BaseBrewfile || echo "Some packages could not be installed."

# Mac App Store apps
# (not included in Brewfile to allow for non-blocking install)
# Pixelmator, Keynote, Pages, Numbers, Xcode, Microsoft Remote Desktop 10
apps=("407963104" "409183694" "409201541" "409203825" \
	"497799835" "1295203466")

printf "${COLOR}Installing specific Brewfile${END}"
if [[ "$MAC" = "mb" ]]
then
		brew bundle --file=MacBookBrewfile

		# Solitaire
		apps+=("515113678")
		# Amphetamine
		apps+=("937984704")


elif [[ "$MAC" = "mm" ]]
then
		brew bundle --file=MacMiniBrewfile
fi

printf "${COLOR}Installing Mac App Store apps in background${END}"
mas install ${apps[*]} > /dev/null 2>&1 &


printf "${COLOR}Change shell to zsh${END}"
sudo python -c 'if not "/usr/local/bin/zsh" in open("/etc/shells").read(): open("/etc/shells", "a").write("/usr/local/bin/zsh\n")'
sudo chsh -s /usr/local/bin/zsh $(whoami)

printf "${COLOR}Installing rustup${END}"
curl https://sh.rustup.rs -sSf > rustup.sh
chmod +x rustup.sh
./rustup.sh -y
rm rustup.sh

printf "${COLOR}Resetting Launchpad${END}"
defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock

# Apply changes with reboot
read -p "Press Enter to restart (Crtl+C to skip)"
sudo reboot
