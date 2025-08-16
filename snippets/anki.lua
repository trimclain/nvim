---@diagnostic disable: undefined-global

return {
    s({ trig = "$", desc = "MathJax inline equation" }, fmt("\\({1}\\)", { i(1) })),
    s({ trig = "[", desc = "MathJax block equation" }, fmt("\\[{1}\\]", { i(1) })),
    s({ trig = "b", desc = "Mathbb" }, fmta("\\mathbb{<1>}", { i(1) })),
    s({ trig = "c", desc = "Mathcal" }, fmta("\\mathcal{<1>}", { i(1) })),
    s({ trig = "e", desc = "Epsilon" }, t("\\varepsilon")),
}
