return {
    -- auto pairs
    {
        "windwp/nvim-autopairs",
        cond = CONFIG.plugins.autopairs,
        event = "InsertEnter",
        opts = {
            check_ts = true, -- work with treesitter
            -- ts_config = {
            --     lua = {'string'},-- it will not add a pair on that treesitter node
            --     javascript = {'template_string'},
            --     java = false,-- don't check treesitter on java
            -- },
            disable_filetype = vim.list_extend(
                { "markdown", "text", "vim" },
                require("core.util").get_disabled_filetypes()
            ),
            disable_in_macro = true, -- disable when recording or executing a macro
            -- I use this instead of surround for now
            fast_wrap = {
                map = "<M-e>",
                chars = { "{", "[", "(", '"', "'", "`" },
                pattern = [=[[%'%"%>%]%)%}%,]]=],
                end_key = "$",
                keys = "qwertyuiopzxcvbnmasdfghjkl",
                check_comma = true,
                highlight = "Search",
                highlight_grey = "Comment",
            },
        },
        config = function(_, opts)
            local npairs = require("nvim-autopairs")
            local Rule = require("nvim-autopairs.rule")
            local cond = require("nvim-autopairs.conds")

            npairs.setup(opts)

            -- Create a rule to add spaces between parentheses
            local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
            npairs.add_rules({
                -- Rule for a pair with left-side ' ' and right side ' '
                Rule(" ", " ")
                    -- Pair will only occur if the conditional function returns true
                    :with_pair(
                        function(options)
                            -- We are checking if we are inserting a space in (), [], or {}
                            local pair = options.line:sub(options.col - 1, options.col)
                            return vim.tbl_contains(
                                vim.iter(brackets)
                                    :map(function(v)
                                        return table.concat(v)
                                    end)
                                    :totable(),
                                pair
                            )
                        end
                    )
                    :with_move(cond.none())
                    :with_cr(cond.none())
                    -- We only want to delete the pair of spaces when the cursor is as such: ( | )
                    :with_del(
                        function(options)
                            local col = vim.api.nvim_win_get_cursor(0)[2]
                            local context = options.line:sub(col - 1, col + 2)
                            return vim.tbl_contains(
                                vim.iter(brackets)
                                    :map(function(v)
                                        return table.concat(v, "  ")
                                    end)
                                    :totable(),
                                context
                            )
                        end
                    ),
            })
            -- For each pair of brackets we will add another rule
            for _, bracket in pairs(brackets) do
                npairs.add_rules({
                    -- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
                    Rule(bracket[1] .. " ", " " .. bracket[2])
                        :with_pair(cond.none())
                        :with_move(function(options)
                            return options.char == bracket[2]
                        end)
                        :with_del(cond.none())
                        :use_key(bracket[2])
                        -- Removes the trailing whitespace that can occur without this
                        :replace_map_cr(
                            function(_)
                                return "<C-c>2xi<CR><C-c>O"
                            end
                        ),
                })
            end

            -- Add the rule for Typst math mode
            npairs.add_rules({
                Rule("$", "$", { "typst", "tex" }):with_move(cond.not_before_regex("%$")),
            })

            -- A rule for arrow functions in javascript
            Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
                :use_regex(true)
                :set_end_pair_length(2)
        end,
    },

    -- close tags using treesitter
    {
        "windwp/nvim-ts-autotag",
        cond = CONFIG.plugins.autopairs,
        -- dependencies = "nvim-treesitter",
        event = "InsertEnter",
        config = true,
    },
}
