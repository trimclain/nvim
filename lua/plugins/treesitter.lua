-- tree sitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        enabled = vim.fn.executable("tree-sitter") == 1, -- NOTE: in worst case can be installed using Mason
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
                -- -- sadly broken right now
                -- if language == "julia" then
                --     return true
                -- end
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
        end,
    },
}
