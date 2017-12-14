" Local preferences file for Vim

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

" Use pathogen to load all bundles
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

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

" Use xmledit ftplugin when editing HTML
let g:xml_use_xhtml = 1
let g:xmledit_enable_html = 1

if has('autocmd')
    autocmd FileType cmake setlocal sts=2 sw=2 et
    autocmd FileType {css,less,sass,scss} setlocal sts=2 sw=2 et
    " Disable reindenting on keystrokes other than CTRL-F and new lines (annoying)
    autocmd FileType {html,xhtml,xml,xslt} setlocal sts=2 sw=2 et indentkeys=!^F,o,O
    autocmd FileType {php,c,cpp,java} setlocal sts=4 sw=4 et
    autocmd FileType lua setlocal sts=8 sw=8
    autocmd Filetype markdown setlocal et tw=78 spell
    autocmd Filetype make setlocal sts=8 sw=8 noet
    autocmd FileType php setlocal indentexpr= cindent noet ts=4
    autocmd Filetype python setlocal sts=4 sw=4 et
    autocmd Filetype {json,javascript,ruby} setlocal sts=2 sw=2 et
    autocmd Filetype scala setlocal sts=2 sw=2 et tw=80 fo=croql
    autocmd Filetype sh setlocal sts=8 sw=8 noet
    " Disable reindenting on keystrokes other than CTRL-F and new lines (annoying)
    autocmd Filetype yaml setlocal sts=2 sw=2 et indentkeys=!^F,o,O

    " Special makeprg for CSS
    autocmd FileType css setlocal makeprg=csslint\ --quiet\ --format=compact\ % errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m
    " Special makeprg for html/xhtml/xml
    "autocmd FileType {html,xhtml} setlocal makeprg=curl\ -s\ -F\ level=error\ -F\ laxtype=yes\ -F\ out=gnu\ -F\ doc=@%\ http://localhost:8888 errorformat="\"%f\":%l.%c-%m"
    autocmd FileType {html,xhtml,xml} setlocal makeprg=xmllint\ --noout\ --valid\ % errorformat=%A%f:%l:\ %m,%-C%s,%-Z%p^
    " Special makeprg for javascript
    "autocmd FileType javascript setlocal makeprg=jslint\ % errorformat=%f:%l:%c:\ error:\ %m,%f:%l:\ %m,%f:\ line\ %l\\,\ col\ %c\\,\ %m
    autocmd FileType javascript setlocal makeprg=jscheck\ % "errorformat=%f:%l:%c:%m
    " Special makeprg for perl
    autocmd FileType perl setlocal makeprg=perlcritic\ --verbose\ 1\ %
    " Special makeprg for php
    autocmd FileType php setlocal makeprg=phpcs\ -q\ --report=emacs\ %
    "autocmd FileType php setlocal makeprg=php\ --syntax-check\ % errorformat="%m in %f on line %l"
    " Special makeprg for python
    function! s:SetPythonMakeprg()
        let l:pylint = getline(1) =~# 'python3' ? 'pylint3' : 'pylint'
        let &l:makeprg = l:pylint . ' --reports=n --msg-template="{path}:{line}: {msg_id} {symbol}, {obj} {msg}" %:p'
        setlocal errorformat=%f:%l:\ %m
    endfunction
    autocmd FileType python call s:SetPythonMakeprg()
    " Special makeprg for scala
    " Note1: sed is required because %s matches anything, so there is no way to
    "        distinguish source code lines from multiline error messages without
    "        enumerating all of them
    autocmd FileType scala setlocal makeprg=(sbt\ -Dsbt.log.noformat=true\ compile\ \\\|\ sed\ '/\\[[[:alpha:]]\\+\\]\ \\+^$/{$p;x;d};x;1d;${x;p}'\ ;\ beep) errorformat=
	\%E\ %#[error]\ %f:%l:\ %m,%-Z\ %#[error]\ %p^,%+C\ %#[error]\ %.%#,
	\%W\ %#[warn]\ %f:%l:\ %m,%-Z\ %#[warn]\ %p^,%+C\ %#[warn]\ %.%#
    " makeprg for sh
    autocmd FileType sh setlocal makeprg=shellcheck\ -f\ gcc\ %\ \\\|\ grep\ -v\ local.*SC2039
    " makeprg for vim
    autocmd FileType vim setlocal makeprg=vint\ -s\ %
    " makeprg for yaml
    autocmd Filetype yaml setlocal makeprg=yamllint\ -fparsable\ %

    " Set keyword characters appropriately for XML and XSLT
    autocmd FileType {xml,xslt} setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235

    " Interpret *.md files as Markdown (rather than modula2)
    autocmd BufRead *.md			set ft=markdown

    " Interpret Jekyll files as Liquid rather than Markdown
    " This way the YAML frontmatter and liquid tags are highlighted correctly
    autocmd BufRead */_drafts/*.markdown	set ft=liquid
    autocmd BufRead */_posts/*.markdown	set ft=liquid

    " Interpret JavaScript modules as JavaScript
    autocmd BufRead *.jsm		set ft=javascript

    " Interpret Simple Build Tool files as Scala
    autocmd BufRead *.sbt		set ft=scala

    " Set appropriate defaults for composing mail in mutt
    autocmd BufRead /tmp/mutt*		set ft=mail
    autocmd BufRead /tmp/mutt*		setlocal tw=70
    autocmd BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L

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

endif

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
