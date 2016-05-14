" Tim Chu's vimrc, from Yann Eposito's vimrc (Google it and you'll find a 
" great writeup).
" Other alternatives: vim mode haskell, Stephen Diehl's haskell. For the
" second, see http://www.stephendiehl.com/posts/vim_2016.html

" This vimrc should work out of the box.
"
" Awesome things you can do:
" 1. In-line typechecks. (ghcmod)
" 2. Lookup user defined function definition (hit <space>f over a function
" name. Type lookup can be done via <space>t).
" 3. Ghclint will automatically lint your files and make suggestions.

" Things you can do but I haven't made work yet:
" 1. Inline Vim Hoogling
" 2. hdevtools

"""""" More documentation
" Basic things to lookup if you are so inclined:
" 1. Yann Eposito's vimrc.  Just google this, and you'll find it. He has a
" great writeup. This forms the core of this vimrc.
" 2. Unite, a great vim plugin. 
" 3. VimFilerExplorer, a replacement for NERDTree.
" 4. Vim-Hoogle. In-line vim.
" 5. ghc-mod and ghcmod-vim. In-line type checks.

" Main changes by Tim Chu are:
"   1. commenting out neocomplcache.
"   2. <space>f jumps to user defined function definitions.
"   2. <space>t jumps to user defined function definitions.
"   3. Vim Hoogle isn't enabled. No good reason.
"   4. Commented  out haskell-concealplus. It messed up the indents, a known
"   issue.
"   5. Added VimFilerExplorer, which opens by default. It's a replacement for
"   NERDTree. You can disable it by setting let g:vimfiler_as_default_explorer = 0
"   5. Ghcmod is AWESOME. This isn't a change from Yann Eposito's vim, but
"   it's pretty cool anyways.

"""""""""""""""""""""""""""""""""""""""""""""""""

" Yann Esposito
" http://yannesposito.com
" @yogsototh
"
" ---------- VERY IMPORTANT -----------
" To install plugin the first time:
" > vim +PlugInstall +qall
" cd ~/.vim/plugged/vimproc.vim && make
" cabal install ghc-mod
" -------------------------------------
call plug#begin('~/.vim/plugged')
" #### set rtp+=~/.vim/vundle/Vundle.vim/
" set rtp+=~/.vim/bundle/vundle/
" ### call vundle#rc()
" the vundle plugin to install vim plugin
" Bundle 'gmarik/vundle'
" completion during typing
Plug 'neocomplcache'
Plug 'Shougo/neocomplete'
" solarized colorscheme
Plug 'altercation/vim-colors-solarized'
" Right way to handle trailing-whitespace
" Plug 'bronson/vim-trailing-whitespace'
" NERDTree
" Plug 'scrooloose/nerdtree'
" Unite
"   depend on vimproc
"   you have to go to .vim/plugin/vimproc.vim and do a ./make
Plug 'Shougo/vimproc.vim'
Plug 'Shougo/vimfiler.vim'
Plug 'Shougo/unite.vim'
" writing pandoc documents
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
" GIT
Plug 'tpope/vim-fugitive'
" show which line changed using git
Plug 'airblade/vim-gitgutter'
" Align code
Plug 'junegunn/vim-easy-align'
Plug 'scrooloose/syntastic'             " syntax checker
" --- Haskell
Plug 'yogsototh/haskell-vim'            " syntax indentation / highlight
"Plug 'enomsg/vim-haskellConcealPlus'    " unicode for haskell operators
Plug 'eagletmt/ghcmod-vim'
Plug 'eagletmt/neco-ghc'
Plug 'Twinside/vim-hoogle'
Plug 'pbrisbin/html-template-syntax'    " Yesod templates
" --- XML
Plug 'othree/xml.vim'
" " -- Clojure
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-repeat'
" " Plug 'paredit.vim'
Plug 'tpope/vim-fireplace'
" " <<< vim-fireplace dependencie
" Plug 'tpope/vim-classpath'
" Plug 'jpalardy/vim-slime'
" -- ag
Plug 'rking/ag.vim'
" --- elm-lang
Plug 'lambdatoast/elm.vim'
" --- Idris
Plug 'idris-hackers/idris-vim'
" -- reload browser on change
" Plug 'Bogdanp/browser-connect.vim'
Plug 'maksimr/vim-jsbeautify'
Plug 'einars/js-beautify'
call plug#end()
set nocompatible
" ###################
" ### Plugin conf ###
" ###################
" -------------------
"       Haskell
" -------------------
let mapleader="-"
let g:mapleader="-"
set tm=2000
nmap <silent> <leader>ht :GhcModType<CR>
nmap <silent> <leader>hh :GhcModTypeClear<CR>
nmap <silent> <leader>hT :GhcModTypeInsert<CR>
nmap <silent> <leader>hc :SyntasticCheck ghc_mod<CR>:lopen<CR>
let g:syntastic_mode_map={'mode': 'active', 'passive_filetypes': ['haskell']}
let g:syntastic_always_populate_loc_list = 1
nmap <silent> <leader>hl :SyntasticCheck hlint<CR>:lopen<CR>
" Auto-checking on writing
autocmd BufWritePost *.hs,*.lhs GhcModCheckAndLintAsync
"  neocomplcache (advanced completion)
" CURRENTLY SLOW AS BALLS. Commented out!
let g:acp_enableAtStartup = 0
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_dictionary_filetype_lists = {
     \ 'default' : '',
     \ 'vimshell' : $HOME.'/.vimshell_hist',
     \ 'scheme' : $HOME.'.ghosh_completions'
     \ }
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
    return neocomplcache#smart_close_popup() . "\<CR>"
endfunction
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
function! SetToCabalBuild()
    if glob("*.cabal") != ''
        set makeprg=cabal\ build
    endif
endfunction
autocmd BufEnter *.hs,*.lhs :call SetToCabalBuild()
" -- neco-ghc
let $PATH=$PATH.':'.expand("~/.cabal/bin")
autocmd BufEnter *.hs,*.lhs setlocal omnifunc=necoghc#omnifunc
" -- Frege
autocmd BufEnter *.fr :filetype haskell
" ----------------
"       GIT
" ----------------
" -- vim-gitgutter
highlight clear SignColumn
highlight SignColumn ctermbg=0
nmap gn <Plug>GitGutterNextHunk
nmap gN <Plug>GitGutterPrevHunk
" -----------------
"       THEME
" -----------------
" -- solarized theme
set background=light
try
    colorscheme solarized
catch
endtry
" ----------------------------
"       File Management
" ----------------------------
let g:unite_source_history_yank_enable = 1
try
  let g:unite_source_rec_async_command='ag --nocolor --nogroup -g ""'
  call unite#filters#matcher_default#use(['matcher_fuzzy'])
catch
endtry
" search a file in the filetree
nnoremap <space><space> :tabedit<cr>:<C-u>Unite -start-insert file_rec/async<cr>
nnoremap <space>k :<C-u>Unite file<cr>
nnoremap <space>g :<C-u>Unite -start-insert file_rec/git<cr>
" make a grep on all files!
nnoremap <space>/ :<C-u>Unite grep:.<cr>
nnoremap <space>w "zyiw :<C-u>Unite grep:. <cr><C-r>z <cr>
" Looks up where a word is used in the current directory (recursive).
" Call this when your cursor is over a word.
nnoremap <space>W "zyiw :<C-u>Unite grep:. <cr><C-r>z 

" nnoremap <space>d "zyiw :<C-u>Unite grep:. <cr><C-r>z :: <cr>

" Looks up a function definition in Haskell, via a silly grep.
" Call this when your cursor is over a function name. It will open a top bar
" that you can use j k and l to scroll through.
nnoremap <space>f "zyiw :<C-u>Unite grep:. <cr><C-r>z :: <cr>

" Looks up a word is used in the current directory (recursive).
" Call this when your cursor is over a word.
nnoremap <space>u "zyiw :<C-u>Unite grep:. <cr>[( ]<C-r>z <cr>

" Looks up a type definition in Haskell, via a silly grep. This doesn't
" quite work for constructors, unfortunately.
" Call this when your cursor is over a type name.
nnoremap <space>t "zyiw :<C-u>Unite grep:. <cr>\(^data <C-r>z \\|^newtype <C-r>z \\|^type <C-r>z \)<cr>
nnoremap <space>y :open<cr>:<C-u>Unite history/yank<cr>
" reset not it is <C-l> normally
nnoremap <space>r <Plug>(unite_restart)
" ------------------
"       Clojure
" ------------------
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesActivate
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadRound
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadSquare
autocmd BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadBraces
" Fix I don't know why
autocmd BufEnter *.cljs,*.clj,*.cljs.hl setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.,:
" -- Rainbow parenthesis options
let g:rbpt_colorpairs = [
	\ ['darkyellow',  'RoyalBlue3'],
	\ ['darkgreen',   'SeaGreen3'],
	\ ['darkcyan',    'DarkOrchid3'],
	\ ['Darkblue',    'firebrick3'],
	\ ['DarkMagenta', 'RoyalBlue3'],
	\ ['darkred',     'SeaGreen3'],
	\ ['darkyellow',  'DarkOrchid3'],
	\ ['darkgreen',   'firebrick3'],
	\ ['darkcyan',    'RoyalBlue3'],
	\ ['Darkblue',    'SeaGreen3'],
	\ ['DarkMagenta', 'DarkOrchid3'],
	\ ['Darkblue',    'firebrick3'],
	\ ['darkcyan',    'SeaGreen3'],
	\ ['darkgreen',   'RoyalBlue3'],
	\ ['darkyellow',  'DarkOrchid3'],
	\ ['darkred',     'firebrick3'],
	\ ]
" #####################
" ### Personal conf ###
" #####################
" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
set bs=2		        " allow backspacing over everything in insert mode
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
			            " than 50 lines of registers
set history=10000	    " keep 100000 lines of command line history
set ruler		        " show the cursor position all the time
syntax on " syntax highlighting
set hlsearch " highlight searches
set visualbell " no beep
" move between splits
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" -- sudo save
cmap w!! w !sudo tee >/dev/null %
" Tabulation management
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set smartindent
set cindent
set cinoptions=(0,u0,U0
" Spellchecking
if has("spell") " if vim support spell checking
    " Download dictionaries automatically
    if !filewritable($HOME."/.vim/spell")
        call mkdir($HOME."/.vim/spell","p")
    endif
    set spellsuggest=10 " z= will show suggestions (10 at most)
    " spell checking for text, HTML, LaTeX, markdown and literate Haskell
    autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spell
    autocmd BufEnter *.txt,*.tex,*.html,*.md,*.ymd,*.lhs setlocal spelllang=fr,en
    " better error highlighting with solarized
    highlight clear SpellBad
    highlight SpellBad term=standout ctermfg=2 term=underline cterm=underline
    highlight clear SpellCap
    highlight SpellCap term=underline cterm=underline
    highlight clear SpellRare
    highlight SpellRare term=underline cterm=underline
    highlight clear SpellLocal
    highlight SpellLocal term=underline cterm=underline
endif
" Easy align interactive
vnoremap <silent> <Enter> :EasyAlign<cr>
" .ymd file type
autocmd BufEnter *.ymd set filetype=markdown
autocmd BufEnter *.cljs,*.cljs.hl set filetype=clojure
" -- Reload browser on cljs save
"  don't forget to put <script src="http://localhost:9001/ws"></script>
"  in your HTML
" au BufWritePost *.cljs :BCReloadPage
" ========
" Personal
" ========
" Easier anti-quote
imap éé `
" -- show the column 81
if (exists('+colorcolumn'))
    set colorcolumn=80
    highlight ColorColumn ctermbg=0
endif
" --- type ° to search the word in all files in the current dir
nmap ° :Ag <c-r>=expand("<cword>")<cr><cr>
" -- js beautifer
autocmd FileType javascript noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType html noremap <buffer> <c-f> :call JsBeautify()<cr>
autocmd FileType css noremap <buffer> <c-f> :call JsBeautify()<cr>
" set noswapfile
" -- vim-pandoc folding
let g:pandoc#modules#disabled = ["folding"]

" END YANN EPOSITOS FUNCTIONS. BEGIN TIM CHU'S CUSTOM THINGS.

nnoremap ; :
nnoremap , :noh<cr>
if $COLORTERM == 'gnome-terminal'
  set t_Co=256
endif
nnoremap H gT
nnoremap L gt
set clipboard+=unnamed
set nu
set ic
let g:vimfiler_as_default_explorer = 1
" autocmd VimEnter * VimFilerExplorer
set conceallevel=0

" BEGIN NEOCOMPLETE
" BEGIN AUTOCOMPLETE
" Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" " Disable AutoComplPop.
" let g:acp_enableAtStartup = 0
" " Use neocomplete.
" let g:neocomplete#enable_at_startup = 1
" " Use smartcase.
" let g:neocomplete#enable_smart_case = 1
" " Set minimum syntax keyword length.
" let g:neocomplete#sources#syntax#min_keyword_length = 3
" let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" 
" " Define dictionary.
" let g:neocomplete#sources#dictionary#dictionaries = {
"     \ 'default' : '',
"     \ 'vimshell' : $HOME.'/.vimshell_hist',
"     \ 'scheme' : $HOME.'/.gosh_completions'
"         \ }
" 
" " Define keyword.
" if !exists('g:neocomplete#keyword_patterns')
"     let g:neocomplete#keyword_patterns = {}
" endif
" let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" 
" " Plugin key-mappings.
" inoremap <expr><C-g>     neocomplete#undo_completion()
" inoremap <expr><C-l>     neocomplete#complete_common_string()
" 
" " Recommended key-mappings.
" " <CR>: close popup and save indent.
" inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
" function! s:my_cr_function()
"   " For no inserting <CR> key.
" endfunction
" " <TAB>: completion.
" " <C-h>, <BS>: close popup and delete backword char.
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" " Close popup by <Space>.
" 
" " AutoComplPop like behavior.
" "let g:neocomplete#enable_auto_select = 1
" 
" " Shell like behavior(not recommended).
" "set completeopt+=longest
" "let g:neocomplete#enable_auto_select = 1
" "let g:neocomplete#disable_auto_complete = 1
" 
" " Enable omni completion.
" autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
" autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
" autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
" autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
" autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" 
" " Enable heavy omni completion.
" if !exists('g:neocomplete#sources#omni#input_patterns')
"   let g:neocomplete#sources#omni#input_patterns = {}
" endif
" "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" 
" " For perlomni.vim setting.
" " https://github.com/c9s/perlomni.vim
" let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
