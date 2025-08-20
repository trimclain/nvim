return {
    -- PERF: it takes 15-25 ms to load on startup
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    cond = CONFIG.lsp.enable_completion,
    -- dependencies = {
    --     -- PERF: it takes 8 ms to load on startup
    --     -- TODO: take the snippets I use and remove this plugin
    --     "rafamadriz/friendly-snippets",
    --     config = function()
    --         require("luasnip.loaders.from_vscode").lazy_load()
    --     end,
    -- },
    opts = {
        update_events = { "TextChanged", "TextChangedI" },
        delete_check_events = "TextChanged",
    },
    config = function(_, opts)
        local luasnip = require("luasnip")
        luasnip.setup(opts)
        luasnip.filetype_extend("javascript", { "javascriptreact", "html" }) -- add jsx and html snippets to js
        luasnip.filetype_extend("javascriptreact", { "javascript", "html" }) -- add js and html snippets to jsx
        luasnip.filetype_extend("typescriptreact", { "javascript", "html" }) -- add js and html snippets to tsx

        -- my own snippets
        -- INFO: these files are reloaded on save
        require("luasnip.loaders.from_lua").lazy_load({
            paths = {
                -- Load local snippets if present
                -- vim.fn.getcwd() .. "/.snippets",
                -- Global snippets
                vim.fn.stdpath("config") .. "/snippets",
            },
        })
    end,
    keys = function()
        local luasnip = require("luasnip")
        return {
            {
                "<C-k>",
                function()
                    -- Fixes the case where a collapsed choice node gets expanded into a new snippet
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    elseif luasnip.expandable() then
                        luasnip.expand({}) -- TODO: remove {} in luasnip v2.5
                    end
                end,
                silent = true,
                mode = { "i", "s" },
            },
            -- stylua: ignore start
            { "<C-j>", function() if luasnip.jumpable(-1) then luasnip.jump(-1) end end, silent = true, mode = { "i", "s" } },
            { "<C-h>", function() if luasnip.choice_active() then luasnip.change_choice(-1) end end, mode = { "i", "s" } },
            { "<C-l>", function() if luasnip.choice_active() then luasnip.change_choice(1) end end, mode = { "i", "s" } },
            -- stylua: ignore end
        }
    end,
}
