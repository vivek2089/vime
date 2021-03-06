set laststatus=2
set showtabline=2

function! CryCocError()
    if !common#functions#HasPlug('coc.nvim')
        let error_sign = get(g:, 'coc_status_error_sign', has('mac') ? '❌ ' : 'E')
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info)
            return ''
        endif
        let errmsgs = []
        if get(info, 'error', 0)
            call add(errmsgs, error_sign . info['error'])
        endif
        return join(errmsgs, ' ')
    endif
    return ""
endfunction

function! CryCocWarn() abort
    if !common#functions#HasPlug('coc.nvim')
        let warning_sign = get(g:, 'coc_status_warning_sign')
        let info = get(b:, 'coc_diagnostic_info', {})
        if empty(info)
            return ''
        endif
        let warnmsgs = []
        if get(info, 'warning', 0)
            call add(warnmsgs, warning_sign . info['warning'])
        endif
        return join(warnmsgs, ' ')
    endif

    return ""
endfunction

function! CryCocFixes() abort
    if common#functions#HasPlug('coc.nvim')
        let b:coc_line_fixes = get(get(b:, 'coc_quickfixes', {}), line('.'), 0)
        return b:coc_line_fixes > 0 ? printf('%d ', b:coc_line_fixes) : ''
    endif
    return ""
endfunction

function! StatusLine(current, width)

    let l:f_list = ["coc-explorer", "defx", "vista", "nerdtree"]

    if index(f_list, &ft) > -1
        return &ft
    endif

    let l:s = ''

    if a:current
        let l:s .= crystalline#mode() . crystalline#right_mode_sep('')
    else
        let l:s .= '%#CrystallineInactive#'
    endif

    let l:s .= ' %f%h%w%m%r '
    if a:current
        let l:s .= crystalline#right_sep('', 'Fill') . ' %{common#functions#GitBranch()} %{common#functions#GitCount()}'
    endif

    if common#functions#HasPlug("coc.nvim")
        let l:s .= " %{coc#status()}%{get(b:, 'coc_current_function', '')}"
    endif

    let l:s .= '%='
    if a:current
        let l:s .= crystalline#left_sep('', 'Fill') . ' %{&paste ?"PASTE ":""}%{&spell?"SPELL ":""}'
        let l:s .= crystalline#left_mode_sep('')
    endif
    if a:width > 80
        let l:s .= ' %{&ft}[%{&fenc!=#""?&fenc:&enc}][%{&ff}] %l/%L %c%V %P '
    else
        let l:s .= ' '
    endif

    " let l:s .= crystalline#left_sep('', 'Fill') . ' %{CryCocWarn()}'
    " let l:s .= crystalline#left_mode_sep('')
    " let l:s .= crystalline#left_sep('', 'Fill') . ' %{CryCocError()}'
    " let l:s .= crystalline#left_mode_sep('')
    " let l:s .= crystalline#left_sep('', 'Fill') . ' %{CryCocFixes()}'
    " let l:s .= crystalline#left_mode_sep('')

    return l:s
endfunction

function! TabLine()
    let l:vimlabel = 'VIME'
    return crystalline#bufferline(2, len(l:vimlabel), 1) . '%=%#CrystallineTab# ' . l:vimlabel
endfunction

let g:crystalline_enable_sep = 1
let g:crystalline_statusline_fn = 'StatusLine'
let g:crystalline_tabline_fn = 'TabLine'
let g:crystalline_theme = 'onedark'

nnoremap <silent> <M-l> :call common#functions#MoveTabOrBuf(1)<cr>
nnoremap <silent> <M-h> :call common#functions#MoveTabOrBuf(0)<cr>
tnoremap <silent> <M-l> <c-\><c-n>:call common#functions#MoveTabOrBuf(1)<cr>
tnoremap <silent> <M-h> <c-\><c-n>:call common#functions#MoveTabOrBuf(0)<CR>
