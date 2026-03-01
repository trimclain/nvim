return {
    -- preview colors in neovim
    {
        -- Alternative: https://github.com/brenoprata10/nvim-highlight-colors
        "catgoose/nvim-colorizer.lua",
        event = "VeryLazy",
        -- keys = {
        --     { "<leader>cr",  "<cmd>ColorizerReloadAllBuffers<cr>", desc = "ColorizeReload" },
        -- },
        config = function()
            require("colorizer").setup({
                lazy_load = true,
                options = {
                    parsers = {
                        css = true, -- Preset: enables names, hex (all), rgb, hsl, oklch
                        names = { enable = false }, -- disable names despite css preset
                        tailwind = {
                            enable = true,
                            update_names = false, -- Update tailwind_names color mapping from LSP results
                        },
                        xterm = { enable = true },
                    },
                    display = {
                        mode = "background", -- opts: "background", "foreground", "virtualtext"
                    },
                    -- update color values even if buffer is not focused
                    always_update = false,
                },
                filetypes = { "*" },
                -- all the sub-options of filetypes apply to buftypes
                buftypes = {
                    "*",
                    -- exclude prompt and popup buftypes from highlight
                    "!prompt",
                    "!popup",
                },
            })
        end,
    },

    -- color picker
    {
        "KabbAmine/vCoolor.vim",
        enabled = vim.fn.executable("zenity") == 1 or vim.fn.executable("yad") == 1,
        keys = {
            { "<M-c>", "<cmd>VCoolor<cr>", desc = "Open Colorpicker", mode = { "n", "i" } },
        },
        config = function()
            vim.g.vcoolor_disable_mappings = 1
            -- vim.g.vcoolor_lowercase = 1
        end,
    },

    -- -- alternative to colorizer and colorpicker in one plugin:
    -- {
    --     "uga-rosa/ccc.nvim",
    --     event = { "BufReadPost", "BufNewFile" },
    --     keys = {
    --         { "<M-c>", "<cmd>CccPick<cr>", desc = "Open Colorpicker" },
    --     },
    --     opts = {
    --         win_opts = {
    --             border = CONFIG.ui.border,
    --         },
    --         -- highlight_mode = "virtual", -- "fg" | "bg" (default) | "foreground" | "background" | "virtual"
    --         -- virtual_symbol = " ■ ", -- default: " ● "
    --         highlighter = {
    --             auto_enable = true, -- enable colorizer
    --         },
    --     },
    -- },

    -- can't make it work for some reason
    -- {
    --     "nvzone/minty",
    --     dependencies = "nvzone/volt",
    --     cmd = { "Shades", "Huefy" },
    -- },
}
