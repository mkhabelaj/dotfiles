# @document
# Check if fzf is installed
if command -v fzf &> /dev/null; then
    # @p Ctrl+R - Search command history
    # @p Ctrl+T - Search files/directories
    # @p Alt+C - cd into a directory
    # Set up fzf key bindings and fuzzy completion
    source <(fzf --zsh)
fi

