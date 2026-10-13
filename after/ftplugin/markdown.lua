local tabwidth = 2
vim.opt_local.shiftwidth = tabwidth
vim.opt_local.softtabstop = tabwidth
vim.opt_local.tabstop = tabwidth

vim.opt_local.colorcolumn = "120"
vim.opt_local.textwidth = 120

-- buffer set to true means the keymap is set only in the buffer this was sourced in
local opts = { noremap = true, silent = true, buffer = true }
local add_desc = function(desc)
    return vim.tbl_extend("error", opts, { desc = desc })
end

vim.b.todo_list_bufnr = vim.fn.bufnr()
vim.b.is_todo_list = false

--- Toggle writing TODO lists in current markdown buffer
local toggle_inserting_checkboxes = function()
    if vim.b.is_todo_list == false then
        vim.keymap.set("i", "<cr>", "<cr>- [ ] ", { buffer = vim.b.todo_list_bufnr })
        vim.b.is_todo_list = true
        vim.notify("Enabled TODO List")
    else
        vim.keymap.del("i", "<cr>", { buffer = vim.b.todo_list_bufnr })
        vim.b.is_todo_list = false
        vim.notify("Disabled TODO List")
    end
end
vim.keymap.set("n", "<leader>td", toggle_inserting_checkboxes, add_desc("Toggle inserting checkboxes on Enter"))

-- Follow the link to a header in current (probably not only) file
local function follow_markdown_heading_on_current_line()
    local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown_inline")
    if not ok or not parser then
        return false
    end

    local tree = parser:parse()[1]
    if not tree then
        return false
    end

    local root = tree:root()
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local query = vim.treesitter.query.parse("markdown_inline", "(inline_link) @link")

    local best_node, best_col
    for _, node in query:iter_captures(root, 0, row, row + 1) do
        local sr, sc, _, _ = node:range()
        if sr == row then
            if not best_col or sc < best_col then
                best_node = node
                best_col = sc
            end
        end
    end

    if not best_node then
        return false
    end

    local sr, sc = best_node:range()
    vim.api.nvim_win_set_cursor(0, { sr + 1, sc })
    vim.lsp.buf.definition()
    return true
end
vim.keymap.set("n", "<cr>", follow_markdown_heading_on_current_line, add_desc("Follow heading link on current line"))

--- Check/uncheck a checkbox or convert a list item into a checkbox.
--- In Visual mode, apply to every line touched by the selection.
local toggle_checkbox = function()
    local first_line = vim.fn.line(".")
    local last_line = first_line

    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
        local selection_start = vim.fn.getpos("v")[2]
        first_line = math.min(selection_start, last_line)
        last_line = math.max(selection_start, last_line)
    end

    local lines = vim.api.nvim_buf_get_lines(0, first_line - 1, last_line, false)
    local changed = false

    for i, line in ipairs(lines) do
        -- Preserve the original indentation, including tabs.
        local indentation, trimmed_line = line:match("^(%s*)(.*)$")
        local replacement

        if vim.startswith(trimmed_line, "- [ ] ") then
            replacement = "- [x] " .. string.sub(trimmed_line, 7)
        elseif vim.startswith(trimmed_line, "- [x] ") then
            replacement = "- [ ] " .. string.sub(trimmed_line, 7)
        elseif vim.startswith(trimmed_line, "- ") then
            replacement = "- [ ] " .. string.sub(trimmed_line, 3)
        end

        if replacement then
            lines[i] = indentation .. replacement
            changed = true
        end
    end

    if changed then
        vim.api.nvim_buf_set_lines(0, first_line - 1, last_line, false, lines)
    end
end

vim.keymap.set({ "n", "x" }, "<C-s>", toggle_checkbox, add_desc("Toggle a checkbox"))

-- vim.keymap.set("i", "--", "—", opts)
