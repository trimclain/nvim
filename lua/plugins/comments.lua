-- comments with treesitter integration
return {
    -- RIP numToStr/Comment.nvim. Feautures like block comments and gco/gcO mappings will be missed.
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts = {
            options = {
                ignore_blank_line = true,
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        -- dependencies = "nvim-treesitter",
        init = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
        opts = { enable_autocmd = false },
    },
}
