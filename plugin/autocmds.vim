augroup history_group
  " Set up the w:window_created variable when vim is launched
  autocmd VimEnter * autocmd WinEnter * let w:window_created=1

  " WinEnter doesn't fire on the first window created when Vim launches
  autocmd VimEnter * let w:window_created=1

  " Before you leave a window, persist its state to the script scope variables
  autocmd WinLeave * call history_traverse#PersistLocalHistoryToGlobal()

  " If this is the first time we've entered this window, initialize the window's
  " settings based on the last window's state
  autocmd WinEnter * call history_traverse#InitializeWindowSettings()

  autocmd BufReadPost * if index(g:history_ft_ignore, &ft) < 0 |
        \ call history_traverse#AddToBufferHistoryList(expand('%:p'))
augroup END
