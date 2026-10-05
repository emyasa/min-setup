local M = {}

utils = require("emyasa.java.move_type.utils")
buffer = require("emyasa.java.move_type.buffer")

package_declaration = require("emyasa.java.move_type.package_declaration")
class_import = require("emyasa.java.move_type.class_import")
class_declaration = require("emyasa.java.move_type.class_declaration")
import_references = require("emyasa.java.move_type.import_references")

local function get_package_name(path)
    local root_markers = {
        "main/java/",
        "test/java/"
    }

    -- find the relative root path by splitting the array, which is defined root_markers
    local parts = utils.split_with_patterns(path, root_markers)

    -- if any of the root markers could not be found, cancel
    if #parts <= 1 then
        return nil
    end

    -- get the package name by replacing "/" with "."
    local package_name = parts[2]:gsub("/", ".")

    return package_name
end

function M.on_rename_file(old_name, new_name)
    -- extract the folder names from the file names, removes the last part of the path
    local old_folder = old_name:gsub("%/([%w%.]*)$", "")
    local new_folder = new_name:gsub("%/([%w%.]*)$", "")

    -- extract the class names from the path by removing the folder part and the file extension
    local old_class_name = old_name:gsub("^%/(.*)%/", ""):gsub("%.(%w*)$", "")
    local new_class_name = new_name:gsub("^%/(.*)%/", ""):gsub("%.(%w*)$", "")

    -- get package name
    local old_package_name = get_package_name(old_folder)
    local new_package_name = get_package_name(new_folder)

    -- if package name could not be found, cancel the rename event
    if old_package_name == nil or new_package_name == nil then
        return
    end

    -- generate class pathes from the package names and class names
    local old_class_path = old_package_name .. "." .. old_class_name
    local new_class_path = new_package_name .. "." .. new_class_name

    -- fix package, imports, and class declaration for the renamed buffer
    local bufnr = buffer.open_silent(new_name)
    package_declaration.replace(old_package_name, new_package_name, bufnr)
    class_import.add(old_folder, old_package_name, bufnr)
    class_import.remove(new_folder, new_package_name, bufnr)
    class_declaration.replace(old_class_name, new_class_name, bufnr)

    import_references.fix(old_folder, new_folder, 
        old_class_path, new_class_path, old_class_name, new_class_name)
end

return M

