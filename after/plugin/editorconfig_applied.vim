" Plugin which defines b:EditorConfig_applied for buffers where settings from
" an .editorconfig file have been applied.
" Last Change: 2019-03-06
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" License:     CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

function! s:EditorConfigApplied(config) abort
    let b:EditorConfig_applied = 1
endfunction
call editorconfig#AddNewHook(function('s:EditorConfigApplied'))
