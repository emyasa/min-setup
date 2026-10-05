vim.g.mapleader = " "

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 8

vim.opt.guicursor = table.concat({
  "n:block",                              -- Normal: non-blinking block
  "v:block",                              -- Visual: non-blinking block
  "c:block",                              -- Command: non-blinking block
  "i:block-blinkwait700-blinkoff400-blinkon250",   -- Insert: blinking block
  "ci:block-blinkwait700-blinkoff400-blinkon250",
  "ve:block-blinkwait700-blinkoff400-blinkon250",
  "r:hor20",                              -- Replace: non-blinking horizontal
  "cr:hor20",
  "o:hor50",                              -- Operator-pending: non-blinking horizontal
}, ",")
