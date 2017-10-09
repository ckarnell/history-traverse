let s:most_recent_list = []

function! history_most_recent#AddToMostRecentList(buffer_name, line, col) abort
  if index(g:history_ft_ignore, &filetype) != -1 || len(a:buffer_name) == 0
    return
  endif

  let l:mr_dict = {'filename': a:buffer_name, 'col': a:col, 'lnum': a:line}
  call add(w:most_recent_list, l:mr_dict)
endfunction

function! DeleteDuplicateFilenames(mr_list) abort
  let b:most_recent_copy = deepcopy(w:most_recent_list)
  call reverse(b:most_recent_copy)
  let l:used_filenames = []
  let l:return_list = []
  for l:element in b:most_recent_copy
    if index(l:used_filenames, l:element['filename']) == -1
      call add(l:used_filenames, l:element['filename'])
      call add(l:return_list, l:element)
    endif
  endfor
  return reverse(l:return_list)
endfunction

function! history_most_recent#RecentHistorySelect() abort
  let w:most_recent_list = DeleteDuplicateFilenames(w:most_recent_list)
  if g:history_mr_use_loc != 1
      call setqflist(w:most_recent_list)
      if g:history_mr_auto_open == 1
          copen
      endif
  else
      call setloclist(w:most_recent_list)
      if g:history_mr_auto_open == 1
          lopen
      endif
  endif
endfunction
