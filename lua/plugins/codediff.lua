-- better git diff
return {
    "esmuellert/codediff.nvim",
    cond = CONFIG.git.enabled,
    cmd = "CodeDiff",
    keys = {
        { "<leader>gd", "<cmd>CodeDiff<cr>", desc = "Diff" },
        -- TODO: implement opening 2 files vsplit and passing them to 'CodeDiff file'
    },
}
