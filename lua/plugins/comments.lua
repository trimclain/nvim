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
        config = function(_, opts)
            require("mini.comment").setup(opts)

            local function get_comment_parts()
                local cs = opts.options.custom_commentstring()
                local left, right = string.match(cs or vim.bo.commentstring, "(.*)%%s(.*)")
                return vim.trim(left or ""), vim.trim(right or "")
            end

            local function insert_commented_line(above)
                local row = vim.api.nvim_win_get_cursor(0)[1]
                local insert_at = above and (row - 1) or row
                local left, right = get_comment_parts()

                local line
                if right ~= "" then
                    line = left .. "  " .. right
                else
                    line = left .. " "
                end

                vim.api.nvim_buf_set_lines(0, insert_at, insert_at, false, { line })

                vim.api.nvim_win_set_cursor(0, { insert_at + 1, 0 })
                vim.cmd.normal({ "==", bang = true })

                local current = vim.api.nvim_get_current_line()
                local indent = current:match("^%s*") or ""
                local col = #indent + #left

                vim.api.nvim_win_set_cursor(0, { insert_at + 1, col })
                vim.api.nvim_feedkeys("a", "n", false)
            end

            vim.keymap.set("n", "gco", function()
                insert_commented_line(false)
            end, { desc = "Add comment below" })

            vim.keymap.set("n", "gcO", function()
                insert_commented_line(true)
            end, { desc = "Add comment above" })
        end,
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
