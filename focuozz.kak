# Find the last client with the specified buffer opened

# Helper function that runs in every client to check what the active buffer filename is
define-command -hidden -params 1 try-focus-client-buffile %{
    evaluate-commands %sh{
        if [ "$kak_buffile" = "$1" ];
        then
            printf "focus\n"
            printf "fail\n"
        else
            printf "nop\n"
        fi
    }
}

# Helper function that runs in every client to check what the active buffer name is
define-command -hidden -params 1 try-focus-client-bufname %{
    evaluate-commands %sh{
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
    Focus (using :focus command) the first client whose active buffer *absolute filename* refers to the same file
    of the given input filepath.
    If no client matches the research criterion, open the file in a new client } focuozz-filepath %{
    evaluate-commands %sh{
        # Let us find the absolute path of the input filepath, this is for making sure paths
        # refer to the same file
        absolute_path=$(realpath "$1")

        # Let us iterate all the open clients
        for client in $kak_client_list
        do
            # Check whether the active buffer in this client matches the name
            # If so, focus the current client
            printf "evaluate-commands -client %s try-focus-client-buffile %s\n" "$client" "$absolute_path"
        done
        # If no client has the requested buffer active,
        # open a new window
        # Notice that here we don't use the absolute path, this is because the name
        # could potentially be longer without adding more info, so we directly use the path provided by the user
        printf "new edit %s\n" "$1"
    }
}

define-command -buffer-completion -params 1 -docstring %{
    Focus (using :focus command) the first client whose active buffer name matches the given name.
    If no client matches the research criterion, open the file in a new client } focuozz %{
    evaluate-commands %sh{
        # Let us iterate all the open clients
        for client in $kak_client_list
        do
            # Check whether the active buffer in this client matches the name
            # If so, focus the current client
            printf "evaluate-commands -client %s try-focus-client-bufname %s\n" "$client" "$1"
        done
        # If no client has the requested buffer active,
        # open a new window
        printf "new edit %s\n" "$1"
    }
}
