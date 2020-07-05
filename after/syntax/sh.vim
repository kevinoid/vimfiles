" Adjust sh syntax to support local for dash
" Last Change: 2020-07-05
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" License:     CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

" If buffer is Debian Almquist shell (based on shellcheck shell=dash directive)
if search('\C^\s*#\s*shellcheck\s\+\%(.*\s\)\?shell=dash\%(\s\|$\)', 'cnw')
    " Treat local builtin like export
    syn region shSetList oneline matchgroup=shSet start="\<\(local\)\>\ze[/]\@!" end="$"		matchgroup=shSetListDelim end="\ze[}|);&]" matchgroup=NONE end="\ze\s\+[#=]"	contains=@shIdList
endif
