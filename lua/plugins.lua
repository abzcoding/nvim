local packer = require "util.packer"

local config = {
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    open_fn = function()
      return require("packer.util").float { border = "single" }
    end,
  },
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {
    -- folke = true,
    -- ["nvim-compe"] = false,
    -- ["null-ls.nvim"] = false,
    -- ["nvim-lspconfig"] = false,
    -- ["nvim-treesitter"] = true,
  },
}

local function plugins(use)
  use { "lewis6991/impatient.nvim", rocks = "mpack" }
  -- Packer can manage itself as an optional plugin
  use { "wbthomason/packer.nvim", opt = true }
  -- use({ "folke/workspace.nvim" })
  -- LSP
  use {
    "neovim/nvim-lspconfig",
    opt = true,
    -- event = "BufReadPre",
    wants = { "nvim-lsp-ts-utils", "null-ls.nvim", "lua-dev.nvim" },
    config = function()
      require "config.lsp"
    end,
    requires = {
      -- "folke/workspace.nvim",
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/lua-dev.nvim",
    },
  }

  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("config.cmp").config()
    end,
    wants = { "LuaSnip" },
    requires = {
      {
        "L3MON4D3/LuaSnip",
        event = "BufReadPre",
        wants = "friendly-snippets",
        config = function()
          require "config.snippets"
        end,
      },
      "rafamadriz/friendly-snippets",
      {
        "windwp/nvim-autopairs",
        event = "BufReadPre",
        config = function()
          require "config.autopairs"
        end,
      },
    },
  } -- Autocompletion plugin

  use { "hrsh7th/cmp-path", after = "nvim-cmp" }
  use { "hrsh7th/cmp-buffer", after = "nvim-cmp" }
  use { "hrsh7th/cmp-calc", after = "nvim-cmp" }
  -- use { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" }
  use { "hrsh7th/cmp-emoji", after = "nvim-cmp" }
  use { "hrsh7th/cmp-nvim-lsp", after = "nvim-cmp" }
  use { "saadparwaiz1/cmp_luasnip", after = "nvim-cmp" }
  use {
    "kdheepak/cmp-latex-symbols",
    after = "nvim-cmp",
    ft = "latex",
    requires = {
      { "kdheepak/cmp-latex-symbols" },
    },
  }

  use {
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
  }

  use {
    "b3nj5m1n/kommentary",
    opt = true,
    wants = "nvim-ts-context-commentstring",
    keys = { "gc", "gcc", "<Space>/" },
    config = function()
      require "config.comments"
    end,
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
  }

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opt = true,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = [[require('config.treesitter')]],
  }

  -- Theme: color schemes
  -- use("tjdevries/colorbuddy.vim")
  use {
    -- "shaunsingh/nord.nvim",
    -- "shaunsingh/moonlight.nvim",
    -- { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" },
    -- "joshdick/onedark.vim",
    -- "wadackel/vim-dogrun",
    -- { "npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim" },
    -- "bluz71/vim-nightfly-guicolors",
    -- { "marko-cerovac/material.nvim" },
    -- "sainnhe/edge",
    -- { "embark-theme/vim", as = "embark" },
    -- "norcalli/nvim-base16.lua",
    -- "RRethy/nvim-base16",
    -- "novakne/kosmikoa.nvim",
    -- "glepnir/zephyr-nvim",
    -- "ghifarit53/tokyonight-vim"
    -- "sainnhe/sonokai",
    -- "morhetz/gruvbox",
    -- "arcticicestudio/nord-vim",
    -- "drewtempelmeyer/palenight.vim",
    -- "Th3Whit3Wolf/onebuddy",
    -- "christianchiarulli/nvcode-color-schemes.vim",
    -- "Th3Whit3Wolf/one-nvim"

    "folke/tokyonight.nvim",
    -- event = "VimEnter",
    config = function()
      require "config.theme"
      local _time = os.date "*t"
      if _time.hour < 9 then
        vim.g.tokyonight_style = "night"
      end
      require("tokyonight").colorscheme()
    end,
    -- cond = function()
    --   local _time = os.date "*t"
    --   return (_time.hour >= 0 and _time.hour < 16)
    -- end,
  }
  -- use {
  --   "NTBBloodbath/doom-one.nvim",
  --   config = function()
  --     vim.g.doom_one_italic_comments = true
  --     vim.cmd [[
  --     colorscheme doom-one
  --     ]]
  --     -- vim.g.doom_one_terminal_colors = true
  --   end,
  --   cond = function()
  --     local _time = os.date "*t"
  --     return (_time.hour >= 16 and _time.hour < 20)
  --   end,
  -- }
  -- use {
  --   "glepnir/zephyr-nvim",
  --   config = function()
  --     vim.cmd [[
  --     colorscheme zephyr
  --     ]]
  --   end,
  --   cond = function()
  --     local _time = os.date "*t"
  --     return (_time.hour >= 20 and _time.hour <= 24)
  --   end,
  -- }

  -- Theme: icons
  use {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  }

  -- Dashboard
  -- use { "glepnir/dashboard-nvim", config = [[require('config.dashboard')]] }

  use {
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  }
  use { "nvim-lua/plenary.nvim", opt = true, module = "plenary" }
  use { "nvim-lua/popup.nvim", opt = true, module = "popup" }

  use {
    "windwp/nvim-spectre",
    opt = true,
    module = "spectre",
    wants = { "plenary.nvim", "popup.nvim" },
    requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  }

  use {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    config = function()
      require "config.tree"
    end,
  }

  -- Fuzzy finder
  use {
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require "config.telescope"
    end,
    cmd = { "Telescope" },
    module = "telescope",
    keys = { "<leader><space>", "<leader>f", "<leader>p" },
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-z.nvim",
      -- "telescope-frecency.nvim",
      "telescope-fzy-native.nvim",
      "telescope-project.nvim",
      "trouble.nvim",
      "telescope-symbols.nvim",
    },
    requires = {
      "nvim-telescope/telescope-z.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      -- { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim" }
    },
  }

  -- Indent Guides and rainbow brackets

  use {
    "lukas-reineke/indent-blankline.nvim",
    setup = function()
      require("config.blankline").setup()
    end,
    event = "BufRead",
  }

  -- Tabs
  use {
    "akinsho/nvim-bufferline.lua",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    config = function()
      require "config.bufferline"
    end,
  }

  -- Terminal
  use {
    "akinsho/nvim-toggleterm.lua",
    -- event = "BufWinEnter",
    opt = true,
    config = function()
      require "config.terminal"
    end,
  }

  -- Smooth Scrolling
  use {
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = function()
      require "config.scroll"
    end,
  }
  use {
    "edluffy/specs.nvim",
    after = "neoscroll.nvim",
    config = function()
      require "config.specs"
    end,
  }
  -- use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }

  -- Git Gutter
  use {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require "config.gitsigns"
    end,
  }
  use {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    config = function()
      vim.g.lazygit_floating_window_use_plenary = 0
    end,
  }
  -- use {
  --   "TimUntersberger/neogit",
  --   cmd = "Neogit",
  --   config = function()
  --     require "config.neogit"
  --   end,
  -- }

  -- Statusline
  use {
    "shadmansaleh/lualine.nvim",
    event = "BufReadPre",
    config = [[require('config.lualine')]],
    wants = "nvim-web-devicons",
  }

  use {
    "norcalli/nvim-colorizer.lua",
    -- event = "BufReadPre",
    opt = true,
    config = function()
      require "config.colorizer"
    end,
  }

  use { "npxbr/glow.nvim", cmd = "Glow" }

  use {
    "plasticboy/vim-markdown",
    opt = true,
    requires = "godlygeek/tabular",
    ft = "markdown",
  }
  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  }

  -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

  -- use({ "wfxr/minimap.vim", config = function()
  --   require("config.minimap")
  -- end })

  use {
    "phaazon/hop.nvim",
    keys = { "gh" },
    cmd = { "HopWord", "HopChar1" },
    config = function()
      require("util").nmap("gh", "<cmd>HopWord<CR>")
      -- require("util").nmap("s", "<cmd>HopChar1<CR>")
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup {}
    end,
  }

  use {
    "ggandor/lightspeed.nvim",
    -- event = "BufReadPost",
    opt = true,
    config = require "config.lightspeed",
  }

  use {
    "folke/trouble.nvim",
    -- event = "BufReadPre",
    opt = true,
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup { auto_open = false }
    end,
  }

  use {
    "folke/persistence.nvim",
    event = "BufReadPre",
    module = "persistence",
    config = function()
      require("persistence").setup()
    end,
  }

  use { "tweekmonster/startuptime.vim", cmd = "StartupTime" }

  use { "mbbill/undotree", cmd = "UndotreeToggle" }

  use { "mjlbach/babelfish.nvim", module = "babelfish" }

  use {
    "folke/zen-mode.nvim",
    cmd = "ZenMode",
    opt = true,
    wants = "twilight.nvim",
    requires = { "folke/twilight.nvim" },
    config = function()
      require("zen-mode").setup {
        plugins = { gitsigns = true, tmux = true, kitty = { enabled = false, font = "+2" } },
      }
    end,
  }

  use {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    -- event = "BufReadPost",
    opt = true,
    config = require "config.todo",
  }

  use {
    "folke/which-key.nvim",
    opt = true,
    -- event = "VimEnter",
    config = require "config.keys",
  }

  use {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      require "config.diffview"
    end,
  }

  use {
    "RRethy/vim-illuminate",
    event = "CursorHold",
    module = "illuminate",
    config = function()
      vim.g.Illuminate_delay = 1000
    end,
  }

  -- use({ "wellle/targets.vim" })

  -- use("DanilaMihailov/vim-tips-wiki")
  -- use "nanotee/luv-vimdocs"
  use {
    "andymass/vim-matchup",
    -- event = "CursorMoved",
    opt = true,
  }
  use { "camspiers/snap", rocks = { "fzy" }, module = "snap" }
  -- use "kmonad/kmonad-vim"
  use {
    "simrat39/rust-tools.nvim",
    config = function()
      local opts = {
        tools = { -- rust-tools options
          -- automatically set inlay hints (type hints)
          -- There is an issue due to which the hints are not applied on the first
          -- opened file. For now, write to the file to trigger a reapplication of
          -- the hints or just run :RustSetInlayHints.
          -- default: true
          autoSetHints = true,

          -- whether to show hover actions inside the hover window
          -- this overrides the default hover handler
          -- default: true
          hover_with_actions = true,

          runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true,

            -- rest of the opts are forwarded to telescope
          },

          inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<-",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix = "=>",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,
          },

          hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              { "╭", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╮", "FloatBorder" },
              { "│", "FloatBorder" },
              { "╯", "FloatBorder" },
              { "─", "FloatBorder" },
              { "╰", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },

        -- all the opts to send to nvim-lspconfig
        -- these override the defaults set by rust-tools.nvim
        -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
        server = {

          cmd = { vim.fn.stdpath "data" .. "/lspinstall/rust/rust-analyzer" },
        }, -- rust-analyser options
      }
      require("rust-tools").setup(opts)
      vim.api.nvim_exec(
        [[
    autocmd Filetype rust nnoremap <leader>lm <Cmd>RustExpandMacro<CR>
    autocmd Filetype rust nnoremap <leader>lH <Cmd>RustToggleInlayHints<CR>
    autocmd Filetype rust nnoremap <leader>le <Cmd>RustRunnables<CR>
    autocmd Filetype rust nnoremap <leader>lh <Cmd>RustHoverActions<CR>
    ]],
        true
      )
    end,
    ft = { "rust", "rs" },
  }
end

return packer.setup(config, plugins)
