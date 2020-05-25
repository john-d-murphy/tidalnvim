" File: ftplugin/tidal/tidal.vim
" Author: John Murphy
" Description: General settings

scriptencoding utf-8

if exists('b:did_tidalnvim')
  finish
endif
let b:did_tidalnvim = 1

" matchit
"let b:match_skip = 's:scComment\|scString\|scSymbol'
"let b:match_words = '(:),[:],{:}'

" help
setlocal keywordprg=:tidalnvimHelp

