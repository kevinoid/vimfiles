" Local preferences file for Vim

" Path to directory containing this file (~/.vim or vimfiles)
" See https://superuser.com/a/120011/141375
let s:vimhome=expand('<sfile>:p:h')

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
set hlsearch           " Highlight search results
set incsearch          " Incremental search
set history=1000       " Remember what I've done for longer
set mouse=             " Disable mouse, which I don't often use
set undofile           " Save undo information for files (:undo-persistence)
set visualbell	       " Use terminal visual bell in place of beep

" quickfix shortcuts
" https://begriffs.com/posts/2019-07-19-history-use-vim.html#edit-compile-cycle
nmap ]q :cnext<cr>
nmap ]Q :clast<cr>
nmap [q :cprev<cr>
nmap [Q :cfirst<cr>

" Save swap and backup files in vimhome
" Saving alongside the edited file allows sharing between users, but has more
" significant disadvantages for my most common uses, where it causes problems
" with build systems that rebuild on file changes (especially XSDs in ASP.NET
" Web Site Projects) and lots of unnecessary clutter on unclean vim exit.
let &backupdir=s:vimhome . '/backup/'
let &directory=s:vimhome . '/swap//'	" // to build swap path from file path
let &undodir=s:vimhome . '/undo//'	" // to build undo path from file path

" Look for ctags above current directory
" https://stackoverflow.com/a/741486
set tags=./tags,./TAGS,tags,TAGS;/

" Enable securemodeline plugin with verbose messages
" Disable builtin modeline support to avoid securemodelines warning
set nomodeline
let g:secure_modelines_verbose=1
runtime! bundle/securemodelines/plugin/securemodelines.vim

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

" Use xmledit for editing HTML
let g:xml_use_xhtml = 1

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

if !has('autocmd')
    finish
endif

augroup fileTypeIndent
    autocmd!

    " Set bzr commit line length to match git convention of 72
    autocmd FileType bzr setlocal tw=72
    autocmd FileType cmake setlocal sts=2 sw=2 et
    autocmd FileType {css,less,sass,scss} setlocal sts=2 sw=2 et
    autocmd FileType {html,xhtml,xml,xslt} setlocal sts=2 sw=2 et
    autocmd FileType {php,c,cpp,java} setlocal sts=4 sw=4 et
    autocmd FileType lua setlocal sts=8 sw=8
    autocmd FileType markdown setlocal et tw=78
    autocmd FileType make setlocal sts=8 sw=8 noet
    autocmd FileType php setlocal indentexpr= cindent noet ts=4
    " Note: PS1 indentation size follows PowerShell ISE convention.
    " https://poshcode.gitbooks.io/powershell-practice-and-style/Style-Guide/Code-Layout-and-Formatting.html#indentation
    autocmd FileType ps1 setlocal sts=4 sw=4 et
    autocmd FileType python setlocal sts=4 sw=4 et
    autocmd FileType rst setlocal et tw=80
    autocmd FileType {json,javascript,ruby} setlocal sts=2 sw=2 et
    autocmd FileType scala setlocal sts=2 sw=2 et tw=80
    autocmd FileType sh setlocal sts=8 sw=8 noet
    autocmd FileType vim setlocal sts=4 sw=4 et
    autocmd FileType yaml setlocal sts=2 sw=2 et
augroup END

augroup fileTypeSettings
    autocmd!

    " Disable reindenting on keystrokes other than CTRL-F and new lines (annoying)
    autocmd FileType {html,xhtml,xml,xslt,yaml} setlocal indentkeys=!^F,o,O
    " Enable spellcheck and expand folds on open
    " https://stackoverflow.com/a/8316817
    autocmd FileType markdown setlocal spell | normal zR
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

    " Match additional systemd files added in 63b74a8362 (8.1.1048)
    if !has('patch-8.1.1048')
        " Systemd overrides
        autocmd BufNewFile,BufRead /etc/systemd/system/*.d/*.conf	setf systemd
        " Systemd temp files
        autocmd BufNewFile,BufRead /etc/systemd/system/*.d/.#*	setf systemd
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
