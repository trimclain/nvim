---@diagnostic disable: undefined-global

return {
    s({ trig = "ign", desc = "pylsp: ignore long lines" }, t("# noqa: E501")),
    s({ trig = "nop", desc = "autopep8: ignore current line" }, t("# nopep8")),
    s({ trig = "fs", desc = "format: ignore start" }, t("# fmt off")),
    s({ trig = "fe", desc = "format: ignore end" }, t("# fmt on")),
}
