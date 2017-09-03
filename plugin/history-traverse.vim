"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Sections:
"    -> Variables
"    -> Auto commands
"    -> Functions
"    -> Mappings
"    -> Debugging utils
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Variables
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Globals
let g:HISTORY_MESSAGE_ENUMS = {
      \   'NO_PREV_FILE': 'No previous file!',
      \   'NO_NEXT_FILE': 'No next file!',
      \   'INDEX_HISTORY_LIST_MISMATCH': 'The current history index seems wrong... fixing!',
      \ }
let g:history_filetypes_to_ignore = ['netrw', 'pyc',]
let g:buffer_history_max_len = 100
let g:skip_add_buffer_history_list = 0 " Boolean
let g:buffer_history_list = []
let g:previous_buffer_index = -1

" Window scope
let w:skip_add_buffer_history_list = 0 " Boolean
let w:buffer_history_list = []
let w:previous_buffer_index = -1


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set up the w:window_created variable when vim is launched
autocmd VimEnter * autocmd WinEnter * let w:window_created=1
" WinEnter doesn't fire on the first window created when Vim launches
autocmd VimEnter * let w:window_created=1

autocmd WinEnter *
      \ if !exists('w:window_created') |
      \   let w:window_created = 1 |
      \   let w:skip_add_buffer_history_list = g:skip_add_buffer_history_list |
      \   let w:buffer_history_list = g:buffer_history_list |
      \   let w:previous_buffer_index = g:previous_buffer_index |
      \ endif

autocmd BufLeave * if index(g:history_filetypes_to_ignore, &ft) < 0 |
      \ call AddToBufferHistoryList(expand('%:p')) |
      \ call UpdateHistoryGlobals()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! UpdateHistoryGlobals()
  let g:skip_add_buffer_history_list = w:skip_add_buffer_history_list
  let g:buffer_history_list = w:buffer_history_list
  let g:previous_buffer_index = w:previous_buffer_index
endfunction

function! AddToBufferHistoryList(last_buffer_name)
  " Don't add empty strings to the list
  if (w:skip_add_buffer_history_list || !len(a:last_buffer_name))
    return
  endif

  " Slice buffer_history_list to be one less than the previous_buffer_index value,
  " to effectively start a new 'forward' history
  if w:previous_buffer_index != len(w:buffer_history_list) - 1
    if w:previous_buffer_index == -1
      " There is no slice that creates an empty list, so we need a special case
      " for this
      let w:buffer_history_list = []
    else
      let w:buffer_history_list = w:buffer_history_list[0:w:previous_buffer_index]
    endif
  endif

  call add(w:buffer_history_list, a:last_buffer_name)
  " Should be able to just increment this variable, but I'll put a check in
  " so I can uncover some bugs if there are any
  let w:previous_buffer_index = w:previous_buffer_index + 1
  if w:previous_buffer_index != len(w:buffer_history_list) - 1
    echo g:HISTORY_MESSAGE_ENUMS['INDEX_HISTORY_LIST_MISMATCH']
    let w:previous_buffer_index = len(w:buffer_history_list) - 1
  endif

  " If the list has become too long, chop off the beginning of it to meet the max length.
  " Note that this can't occur
  if len(w:buffer_history_list) > g:buffer_history_max_len
    let w:buffer_history_list = w:buffer_history_list[-g:buffer_history_max_len:]
  endif
endfunction

function! GoBack()
  if !len(w:buffer_history_list) || w:previous_buffer_index < 0
    echo g:HISTORY_MESSAGE_ENUMS['NO_PREV_FILE']
    return
  endif

  " Add the current buffer to the list only if the history index is at
  " the tail of the list
  if w:previous_buffer_index == len(w:buffer_history_list) - 1
    call add(w:buffer_history_list, expand('%:p'))
  endif

  " Set a variable to let the autocmd skip adding onto the history list
  let w:skip_add_buffer_history_list = 1
  " Go BACK IN TIME!
  execute ":e " . w:buffer_history_list[w:previous_buffer_index]
  " Going back in time means we can go forward in time one more than before!
  let w:skip_add_buffer_history_list = 0
  " Decrement the history index
  let w:previous_buffer_index = w:previous_buffer_index - 1
endfunction

function! GoForward()
  " Skip with a friendly message if we're at the tail of the list
  if w:previous_buffer_index >= len(w:buffer_history_list) - 2
    echo g:HISTORY_MESSAGE_ENUMS['NO_NEXT_FILE']
    return
  endif

  " Increment the history index
  let w:previous_buffer_index = w:previous_buffer_index + 1
  " Set a variable to let the autocmd skip adding onto the history list
  let w:skip_add_buffer_history_list = 1
  " Go FORWARD IN TIME!
  execute ":e " . w:buffer_history_list[w:previous_buffer_index + 1]
  let w:skip_add_buffer_history_list = 0
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" This is the MEAT!
nnoremap <silent> <c-n> :call GoForward()<Enter>
nnoremap <silent> <c-m> :call GoBack()<Enter>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Debugging utils
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Debugging function - this can be safely deleted
function! Check()
  echo 'Globals:'
  echo g:previous_buffer_index
  echo g:buffer_history_list
  echo len(g:buffer_history_list)
  echo 'Window locals:'
  echo w:previous_buffer_index
  echo w:buffer_history_list
  echo len(w:buffer_history_list)
endfunction
