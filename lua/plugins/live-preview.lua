-- preview stuff in browser
return {
    "brianhuster/live-preview.nvim",
    -- dev = true,
    enabled = not ON_INFERIOR_OS,
    dependencies = { "snacks.nvim" },
    ft = { "markdown", "html", "svg" },
    -- TODO: can I make LivePreview close to also close the browser window like iamcco/markdown-preview.nvim
    cmd = "LivePreview",
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
