if version >= 500

    let c_comment_strings=1

    if !exists("syntax_on")
        syntax on
    endif

    set hlsearch

    if has("gui_running")
        if has("gui_win32")
            set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h9
        endif
    endif
endif
