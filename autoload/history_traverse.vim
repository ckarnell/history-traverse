let s:HISTORY_MESSAGE_ENUMS = {
      \   'NO_PREV_FILE': 'No previous file!',
      \   'NO_NEXT_FILE': 'No next file!',
      \ }
let s:skip_add_buffer_history_list = 0 " Boolean
let s:bufwinenter_flag = 0
let s:buffer_history_list = []
let s:current_buffer_index = 0

function! history_traverse#InitializeWindowSettings() abort
  if exists('w:window_created') |
    return
  endif
  let w:window_created = 1
  let w:buffer_history_list = s:buffer_history_list
  let w:current_buffer_index = s:current_buffer_index
  let s:skip_add_buffer_history_list = 0
endfunction

function! history_traverse#PersistLocalHistoryToScriptScope() abort
  let s:buffer_history_list = w:buffer_history_list
  let s:current_buffer_index = w:current_buffer_index
endfunction

" TODO: Take care of all duplicate cases
" This function is agnostic to the current history index, and is idempotent
function! history_traverse#AddToBufferHistoryList(buffer_name) abort
  " Cover the case where vim was launched without a buffer loaded
  if (!len(w:buffer_history_list) && w:current_buffer_index == 0)
    let w:current_buffer_index = -1
  endif
  " Try the flag
  if !s:bufwinenter_flag
    let s:bufwinenter_flag = 1
  else
    let s:bufwinenter_flag = 0
    return
  endif
  " Don't add empty strings to the list, or add to the list at
  " if the skip flag is set
  if (s:skip_add_buffer_history_list || !len(a:buffer_name))
    return
  endif

  " Slice the history list to start a new 'forward' history
  let w:buffer_history_list = w:buffer_history_list[:w:current_buffer_index]

  " Finally, append the new name and increment the index value
  call add(w:buffer_history_list, a:buffer_name)
  let w:current_buffer_index = w:current_buffer_index + 1

  " If the list has become too long, chop off the beginning of it to meet the max length.
  " Note that this can't occur when the index is 0, avoiding an index error
  if len(w:buffer_history_list) > g:history_max_len
    let w:buffer_history_list = w:buffer_history_list[-g:history_max_len:]
    let w:current_buffer_index = w:current_buffer_index - 1
  endif
endfunction

function! history_traverse#HistoryGoBack() abort
  " Skip if we're at the head of the list
  if len(w:buffer_history_list) <= 1 || w:current_buffer_index == 0
    echo s:HISTORY_MESSAGE_ENUMS['NO_PREV_FILE']
    return
  endif

  " Decrement the history index
  let w:current_buffer_index = w:current_buffer_index - 1
  " Set a flag to prevent the autocmd from adding this buffer to the history list
  let s:skip_add_buffer_history_list = 1
  " Go BACK IN TIME!
  execute ':e ' . w:buffer_history_list[w:current_buffer_index]
  let s:skip_add_buffer_history_list = 0
endfunction

function! history_traverse#HistoryGoForward() abort
  " Skip if vim has just been launched with no buffer loaded
  if !len(w:buffer_history_list)
    echo s:HISTORY_MESSAGE_ENUMS['NO_NEXT_FILE']
    return
  endif

  " Skip if we're at the tail of the list
  if w:current_buffer_index >= len(w:buffer_history_list) - 1
    " Set this just to restore a nice state
    let w:current_buffer_index = len(w:buffer_history_list) - 1
    echo s:HISTORY_MESSAGE_ENUMS['NO_NEXT_FILE']
    return
  endif

  " Increment the history index
  let w:current_buffer_index = w:current_buffer_index + 1
  " Set a flag to let the autocmd skip adding onto the history list
  let s:skip_add_buffer_history_list = 1
  " Go FORWARD IN TIME!
  execute ':e ' . w:buffer_history_list[w:current_buffer_index]
  let s:skip_add_buffer_history_list = 0
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Debugging utils
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Debugging function - this can be safely deleted
function! history_traverse#HistoryCheck() abort
  echo 'Script scope:'
  echo '  Buffer index: ' s:current_buffer_index
  echo '  Buffer list:  ' s:buffer_history_list
  echo '  List length:  ' len(s:buffer_history_list)
  echo 'Window locals:'
  echo '  Buffer index: ' w:current_buffer_index
  echo '  Buffer list:  ' w:buffer_history_list
  echo '  List length:  ' len(w:buffer_history_list)
endfunction
