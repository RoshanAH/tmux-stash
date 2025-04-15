CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/helpers.sh"

load() {
    local res_dir
    res_dir=$(resurrect_dir)

    local session
    session=$(find "$res_dir/stash" -maxdepth 1 -type f -printf "%f\n" | fzf --tmux center --layout reverse)
    if [ -z $session ]; then
        tmux display-message "Session does not exist" 
        return 0
    fi

    if tmux has-session -t="$session" 2>/dev/null; then
        tmux switch-client -t "$session"
        tmux display-message "Switched to running session: $session"
        return 0
    fi

    ln -sf "$res_dir/stash/$session" "$res_dir/last"

    local resurrect_load
    resurrect_load=$(get_tmux_option "$resurrect_restore_path_option" "")
    if [ -n "$resurrect_load" ]; then
        "$resurrect_load" >/dev/null 2>&1
    fi

    if tmux has-session -t="$session" 2>/dev/null; then
        tmux switch-client -t "$session"
        return 0
    fi

    tmux display-message "Failed to switch to restored session: $session"
    return 1
}
load
