-- LSP Server Settings
-- Servers listed here will be autoinstalled
-- Docs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- Config Examples: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- Mason Server List: https://mason-registry.dev/registry/list
local servers = {
    gopls = {
        name = "gopls",
        cond = vim.fn.executable("go") == 1,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
            },
        },
    },
    pylsp = {
        name = "python-lsp-server",
        settings = {
            -- docs: https://github.com/python-lsp/python-lsp-server/blob/develop/CONFIGURATION.md
            pylsp = {
                -- configurationSources = { "flake8" }, -- (one of: 'pycodestyle', 'flake8')
                plugins = {
                    pycodestyle = {
                        ignore = { "E501", "W503" }, -- ignore long lines and old line break rule
                    },
                    yapf = { enabled = false },
                    -- autopep8 = { enabled = false },
                    -- mccabe = { enabled = false },
                    -- preload = { enabled = false },
                    -- pycodestyle = { enabled = false },
                    -- pyflakes = { enabled = false },

                    -- flake8 = { enabled = true },
                    -- pydocstyle = { enabled = true },
                    -- pylint = { enabled = true },
                    -- rope_autoimport = { enabled = true },
                },
            },
        },
    },
    bashls = { name = "bash-language-server", cond = not _G.ON_INFERIOR_OS and vim.fn.executable("node") == 1 }, -- requires node to work
    marksman = { name = "marksman" }, -- markdown
    dockerls = { name = "dockerfile-language-server", cond = not _G.ON_INFERIOR_OS },

    html = { name = "html-lsp" },
    cssls = { name = "css-lsp", cond = not _G.ON_INFERIOR_OS },
    emmet_ls = { name = "emmet-ls", cond = not _G.ON_INFERIOR_OS },
    tailwindcss = { name = "tailwindcss-language-server", cond = not _G.ON_INFERIOR_OS },
    ts_ls = { name = "typescript-language-server", not _G.ON_INFERIOR_OS }, -- Extended: https://github.com/pmizio/typescript-tools.nvim
    vue_ls = { name = "vue-language-server", cond = not _G.ON_INFERIOR_OS }, -- vue-language-server
    graphql = { name = "graphql-language-service-cli", cond = not _G.ON_INFERIOR_OS },
    jsonls = { name = "json-lsp" },
    lemminx = { name = "lemminx", cond = not _G.ON_INFERIOR_OS }, -- xml language server

    -- yamlls = { name = "yaml-language-server" },
    -- texlab = { name = "texlab" }, -- latex
    -- julials = { name = "julia-lsp" },
    -- ansiblels = { name = "ansible-language-server" },
    vimls = { name = "vim-language-server" },
    lua_ls = {
        name = "lua-language-server",
        -- cmd = {...}, -- Override the default command used to start the server
        -- filetypes = { ...}, -- Override the default list of associated filetypes for the server
        -- capabilities = {}, -- Override fields in capabilities. Can be used to disable certain LSP features.
        settings = { -- Override the default settings passed when initializing the server.
            -- docs: https://luals.github.io/wiki/settings/
            Lua = {
                completion = {
                    -- "Disable" - Only show function name (default)
                    -- "Both" - Show function name and snippet
                    -- "Replace" - Only show the call snippet
                    callSnippet = "Replace",
                },

                diagnostics = {
                    globals = { "describe", "it", "before_each", "after_each", "vim" },
                    -- ignore Lua_LS's noisy `missing-fields` warnings
                    -- disable = { 'missing-fields' },
                },
                hint = {
                    enable = true,
                    setType = true,
                    -- semicolon = "Disable" -- default: "SameLine"
                },
                workspace = {
                    checkThirdParty = false,
                },
            },
        },
    },

    powershell_es = {
        name = "powershell-editor-services",
        cond = vim.fn.executable("pwsh") == 1,
        bundle_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "packages", "powershell-editor-services"),
        settings = {
            powershell = {
                codeFormatting = {
                    preset = "Custom", -- using OTBS with additional config
                    newLineAfterCloseBrace = false, -- default: true
                    newLineAfterOpenBrace = false, -- default: true
                    addWhitespaceAroundPipe = true,
                    alignPropertyValuePairs = true,
                    autoCorrectAliases = false,
                    avoidSemicolonsAsLineTerminators = false,
                    ignoreOneLineBlock = true,
                    openBraceOnSameLine = true,
                    pipelineIndentationStyle = "NoIndentation",
                    trimWhitespaceAroundPipe = false,
                    useConstantStrings = false,
                    useCorrectCasing = false,
                    whitespaceAfterSeparator = true,
                    whitespaceAroundOperator = true,
                    whitespaceAroundPipe = true,
                    whitespaceBeforeOpenBrace = true,
                    whitespaceBeforeOpenParen = true,
                    whitespaceBetweenParameters = false,
                    whitespaceInsideBrace = true,
                },
            },
        },
    },
}

local formatters = {
    isort = {},
    autopep8 = {},
    prettierd = {},
    stylua = {},
    shfmt = { cond = not _G.ON_INFERIOR_OS }, -- "beautysh",
    gofumpt = { cond = vim.fn.executable("go") == 1 },
}

local linters = {
    -- eslint_d = {}, -- need config file, annoying
    -- luacheck = {}, -- "selene",
    -- markdownlint = {},
    -- stylelint = {}, -- css linter
    shellcheck = { cond = not _G.ON_INFERIOR_OS }, -- extends bashls
}

return {
    -- LSP Configuration & Plugins
    {
        "neovim/nvim-lspconfig",
        cond = CONFIG.lsp.enabled,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- used by some keymaps
            { "fzf-lua", cond = CONFIG.plugins.use_fzf_lua },
            { "telescope.nvim", cond = not CONFIG.plugins.use_fzf_lua },

            { "blink.cmp", cond = CONFIG.plugins.use_blink_completion },
            { "hrsh7th/cmp-nvim-lsp", cond = not CONFIG.plugins.use_blink_completion },

            "mason.nvim",
            {
                "smjonas/inc-rename.nvim",
                opts = { preview_empty_name = false },
                config = function(_, opts)
                    require("inc_rename").setup(opts)
                end,
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("trimclain_lsp_attach", { clear = true }),
                callback = function(event)
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    local methods = vim.lsp.protocol.Methods

                    -- adjust the border for LSP floating windows
                    vim.lsp.handlers[methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, {
                        border = CONFIG.ui.border,
                        -- Disable the 'No information available' notification in .tsx with hover on tailwind class
                        -- https://github.com/neovim/neovim/blob/25d3b92d071c77aec40f3e78d27537220fc68d70/runtime/lua/vim/lsp/handlers.lua#L360
                        silent = true,
                    })
                    vim.lsp.handlers[methods.textDocument_signatureHelp] =
                        vim.lsp.with(vim.lsp.handlers.signature_help, {
                            border = CONFIG.ui.border,
                        })

                    -- configure diagnostics
                    local icons = require("core.icons")
                    vim.diagnostic.config({
                        severity_sort = true,
                        underline = { severity = vim.diagnostic.severity.ERROR },
                        virtual_text = CONFIG.lsp.virtual_text and { spacing = 4, source = "if_many", prefix = "●" }
                            or false,
                        float = { border = CONFIG.ui.border, source = "if_many" },
                        update_in_insert = false,
                        signs = {
                            text = {
                                [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
                                [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
                                [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
                                [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
                            },
                        },
                    })

                    -----------------------------------------------------------
                    -- Keymaps
                    -----------------------------------------------------------
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    -- INFO:
                    -- These GLOBAL keymaps are created unconditionally when Nvim starts:
                    -- - "grn" is mapped in Normal mode to |vim.lsp.buf.rename()|
                    -- - "gra" is mapped in Normal and Visual mode to |vim.lsp.buf.code_action()|
                    -- - "grr" is mapped in Normal mode to |vim.lsp.buf.references()|
                    -- - "gri" is mapped in Normal mode to |vim.lsp.buf.implementation()|
                    -- - "grt" is mapped in Normal mode to |vim.lsp.buf.type_definition()|
                    -- - "gO" is mapped in Normal mode to |vim.lsp.buf.document_symbol()|
                    -- - CTRL-S is mapped in Insert mode to |vim.lsp.buf.signature_help()|
                    require("which-key").add({ "gr", group = "get-from-lsp" })

                    if CONFIG.plugins.use_fzf_lua then
                        if client and client:supports_method(methods.textDocument_definition) then
                            map("gd", require("fzf-lua").lsp_definitions, "Go to Definitions")
                        end
                        map("grr", require("fzf-lua").lsp_references, "References")
                        map("gri", require("fzf-lua").lsp_implementations, "Implementations")
                        map("grt", require("fzf-lua").lsp_typedefs, "Type Definitions")
                        map("gO", require("fzf-lua").lsp_document_symbols, "Document Symbols")
                    else
                        if client and client:supports_method(methods.textDocument_definition) then
                            map("gd", require("telescope.builtin").lsp_definitions, "Go to Definitions")
                        end
                        map("grr", require("telescope.builtin").lsp_references, "References")
                        map("gri", require("telescope.builtin").lsp_implementations, "Implementations")
                        map("grt", require("telescope.builtin").lsp_type_definitions, "Type Definitions")
                        map("gO", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
                    end

                    if require("core.util").has_plugin("inc-rename.nvim") then
                        vim.keymap.set("n", "grn", function()
                            return ":IncRename " .. vim.fn.expand("<cword>")
                        end, { buffer = event.buf, desc = "LSP: Rename", expr = true })
                    end

                    map("gl", vim.diagnostic.open_float, "Get Line Diagnostics")
                    map("gD", vim.lsp.buf.declaration, "Go to Declaration")

                    -- Diagnostic keymaps
                    local function diagnostic_goto(next, severity)
                        local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
                        severity = severity and vim.diagnostic.severity[severity] or nil
                        return function()
                            go({ severity = severity })
                        end
                    end

                    map("[d", diagnostic_goto(false), "Previous [D]iagnostic")
                    map("]d", diagnostic_goto(true), "Next [D]iagnostic")
                    map("]e", diagnostic_goto(true, "ERROR"), "Next [E]rror")
                    map("[e", diagnostic_goto(false, "ERROR"), "Previous [E]rror")
                    map("]w", diagnostic_goto(true, "WARN"), "Next [W]arning")
                    map("[w", diagnostic_goto(false, "WARN"), "Previous [W]arning")

                    -- Inlay Hints
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        if CONFIG.ui.inlay_hints then
                            vim.lsp.inlay_hint.enable()
                        end
                        map("<leader>oh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                        end, "Toggle Inlay [H]ints")
                    end
                end,
            })
        end,
    },

    -- cmdline tools and lsp servers
    {
        "mason-org/mason.nvim",
        cond = CONFIG.lsp.enabled,
        cmd = "Mason",
        keys = { { "<leader>M", "<cmd>Mason<cr>", desc = "[M]ason" } },
        config = function()
            local icons = require("core.icons")
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = icons.ui.UnicodeCheck,
                        package_uninstalled = icons.ui.UnicodeBallotX,
                        package_pending = icons.ui.UnicodeCircleArrow,
                    },
                    border = CONFIG.ui.border,
                },
            })

            ---------------------------------------------------------------------------------------
            -- Install All Mason Tools
            -- Alternative: "WhoIsSethDaniel/mason-tool-installer.nvim"
            ---------------------------------------------------------------------------------------
            local ensure_installed = vim.tbl_extend("error", servers, formatters, linters)

            local function ensure_tool_installed(tool)
                local cond = ensure_installed[tool].cond
                if cond == false then
                    return
                end

                local mr = require("mason-registry")

                mr:on("package:install:success", function()
                    vim.defer_fn(function()
                        -- trigger FileType event to possibly load this newly installed LSP server
                        require("lazy.core.handler.event").trigger({
                            event = "FileType",
                            buf = vim.api.nvim_get_current_buf(),
                        })
                    end, 100)
                end)

                mr.refresh(function()
                    local p = mr.get_package(ensure_installed[tool].name or tool)

                    -- let me know how u doin
                    local notify = function(msg, lvl)
                        if not lvl then
                            lvl = vim.log.levels.INFO
                        end
                        vim.schedule(function()
                            vim.notify(msg, lvl, { title = "Mason Tool Installer" })
                        end)
                    end
                    -- notify(string.format('%s: installing', p.name))
                    p:once("install:success", function()
                        notify(string.format("%s: successfully installed", p.name))
                    end)
                    p:once("install:failed", function()
                        notify(string.format("%s: failed to install", p.name), vim.log.levels.ERROR)
                    end)

                    if not p:is_installed() then
                        if not p:is_installing() then
                            p:install()
                        end
                    end
                end)
            end

            for tool_name, _ in pairs(ensure_installed) do
                ensure_tool_installed(tool_name)
            end

            ---------------------------------------------------------------------------------------
            -- Configure and Enable LSP Servers
            ---------------------------------------------------------------------------------------
            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local has_blink, blink = pcall(require, "blink.cmp")
            -- TODO: rewrite for nvim 0.11
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {}
            )

            local function configure_and_enable(server, server_settings)
                if server_settings.cond == false then
                    return
                end

                server_settings.capabilities =
                    vim.tbl_deep_extend("force", {}, capabilities, server_settings.capabilities or {})
                vim.lsp.config(server, server_settings)
                vim.lsp.enable(server)
            end

            for server_name, server_settings in pairs(servers) do
                configure_and_enable(server_name, server_settings)
            end
        end,
    },
}
