local M = {}

function M.open_silent(name)
    -- Try to get an existing buffer by name
    local bufnr = vim.fn.bufnr(name)

    -- If it doesn't exist, register it
    if bufnr == -1 then
        bufnr = vim.fn.bufadd(name)
    end

    -- Ensure file contents are loaded into memory
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end

    vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("filetype detect")
    end)

    return bufnr
end

function M.read_buffer_lines(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then
        vim.fn.bufload(bufnr)
    end

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, line_count, true)

    local line_result = ""

    for i, line in ipairs(lines) do
        
        line_result = line_result .. line

        if i < (#lines) then
            line_result = line_result .. "\n"
        end
    end

    return line_result
end

function M.write_buffer_lines(data, bufnr)
    local bufnr = bufnr or 0
    if not vim.api.nvim_buf_get_option(bufnr, "modifiable") then
        vim.api.nvim_buf_set_option(bufnr, "modifiable", true)
    end

    local line_count = vim.api.nvim_buf_line_count(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, line_count, true, utils.split(data, "\n"))
end

function M.replace_buffer(regex, dist, bufnr)
    local line_result = buffer.read_buffer_lines(bufnr)
    local result = line_result:gsub(regex, dist)

    buffer.write_buffer_lines(result, bufnr)
end

return M

