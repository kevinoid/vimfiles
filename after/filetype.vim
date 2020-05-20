" Late file type detection
"
" Maintainer:	Kevin Locke <kevin@kevinlocke.name>
" Last Change:	2020 May 19
"
" File type detection is split into 4 phases (see :help 43.2):
" 1. filetype.vim precise path pattern matching.
" 2. scripts.vim content matching from first few lines.
" 3. filetype.vim loose path pattern matching.
" 4. ftdetect/*.vim from plugins.
"
" This script contains expensive or loose file type checks, which should only
" run if none of the above steps determine a filetype.

" Only do the rest when the FileType autocommand has not been triggered yet.
if did_filetype()
  finish
endif

" Line continuation is used here, remove 'C' from 'cpoptions'
let s:cpo_save = &cpoptions
set cpoptions&vim

augroup filetypedetect

" MSBuild response files
" https://docs.microsoft.com/en-us/visualstudio/msbuild/msbuild-response-files
autocmd BufNewFile,BufRead *.rsp			setf conf

" MSBuild imports
" https://docs.microsoft.com/en-us/visualstudio/msbuild/customize-your-build
autocmd BufNewFile,BufRead *.props,*.targets
	\ if search('\C<Project', 'cnw')
	\|  setf xml
	\|endif

augroup END

" Restore 'cpoptions'
let &cpoptions = s:cpo_save
