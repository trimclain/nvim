-- harpoon btw
return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        enabled = not _G.ON_INFERIOR_OS,
        dependencies = "plenary.nvim",
        -- dir = "~/projects/open-source/nvim-plugins/harpoon",
        -- stylua: ignore
        keys = function()
            return {
                { "<leader>a", function() require("harpoon"):list():add() end, desc = "Add Harpoon Mark" },
                { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle Harpoon Menu" },
                { "<C-j>", function() require("harpoon"):list():select(1) end, desc = "Harpoon to file 1" },
                { "<C-k>", function() require("harpoon"):list():select(2) end, desc = "Harpoon to file 2" },
                { "<C-h>", function() require("harpoon"):list():select(3) end, desc = "Harpoon to file 3" },
                { "<C-g>", function() require("harpoon"):list():select(4) end, desc = "Harpoon to file 4" },
            }
        end,
        opts = {
            settings = {
                save_on_toggle = true,
            },
        },
        config = function(_, opts)
            require("harpoon"):setup(opts)
        end,
    },
}
