let mapleader = ","

set nocompatible  " Use Vim settings, rather then Vi settings
set nobackup
set nowritebackup
set noswapfile    " http://robots.thoughtbot.com/post/18739402579/global-gitignore#comment-458413287
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set backspace=indent,eol,start
set hlsearch

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
	syntax on
endif

"clear the search buffer when hitting return or esc
augroup no_highlight
	autocmd TermResponse * nnoremap <esc> :noh<return><esc>
augroup END

if filereadable(expand("~/.vimrc.bundles"))
	source ~/.vimrc.bundles
endif

filetype plugin indent on " Enable filetype-specific indenting and plugins

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" configure syntastic syntax checking to check on open as well as save
let g:syntastic_check_on_open=1

" Local config
if filereadable($HOME . "/.vimrc.local")
	source ~/.vimrc.local
endif

"Rename Current File
function! RenmaeFile()
	let old_name = expand('%')
	let new_name = input('New file name: ', expand('%'), 'file')
	if new_name != '' && new_name != old_name
		exec ':saveas ' . new_name
		exec ':silent !rm ' . old_name
		redraw!
	endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>t :silent call RunTestFile()<cr>
map <leader>T :silent call RunNearestTest()<cr>
map <leader>a :silent call RunTests('')<cr>
map <leader>c :w\|:silent !script/features<cr>
map <leader>w :w\|:silent !script/features --profile wip<cr>

function! RunTestFile(...)
	if a:0
		let command_suffix = a:1
	else
		let command_suffix = ""
	endif

	" Run the tests for the previously-marked file.
	let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
	if in_test_file
		call SetTestFile()
	elseif !exists("t:grb_test_file")
		return
	end
	call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
	let spec_line_number = line('.')
	call RunTestFile(":" . spec_line_number)
endfunction

function! SetTestFile()
	" Set the spec file that tests will be run for.
	let t:grb_test_file=@%
endfunction

function! RunTests(filename)
	" Write the file and run tests for the given filename
	:w
	if match(a:filename, '\.feature$') != -1
		exec ":!script/features " . a:filename
	else
		if filereadable("script/test")
			exec ":!script/test " . a:filename
		elseif filereadable("Gemfile")
			exec ":!bundle exec rspec --color " . a:filename
		else
			exec ":!rspec --color " . a:filename
		end
	end
endfunction

"""""""""""""""""""
"Random Key Mappings
"""""""""""""""""""

"make shift-tab unindent
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i

map <Leader>bb :!bundle install<cr>
map <Leader>co :Tabularize /\|
map <Leader>i mmgg=G`m<CR>
map <Leader>pn :sp ~/Dropbox/notes/programing_notes.txt<cr>
map <Leader>ra :%s/
map <Leader>sp yss<p>
map <Leader>st :sp ~/Dropbox/notes/sharpen_tools.txt<cr>
map <Leader>vi :tabe ~/Dropbox/dotfiles/dotfiles/vimrc<CR>
map <Leader>vu :RVunittest<CR>
map <Leader>vm :RVmodel<cr>
map <Leader>vv :RVview<cr>
map <Leader>vc :RVcontroller<cr>
map <Leader>vf :RVfunctional<cr>
nnoremap <leader>w :w!<cr>

imap <C-j> (
imap <C-k> )

command! Q q " Bind :Q to :q
command! WQ wq
command! Wq wq
command! W w
