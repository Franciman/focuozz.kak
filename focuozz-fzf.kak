# Integrating focuozz with peneira fuzzy finder

require-module fzf

set-option global fzf_highlight_command 'bat'

define-command -override focuozz-files %{
    fzf -preview -kak-cmd %{focuozz} -items-cmd 'find -L . -type f'
}

define-command -override focuozz-git %{
    fzf -preview -kak-cmd %{focuozz} -items-cmd 'git ls-files'
}

define-command -override focuozz-rg %{
    fzf -kak-cmd %{evaluate-commands} -items-cmd "rg --line-number --no-column --no-heading --color=never '' 2>/dev/null" -filter %{sed -E 's/([^:]+):([^:]+):.*/focuozz \1; execute-keys \2gvc/'}
}

declare-user-mode focuozz-mode

map -docstring 'Search files' global focuozz-mode f ':focuozz-files<ret>'
map -docstring 'Search files in git repo' global focuozz-mode g ':focuozz-git<ret>'
map -docstring 'Search using ripgrep' global focuozz-mode r ':focuozz-rg<ret>'

define-command -override enter-focuozz-mode %{
    enter-user-mode focuozz-mode
}
