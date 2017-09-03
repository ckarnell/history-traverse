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

" These can be added to your statusline for 'browser like' back/forward indicators:
" set statusline+=%{w:current_buffer_index!=0?'←':'\ '} " Back history indicator
" set statusline+=%{w:current_buffer_index<(len(w:buffer_history_list)-1)?'→':'\ '} " Forward history indicator

" Globals
let g:HISTORY_MESSAGE_ENUMS = {
      \   'NO_PREV_FILE': 'No previous file!',
      \   'NO_NEXT_FILE': 'No next file!',
      \   'INDEX_HISTORY_LIST_MISMATCH': 'The current history index seems wrong... fixing!',
      \ }
let g:history_filetypes_to_ignore = ['netrw', 'pyc',]
let g:buffer_history_max_len = 100
let g:buffer_history_list = []
let g:current_buffer_index = -1

" Window scope
let w:skip_add_buffer_history_list = 0 " Boolean
let w:buffer_history_list = []
let w:current_buffer_index = -1


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
      \   let w:buffer_history_list = g:buffer_history_list |
      \   let w:current_buffer_index = g:current_buffer_index |
      \   let w:skip_add_buffer_history_list = 0 " Boolean
      \ endif

autocmd BufReadPost * |
      \ call AddToBufferHistoryList(expand('%:p')) |
      \ call UpdateHistoryGlobals()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! UpdateHistoryGlobals()
  let g:buffer_history_list = w:buffer_history_list
  let g:current_buffer_index = w:current_buffer_index
endfunction

" This function is agnostic to the current history index, and is idempotent
" TODO: Take care of all duplicate cases
function! AddToBufferHistoryList(buffer_name)
  " Don't add empty strings to the list, or add to the list at
  " all if our skip flag is set
  if (w:skip_add_buffer_history_list || !len(a:buffer_name))
    return
  endif
  " Don't append the same name that was last added to the list
  if (len(w:buffer_history_list) && w:buffer_history_list[-1] == a:buffer_name)
    return
  endif

  " Slice the history list to start a new 'forward' history
  let w:buffer_history_list = w:buffer_history_list[:w:current_buffer_index]

  " Finally, append the new name and increment the index value
  call add(w:buffer_history_list, a:buffer_name)
  let w:current_buffer_index = w:current_buffer_index + 1

  " If the list has become too long, chop off the beginning of it to meet the max length.
  " Note that this can't occur when the index is 0, avoiding an index error
  if len(w:buffer_history_list) > g:buffer_history_max_len
    let w:buffer_history_list = w:buffer_history_list[-g:buffer_history_max_len:]
      let w:current_buffer_index = w:current_buffer_index - 1
  endif
endfunction


function! GoBack()
  if len(w:buffer_history_list) == 1 || w:current_buffer_index == 0
    echo g:HISTORY_MESSAGE_ENUMS['NO_PREV_FILE']
    return
  endif

  " Decrement the history index
  let w:current_buffer_index = w:current_buffer_index - 1
  " Set a flag to prevent the autocmd from adding this buffer to the history list
  let w:skip_add_buffer_history_list = 1
  " Go BACK IN TIME!
  execute ":e " . w:buffer_history_list[w:current_buffer_index]
  let w:skip_add_buffer_history_list = 0
endfunction

function! GoForward()
  " Skip with a friendly message if we're at the tail of the list
  if w:current_buffer_index >= len(w:buffer_history_list) - 1
    " Set this just to restore a nice state
    let w:current_buffer_index = len(w:buffer_history_list) - 1
    echo g:HISTORY_MESSAGE_ENUMS['NO_NEXT_FILE']
    return
  endif

  " Increment the history index
  let w:current_buffer_index = w:current_buffer_index + 1
  " Set a variable to let the autocmd skip adding onto the history list
  let w:skip_add_buffer_history_list = 1
  " Go FORWARD IN TIME!
  execute ":e " . w:buffer_history_list[w:current_buffer_index]
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
  echo 'Buffer index:'
  echo g:current_buffer_index
  echo g:buffer_history_list
  echo 'List length'
  echo len(g:buffer_history_list)
  echo 'Window locals:'
  echo 'Buffer index:'
  echo w:current_buffer_index
  echo w:buffer_history_list
  echo 'List length'
  echo len(w:buffer_history_list)
endfunction
