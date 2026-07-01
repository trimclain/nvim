return {
    "dmtrKovalenko/fff.nvim",
    enabled = CONFIG.plugins.fff,
    lazy = false,
    build = function()
        require("fff.download").download_or_build_binary()
    end,
    opts = {
        debug = {
            enabled = true,
            show_scores = true,
        },
    },
    -- stylua: ignore
    keys = {
        -- NOTE: before enabling fff handle the conflicting keymaps with snacks
        { "<C-p>", function() require("fff").find_files() end, desc = "Find Files" },
        { "<leader>ff", function() require("fff").find_files() end, desc = "Files with preview" },
        { "<leader>fs", function() require("fff").live_grep() end, desc = "String in Files" },
        { "<leader>fw", function() require("fff").live_grep_under_cursor() end, mode = { "n", "x" }, desc = "Visual selection or <cword>" },
        -- { "<leader>fz", function() require("fff").live_grep({ grep = { modes = { "fuzzy", "plain" } } }) end, desc = "Live fffuzy grep" },
    },
}
