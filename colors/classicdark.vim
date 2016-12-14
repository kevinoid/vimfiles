" Vim color file
" Maintainer:	Kevin Locke <kwl7@cornell.edu>
" Last Change:	April 14, 2007
" License:	Public Domain

" This package attempts to duplicate the terminal color scheme in
" the gvim mode
"
" Mostly copied from syncolor.vim and the output of :highlight
" Converted using defines in syntax help file

" First remove all existing highlighting.
set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "classicdark"

hi Normal guifg=LightGrey guibg=Black

hi SpecialKey     term=bold ctermfg=9 gui=bold guifg=Blue
hi NonText        term=bold ctermfg=9 gui=bold guifg=Blue
hi Directory      term=bold ctermfg=11 gui=bold guifg=Cyan
hi ErrorMsg       term=standout cterm=bold gui=bold ctermfg=15 guifg=White ctermbg=4 guibg=DarkRed
hi IncSearch      term=reverse cterm=reverse gui=reverse
hi Search         term=reverse ctermfg=0 guifg=Black ctermbg=14 guibg=Brown
hi MoreMsg        term=bold ctermfg=10 gui=bold guifg=Green
hi ModeMsg        term=bold cterm=bold gui=bold
hi LineNr         term=underline ctermfg=14 guifg=Yellow
hi Question       term=standout gui=NONE ctermfg=10 guifg=Green
hi StatusLine     term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi StatusLineNC   term=reverse cterm=reverse gui=reverse
hi VertSplit      term=reverse cterm=reverse gui=reverse
hi Title          term=bold gui=NONE ctermfg=13 guifg=Magenta
hi Visual         term=reverse ctermbg=8 guibg=DarkGrey
hi VisualNOS      term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg     term=standout ctermfg=12 guifg=Red
hi WildMenu       term=standout ctermfg=0 guifg=Black ctermbg=14 guibg=Yellow
hi Folded         term=standout ctermfg=11 guifg=Cyan ctermbg=8 guibg=DarkGrey
hi FoldColumn     term=standout ctermfg=11 guifg=Cyan ctermbg=8 guibg=DarkGrey
hi DiffAdd        term=bold ctermbg=1 guibg=DarkBlue
hi DiffChange     term=bold ctermbg=5 guibg=DarkMagenta
hi DiffDelete     term=bold ctermfg=9 guifg=Blue ctermbg=3 guibg=DarkCyan
hi DiffText       term=reverse cterm=bold gui=bold guifg=White ctermbg=12 guibg=DarkRed
hi SignColumn     term=standout ctermfg=11 guifg=Cyan ctermbg=8 guibg=DarkGrey
hi SpellBad       term=reverse ctermbg=12 guibg=DarkRed
hi SpellCap       term=reverse ctermbg=9 guibg=Blue
hi SpellRare      term=reverse ctermbg=13 guibg=DarkMagenta
hi SpellLocal     term=underline ctermbg=11 guibg=DarkCyan
hi Pmenu          ctermbg=13 guibg=Magenta
hi PmenuSel       ctermbg=8 guibg=DarkGrey
hi PmenuSbar      ctermbg=7 guibg=DarkGrey
hi PmenuThumb     cterm=reverse gui=reverse
hi TabLine        term=underline cterm=underline gui=underline ctermfg=15 guifg=White ctermbg=8 guibg=DarkGrey
hi TabLineSel     term=bold cterm=bold gui=bold guifg=White
hi TabLineFill    term=reverse cterm=reverse gui=reverse
hi CursorColumn   term=reverse ctermbg=8 guibg=DarkGrey
hi CursorLine     term=underline cterm=underline gui=underline
hi MatchParen     term=reverse ctermbg=3 guibg=DarkCyan

hi Comment	term=bold cterm=NONE gui=NONE  ctermfg=Cyan guifg=Cyan ctermbg=NONE guibg=NONE
hi Constant	term=underline cterm=NONE gui=NONE  ctermfg=13 guifg=Magenta  ctermbg=NONE guibg=NONE
hi Special	term=bold cterm=NONE gui=NONE  ctermfg=12 guifg=Red  ctermbg=NONE guibg=NONE
hi Identifier	term=underline cterm=bold gui=bold  ctermfg=11 guifg=Cyan  ctermbg=NONE guibg=NONE
hi Statement	term=bold cterm=NONE gui=NONE  ctermfg=14 guifg=Yellow  ctermbg=NONE guibg=NONE
hi PreProc	term=underline cterm=NONE gui=NONE  ctermfg=9 guifg=Blue  ctermbg=NONE guibg=NONE
hi Type		term=underline cterm=NONE gui=NONE  ctermfg=10 guifg=Green  ctermbg=NONE guibg=NONE
hi Underlined	term=underline cterm=underline gui=underline  ctermfg=9 guifg=Blue
hi Ignore	term=NONE cterm=NONE gui=NONE  ctermfg=0 guifg=Black  ctermbg=NONE guibg=NONE
hi Error		term=reverse cterm=NONE gui=NONE  ctermfg=White guifg=White  ctermbg=Red guibg=Red
hi Todo		term=standout cterm=NONE gui=NONE  ctermfg=Black guifg=Black  ctermbg=Yellow guibg=Yellow

hi link String		Constant
hi link Character	Constant
hi link Number		Constant
hi link Boolean		Constant
hi link Float		Number
hi link Function	Identifier
hi link Conditional	Statement
hi link Repeat		Statement
hi link Label		Statement
hi link Operator	Statement
hi link Keyword		Statement
hi link Exception	Statement
hi link Include		PreProc
hi link Define		PreProc
hi link Macro		PreProc
hi link PreCondit	PreProc
hi link StorageClass	Type
hi link Structure	Type
hi link Typedef		Type
hi link Tag		Special
hi link SpecialChar	Special
hi link Delimiter	Special
hi link SpecialComment	Special
hi link Debug		Special
