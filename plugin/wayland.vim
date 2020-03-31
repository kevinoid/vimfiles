" Workarounds for Wayland
" Last Change: 2020-03-29
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" License:     CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

" Don't enable Wayland workarounds if not running under Wayland
if empty($WAYLAND_DISPLAY)
    finish
endif

" Use wl-clipboard to access Wayland clipboard, if available
" https://github.com/vim/vim/issues/5157#issue-516033639
if executable('wl-copy')
    xnoremap "+y :call system("wl-copy", @")<cr>
    nnoremap "+p :let @"=substitute(system("wl-paste --no-newline"), '<C-v><C-m>', '', 'g')<cr>p
    nnoremap "*p :let @"=substitute(system("wl-paste --no-newline --primary"), '<C-v><C-m>', '', 'g')<cr>p
endif
