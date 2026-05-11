-- undo tree
return {
    {
        "jiaoshijie/undotree",
        -- dev = true,
        enabled = vim.fn.has("nvim-0.11") == 1,
        cond = vim.fn.executable("diff") == 1, -- windows issues
        opts = {
            window = {
                border = CONFIG.ui.border, -- default: "rounded",
            },
            keymaps = {
                -- ["move_next"] = "j",
                -- ["move_prev"] = "k",
                -- ["move2parent"] = "gj",
                -- ["move_change_next"] = "J",
                -- ["move_change_prev"] = "K",
                -- ["action_enter"] = "<cr>",
                ["enter_diffbuf"] = "<tab>", -- default "p"
                -- ["quit"] = "q",
                -- ["update_undotree_view"] = "S",
            },
        },
        keys = {
            -- stylua: ignore
            { "<leader>u", function() require("undotree").toggle() end, desc = "Toggle UndoTree" },
        },
    },
}
