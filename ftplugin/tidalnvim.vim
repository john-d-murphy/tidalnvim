" tidalnvim post window
setlocal buftype=nofile
setlocal bufhidden=hide
setlocal noswapfile
setlocal nonumber nornu nolist nomodeline nowrap
setlocal nocursorline nocursorcolumn colorcolumn=
setlocal foldcolumn=0 nofoldenable winfixwidth
setlocal tabstop=4

" toggle mapping
if !exists('g:tidal_no_mappings') || !g:tidalnvim_no_mappings
  if !hasmapto('<Plug>(tidal-postwindow-toggle)', 'ni')
    nmap <buffer> <CR> <Plug>(tidal-postwindow-toggle)
    imap <buffer> <M-CR> <c-o><Plug>(tidal-postwindow-toggle)
  endif
endif

" close
nnoremap <buffer><silent> q :close<cr>
