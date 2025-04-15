#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/helpers.sh"

set_save_bindings() {
	local key_bindings=$(get_tmux_option "$save_option" "$default_save_key")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/save.sh"
	done
}

set_save_all_bindings() {
	local key_bindings=$(get_tmux_option "$save_all_option" "$default_save_all_key")
	local key
	for key in $key_bindings; do
        tmux bind-key "$key" run-shell "
            for session in $(tmux list-sessions -F '#S'); do 
                \"$CURRENT_DIR/scripts/save.sh\" \"$session\"
            done 
        "
	done
}

set_load_bindings() {
	local key_bindings=$(get_tmux_option "$load_option" "$default_load_key")
	local key
	for key in $key_bindings; do
        echo "$key"
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/load.sh"
	done
}

main() {
    set_save_bindings
    set_load_bindings
}
main
