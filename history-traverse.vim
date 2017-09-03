let g:skip_bufenter_autocmd = 0 " Boolean
let g:buffer_history_list = []
let g:previous_buffer_index = -1
let g:buffer_history_max_len = 100 " TODO: Implement usage
let g:history_status_line_indicator = "<-"
let g:ERROR_ENUMS = {
      \   'NO_PREV_FILE': 'No previous file!',
      \   'NO_NEXT_FILE': 'No next file!',
      \   'INDEX_HISTORY_LIST_MISMATCH': 'The current history index seems wrong... fixing!',
      \ }

autocmd BufLeave * call AddToBufferHistoryList(expand('%:p'))

function! AddToBufferHistoryList(last_buffer_name)
  " Don't add empty strings to the list
  if (!g:skip_bufenter_autocmd && len(a:last_buffer_name))
    " Slice buffer_history_list to be equal in length to the previous_buffer_index,
    " to effectively start a new 'forward' history
    if g:previous_buffer_index != len(g:buffer_history_list) - 1
      if g:previous_buffer_index == -1
        let g:buffer_history_list = []
      else
        let g:buffer_history_list = g:buffer_history_list[0:g:previous_buffer_index]
      endif
    endif
    call add(g:buffer_history_list, a:last_buffer_name)
    " Should be able to just increment this variable, but I'll put a check in
    " so I can uncover some bugs if there are any
    let g:previous_buffer_index = g:previous_buffer_index + 1
    if g:previous_buffer_index != len(g:buffer_history_list) - 1
      echo g:ERROR_ENUMS['INDEX_HISTORY_LIST_MISMATCH']
      let g:previous_buffer_index = len(g:buffer_history_list) - 1
    endif
    " If the list has become too long, chop off the beginning of it to meet the max length
    if len(g:buffer_history_list) > g:buffer_history_max_len
      let g:buffer_history_list = g:buffer_history_list[-g:buffer_history_max_len:]
    endif
  endif
endfunction

function! GoBack()
  if !len(g:buffer_history_list) || g:previous_buffer_index < 0
    echo g:ERROR_ENUMS['NO_PREV_FILE']
    return
  endif

  " Add the current buffer to the list only if the history index is at
  " the tail of the list
  if g:previous_buffer_index == len(g:buffer_history_list) - 1
    call add(g:buffer_history_list, expand('%:p'))
  endif

  " Set a variable to let the autocmd skip adding onto the history list
  let g:skip_bufenter_autocmd = 1
  " Go BACK IN TIME!
  execute ":e " . g:buffer_history_list[g:previous_buffer_index]
  let g:skip_bufenter_autocmd = 0
  " Decrement the history index
  let g:previous_buffer_index = g:previous_buffer_index - 1
endfunction

nnoremap <silent> <c-m> :call GoBack()<Enter>

function! GoForward()
  " Skip with a friendly message if we're at the tail of the list
  if g:previous_buffer_index >= len(g:buffer_history_list) - 2
    echo g:ERROR_ENUMS['NO_NEXT_FILE']
    return
  endif

  " Increment the history index
  let g:previous_buffer_index = g:previous_buffer_index + 1
  " Set a variable to let the autocmd skip adding onto the history list
  let g:skip_bufenter_autocmd = 1
  " Go FORWARD IN TIME!
  execute ":e " . g:buffer_history_list[g:previous_buffer_index + 1]
  let g:skip_bufenter_autocmd = 0
endfunction

nnoremap <silent> <c-n> :call GoForward()<Enter>

" Function to help debugging. This can safely be deleted.
function! Check()
  echo g:previous_buffer_index
  echo g:buffer_history_list
endfunction
