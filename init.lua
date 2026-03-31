-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)
vim.opt.runtimepath:append("~/.local/share/nvim/treesitter-parsers")
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.opt_local.autoindent = true
        vim.opt_local.smartindent = true
        vim.treesitter.start()
    end,
})

-- Options
vim.g.mapleader = " " -- leader should be set before lazy
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true
vim.opt.autoindent = true

-- Plugins
require("lazy").setup({
    "neovim/nvim-lspconfig",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000, -- load before other plugins
        config = function()
            vim.cmd("colorscheme tokyonight")
        end,
    },
    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup()
            vim.keymap.set('n', '-', ':Oil<CR>')
        end,
    },

    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup()
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            ls.add_snippets("php", {
                s("deb", {
                    t("$this->logger->debug("),
                    i(1),
                    t(");"),
                }),
            })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        config = function()
            local ls = require("luasnip")
            local s = ls.snippet
            local t = ls.text_node
            local i = ls.insert_node

            ls.add_snippets("php", {
                s("deb", {
                    t("$this->logger->debug("),
                    i(1),
                    t(");"),
                }),
            })
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup()
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
        end,
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",     -- LSP completions
            "hrsh7th/cmp-buffer",       -- words from current buffer
            "hrsh7th/cmp-path",         -- file paths
            "saadparwaiz1/cmp_luasnip", -- add this
            "L3MON4D3/LuaSnip",         -- and this
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-k>"] = cmp.mapping(function()
                        if require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        end
                    end, { "i", "s" }),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" }, -- add this
                    { name = "buffer" },
                    { name = "path" },
                },
            })
        end,
    },

    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    php = { "pint" },
                    typescript = { "prettier" },
                    typescriptreact = { "prettier" },
                },
                format_on_save = {
                    timeout_ms = 2000,
                    lsp_fallback = true,
                },
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        config = function()
            require("nvim-treesitter.config").setup({
                highlight = { enable = true },
                indent = { enable = true },
                auto_install = true,
                ensure_installed = { "php", "typescript", "tsx", "c_sharp", "lua" },
            })
        end,
    },

})

-- Mason
vim.env.PATH = vim.env.PATH .. ":/Users/andersandersen/.local/share/nvim/mason/bin"

-- LSP
vim.lsp.config("intelephense", {})
vim.lsp.config("ts_ls", {})
vim.lsp.config("omnisharp", {})
vim.lsp.config("lua_ls", {
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }, -- stops lua_ls complaining that 'vim' is undefined
            },
        },
    },
})

require("oil").setup({
    keymaps = {
        ["q"] = "actions.close",
    },
})

vim.lsp.enable({ "intelephense", "ts_ls", "omnisharp", "lua_ls" })

-- Keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>h', ':noh<CR>')

vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
