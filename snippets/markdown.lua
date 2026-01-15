---@diagnostic disable: undefined-global

-- TODO:
-- - create a dynamic snippetfor tables
-- Reference: https://github.com/rafamadriz/friendly-snippets/blob/main/snippets/markdown.json
-- Docs: https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#textnode

local function capitalize(str)
    return str:sub(1, 1):upper() .. str:sub(2):lower()
end

local function create_callout_snippet(type, trigger, description)
    return s({ trig = trigger, desc = description }, t({ "> [!" .. string.upper(type) .. "]", "> " }))
end

local callout_snippets = {}

for _, type in ipairs({ "note", "tip", "important", "warning", "caution" }) do
    local description = "Insert " .. capitalize(type)
    local short_trigger = type == "important" and "imp" or type:sub(1, 1)
    table.insert(callout_snippets, create_callout_snippet(type, type, description))
    table.insert(callout_snippets, create_callout_snippet(type, short_trigger, description))
end

return callout_snippets
