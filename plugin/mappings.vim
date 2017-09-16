" Set the mapping for going back in history
nnoremap <silent> <Plug>HistoryTraverseGoBack :call history_traverse#HistoryGoBack()<CR>
if !hasmapto('<Plug>HistoryTraverseGoBack', 'n') && '' ==# mapcheck('<C-M>','n')
    nmap <C-M> <Plug>HistoryTraverseGoBack
endif

" Set the mapping for going forward in history
nnoremap <silent> <Plug>HistoryTraverseGoForward :call history_traverse#HistoryGoForward()<CR>
if !hasmapto('<Plug>HistoryTraverseGoForward', 'n') && '' ==# mapcheck('<C-N>','n')
    nmap <C-N> <Plug>HistoryTraverseGoForward
endif
