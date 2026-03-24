-- tree sitter
return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "master",
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
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
        -- keys = {
        --   { "<c-space>", desc = "Increment selection" },
        --   { "<bs>", desc = "Decrement selection", mode = "x" },
        -- },
        opts = {
            ensure_installed = {
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
                "jsonc",
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
            },
            highlight = {
                enable = true,
                disable = function(lang, buf)
                    -- disable highlights in tmux due to some errors in the parser
                    if lang == "tmux" then
                        return true
                    end
                    -- disable slow treesitter highlight for large files
                    --return lang == "cpp" and vim.api.nvim_buf_line_count(bufnr) > 50000
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        return true
                    end
                end,
            },
            indent = {
                enable = true,
                disable = { "julia" }, -- sadly broken right now
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = "<nop>",
                    node_decremental = "<bs>",
                },
            },
        },
        config = function(_, opts)
            -- Prefer git instead of curl in order to improve connectivity in some environments
            require("nvim-treesitter.install").prefer_git = true

            if ON_INFERIOR_OS then
                table.insert(opts.ensure_installed, "powershell")
            end

            -- automatically install missing parsers when entering buffer if `tree-sitter` cli is installed
            if vim.fn.executable("tree-sitter") == 1 then
                opts.auto_install = true
            end

            require("nvim-treesitter.configs").setup(opts)
        end,
    },
}
