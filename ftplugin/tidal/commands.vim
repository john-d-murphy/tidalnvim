" File: ftplugin/tidal/commands.vim
" Author: John Murphy
" Description: tidalnvim commands

scriptencoding utf-8

if exists('b:did_tidalnvim_commands')
  finish
endif

let b:did_tidalnvim_commands = 1

command! -buffer TidalNvimStart call tidalnvim#tidal#open()
command! -buffer TidalNvimStop call tidalnvim#tidal#close()
