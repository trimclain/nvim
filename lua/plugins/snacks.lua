local Util = require("core.util")

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function(_, opts)
        local Icons = require("core.icons")

        -- `vim.ui.input`
        opts.input = {}

        -- picker and `vim.ui.select`
        opts.picker = {
            ui_select = true,
            sources = {
                lines = {
                    matcher = {
                        fuzzy = false, -- default: true
                        smartcase = true,
                        ignorecase = true,
                    },
                    layout = {
                        preview = false, -- default: "main"
                        preset = "select", -- default: "ivy"
                    },
                },
                buffers = {
                    focus = "list", -- default: "input"
                    layout = {
                        preset = "select",
                    },
                },
            },
            win = {
                -- input window
                input = {
                    keys = {
                        ["<C-_>"] = { "toggle_help_list", mode = { "i", "n" } }, -- keys from pressing <C-/> in tmux
                        ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                        ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                        ["<C-j>"] = { "select_and_next", mode = { "i", "n" } },
                        ["<C-k>"] = { "select_and_prev", mode = { "i", "n" } },
                        ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                        ["<C-a>"] = { "toggle_maximize", mode = { "i", "n" } },
                        -- ["<C-p>"] = { "toggle_preview", mode = { "i", "n" } },
                        ["<C-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
                        ["<C-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
                        ["<C-g>"] = { "toggle_live", mode = { "i", "n" } }, -- toggle live_grep
                        -- Defaults:
                        -- ["<a-w>"] = "cycle_win",
                    },
                },
                -- result list window
                list = {
                    keys = {
                        ["<C-c>"] = { "cancel" },
                        ["<C-_>"] = { "toggle_help_list", mode = { "i", "n" } }, -- keys from pressing <C-/> in tmux
                        ["<Tab>"] = { "list_down", mode = { "n", "x" } },
                        ["<S-Tab>"] = { "list_up", mode = { "n", "x" } },
                        ["<C-j>"] = { "select_and_next" },
                        ["<C-k>"] = { "select_and_prev" },
                        ["<C-h>"] = { "toggle_hidden", mode = { "i", "n" } },
                        ["<C-a>"] = { "toggle_maximize", mode = { "i", "n" } },
                        ["a"] = "focus_input",
                        -- Defaults:
                        -- ["i"] = "focus_input",
                        -- ["<a-w>"] = "cycle_win",
                    },
                },
                -- preview window
                preview = {
                    keys = {
                        ["<C-c>"] = { "cancel" },
                        ["a"] = "focus_input",
                        -- Defaults:
                        -- ["i"] = "focus_input",
                        -- ["<a-w>"] = "cycle_win",
                    },
                },
            },
        }

        -- before: <mark, sign, fold, git>, line_number
        -- after: <mark, sign> <line_number> <fold, git>
        opts.statuscolumn = {
            left = { "sign" }, -- default: { "mark", "sign" }
            right = { "fold", "git" },
            folds = { open = true }, -- default: { open = false }
        }

        -- dashboard at UIEnter
        opts.dashboard = {
            enabled = true,
            width = 50,
            preset = {
                -- stylua: ignore
                keys = {
                    { icon = Icons.ui.Search, key = "f", desc = "Find File", action = "<leader>ff" },
                    -- { icon = Icons.kinds.File, key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = Icons.ui.Files, key = "r", desc = "Recent Files", action = "<leader>fr" },
                    { icon = Icons.ui.List, key = "s", desc = "Find Text", action = "<leader>fs" },
                    { icon = Icons.ui.BoxChecked, key = "t", desc = "Find Todo", action = "<leader>ft" },
                    { icon = Icons.ui.Gear, key = "c", desc = "Config", action = "<leader>fn" },
                    { icon = Icons.ui.Lazy, key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                    { icon = Icons.ui.SignOut, key = "q", desc = "Quit", action = ":qa" },
                },
            },
            -- "doom" example (default)
            sections = {
                -- TODO: header padding 2 moves the header too high up on smaller displays. Can I fix it or make it dynamic?
                { section = "header", padding = 2 }, -- default: padding = 2
                { section = "keys", gap = 1, padding = 1 },
                { section = "startup" },
            },
        }

        -- Disabled: adds 12-15 ms to startup time
        -- Show git status if in git repo
        -- if Util.in_git_worktree() then
        --     table.insert(
        --         opts.dashboard.preset.keys,
        --         5,
        --         { action = "Neogit", desc = " Git status", icon = " ", key = "g" }
        --     )
        -- end

        -- BROKEN: no env available
        -- Since I don't have tmux in neovide, add a project manager to dashboard
        -- if vim.g.neovide == true then
        --     table.insert(
        --         opts.dashboard.preset.keys,
        --         2,
        --         { icon = Icons.ui.GitFolder, key = "p", desc = "Open Project", action = "<leader>fp" }
        --     )
        -- end

        return opts
    end,
    keys = function()
        if not CONFIG.plugins.snacks_picker then
            return {}
        end

        -- stylua: ignore
        return {
            -- find files
            { "<C-p>", Util.pick("find_files"), desc = "Find Files" },
            { "<leader>ff", function() require("snacks").picker.files({ hidden = true }) end, desc = "Files with preview" },

            -- find string
            { "<C-f>", function() require("snacks").picker.lines() end, desc = "Fzf Buffer" },
            { "<leader>fs", function() require("snacks").picker.grep() end, desc = "String in Files" },
            { "<leader>fw", function() require("snacks").picker.grep_word() end, desc = "Visual selection or <cword>", mode = { "n", "x" } },

            -- find my dotfiles
            {
                "<leader>fd",
                Util.pick(
                    "git_files",
                    -- Yup, why would $HOME on windows be $HOME and not $HOMEPATH or $USERPROFILE
                    {
                        cwd = _G.ON_INFERIOR_OS and vim.fs.joinpath(vim.env.HOMEPATH, "dotfiles")
                            or vim.fs.joinpath(vim.env.HOME, ".dotfiles"),
                        title = "Dotfiles",
                    }
                ),
                desc = "Dotfiles",
            },
            -- find my neovim config (since it's separate from dotfiles)
            {
                "<leader>fn",
                Util.pick("find_files", { cwd = vim.fn.stdpath("config"), title = "Neovim Config" }),
                desc = "Neovim Config",
            },

            -- find my projects
            { "<leader>fp", Util.open_project, desc = "Open [P]roject" },

            -- Plugins
            { "<leader>fP", function() require("snacks").picker.lazy() end, desc = "Plugin Spec" },
            { "<leader>pe", Util.pick("files", { cwd = vim.fn.stdpath("data") .. "/lazy" }), desc = "Edit Plugins" },

            -- Used Often
            { "<leader>fh", function() require("snacks").picker.help() end, desc = "Help Pages" },
            { "<leader>fk", function() require("snacks").picker.keymaps() end, desc = "Keymaps" },
            { "<leader>fr", function() require("snacks").picker.recent() end, desc = "Recent Files" },
            { "<leader>fl", function() require("snacks").picker.resume() end, desc = "Resume Last Search" },
            { "<leader>fb", function() require("snacks").picker.buffers() end, desc = "Buffers" },
            -- SOMEDAY: make this smaller and under cursor like fzf-lua
            { "z=", function() require("snacks").picker.spelling() end, desc = "Spelling suggestions" }, -- rebind from which-key

            -- Used Rare
            { "<leader>fD", function() require("snacks").picker.diagnostics() end, desc = "Diagnostics" },
            { "<leader>fq", function() require("snacks").picker.qflist() end, desc = "Quickfix List Items" },
            { "<leader>fC", function() require("snacks").picker.commands() end, desc = "Commands" },
            { "<leader>:", function() require("snacks").picker.command_history() end, desc = "Command History" },
            { "<leader>fM", function() require("snacks").picker.man() end, desc = "Man Pages" },
            { "<leader>fR", function() require("snacks").picker.registers() end, desc = "Registers" },
            { "<leader>fa", function() require("snacks").picker.autocmds() end, desc = "Autocmds" },

            -- Colors and Icons
            { "<leader>fH", function() require("snacks").picker.highlights() end, desc = "Highlights" },
            {
                "<leader>fc",
                function() require("snacks").picker.colorschemes({ layout = { preset = "dropdown" } }) end,
                desc = "Colorschemes w/ preview",
            },
            { "<leader>fi", function() require("snacks").picker.icons() end, desc = "Icons" },

            -- Git
            { "<leader>gb", function() require("snacks").picker.git_branches() end, desc = "Branches" },
            { "<leader>gl", function() require("snacks").picker.git_log() end, desc = "Commits" },
            { "<leader>gf", function() require("snacks").picker.git_log_file() end, desc = "Commits (File)" },
            { "<leader>gL", function() require("snacks").picker.git_log_line() end, desc = "Commits (Line)" },
            -- { "<leader>gD", function() require("snacks").picker.git_diff() end, desc = "Git Diff (Hunks)" },
            -- { "<leader>gs", function() require("snacks").picker.git_status() end, desc = "Git Status" },
            -- { "<leader>gS", function() require("snacks").picker.git_stash() end, desc = "Git Stash" },

            -- Other
            { "<leader>q", function() require("snacks").bufdelete({ buf = 0, force = false }) end, desc = "Delete Buffer" },
            -- TODO: switch from zen-mode
            --   { "<leader>z",  function() require("snacks").zen() end, desc = "Toggle Zen Mode" },
            --   { "<leader>Z",  function() require("snacks").zen.zoom() end, desc = "Toggle Zoom" },
            -- TODO: in case I figure out animations in notifier and can switch to it
            --   { "<leader>n",  function() require("snacks").notifier.show_history() end, desc = "Notification History" },
            -- TODO: ?
            --   { "<leader>cR", function() require("snacks").rename.rename_file() end, desc = "Rename File" },
            --   { "<leader>gB", function() require("snacks").gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
            --   { "<leader>gg", function() require("snacks").lazygit() end, desc = "Lazygit" },
            --   { "<leader>un", function() require("snacks").notifier.hide() end, desc = "Dismiss All Notifications" },
            --   { "<c-/>",      function() require("snacks").terminal() end, desc = "Toggle Terminal" },
            --   { "<c-_>",      function() require("snacks").terminal() end, desc = "which_key_ignore" },
            --   { "]]",         function() require("snacks").words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
            --   { "[[",         function() require("snacks").words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
            --   {
            --     "<leader>N",
            --     desc = "Neovim News",
            --     function()
            --       require("snacks").win({
            --         file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            --         width = 0.6,
            --         height = 0.6,
            --         wo = {
            --           spell = false,
            --           wrap = false,
            --           signcolumn = "yes",
            --           statuscolumn = " ",
            --           conceallevel = 3,
            --         },
            --       })
            --     end,
            --   }
        }
    end,
    -- init = function()
    --   vim.api.nvim_create_autocmd("User", {
    --     pattern = "VeryLazy",
    --     callback = function()
    --       -- Setup some globals for debugging (lazy-loaded)
    --       _G.dd = function(...)
    --         require("snacks").debug.inspect(...)
    --       end
    --       _G.bt = function()
    --         require("snacks").debug.backtrace()
    --       end
    --       vim.print = _G.dd -- Override print to use snacks for `:=` command

    --       -- Create some toggle mappings
    --       require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    --       require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    --       require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    --       require("snacks").toggle.diagnostics():map("<leader>ud")
    --       require("snacks").toggle.line_number():map("<leader>ul")
    --       require("snacks").toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    --       require("snacks").toggle.treesitter():map("<leader>uT")
    --       require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    --       require("snacks").toggle.inlay_hints():map("<leader>uh")
    --       require("snacks").toggle.indent():map("<leader>ug")
    --       require("snacks").toggle.dim():map("<leader>uD")
    --     end,
    --   })
    -- end,
}
