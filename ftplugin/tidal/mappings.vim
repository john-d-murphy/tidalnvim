" File: ftplugin/tidal/mappings.vim
" Author: John Murphy
" Description: tidalnvim mappings

scriptencoding utf-8

if exists('b:did_tidalnvim_mappings')
  finish
endif
let b:did_tidalnvim_mappings = 1

if !exists('g:tidalnvim_no_mappings') || !g:tidalnvim_no_mappings
  if !hasmapto('<Plug>(tidalnvim-send-line)', 'ni')
    nmap <buffer> <M-e> <Plug>(tidalnvim-send-line)
    imap <buffer> <M-e> <c-o><Plug>(tidalnvim-send-line)
  endif

  if !hasmapto('<Plug>(tidalnvim-send-selection)', 'x')
    xmap <buffer> <C-e> <Plug>(tidalnvim-send-selection)
  endif

  if !hasmapto('<Plug>(tidalnvim-send-block)', 'ni')
    nmap <buffer> <C-e> <Plug>(tidalnvim-send-block)
    imap <buffer> <C-e> <c-o><Plug>(tidalnvim-send-block)
  endif

  if !hasmapto('<Plug>(tidalnvim-hard-stop)', 'ni')
    nmap <buffer> <F12> <Plug>(tidalnvim-hard-stop)
    imap <buffer> <F12> <c-o><Plug>(tidalnvim-hard-stop)
  endif

  if !hasmapto('<Plug>(tidalnvim-postwindow-toggle)', 'ni')
    nmap <buffer> <CR> <Plug>(tidalnvim-postwindow-toggle)
    imap <buffer> <M-CR> <c-o><Plug>(tidalnvim-postwindow-toggle)
  endif

  if !hasmapto('<Plug>(tidalnvim-postwindow-clear)', 'ni')
    nmap <buffer> <M-L> <Plug>(tidalnvim-postwindow-clear)
    imap <buffer> <M-L> <c-o><Plug>(tidalnvim-postwindow-clear)
  endif
endif
