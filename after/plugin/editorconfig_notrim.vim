" Plugin to prevent editorconfig-vim from trimming trailing whitespace
" (which causes problems for existing files)
" https://github.com/editorconfig/editorconfig-vim/issues/106
" Last Change: 2019-06-25
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" License:     CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

" TODO: Trim trailing whitespace on changed lines only.

function! s:EditorConfigNoTrim(config) abort
    autocmd! editorconfig_trim_trailing_whitespace
endfunction
call editorconfig#AddNewHook(function('s:EditorConfigNoTrim'))
