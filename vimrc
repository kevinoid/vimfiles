" Local preferences file for Vim

" Path to directory containing this file (~/.vim or vimfiles)
" See https://superuser.com/a/120011/141375
let s:vimhome=expand('<sfile>:p:h')

" Set b:vim_json_comments for JSON files which allow comments
" Note: Must be done before :filetype (in defaults.vim) which runs
" filetype.vim which calls :autocmd BufRead *.json setf json
if has('autocmd')
    augroup beforeFileType
        autocmd!
        autocmd BufRead .eslintrc.json let b:vim_json_comments = 1
    augroup END
endif

" Start with system defaults, if they exist (see :help defaults.vim in Vim 8+)
if !empty(glob($VIMRUNTIME.'/defaults.vim'))
    source $VIMRUNTIME/defaults.vim
endif

set background=dark    " Set highlighting for dark background
colorscheme defaultish " Use a modified default colorscheme
syntax on              " Turn on syntax hilighting
set nofixendofline     " Don't add <EOL> at end of files lacking them
                       " It adds too much churn in version control
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set incsearch          " Incremental search
set history=1000       " Remember what I've done for longer
set mouse=             " Disable mouse, which I don't often use
set visualbell	       " Use terminal visual bell in place of beep

" Save swap and backup files in vimhome
" Saving alongside the edited file allows sharing between users, but has more
" significant disadvantages for my most common uses, where it causes problems
" with build systems that rebuild on file changes (especially XSDs in ASP.NET
" Web Site Projects) and lots of unnecessary clutter on unclean vim exit.
let &backupdir=s:vimhome . '/backup/'
let &directory=s:vimhome . '/swap//'	" // to build swap path from file path

" Look for ctags above current directory
" https://stackoverflow.com/a/741486
set tags=./tags,./TAGS,tags,TAGS;/

" Turn on spell-checking by default
set spell spelllang=en_us

" Enable filetype plugins
filetype plugin on

" Add the man plugin so that we can run :Man
" Clear $MANOPT so no options which confuse man.vim get passed through
let $MANOPT=''
runtime! ftplugin/man.vim

" Use ripgrep or silver searcher for grep when available
if executable('rg')
    set grepprg=rg\ -H\ --column\ $*
    set grepformat=%f:%l:%c:%m
elseif executable('ag')
    " Note: Add /dev/null argument to get filenames in output.
    " https://github.com/ggreer/the_silver_searcher/issues/972
    set grepprg=ag\ --column\ $*\ /dev/null
    set grepformat=%f:%l:%c:%m
end

" Turn on indenting
set softtabstop=4 shiftwidth=4
filetype indent on

" Treat /bin/sh as POSIX shell rather than legacy sh
let g:is_posix=1

" Disable quote concealing in vim-json, which I find confusing
let g:vim_json_syntax_conceal = 0

" Use 2-space indent for Markdown lists
" https://github.com/plasticboy/vim-markdown/#adjust-new-list-item-indent
let g:vim_markdown_new_list_item_indent = 2

" Use xmledit ftplugin when editing HTML
let g:xml_use_xhtml = 1
let g:xmledit_enable_html = 1

" Enable language highlighting for code blocks in Markdown
" Note:  Applying all syntaxes caused massive errors, not sure why...
"let g:markdown_fenced_languages2 = map(globpath(&rtp, 'syntax/*.vim', 0, 1), 'substitute(v:val, ''.*/\(.*\)\.vim$'', ''\1'', '''')')
" Enable languages that we are likely to use and alias for pygments names.
let g:markdown_fenced_languages = [
   \ 'apache',
   \ 'c',
   \ 'cpp',
   \ 'css',
   \ 'html',
   \ 'java',
   \ 'javascript',
   \ 'js=javascript',
   \ 'json',
   \ 'ruby',
   \ 'sass',
   \ 'scala',
   \ 'sh',
   \ 'sql',
   \ 'xml',
   \ 'xhtml',
   \ 'yaml'
   \ ]

" Add ALE to statusline, simulating default around it similar to Syntastic
" https://unix.stackexchange.com/a/243667
function! LinterStatus() abort
    let counts = ale#statusline#Count(bufnr(''))
    let num_errors = counts.error + counts.style_error
    let num_warnings = counts.warning + counts.style_warning
    return '[Lint: ' .
        \ (counts.total == 0 ? 'OK' :
            \ printf('%dE %dW', num_errors, num_warnings)) .
        \ ']'
endfunction
set statusline=%f\ %h%w%m%r\ 
set statusline+=%#warningmsg#
set statusline+=%{LinterStatus()}
set statusline+=%*
set statusline+=%=%(%l,%c%V\ %=\ %P%)

" EditorConfig configuration
" Don't apply EditorConfig to files under .git (especially COMMIT_EDITMSG)
let g:EditorConfig_exclude_patterns = ['/\.git/']

" ALE configuration
" Add linter name to messages
let g:ale_echo_msg_format = '%code%: %s [%linter%]'
" Don't lint files in response to text changes (annoying and excessive)
let g:ale_lint_on_text_changed = 'never'
" Set linters for some filetypes
" sh: shell linter fails on scripts where shopt changes parsing (e.g. extglob).
"     Could convert shopt to -O options in some cases, but would be fragile.
"     shellcheck is sufficient for now.
let g:ale_linters = {
\   'sh': ['shellcheck']
\}
" Show 5 lines of errors (default: 10)
let g:ale_list_window_size = 5
" Don't lint minified files
let g:ale_pattern_options = {
    \ '\.min\.css$': {'ale_linters': [], 'ale_fixers': []},
    \ '\.min\.js$': {'ale_linters': [], 'ale_fixers': []},
    \ }
" Use binaries inside pipenv, if present
let g:ale_python_auto_pipenv = 1
" By default, ALE runs vulture on the project root which often includes files
" which should not be vulture'd (virtualenvs, docs, tests).  Exclude.
let g:ale_python_vulture_options = '--exclude ' . join([
    \ '*/site-packages/*',
    \ '*/.env/*',
    \ '*/.env[23]/*',
    \ '*/.tox/*',
    \ '*/.venv/*',
    \ '*/docs/*',
    \ '*/env/*',
    \ '*/env[23]/*',
    \ '*/tests/*',
    \ '*/venv/*',
    \ '*/venv[23]/*',
    \ ], ',')
" Don't pass -s to shellcheck, since it overrides shell directives
let g:ale_sh_shellcheck_dialect = ''
" Disable document-start rule, since I rarely find it useful
let g:ale_yaml_yamllint_options = "-d 'document-start: disable'"

if !has('autocmd')
    finish
endif

augroup fileTypeIndent
    autocmd!

    " Note: b:EditorConfig_applied is true when settings from .editorconfig
    " have been applied to the buffer.
    " Defined by after/plugin/editorconfig_applied.vim

    " Set bzr commit line length to match git convention of 72
    autocmd FileType bzr
        \ if !get(b:, 'EditorConfig_applied') | setlocal tw=72 | endif
    autocmd FileType cmake
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et | endif
    autocmd FileType {css,less,sass,scss}
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et | endif
    autocmd FileType {html,xhtml,xml,xslt}
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et | endif
    autocmd FileType {php,c,cpp,java}
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=4 sw=4 et | endif
    autocmd FileType lua
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=8 sw=8 | endif
    autocmd FileType markdown
        \ if !get(b:, 'EditorConfig_applied') |  setlocal et tw=78 | endif
    autocmd FileType make
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=8 sw=8 noet | endif
    autocmd FileType php
        \ if !get(b:, 'EditorConfig_applied') |  setlocal noet ts=4 | endif
    " Note: PS1 indentation size follows PowerShell ISE convention.
    " https://poshcode.gitbooks.io/powershell-practice-and-style/Style-Guide/Code-Layout-and-Formatting.html#indentation
    autocmd FileType ps1
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=4 sw=4 et | endif
    autocmd FileType python
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=4 sw=4 et | endif
    autocmd FileType rst
        \ if !get(b:, 'EditorConfig_applied') |  setlocal et tw=80 | endif
    autocmd FileType {json,javascript,ruby}
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et | endif
    autocmd FileType scala
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et tw=80 | endif
    autocmd FileType sh
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=8 sw=8 noet | endif
    autocmd FileType vim
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=4 sw=4 et | endif
    autocmd FileType yaml
        \ if !get(b:, 'EditorConfig_applied') |  setlocal sts=2 sw=2 et | endif
augroup END

augroup fileTypeSettings
    autocmd!

    " Disable reindenting on keystrokes other than CTRL-F and new lines (annoying)
    autocmd FileType {html,xhtml,xml,xslt,yaml} setlocal indentkeys=!^F,o,O
    " Enable spellcheck and expand folds on open
    " https://stackoverflow.com/a/8316817
    autocmd FileType markdown setlocal spell | normal zR
    autocmd FileType php setlocal indentexpr= cindent
    " Case is rarely significant in PowerShell.  Ignore by default.
    autocmd FileType ps1 setlocal ignorecase
    autocmd FileType scala setlocal fo=croql
    " Set keyword characters appropriately for XML and XSLT
    autocmd FileType {xml,xslt} setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235
augroup END

augroup pathToFileType
    autocmd!

    " Interpret *.md files as Markdown (rather than modula2)
    " This was fixed in commit 7d76c804a first included in 7.4.480
    if !has('patch-7.4.480')
        autocmd BufRead *.md set ft=markdown
    endif

    " Interpret Jekyll files as Liquid rather than Markdown
    " This way the YAML frontmatter and liquid tags are highlighted correctly
    autocmd BufRead */_drafts/*.markdown set ft=liquid
    autocmd BufRead */_posts/*.markdown set ft=liquid

    " Interpret JavaScript modules as JavaScript
    autocmd BufRead *.jsm set ft=javascript

    " Recognize *.wsdl files as XML
    " https://github.com/vim/vim/pull/3281, commit d473c8c10, release 8.1.0273
    if !has('patch-8.1.0273')
        autocmd BufRead *.wsdl set ft=xml
    endif

    " Set appropriate defaults for composing mail in mutt
    autocmd BufRead /tmp/mutt* set ft=mail
    autocmd BufRead /tmp/mutt* setlocal tw=70
    autocmd BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L
augroup END

" Update vimStartup autocmd group to exclude commits
" https://github.com/vim/vim/commit/9a48961d8bd7ffea14330b9b0181a6cdbe9288f7
augroup vimStartup
    autocmd!

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
augroup END
