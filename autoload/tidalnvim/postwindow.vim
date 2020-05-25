" File: tidalnvim/autoload/postwindow.vim
" Author: John Murphy
" Description: tidalnvim post window

scriptencoding utf-8

let s:bufnr = 0
let s:bufname = get(g:, 'tidalnvim_postwin_title', '[tidal]')

function! tidalnvim#postwindow#create() abort
  if bufexists(s:bufname)
    let s:bufnr = bufnr(s:bufname)
    let winnr = bufwinnr(s:bufnr)
    let should_close = 0
    if winnr < 0
      call tidalnvim#postwindow#open()
      " open to get the winnr
      let winnr = bufwinnr(s:bufnr)
      let should_close = 1
    endif
    execute winnr . 'wincmd w'
    setlocal filetype=tidalnvim
    execute 'wincmd p'
    " restore if postwindow was closed
    if should_close
      call tidalnvim#postwindow#close()
    endif
  endif
  if s:bufnr == 0
    let s:bufnr = s:create_post_window()
  endif
  return s:bufnr
endfunction

function! tidalnvim#postwindow#open() abort
  let settings = tidalnvim#util#get_user_settings()
  let orientation = settings.post_window.orientation
  let direction = settings.post_window.direction
  let size = settings.post_window.calc_size()

  let cmd = 'silent keepjumps keepalt '
  let cmd .= printf('%s %s sbuffer!%d', orientation, direction, s:bufnr)
  let cmd .= printf(' | %s resize %d | wincmd p', orientation, size)
  execute cmd
endfunction

function! tidalnvim#postwindow#close() abort
  let bufnr = tidalnvim#postwindow#get_bufnr()
  let winnr = bufwinnr(bufnr)
  if winnr > 0
    execute winnr . 'close'
  endif
endfunction

function! tidalnvim#postwindow#destroy() abort
  try
    let bufnr = tidalnvim#postwindow#get_bufnr()
    execute 'bwipeout' . bufnr
    let s:bufnr = 0
  catch
    call tidalnvim#util#err(v:exception)
  endtry
endfunction

function! tidalnvim#postwindow#toggle() abort
  try
    if !tidalnvim#sclang#is_running()
      throw 'tidal not running'
    endif
    let settings = tidalnvim#util#get_user_settings()
    let bufnr = tidalnvim#postwindow#get_bufnr()
    let winnr = bufwinnr(bufnr)

    if winnr < 0
      call tidalnvim#postwindow#open()
    else
      call tidalnvim#postwindow#close()
    endif
  catch
    call tidalnvim#util#err(v:exception)
  endtry
endfunction

function! tidalnvim#postwindow#clear() abort
  try
    let bufnr = tidalnvim#postwindow#get_bufnr()
    call nvim_buf_set_lines(bufnr, 0, -1, v:true, [])
  catch
    call tidalnvim#util#err(v:exception)
  endtry
endfunction

function! tidalnvim#postwindow#get_bufnr() abort
  if s:bufnr
    return s:bufnr
  else
    throw 'tidal not started'
    return -1
  endif
endfunction

function! s:create_post_window() abort
  let settings = tidalnvim#util#get_user_settings()
  let orientation = settings.post_window.orientation
  let direction = settings.post_window.direction
  let size = settings.post_window.size

  let cmd = 'silent keepjumps keepalt '
  let cmd .= printf('%s %s new', orientation, direction)
  let cmd .= printf(' | %s resize %d', orientation, size)
  execute cmd

  setlocal filetype=tidalnvim "This may be allowed to be 'tidal' - check on what it actually does when you get it running
  execute printf('file %s', s:bufname)
  keepjumps keepalt wincmd p
  return bufnr('$')
endfunction
