if not CONFIG.plugins.use_blink_completion then
    return {}
end

return {
    {
        "saghen/blink.cmp",
        cond = CONFIG.plugins.enable_completion,
        version = "1.*", -- use a release tag to download pre-built binaries
        event = "VeryLazy", -- '/' and ':' autocomplete won't always work on InsertEnter
        dependencies = {
            "L3MON4D3/LuaSnip",
            "ribru17/blink-cmp-spell",
            {
                "erooke/blink-cmp-latex",
                enabled = not _G.ON_INFERIOR_OS,
            },
            {
                "giuxtaposition/blink-cmp-copilot", -- NOTE: this might be not setup properly. Didn't work last time.
                enabled = CONFIG.lsp.enable_copilot and vim.fn.executable("node") == 1,
                cond = vim.g.neovide == nil,
                dependencies = "copilot.lua",
            },
        },
        -- Docs: https://cmp.saghen.dev/configuration/general.html
        opts = {
            keymap = {
                preset = "none",

                ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
                ["<C-e>"] = { "hide", "fallback" },
                ["<C-y>"] = { "select_and_accept" },
                ["<CR>"] = { "accept", "fallback" },

                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },

                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },

                ["<C-u>"] = { "scroll_documentation_up", "fallback" },
                ["<C-d>"] = { "scroll_documentation_down", "fallback" },
            },
            completion = {
                keyword = {
                    -- "foo_|_bar" will match "foo_" for "prefix" and "foo__bar" for "full"
                    range = "full", -- default: "prefix"
                },
                accept = {
                    auto_brackets = { enabled = false },
                },
                list = {
                    -- per mode config: https://cmp.saghen.dev/recipes#change-selection-type-per-mode
                    selection = { preselect = false, auto_insert = true },
                    -- max_items = 10, -- default: 200
                },
                menu = {
                    -- Docs: https://cmp.saghen.dev/configuration/reference.html#completion-menu-draw
                    draw = {
                        align_to = "none", -- "label" (default), "none", "cursor"
                        -- treesitter = { "lsp" }, -- highlight the label text

                        -- Components to render, grouped by column
                        -- Options: "kind", "kind_icons", "label", "label_description", "source_name"
                        columns = {
                            { "kind_icon" },
                            { "label", "label_description", gap = 1 },
                            { "source_name" },
                        },
                        -- Definitions for possible components to render.
                        components = {
                            source_name = {
                                text = function(ctx)
                                    local custom_source_names = {
                                        Buffer = "[buf]",
                                        LSP = "[LSP]",
                                        Path = "[path]",
                                        Snippets = "[snip]",
                                        cmdline = "[cmd]",
                                        copilot = "[copilot]",
                                        Latex = "[symb]",
                                        LazyDev = "[dev]",
                                        Spell = "[spell]",
                                    }
                                    return custom_source_names[ctx.source_name]
                                end,
                            },
                        },
                    },
                    border = CONFIG.ui.border,
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200, -- default: 500
                    window = { border = CONFIG.ui.border },
                },
                ghost_text = { enabled = CONFIG.ui.ghost_text },
            },
            appearance = {
                kind_icons = require("core.icons").kinds,
            },
            snippets = { preset = "luasnip" },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "spell", "latex" },
                -- Dynamically picking providers by treesitter node/filetype
                -- default = function(ctx)
                --     local success, node = pcall(vim.treesitter.get_node)
                --     if
                --         success
                --         and node
                --         and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
                --     then
                --         return { "buffer" }
                --     elseif vim.bo.filetype == "lua" then
                --         return { "lsp", "path" }
                --     else
                --         return { "lsp", "path", "snippets", "buffer" }
                --     end
                -- end,

                -- Docs: https://cmp.saghen.dev/configuration/reference.html#providers
                providers = {
                    buffer = {
                        min_keyword_length = 1,
                    },
                    cmdline = {
                        min_keyword_length = function(ctx)
                            -- when typing a command, only show when the keyword
                            -- is 2 characters or longer unless a space was typed
                            if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                                return 2
                            end
                            return 0
                        end,
                    },
                    path = {
                        opts = {
                            trailing_slash = false,
                            -- TODO: show hidden ONLY after I type .
                            -- show_hidden_files_by_default = true,
                        },
                    },
                    -- Externals: https://cmp.saghen.dev/configuration/sources.html#community-sources
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                        score_offset = -4, -- prefer snippets over this
                        -- opts = {
                        --     -- EXAMPLE: Only enable source in `@spell` captures, and disable it
                        --     -- in `@nospell` captures.
                        --     enable_in_context = function()
                        --         local curpos = vim.api.nvim_win_get_cursor(0)
                        --         local captures = vim.treesitter.get_captures_at_pos(0, curpos[1] - 1, curpos[2] - 1)
                        --         local in_spell_capture = false
                        --         for _, cap in ipairs(captures) do
                        --             if cap.capture == "spell" then
                        --                 in_spell_capture = true
                        --             elseif cap.capture == "nospell" then
                        --                 return false
                        --             end
                        --         end
                        --         return in_spell_capture
                        --     end,
                        -- },
                    },
                    latex = {
                        name = "Latex",
                        module = "blink-cmp-latex",
                        opts = {
                            -- set to true to insert the latex command instead of the symbol
                            insert_command = false,
                            -- insert_command = function(ctx)
                            --     local ft = vim.api.nvim_get_option_value("filetype", {
                            --         scope = "local",
                            --         buf = ctx.bufnr,
                            --     })
                            --     if ft == "tex" then
                            --         return true
                            --     end
                            --     return false
                            -- end
                        },
                    },
                },
            },
            cmdline = {
                sources = { "path", "buffer", "cmdline" },

                completion = {
                    list = {
                        selection = { preselect = false, auto_insert = true },
                    },
                    menu = { auto_show = true },
                    ghost_text = { enabled = CONFIG.ui.ghost_text },
                },
            },
            signature = {
                enabled = CONFIG.lsp.show_signature_help,
                window = {
                    show_documentation = true,
                    border = CONFIG.ui.border,
                },
            },
        },
        config = function(_, opts)
            -- setup lazydev
            if require("core.util").has_plugin("lazydev") then
                table.insert(opts.sources.default, 1, "lazydev")
                opts.sources.providers.lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                }
            end

            -- setup copilot cmp source
            if require("core.util").has_plugin("copilot") then
                table.insert(opts.sources.default, 1, "copilot")
                opts.sources.providers.copilot = {
                    name = "copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 101, -- show at a higher priority than lsp
                    async = true,
                }
            end

            require("blink.cmp").setup(opts)
        end,
    },

    -- enable type checking to develop neovim
    {
        "folke/lazydev.nvim",
        ft = "lua",
        cmd = "LazyDev",
        opts = {
            library = {
                -- Only load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                --{ path = "LazyVim", words = { "LazyVim" } },
                --{ path = "snacks.nvim", words = { "Snacks" } },
                --{ path = "lazy.nvim", words = { "LazyVim" } },
                -- -- Load the wezterm types when the `wezterm` module is required
                -- -- Needs `justinsgithub/wezterm-types` to be installed
                --{ path = "wezterm-types", mods = { "wezterm" } },
            },
        },
    },

    -- catppuccin support
    {
        "catppuccin",
        optional = true,
        opts = {
            integrations = { blink_cmp = true },
        },
    },
}
