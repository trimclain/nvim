-- tree sitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        -- NOTE: in worst case tree-sitter-cli can be installed using Mason
        enabled = CONFIG.plugins.treesitter and vim.fn.executable("tree-sitter") == 1,
        branch = "main",
        commit = vim.fn.has("nvim-0.12") == 0 and "7caec274fd19c12b55902a5b795100d21531391f" or nil,
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                keys = {
                    {
                        "[c",
                        function()
                            require("treesitter-context").go_to_context()
                        end,
                        desc = "TS: Jump to context (upwards)",
                    },
                },
                config = function()
                    require("treesitter-context").setup({
                        max_lines = 1, -- How many lines the window should span. Values <= 0 mean no limit.
                    })
                end,
            },
        },
        config = function()
            -- List of Parsers: https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md
            local ensure_installed = {
                "python",
                "bash",
                "make",

                -- "go",
                -- "gomod",
                -- "gosum",

                "java",
                -- "kotlin",
                -- "rust",

                "html",
                "css",
                "scss",
                "javascript",
                "typescript",
                -- "tsx",
                "vue",

                -- "julia",
                -- "latex", -- needs tree-sitter CLI installed
                -- "typst"

                "markdown",
                "markdown_inline",
                "regex",

                "json",
                "toml",
                "yaml",

                "sql",
                -- "dockerfile",
                -- "graphql",

                -- should always be installed
                "c",
                "vim",
                "vimdoc",
                "lua",
                "query", -- treesitter query
            }

            if ON_INFERIOR_OS then
                table.insert(ensure_installed, "powershell")
            end

            require("nvim-treesitter").install(ensure_installed)

            ---@param buf integer
            ---@param language string
            ---@diagnostic disable-next-line: unused-local
            local function disable_highlighting(buf, language)
                -- -- disable highlights in tmux due to some errors in the parser
                -- if language == "tmux" then
                --     return true
                -- end
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end

            ---@diagnostic disable-next-line: unused-local
            local function disable_indent(language)
                -- sadly broken right now
                if language == "python" then
                    return true
                end
            end

            ---@param buf integer
            ---@param language string
            local function treesitter_try_attach(buf, language)
                -- check if parser exists and load it
                if not vim.treesitter.language.add(language) then
                    return
                end

                -- enables syntax highlighting and other treesitter features
                if not disable_highlighting(buf, language) then
                    vim.treesitter.start(buf, language)
                end

                -- enables treesitter based folds
                -- for more info on folds see `:help folds`
                -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                -- vim.wo.foldmethod = 'expr'

                -- check if treesitter indentation is available for this language, and if so enable it
                -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
                local has_indent_query = vim.treesitter.query.get(language, "indent") ~= nil

                -- enables treesitter based indentation
                if has_indent_query and not disable_indent(language) then
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end

            -- Auto-install and enable parsers
            local available_parsers = require("nvim-treesitter").get_available()
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf, filetype = args.buf, args.match

                    local language = vim.treesitter.language.get_lang(filetype)
                    if not language then
                        return
                    end

                    local installed_parsers = require("nvim-treesitter").get_installed("parsers")

                    if vim.tbl_contains(installed_parsers, language) then
                        -- enable the parser if it is installed
                        treesitter_try_attach(buf, language)
                    elseif vim.tbl_contains(available_parsers, language) then
                        -- if a parser is available in `nvim-treesitter` auto install it, and enable it after the installation is done
                        require("nvim-treesitter").install(language):await(function()
                            treesitter_try_attach(buf, language)
                        end)
                    else
                        -- try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
                        treesitter_try_attach(buf, language)
                    end
                end,
            })

            -- Reimplement missing commands
            vim.api.nvim_create_user_command("TSBufDisable", function()
                vim.treesitter.stop()
            end, { desc = "Disable Treesitter for current buffer" })
            vim.api.nvim_create_user_command("TSBufEnable", function()
                vim.treesitter.start()
            end, { desc = "Enable Treesitter for current buffer" })

            local function parser_info()
                local icons = require("core.icons").actions
                local lines = {}
                local entries = {}
                local expanded = {}

                -- stylua: ignore
                local longest_parser_name = math.max(0, unpack(vim.tbl_map(function(p) return #p end, available_parsers)))

                local installed = {}
                local uninstalled = {}

                for _, parser in ipairs(available_parsers) do
                    local is_installed = #vim.api.nvim_get_runtime_file("parser/" .. parser .. ".*", false) > 0
                    table.insert(is_installed and installed or uninstalled, parser)
                end

                local all_parser_details = require("nvim-treesitter.parsers")

                local function parser_details(parser)
                    local details = {}

                    local ok, filetypes = pcall(vim.treesitter.language.get_filetypes, parser)
                    if not ok or type(filetypes) ~= "table" or #filetypes == 0 then
                        table.insert(details, "  filetypes: none")
                    else
                        table.sort(filetypes)
                        table.insert(details, "  filetypes: " .. table.concat(filetypes, ", "))
                    end

                    local url = all_parser_details[parser].install_info.url or "none"
                    table.insert(details, "  url:       " .. url)

                    local revision = all_parser_details[parser].install_info.revision or "none"
                    table.insert(details, "  revision:  " .. revision)

                    return details
                end

                local buf = vim.api.nvim_create_buf(false, true)
                local ns_id = vim.api.nvim_create_namespace("parser_status")
                local win, width, height

                local function render()
                    lines = {}
                    entries = {}

                    local function add_section(title, parsers, is_installed)
                        local header = string.format("%s (%d)", title, #parsers)
                        table.insert(lines, "")
                        table.insert(entries, { kind = "spacer" })
                        table.insert(lines, header)
                        table.insert(entries, { kind = "header", text = header })

                        for _, parser in ipairs(parsers) do
                            local icon = is_installed and icons.Check or icons.Close
                            local text = is_installed and " installed" or " not installed"
                            local padding = string.rep(" ", longest_parser_name - #parser + 1)
                            local parser_line = parser .. padding .. icon .. text
                            local status_col = #(parser .. padding)

                            table.insert(lines, parser_line)
                            table.insert(entries, {
                                kind = "parser",
                                parser = parser,
                                installed = is_installed,
                                line = parser_line,
                                status_col = status_col,
                                status_end_col = status_col + #icon,
                            })

                            if expanded[parser] then
                                local details = parser_details(parser)
                                for _, detail in ipairs(details) do
                                    table.insert(lines, detail)
                                    table.insert(entries, {
                                        kind = "details",
                                        parser = parser,
                                        text = detail,
                                    })
                                end
                            end
                        end
                    end

                    add_section("Installed", installed, true)

                    if #installed > 0 and #uninstalled > 0 then
                        table.insert(lines, "")
                        table.insert(entries, { kind = "spacer" })
                    end

                    add_section("Available", uninstalled, false)

                    vim.bo[buf].modifiable = true
                    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
                    vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

                    for row, entry in ipairs(entries) do
                        if entry.kind == "header" then
                            vim.api.nvim_buf_set_extmark(buf, ns_id, row - 1, 0, {
                                end_col = #entry.text,
                                hl_group = "MasonHighlightBlockBold",
                            })
                        elseif entry.kind == "parser" then
                            vim.api.nvim_buf_set_extmark(buf, ns_id, row - 1, 0, {
                                end_col = #entry.parser,
                                hl_group = "Identifier",
                            })

                            vim.api.nvim_buf_set_extmark(buf, ns_id, row - 1, entry.status_col, {
                                end_col = entry.status_end_col,
                                hl_group = entry.installed and "DiagnosticInfo" or "DiagnosticError",
                            })
                        elseif entry.kind == "details" then
                            vim.api.nvim_buf_set_extmark(buf, ns_id, row - 1, 0, {
                                end_col = #entry.text,
                                hl_group = "Comment",
                            })
                        end
                    end

                    vim.bo[buf].modifiable = false

                    -- stylua: ignore
                    local longest_line = math.max(0, unpack(vim.tbl_map(function(line) return #line end, lines)))

                    width = math.min(longest_line + 2, vim.o.columns - 4)
                    height = math.min(#lines, 30)

                    if win and vim.api.nvim_win_is_valid(win) then
                        vim.api.nvim_win_set_config(win, {
                            relative = "editor",
                            width = width,
                            height = height,

                            col = math.floor((vim.o.columns - width) / 2),
                            row = math.floor((vim.o.lines - height) / 2),
                            style = "minimal",
                            title = " TSInstallInfo ",
                            title_pos = "center",
                        })
                    end
                end

                render()

                win = vim.api.nvim_open_win(buf, true, {
                    relative = "editor",
                    width = width,
                    height = height,
                    col = math.floor((vim.o.columns - width) / 2),
                    row = math.floor((vim.o.lines - height) / 2),
                    style = "minimal",
                    title = " TSInstallInfo ",
                    title_pos = "center",
                })

                vim.bo[buf].modifiable = false
                vim.bo[buf].bufhidden = "wipe"

                vim.keymap.set("n", "<CR>", function()
                    local row = vim.api.nvim_win_get_cursor(win)[1]
                    local entry = entries[row]
                    if not entry or (entry.kind ~= "parser" and entry.kind ~= "details") then
                        return
                    end

                    expanded[entry.parser] = not expanded[entry.parser]
                    render()

                    local new_row = row
                    if entry.kind == "details" and not expanded[entry.parser] then
                        new_row = row - 1
                    end

                    vim.api.nvim_win_set_cursor(win, { math.max(1, math.min(new_row, #lines)), 0 })
                end, { buffer = buf, silent = true })

                vim.keymap.set("n", "q", function()
                    if vim.api.nvim_win_is_valid(win) then
                        vim.api.nvim_win_close(win, true)
                    end
                end, { buffer = buf, silent = true })
            end
            vim.api.nvim_create_user_command("TSInstallInfo", parser_info, { desc = "Show Treesitter Parsers Status" })
        end,
    },
}
