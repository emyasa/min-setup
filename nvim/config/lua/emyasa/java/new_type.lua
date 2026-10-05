local M = {}

local JAVA_SRC_ROOT = "src/main/java"

-- -----------------------------
-- Package inference
-- -----------------------------
local function infer_package(filepath)
    local idx = filepath:find(JAVA_SRC_ROOT, 1, true)
    if not idx then return nil end

    local pkg = filepath:sub(idx + #JAVA_SRC_ROOT + 1)
    pkg = pkg:gsub("/[^/]+%.java$", "")
    pkg = pkg:gsub("/", ".")

    if pkg == "" then return nil end
    return pkg
end

-- -----------------------------
-- Tree-sitter safety checks
-- -----------------------------
local function has_package(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "java")
    local tree = parser:parse()[1]
    local root = tree:root()

    for child in root:iter_children() do
        if child:type() == "package_declaration" then
            return true
        end
    end
    return false
end

local function has_type(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "java")
    local tree = parser:parse()[1]
    local root = tree:root()

    for child in root:iter_children() do
        local t = child:type()
        if t == "class_declaration"
            or t == "enum_declaration"
            or t == "interface_declaration"
            or t == "record_declaration"
            then
                return true
            end
        end
        return false
    end

    -- -----------------------------
    -- UI picker
    -- -----------------------------
    local function pick_kind(cb)
        vim.ui.select(
            { "class", "enum", "interface", "record" },
            { prompt = "Create Java type:" },
            cb
        )
    end

    -- -----------------------------
    -- Template generation
    -- -----------------------------
    local function build_lines(kind, name, pkg)
        local lines = {}

        if pkg then
            table.insert(lines, "package " .. pkg .. ";")
            table.insert(lines, "")
        end

        if kind == "interface" then
            table.insert(lines, "public interface " .. name .. " {")
        else
            table.insert(lines, "public " .. kind .. " " .. name .. " {")
        end

        table.insert(lines, "")
        table.insert(lines, "}")

        return lines
    end

    -- -----------------------------
    -- Main entry
    -- -----------------------------
    function M.generate()
        local bufnr = vim.api.nvim_get_current_buf()
        local filepath = vim.api.nvim_buf_get_name(bufnr)

        if filepath == "" or not filepath:match("%.java$") then
            return
        end

        -- Prevent overwriting
        if has_type(bufnr) or has_package(bufnr) then
            return
        end

        local name = vim.fn.expand("%:t:r")
        local pkg = infer_package(filepath)

        pick_kind(function(kind)
            if not kind then return end

            local lines = build_lines(kind, name, pkg)
            vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
            vim.cmd("normal! gg=G")
        end)
    end

    return M

