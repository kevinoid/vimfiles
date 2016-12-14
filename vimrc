" Local preferences file for Vim

set background=dark    " Set highlighting for dark background
syntax on              " Turn on syntax hilighting
set showcmd            " Show (partial) command in status line.
set showmatch          " Show matching brackets.
set incsearch          " Incremental search
set modeline	       " Give me more modes
set history=1000       " Remember what I've done for longer
set visualbell	       " Use terminal visual bell in place of beep

" Look for ctags above current directory
" https://stackoverflow.com/a/741486
set tags=./tags,./TAGS,tags,TAGS;/

" Turn on indenting
set sts=4 sw=4
if has("autocmd")
  filetype indent on
endif
autocmd FileType cmake setlocal sts=2 sw=2 et
autocmd FileType {css,less,sass,scss} setlocal sts=2 sw=2 et
autocmd FileType {html,xhtml,xml,xslt} setlocal sts=2 sw=2 et indentexpr= ai
autocmd FileType {php,c,cpp,java} setlocal sts=4 sw=4 et
autocmd FileType lua setlocal sts=8 sw=8
autocmd Filetype markdown setlocal et tw=78 spell
autocmd Filetype make setlocal sts=8 sw=8 noet
autocmd FileType php setlocal indentexpr= cindent noet ts=4
autocmd Filetype python setlocal sts=4 sw=4 et
autocmd Filetype {json,javascript,ruby} setlocal sts=2 sw=2 et
autocmd Filetype scala setlocal sts=2 sw=2 et tw=80 fo=croql
autocmd Filetype sh setlocal sts=8 sw=8 noet
autocmd Filetype yaml setlocal sts=2 sw=2 et

" Special makeprg for html/xhtml/xml
"autocmd FileType {html,xhtml} setlocal makeprg=curl\ -s\ -F\ level=error\ -F\ laxtype=yes\ -F\ out=gnu\ -F\ doc=@%\ http://localhost:8888 errorformat="\"%f\":%l.%c-%m"
autocmd FileType {html,xhtml,xml} setlocal makeprg=xmllint\ --noout\ --valid\ % errorformat=%A%f:%l:\ %m,%-C%s,%-Z%p^
" Special makeprg for javascript
"autocmd FileType javascript setlocal makeprg=jslint\ % errorformat=%f:%l:%c:\ error:\ %m,%f:%l:\ %m,%f:\ line\ %l\\,\ col\ %c\\,\ %m
autocmd FileType javascript setlocal makeprg=jscheck\ % "errorformat=%f:%l:%c:%m
" Special makeprg for php
autocmd FileType php setlocal makeprg=php\ --syntax-check\ % errorformat="%m in %f on line %l"
" Special makeprg for python
autocmd FileType python setlocal makeprg=pylint3\ --reports=n\ --msg-template=\"{path}:{line}:\ {msg_id}\ {symbol},\ {obj}\ {msg}\"\ %:p errorformat=%f:%l:\ %m
" Special makeprg for scala
" Note1: sed is required because %s matches anything, so there is no way to
"        distinguish source code lines from multiline error messages without
"        enumerating all of them
autocmd FileType scala setlocal makeprg=(sbt\ -Dsbt.log.noformat=true\ compile\ \\\|\ sed\ '/\\[[[:alpha:]]\\+\\]\ \\+^$/{$p;x;d};x;1d;${x;p}'\ ;\ beep) errorformat=
    \%E\ %#[error]\ %f:%l:\ %m,%-Z\ %#[error]\ %p^,%+C\ %#[error]\ %.%#,
    \%W\ %#[warn]\ %f:%l:\ %m,%-Z\ %#[warn]\ %p^,%+C\ %#[warn]\ %.%#

" Set keyword characters appropriately for XML and XSLT
let xml_use_xhtml = 1
autocmd FileType {xml,xslt} setlocal iskeyword=@,-,\:,48-57,_,128-167,224-235

" Interpret *.md files as Markdown (rather than modula2)
au BufRead *.md			set ft=markdown

" Interpret Jekyll files as Liquid rather than Markdown
" This way the YAML frontmatter and liquid tags are highlighted correctly
au BufRead */_drafts/*.markdown	set ft=liquid
au BufRead */_posts/*.markdown	set ft=liquid

" Interpret JavaScript modules as JavaScript
au BufRead *.jsm		set ft=javascript

" Interpret Simple Build Tool files as Scala
au BufRead *.sbt		set ft=scala

" Set appropriate defaults for composing mail in mutt
au BufRead /tmp/mutt*		set ft=mail
au BufRead /tmp/mutt*		setlocal tw=70
au BufRead /tmp/mutt* normal :g/^> -- $/,/^$/-1d^M/^$^M^L

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
