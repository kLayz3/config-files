set number
set relativenumber
set autoindent
set tabstop=4
set shiftwidth=4
set smarttab
set softtabstop=4
set mouse=v
set encoding=UTF-8

call plug#begin()

Plug 'https://github.com/vim-airline/vim-airline' " Status bar 
Plug 'https://github.com/preservim/nerdtree' 	  " NerdTree
Plug 'http://github.com/tpope/vim-surround' 	  " Surrounding ysw)
Plug 'https://github.com/tpope/vim-commentary'    " For Commenting gcc & gc
Plug 'https://github.com/rafi/awesome-vim-colorschemes' " Retro Scheme
Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}  " Auto Completion
Plug 'https://github.com/tmsvg/pear-tree'		  " Bracket automatching

call plug#end()

nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>

nnoremap <C-l> :call CocActionAsync('jumpDefinition')<CR>
inoremap <expr> <Tab> pumvisible() ? coc#_select_confirm() : "<Tab>"

" inoremap { {}<Esc>ha<Tab>
" inoremap { {<CR>}<Esc>ko<tab>
" inoremap ( ()<Esc>ha
" inoremap [ []<Esc>ha
" inoremap " ""<Esc>ha
" inoremap ' ''<Esc>ha
" inoremap ` ``<Esc>ha
"let g:NERDTreeDirArrowExpandable="+"
"let g:NERDTreeDirArrowCollapsible="~"

" Error flags
let g:coc_disable_startup_warning = 1
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers = 1
let g:pear_tree_smart_closers = 1
let g:pear_tree_smart_backspace = 1

" --- Notes & Hacks ---
" :PlugClean :PlugInstall :UpdateRemotePlugins
" :CocInstall coc-python
" :CocInstall coc-clangd
" :CocInstall coc-snippets
" :CocCommand snippets.edit... FOR EACH FILE TYPE
"
" In case CoC gives errors on startup - install nodejs and google the errors
" LOL
