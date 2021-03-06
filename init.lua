vim.cmd [[
  syntax off
  filetype off
  filetype plugin indent off
]]

vim.opt.shadafile = "NONE"
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false
vim.g.loaded_tar = false
vim.g.loaded_netrw = false
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

require "util"
require "options"

vim.defer_fn(function()
  require "plugins"
  vim.opt.shadafile = ""
  vim.cmd [[
    rshada!
    doautocmd BufRead
    syntax on
    filetype on
    filetype plugin indent on
  ]]
  vim.defer_fn(function()
    vim.cmd [[
      PackerLoad impatient.nvim
      PackerLoad which-key.nvim
      PackerLoad nvim-lspconfig
      silent! bufdo e
    ]]
  end, 5)
end, 0)
