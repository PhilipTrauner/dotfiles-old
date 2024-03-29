source ~/.antigen/antigen.zsh
if [[ -a ~/.iterm2_shell_integration.zsh ]]; then
	source ~/.iterm2_shell_integration.zsh
fi

if [ -x "$(command -v direnv)" ]; then
	eval "$(direnv hook zsh)"
fi

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle python
antigen bundle nmap
antigen bundle brew
antigen bundle ssh-agent
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme cypher
antigen apply

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias flushdns="dscacheutil -flushcache"
alias dnsflush="dscacheutil -flushcache"
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
alias update="mas upgrade && brew update && brew upgrade"
alias lsblk="diskutil list"
alias resetlaunchpad="defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock"
alias recovery='sudo nvram "recovery-boot-mode=unused" && sudo reboot'

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/TeX/texbin:$HOME/.cargo/bin"
export MANPATH="/usr/local/man:$MANPATH"
export EDITOR="nano"