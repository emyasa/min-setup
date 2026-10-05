local M = {}

function M.add_import_statement(content, statement)
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

return M

