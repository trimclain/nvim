-- preview typst document instantly on type
return {
    "chomosuke/typst-preview.nvim",
    enabled = not ON_INFERIOR_OS, -- curl is required to download necessary binaries
    ft = "typst",
    version = "1.*",
    opts = {
        -- Setting this to 'always' will invert black and white in the preview
        -- Setting this to 'auto' will invert depending if the browser has enable
        -- dark mode
        -- Setting this to '{"rest": "<option>","image": "<option>"}' will apply
        -- your choice of color inversion to images and everything else
        -- separately.
        invert_colors = "never",

        -- Provide the path to binaries for dependencies.
        -- Setting this will skip the download of the binary by the plugin.
        -- Warning: Be aware that your version might be older than the one
        -- required.
        dependencies_bin = {
            ["tinymist"] = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "tinymist"), -- installed via Mason
            ["websocat"] = nil,
        },
    },
    config = function(_, opts)
        -- Detect installed browser
        local browserlist = {
            "helium-browser",
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
                opts.open_cmd = browser .. " --new-window %s"
                break
            end
        end
        require("typst-preview").setup(opts)
    end,
}
