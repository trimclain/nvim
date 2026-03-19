-------------------------------------------------------------------------------
-- Send Notifications
-------------------------------------------------------------------------------
local M = {}

--- Send a notification
---@param msg string Content of the notification to show to the user
---@param title string Title of the notification window
---@param level number? One of the values from vim.log.levels, default: vim.log.levels.INFO
function M.notify(msg, title, level)
    level = level or vim.log.levels.INFO
    vim.notify(msg, level, { title = title })
end

--- Defer sending a notification
---@param msg string Content of the notification to show to the user
---@param title string Title of the notification window
---@param level number? One of the values from vim.log.levels, default: vim.log.levels.INFO
---@param timeout number? Number of milliseconds to wait, default: 500
function M.defer_notify(msg, title, level, timeout)
    timeout = timeout or 500
    vim.defer_fn(function()
        M.notify(msg, title, level)
    end, timeout)
end

return M
