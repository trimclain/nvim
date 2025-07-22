local Util = require("core.util")
local Icons = require("core.icons")

-- LSP Server Settings
-- Servers listed here will be autoinstalled
-- Docs: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- Config Examples: https://github.com/neovim/nvim-lspconfig/tree/master/lsp
-- Mason Server List: https://mason-registry.dev/registry/list
local servers = {
    gopls = {
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
    bashls = { cond = not _G.ON_INFERIOR_OS and vim.fn.executable("node") == 1 }, -- requires node installed
    marksman = {}, -- markdown
    dockerls = { cond = not _G.ON_INFERIOR_OS },

    html = {},
    cssls = { cond = not _G.ON_INFERIOR_OS },
    emmet_ls = { cond = not _G.ON_INFERIOR_OS },
    tailwindcss = { cond = not _G.ON_INFERIOR_OS },
    ts_ls = { not _G.ON_INFERIOR_OS }, -- Extended: https://github.com/pmizio/typescript-tools.nvim
    vue_ls = { cond = not _G.ON_INFERIOR_OS }, -- vue-language-server
    graphql = { cond = not _G.ON_INFERIOR_OS },
    jsonls = {},
    lemminx = { cond = not _G.ON_INFERIOR_OS }, -- xml language server

    -- yamlls = {},
    -- texlab = {}, -- latex
    -- julials = {},
    -- ansiblels = {},
    vimls = {},
    lua_ls = {
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
            {
                "nvim-telescope/telescope.nvim",
                cond = not CONFIG.plugins.use_fzf_lua,
            },
            {
                "ibhagwan/fzf-lua",
                cond = CONFIG.plugins.use_fzf_lua,
            },

            "mason.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                cond = Util.has_plugin("nvim-cmp"),
            },
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
                    vim.diagnostic.config({
                        underline = true,
                        update_in_insert = false,
                        signs = {
                            text = {
                                [vim.diagnostic.severity.ERROR] = Icons.diagnostics.Error,
                                [vim.diagnostic.severity.WARN] = Icons.diagnostics.Warn,
                                [vim.diagnostic.severity.INFO] = Icons.diagnostics.Info,
                                [vim.diagnostic.severity.HINT] = Icons.diagnostics.Hint,
                            },
                        },
                        virtual_text = CONFIG.lsp.virtual_text and { spacing = 4, source = "if_many", prefix = "●" }
                            or false,
                        severity_sort = true,
                        float = {
                            focusable = false,
                            style = "minimal",
                            border = CONFIG.ui.border,
                            source = "if_many",
                            header = "",
                            prefix = "",
                        },
                    })

                    -----------------------------------------------------------
                    -- Keymaps
                    -----------------------------------------------------------
                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    map("<leader>li", "<cmd>LspInfo<cr>", "[L]sp [I]nfo")

                    if CONFIG.plugins.use_fzf_lua then
                        if client and client:supports_method(methods.textDocument_definition) then
                            map("gd", require("fzf-lua").lsp_definitions, "[G]oto [D]efinition")
                        end
                        map("gr", require("fzf-lua").lsp_references, "[G]oto [R]eferences")
                        map("gI", require("fzf-lua").lsp_implementations, "[G]oto [I]mplementation")
                        map("gt", require("fzf-lua").lsp_typedefs, "[G]oto [T]ype Definition")
                        map("<leader>ls", require("fzf-lua").lsp_document_symbols, "Document [S]ymbols")
                    else
                        if client and client:supports_method(methods.textDocument_definition) then
                            map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                        end
                        map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                        map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                        map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
                        map("<leader>ls", require("telescope.builtin").lsp_document_symbols, "Document [S]ymbols")
                    end

                    map("gl", vim.diagnostic.open_float, "[G]et [L]ine Diagnostics")
                    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gK", vim.lsp.buf.signature_help, "Signature Help")

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

                    if Util.has_plugin("inc-rename.nvim") then
                        vim.keymap.set("n", "<leader>lr", function()
                            return ":IncRename " .. vim.fn.expand("<cword>")
                        end, { buffer = event.buf, desc = "LSP: [R]ename", expr = true })
                    else
                        map("<leader>lr", vim.lsp.buf.rename, "[R]ename")
                    end

                    vim.keymap.set(
                        { "n", "v" },
                        "<leader>la",
                        vim.lsp.buf.code_action,
                        { buffer = event.buf, desc = "LSP: Code [A]ction" }
                    )
                    map("<leader>lA", function()
                        vim.lsp.buf.code_action({
                            context = {
                                only = {
                                    "source",
                                },
                                diagnostics = {},
                            },
                        })
                    end, "Source [A]ction")

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
        dependencies = {
            "mason-org/mason-lspconfig.nvim", -- to convert server names to their Mason package names
        },
        cmd = "Mason",
        keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "[M]ason" } },
        opts = {
            ui = {
                icons = {
                    package_installed = Icons.ui.UnicodeCheck,
                    package_uninstalled = Icons.ui.UnicodeBallotX,
                    package_pending = Icons.ui.UnicodeCircleArrow,
                },
                border = CONFIG.ui.border,
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)

            ---------------------------------------------------------------------------------------
            -- Install All Mason Tools
            -- Alternative: "WhoIsSethDaniel/mason-tool-installer.nvim"
            ---------------------------------------------------------------------------------------
            local ensure_installed = vim.tbl_extend("error", servers, formatters, linters)
            local mlsp_mappings = require("mason-lspconfig").get_mappings()
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
                    local name = mlsp_mappings.lspconfig_to_package[tool] or tool
                    local p = mr.get_package(name)

                    -- let me know how u doin
                    local notify = function(msg, lvl)
                        if not lvl then
                            lvl = vim.log.levels.INFO
                        end
                        vim.notify(msg, lvl, { title = "Mason Tool Installer" })
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
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {},
                has_blink and blink.get_lsp_capabilities() or {},
                opts.capabilities or {}
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
