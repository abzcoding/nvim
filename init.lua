-- Disable these for very fast startup time
vim.cmd [[
  syntax off
  filetype off
  filetype plugin indent off
]]

-- Temporarily disable shada file to improve performance
vim.opt.shadafile = "NONE"
-- Disable some unused built-in Neovim plugins
vim.g.loaded_gzip = false
vim.g.loaded_netrwPlugin = false
vim.g.loaded_tarPlugin = false
vim.g.loaded_zipPlugin = false
vim.g.loaded_2html_plugin = false
vim.g.loaded_remote_plugins = false
vim.g.loaded_tar = 1
vim.g.loaded_netrw = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

require "util"
require "options"

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
  require "plugins"
  vim.opt.shadafile = ""
  vim.cmd [[
    rshada!
    doautocmd BufRead
    syntax on
    filetype on
    filetype plugin indent on
    PackerLoad nvim-treesitter
  ]]
end, 0)
