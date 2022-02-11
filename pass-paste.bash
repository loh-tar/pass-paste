# pass-paste completion file for bash
# version 0.8 - feb 2022

PASSWORD_STORE_EXTENSION_COMMANDS+=(paste)

__password_store_extension_complete_paste() {
    # Build pass file name out of current input data
    # see _pass_complete_entries () from original pass completion file
    local prefix="${PASSWORD_STORE_DIR:-$HOME/.password-store/}"
    prefix="${prefix%/}/"
    local suffix=".gpg"
    local passFile="${prefix}${COMP_WORDS[2]}${suffix}"

    # Don't try to complete when we have already a winner, otherwise will the content of
    # the password store again offered. No idea why we need this check here
    if [[ ! -f "${passFile}" ]] ; then
        COMPREPLY+=($(compgen -W "" -- ${cur}))
        _pass_complete_entries 1
    fi
}
