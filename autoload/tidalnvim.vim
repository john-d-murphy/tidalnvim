" File: tidalnvim/autoload/tidalnvim.vim
" Author: John Murphy
" Description: tidalnvim interface
"

scriptencoding utf-8

" Crib these functions from the current tidal-vim package

function! tidalnvim#send_line(start, end) abort
    let is_single_line = (a:start == a:end)
    if is_single_line
        let line = line('.')
        let str = getline(line)
        call tidalnvim#tidal#send(str)
        call s:flash(line, line, 'n')
    else
        let tidal_command = ''
        let lines = getline(a:start, a:end)

        " Strip out any comments from the block
        for line in lines
            let line = substitute(line, '--.*', '', '')
            let tidal_command = tidal_command . line
        endfor

        " Goal here is to join all the lines into one command and then replace all
        " control characters (e.g. vim newlines) with spaces. There is likely a better
        " way of doing this.
        let tidal_command = substitute(tidal_command, '[[:cntrl:]]', ' ', 'g')
        call s:flash(a:start - 1, a:end + 1, 'n')
        call tidalnvim#tidal#send(tidal_command)
    endif
endfunction

function! tidalnvim#send_selection() abort
    let obj = s:get_visual_selection()
    call tidalnvim#tidal#send(obj.text)
    " the col_end check fixes the case of a single line selected by V
    if obj.line_start == obj.line_end && obj.col_end < 100000
        " visual by character
        call s:flash(obj.col_start - 1, obj.col_end + 1, 'v')
    else
        " visual by line
        call s:flash(obj.line_start - 1, obj.line_end + 1, 'V')
    endif
endfunction

function! tidalnvim#send_block() abort
    let [start, end] = s:get_block()
    call tidalnvim#send_line(start, end)
endfunction

function! tidalnvim#hard_stop() abort
    call tidalnvim#tidal#send_silent('thisProcess.hardStop')
endfunction

" helpers
function! s:get_visual_selection() abort
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    if &selection ==# 'exclusive'
        let col2 -= 1
    endif
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][:col2 - 1]
    let lines[0] = lines[0][col1 - 1:]
    return {
                \ 'text': join(lines, "\n"),
                \ 'line_start': lnum1,
                \ 'line_end': lnum2,
                \ 'col_start': col1,
                \ 'col_end': col2,
                \ }
endfunction

function! s:skip_pattern() abort
    return 'synIDattr(synID(line("."), col("."), 0), "name") ' .
                \ '=~? "scLineComment\\|scComment\\|scString\\|scSymbol"'
endfunction

function! s:find_match(start, end, flags) abort
    return searchpairpos(a:start, '', a:end, a:flags, s:skip_pattern())
endfunction

function! s:get_block() abort
    " Find the next blank line and the previous blank line that's before the
    " next blank line - this'll find our paragraph that we need to send
    let end_lnum = search("^\s*$", 'n')
    let start_lnum = search("^\s*$", 'nb')

    " If start pos has no match (e.g. 0), return the current line
    " If the end_pos has no match or is somehow equal or less than the start
    " line, we'll consider it one line and set the line number to 'start_lnum'
    let start_lnum = start_lnum + 1
    let end_lnum = (end_lnum <= start_lnum) ? start_lnum : end_lnum - 1

    return [start_lnum, end_lnum]
endfunction

function! s:flash(start, end, mode) abort
    let repeats = get(g:, 'tidalnvim_eval_flash_repeats', 2)
    let duration = get(g:, 'tidalnvim_eval_flash_duration', 100)
    if repeats == 0 || duration == 0
        return
    elseif repeats == 1
        call s:flash_once(a:start, a:end, duration, a:mode)
    else
        let delta = duration / 2
        call s:flash_once(a:start, a:end, delta, a:mode)
        call timer_start(duration, {-> s:flash_once(a:start, a:end, delta, a:mode)}, {'repeat': repeats - 1})
    endif
endfunction

function! s:flash_once(start, end, duration, mode) abort
    let m = s:highlight_region(a:start, a:end, a:mode)
    call timer_start(a:duration, {-> s:clear_region(m) })
endfunction

function! s:highlight_region(start, end, mode) abort
    if a:mode ==# 'n' || a:mode ==# 'V'
        if a:start == a:end
            let pattern = '\%' . a:start . 'l'
        else
            let pattern = '\%>' . a:start . 'l'
            let pattern .= '\%<' . a:end . 'l'
        endif
    else
        let pattern = '\%' . line('.') . 'l'
        if a:start == a:end
            let pattern .= '\%' . a:start . 'c'
        else
            let pattern .= '\%>' . a:start . 'c'
            let pattern .= '\%<' . a:end . 'c'
        endif
    endif
    return matchadd('tidalnvimEval', pattern)
endfunction

function! s:clear_region(match) abort
    call matchdelete(a:match)
endfunction
