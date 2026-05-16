---@diagnostic disable: unused-local
-----------------------------------------------------------------------------------------------------------
-- My Snippets for LuaSnip
-- Documentation: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md
-- Loading from lua: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
-----------------------------------------------------------------------------------------------------------

-- NOTE: I'm trying to replace friendly-snippets. Reference:
-- https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/

local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node
local fmt = require("luasnip.extras.fmt").fmt

local all_snippets = {
    -- s(
    --     { trig = "cu", desc = "config update commit" },
    --     fmt("chore{scope}: update config", {
    --         scope = c(1, {
    --             t(""),
    --             fmt("({})", { i(1, "scope") }),
    --         }),
    --     })
    -- ),

    --- Ported from: https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/global.json
    -- s({ trig = "copyright", desc = "Snippet to put copyright" }, {
    --     t("Copyright (c) "),
    --     f(function(args, snip)
    --         return snip.env.CURRENT_YEAR
    --     end, {}),
    --     t(" "),
    --     i(1, "Author"),
    --     t(". All Rights Reserved."),
    -- }),
    -- s({ trig = "diso", desc = "ISO date time stamp" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_YEAR
    --             .. "-"
    --             .. snip.env.CURRENT_MONTH
    --             .. "-"
    --             .. snip.env.CURRENT_DATE
    --             .. "T"
    --             .. snip.env.CURRENT_HOUR
    --             .. ":"
    --             .. snip.env.CURRENT_MINUTE
    --             .. ":"
    --             .. snip.env.CURRENT_SECOND
    --     end, {}),
    -- }),
    -- s({ trig = "date", desc = "Put the date in (Y-m-D) format" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_YEAR .. "-" .. snip.env.CURRENT_MONTH .. "-" .. snip.env.CURRENT_DATE
    --     end, {}),
    -- }),
    -- s({ trig = "dateDMY", desc = "Put date in (DD/MM/YY) format" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_DATE .. "/" .. snip.env.CURRENT_MONTH .. "/" .. snip.env.CURRENT_YEAR
    --     end, {}),
    -- }),
    -- s({ trig = "dateMDY", desc = "Put the date in (m/D/Y) format" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_MONTH .. "/" .. snip.env.CURRENT_DATE .. "/" .. snip.env.CURRENT_YEAR
    --     end, {}),
    -- }),
    -- s({ trig = "time", desc = "I give you back the time (H:M)" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_HOUR .. ":" .. snip.env.CURRENT_MINUTE
    --     end, {}),
    -- }),
    -- s({ trig = "timeHMS", desc = "I give you back the time (H:M:S)" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_HOUR .. ":" .. snip.env.CURRENT_MINUTE .. ":" .. snip.env.CURRENT_SECOND
    --     end, {}),
    -- }),
    -- s({ trig = "datetime", desc = "I give you back the time and date (Y-m-d H:M)" }, {
    --     f(function(_, snip)
    --         return snip.env.CURRENT_YEAR
    --             .. "-"
    --             .. snip.env.CURRENT_MONTH
    --             .. "-"
    --             .. snip.env.CURRENT_DATE
    --             .. " "
    --             .. snip.env.CURRENT_HOUR
    --             .. ":"
    --             .. snip.env.CURRENT_MINUTE
    --     end, {}),
    -- }),
    s(
        { trig = "uuid", desc = "A Version 4 UUID" },
        f(function(_, snip)
            return snip.env.UUID
        end, {})
    ),

    s(
        { trig = "colors", desc = "define ANSI colors" },
        f(function()
            local eq = "="
            if vim.bo.filetype == "python" then
                eq = " = "
            end

            return {
                string.format(vim.bo.commentstring, "ANSI Colors"),
                "RESET" .. eq .. '"\\033[0m"',
                "RED" .. eq .. '"\\033[31m"',
                "GREEN" .. eq .. '"\\033[32m"',
                "YELLOW" .. eq .. '"\\033[33m"',
                "BLUE" .. eq .. '"\\033[34m"',
                "MAGENTA" .. eq .. '"\\033[35m"',
                "CYAN" .. eq .. '"\\033[36m"',
                "BOLD" .. eq .. '"\\033[1m"',
                "ITALIC" .. eq .. '"\\033[3m"',
            }
        end, {})
    ),
}

return all_snippets
