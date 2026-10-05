local M = {}

local buffer = require("emyasa.java.move_type.buffer")

function M.generate_regex(class_name)
    return string.format(
        "[%%s,;%%(}<]%s[%%s,;%%(}%%.>]",
        class_name
    )
end

function M.replace(old_class_name, new_class_name, bufnr)
    local bufnr = bufnr or 0
    local regex = M.generate_regex(old_class_name)

    local lines = buffer.read_buffer_lines(bufnr)

    local index = 0

    while index ~= nil do
        local index_start, index_end = string.find(lines, regex, index)

        if index_start == nil or index_end == nil then
            break
        end

        lines = lines:sub(0, index_start) ..
            new_class_name ..
            lines:sub(index_end, #lines)

        index = index_end
    end

    buffer.write_buffer_lines(lines, bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

return M

