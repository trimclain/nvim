---@diagnostic disable: undefined-global

return {
    s(
        {
            trig = "!",
            dscr = "HTML - Defines a template for a html5 document",
        },
        fmt(
            [[
            <!DOCTYPE html>
            <html lang="{lang}">
            <head>
              <meta charset="UTF-8">
              <meta name="viewport" content="width={width}, initial-scale={scale}">
              <title>{title}</title>
            </head>
            <body>
              {body}
            </body>
            </html>
            ]],
            {
                lang = i(1, "en"),
                width = i(2, "device-width"),
                scale = i(3, "1.0"),
                title = i(4, "Document"),
                body = i(5),
            }
        )
    ),
    s(
        {
            trig = "html5",
            dscr = "HTML - Defines a template for a html5 document with css",
        },
        fmt(
            [[
            <!DOCTYPE html>
            <html lang="{lang}">
              <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <title>{title}</title>
                <link href="{css_link}" rel="stylesheet">
              </head>
              <body>
                {body}
              </body>
            </html>
            ]],
            {
                lang = i(1, "en"),
                title = i(2, "Document"),
                css_link = i(3, "css/style.css"),
                body = i(4),
            }
        )
    ),
}
