" Vim syntax file
" Language:	Ferite
" Maintainer:	Nazri Ramliy <nazri.ramliy@gmail.com>
" URL:		http://ferite.org/

if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  let main_syntax = 'ferite'
elseif exists("b:current_syntax") && b:current_syntax == "ferite"
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

syn match feriteVarPlain "$[A-z]\+[A-z0-9_]*" contained
syn cluster feriteInterpDQ	contains=feriteVarPlain,perlVarBlock

syn keyword feriteCommentTodo      TODO FIXME XXX TBD contained
syn match   feriteLineComment      "\/\/.*" contains=@Spell,feriteCommentTodo
syn match   feriteEval             "$[A-z]\+[A-z0-9_]*" contained
syn match   feriteEval             "${[^}]\+}" contained contains=feriteBraces
syn match   feriteCommentSkip      "^[ \t]*\*\($\|[ \t]\+\)"
syn region  feriteComment	       start="/\*"  end="\*/" contains=@Spell,feriteCommentTodo
syn match   feriteSpecial	       "\\\d\d\d\|\\."
syn region  feriteStringD	       start=+"+  skip=+\\\\\|\\"+  end=+"+	contains=@feriteInterpDQ,feriteSpecial,feriteEval,@htmlPreproc
syn region  feriteStringS	       start=+'+  skip=+\\\\\|\\'+  end=+'\|$+	contains=feriteSpecial,@htmlPreproc

syn match   feriteSpecialCharacter "'\\.'"
syn match   feriteNumber	       "-\=\<\d\+L\=\>\|0[xX][0-9a-fA-F]\+\>"
syn region  feriteRegexpString     start=+/[^/*]+me=e-1 skip=+\\\\\|\\/+ end=+/[gim]\{0,2\}\s*$+ end=+/[gim]\{0,2\}\s*[;.,)\]}]+me=e-1 contains=@htmlPreproc oneline

syn keyword feriteConditional	if else switch
syn keyword feriteFunction	arguments getClass conformsToProtocol attribute_missing method_missing recipient deliver
syn keyword feriteRepeat	while for do
syn keyword feriteBranch	break continue
syn keyword feriteOperator	new instanceof isa
syn keyword feriteType		array boolean number string void object
syn keyword feriteStatement	return using
syn keyword feriteBoolean	true false
syn keyword feriteNull		null undefined
syn keyword feriteLabel		case default
syn keyword feriteException	monitor handle
syn keyword feriteGlobal	err
syn keyword feriteQualifier	self super
syn keyword feriteModifier	static public private protected abstract final rename alias

syn keyword feriteBlocks	directive function global class modifies extends implements protocol namespace modifies
syn match	feriteBraces	   "[{}\[\]]"
syn match	feriteParens	   "[()]"

syn sync fromstart
syn sync maxlines=100

if main_syntax == "ferite"
  syn sync ccomment feriteComment
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_ferite_syn_inits")
  if version < 508
    let did_javascript_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink feriteComment		Comment
  HiLink feriteLineComment	Comment
  HiLink feriteCommentTodo	Todo
  HiLink feriteSpecial		Special
  HiLink feriteStringS		String
  HiLink feriteStringD		String
  HiLink feriteCharacter	Character
  HiLink feriteSpecialCharacter	feriteSpecial
  HiLink feriteNumber		feriteValue
  HiLink feriteConditional	Conditional
  HiLink feriteFunction		Function
  HiLink feriteRepeat		Repeat
  HiLink feriteBranch		Conditional
  HiLink feriteOperator		Operator
  HiLink feriteType		Type
  HiLink feriteStatement	Statement
  HiLink feriteFunction		Function
  HiLink feriteBraces		Function
  HiLink feriteError		Error
  HiLink javaScrParenError	feriteError
  HiLink feriteNull		Keyword
  HiLink feriteBoolean		Boolean
  HiLink feriteRegexpString	String
  HiLink feriteEval             Identifier

  HiLink feriteIdentifier	Identifier
  HiLink feriteLabel		Label
  HiLink feriteException	Exception
  HiLink feriteMessage		Keyword
  HiLink feriteGlobal		Keyword
  HiLink feriteQualifier	Keyword
  HiLink feriteModifier		Keyword
  HiLink feriteMember		Keyword
  HiLink feriteDeprecated	Exception
  HiLink feriteReserved		Keyword
  HiLink feriteDebug		Debug
  HiLink feriteConstant		Label

  HiLink feriteBlocks	Keyword

  delcommand HiLink
endif

let b:current_syntax = "ferite"
if main_syntax == 'ferite'
  unlet main_syntax
endif
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: ts=8
