-- Alternative: https://github.com/echasnovski/mini.hipatterns (combines colorizer)
return {
    "folke/todo-comments.nvim",
    cond = CONFIG.plugins.todo_comments,
    -- dependencies = {
    --     "plenary.nvim", -- used if ripgrep not found
    --     "snacks.nvim",
    -- },
    cmd = { "TodoQuickFix" },
    -- stylua: ignore
    keys = {
        { "]t", function() require("todo-comments").jump_next({ keywords = { "TODO", "FIX" } }) end, desc = "Next todo comment" },
        { "[t", function() require("todo-comments").jump_prev({ keywords = { "TODO", "FIX" } }) end, desc = "Previous todo comment" },
        ---@diagnostic disable-next-line: undefined-field
        { "<leader>ft", function() require("snacks").picker.todo_comments({ keywords = { "TODO", "FIX" }, hidden = true }) end, desc = "Todo" },
        ---@diagnostic disable-next-line: undefined-field
        { "<leader>fT", function() require("snacks").picker.todo_comments({ hidden = true }) end, desc = "Todo" },
    },
    event = { "BufReadPost", "BufNewFile" },
    opts = function()
        local Icons = require("core.icons")

        return {
            -- keywords recognized as todo comments
            keywords = {
                FIX = {
                    icon = Icons.status.Bug, -- icon used for the sign, and in search results
                    color = "error", -- can be a hex color, or a named color (see below)
                    alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                    -- signs = false, -- configure signs for some keywords individually
                },
                TODO = { icon = Icons.actions.Check, color = "info" },
                HACK = { icon = Icons.status.Fire, color = "warning" },
                WARN = {
                    icon = Icons.diagnostics.WarnThick,
                    color = "warning",
                    alt = { "WARNING", "XXX" },
                },
                PERF = { icon = Icons.status.Clock, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                NOTE = { icon = Icons.status.Message, color = "hint", alt = { "INFO", "IDEA" } },
                TEST = { icon = Icons.status.Speedometer, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
            },
            search = {
                command = "rg",
                args = {
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--hidden", -- search hidden files/directories
                },
                -- regex that will be used to match keywords.
                -- don't replace the (KEYWORDS) placeholder
                pattern = [[\b(KEYWORDS):]], -- ripgrep regex
                -- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
            },
        }
    end,
}
