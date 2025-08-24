return {
    -- indent guides for Neovim
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = { "BufReadPost", "BufNewFile" },
        cond = CONFIG.plugins.indentline,
        opts = function()
            local Icons = require("core.icons")
            return {
                indent = {
                    char = Icons.ui.LineLeft, -- default: "│"
                    tab_char = Icons.ui.LineLeft, -- default: "│"
                },
                scope = { enabled = false },
                exclude = {
                    filetypes = require("core.util").get_disabled_filetypes(),
                },
            }
        end,
    },

    -- active indent guide and indent text objects
    {
        "echasnovski/mini.indentscope",
        event = { "BufReadPre", "BufNewFile" },
        cond = CONFIG.plugins.indentline,
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = require("core.util").get_disabled_filetypes(),
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
        config = function()
            local opts = {
                symbol = require("core.icons").ui.LineLeft, -- default: "│",
                options = { try_as_border = true },
            }

            require("mini.indentscope").setup(opts)
        end,
    },

    -- Detect tabstop and shiftwidth automatically
    {
        "nmac427/guess-indent.nvim",
        event = { "BufReadPost", "BufNewFile" },
        cmd = "GuessIndent",
        opts = {
            -- auto_cmd = true, -- Set to false to disable automatic execution
            -- override_editorconfig = false, -- Set to true to override settings set by .editorconfig
            filetype_exclude = vim.list_extend({ "netrw", "tutor" }, require("core.util").get_disabled_filetypes()),
        },
    },
}
