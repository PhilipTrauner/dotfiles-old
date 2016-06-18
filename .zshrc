source ~/.antigen/antigen.zsh
if [[ -a ~/.iterm2_shell_integration.zsh ]]; then
	source ~/.iterm2_shell_integration.zsh
fi

. ~/.z-stuff/z.sh

antigen use oh-my-zsh
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen theme PhilipTrauner/zsh-bundle themes/texas
antigen apply

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

transfer() {
    # write to output to tmpfile because of progress bar
    tmpfile=$( mktemp -t transferXXX )
    curl --progress-bar --upload-file $1 https://transfer.sh/$(basename $1) >> $tmpfile;
    cat $tmpfile;
    rm -f $tmpfile;
}

ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
export MANPATH="/usr/local/man:$MANPATH"
export EDITOR='nano'
