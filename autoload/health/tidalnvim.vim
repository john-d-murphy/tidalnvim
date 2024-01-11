" File: autoload/health/tidalnvim.vim
" Author: John Murphy
" Description: Health check

scriptencoding utf-8

function! s:check_minimum_nvim_version() abort
  if !has('nvim-0.4.3')
    call v:lua.vim.health.error(
          \ 'has(nvim-0.4.3)',
          \ 'tidalnvim requires nvim 0.4.3 or later'
          \ )
  endif
endfunction

function! s:check_timers() abort
  if has('timers')
    call v:lua.vim.health.ok('has("timers") - success')
  else
    call v:lua.vim.health.warn(
          \ 'has("timers" - error)',
          \ 'tidalnvim needs "+timers" for eval flash'
          \ )
  endif
endfunction

function! s:check_tidal_executable() abort
  let user_tidal = get(g:, 'tidalnvim_configuration_file')
  if !empty(user_tidal)
    call v:lua.vim.health.info('using g:tidalnvim_configuration_file = ' . user_tidal)
  endif

  try
    let tidal = tidalnvim#util#find_tidal_executable()
    call v:lua.vim.health.info('tidal executable: ' . tidal)
  catch
    call v:lua.vim.health.error(
          \ 'could not find tidal executable',
          \ 'set g:tidalnvim_configuration_file or add tidal to your $PATH'
          \ )
  endtry
endfunction

function! health#tidalnvim#check() abort
  call v:lua.vim.health.start('tidalnvim')
  call s:check_minimum_nvim_version()
  call s:check_timers()
  call s:check_tidal_executable()
endfunction
