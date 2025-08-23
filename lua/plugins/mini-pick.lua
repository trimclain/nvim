-- pick anything
return {
    "echasnovski/mini.pick",
    cond = CONFIG.plugins.mini_pick,
    dependencies = {
        { "echasnovski/mini.extra", opts = true },
    },
    cmd = "Pick",
    keys = function()
        local Util = require("core.util")

        return {
            -- find files
            { "<C-p>", Util.pick_files(), desc = "Find Files (root dir)" },
            { "<leader>ff", "<cmd>Pick files<cr>", desc = "Find Files with preview" }, -- no extra

            -- find string
            { "<C-f>", "<cmd>Pick buf_lines<cr>", desc = "Fzf Buffer" },
            { "<leader>fs", "<cmd>Pick grep_live<cr>", desc = "String in Files" }, -- no extra
            -- TODO:
            -- { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
            -- { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Find WORD under cursor" },

            { "<leader>fh", "<cmd>Pick help<cr>", desc = "Help" }, -- no extra
            { "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Keymaps" },
            { "<leader>fr", "<cmd>Pick oldfiles<cr>", desc = "Recent Files" },
            { "<leader>fD", "<cmd>Pick diagnostic<cr>", desc = "Diagnostics" },
            { "<leader>:", "<cmd>Pick history<cr>", desc = "Command History" },
            { "<leader>fC", "<cmd>Pick commands<cr>", desc = "Commands" },
            { "<leader>fH", "<cmd>Pick hl_groups<cr>", desc = "Highlight Groups" },
            { "<leader>fl", "<cmd>Pick resume<cr>", desc = "Resume Last Search" }, -- no extra
            { "<leader>fR", "<cmd>Pick registers<cr>", desc = "Registers" },
            -- TODO: can this start it normal and allow to close?
            { "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers" }, -- no extra
            -- TODO: can I add preview?
            { "<leader>fc", "<cmd>Pick colorschemes<cr>", desc = "Colorscheme w/ preview" },

            -- git
            { "<leader>gb", "<cmd>Pick git_branches<cr>", desc = "branches" },
            { "<leader>gl", "<cmd>Pick git_commits<CR>", desc = "commits" },

            -- rebind from which-key
            { "z=", "<cmd>Pick spellsuggest<cr>", desc = "Spelling suggestions" },
        }
    end,
    opts = {
        -- Keys for performing actions. See `:h MiniPick-actions`.
        mappings = {
            move_down = "<Tab>", -- default: "<C-n>"
            move_up = "<S-Tab>", -- default: "<C-p>"
            toggle_info = "<C-_>", -- same as <C-/>; default: "<S-Tab>",
            toggle_preview = "<C-p>", -- default: "<Tab>",
        },
        -- Useful: `:h MiniPick-examples`
        window = {
            -- Centered on screen
            config = function()
                -- local height = math.floor(0.618 * vim.o.lines)
                -- local width = math.floor(0.618 * vim.o.columns)
                local height = math.floor(0.55 * vim.o.lines)
                local width = math.floor(0.65 * vim.o.columns)
                return {
                    anchor = "NW",
                    height = height,
                    width = width,
                    row = math.floor(0.5 * (vim.o.lines - height)),
                    col = math.floor(0.5 * (vim.o.columns - width)),
                }
            end,
        },
    },
}
