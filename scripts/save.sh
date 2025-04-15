CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/helpers.sh"

save() {
    local resurrect_save=$(get_tmux_option "$resurrect_save_path_option" "")
    if [ -n "$resurrect_save" ]; then
        "$resurrect_save" >/dev/null 2>&1
    fi
    local res_dir
    res_dir=$(resurrect_dir)
    mkdir -p "$res_dir/stash"
    local session_name
    if [ -z "$1" ]; then 
        session_name=$(tmux display-message -p '#S')
    else
        session_name="$1"
    fi
    sed "s/state.*/state $session_name/" "$res_dir/last" | awk -v s="$session_name" '$2 == s' > "$res_dir/stash/$session_name" 
}
save "$1"
