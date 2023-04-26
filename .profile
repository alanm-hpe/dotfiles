export PATH=${PATH}:$HOME/bin
export PATH=${PATH}:$HOME/google-cloud-sdk/bin
export PATH=${PATH}:$HOME/.config/superinit/cmds/cray_venv/bin
export PATH=${PATH}:$HOME/.config/superinit/cmds/sat_venv/bin
export PATH="${PATH}:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Users/alanm/bin"

export BASH_SILENCE_DEPRECATION_WARNING=1

#eval "$(register-python-argcomplete sat)"

eval "$(_CRAY_COMPLETE=source_bash cray)"
export CRAY_FORMAT=json

alias vim=nvim

function superinit_sat {
  export REQUESTS_CA_BUNDLE="/Users/alanm/.config/superinit/$(cat ~/.config/superinit/active_system)/platform-ca-certs.crt"
  $HOME/.config/superinit/cmds/sat_venv/bin/sat --token-file ~/.config/cray/tokens/$(echo $(cray config get core.hostname) | sed -e 's/https:\/\///' -e 's/\./_/g' -e "s/$/.$USER/g") $@
}
alias sat=superinit_sat

function s {
    local system=${1}; shift || die "no system name specified"
    ssh root@${system}-ncn-m001.hpc.amslabs.hpecorp.net "${@}"
}

function t {
  VAR=$1
  export PROMPT_COMMAND='echo -ne "\033]0;${VAR}\007"'
}

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

parse_supercomputer() {
     active_super=~/.config/superinit/active_system
     if [[ -f $active_super ]]; then cat $active_super 2> /dev/null | sed 's/.*/ (&)/'; fi
}

alias say="say -v Daniel"

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

export PS1="arbus \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\]\[\033[35m\]\$(parse_supercomputer)\[\033[00m\] $ "

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/alanm/google-cloud-sdk/path.bash.inc' ]; then . '/Users/alanm/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/alanm/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/alanm/google-cloud-sdk/completion.bash.inc'; fi
