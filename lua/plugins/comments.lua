-- comments with some nice keybindings and treesitter integration
return {
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        dependencies = {
            {
                "JoosepAlviste/nvim-ts-context-commentstring",
                dependencies = "nvim-treesitter",
                config = function()
                    vim.g.skip_ts_context_commentstring_module = true
                    require("ts_context_commentstring").setup({
                        enable_autocmd = false,
                    })
                end,
            },
        },
        config = function()
            ---@diagnostic disable-next-line: missing-fields
            require("Comment").setup({
                mappings = { basic = false, extra = false }, -- I'll create them myself below
                ignore = "^$", -- ignores empty lines
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })

            -- Credit: Comment.nvim/lua/Comment/init.lua
            -- Removed useless normal mod mapping for "gc" and "gb"
            local api = require("Comment.api")
            local vvar = vim.api.nvim_get_vvar
            local K = vim.keymap.set

            -- Basic Mappings
            -- NORMAL mode mappings
            --- Exists in nvim since 0.10
            -- K("n", "gcc", function()
            --     return vvar("count") == 0 and "<Plug>(comment_toggle_linewise_current)"
            --         or "<Plug>(comment_toggle_linewise_count)"
            -- end, { expr = true, desc = "Comment toggle current line" })
            K("n", "gcb", function()
                return vvar("count") == 0 and "<Plug>(comment_toggle_blockwise_current)"
                    or "<Plug>(comment_toggle_blockwise_count)"
            end, { expr = true, desc = "Comment toggle current block" })

            -- VISUAL mode mappings
            --- Exists in nvim since 0.10
            -- K("x", "gc", "<Plug>(comment_toggle_linewise_visual)", { desc = "Comment toggle linewise (visual)" })
            K("x", "gb", "<Plug>(comment_toggle_blockwise_visual)", { desc = "Comment toggle blockwise (visual)" })

            -- Extra Mappings
            K("n", "gco", api.insert.linewise.below, { desc = "Comment insert below" })
            K("n", "gcO", api.insert.linewise.above, { desc = "Comment insert above" })
            K("n", "gcA", api.locked("insert.linewise.eol"), { desc = "Comment insert end of line" })

            local comment_ft = require("Comment.ft")
            comment_ft.set("rasi", { "//%s", "/*%s*/" }) -- rofi config
            -- comment_ft.set("lua", { "--%s", "--[[%s]]" })
            -- comment_ft.set("markdown", { "[//]:%s", "<!--%s-->" })
        end,
    },
}
