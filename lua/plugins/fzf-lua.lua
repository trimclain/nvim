-- fuzzy finder

return {
    "ibhagwan/fzf-lua",
    enabled = CONFIG.plugins.fzf_lua,
    cmd = "FzfLua",
    dependencies = { "nvim-web-devicons" },
    keys = function()
        local Util = require("core.util")

        return {
            -- find files
            -- stylua: ignore start
            { "<C-p>", Util.pick_files(), desc = "Find Files (root dir)" },
            { "<leader>ff", Util.pick_files({ theme = "default" }), desc = "Find Files with preview" },
            -- stylua: ignore end

            -- find string
            { "<C-f>", "<cmd>FzfLua lgrep_curbuf<cr>", desc = "Fzf Buffer" },
            { "<leader>fs", "<cmd>FzfLua live_grep<cr>", desc = "String in Files" },
            { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Find word under cursor" },
            { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "Find WORD under cursor" },

            {
                "<leader>fd",
                function()
                    require("fzf-lua").git_files({
                        -- Yup, why would $HOME on windows be $HOME and not $HOMEPATH or $USERPROFILE
                        cwd = _G.ON_INFERIOR_OS and vim.fs.joinpath(vim.env.HOMEPATH, "dotfiles")
                            or vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
                        winopts = { title = " Dotfiles " },
                    })
                end,
                desc = "Dotfiles",
            },

            -- find my projects
            { "<leader>fp", Util.open_project, desc = "Open [P]roject" },

            -- edit packages
            {
                "<leader>pe",
                Util.pick_files({ cwd = vim.fn.stdpath("data") .. "/lazy" }),
                desc = "Edit Plugins",
            },

            { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Help" },
            { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymaps" },
            { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent Files" },
            { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostics" },
            { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
            { "<leader>fC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
            { "<leader>fM", "<cmd>FzfLua manpages<cr>", desc = "Man Pages" },
            { "<leader>fH", "<cmd>FzfLua highlights<cr>", desc = "Highlight Groups" },
            -- TODO: worse than telescope, doesn't remember exact line position can I fix it?
            -- NOTE: impossible to fix -- maybe mini.pick fixes this
            { "<leader>fl", "<cmd>FzfLua resume<cr>", desc = "Resume Last Search" },
            { "<leader>fR", "<cmd>FzfLua registers<cr>", desc = "Registers" },
            { "<leader>fa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
            -- TODO: this needs work: start it normal, show current too, allow to close
            -- NOTE: can't do this fully similar, maybe mini.pick will have a solution
            { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffers" },
            { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix Items" },
            { "<leader>fc", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme w/ preview" },

            -- git
            { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "branches" },
            { "<leader>gl", "<cmd>FzfLua git_commits<CR>", desc = "commits" },

            -- rebind from which-key
            { "z=", "<cmd>FzfLua spell_suggest<cr>", desc = "Spelling suggestions" },
        }
    end,
    opts = function()
        local actions = require("fzf-lua.actions")

        -- Docs: https://github.com/ibhagwan/fzf-lua#customization
        return {
            winopts = {
                title_flags = false, -- don't show "h", "i", "f" if the flags are set
                -- height = 0.85,
                -- width = 0.80,
                row = 0.5, -- default: 0.35 (0 - top, 1 - bottom)
                -- col = 0.55, -- (0 - left, 1 - right)
                preview = {
                    layout = "horizontal",
                },
            },
            keymap = {
                builtin = {
                    ["<C-_>"] = "toggle-help", -- keys from pressing <C-/> in tmux
                    ["<C-a>"] = "toggle-fullscreen",
                    ["<C-p>"] = "toggle-preview",
                    ["<C-f>"] = "preview-page-down",
                    ["<C-b>"] = "preview-page-up",
                },
                fzf = {
                    -- fzf '--bind=' options
                    ["tab"] = "down",
                    ["btab"] = "up",
                    ["ctrl-j"] = "toggle-down",
                    ["ctrl-k"] = "toggle-up",
                    ["ctrl-q"] = "select-all+accept", -- together with ["enter"] action sends all to qf
                },
            },
            actions = {
                files = {
                    -- Pickers inheriting these actions:
                    --   files, git_files, git_status, grep, lsp, oldfiles, quickfix, loclist,
                    --   tags, btags, args, buffers, tabs, lines, blines
                    ["enter"] = actions.file_edit_or_qf, -- or actions.file_switch_or_edit
                    ["ctrl-s"] = actions.file_split,
                    ["ctrl-v"] = actions.file_vsplit,
                    -- ["ctrl-t"] = actions.file_tabedit,
                    -- ["alt-i"] = actions.toggle_ignore,
                    -- ["ctrl-q"]  = actions.file_sel_to_qf, -- using the one above
                    -- TODO: hidden icon should be modifable. Create a PR or an issue.
                    ["ctrl-h"] = actions.toggle_hidden, -- default: ["alt-h"]
                    -- ["alt-f"] = actions.toggle_follow,
                },
                -- grep = {
                --     actions = { ["ctrl-g"] = { actions.grep_lgrep } }, --  default: toggle fuzzy search
                -- },
            },
            fzf_opts = {
                ["--cycle"] = true,
                -- ["--layout"] = "reverse-list", -- telescope-like
            },
            fzf_colors = true, -- apply colorscheme
            -- Picker Options:
            defaults = {
                git_icons = false,
                cwd_header = false, -- hide
                no_header = true, --   all
                no_header_i = true, -- headers
            },
            files = { previewer = false, winopts = { height = 0.55, width = 0.65 } },
            git = { files = { previewer = false, winopts = { height = 0.55, width = 0.65 } } },
            keymaps = { winopts = { preview = { hidden = "hidden" } } },
            lsp = { symbols = { symbol_icons = require("core.icons").kinds } },
            oldfiles = { winopts = { preview = { hidden = "hidden" }, height = 0.55, width = 0.65 } },
            buffers = {
                winopts = {
                    preview = { hidden = "hidden" },
                    height = 0.55,
                    width = 0.65,
                },
                -- Docs: fzf-lua/lua/fzf-lua/profiles/telescope.lua
                keymap = { builtin = { ["<C-d>"] = false } },
                actions = { ["ctrl-x"] = false, ["ctrl-d"] = { actions.buf_del, actions.resume } },
            },
            grep_curbuf = { winopts = { preview = { hidden = "hidden" }, height = 0.55, width = 0.65 } },
            helptags = { winopts = { preview = { hidden = "hidden", horizontal = "right:70%" } } },
        }
    end,
}
