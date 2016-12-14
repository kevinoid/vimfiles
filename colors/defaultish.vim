" Vim color file
" Maintainer:	Kevin Locke <kevin@kevinlocke.name>
" Last Change:	2016 Oct 29

" This color scheme is based on the default color scheme, but with bright
" background colors replaced by dark ones.

" Remove all existing highlighting and set the defaults.
hi clear

" Load the syntax highlighting defaults, if it's enabled.
if exists("syntax_on")
  syntax reset
endif

" Override bright background colors with dark ones
if &bg == "dark"
  hi DiffText	ctermbg=1
  hi Error	ctermbg=1
  hi SpellBad	ctermbg=1
  hi SpellLocal	ctermbg=6
  hi vimError	ctermbg=1
endif

let colors_name = "defaultish"

" vim: sw=2
