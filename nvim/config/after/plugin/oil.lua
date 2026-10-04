vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>oh", require("oil.view").toggle_hidden, {})

require("oil").setup({
    keymaps = {
        ["<C-c>"] = false,
    },
    view_options = {
        show_hidden = false,
    },
})
