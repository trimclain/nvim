-------------------------------------------------------------------------------
-- Measure Performance of a Code Block
-------------------------------------------------------------------------------
---@Usage:
-- local Timer = require("core.util.timer")
-- Timer.start("My Cool Code Block")
-- ...some stuff that takes time...
-- Timer.stop()

local M = {}

--- Start the timer
---@param name string? Name of the timer
function M.start(name)
    name = name or "It"
    vim.b.timer_name = name
    vim.b.start_time = vim.fn.reltime()
end

local function time_passed(start_time)
    local seconds = vim.fn.reltimefloat(vim.fn.reltime(start_time))
    local milliseconds = seconds * 1000
    return milliseconds
end

--- Stop the timer and print the results
function M.stop()
    local result_time_passed = time_passed(vim.b.start_time)
    require("core.util.notify").defer_notify(vim.b.timer_name .. " took " .. result_time_passed .. "ms", "Performance Debugger")
    vim.b.start_time, vim.b.timer_name = nil, nil
end

return M
