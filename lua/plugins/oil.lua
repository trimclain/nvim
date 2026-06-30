-- file explorer that allows to edit the filesystem like a buffer
return {
    "stevearc/oil.nvim",
    cond = CONFIG.plugins.oil,
    lazy = false,
    -- dependencies = { "nvim-web-devicons" },
    keys = {
        { "<leader>E", "<cmd>Oil<cr>", desc = "Explorer Oil" },
    },
    opts = {
        default_file_explorer = false,
        keymaps = {
            -- ["g?"] = { "actions.show_help", mode = "n" },
            -- ["<CR>"] = "actions.select",
            -- ["<C-s>"] = { "actions.select", opts = { vertical = true } },
            -- ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
            -- ["<C-t>"] = { "actions.select", opts = { tab = true } },
            -- ["<C-p>"] = "actions.preview",
            -- ["<C-c>"] = { "actions.close", mode = "n" },
            -- ["<C-l>"] = "actions.refresh",
            -- ["-"] = { "actions.parent", mode = "n" },
            ["<BS>"] = { "actions.parent", mode = "n" },
            -- ["_"] = { "actions.open_cwd", mode = "n" },
            -- ["`"] = { "actions.cd", mode = "n" },
            -- ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            -- ["gs"] = { "actions.change_sort", mode = "n" },
            -- ["gx"] = "actions.open_external",
            -- ["g."] = { "actions.toggle_hidden", mode = "n" },
            -- ["g\\"] = { "actions.toggle_trash", mode = "n" },
        },
    },
}
