---@diagnostic disable: undefined-global

local function create_optimization_snippet(optimization_type)
    return s(
        {
            trig = optimization_type == "minimize" and "min" or "max",
            desc = string.format(
                "Template for a %s program",
                optimization_type == "minimize" and "minimization" or "maximization"
            ),
        },
        fmta(
            string.format(
                [[
                mat(
                  delim: #none, align: #left,
                  "%s", <objective_function>, ;
                  "subject to", <subject_to_left>, <subject_to_right>;
                  #none, <constrains_left>, <constrains_right>;
                )
                ]],
                optimization_type
            ),
            {
                objective_function = i(1, "objective-function"),
                subject_to_left = i(2, "subject-to-left"),
                subject_to_right = i(3, "subject-to-right"),
                constrains_left = i(4, "constrains-left"),
                constrains_right = i(5, "constrains-right"),
            }
        )
    )
end

return {
    create_optimization_snippet("minimize"),
    create_optimization_snippet("maximize"),
    s({ trig = "cent", desc = "Align center" }, fmta("#align(center)[<>]", { i(1) })),
    s(
        { trig = "(%d+)", regTrig = true },
        fmta(
            [[
            #for i in range(<>) {
              <>
            }
            ]],
            {
                f(function(_, s)
                    return s.captures[1]
                end),
                i(1),
            }
        )
    ),
}
