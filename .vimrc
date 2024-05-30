set rnu
set nu
set shiftwidth=3
set softtabstop=3
set tabstop=3
set expandtab
set autoindent
set smartindent
set hlsearch
set background=dark

if has('autocmd')
   autocmd Filetype makefile setlocal noexpandtab
   autocmd FileType xml setlocal indentexpr=
   autocmd BufWritePre * :%s/\(\s*\n\)\+\%$//ge
   autocmd BufWritePre * :%s/\(\s*\n\)\{3,}/\r\r/ge
   autocmd BufWritePre * :%s/\s\+$//ge
endif

nnoremap ,c :nohlsearch<CR>
nnoremap ,i mqggVG=`qzz
nnoremap ,b :e ++ff=unix<CR>
nnoremap ,m :%s/\r$//<CR>
nnoremap ,s :set ft=sh<CR>
