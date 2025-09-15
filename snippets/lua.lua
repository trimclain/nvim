---@diagnostic disable: undefined-global

return {
    s(
        {
            trig = "repro",
            desc = "Template for repro.lua",
        },
        fmta(
            [[
            vim.env.LAZY_STDPATH = ".repro"
            load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

            require("lazy.minit").repro({
                spec = {
                    <spec>
                },
            })
            ]],
            {
                spec = i(1),
            }
        )
    ),
}
