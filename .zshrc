source ~/.antigen/antigen.zsh
if [[ -a ~/.iterm2_shell_integration.zsh ]]; then
	source ~/.iterm2_shell_integration.zsh
fi

. `brew --prefix`/etc/profile.d/z.sh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle nmap
antigen bundle jsontools
antigen bundle brew
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
alias update="mas upgrade && brew update && brew upgrade && brew cask update"
alias lsblk="diskutil list"

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

export PATH="/usr/local/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$HOME/.cargo/bin"
export MANPATH="/usr/local/man:$MANPATH"
export EDITOR="nano"
