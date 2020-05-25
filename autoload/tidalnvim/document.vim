" File: tidalnvim/autoload/document.vim
" Author: John Murphy
" Description: tidalnvim document

scriptencoding utf-8

function! tidalnvim#document#set_current_path() abort
  if tidalnvim#tidal#is_running()
    let path = expand('%:p')
    let cmd = printf('tidalnvim.currentPath = "%s"', path)
    call tidalnvim#tidal#send_silent(cmd)
  endif
endfunction
