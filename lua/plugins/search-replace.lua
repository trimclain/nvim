-- search/replace in multiple files
return {
    "MagicDuck/grug-far.nvim",
    enabled = vim.fn.has("nvim-0.11") == 1,
    cond = vim.fn.executable("rg") == 1,
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
        {
            "<leader>rr",
            function()
                local grug = require("grug-far")
                local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                grug.open({
                    transient = true, -- launch as a unlisted buffer that fully deletes itself when not in use
                    keymaps = { help = "?" },
                    prefills = {
                        filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        flags = "--hidden",
                    },
                })
            end,
            mode = { "n", "v" },
            desc = "Search and Replace",
        },
    },
}
