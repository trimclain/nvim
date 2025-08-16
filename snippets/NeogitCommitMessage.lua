---@diagnostic disable: undefined-global

local function create_conventional_commit_snippet(commit_type, is_breaking)
    local scope_opts
    if is_breaking then
        scope_opts = { fmt("({})!:", { i(1, "scope") }), t("!:") }
    else
        scope_opts = { fmt("({}):", { i(1, "scope") }), t(":") }
    end
    local trigger = is_breaking and commit_type .. "!" or commit_type
    local description = commit_type .. " conventional commit" .. (is_breaking and " with breaking changes" or "")
    return s(
        { trig = trigger, desc = description },
        fmt(commit_type .. "{scope} {}\n\n{}", {
            scope = c(1, scope_opts),
            i(2, "title"),
            is_breaking and t("BREAKING CHANGE: ") or i(0),
        })
    )
end

local cc_snippets = {
    -- s("BREAK", fmt("BREAKING CHANGE: {}", { i(0) })),
    s("co", fmt("Co-authored-by: {} <{}>", { i(1, "name"), i(2, "email") })),
    s("si", fmt("Signed-off-by: {} <{}>", { i(1, "name"), i(2, "email") })),
    s("on", fmt("On-behalf-of: {} <{}>", { i(1, "org"), i(2, "email") })),
}
for _, commit_type in ipairs({
    "build",
    "chore",
    "ci",
    "docs",
    "feat",
    "fix",
    "perf",
    "refactor",
    "revert",
    "style",
    "test",
}) do
    table.insert(cc_snippets, create_conventional_commit_snippet(commit_type))
    table.insert(cc_snippets, create_conventional_commit_snippet(commit_type, true))
end

local all_snippets = {
    s({ trig = "ll", desc = "lazy-lock update commit" }, { t("chore: update lazy-lock") }),
    s({ trig = "du", desc = "docs update commit" }, { t("docs: update README") }),
    s(
        { trig = "cu", desc = "config update commit" },
        fmt("chore{scope}: update config", {
            scope = c(1, {
                t(""),
                fmt("({})", { i(1, "scope") }),
            }),
        })
    ),
}

return vim.list_extend(all_snippets, cc_snippets)
