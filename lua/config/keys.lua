return function()
  local wk = require "which-key"
  local util = require "util"

  vim.o.timeoutlen = 200

  local presets = require "which-key.plugins.presets"
  presets.objects["a("] = nil
  wk.setup {
    show_help = false,
    triggers = "auto",
    plugins = { spelling = true },
    key_labels = { ["<leader>"] = "SPC" },
  }

  -- Move to window using the <ctrl> movement keys
  -- util.nmap("<left>", "<C-w>h")
  -- util.nmap("<down>", "<C-w>j")
  -- util.nmap("<up>", "<C-w>k")
  -- util.nmap("<right>", "<C-w>l")

  -- Resize window using <ctrl> arrow keys
  util.nnoremap("<C-Up>", ":resize +2<CR>")
  util.nnoremap("<C-Down>", ":resize -2<CR>")
  util.nnoremap("<C-Left>", ":vertical resize -2<CR>")
  util.nnoremap("<C-Right>", ":vertical resize +2<CR>")

  -- Move Lines
  util.nnoremap("<A-j>", ":m .+1<CR>==")
  util.vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
  util.inoremap("<A-j>", "<Esc>:m .+1<CR>==gi")
  util.nnoremap("<A-k>", ":m .-2<CR>==")
  util.vnoremap("<A-k>", ":m '<-2<CR>gv=gv")
  util.inoremap("<A-k>", "<Esc>:m .-2<CR>==gi")

  -- Switch buffers with tab
  util.nnoremap("<C-Left>", ":bprevious<cr>")
  util.nnoremap("<C-Right>", ":bnext<cr>")

  -- Easier pasting
  util.nnoremap("[p", ":pu!<cr>")
  util.nnoremap("]p", ":pu<cr>")

  -- Clear search with <esc>
  util.map("", "<esc>", ":noh<cr>")
  util.nnoremap("gw", "*N")
  util.xnoremap("gw", "*N")

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  util.nnoremap("n", "'Nn'[v:searchforward]", { expr = true })
  util.xnoremap("n", "'Nn'[v:searchforward]", { expr = true })
  util.onoremap("n", "'Nn'[v:searchforward]", { expr = true })
  util.nnoremap("N", "'nN'[v:searchforward]", { expr = true })
  util.xnoremap("N", "'nN'[v:searchforward]", { expr = true })
  util.onoremap("N", "'nN'[v:searchforward]", { expr = true })

  -- open floating terminal
  util.nnoremap("<c-t>", "<cmd>ToggleTerm<cr>")

  -- markdown
  util.nnoremap("=t", "<cmd>TableFormat<cr>")

  -- better indenting
  util.vnoremap("<", "<gv")
  util.vnoremap(">", ">gv")

  -- makes * and # work on visual mode too.
  vim.api.nvim_exec(
    [[
function! g:VSetSearch(cmdtype)
let temp = @s
norm! gv"sy
let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
let @s = temp
endfunction

xnoremap * :<C-u>call g:VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call g:VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
]],
    false
  )

  local leader = {
    ["w"] = {
      name = "+windows",
      ["w"] = { "<C-W>p", "other-window" },
      ["d"] = { "<C-W>c", "delete-window" },
      ["-"] = { "<C-W>s", "split-window-below" },
      ["|"] = { "<C-W>v", "split-window-right" },
      ["2"] = { "<C-W>v", "layout-double-columns" },
      ["h"] = { "<C-W>h", "window-left" },
      ["j"] = { "<C-W>j", "window-below" },
      ["l"] = { "<C-W>l", "window-right" },
      ["k"] = { "<C-W>k", "window-up" },
      ["H"] = { "<C-W>5<", "expand-window-left" },
      ["J"] = { ":resize +5", "expand-window-below" },
      ["L"] = { "<C-W>5>", "expand-window-right" },
      ["K"] = { ":resize -5", "expand-window-up" },
      ["="] = { "<C-W>=", "balance-window" },
      ["s"] = { "<C-W>s", "split-window-below" },
      ["v"] = { "<C-W>v", "split-window-right" },
    },
    ["h"] = { '<cmd>let @/=""<CR>', "No Highlight" },
    c = { v = { "<cmd>Vista!!<CR>", "Vista" }, o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" } },
    b = {
      name = "+buffer",
      ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
      ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
      ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
      ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
      ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
      ["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
      ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
    },
    g = {
      name = "+git",
      -- g = { "<cmd>Neogit<CR>", "NeoGit" },
      g = {
        function()
          require("util").float_terminal "lazygit"
        end,
        "LazyGit",
      },
      c = { "<Cmd>Telescope git_commits<CR>", "commits" },
      b = { "<Cmd>Telescope git_branches<CR>", "branches" },
      s = { "<Cmd>Telescope git_status<CR>", "status" },
      d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
      h = { name = "+hunk" },
    },
    ["H"] = {
      name = "+help",
      t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
      c = { "<cmd>:Telescope commands<cr>", "Commands" },
      h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
      m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
      k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
      s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
      l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
      f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
      o = { "<cmd>:Telescope vim_options<cr>", "Options" },
      a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
      p = {
        name = "+packer",
        p = { "<cmd>PackerSync<cr>", "Sync" },
        s = { "<cmd>PackerStatus<cr>", "Status" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        c = { "<cmd>PackerCompile<cr>", "Compile" },
      },
    },
    e = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
    s = {
      name = "Search",
      b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
      c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      h = { "<cmd>Telescope help_tags<cr>", "Find Help" },
      M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
      R = { "<cmd>Telescope registers<cr>", "Registers" },
      t = { "<cmd>Telescope live_grep<cr>", "Text" },
      k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
      C = { "<cmd>Telescope commands<cr>", "Commands" },
      p = {
        "<cmd>lua require('telescope.builtin.internal').colorscheme({enable_preview = true})<cr>",
        "Colorscheme with Preview",
      },
      s = {
        function()
          require("telescope.builtin").lsp_document_symbols {
            symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
          }
        end,
        "Goto Symbol",
      },
      m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
      r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
    },
    ["f"] = { "<cmd>Telescope find_files<CR>", "Find File" },
    F = {
      name = "+file",
      u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
      f = { "<cmd>Telescope find_files<cr>", "Find File" },
      r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
      n = { "<cmd>enew<cr>", "New File" },
      z = "Zoxide",
      d = "Dot Files",
    },
    l = {
      name = "LSP",
      a = {
        '<cmd>lua require("telescope.builtin").lsp_code_actions(require("telescope.themes").get_dropdown({winblend = 10,border = true,previewer = false,shorten_path = false}))<cr>',
        "Code Action",
      },
      d = {
        "<cmd>Telescope lsp_document_diagnostics<cr>",
        "Document Diagnostics",
      },
      w = {
        "<cmd>Telescope lsp_workspace_diagnostics<cr>",
        "Workspace Diagnostics",
      },
      -- f = { "<cmd>silent FormatWrite<cr>", "Format" },
      f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
      i = { "<cmd>LspInfo<cr>", "Info" },
      j = {
        "<cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = 'single'}})<cr>",
        "Next Diagnostic",
      },
      k = {
        "<cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = 'single'}})<cr>",
        "Prev Diagnostic",
      },
      l = { "<cmd>silent lua require('lint').try_lint()<cr>", "Lint" },
      q = { "<cmd>Telescope quickfix<cr>", "Quickfix" },
      r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
      S = {
        "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
        "Workspace Symbols",
      },
    },
    o = {
      name = "+open",
      p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
      g = { "<cmd>Glow<cr>", "Markdown Glow" },
    },
    ["p"] = { "<cmd>lua require'telescope'.extensions.project.project{}<CR>", "Projects" },
    ["t"] = {
      name = "+Latex",
      c = { "<cmd>VimtexCompile<cr>", "Toggle Compilation Mode" },
      f = { "<cmd>call vimtex#fzf#run()<cr>", "Fzf Find" },
      i = { "<cmd>VimtexInfo<cr>", "Project Information" },
      s = { "<cmd>VimtexStop<cr>", "Stop Project Compilation" },
      t = { "<cmd>VimtexTocToggle<cr>", "Toggle Table Of Content" },
      v = { "<cmd>VimtexView<cr>", "View PDF" },
      b = { "<cmd>TexlabBuild<cr>", "Build with Texlab" },
      p = { "<cmd>TexlabForward<cr>", "Search with Texlab" },
    },
    T = {
      name = "toggle",
      f = {
        require("config.lsp.formatting").toggle,
        "Format on Save",
      },
      s = {
        function()
          util.toggle "spell"
        end,
        "Spelling",
      },
      w = {
        function()
          util.toggle "wrap"
        end,
        "Word Wrap",
      },
      n = {
        function()
          util.toggle("relativenumber", true)
          util.toggle "number"
        end,
        "Line Numbers",
      },
      t = { [[<Plug>PlenaryTestFile]], "Plenary Test" },
    },
    -- ["/"] = { "<Plug>kommentary_line_default<CR>", "Comment" },
    ["<tab>"] = {
      name = "workspace",
      ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },

      n = { "<cmd>tabnext<CR>", "Next" },
      d = { "<cmd>tabclose<CR>", "Close" },
      p = { "<cmd>tabprevious<CR>", "Previous" },
      ["]"] = { "<cmd>tabnext<CR>", "Next" },
      ["["] = { "<cmd>tabprevious<CR>", "Previous" },
      f = { "<cmd>tabfirst<CR>", "First" },
      l = { "<cmd>tablast<CR>", "Last" },
    },
    ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    [" "] = "Find File",
    ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
    [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
    -- ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
    [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
    q = {
      name = "+quit/session",
      q = { "<cmd>:qa<cr>", "Quit" },
      ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
      s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
      l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
      d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
    },
    x = {
      name = "+errors",
      x = { "<cmd>TroubleToggle<cr>", "Trouble" },
      w = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
      d = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
      t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
      T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
      l = { "<cmd>lopen<cr>", "Open Location List" },
      q = { "<cmd>copen<cr>", "Open Quickfix List" },
    },
    -- Z = { [[<cmd>lua require("zen-mode").reset()<cr>]], "Zen Mode" },
    z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
    D = {
      function()
        util.docs()
      end,
      "Create Docs from README.md",
    },
  }

  for i = 0, 10 do
    leader[tostring(i)] = "which_key_ignore"
  end

  wk.register(leader, { prefix = "<leader>" })

  wk.register { g = { name = "+goto", h = "Hop Word" }, s = "Hop Word1" }
end
