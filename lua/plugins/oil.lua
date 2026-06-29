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
    },
}
