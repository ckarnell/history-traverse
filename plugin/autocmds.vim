augroup history_group
  " WinEnter doesn't fire on the first window created when Vim launches.
  " Set the buffer index to 0 if vim is launched without a buffer loaded
  " to prevent bugs caused by the index being -1
  autocmd VimEnter * let w:window_created=1 |
        \ if !len(bufname('%')) |
        \   let w:current_buffer_index = 0 |
        \ endif

  " If this is the first time we've entered this window, initialize the window's
  " settings based on the last window's state
  autocmd WinEnter * call history_traverse#InitializeWindowSettings()

  " Before you leave a window, persist its state to the script scope variables
  autocmd WinLeave * call history_traverse#PersistLocalHistoryToScriptScope()

  " Command window specific (fixes an error when you press <c-f> in command mode)
  autocmd CmdwinEnter * call history_traverse#InitializeWindowSettings()

  autocmd BufWinEnter * if index(g:history_ft_ignore, &ft) < 0 |
        \ call history_traverse#AddToBufferHistoryList(expand('%:p'))
augroup END
