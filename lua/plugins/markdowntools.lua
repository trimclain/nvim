return {
    -- Plugin for automated bullet lists in markdown
    -- use "dkarter/bullets.vim"

    -- Plugin to generate table of contents for Markdown files
    -- use "mzlogin/vim-markdown-toc"

    -- preview markdown files in browser
    --- INFO:Currently replaced this with live-preview.nvim, although this is still a little better
    -- {
    --     "iamcco/markdown-preview.nvim",
    --     enabled = vim.fn.executable("npm") == 1,
    --     build = "cd app && npx --yes yarn install", -- Lazy sync doesn't run `git restore .` so it can't pull
    --     -- build = function() vim.fn["mkdp#util#install"]() end, # it's possible to install without npm/yarn
    --     -- cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    --     ft = { "markdown" },
    --     init = function()
    --         vim.g.mkdp_filetypes = { "markdown" }
    --     end,
    --     config = function()
    --         vim.g.mkdp_auto_close = 0 -- don't auto close current preview window when change to another buffer
    --         vim.g.mkdp_echo_preview_url = 1 -- echo preview page url in command line when open preview page
    --
    --         -- Detect installed browser
    --         local browserlist = {
    --             "thorium-browser",
    --             "google-chrome",
    --             "brave",
    --             "brave-browser",
    --         }
    --         local browserlist_on_windows = {
    --             "C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe",
    --             "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe",
    --         }
    --
    --         local on_windows = _G.ON_INFERIOR_OS
    --         if on_windows then
    --             for _, browser in ipairs(browserlist_on_windows) do
    --                 if vim.fn.executable(browser) == 1 then
    --                     vim.g.mkdp_browser = browser
    --                     break
    --                 end
    --             end
    --         else
    --             for _, browser in ipairs(browserlist) do
    --                 if vim.fn.executable(browser) == 1 then
    --                     vim.g.mkdp_browser = browser
    --                     break
    --                 end
    --             end
    --         end
    --
    --         if not vim.g.mkdp_browser then
    --             vim.notify("Couldn't find installed browser", vim.log.levels.ERROR, { title = "Markdown Previewer" })
    --         end
    --
    --         -- Open preview in a new window
    --         -- doesn't work on mac: https://github.com/iamcco/markdown-preview.nvim#faq
    --         vim.cmd([[
    --             function! OpenMarkdownPreview(url)
    --                 execute 'silent ! "' . g:mkdp_browser . '" --new-window ' . a:url
    --             endfunction
    --             let g:mkdp_browserfunc = "OpenMarkdownPreview"
    --         ]])
    --
    --         vim.keymap.set(
    --             "n",
    --             "<leader>mp",
    --             "<cmd>MarkdownPreviewToggle<cr>",
    --             { noremap = true, silent = true, buffer = true, desc = "Toggle Markdown Preview" }
    --         )
    --     end,
    -- },

    -- Alternative: https://github.com/OXY2DEV/markview.nvim
    -- render markdown in neovim
    {
        "MeanderingProgrammer/render-markdown.nvim",
        -- dependencies = {
        --     "nvim-treesitter",
        --     "nvim-web-devicons",
        -- },
        cond = CONFIG.plugins.treesitter,
        cmd = "RenderMarkdown",
        ft = { "markdown" },
        opts = function()
            -- Define highlights for custom checkbox types
            vim.api.nvim_set_hl(0, "RenderMarkdownUncertain", { link = "DiagnosticWarn" })
            vim.api.nvim_set_hl(0, "RenderMarkdownOnHold", { link = "Conditional" })
            vim.api.nvim_set_hl(0, "RenderMarkdownCancelled", { link = "Comment" })
            vim.api.nvim_set_hl(0, "RenderMarkdownRecurring", { link = "Special" })
            vim.api.nvim_set_hl(0, "RenderMarkdownUrgent", { link = "DiagnosticError" })

            local Icons = require("core.icons")
            return {
                render_modes = true, -- default: { "n", "c", "t" }
                code = {
                    sign = false,
                    width = "block", -- default: "full"
                    right_pad = 1, -- default: 0
                    border = "thin", -- default: "hide"
                },
                heading = {
                    sign = false,
                    -- use basic icons from neorg
                    icons = { "◉ ", "◎ ", "○ ", "✺ ", "▶ ", "⤷ " }, -- default: { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
                },
                -- Docs: https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki/Checkboxes
                checkbox = {
                    unchecked = {
                        icon = Icons.status.BoxUnchecked .. " ",
                        highlight = "RenderMarkdownUnchecked",
                        scope_highlight = nil,
                    },
                    -- default: "󰱒 "
                    checked = {
                        icon = Icons.status.BoxChecked .. " ",
                        highlight = "RenderMarkdownChecked",
                        scope_highlight = nil,
                    },
                    custom = {
                        -- default: "󰥔 "
                        todo = {
                            raw = "[-]",
                            rendered = Icons.status.Clock .. " ",
                            highlight = "RenderMarkdownTodo",
                            scope_highlight = nil,
                        },
                        uncertain = {
                            raw = "[?]",
                            rendered = Icons.status.Question .. " ",
                            highlight = "RenderMarkdownUncertain",
                            scope_highlight = nil,
                        },
                        on_hold = {
                            raw = "[=]",
                            rendered = Icons.actions.Pause .. " ",
                            highlight = "RenderMarkdownOnHold",
                            scope_highlight = nil,
                        },
                        cancelled = {
                            raw = "[_]",
                            rendered = Icons.actions.Cancel .. " ",
                            highlight = "RenderMarkdownCancelled",
                            scope_highlight = nil,
                        },
                        recurring = {
                            raw = "[+]",
                            rendered = Icons.unicode.OpenCircleArrowAnticlockwise .. " ",
                            highlight = "RenderMarkdownRecurring",
                            scope_highlight = nil,
                        },
                        urgent = {
                            raw = "[!]",
                            rendered = Icons.diagnostics.Warn .. " ",
                            highlight = "RenderMarkdownUrgent",
                            scope_highlight = nil,
                        },
                    },
                },
            }
        end,
    },
}
