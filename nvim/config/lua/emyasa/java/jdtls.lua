-- ~/.config/nvim/lua/lsp/jdtls.lua

local M = {}

local function get_jdtls_paths()
    local jdtls_path = vim.fn.stdpath("data") .. "/mason/packages/jdtls"
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true, true)[1]
    assert(launcher, "jdtls launcher not found at " .. jdtls_path)

    local config = jdtls_path .. "/config_mac"
    local lombok = jdtls_path .. "/lombok.jar"

    return launcher, config, lombok
end

local function get_workspace_dir(root_dir)
    local home = os.getenv("HOME")
    local project_name = vim.fn.fnamemodify(root_dir, ":t")
    return home .. "/.cache/jdtls-workspaces/" .. project_name
end

local function setup_keymaps(bufnr)
    local jdtls = require("jdtls")

    local map = function(lhs, rhs, desc)
        vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("<leader>ca", vim.lsp.buf.code_action, "Java code action (add import)")
    map("<leader>gd", vim.lsp.buf.definition, "Go to definition")
    map("<leader>gr", vim.lsp.buf.references, "Go to references")
    map("<leader>gi", vim.lsp.buf.implementation, "Go to implementation")
    map("<leader>rn", vim.lsp.buf.rename, "LSP rename")
end

function M.setup()
    local jdtls = require("jdtls")

    local root_dir = jdtls.setup.find_root({
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
    })

    if not root_dir then
        vim.notify("INFO: not a java project")
        return
    end

    local launcher, os_config, lombok = get_jdtls_paths()
    local workspace_dir = get_workspace_dir(root_dir)

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.workspace.configuration = true

    local cmp_caps = require("cmp_nvim_lsp").default_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, cmp_caps)

    local extendedClientCapabilities = jdtls.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ERROR",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok,
        "-jar", launcher,
        "-configuration", os_config,
        "-data", workspace_dir,
    }

    local settings = {
        java = {
            eclipse = {
                downloadSources = true,
            },
            configuration = {
                updateBuildConfiguration = "interactive",
            },
            maven = {
                downloadSources = true,
            },
            implementationsCodeLens = {
                enabled = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all",
                },
            },
            format = {
                enabled = true,
            },
        },
    }

    local on_attach = function(_, bufnr)
        setup_keymaps(bufnr)

        vim.lsp.codelens.refresh()

        vim.api.nvim_create_autocmd("BufWritePost", {
            buffer = bufnr,
            callback = function()
                pcall(vim.lsp.codelens.refresh)
            end,
        })
    end

    jdtls.start_or_attach({
        cmd = cmd,
        root_dir = root_dir,
        settings = settings,
        capabilities = capabilities,
        init_options = {
            extendedClientCapabilities = extendedClientCapabilities,
        },
        on_attach = on_attach,
    })
end

return M
