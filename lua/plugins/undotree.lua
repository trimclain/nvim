-- undo tree
return {
    {
        "jiaoshijie/undotree",
        enabled = vim.fn.has("nvim-0.11") == 1,
        cond = vim.fn.executable("diff") == 1, -- windows issues
        opts = {
            window = {
                border = CONFIG.ui.border, -- default: "rounded",
            },
            keymaps = {
                -- ["j"] = "move_next",
                -- ["k"] = "move_prev",
                -- ["gj"] = "move2parent",
                -- ["J"] = "move_change_next",
                -- ["K"] = "move_change_prev",
                -- ["<cr>"] = "action_enter",
                ["<tab>"] = "enter_diffbuf", -- default: ["p"]
                -- ["q"] = "quit",
                -- ["S"] = "update_undotree_view",
            },
        },
        keys = {
            -- stylua: ignore
            { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle UndoTree" },
        },
    },
}
