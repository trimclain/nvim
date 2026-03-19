-- git client
return {
    {
        "NeogitOrg/neogit",
        -- dir = "~/projects/open-source/nvim-plugins/neogit",
        cond = CONFIG.git.enabled,
        dependencies = {
            "plenary.nvim",
            "diffview.nvim",
            "snacks.nvim",
        },
        cmd = "Neogit",
        keys = {
            { "<leader>gs", "<cmd>Neogit<cr>", desc = "status" },
        },
        config = function()
            local Icons = require("core.icons").ui
            local neogit = require("neogit")
            neogit.setup({
                disable_insert_on_commit = true, -- "auto", "true" or "false"
                -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
                -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
                --auto_refresh = true,
                -- The time after which an output console is shown for slow running commands
                --console_timeout = 2000,
                -- Automatically show console if a command takes more than console_timeout milliseconds
                --auto_show_console = true,
                -- override/add mappings
                signs = {
                    -- { CLOSED, OPENED }
                    section = { Icons.ArrowClosed, Icons.ArrowOpen }, -- default: { ">", "v" },
                    item = { Icons.ArrowClosedSmall, Icons.ArrowOpenSmall }, -- default: { ">", "v" },
                    -- default: hunk = { "", "" },
                    hunk = { "", "" },
                },
                mappings = {
                    commit_editor_I = {
                        ["<c-c><c-c>"] = false,
                        ["<c-c><c-k>"] = false,
                    },
                    popup = {
                        ["P"] = "PullPopup",
                        ["p"] = "PushPopup",
                    },
                },
            })

            -- Close Neogit after `git push`
            vim.api.nvim_create_autocmd("User", {
                pattern = "NeogitPushComplete",
                group = vim.api.nvim_create_augroup("trimclain_close_neogit_after_push", { clear = true }),
                callback = function()
                    neogit.close()
                end,
            })

            -- Allow more characters in the git commit message
            -- Docs: https://superuser.com/questions/887712/how-do-i-change-the-hilighted-length-of-git-commit-messages-in-vim
            vim.g.gitcommit_summary_length = 72 -- default: 50
        end,
    },
}
