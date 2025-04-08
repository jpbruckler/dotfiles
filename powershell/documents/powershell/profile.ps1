# Set output rendering if called from Vim/Neovim
if ($env:VIMRUNTIME) {
    $PSStyle.OutputRendering = 'PlainText'
}

