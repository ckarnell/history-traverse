# history-traverse.vim
Easily go back and forth in your buffer history in vim, similar to the behavior of a browser. You even get little tiny arrows to put in your statusline to indicate when you can go back or forward or both (if want them)!
:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:
![Alt Text](http://g.recordit.co/57fvVbiwZ0.gif)
:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:

<sup><i>Look at the majesty of those little arrows!</i></sup>

Each window (i.e. split) gets its own personal history, and each time you create a new window or a new tab, it inherits its history from the previous buffer (both forward and backward). If you're curious about the behavior of the history list, I basically made it to act the same way as a web browser's forward/backward buttons.

The default mappings are `<c-m>` to go back to the most previous buffer, and `<c-n>` to go to the next file. Both of these mappings can be easily changed (see the settings section). Note that the `<c-m>` default will also override your carriage return mapping so you'll want to change that if you use `<cr>` for something else (see settings below).

# Installation
Install with your favorite package manager. For the sake of completion, I'll give step by step instructions for installing with [vundle](https://github.com/VundleVim/Vundle.vim).

- Install vundle and do whatever setup business it requires.
- Put the following in your .vimrc: `Plugin 'ckarnell/history-traverse'`.
- Type `:so %` to source your .vimrc (or close and reopen it).
- Type `:PluginInstall`.
- Restart whatever instances of vim you were using, and it should work.

Append these to your status line wherever you like to get history indicators:
```vim
" Back history indicator:
set statusline+=%{w:current_buffer_index!=0?'←':'\ '}
" Forward history indicator:
set statusline+=%{w:current_buffer_index<(len(w:buffer_history_list)-1)?'→':'\ '}
```

# Settings
```vim
" Put these in your .vimrc (all are optional):

" Use this setting to override the default mapping (<c-m>) for going back in the history.
let g:history_back_map = '<c-m>'
" Use this setting to override the default mapping (<c-n>) for going forward in the history.
let g:history_forward_map = '<c-n>'
" Set filetypes to pass over putting in the history. Defaults to ['netrw']
let g:history_ft_ignore = ['pyc', 'netrw']
" Set the maximum length of each buffers history. This defaults to 100.
let g:buffer_history_max_len = 1000
```
