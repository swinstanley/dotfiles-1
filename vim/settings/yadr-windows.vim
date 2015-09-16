if exists('loaded_yadr_windows')
  finish
endif
if has('win32') || has ('win64') || has("win32unix")
" Use forward slashes by default
  if exists('+shellslash')
    set shellslash
  endif
" use unix line endings by default
  if &fileformat == ''
    set fileformat='unix'
  endif
endif
let loaded_yadr_windows=1
