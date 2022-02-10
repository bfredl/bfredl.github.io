-- create plugin files for test
local packpath = "./mypackpath"
vim.fn.mkdir(packpath, "p")
local lua_dir = packpath .. "/pack/mypackage/start/myplugin/autoload/"
vim.fn.mkdir(lua_dir, "p")
io.open(lua_dir .. "myplugin.vim", "w"):close()

vim.cmd("set packpath^=" .. packpath)
--vim.cmd("set rtp^=" .. packpath)
vim.cmd("packloadall")

print(vim.api.nvim_get_runtime_file("autoload/myplugin.vim", false)[1]) -- nil
print(table.concat(vim.api.nvim_list_runtime_paths(), ";"):find("start/myplugin") ~= nil) -- false
