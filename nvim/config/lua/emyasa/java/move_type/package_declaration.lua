local M = {}

local buffer = require("emyasa.java.move_type.buffer")

-- generate a regex for looking for package declartions
local function generate_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "package( +)%s( *);",
        mapped
    )
end

function M.replace(old_package_path, new_package_path, bufnr)
    local lines = buffer.read_buffer_lines(bufnr)
    local regex = generate_regex(old_package_path)

    local result = lines:gsub(regex, "package " .. new_package_path .. ";")

    buffer.write_buffer_lines(result, bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

return M

