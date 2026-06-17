-- git client
return {
    "NeogitOrg/neogit",
    -- dir = "~/projects/open-source/nvim-plugins/neogit",
    cond = CONFIG.git.enabled,
    -- dependencies = {
    --     "plenary.nvim",
    --     "codediff.nvim",
    --     "snacks.nvim",
    -- },
    cmd = "Neogit",
    keys = {
        { "<leader>gs", "<cmd>Neogit<cr>", desc = "Status" },
    },
    init = function()
        -- Allow more characters in the git commit message
        -- Docs: https://superuser.com/questions/887712/how-do-i-change-the-hilighted-length-of-git-commit-messages-in-vim
        vim.g.gitcommit_summary_length = 72 -- default: 50
    end,
    opts = function()
        local Icons = require("core.icons")
        return {
            prompt_amend_commit = false, -- request confirmation when amending already published commits
            disable_insert_on_commit = true, -- "auto", "true" or "false"
            --remember_settings = false, -- persist the values of switches/options within and across sessions
            --use_per_project_settings = false, -- scope persisted settings on a per-project basis
            -- Table of settings to never persist. Uses format "Filetype--cli-value"
            ignored_settings = {
                "NeogitPushPopup--force",
                "NeogitPushPopup--force-with-lease",
            },
            -- Neogit refreshes its internal state after specific events, which can be expensive depending on the repository size.
            -- Disabling `auto_refresh` will make it so you have to manually refresh the status after you open it.
            --auto_refresh = false,
            -- The time after which an output console is shown for slow running commands
            --console_timeout = 2000,
            -- Automatically show console if a command takes more than console_timeout milliseconds
            --auto_show_console = true,
            signs = {
                -- { CLOSED, OPENED }
                section = { Icons.nav.ArrowClosed, Icons.nav.ArrowOpen }, -- default: { ">", "v" },
                item = { Icons.nav.ArrowClosedSmall, Icons.nav.ArrowOpenSmall }, -- default: { ">", "v" },
                -- default: hunk = { "", "" },
                hunk = { "", "" },
            },
            diff_viewer = "codediff",
            -- override/add mappings
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
        }
    end,
    config = function(_, opts)
        local neogit = require("neogit")
        neogit.setup(opts)

        -- Close Neogit after `git push`
        vim.api.nvim_create_autocmd("User", {
            pattern = "NeogitPushComplete",
            group = vim.api.nvim_create_augroup("trimclain_close_neogit_after_push", { clear = true }),
            callback = function()
                neogit.close()
            end,
        })
    end,
}
