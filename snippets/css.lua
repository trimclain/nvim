---@diagnostic disable: undefined-global

return {
    s(
        {
            trig = "cssbody",
            desc = "The minimal CSS to make a website more readable",
        },
        t({
            "body {",
            "    font-family: Open Sans, Arial;",
            "    color: #454545;",
            "    font-size: 16px;",
            "    margin: 2em auto;",
            "    max-width: 800px;",
            "    padding: 1em;",
            "    line-height: 1.4;",
            "    -webkit-hyphens: auto;",
            "    -ms-hyphens: auto;",
            "    hyphens: auto;",
            "}",
        })
    ),
}
