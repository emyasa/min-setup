local M = {}

buffer = require("emyasa.java.move_type.buffer")
utils = require("emyasa.java.move_type.utils")
symbol_usage = require("emyasa.java.move_type.symbol_usage")

--- will insert an import statement into the content
local function add_import_statement(content, statement)
    local regex = "import( +)([A-Za-z%.]*)( *)%;"

    local start_index, end_index = string.find(content, regex)

    -- if there is no import statement, insert the import statement after the package declaration
    if start_index == nil then
        local regex = "package( +)([A-Za-z%.]*)( *)%;( *)\n"
        start_index, end_index = string.find(content, regex)
        start_index = end_index+1

        statement = "\n" .. statement
    else
        statement = statement .. "\n"
    end

    return content:sub(0, start_index - 1) .. statement .. content:sub(start_index, #content)
end

function M.add(old_folder, old_package_name, bufnr)
    local buffer_content = buffer.read_buffer_lines(bufnr)

    -- load all classes inside the folder
    local contents = utils.list_folder_contents(old_folder)

    for _, file_name in ipairs(contents) do
        local found = string.find(file_name, "(.*)%.java") ~= nil

        if found then
            local parts = utils.split(file_name, "/")
            local last_part = parts[#parts]
            local class_name = utils.split(last_part, "%.java")[1]

            local regex = symbol_usage.generate_regex(class_name)

            local result = string.find(buffer_content, regex)
            if result ~= nil then
                local addition = "import " .. old_package_name .. "." .. class_name .. ";"

                buffer_content = add_import_statement(buffer_content, addition)            
            end
        end
    end

    buffer.write_buffer_lines(buffer_content, bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

function M.remove(new_folder, new_package_name, bufnr)
    local buffer_content = buffer.read_buffer_lines(bufnr)

    local contents = utils.list_folder_contents(new_folder)

    for _, file_name in ipairs(contents) do
        local found = string.find(file_name, "(.*)%.java") ~= nil

        if found then
            local parts = utils.split(file_name, "/")
            local last_part = parts[#parts]
            local class_name = utils.split(last_part, "%.java")[1]

            local regex = utils.generate_import_regex(new_package_name .. "." .. class_name)

            buffer_content = string.gsub(buffer_content, regex, "")
        end
    end

    buffer.write_buffer_lines(buffer_content, bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

return M

