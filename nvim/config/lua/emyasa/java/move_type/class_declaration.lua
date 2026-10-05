local M = {}

local buffer = require("emyasa.java.move_type.buffer")

function M.replace(old_class_name, new_class_name, bufnr)
    local line_result = buffer.read_buffer_lines(bufnr)

    local regex = string.format(
        "class(%%s+)%s(%%s*){",
        old_class_name
    )

    local start_index, end_index = string.find(line_result, regex)

    if start_index == nil then
        local regex = string.format(
            "interface(%%s+)%s(%%s*){",
            old_class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        local regex = string.format(
            "enum(%%s+)%s(%%s*){",
            old_class_name
        )

        start_index, end_index = string.find(line_result, regex)
    end

    if start_index == nil then
        return
    end

    local sub = string.sub(line_result, start_index, end_index)

    local index = string.find(sub, old_class_name)

    local dist_index = start_index + index - 1;

    local result = string.sub(line_result, 0, dist_index - 1) ..
    new_class_name ..
    string.sub(line_result, dist_index + #old_class_name, #line_result)

    buffer.write_buffer_lines(result, bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

return M

