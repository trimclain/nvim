---@diagnostic disable: undefined-global

local function create_conventional_commit_snippet(commit_type, is_breaking)
    local scope_opts, body_start
    if is_breaking then
        scope_opts = { fmt("({})!:", { i(1, "scope") }), t("!:") }
        body_start = commit_type .. "{scope} {}\n\n{}"
    else
        scope_opts = { fmt("({}):", { i(1, "scope") }), t(":") }
        body_start = commit_type .. "{scope} {}"
    end
    local trigger = is_breaking and commit_type .. "!" or commit_type
    local description = commit_type .. " conventional commit" .. (is_breaking and " with breaking changes" or "")
    return s(
        { trig = trigger, desc = description },
        fmt(body_start, {
            scope = c(1, scope_opts),
            i(2, "title"),
            is_breaking and t("BREAKING CHANGE: "),
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
