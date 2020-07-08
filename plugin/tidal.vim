" File: plugin/tidal.vim
" Author: John Murphy
" Description: tidalnvim setup

scriptencoding utf-8

if exists('g:tidalnvim_loaded')
  finish
endif
let g:tidalnvim_loaded = 1

let g:tidalnvim_root_dir = expand('<sfile>:h:h')
let g:tidalnvim_stl_widgets = {}

" augroup to be used w/ ftplugin
augroup tidalnvim
  autocmd!
augroup END


autocmd tidalnvim ColorScheme * highlight default tidalnvimEval guifg=black guibg=white ctermfg=black ctermbg=white
autocmd tidalnvim BufEnter,BufNewFile,BufRead *.tidal call tidalnvim#document#set_current_path()

" eval flash default color
highlight default tidalnvimEval guifg=black guibg=white ctermfg=black ctermbg=white

noremap <unique><script><silent> <Plug>(tidalnvim-send-line) :<c-u>call tidalnvim#send_line(0, 0)<cr>
noremap <unique><script><silent> <Plug>(tidalnvim-send-block) :<c-u>call tidalnvim#send_block()<cr>
noremap <unique><script><silent> <Plug>(tidalnvim-send-selection) :<c-u>call tidalnvim#send_selection()<cr>
noremap <unique><script><silent> <Plug>(tidalnvim-postwindow-toggle) :<c-u>call tidalnvim#postwindow#toggle()<cr>
noremap <unique><script><silent> <Plug>(tidalnvim-postwindow-clear) :<c-u>call tidalnvim#postwindow#clear()<cr>

