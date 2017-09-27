function! BackHistoryIndicator() abort
  if w:current_buffer_index != 0
    return '←'
  else
    return ' '
  end
endfunction

function! ForwardHistoryIndicator() abort
  if w:current_buffer_index < (len(w:buffer_history_list) - 1)
    return '→'
  else
    return ' '
  end
endfunction

function! HistoryIndicator() abort
  return BackHistoryIndicator() . ForwardHistoryIndicator()
endfunction

if exists('g:history_traverse_loaded') || v:version < 700
  finish
endif
let g:history_traverse_loaded = 1

" Global scope (user settings)
if !exists('g:history_ft_ignore')   | let g:history_ft_ignore = ['netrw'] | endif
if !exists('g:history_max_len')     | let g:history_max_len = 100         | endif
if !exists('g:history_back_map')    | let g:history_back_map = '<c-m>'    | endif
if !exists('g:history_forward_map') | let g:history_forward_map = '<c-n>' | endif

" Window scope
let w:buffer_history_list = []
let w:current_buffer_index = -1
