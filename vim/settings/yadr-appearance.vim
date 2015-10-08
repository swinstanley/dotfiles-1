" Make it beautiful - colors and fonts
scriptencoding utf-8
set encoding=utf-8

if has("gui_running")
  "tell the term has 256 colors
  set t_Co=256

  " Show tab number (useful for Cmd-1, Cmd-2.. mapping)
  " For some reason this doesn't work as a regular set command,
  " (the numbers don't show up) so I made it a VimEnter event
  autocmd VimEnter * set guitablabel=%N:\ %t\ %M

  set lines=60
  set columns=190

  if has("gui_gtk2")
    set guifont=Inconsolata\ XL\ 12,Inconsolata\ 15,Monaco\ 12
  elseif has ("macos")
    set guifont=Inconsolata\ XL:h17,Inconsolata:h20,Monaco:h17
  elseif has ("win32") || has("win64")
    let regfont = system('reg query HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts')
    set guifont=Consolas_for_Powerline_FixedD:h11:cANSI
  elseif syste
    set guifont=ConsolasD:h11:cANSI
  end
else
  let g:CSApprox_loaded = 1
  " For people using a terminal that is not Solarized
  let g:solarized_termcolors=256
  let g:solarized_termtrans=1
endif

let g:solarized_contrast="high"
colorscheme solarized
set background=dark
