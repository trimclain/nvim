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

---Detects if a string starts with whitespaces and returns the length of them.
---@param str string The string to check.
---@return integer|nil The length of the leading whitespaces, nil if no leading whitespaces.
local function get_leading_whitespaces_length(str)
    local length = string.len(str)
    for i = 1, length do
        local char = string.sub(str, i, i)
        -- find a non-whitespace character
        if char:match("%S") then
            return i - 1
        end
    end
    -- if the string contains only whitespaces or is empty
    return nil
end

--- Check/uncheck the checkbox or convert the list item into the checkbox in current line
local toggle_checkbox = function()
    local line = vim.api.nvim_get_current_line()
    local leading_whitespace_length = get_leading_whitespaces_length(line)

    if leading_whitespace_length == nil then
        return
    end

    local trimmed_line = string.sub(line, leading_whitespace_length + 1)
    if vim.startswith(trimmed_line, "- [ ] ") then
        trimmed_line = "- [x] " .. string.sub(trimmed_line, 7)
    elseif vim.startswith(trimmed_line, "- [x] ") then
        trimmed_line = "- [ ] " .. string.sub(trimmed_line, 7)
    elseif vim.startswith(trimmed_line, "- ") then
        trimmed_line = "- [ ] " .. string.sub(trimmed_line, 3)
    else
        return
    end

    vim.api.nvim_set_current_line(string.rep(" ", leading_whitespace_length) .. trimmed_line)
end
vim.keymap.set("n", "<C-s>", toggle_checkbox, add_desc("Toggle a checkbox"))

vim.keymap.set("i", "--", "—", opts)
