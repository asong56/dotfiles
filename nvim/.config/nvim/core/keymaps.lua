local map = function(mode, lhs, rhs, opts)
    opts = vim.tbl_extend("force", { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
end

-- ── Comfort ───────────────────────────────────────────────────────────
map("n", "<Esc>",      "<cmd>nohlsearch<CR>")         -- clear search highlight
map("i", "jk",         "<Esc>")                        -- fast escape
map("n", "U",          "<C-r>")                        -- redo with U
map("n", "Q",          "<nop>")                        -- disable Ex mode

-- ── Saving ────────────────────────────────────────────────────────────
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR><Esc>")    -- Ctrl-S to save

-- ── Cursor movement in wrapped lines ─────────────────────────────────
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- ── Navigation ────────────────────────────────────────────────────────
map("n", "<C-d>", "<C-d>zz")                           -- keep cursor centred while paging
map("n", "<C-u>", "<C-u>zz")
map("n", "n",     "nzzzv")                             -- keep search result centred
map("n", "N",     "Nzzzv")

-- ── Indenting in Visual mode ──────────────────────────────────────────
map("v", "<", "<gv")
map("v", ">", ">gv")

-- ── Move lines ────────────────────────────────────────────────────────
map("v", "<A-j>", ":m '>+1<CR>gv=gv")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")
map("n", "<A-j>", ":m .+1<CR>==")
map("n", "<A-k>", ":m .-2<CR>==")

-- ── Windows ───────────────────────────────────────────────────────────
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-Up>",    "<cmd>resize +2<CR>")
map("n", "<C-Down>",  "<cmd>resize -2<CR>")
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>")

-- ── Buffers ───────────────────────────────────────────────────────────
map("n", "<S-l>", "<cmd>bnext<CR>")
map("n", "<S-h>", "<cmd>bprev<CR>")
map("n", "<leader>bd", "<cmd>bdelete<CR>",     { desc = "Delete buffer" })

-- ── Quickfix ──────────────────────────────────────────────────────────
map("n", "<leader>qo", "<cmd>copen<CR>",  { desc = "Open quickfix" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix" })
map("n", "]q", "<cmd>cnext<CR>zz")
map("n", "[q", "<cmd>cprev<CR>zz")

-- ── Telescope (prefixed <leader>f) ───────────────────────────────────
-- (actual mappings are set in the telescope plugin spec)

-- ── LSP (set in on_attach, but shown here for discoverability) ────────
-- gd  = go to definition          K   = hover doc
-- gr  = go to references          <leader>ca = code action
-- gI  = go to implementation      <leader>rn = rename
-- [d  = prev diagnostic           ]d  = next diagnostic
