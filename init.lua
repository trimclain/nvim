-------------------------------------------------------------------------------
--                                                                           --
--   ████████╗██████╗ ██╗███╗   ███╗ ██████╗██╗      █████╗ ██╗███╗   ██╗    --
--   ╚══██╔══╝██╔══██╗██║████╗ ████║██╔════╝██║     ██╔══██╗██║████╗  ██║    --
--      ██║   ██████╔╝██║██╔████╔██║██║     ██║     ███████║██║██╔██╗ ██║    --
--      ██║   ██╔══██╗██║██║╚██╔╝██║██║     ██║     ██╔══██║██║██║╚██╗██║    --
--      ██║   ██║  ██║██║██║ ╚═╝ ██║╚██████╗███████╗██║  ██║██║██║ ╚████║    --
--      ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚══════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝    --
--                                                                           --
--       Arthur McLain (trimclain)                                           --
--       mclain.it@gmail.com                                                 --
--       https://github.com/trimclain                                        --
--                                                                           --
-------------------------------------------------------------------------------

--- @usage: "default" | "minimal"
local mode = "default"

_G.ON_INFERIOR_OS = not not jit.os:find("Windows")

if _G.ON_INFERIOR_OS and (vim.g.neovide or vim.fn.has("gui_running") == 1) then
    -- I want neovide to start fast, until I fix 15 minute startup time on garbage os
    mode = "minimal"
end

-- Important settings for easy modification
CONFIG = {
    opts = {
        tabwidth = 4,
        colorcolumn = true,
        word_wrap = false,
        spaces_over_tabs = true, -- there's only one correct option here
    },
    lsp = {
        enabled = mode == "default",
        format_on_save = false,
        virtual_text = false,
        show_signature_help = not _G.ON_INFERIOR_OS,
        enable_copilot = false,
    },
    ui = {
        -- Colorschemes (note/10):
        -- astrospeed (10)
        -- astrotheme (9), catppuccin (9), tokyonight (9), rose-pine (9), tundra (9)
        -- darkplus (8.5), primer-dark (8), nightfox (8), vscode (8), gruvbox (8)
        -- github-dark (7), onedark (7), kanagawa (7), zephyr (7), poimandres (7)
        -- embark(6), sonokai (6), omni (6),
        colorscheme = "astrotheme",
        transparent_background = false,
        cursorline = true,
        -- border = "rounded", -- see `:h nvim_open_win()`
        border = "none",
        italic_comments = true,
        ghost_text = false,
        inlay_hints = false,
    },
    git = {
        enabled = mode == "default",
        show_line_blame = true,
        show_signcolumn = true,
    },
    plugins = {
        enable_completion = mode == "default",
        -- use blink.cmp or nvim-cmp
        use_blink_completion = true,
        -- use fzf-lua or telescope.nvim
        use_fzf_lua = vim.fn.executable("fzf") == 1 and false,

        neoscroll = not _G.ON_INFERIOR_OS,
        smear_cursor = false, -- found out about kitty's cursor trail

        autopairs = mode == "default",
        bufferline = false, -- to use harpoon more
        dashboard = mode == "default",
        dressing = mode == "default",
        illuminate = mode == "default",
        indentline = mode == "default",
        lualine = mode == "default",
        spinner = mode == "default", -- animation shown when tasks are ongoing
        spinner_type = "dots_pulse", -- spinners: dots_pulse, moon, meter, zip, pipe, dots, arc
        todo_comments = mode == "default",
        treesj = mode == "default",
    },
}

-- -- Check for neovim dependencies:
-- -- gcc: nvim-treesitter, telescope-fzf-native
-- -- make: telescope-fzf-native
-- -- ripgrep: telescope, grug-far, todo-comments, fzf-lua
-- -- node: mason, nvim-lspconfig
-- -- fzf: fzf-lua
-- -- fd: fzf-lua
-- -- bat: fzf-lua
-- local dependencies = {
--     "gcc",
--     "make",
--     "ripgrep",
--     "node",
--     "fzf",
--     "fd",
--     "bat",
-- }
-- for _, dep in ipairs(dependencies) do
--     if vim.fn.executable(dep) == 0 then
--         vim.notify("Missing dependency: " .. dep, vim.log.levels.WARN, { title = "My Neovim Dependencies" })
--     end
-- end

require("core.options")
require("core.autocmd")
require("core.lazy")
require("core.keymaps")
