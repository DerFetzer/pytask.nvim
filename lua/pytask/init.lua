local M = {}

local fn = vim.fn
local ui = vim.ui

M.run_poe_task = function()
    local tt_exists, toggle_term = pcall(require, "toggleterm")
    local tasks = {}
    local in_task_section = false

    fn.jobstart(
        { "poetry", "run", "poe", "--help" },
        {
            stdout_buffered = true,
            on_stdout = function(_, data)
                if data then
                    for _, l in ipairs(data) do
                        local line = fn.trim(l)
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
                end
            end,
            on_exit = function(_, exit_code)
                if exit_code == 0 then
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
                else
                    print("Error: ", exit_code)
                end
            end
        }
    )
end

M.setup = function()
    -- User commands
    vim.api.nvim_create_user_command("PytaskPoe", M.run_poe_task, {})
end

return M
