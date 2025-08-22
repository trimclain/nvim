-- Alternative: https://github.com/echasnovski/mini.hipatterns (combines colorizer)
return {
    {
        "folke/todo-comments.nvim",
        cond = CONFIG.plugins.todo_comments,
        dependencies = {
            "plenary.nvim", -- used if ripgrep not found
            "fzf-lua",
        },
        cmd = { "TodoTrouble", "TodoFzfLua" },
        keys = {
            -- stylua: ignore start
            { "]t", function() require("todo-comments").jump_next({ keywords = { "TODO", "FIX" } }) end, desc = "Next todo comment" },
            { "[t", function() require("todo-comments").jump_prev({ keywords = { "TODO", "FIX" } }) end, desc = "Previous todo comment" },
            -- stylua: ignore end
            { "<leader>ft", "<cmd>TodoFzfLua<cr>", desc = "Todo" },
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            -- Fix some display issues
            vim.api.nvim_create_user_command(
                "TodoFzfLua",
                function()
                    if not CONFIG.plugins.fzf_lua then
                        vim.notify("Fzf-Lua is not installed", vim.log.levels.ERROR, { title = "Todo Comments" })
                        return
                    end
                    require("fzf-lua.providers.grep").grep({
                        no_esc = true,
                        multiline = true,
                        search = "\\b(TODO|FIX):",
                        no_headr = true,
                        no_header_i = true,
                        prompt = "> ",
                        winopts = { title = " Find Todo " },
                    })
                end,
                { bang = true } -- force to redefine the command
            )

            local Icons = require("core.icons")

            return {
                -- keywords recognized as todo comments
                keywords = {
                    FIX = {
                        icon = Icons.ui.Bug, -- icon used for the sign, and in search results
                        color = "error", -- can be a hex color, or a named color (see below)
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
                        -- signs = false, -- configure signs for some keywords individually
                    },
                    TODO = { icon = Icons.ui.Check, color = "info" },
                    HACK = { icon = Icons.ui.Fire, color = "warning" },
                    WARN = {
                        icon = Icons.diagnostics.BoldWarn,
                        color = "warning",
                        alt = { "WARNING", "XXX" },
                    },
                    PERF = { icon = Icons.ui.Clock, alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = Icons.ui.Message, color = "hint", alt = { "INFO", "IDEA" } },
                    TEST = { icon = Icons.ui.Speedometer, color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
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
    },
}
