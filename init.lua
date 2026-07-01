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

-- Dependencies:
-- gcc: nvim-treesitter
-- tree-sitter-cli: nvim-treesitter
-- ripgrep: snacks.picker, grug-far, todo-comments
-- node: mason, nvim-lspconfig
-- imagemagick: snacks.image

--- @usage: "default" | "minimal"
local mode = "default"

_G.ON_INFERIOR_OS = not not jit.os:find("Windows")

if ON_INFERIOR_OS and (vim.g.neovide or vim.fn.has("gui_running") == 1) then
    -- I want neovide to start fast, until I fix 15 minute startup time on garbage os
    mode = "minimal"
end

-- Important settings for easy modification
_G.CONFIG = {
    opts = {
        tabwidth = 4,
        colorcolumn = true,
        word_wrap = false,
        spaces_over_tabs = true, -- there's only one correct option here
    },
    ui = {
        -- Colorschemes (note/10):
        -- astrotheme (9.5), catppuccin (9), tokyonight (9), rose-pine (9), nightfox (9)
        -- vague (8.9), duskfox (8.8), carbonfox (8.7) tundra (8.5), darkplus (8.5), primer-dark (8), vscode (8)
        -- gruvbox (7.9), github-dark (7), onedark (7), kanagawa (7), zephyr (7), poimandres (7)
        -- embark(6), sonokai (6), omni (6),
        colorscheme = "astrotheme",
        transparent_background = false,
        cursorline = true,
        border = "rounded", -- see `:h winborder`
        italic_comments = true,
        ghost_text = false,
        inlay_hints = false,
    },
    git = {
        enabled = mode == "default",
        show_line_blame = true,
        show_signcolumn = true,
    },
    lsp = {
        enable_completion = mode == "default", -- LSP, autocomplete, snippets, language servers and tools
        format_on_save = false,
        virtual_text = false,
        show_signature_help = not ON_INFERIOR_OS,
        enable_copilot = false,
        enable_windsurf = false,
    },
    plugins = {
        neoscroll = not ON_INFERIOR_OS,
        smear_cursor = ON_INFERIOR_OS, -- found out about kitty's cursor trail

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
        treesitter = not ON_INFERIOR_OS,

        -- these have sadly no lazy loading support
        oil = true,
        debugprint = true,
        fff = false,
    },
}

-- local Timer = require("core.util.timer")
-- Timer.start("Sourcing Local Config")
local local_config = vim.fs.joinpath(vim.fn.stdpath("config"), "local.lua")
if require("core.util").file_exists(local_config) then
    dofile(local_config)
end
-- Timer.stop()

require("core.options")
require("core.autocmd")
require("core.lazy")
require("core.keymaps")
