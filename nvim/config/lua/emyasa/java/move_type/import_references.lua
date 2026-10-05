local M = {}

local buffer = require("emyasa.java.move_type.buffer")
local utils = require("emyasa.java.move_type.utils")
local import_utils = require("emyasa.java.move_type.import_utils")
local symbol_usage = require("emyasa.java.move_type.symbol_usage")

local function generate_regex(package_path)
    local mapped = package_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);",
        mapped
    )
end

local function delete_references(new_folder, old_class_path)
    local contents = utils.list_folder_contents(new_folder)

    for _, file in ipairs(contents) do
        local bufnr = buffer.open_silent(file)
        local regex = utils.generate_import_regex(old_class_path)
        local lines = buffer.read_buffer_lines(bufnr)
        local result = string.gsub(lines, regex, "")

        buffer.write_buffer_lines(result, bufnr)
        vim.api.nvim_buf_call(bufnr, function() 
            local ok, err = pcall(vim.cmd, "silent! write!")
            if not ok then
                vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
            end
        end)
    end
end

local function add_references(old_folder, new_class_path, old_class_name)
    local contents = utils.searchRegex(old_class_name, old_folder, 1)

    for _, file in ipairs(contents) do
        local bufnr = buffer.open_silent(old_folder .. "/" .. file)

        local lines = buffer.read_buffer_lines(bufnr)
        local addition = "import " .. new_class_path .. ";"

        local result = import_utils.add_import_statement(lines, addition)

        buffer.write_buffer_lines(result, bufnr)
        vim.api.nvim_buf_call(bufnr, function() 
            local ok, err = pcall(vim.cmd, "silent! write!")
            if not ok then
                vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
            end
        end)
    end
end

local function replace_import_declaration(old_class_path, new_class_path, bufnr)
    -- search import statements and replace them with new class path
    local regex = generate_regex(old_class_path)

    buffer.replace_buffer(regex, "import " .. new_class_path .. ";", bufnr)
    vim.api.nvim_buf_call(bufnr, function() 
        local ok, err = pcall(vim.cmd, "silent! write!")
        if not ok then
            vim.notify("Failed to write buffer: " .. err, vim.log.levels.ERROR)
        end
    end)
end

function M.fix(old_folder, new_folder, old_class_path, new_class_path, old_class_name, new_class_name)
    delete_references(new_folder, old_class_path)
    add_references(old_folder, new_class_path, old_class_name)

    local occurences = utils.searchRegex(old_class_name)

    for _, file in ipairs(occurences) do
        local bufnr = buffer.open_silent(file)

        -- replace import and symbol usages of the old class name
        replace_import_declaration(old_class_path, new_class_path, bufnr)
        symbol_usage.replace(old_class_name, new_class_name, bufnr)
    end
end

return M
