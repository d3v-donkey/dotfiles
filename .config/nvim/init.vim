"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" not in the 80's anymore
set nocompatible

" Set relative line number, gutter always visible
set number relativenumber signcolumn=yes

" Reload files when changed behind vim's back
set autoread

" Highlight of the current line
set cursorline

" Disable swap files and such nonsense
set nobackup nowb noswapfile

" Configure search
set hlsearch ignorecase smartcase incsearch wrapscan nowrap

" Configure mouse interation
set mouse=a

" Everything that's yanked is put in the cliboard + mouse cliboard
set clipboard+=unnamed,unnamedplus

" When selecting text in visual mode, put it in primary clipboard (middle mouse button)
vmap <LeftRelease> "*ygv
nmap <2-LeftMouse> <2-LeftMouse>"*ygv
vmap <3-LeftMouse> <3-LeftMouse>"*ygv

" Use 4x spaces for tabs...
set expandtab smarttab shiftwidth=4 tabstop=4

" ...except for Makefiles
filetype plugin indent on
autocmd FileType make setlocal noexpandtab

" Split goes to the bottom and vsplit to the right
set splitbelow splitright

" Do not display current mode, will be done in status bar
set noshowmode laststatus=2

" Automatically reload vimrc, and refresh airline if installed
autocmd! BufWritePost init.vim,.vimrc source % | if exists(':AirlineRefresh') | execute 'AirlineRefresh' | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" When switching back to Normal mode from Insert mode
" prevent the cursor from moving to the left, grrr
inoremap <Esc> <Esc><Right>

" allow to go directly from visual mode to insert mode
xnoremap i <Esc>i

" Remap leader key
let mapleader = ","

" disable highlighted search with esc in normal mode
nnoremap <silent><esc> :nohl<cr>

" ',s' to create a split
map <leader>s :split<cr>

" ',v' to create a vsplit
map <leader>v :vsplit<cr>

" ',d' to delete but not modify register
map <leader>d "_d

" Use ctrl+kj to just 5 lines at a time
nnoremap <C-K> 10k
nnoremap <C-j> 10j
vnoremap <C-k> 10k
vnoremap <C-j> 10j

" indent/dedent with tab/s-tab
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv

" ctrl+c copy to system clipboard
vnoremap <c-c> y

" ctrl+v to paste from system clipboard
nnoremap <c-v> Pl
inoremap <c-v> <esc>lPa

" ctrl+x to cut to system clipboard
vnoremap <c-x> d

" ctrl+s to save
nmap <c-s> :w<CR>
vmap <c-s> <Esc>:w<cr>gv
imap <c-s> <Esc>:w<CR>i

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text selection
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Select using shift+arrow/home/insert
nnoremap <S-Right> v<Right>
xnoremap <S-Right> <Right>
inoremap <S-Right> <c-o>v<Right>
nnoremap <S-Left> v<Left>
xnoremap <S-Left> <Left>
inoremap <S-Left> <c-o>v<Left>
nnoremap <S-Up> v<Up>
xnoremap <S-Up> <Up>
inoremap <S-Up> <c-o>v<Up>
nnoremap <S-Down> v<Down>
xnoremap <S-Down> <Down>
inoremap <S-Down> <c-o>v<Down>
nnoremap <S-Home> v<Home>
inoremap <S-Home> <c-o>v<Home>
xnoremap <S-Home> <Home>
nnoremap <S-End> v<End>h
inoremap <S-End> <c-o>v<End>h
xnoremap <S-End> <End>h

" Select words using ctrl+shift+arrow/home/insert
nnoremap <C-S-Right> ve
xnoremap <C-S-Right> e
inoremap <C-S-Right> <c-o>ve
nnoremap <C-S-Left> vb
xnoremap <C-S-Left> b
inoremap <C-S-Left> <c-o>vb

" Select line using ctrl+shift+arrow/home/insert
nnoremap <C-S-Home> v<Home>
inoremap <C-S-Home> <c-o>v<Home>
xnoremap <C-S-Home> <Home>
nnoremap <C-S-End> v<End>
inoremap <C-S-End> <c-o>v<End>
xnoremap <C-S-End> <End>

" Exit VISUAL when shift not held.
xnoremap <Right> <Esc><Right>
xnoremap <Left> <Esc><Left>
xnoremap <Up> <Esc><Up>
xnoremap <Down> <Esc><Down>
xnoremap <C-Right> <Esc>e
xnoremap <C-left> <Esc>b

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configure embedded terminal
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Open a terminal in current buffer using ',t'
map <leader>t :terminal<cr>

" Open a terminal in a (horizontal) with ',ts'
map <leader>ts :split \| terminal<cr>

" Open a terminal in a vertical split with ',tv'
map <leader>tv :vsplit \| terminal<cr>

" Automatically open terminal in insert mode
autocmd BufWinEnter,WinEnter term://* startinsert

if has('nvim')
    " terminal closes automatically when exit
    " autocmd TermClose term://* :q!

    " disable line number in terminal mode
    autocmd TermOpen term://* startinsert | setlocal nonumber norelativenumber signcolumn=no
endif

" Escp to get out of insert mode like in any other buffer
tnoremap <Esc> <C-\><C-n>

" Automatically escapes when switching to another buffer
tnoremap <C-w><Up> <C-\><C-n><C-w><Up>
tnoremap <C-w><Down> <C-\><C-n><C-w><Down>
tnoremap <C-w><Left> <C-\><C-n><C-w><Left>
tnoremap <C-w><Right> <C-\><C-n><C-w><Right>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin Manager
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Some local variables
let s:vimrc=has('nvim') ? '~/.config/nvim/init.vim' : '~/.vimrc'
let s:plugpath=has('nvim') ? '~/.config/nvim/autoload/plug.vim' : '~/.vim/autoload/plug.vim'
let s:plugurl='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

" Install vim-plug automatically on first start
if empty(glob(s:plugpath))
    execute 'silent !curl -fLo ' . s:plugpath . ' --create-dirs ' . s:plugurl
    autocmd VimEnter * PlugInstall
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.config/nvim/plugged')
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color Scheme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'https://github.com/rafi/awesome-vim-colorschemes.git'

" setting the color scheme has to be delayed after plug#end()
function! SetColorScheme()
    syntax on
    set t_Co=256i
    silent! colorscheme seoul256
    set background=dark
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Airline - status/tab bar
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'https://github.com/vim-airline/vim-airline.git'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Configure satus bar
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#fugitiveline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#ycm = 0
let g:airline_powerline_fonts = 1
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.paste = 'p'
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_section_error = ''
let g:airline_section_warning = ''

" Configure tab bar
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#buffer_idx_mode = 1

" Navigate tab bar
nmap <c-w>1 <Plug>AirlineSelectTab1
nmap <c-w>2 <Plug>AirlineSelectTab2
nmap <c-w>3 <Plug>AirlineSelectTab3
nmap <c-w>4 <Plug>AirlineSelectTab4
nmap <c-w>5 <Plug>AirlineSelectTab5
nmap <c-w>6 <Plug>AirlineSelectTab6
nmap <c-w>7 <Plug>AirlineSelectTab7
nmap <c-w>8 <Plug>AirlineSelectTab8
nmap <c-w>9 <Plug>AirlineSelectTab9
nmap <c-tab> <Plug>AirlineSelectNextTab
nmap <c-s-tab> <Plug>AirlineSelectPrevTab
map <silent><c-t> :tabnew<cr>
map <silent><leader>w :bd!<cr>

" Select theme for both status and tab bar
Plug 'https://github.com/vim-airline/vim-airline-themes.git'
let g:airline_theme='bubblegum'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commenting out stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'https://github.com/tpope/vim-commentary.git'

" Toggle comment using ',c'
map <leader>c gcc

" Disable auto comment insertion on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Use // instead of /* */ when commenting out c code
autocmd FileType c setlocal commentstring=\/\/\ %s

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File explorer
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'https://github.com/scrooloose/nerdtree.git', { 'on': 'NERDTreeToggle' }
Plug 'https://github.com/ryanoasis/vim-devicons.git', { 'on': 'NERDTreeToggle' }
Plug 'https://github.com/tiagofumo/vim-nerdtree-syntax-highlight.git', { 'on': 'NERDTreeToggle' }

" Focus on most used filetype for efficiency
let g:NERDTreeLimitedSyntax = 1

" Toggle file explorer using ',b'
map <leader>b :NERDTreeToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Git integration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Call git from vim
Plug 'https://github.com/tpope/vim-fugitive.git'
map <Leader>gd :Gvdiff<cr>
map <Leader>gs :Gstatus<cr>
map <Leader>gb :Gblame<cr>

" Have some + and ~ in the gutter to indicate changes in a file
Plug 'https://github.com/airblade/vim-gitgutter'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fuzzy file search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Plug 'https://github.com/ctrlpvim/ctrlp.vim.git'

" Ctrl+p for fuzzy search ('r' means start at the .git)
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global search and replace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" faster async vimgrep
Plug 'https://github.com/mileszs/ack.vim.git'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Toggle quickfix (search result) with ',q' and
" loclist (compilation errors, etc) with ',l'
Plug 'https://github.com/Valloric/ListToggle.git'

" Make the quickfix editable, e.g. before global replace
Plug 'https://github.com/itchyny/vim-qfedit.git'

function! GlobalSearch()
    let l:search_query = input('Search: ')
    if !empty(l:search_query)
        exec ':Ack ' . '"' . l:search_query . '"'
    endif
    return l:search_query
endfunction

function! GlobalReplace()
    let l:save = winsaveview()
    let l:search_query = GlobalSearch()
    if !empty(l:search_query)
        let l:replace_by = input('Replace by: ')
        if !empty(l:replace_by)
            try
                exec ':cfdo %s/' . l:search_query . '/' . l:replace_by . '/gc | update'
            finally
                execute ':QToggle'
                call winrestview(l:save)
            endtry
        endif
    endif
endfunction

" Search throughout cwd using C-S-F
inoremap <C-S-F> <Esc>:call GlobalSearch()<cr>
nnoremap <C-S-F> :call GlobalSearch()<cr>

" Search and replace interactive using C-S-H
inoremap <C-S-H> <Esc>:call GlobalReplace()<cr>
nnoremap <C-S-H> :call GlobalReplace()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code Completion
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Installs/Updates YCM
function! BuildYCM(info)
    " info is a dictionary with 3 fields
    " - name:   name of the plugin
    " - status: 'installed', 'updated', or 'unchanged'
    " - force:  set on PlugInstall! or PlugUpdate!
    if a:info.status == 'installed' || a:info.force
        !./install.py --clang-completer
    endif
endfunction

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }

" Configure YouCompleteMe
let g:ycm_global_ycm_extra_conf = '~/.devbox/nvim/.ycm_extra_conf.py'
let g:ycm_auto_trigger = 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1P
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_semantic_triggers = {
	\   'python': [ 're!\w{2}' ],
	\   'c': [ 're!\w{2}' ]
	\ }

" <Enter> to confirm completion
set completeopt=menuone,preview,noinsert
function! ConfirmCompletion()
    if pumvisible()
        if !empty(v:completed_item)
            return "\<Esc>a"
        else
            return "\<c-n>\<Esc>a"
        endif
    else
        return "\<cr>"
    endif
endf
inoremap <expr> <cr> ConfirmCompletion()

" Configure completion pop
set pumheight=10
highlight Pmenu ctermbg=white

" Goto declaration + jump to file with <leader>j
nnoremap <silent> <leader>j :YcmCompleter GoTo<CR>
inoremap <silent> <leader>j <Esc>:YcmCompleter GoTo<CR>
vnoremap <silent> <leader>j <Esc>:YcmCompleter GoTo<CR>

nnoremap <silent> <leader>x :YcmCompleter FixIt<CR>
inoremap <silent> <leader>x <Esc>:YcmCompleter FixIt<CR>
vnoremap <silent> <leader>x <Esc>:YcmCompleter FixIt<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Code navigation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Update ctags automagically
Plug 'https://github.com/xolox/vim-misc'
Plug 'https://github.com/xolox/vim-easytags.git'

" Navigation bar on the side (open with ',n'
Plug 'https://github.com/majutsushi/tagbar.git'
map <silent> <leader>n :TagbarOpenAutoClose<cr>
let g:tagbar_autofocus = 1
let g:tagbar_left = 1
let g:easytags_async = 1

" Switch from .h to .c and vice versa using ',o'
Plug 'https://github.com/ericcurtin/CurtineIncSw.vim'
map <leader>o :call CurtineIncSw()<cr>

" Goto tag (+/- goto declaration)
map <silent> <leader>k <c-]>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscelaneous
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Dim inactive windows
Plug 'https://github.com/blueyed/vim-diminactive.git'

" Remember cursor position when editing a file
Plug 'https://github.com/farmergreg/vim-lastplace'

" Move lines around using alt+j/k
Plug 'https://github.com/matze/vim-move.git'

" Zoom on current buffer using <c-w> <c-o>
Plug 'https://github.com/troydm/zoomwintab.vim.git'

" Multiple cursors (ctrl+n / ctrl+p then c to change)
Plug 'https://github.com/terryma/vim-multiple-cursors.git'

" Autoformat code with ',f'
Plug 'https://github.com/Chiel92/vim-autoformat.git'
map <leader>f :Autoformat<cr>

" Language pack
Plug 'https://github.com/sheerun/vim-polyglot.git'

" Syntax checker
Plug 'https://github.com/vim-syntastic/syntastic.git'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Build using make
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Allow to call :Make to spawn the build in a background terminal (tmux, iterm, etc).
Plug 'https://github.com/tpope/vim-dispatch'

" Allow to use the neovim built-in terminal on top of dispatch.
Plug 'https://github.com/radenling/vim-dispatch-neovim.git'

map <F17> :make test -s \| copen <cr><cr>G
map <F7> :make -s \| copen <cr><cr>G

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#end()
call SetColorScheme() " should happen after plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Handling trailing whitespace
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! TrimWhitespaceCurrentLine()
    let l:save = winsaveview()
    s/\s\+$//eg
    call winrestview(l:save)
endfunction

function! TrimWhitespaceCurrentFile()
    let l:save = winsaveview()
    %s/\s\+$//eg
    call winrestview(l:save)
endfunction

" ',tr' to trim whitespace

nmap <silent> <leader>tr :call TrimWhitespaceCurrentLine()<cr>

" ',tra' to trim whitespace in all file
nmap <silent> <leader>tra :call TrimWhitespaceCurrentFile()<cr>

" Highlight itrailing whitespace
syntax on
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()



