require("emyasa.java.move_type")

vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*.java",
    callback = function(args)
        local buf = args.buf
        local name = vim.api.nvim_buf_get_name(buf)

        -- only act on empty files
        if vim.api.nvim_buf_line_count(buf) ~= 1 then
            return
        end
        if vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] ~= "" then
            return
        end

        require("emyasa.java.new_type").generate()
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        local ok, err = pcall(function()
            require("emyasa.java.jdtls").setup()
        end)

        if not ok then
            print(err)
            vim.notify("JDTLS setup error:\n" .. err, vim.log.levels.ERROR)
        end
    end,
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
})

vim.keymap.set("n", "K", function()
  vim.lsp.buf.hover()
  vim.cmd("normal! zz")
end)

