" Detect filetypes not matched by extension
"
" Based on https://github.com/vim/vim/blob/v8.0.0402/runtime/scripts.vim
"
" This file is called by an autocommand for every file that has just been
" loaded into a buffer.  It checks if the type of file can be recognized by
" the file contents.  The autocommand is in $VIMRUNTIME/filetype.vim.

" Only do the rest when the FileType autocommand has not been triggered yet.
if did_filetype()
  finish
endif

let s:line1 = getline(1)

if s:line1 =~ "^#!"
  " A script that starts with "#!".

  " Check for a line like "#!/usr/bin/env VAR=val bash".  Turn it into
  " "#!/usr/bin/bash" to make matching easier.
  if s:line1 =~ '^#!\s*\S*\<env\s'
    let s:line1 = substitute(s:line1, '\S\+=\S\+', '', 'g')
    let s:line1 = substitute(s:line1, '\<env\s\+', '', '')
  endif

  " Get the program name.
  " Only accept spaces in PC style paths: "#!c:/program files/perl [args]".
  " If the word env is used, use the first word after the space:
  " "#!/usr/bin/env perl [path/args]"
  " If there is no path use the first word: "#!perl [path/args]".
  " Otherwise get the last word after a slash: "#!/usr/bin/perl [path/args]".
  if s:line1 =~ '^#!\s*\a:[/\\]'
    let s:name = substitute(s:line1, '^#!.*[/\\]\(\i\+\).*', '\1', '')
  elseif s:line1 =~ '^#!.*\<env\>'
    let s:name = substitute(s:line1, '^#!.*\<env\>\s\+\(\i\+\).*', '\1', '')
  elseif s:line1 =~ '^#!\s*[^/\\ ]*\>\([^/\\]\|$\)'
    let s:name = substitute(s:line1, '^#!\s*\([^/\\ ]*\>\).*', '\1', '')
  else
    let s:name = substitute(s:line1, '^#!\s*\S*[/\\]\(\i\+\).*', '\1', '')
  endif

    " JavaScript
    " Note: Can be removed after https://github.com/vim/vim/pull/1530 merged
  if s:name =~ 'node\>' || s:name =~ 'nodejs\>' || s:name =~ 'rhino\>'
    set ft=javascript

    " Haskell
    " Note: Can be removed after https://github.com/vim/vim/pull/1530 merged
  elseif s:name =~ 'haskell'
    set ft=haskell

    " Scala
    " Note: Can be removed after https://github.com/vim/vim/pull/1530 merged
  elseif s:name =~ 'scala\>'
    set ft=scala

  endif
  unlet s:name

endif
