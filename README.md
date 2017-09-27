# history-traverse.vim
Easily go back and forth in your buffer history in vim, similar to the behavior of a browser. You even get little tiny arrows to put in your statusline to indicate when you can go back or forward (if you want them)!


:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:
![Alt Text](http://g.recordit.co/57fvVbiwZ0.gif)
:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:

<sup><i>Look at the majesty of those little arrows!</i></sup>

Each window (i.e. split) gets its own personal history, and each time you create a new window or a new tab, it inherits its history from the previous buffer (both forward and backward). If you're curious about the behavior of the history list, I basically made it to act the same way as a web browser's forward/backward buttons.

# Usage

The default mappings are `<c-m>` to go back to the most previous buffer, and `<c-n>` to go to the next. Both of these mappings can be easily changed. Note that the `<c-m>` default will also override your carriage return mapping so you'll want to change that if you use `<cr>` for something else.

# Settings
```vim
" Put these in your .vimrc (all are optional):

" Use this setting to override the default mapping (<c-m>) for going back in the history
nmap <C-M> <Plug>HistoryTraverseGoBack
" Use this setting to override the default mapping (<c-n>) for going forward in the history
nmap <C-N> <Plug>HistoryTraverseGoForward
" Set filetypes to pass over putting in the history. Defaults to ['netrw']
let g:history_ft_ignore = ['pyc', 'netrw']
" Set the maximum length of each buffers history. Defaults to 100
let g:history_max_len = 1000
```

# Installation
Install with your favorite package manager. For the sake of completion, I'll give step by step instructions for installing with [vundle](https://github.com/VundleVim/Vundle.vim).

- Install vundle and do whatever setup business it requires.
- Put the following in your .vimrc: `Plugin 'ckarnell/history-traverse'`.
- Type `:so %` to source your .vimrc (or close and reopen it).
- Type `:PluginInstall`.
- Restart whatever instances of vim you were using, and it should work.

Append this to your status line wherever you like to get history indicators:
```vim
" History indicator:
set statusline+=%{HistoryIndicator}
```

# Shameless begging for help
I don't really know how to make vim plugins so if you want to review my code, make suggestions about defaults or extensions, let me know about issues, help me make it more clear exactly what this plugin does in this README, or anything else, please go right ahead.
