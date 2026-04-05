-- All plugins in one file. Each spec is self-contained.
-- lazy.nvim picks up everything returned from this file.

return {

    -- ── Colorscheme ─────────────────────────────────────────────────
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,
        opts = {
            flavour             = "mocha",
            transparent_background = false,
            integrations = {
                cmp        = true,
                gitsigns   = true,
                telescope  = { enabled = true },
                treesitter = true,
                which_key  = true,
                mini       = { enabled = true },
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },

    -- ── UI: statusline ──────────────────────────────────────────────
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {
            options = {
                theme           = "catppuccin",
                component_separators = "|",
                section_separators = { left = "", right = "" },
                globalstatus    = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- ── UI: key hint popup ──────────────────────────────────────────
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            win  = { border = "rounded" },
            spec = {
                { "<leader>f",  group = "find" },
                { "<leader>g",  group = "git"  },
                { "<leader>l",  group = "lsp"  },
                { "<leader>b",  group = "buffer" },
                { "<leader>q",  group = "quickfix" },
            },
        },
    },

    -- ── Treesitter: syntax + text objects ────────────────────────────
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash", "css", "html", "javascript", "json",
                    "lua", "markdown", "markdown_inline", "python",
                    "rust", "scss", "toml", "typescript", "yaml",
                },
                highlight = { enable = true },
                indent    = { enable = true },
                textobjects = {
                    select = {
                        enable    = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                    },
                    move = {
                        enable              = true,
                        set_jumps           = true,
                        goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    },
                },
            })
        end,
    },

    -- ── Telescope: fuzzy finder ──────────────────────────────────────
    {
        "nvim-telescope/telescope.nvim",
        branch = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        cmd = "Telescope",
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<CR>",              desc = "Find files" },
            { "<leader>fg", "<cmd>Telescope live_grep<CR>",               desc = "Live grep" },
            { "<leader>fb", "<cmd>Telescope buffers<CR>",                 desc = "Buffers" },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>",               desc = "Help tags" },
            { "<leader>fo", "<cmd>Telescope oldfiles<CR>",                desc = "Recent files" },
            { "<leader>fr", "<cmd>Telescope lsp_references<CR>",          desc = "References" },
            { "<leader>fd", "<cmd>Telescope diagnostics<CR>",             desc = "Diagnostics" },
            { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",    desc = "Symbols" },
            { "<leader>gc", "<cmd>Telescope git_commits<CR>",             desc = "Git commits" },
            { "<leader>gb", "<cmd>Telescope git_branches<CR>",            desc = "Git branches" },
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")
            telescope.setup({
                defaults = {
                    prompt_prefix = "  ",
                    selection_caret = " ",
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        },
                    },
                    file_ignore_patterns = { "node_modules", ".git/", "dist/", "target/" },
                },
                pickers = {
                    find_files = { hidden = true },
                },
            })
            telescope.load_extension("fzf")
        end,
    },

    -- ── LSP: mason + lspconfig ───────────────────────────────────────
    {
        "williamboman/mason.nvim",
        cmd  = "Mason",
        opts = { ui = { border = "rounded" } },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls",        -- Lua
                "ts_ls",         -- TypeScript / JavaScript
                "html",          -- HTML
                "cssls",         -- CSS
                "pyright",       -- Python
                "rust_analyzer", -- Rust
                "jsonls",        -- JSON
                "yamlls",        -- YAML
            },
            automatic_installation = true,
        },
        config = function(_, opts)
            require("mason-lspconfig").setup(opts)

            local lspconfig = require("lspconfig")
            local caps = vim.tbl_deep_extend(
                "force",
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities()
            )

            local on_attach = function(_, bufnr)
                local bmap = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
                end
                bmap("n", "gd",          vim.lsp.buf.definition,      "Go to definition")
                bmap("n", "gD",          vim.lsp.buf.declaration,     "Go to declaration")
                bmap("n", "gI",          vim.lsp.buf.implementation,  "Go to implementation")
                bmap("n", "gr",          vim.lsp.buf.references,      "References")
                bmap("n", "K",           vim.lsp.buf.hover,           "Hover doc")
                bmap("n", "<leader>lk",  vim.lsp.buf.signature_help,  "Signature help")
                bmap("n", "<leader>rn",  vim.lsp.buf.rename,          "Rename")
                bmap("n", "<leader>ca",  vim.lsp.buf.code_action,     "Code action")
                bmap("n", "<leader>ld",  vim.diagnostic.open_float,   "Line diagnostics")
                bmap("n", "]d",          vim.diagnostic.goto_next,    "Next diagnostic")
                bmap("n", "[d",          vim.diagnostic.goto_prev,    "Prev diagnostic")
            end

            -- Server-specific settings
            local server_settings = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            workspace   = { checkThirdParty = false },
                            telemetry   = { enable = false },
                        },
                    },
                },
            }

            require("mason-lspconfig").setup_handlers({
                function(server)
                    lspconfig[server].setup(vim.tbl_deep_extend("force", {
                        on_attach    = on_attach,
                        capabilities = caps,
                    }, server_settings[server] or {}))
                end,
            })
        end,
    },

    -- ── Completion ───────────────────────────────────────────────────
    {
        "hrsh7th/nvim-cmp",
        event        = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp     = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"]     = cmp.mapping.select_next_item(),
                    ["<C-p>"]     = cmp.mapping.select_prev_item(),
                    ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible()              then cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
                        else fallback() end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible()             then cmp.select_prev_item()
                        elseif luasnip.jumpable(-1)  then luasnip.jump(-1)
                        else fallback() end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip",  priority = 750  },
                    { name = "buffer",   priority = 500  },
                    { name = "path",     priority = 250  },
                }),
                window = {
                    completion    = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = function(entry, item)
                        local icons = {
                            Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
                            Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
                            Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
                            Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                            File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
                            Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
                            TypeParameter = "",
                        }
                        item.kind = string.format("%s %s", icons[item.kind] or "", item.kind)
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip  = "[Snip]",
                            buffer   = "[Buf]",
                            path     = "[Path]",
                        })[entry.source.name]
                        return item
                    end,
                },
            })
        end,
    },

    -- ── Formatting ───────────────────────────────────────────────────
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd   = "ConformInfo",
        keys  = {
            { "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
        },
        opts = {
            formatters_by_ft = {
                lua        = { "stylua" },
                python     = { "ruff_format", "isort" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                css        = { "prettier" },
                scss       = { "prettier" },
                html       = { "prettier" },
                json       = { "prettier" },
                markdown   = { "prettier" },
                rust       = { "rustfmt" },
                sh         = { "shfmt" },
            },
            format_on_save = {
                timeout_ms = 1000,
                lsp_format = "fallback",
            },
        },
    },

    -- ── Git decorations ──────────────────────────────────────────────
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys  = {
            { "<leader>gs", "<cmd>Gitsigns stage_hunk<CR>",      desc = "Stage hunk" },
            { "<leader>gr", "<cmd>Gitsigns reset_hunk<CR>",      desc = "Reset hunk" },
            { "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>",    desc = "Preview hunk" },
            { "<leader>gb", "<cmd>Gitsigns blame_line<CR>",      desc = "Blame line" },
            { "]h",         "<cmd>Gitsigns next_hunk<CR>",       desc = "Next hunk" },
            { "[h",         "<cmd>Gitsigns prev_hunk<CR>",       desc = "Prev hunk" },
        },
        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
                untracked    = { text = "▎" },
            },
        },
    },

    -- ── File explorer (oil: edit filesystem like a buffer) ───────────
    {
        "stevearc/oil.nvim",
        lazy = false,
        keys = {
            { "-", "<cmd>Oil<CR>", desc = "Open parent directory" },
        },
        opts = {
            view_options = { show_hidden = true },
            float = { padding = 2, border = "rounded" },
        },
    },

    -- ── Mini: pairs, surround, ai text objects ───────────────────────
    {
        "echasnovski/mini.nvim",
        version = "*",
        config = function()
            require("mini.pairs").setup()      -- auto-close brackets/quotes
            require("mini.surround").setup()   -- sa/sd/sr: add/delete/replace surrounds
            require("mini.comment").setup()    -- gc: toggle comment
            require("mini.ai").setup()         -- extra text objects: a/i for f,c,a,t,...
        end,
    },

    -- ── Trouble: pretty diagnostics panel ───────────────────────────
    {
        "folke/trouble.nvim",
        cmd  = "Trouble",
        keys = {
            { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Diagnostics" },
            { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
            { "<leader>xl", "<cmd>Trouble lsp_lines toggle<CR>",                desc = "LSP lines" },
        },
        opts = { use_diagnostic_signs = true },
    },

    -- ── todo-comments: highlight TODO/FIXME/HACK ─────────────────────
    {
        "folke/todo-comments.nvim",
        event        = { "BufReadPost", "BufNewFile" },
        dependencies = "nvim-lua/plenary.nvim",
        keys = {
            { "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find TODOs" },
        },
        opts = {},
    },

}
