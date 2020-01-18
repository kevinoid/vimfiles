" Adjust JavaScript highlighting to my tastes
" Last Change: 2020-01-18
" Maintainer:  Kevin Locke <kevin@kevinlocke.name>
" License:     CC0 1.0 Universal (CC0 1.0) Public Domain Dedication

" Adjust JavaScript highlighting to match my conceptions of the language
highlight link jsArrowFunction      Operator
highlight link jsThis               Keyword
highlight link jsSuper              Keyword
highlight link jsNull               Constant
highlight link jsUndefined          Constant
highlight link jsFutureKeys         Error

" Disable Identifier+Function highlighting, which I find to be too noisy
highlight link jsFuncName           NONE
highlight link jsFuncCall           NONE
highlight link jsGlobalObjects      NONE
highlight link jsGlobalNodeObjects  NONE
highlight link jsExceptions         NONE
highlight link jsBuiltins           NONE
highlight link jsDomErrNo           NONE
highlight link jsDomNodeConsts      NONE
