" File: autoload/tidalnvim/tidal.vim
" Author: John Murphy
" Description: Spawn a tidal process

scriptencoding utf-8

let s:recompling_class_library = 0
let s:is_exiting = 0
let s:vim_exiting = 0

autocmd tidalnvim VimLeavePre * let s:vim_exiting = 1

" interface
function! tidalnvim#tidal#open() abort
    if exists('s:tidal_job')
        call tidalnvim#util#err('tidal is already running.')
        return
    endif
    try
        let s:tidal_job = s:Tidal.new()
        call tidalnvim#document#set_current_path()
    catch
        call tidalnvim#util#err(v:exception)
    endtry
endfunction

function! tidalnvim#tidal#close() abort
    try
      let s:is_exiting = 1
      call jobstop(s:tidal_job.id)
    catch
      call tidalnvim#util#err('tidal is not running')
    endtry
    let s:is_exiting = 0
endfunction

function! tidalnvim#tidal#send(data) abort
    let bufnr = tidalnvim#postwindow#get_bufnr()
    let buflines= nvim_buf_line_count(bufnr)
    "TODO: Fix this so it appends to the last line of the buffer without having the prompt
    call nvim_buf_set_lines(bufnr, buflines, buflines, v:true, ["tidal> ". a:data])
    let cmd = printf("%s\n", a:data)
    call s:send(cmd)
endfunction

function! tidalnvim#tidal#send_silent(data) abort
    let cmd = printf("%s\n", a:data)
    call s:send(cmd)
endfunction

function! tidalnvim#tidal#is_running() abort
    return exists('s:tidal_job') && !empty(s:tidal_job)
endfunction

" job handlers
let s:Tidal = {}

function! s:Tidal.new() abort
    let options = {
                \ 'name': 'tidal',
                \ 'bufnr': 0,
                \ }
    let settings = tidalnvim#util#get_user_settings()
    let job = extend(copy(s:Tidal), options)
    let rundir = expand('%:p:h')

    let job.bufnr = tidalnvim#postwindow#create()
    let prg = settings.paths.tidal_executable
    let job.cmd = split(prg) "Split the string by whitespace to give jobstart a list
    let job.id = jobstart(job.cmd, job)

    if job.id == 0
        throw 'job table is full'
    elseif job.id == -1
        throw 'could not find tidal executable'
    endif

    return job
endfunction

function! s:Tidal.on_stdout(id, data, event) dict abort
    let s:chunks = ['']
    let s:chunks[-1] .= a:data[0]
    call extend(s:chunks, a:data[1:])
    for line in s:chunks
        if !empty(line)
            call s:receive(self, line)
        else
            let s:chunks = ['']
        endif
    endfor
endfunction

let s:Tidal.on_stderr = function(s:Tidal.on_stdout)

function! s:Tidal.on_exit(id, data, event) abort
    if s:vim_exiting
        return
    endif
    call tidalnvim#postwindow#destroy()
    unlet s:tidal_job
endfunction

" helpers
function! s:send(cmd) abort
    if exists('s:tidal_job')
        call chansend(s:tidal_job.id, a:cmd)
    endif
endfunction

function! s:receive(self, data) abort
    if s:is_exiting
        return
    endif
    let bufnr = get(a:self, 'bufnr')
    let winnr = bufwinid(bufnr)
    " scan for ERROR: marker in tidal stdout
    let found_error = match(a:data, '^ERROR') == 0
    let post_window_visible = winnr >= 0

    let settings = tidalnvim#util#get_user_settings()
    if found_error && settings.post_window.auto_toggle
        if !post_window_visible
            call tidalnvim#postwindow#toggle()
        endif
    endif

    call nvim_buf_set_lines(bufnr, -1, -1, v:true, [a:data])

    if post_window_visible
        let numlines = nvim_buf_line_count(bufnr)
        call nvim_win_set_cursor(winnr, [numlines, 0])
    endif
endfunction
