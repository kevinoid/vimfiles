" Clipboard configuration
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" Last Change: 2020-10-06
" License:     Same as Vim

let s:cpoptions_save = &cpoptions
set cpoptions&vim

" Note: Don't call has('clipboard'), which breaks clipboard-providers on nvim
" https://github.com/neovim/neovim/issues/13062
if empty($WAYLAND_DISPLAY) || !executable('wl-copy')
    " Not in Wayland or wl-copy not available, leave clipboard handling alone.
elseif has('nvim')
    " Neovim clipboard provider for Wayland which strips carriage returns.
    " and handles wl-paste errors (like "No selection" when empty)
    " See https://gitlab.gnome.org/GNOME/gtk/-/issues/2307
    " See https://bugzilla.mozilla.org/1572104
    " https://github.com/neovim/neovim/issues/10223#issuecomment-521952122
    function! s:wl_paste(args)
        " Add -t UTF8_STRING to avoid getting text/html for text.
        " If some programs don't produce UTF8_STRING, open wl-clipboard
        " issue requesting support for multiple -t options.
        let output = system('wl-paste -t UTF8_STRING --no-newline '.a:args)

        " If paste failed due to lack of UTF8_STRING, retry with any type
        if v:shell_error
        \ && trim(output) ==# 'No suitable type of content copied'
            let output = system('wl-paste --no-newline '.a:args)
        endif

        if v:shell_error
            let output = trim(output)
            " 'Nothing in register +' sufficient for 'No selection'
            if output !=# 'No selection'
                " echoerr would throw, so use echohl to highlight
                echohl ErrorMsg
                echom 'wl-paste: ' . output
                echohl None
            endif
            return []
        endif
        return split(output, "\r\\?\n", 1)
    endfunction

    let g:clipboard = {
    \   'name': 'wayland-strip-carriage',
    \   'copy': {
    \      '+': 'wl-copy --foreground --type text/plain',
    \      '*': 'wl-copy --foreground --type text/plain --primary',
    \    },
    \   'paste': {
    \      '+': {-> s:wl_paste('')},
    \      '*': {-> s:wl_paste('--primary')},
    \   },
    \   'cache_enabled': 1,
    \ }
else
    " Use fakeclip for Wayland support in Vim
    " https://github.com/vim/vim/issues/5157
    " https://github.com/kana/vim-fakeclip/pull/32
    let g:fakeclip_provide_clipboard_key_mappings = 1
endif

let &cpoptions = s:cpoptions_save
unlet s:cpoptions_save
