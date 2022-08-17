local M = {}

local fn = vim.fn
local ui = vim.ui

local Job = require("plenary.job")

M.run_poe_task = function()
    local tt_exists, toggle_term = pcall(require, "toggleterm")
    local tasks = {}
    local result
    local ret_val

    Job:new {
        command = "poetry",
        args = { "run", "poe", "--help" },
        on_exit = function(j, return_val)
            ret_val = return_val
            result = j:result()
        end
    }:sync()

    if ret_val == 0 then
        local in_task_section = false
        for i = 1, #result do
            local line = fn.trim(result[i])
            if in_task_section then
                local split_line = fn.split(line)
                if #split_line > 0 then
                    local task_name = split_line[1]
                    table.insert(tasks, { task_name, line })
                end
            else
                if string.find(line, "CONFIGURED TASKS") then
                    in_task_section = true
                end
            end
        end
    else
        print("Error: ", ret_val)
    end

    ui.select(tasks, {
        prompt = 'Select poe task:',
        format_item = function(item)
            return item[2]
        end
    }, function(choice)
        if choice then
            local cmd = "poetry run poe " .. choice[1]
            if tt_exists then
                toggle_term.exec(cmd)
            else
                vim.cmd("terminal " .. cmd)
            end
        end
    end)
end

M.setup = function()
    -- User commands
    vim.api.nvim_create_user_command("PytaskPoe", M.run_poe_task, {})
end

return M
