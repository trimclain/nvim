-- preview stuff in browser
return {
    "brianhuster/live-preview.nvim",
    -- dev = true,
    enabled = not _G.ON_INFERIOR_OS,
    dependencies = {
        "fzf-lua",
        "telescope.nvim",
    },
    ft = { "markdown", "html", "svg" },
    cmd = "LivePreview",
    keys = {
        -- TODO: make this toggle
        { "<leader>mp", "<cmd>LivePreview start<cr>", desc = "Open Markdown/HTML Preview (Live Server)" },
    },
    opts = {
        -- port = 5500,
        -- browser = "default",
        -- dynamic_root = false,
        -- sync_scroll = true,
        -- picker = "",
    },
    config = function(_, opts)
        -- Detect installed browser
        local browserlist = {
            "thorium-browser",
            "google-chrome",
            "brave",
            "brave-browser",
            "zen-browser",
            "chromium",
        }
        for _, browser in ipairs(browserlist) do
            if vim.fn.executable(browser) == 1 then
                -- Open preview in a new window
                opts.browser = browser .. " --new-window"
                break
            end
        end

        require("livepreview.config").set(opts)
    end,
}
