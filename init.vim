:set number
:set relativenumber
:set autoindent

set scrolloff=7

filetype on
filetype indent on
filetype plugin on


call plug#begin(stdpath('data') . '/plugged')

" main one
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" 9000+ Snippets
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-lualine/lualine.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'preservim/nerdtree'
Plug 'SidOfc/mkdx'
Plug 'fatih/vim-go'

call plug#end()


nnoremap <C-f> :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTree<CR>
nnoremap <C-t> :NERDTreeToggle<CR>




lua << END
require'lualine'.setup {
	options = {
		icons_enabled = true,
		theme = 'powerline_dark',
	}
}

END
