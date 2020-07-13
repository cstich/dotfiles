" TODO Setup jupyter integration with vim
" TODO Finish coc setup
"
" """""""""""""""""""""""""""""""""""""""""""""""
" Setup and use vim-plug. A vim plugin manager
"""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.local/share/nvim/site/autload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.local/share/nvim/plugged')


" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
Plug 'jeetsukumaran/vim-buffergator'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf'
Plug 'Raimondi/delimitMate' " Automatically close parenthesis, etc
Plug 'ervandew/supertab' " Use tab for autocompletion
Plug 'majutsushi/tagbar'
Plug 'Yggdroot/indentLine' " Indentation highlighting
Plug 'myusuf3/numbers.vim' " Intelligently toggle line numbers
Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope' " Highlights the first character for f,F targets

" Style/colors/etc.
Plug 'sickill/vim-monokai'
Plug 'patstockwell/vim-monokai-tasty'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Enable fzf
" If installed using git
" Plug '~/.fzf'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'

" Language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Linter/Language Server Protocoll Client
" Plug 'w0rp/ale'
" Asynchronous completeion
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" Plug 'zchee/deoplete-jedi' " Requires jedi, pynvim, python 3

Plug 'JuliaEditorSupport/julia-vim'
Plug 'jalvesaq/Nvim-R'
Plug 'lervag/vimtex'
Plug 'Chiel92/vim-autoformat'
Plug 'Shougo/context_filetype.vim'
Plug 'vim-python/python-syntax' " Better python syntax highlighting
Plug 'JuliaEditorSupport/julia-vim'
Plug 'Shougo/echodoc.vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'


" Always load devicons last
Plug 'ryanoasis/vim-devicons'

" Initialize plugin system
call plug#end()

""""""""""""""""""""""""""""""""""""
" General
""""""""""""""""""""""""""""""""""""

" tell vim to keep a backup file
set backup

" tell vim where to put its backup files
set backupdir=~/tmp

" Enable mouse support
set mouse=a

" Set the displayed encoding to UTf-8
set encoding=utf-8

" Set encodings to work in UTF-8 exclusively
set fileencoding=utf-8

""""""""""""""""""""""""""""""""""""
" VIM user interface
""""""""""""""""""""""""""""""""""""

"Always show current position
set ruler
" Ignore case when searching
set ignorecase
" When searching try to be smart about cases
set smartcase
" set show matching parenthesis
set showmatch
" insert tabs on the start of a line according to
" shiftwidth, not tabstop
set smarttab
" Highlight search results
set hlsearch
" Makes search act like search in modern browsers
set incsearch
" Don't redraw while executing macros (good performance config)
set lazyredraw
" Show line numbers
set hidden " LSP needed this
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent " Always set autoindenting on
set copyindent " Copy the previous indentation
set noswapfile " disable swapfile usage
set autochdir " automatically change window's cwd to file's dir

" Keybindings
"
" Change the behavior of j and k for wrapped lines
" :nmap j gj
" :nmap k gk

" Sane moving between window panes
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" for command mode
nmap <Tab> >>
nmap <S-Tab> <<

" for insert mode
imap <S-Tab> <Esc><<

" Display all trailing white space
set list

" change <leader>
let mapleader = "\<Space>"
" let maplocalleader = "\\"
let maplocalleader = "\<Space>"

" Use <leader>l to toggle display of whitespace
nmap <leader>l :set list!<CR>

map <F2> :NERDTreeToggle<CR>
nmap <F3> :BuffergatorToggle<CR>
nmap <F4> :TagbarToggle<CR>
" noremap <F5> :ALEGoToDefinition<CR>
noremap <F6> :Autoformat<CR>

" Always draw the signcolumn.
set signcolumn=yes

" show a visual line under the cursor's current line
set cursorline

" show the matching part of the pair for [] {} and ()
set showmatch

" Relative/hybrid linenumbers
" As described here
" https://jeffkreeftmeijer.com/vim-number/
set number relativenumber

" Disable concealing of text 
set conceallevel=0

"augroup numbertoggle
"  autocmd!
"  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
"augroup END

""""""""""""""""""""""""""""""""""
" Spellcheck settings
""""""""""""""""""""""""""""""""""

set spelllang=en
set spellfile=$HOME/.config/nvim/spell/en.utf-8.add


""""""""""""""""""""""""""""""""""
" Autoread changes on disk
""""""""""""""""""""""""""""""""""

" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim
au CursorHold,CursorHoldI * checktime
au FocusGained,BufEnter * :checktime


""""""""""""""""""""""""""""""""""
" fzf.vim settings
""""""""""""""""""""""""""""""""""

" This is the default extra key bindings
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-x': 'split',
            \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
" let g:fzf_layout = { 'down': '~60%' }

" In Neovim, you can set up fzf window using a Vim command
" let g:fzf_layout = { 'window': 'enew' }
" let g:fzf_layout = { 'window': '-tabnew' }
let g:fzf_layout = { 'window': '10split enew' }

" Customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

" TODO Understand what those mappings do
" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Advanced customization using autoload functions
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'left': '15%'})

" TODO Play around with my own mappings
map <leader>bb :Buffers<CR>
map <leader>ff :Files<CR>

""""""""""""""""""""""""""""""""""
" Buffergator settings
""""""""""""""""""""""""""""""""""

let g:buffergator_suppress_keymaps = 1

""""""""""""""""""""""""""""""""""
" Vimtex settings
""""""""""""""""""""""""""""""""""

let g:vimtex_view_method = "zathura"
let g:tex_conceal = ""

""""""""""""""""""""""""""""""""""
" Vimpyter settings 
""""""""""""""""""""""""""""""""""
autocmd Filetype ipynb nmap <silent><Leader>b :VimpyterInsertPythonBlock<CR>
autocmd Filetype ipynb nmap <silent><Leader>j :VimpyterStartJupyter<CR>
autocmd Filetype ipynb nmap <silent><Leader>n :VimpyterStartNteract<CR>

""""""""""""""""""""""""""""""""""
" Colors and formatting
""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Set colorscheme to monokai
colorscheme vim-monokai-tasty

" Monokai-tasty additional settings
let g:vim_monokai_tasty_italic = 1
let g:airline_theme='monokai_tasty'

" Use Unix as the standard file type
set fileformat=unix

" Set the font to use a nerd font
"set guifont=DejaVu\ Sans\ Mono\ for\ Powerline\ 9

" Powerline setup
set laststatus=2

" Override vim's autodetectionn of colors
" if $COLORTERM == 'gnome-terminal'
"     set t_Co=256
" endif
set t_Co=256

" Airline settings
let g:airline_powerline_fonts = 1
let g:airline_theme='powerlineish'
let g:airline#extensions#tabline#enabled = 1


"""""""""""""""""""""""""""""""""""""""
" Plug: ALE
""""""""""""""""""""""""""""""""""""""""


" Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" Set the fixers for the languages I have them installed for
let g:ale_fixers = { 'python': ['yapf']  }
let g:ale_fix_on_save = 1

"""""""""""""""""""""""""""""""""""""""
" Plug: Supertab
""""""""""""""""""""""""""""""""""""""""

let g:SuperTabDefaultCompletionType = "<c-n>"

"""""""""""""""""""""""""""""""""""""""""
" Python specific settings
"""""""""""""""""""""""""""""""""""""""""

" highlight characters past column 80
augroup vimrc_autocmds
    autocmd!
    autocmd FileType python highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python match Excess /\%81v.*/
    autocmd FileType python set nowrap
augroup END


"""""""""""""""""""""""""""""""""""""""""
" Plug: Deoplete
"""""""""""""""""""""""""""""""""""""""""
" Basically use two seperate massive python cond envs to get all the
" completions right
" let g:python_host_prog = '/home/christoph/anaconda3/envs/nvim/bin/python'
" let g:python3_host_prog = '/home/christoph/anaconda3/envs/nvim3/bin/python'

" call deoplete#custom#source('LanguageClient',
"             \ 'min_pattern_length',
"             \ 2)
" 
" " Use deoplete.
" let g:deoplete#enable_at_startup = 1
" let g:deoplete#enable_ignore_case = 1
" let g:deoplete#enable_smart_case = 1
" " Fixes https://github.com/zchee/deoplete-jedi/issues/167
" " let g:deoplete#sources#jedi#server_timeout = 60
" 
" " complete with words from any opened file
" let g:context_filetype#same_filetypes = {}
" let g:context_filetype#same_filetypes._ = '_'
" 
" " Automatically close the preview once you are done
" autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: easy-align
""""""""""""""""""""""""""""""""""""""""""""""""""

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: javacomplete2
""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType java setlocal omnifunc=javacomplete#Complete

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: ALE
""""""""""""""""""""""""""""""""""""""""""""""""""

" Set this in your vimrc file to disabling highlighting
let g:ale_set_highlights = 0

" In ~/.vim/vimrc, or somewhere similar.
let g:ale_linters = {
            \   'python': [ 'pyls', 'pyling', 'flake8', 'yapf'],
            \}


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: numbers
""""""""""""""""""""""""""""""""""""""""""""""""""

let g:numbers_exclude = ['tagbar', 'gundo', 'minibufexpl', 'nerdtree', 'buffergator']


""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: coc 
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:coc_global_extensions = ['coc-python', 'coc-java']
set statusline^=%{coc#status()}

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug: python-syntax
""""""""""""""""""""""""""""""""""""""""""""""""""

let g:python_highlight_all = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Plug:  NERDTree
""""""""""""""""""""""""""""""""""""""""""""""""""

" Close vim if NERDTree is the only opened window.
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
