# Installing command line tools
xcode-select --install
read -p "Press Enter when either the command line tools or Xcode are installed"
command -v clang >/dev/null 2>&1 || { echo "Command line tools aren't installed"; exit 1; }

# Installing brew if not
command -v brew >/dev/null 2>&1 || { ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"; }
brew install cask

# Install Brewfile
brew bundle install

# Copy zshrc
cp .zshrc ~/

# Installing antigen
mkdir ~/.antigen
curl -L https://raw.githubusercontent.com/zsh-users/antigen/master/antigen.zsh > ~/.antigen/antigen.zsh 
touch ~/.hushlogin

# Use zsh as default shell
echo "/usr/local/bin/zsh" >> /etc/shells
chsh -s /usr/local/bin/zsh

# Install apps
echo "Download and install following applications (⌘ + Double Click)"

APPS=( "http://www.sublimetext.com/3" )

for app in "${APPS[@]}"
do
	echo $app
done
