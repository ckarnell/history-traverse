# history-traverse.vim
Easily go back and forth in your buffer history in vim, similar to the behavior of a browser. You even get little tiny arrows to put in your statusline to indicate when you can go back or forward (if you want them)!


:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:
![Alt Text](http://g.recordit.co/57fvVbiwZ0.gif)
:sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles::sparkles:

<sup><i>Look at the majesty of those little arrows!</i></sup>

Each window (i.e. split) gets its own personal history, and each time you create a new window or a new tab, it inherits its history from the previous buffer (both forward and backward).
# Usage

This plugin provides `:HisTravBack` and `:HisTravForward` commands to navigate similarly to a web browser.

# Settings
```vim
" Put these in your .vimrc (all are optional):

" Set mappings for the commands. This plugin doesn't set any mappings by default, but <BS> and <C-n> are recommended
nnoremap <BS> :HisTravBack<CR>
nnoremap <C-n> :HisTravForward<CR>

" Set filetypes to pass over putting in the history. Defaults to ['netrw']
let g:history_ft_ignore = ['pyc', 'netrw']

" Set the maximum length of each buffer's history. Defaults to 100
let g:history_max_len = 1000

" Append this to your status line wherever you want if you want to see the history indicators
set statusline+=%{HistoryIndicator()}

" Use these variables to set custom characters for the history indicators.
" These are also the defaults for terminal vim
let g:history_indicator_back_active      = '⬅'
let g:history_indicator_back_inactive    = '⇦'
let g:history_indicator_forward_active   = '➡'
let g:history_indicator_forward_inactive = '⇨'
let g:history_indicator_separator        = ' '
```

Note the your mileage may vary with the default indicator characters depending on your vim environment / choice of font (and they may look weird in your browser too), so you may want to customize these - but it would be wise to load vim up with the defaults first to see if it looks okay. You never know.

If the defaults don't work for you, I recommend poking around `:help digraph-table` for some symbols that look nice in your environment. Google is a good resource for this too :)

# Installation
Install with your favorite package manager. For the sake of completion, I'll give step by step instructions for installing with [vundle](https://github.com/VundleVim/Vundle.vim).

- Install vundle and do whatever setup business it requires.
- Put the following in your .vimrc: `Plugin 'ckarnell/history-traverse'`.
- Type `:so %` to source your .vimrc (or close and reopen it).
- Type `:PluginInstall`.
- Restart whatever instances of vim you were using, and it should work.

# Shameless begging for help
I don't really know how to make vim plugins so if you want to review my code, make suggestions about defaults or extensions, let me know about issues, help me make it more clear exactly what this plugin does in this README, or anything else, please go right ahead.
