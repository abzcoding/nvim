local M = {}
local function check_backspace()
  local col = vim.fn.col "." - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match "%s" then
    return true
  else
    return false
  end
end

local function T(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

M.config = function()
  vim.o.completeopt = "menuone,noselect"

  -- nvim-cmp setup
  local cmp = require "cmp"
  local luasnip = require "luasnip"
  cmp.setup {
    formatting = {
      format = function(entry, vim_item)
        local icons = require("config.lsp.kind").icons
        vim_item.kind = icons[vim_item.kind]
        vim_item.menu = ({
          nvim_lsp = "[L]",
          emoji = "[E]",
          path = "[F]",
          calc = "[C]",
          vsnip = "[S]",
          buffer = "[B]",
        })[entry.source.name]
        vim_item.dup = ({
          buffer = 1,
          path = 1,
          nvim_lsp = 0,
        })[entry.source.name] or 0
        return vim_item
      end,
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.close(),
      -- ["<ESC>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(T "<C-n>", "n")
        elseif luasnip.expand_or_jumpable() then
          vim.fn.feedkeys(T "<Plug>luasnip-expand-or-jump", "")
        elseif check_backspace() then
          vim.fn.feedkeys(T "<Tab>", "n")
        else
          vim.fn.feedkeys(T "<C-Space>") -- Manual trigger
        end
      end, {
        "i",
        "s",
      }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if vim.fn.pumvisible() == 1 then
          vim.fn.feedkeys(T "<C-p>", "n")
        elseif luasnip.jumpable(-1) then
          vim.fn.feedkeys(T "<Plug>luasnip-jump-prev", "")
        else
          fallback()
        end
      end, {
        "i",
        "s",
      }),
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      {
        name = "buffer",
        opts = {
          get_bufnrs = function()
            local bufs = {}
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              bufs[vim.api.nvim_win_get_buf(win)] = true
            end
            return vim.tbl_keys(bufs)
          end,
        },
      },
      { name = "calc" },
      { name = "emoji" },
      -- { name = "nvim_lua" },
    },
  }
end
return M
