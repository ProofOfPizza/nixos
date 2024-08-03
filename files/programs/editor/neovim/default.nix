" init.vim

" Basic settings
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set nocompatible
set hidden
set encoding=utf-8
set mouse=nv
set nofoldenable
set clipboard+=unnamedplus
set background=dark
set signcolumn=yes
set updatetime=300
set nobackup
set nowritebackup
set noendofline
set nofixendofline
set t_Co=256

" Set leader key
let mapleader = " "

" Plugins configuration using vim-plug
call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-sensible'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'argtextobj-vim'
Plug 'jiangmiao/auto-pairs'
Plug 'bkad/CamelCaseMotion'
Plug 'direnv/direnv.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'raichoo/haskell-vim'
Plug 'mboughaba/i3config.vim'
Plug 'martinda/Jenkinsfile-vim-syntax'
Plug 'NLKNguyen/papercolor-theme'
Plug 'wakatime/vim-wakatime'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'voldikss/vim-floaterm'
Plug 'pangloss/vim-javascript'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'godlygeek/tabular'
Plug 'hashivim/vim-terraform'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Airline configuration
let g:airline_powerline_fonts = 1
let g:airline_theme='luna'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_alt_sep = '|'

" Coc.nvim configuration
let g:coc_global_extensions = [
    \ 'coc-json', 'coc-tsserver', 'coc-prettier', 'coc-eslint',
    \ 'coc-solargraph', 'coc-html', 'coc-xml', 'coc-angular' ]

" CamelCaseMotion
let g:camelcasemotion_key = '<leader>'

" Mappings for Coc.nvim actions
nmap <silent><leader>g <Plug>(coc-definition)
nmap <leader>t <Plug>(coc-type-definition)
nmap <leader>i <Plug>(coc-implementation)
nmap <leader>w <Plug>(coc-references)
nmap <leader>r <Plug>(coc-rename)
nmap <leader>d  <Plug>(coc-codeaction)
nmap <leader>k  <Plug>(coc-codeaction-selected)
nmap <leader>j  <Plug>(coc-codeaction-line)
nmap <leader>h  <Plug>(coc-codeaction-cursor)
nmap <leader>f  <Plug>(coc-fix-current)
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Enable spell checking for markdown and feature files
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.md.erb setlocal spell
au BufRead,BufNewFile *.feature setlocal spell

" Floaterm configuration
let g:floaterm_opener = 'edit'
vnoremap <leader>m :FloatermNew --autoclose=2 vifm<CR>
nnoremap <leader>m :FloatermNew --autoclose=2 vifm<CR>

" Buffer navigation
map <leader>0 :bn<cr>
map <leader>9 :bp<cr>
map <leader>3 :b#<cr>
map <leader>4 ":b "
nnoremap <C-x> :bd<cr>

" Mappings for moving lines and blocks
xnoremap <C-S-Up> xkP`[V`]
xnoremap <C-S-Down> xp`[V`]
xnoremap <C-S-Left> <gv
xnoremap <C-S-Right> >gv

" Additional mappings and custom commands
nnoremap <leader>n :%s///gn<CR>
nnoremap ff :Commentary<CR>
vnoremap ff :Commentary<CR>
vnoremap fg $%:Commentary<CR>
let g:user_emmet_leader_key=','

" Enable syntax highlighting and filetype plugins
filetype plugin on
filetype indent on
syntax on

" Colorscheme
colorscheme PaperColor

" Custom functions
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Automatically delete trailing spaces
autocmd BufWritePre * :%s/\s\+$//e
