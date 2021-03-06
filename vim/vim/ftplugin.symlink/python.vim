setlocal autoread

silent let g:black_virtualenv = substitute(system('pipenv --venv'), '\n\+$', '', '')
silent let s:black_command = substitute(system('which black'), '\n\+$', '', '')
if g:black_virtualenv == ""
    echom 'Skipping black formatting, unable to find virtualenv'
elseif s:black_command == "black not found"
    echom 'Skipping black formatting, unable to find black command'
else
    autocmd! BufWritePre <buffer> call s:PythonAutoformat()
endif

function s:PythonAutoformat() abort
    let cursor_pos = getpos('.')
    execute ':%!black -q - 2>/dev/null'
    call cursor(cursor_pos[1], cursor_pos[2])
endfunction

