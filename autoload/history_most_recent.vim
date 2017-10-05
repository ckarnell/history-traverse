function! history_most_recent#AddToMostRecentList(buffer_name) abort
  let b:recent_ind = index(w:most_recent_list, a:buffer_name)

  " Slice off the existing element
  if b:recent_ind > 0
    let w:most_recent_list = w:most_recent_list[:b:recent_ind-1] + w:most_recent_list[b:recent_ind+1:]
  elseif b:recent_ind == 0
    let w:most_recent_list = w:most_recent_list[1:b:recent_ind-1]
  endif

  if len(w:most_recent_list) + 1 > g:history_mr_max_len
    let w:most_recent_list = w:most_recent_list[-g:history_mr_max_len:]
  endif

  call add(w:most_recent_list, a:buffer_name)
endfunction

function! history_most_recent#HistoryLocalList() abort
  let b:recent_copy = copy(w:most_recent_list)
  call reverse(b:recent_copy)
  call setloclist(0, map(b:recent_copy, {_, file -> {'filename': file}}))
  lopen
endfunction
