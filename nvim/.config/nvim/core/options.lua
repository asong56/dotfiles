local o = vim.opt

-- ── Appearance ────────────────────────────────────────────────────────
o.number         = true
o.relativenumber = true
o.signcolumn     = "yes"           -- always show sign column (no layout shift)
o.cursorline     = true
o.termguicolors  = true
o.scrolloff      = 8               -- keep 8 lines above/below cursor
o.sidescrolloff  = 8
o.wrap           = false
o.linebreak      = true            -- if wrap is on, break at word boundaries
o.showmode       = false           -- lualine shows the mode already
o.cmdheight      = 1

-- ── Indentation ───────────────────────────────────────────────────────
o.tabstop     = 4
o.shiftwidth  = 4
o.softtabstop = 4
o.expandtab   = true
o.smartindent = true
o.shiftround  = true               -- round indent to multiple of shiftwidth

-- ── Search ────────────────────────────────────────────────────────────
o.ignorecase = true
o.smartcase  = true                -- override ignorecase when uppercase present
o.hlsearch   = false               -- don't persist highlight after searching
o.incsearch  = true

-- ── Files ─────────────────────────────────────────────────────────────
o.undofile     = true              -- persist undo history across sessions
o.swapfile     = false
o.backup       = false
o.updatetime   = 250               -- faster CursorHold events (used by LSP)
o.timeoutlen   = 300               -- faster which-key popup

-- ── Splits ────────────────────────────────────────────────────────────
o.splitbelow = true
o.splitright = true

-- ── Completion ────────────────────────────────────────────────────────
o.completeopt = { "menuone", "noselect", "noinsert" }
o.pumheight   = 10

-- ── Clipboard ─────────────────────────────────────────────────────────
o.clipboard = "unnamedplus"        -- sync with system clipboard

-- ── Misc ──────────────────────────────────────────────────────────────
o.mouse          = "a"
o.conceallevel   = 1               -- hide markup (useful for Markdown/Obsidian)
o.isfname:append("@-@")            -- treat @ as valid filename char
o.shortmess:append("c")            -- suppress "match x of y" completion messages
