local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local r = ls.restore_node

-- NOTE: for future snippets use fmt
-- local fmt = require("luasnip.extras.fmt").fmt

return {
    s("#ign", t("# noqa: E501")), -- pylsp: ignore long lines
    -- TODO: # fmt of \n \n # fmt on
    -- TODO: # nopep8
}
