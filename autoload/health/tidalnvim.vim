" File: autoload/health/tidalnvim.vim
" Author: John Murphy
" Description: Health check

scriptencoding utf-8

function! s:check_minimum_nvim_version() abort
  if !has('nvim-0.4.3')
    call health#report_error(
          \ 'has(nvim-0.4.3)',
          \ 'tidalnvim requires nvim 0.4.3 or later'
          \ )
  endif
endfunction

function! s:check_timers() abort
  if has('timers')
    call health#report_ok('has("timers") - success')
  else
    call health#report_warn(
          \ 'has("timers" - error)',
          \ 'tidalnvim needs "+timers" for eval flash'
          \ )
  endif
endfunction

function! s:check_tidal_executable() abort
  let user_tidal = get(g:, 'tidalnvim_configuration_file')
  if !empty(user_tidal)
    call health#report_info('using g:tidalnvim_configuration_file = ' . user_tidal)
  endif

  try
    let tidal = tidalnvim#util#find_tidal_executable()
    call health#report_info('tidal executable: ' . tidal)
  catch
    call health#report_error(
          \ 'could not find tidal executable',
          \ 'set g:tidalnvim_configuration_file or add tidal to your $PATH'
          \ )
  endtry
endfunction

function! health#tidalnvim#check() abort
  call health#report_start('tidalnvim')
  call s:check_minimum_nvim_version()
  call s:check_timers()
  call s:check_tidal_executable()
endfunction
