source ~/.antigen/antigen.zsh
if [[ -a ~/.iterm2_shell_integration.zsh ]]; then
	source ~/.iterm2_shell_integration.zsh
fi

. `brew --prefix`/etc/profile.d/z.sh

antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme PhilipTrauner/zsh-bundle themes/texas
antigen apply

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias flushdns='dscacheutil -flushcache'
alias dnsflush='dscacheutil -flushcache'
alias fumount='diskutil force umount'

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"
export EDITOR='nano'
