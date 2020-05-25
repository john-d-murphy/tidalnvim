scriptencoding utf-8

function! tidalnvim#util#err(msg) abort
  echohl ErrorMsg | echom '[tidalnvim] ' . a:msg | echohl None
endfunction

function! tidalnvim#util#find_tidal_executable() abort

    let tidal_exepath = ''

    let config_file = get(g:, 'tidalnvim_configuration_file', '')
    if !empty(config_file)
        let ghci = exepath('ghci')
        if (!empty(ghci))
            let tidal_exepath = expand(ghci) . " -ghci-script " . config_file
        endif
    elseif !empty(exepath('tidal'))
        let tidal_exepath = exepath('tidal')
    endif
    return tidal_exepath
endfunction

function! tidalnvim#util#calc_postwindow_size() abort
    let user_defined = get(g:, 'tidalnvim_postwin_size')
    if user_defined
        return user_defined
    endif
    let settings = tidalnvim#util#get_user_settings()
    let orientation = settings.post_window.orientation
    if orientation ==# 'vertical'
        let size = &columns / 2
    else
        let size = &lines / 3
    endif
    return size
endfunction

function! tidalnvim#util#get_user_settings() abort
    if exists('g:tidalnvim_user_settings')
        return g:tidalnvim_user_settings
    endif

    let post_win_orientation = get(g:, 'tidalnvim_postwin_orientation', 'v')
    let post_win_direction = get(g:, 'tidalnvim_postwin_direction', 'right')
    let post_win_auto_toggle = get(g:, 'tidalnvim_postwin_auto_toggle', 1)

    if post_win_direction ==# 'right'
        let post_win_direction = 'botright'
    elseif post_win_direction ==# 'left'
        let post_win_direction = 'topleft'
    else
        throw "valid directions are: 'left' or 'right'"
    endif

    if post_win_orientation ==# 'v'
        let post_win_orientation = 'vertical'
        let default_size = &columns / 2
    elseif post_win_orientation ==# 'h'
        let post_win_orientation = ''
        let default_size = &lines / 3
    else
        throw "valid orientations are: 'v' or 'h'"
    endif

    let post_win_size = get(g:, 'tidalnvim_postwin_size', default_size)
    let postwin = {
                \ 'direction': post_win_direction,
                \ 'orientation': post_win_orientation,
                \ 'size': post_win_size,
                \ 'calc_size': function('tidalnvim#util#calc_postwindow_size'),
                \ 'auto_toggle': post_win_auto_toggle,
                \ }

    let helpwin = {
                \ 'id': 0,
                \ }

    let tidal_executable = tidalnvim#util#find_tidal_executable()
    let paths = {
                \ 'tidal_executable': tidal_executable,
                \ }

    let settings = {
                \ 'paths': paths,
                \ 'post_window': postwin,
                \ 'help_window': helpwin,
                \ }

    " cache settings
    let g:tidalnvim_user_settings = settings
    return settings
endfunction
