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

function! history_traverse#AddToBufferHistoryList(buffer_name) abort
  let l:history_length = len(w:buffer_history_list)
  " Cover the case where vim was launched without a buffer loaded
  if (!l:history_length && w:current_buffer_index == 0)
    let w:current_buffer_index = -1
  endif

  " Don't add empty strings to the list, or add to the list at all
  " if the skip flag is set
  if (!len(a:buffer_name) || s:skip_add_buffer_history_list)
    return
  endif

  " Cover the case where the input buffer is the same as the current buffer
  " by simply returning without changing the state, avoiding a duplicate entry
  if w:current_buffer_index > -1
    if w:buffer_history_list[w:current_buffer_index] == a:buffer_name
      return
    endif
  endif

  " Cover the case where the input buffer is the same as the next buffer
  " by advancing in the history list without destroying the rest of the history
  if w:current_buffer_index < l:history_length - 1
    if w:buffer_history_list[w:current_buffer_index + 1] == a:buffer_name
      let w:current_buffer_index = w:current_buffer_index + 1
      return
    endif
  endif

  " Slice the history list to start a new 'forward' history
  " TODO: Preserve and expose the whole tree of history files
  let w:buffer_history_list = w:buffer_history_list[:w:current_buffer_index]

  " Finally, append the new name and increment the index value
  call add(w:buffer_history_list, a:buffer_name)
  let w:current_buffer_index = w:current_buffer_index + 1

  " If the list has become too long, chop off the beginning of it to meet the max length.
  " Note that this can't occur when the index is 0, avoiding an index error
  if l:history_length + 1 > g:history_max_len
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

  " Don't decrement the index if we're in a file that isn't in the history list
  if index(g:history_ft_ignore, &filetype) >= 0 || index(g:history_fn_ignore, expand('%:t')) >= 0
    let s:skip_add_buffer_history_list = 1
    execute ':e ' . w:buffer_history_list[w:current_buffer_index]
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

function! BackHistoryIndicator() abort
  if w:current_buffer_index != 0
    return g:history_indicator_back_active
  endif
  return g:history_indicator_back_inactive
endfunction

function! ForwardHistoryIndicator() abort
  if w:current_buffer_index < (len(w:buffer_history_list) - 1)
    return g:history_indicator_forward_active
  endif
  return g:history_indicator_forward_inactive
endfunction

function! HistoryIndicator() abort
  return BackHistoryIndicator() . g:history_indicator_separator . ForwardHistoryIndicator()
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
