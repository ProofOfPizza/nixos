" init.vim

" Basic settings
set number
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
"colorscheme PaperColor

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

"search
nnoremap <C-g> :GFiles?<CR>
nnoremap <C-h> :History<CR>
nnoremap <C-l> :Rg<CR>
nnoremap <C-b> :BLines<CR>
nnoremap <C-p> :All<CR>
nnoremap <leader>v :Buffers<CR>
"set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
let g:fzf_preview_window = ['up:50%:hidden', 'ctrl-/']
command! -bang -nargs=*  All
  \ call fzf#run(fzf#wrap({'source': 'rg --files --hidden --no-ignore-vcs --glob "!{node_modules/*,.git/*}"', 'options': '--expect=ctrl-t,ctrl-x,ctrl-v --multi --reverse' }))

"======================== copied from source: https://github.com/junegunn/fzf.vim/blob/master/plugin/fzf.vim ============
"======================== can possibly be removed  after update =========================================================
command! -bang -nargs=* Rg
  \ call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case -- ".shellescape(<q-args>),
  \ 1, s:p(), <bang>0)

command! -bang -nargs=* History
  \ call s:history(<q-args>, s:p(), <bang>0)'])

command! -bar -bang -nargs=? -complete=buffer Buffers
  \ call fzf#vim#buffers(<q-args>, s:p({ "placeholder": "{1}" }), <bang>0)

function! s:p(...)
  let preview_args = get(g:, 'fzf_preview_window', ['right', 'ctrl-/'])
  if empty(preview_args)
    return { 'options': ['--preview-window', 'hidden'] }
  endif

  " For backward-compatiblity
  if type(preview_args) == type("")
    let preview_args = [preview_args]
  endif
  return call('fzf#vim#with_preview', extend(copy(a:000), preview_args))
endfunction

function! s:history(arg, extra, bang)
  let bang = a:bang || a:arg[len(a:arg)-1] == '!'
  if a:arg[0] == ':'
    call fzf#vim#command_history(bang)
  elseif a:arg[0] == '/'
    call fzf#vim#search_history(bang)
  else
    call fzf#vim#history(a:extra, bang)
  endif
endfunction

