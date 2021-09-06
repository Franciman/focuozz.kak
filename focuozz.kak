# Find the last client with the specified buffer opened

# Helper function that runs in every client to check what the active buffer name is
define-command -hidden -params 1 try-focus-client %{
    evaluate-commands %sh{
        printf "echo %s\n" "$kak_bufname"
        if [ "$kak_bufname" = "$1" ];
        then
            printf "focus\n"
            printf "fail\n"
        else
            printf "nop\n"
        fi
    }
}

define-command -buffer-completion -params 1 -docstring %{
    Focus (using :focus command) the first client whose active buffer name matches the given filename.
    If no client matches the research criterion, open the file in a new client } focuozz %{
    evaluate-commands %sh{
        # Let us iterate all the open clients
        for client in $kak_client_list
        do
            # Check whether the active buffer in this client matches the name
            # If so, focus the current client
            printf "evaluate-commands -client %s try-focus-client %s\n" "$client" "$1"
        done
        # If no client has the requested buffer active,
        # open a new window
        printf "new edit %s\n" "$1"
    }
}
