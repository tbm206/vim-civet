" Language:    Civet
" Maintainer:  Taha Ben Masaud <tbm206@gmail.com>
" URL:         https://github.com/tbm206/vim-civet
" License:     MIT

" Bail if our syntax is already loaded.
if exists('b:current_syntax') && b:current_syntax == 'civet'
  finish
endif

silent! unlet b:current_syntax

" Highlight long strings.
syntax sync fromstart

" These are `matches` instead of `keywords` because vim's highlighting
" priority for keywords is higher than matches. This causes keywords to be
" highlighted inside matches, even if a match says it shouldn't contain them --
" like with civetAssign and civetDot.
syntax match civetStatement /\<\%(return\|break\|continue\|throw\)\>/ display
highlight def link civetStatement Statement

syntax match civetRepeat /\<\%(for\|while\|until\|loop\)\>/ display
highlight def link civetRepeat Repeat

syntax match civetConditional /\<\%(if\|else\|unless\|switch\|when\|then\)\>/
\ display
highlight def link civetConditional Conditional

syntax match civetException /\<\%(try\|catch\|finally\)\>/ display
highlight def link civetException Exception

syntax match civetKeyword /\<\%(new\|in\|of\|from\|by\|and\|or\|not\|is\|isnt\|class\|extends\|super\|do\|yield\|debugger\|import\|export\|default\|await\)\>/ display
highlight def link civetKeyword Keyword

syntax match civetOperator /\<\%(instanceof\|typeof\|delete\)\>/ display
highlight def link civetOperator Operator

" The first case matches symbol operators only if they have an operand before.
syntax match civetExtendedOp /\%(\S\s*\)\@<=[+\-*/%&|\^=!<>?.]\{-1,}\|[-=]>\|--\|++\|:/ display
syntax match civetExtendedOp /\<\%(and\|or\)=/ display
highlight def link civetExtendedOp civetOperator

" Pipe Operator
syntax match civetPipeOp /\<\%(|>\)\>/ display
highlight def link civetPipeOp civetOperator

" This is separate from `civetExtendedOp` to help differentiate commas from dots.
syntax match civetSpecialOp /[,;]/ display
highlight def link civetSpecialOp SpecialChar

syntax match civetBoolean /\<\%(true\|on\|yes\|false\|off\|no\)\>/ display
highlight def link civetBoolean Boolean

syntax match civetGlobal /\<\%(null\|undefined\)\>/ display
highlight def link civetGlobal Type

" A special variable
syntax match civetSpecialVar /\<\%(this\|prototype\|arguments\)\>/ display
highlight def link civetSpecialVar Special

" An @-variable
syntax match civetSpecialIdent /@\%(\%(\I\|\$\)\%(\i\|\$\)*\)\?/ display
highlight def link civetSpecialIdent Identifier

" A class-like name that starts with a capital letter
syntax match civetObject /\<\u\w*\>/ display
highlight def link civetObject Structure

" A constant-like name in SCREAMING_CAPS
syntax match civetConstant /\<\u[A-Z0-9_]\+\>/ display
highlight def link civetConstant Constant

" A variable name
syntax cluster civetIdentifier contains=civetSpecialVar,civetSpecialIdent,civetObject,civetConstant

" A non-interpolated string
syntax cluster civetBasicString contains=@Spell,civetEscape
" An interpolated string
syntax cluster civetInterpString contains=@civetBasicString,civetInterp

" Regular strings
syntax region civetString start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@civetInterpString
syntax region civetString start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@civetBasicString
highlight def link civetString String

" Template strings
syntax region civetTemplateString start=+`+ skip=+\\`+ end=+`+ contains=civetTemplateExpression,jsSpecial extend
highlight def link civetTemplateString String
syntax match civetTaggedTemplate /\<\K\k*\ze`/ nextgroup=civetTemplateString
highlight def link civetTaggedTemplate String

" A integer, including a leading plus or minus
syntax match civetNumber /\%(\i\|\$\)\@<![-+]\?\d\+\%(e[+-]\?\d\+\)\?/ display
" A hex, binary, or octal number
syntax match civetNumber /\<0[xX]\x\+\>/ display
syntax match civetNumber /\<0[bB][01]\+\>/ display
syntax match civetNumber /\<0[oO][0-7]\+\>/ display
syntax match civetNumber /\<\%(Infinity\|NaN\)\>/ display
highlight def link civetNumber Number

" A floating-point number, including a leading plus or minus
syntax match civetFloat /\%(\i\|\$\)\@<![-+]\?\d*\.\@<!\.\d\+\%([eE][+-]\?\d\+\)\?/ display
highlight def link civetFloat Float

" An error for reserved keywords, taken from the RESERVED array:
syntax match civetReservedError /\<\%(case\|function\|var\|void\|with\|const\|let\|enum\|native\|implements\|interface\|package\|private\|protected\|public\|static\)\>/ display
highlight def link civetReservedError Error

syntax keyword civetTodo TODO FIXME XXX contained
highlight def link civetTodo Todo

syntax region civetComment        start=+//+ end=/$/ contains=civetTodo,@Spell extend keepend
syntax region civetComment        start=+/\*+  end=+\*/+ contains=civetTodo,@Spell fold extend keepend
syntax region civetEnvComment     start=/\%^#!/ end=/$/ display
highlight def link civetComment Comment

" A normal object assignment
syntax match civetObjAssign /@\?\%(\I\|\$\)\%(\i\|\$\)*\s*\ze::\@!/ contains=@civetIdentifier display
highlight def link civetObjAssign Identifier

syntax region civetInterp matchgroup=civetInterpDelim start=/#{/ end=/}/ contained contains=@civetAll
highlight def link civetInterpDelim PreProc

" A string escape sequence
syntax match civetEscape /\\\d\d\d\|\\x\x\{2\}\|\\u\x\{4\}\|\\./ contained display
highlight def link civetEscape SpecialChar

" A regex -- must not follow a parenthesis, number, or identifier, and must not
" be followed by a number
syntax region civetRegex start=#\%(\%()\|\%(\i\|\$\)\@<!\d\)\s*\|\i\|\.\)\@<!/=\@!\s\@!# end=#/[gimy]\{,4}\d\@!# oneline contains=@civetBasicString,civetRegexCharSet
syntax region civetRegexCharSet start=/\[/ end=/]/ contained contains=@civetBasicString
highlight def link civetRegex String
highlight def link civetRegexCharSet civetRegex

" An error for trailing whitespace, as long as the line isn't just whitespace
syntax match civetSpaceError /\S\@<=\s\+$/ display
highlight def link civetSpaceError Error

" An error for trailing semicolons, for help transitioning from JavaScript
syntax match civetSemicolonError /;$/ display
highlight def link civetSemicolonError Error

" Ignore reserved words in dot accesses.
syntax match civetDotAccess /\.\@<!\.\s*\%(\I\|\$\)\%(\i\|\$\)*/he=s+1 contains=@civetIdentifier
highlight def link civetDotAccess civetExtendedOp

" Ignore reserved words in prototype accesses.
syntax match civetProtoAccess /::\s*\%(\I\|\$\)\%(\i\|\$\)*/he=s+2 contains=@civetIdentifier
highlight def link civetProtoAccess civetExtendedOp

" This is required for interpolations to work.
syntax region civetCurlies matchgroup=civetCurly start=/{/ end=/}/
\ contains=@civetAll
syntax region civetBrackets matchgroup=civetBracket start=/\[/ end=/\]/
\ contains=@civetAll
syntax region civetParens matchgroup=civetParen start=/(/ end=/)/
\ contains=@civetAll

" These are highlighted the same as commas since they tend to go together.
highlight def link civetBlock civetSpecialOp
highlight def link civetBracket civetBlock
highlight def link civetCurly civetBlock
highlight def link civetParen civetBlock

syntax cluster civetAll contains=civetStatement,civetRepeat,civetConditional,
\ civetException,civetKeyword,civetOperator,
\ civetExtendedOp,civetSpecialOp,civetBoolean,
\ civetGlobal,civetSpecialVar,civetSpecialIdent,
\ civetObject,civetConstant,civetString,
\ civetNumber,civetFloat,civetReservedError,
\ civetObjAssign,civetComment,
\ civetRegex,civetTemplateString, civetTaggedTemplate,
\ civetSpaceError,
\ civetSemicolonError,civetDotAccess,
\ civetProtoAccess,civetCurlies,civetBrackets,
\ civetParens

" Set syntax to civet
if !exists('b:current_syntax')
  let b:current_syntax = 'civet'
endif
