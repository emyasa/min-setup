local java_rename = require("emyasa.java.move_type.rename")

vim.api.nvim_create_autocmd("User", {
  pattern = "OilFileRenamed",
  callback = function(ev)
    local d = ev.data
    print(d.src)
    print(d.dest)

    java_rename.on_rename_file(d.src, d.dest)
  end,
})

