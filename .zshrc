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

read -r -d '' SPOTIFY_STATUS << EOM
on is_running(appName)
    tell application "System Events" to (name of processes) contains appName
end is_running

if is_running("Spotify") then
	tell application "Spotify"
		if (player state as string) is equal to "playing"
			set currentTrack to name of current track as string
			set currentArtist to artist of current track as string
  
    			set output to ("▶️  " & currentTrack & " - " & currentArtist)
			do shell script "echo " & quoted form of output
		end if
	end tell
end if
EOM

osascript -e "$SPOTIFY_STATUS"
curl "wttr.in/$(curl -s http://ip-api.com/json | python -c "import sys, json; print json.load(sys.stdin)['city'].replace(' ', '+')" 2>/dev/null )?0?q" 2>/dev/null
