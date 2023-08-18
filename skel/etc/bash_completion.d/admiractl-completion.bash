#/usr/bin/env bash

_admiractl_completion() {
	for w in '>' '>>' '&>' '<'; do
        if [[ $w = "${COMP_WORDS[COMP_CWORD-1]}" ]]; then
            compopt -o filenames
            COMPREPLY=($(compgen -f -- "${COMP_WORDS[COMP_CWORD]}"))
            return 0
        fi
    done

    COMPREPLY=($(/usr/bin/admiractl __autocomplete "$2" "$3"))
}

#complete -C "/home/coghi/Projects/admiractl/complete/teste __autocomplete" admiractl
complete -F _admiractl_completion admiractl