---@diagnostic disable: undefined-global

local function create_optimization_snippet(optimization_type)
    return s(
        {
            trig = optimization_type,
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
                objective_function = i(1, "objective_function"),
                subject_to_left = i(2, "subject_to_left"),
                subject_to_right = i(3, "subject_to_right"),
                constrains_left = i(4, "constrains_left"),
                constrains_right = i(5, "constrains_right"),
            }
        )
    )
end

return {
    create_optimization_snippet("minimize"),
    create_optimization_snippet("maximize"),
}
