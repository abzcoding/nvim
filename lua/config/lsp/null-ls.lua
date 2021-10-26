local M = {}

function M.setup()
  local nls = require "null-ls"
  nls.config {
    debounce = 150,
    save_after_format = false,
    sources = {
      nls.builtins.formatting.prettier,
      nls.builtins.formatting.stylua,
      nls.builtins.formatting.black.with { extra_args = { "--fast" } },
      nls.builtins.formatting.isort.with { extra_args = { "--profile", "black" } },
      nls.builtins.formatting.goimports,
      nls.builtins.formatting.shfmt.with { extra_args = { "-i", "2", "-ci" } },
      nls.builtins.diagnostics.hadolint,
      nls.builtins.diagnostics.eslint_d,
      nls.builtins.diagnostics.shellcheck,
      nls.builtins.diagnostics.markdownlint,
      nls.builtins.diagnostics.selene,
      nls.builtins.diagnostics.vint,
      nls.builtins.diagnostics.chktex,
    },
  }
  -- require("lspconfig")["null-ls"].setup(options)
end

function M.has_formatter(ft)
  local config = require("null-ls.config").get()
  local formatters = config._generators["NULL_LS_FORMATTING"]
  for _, f in ipairs(formatters) do
    if vim.tbl_contains(f.filetypes, ft) then
      return true
    end
  end
end

return M
