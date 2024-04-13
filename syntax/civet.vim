" Language:    Civet
" Maintainer:  Taha Ben Masaud <tbm206@gmail.com>
" URL:         https://github.com/tbm206/vim-civet
" License:     MIT

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'civet'
  finish
endif

" Include JavaScript for civetEmbed.
syn include @civetJS syntax/javascript.vim
silent! unlet b:current_syntax

" Highlight long strings.
syntax sync fromstart

" These are `matches` instead of `keywords` because vim's highlighting
" priority for keywords is higher than matches. This causes keywords to be
" highlighted inside matches, even if a match says it shouldn't contain them --
" like with civetAssign and civetDot.
syn match civetStatement /\<\%(return\|break\|continue\|throw\)\>/ display
hi def link civetStatement Statement

syn match civetRepeat /\<\%(for\|while\|until\|loop\)\>/ display
hi def link civetRepeat Repeat

syn match civetConditional /\<\%(if\|else\|unless\|switch\|when\|then\)\>/
\                           display
hi def link civetConditional Conditional

syn match civetException /\<\%(try\|catch\|finally\)\>/ display
hi def link civetException Exception

syn match civetKeyword /\<\%(new\|in\|of\|from\|by\|and\|or\|not\|is\|isnt\|class\|extends\|super\|do\|yield\|debugger\|import\|export\|default\|await\)\>/ display
hi def link civetKeyword Keyword

syn match civetOperator /\<\%(instanceof\|typeof\|delete\)\>/ display
hi def link civetOperator Operator

" The first case matches symbol operators only if they have an operand before.
syn match civetExtendedOp /\%(\S\s*\)\@<=[+\-*/%&|\^=!<>?.]\{-1,}\|[-=]>\|--\|++\|:/ display
syn match civetExtendedOp /\<\%(and\|or\)=/ display
hi def link civetExtendedOp civetOperator

" This is separate from `civetExtendedOp` to help differentiate commas from dots.
syn match civetSpecialOp /[,;]/ display
hi def link civetSpecialOp SpecialChar

syn match civetBoolean /\<\%(true\|on\|yes\|false\|off\|no\)\>/ display
hi def link civetBoolean Boolean

syn match civetGlobal /\<\%(null\|undefined\)\>/ display
hi def link civetGlobal Type

" A special variable
syn match civetSpecialVar /\<\%(this\|prototype\|arguments\)\>/ display
hi def link civetSpecialVar Special

" Set syntax to civet
if !exists('b:current_syntax')
  let b:current_syntax = 'civet'
endif
