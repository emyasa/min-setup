local M = {}

function M.split(search_string, pattern)
  local result = {}
  local end_index = 1
  local start_index = 1

  while end_index ~= nil do
    start_index, end_index = string.find(search_string, pattern, 1, true)

    if start_index ~= nil and end_index ~= nil then
      table.insert(result, string.sub(search_string, 1, start_index - 1))
      search_string = string.sub(search_string, end_index + 1, #search_string)
    end
  end

  table.insert(result, search_string)

  return result
end

function M.split_with_patterns(search_string, patterns)
    local result = {}

    for _, pattern in ipairs(patterns) do
        result = M.split(search_string, pattern)

        if #result > 1 then
            break
        end
        -- The pattern could not be found
    end
    return result
end

-- list all files in a folder
function M.list_folder_contents(folder)
    local result = {}

    local command = "cd '" .. folder .. "' && find * -maxdepth 0 -type f"
    local handle = io.popen(command .. " 2>/dev/null")

    while handle ~= nil do
        local line = handle:read("l")

        if line == nil then
            break
        end

        local l = string.find(line, "%.java$")

        if l ~= nil then
            table.insert(result, folder .. "/" .. line)
        end
    end

    return result
end

function M.generate_import_regex(class_path)
    local mapped = class_path:gsub("%.", "%%.")

    return string.format(
        "import( +)%s( *);( *)(\n?)",
        mapped
    )
end

function M.searchRegex(regex, folder, depth)
    if folder == nil then
        folder = "."
    end

    local args = ""
    if depth ~= nil then
        args = "--max-depth " .. depth .. " "
    end
    local command = string.format(
        "cd '%s' && rg --no-heading --no-messages --type java %s'%s'",
        folder,
        args,
        regex
    )
 
    local result = {}

    local handle = io.popen(command)

    while handle ~= nil do
        local line = handle:read("l")

        if line ~= nil then
            local splitted = M.split(line, ":")
            local file = splitted[1]

            result[file] = true
        else
            break
        end
    end

    local t = {}
    for key, _ in pairs(result) do
        table.insert(t, key)
    end

    return t
end

return M

