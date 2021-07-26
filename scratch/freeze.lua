-- raaaaaaaaaaaa
vim.fn.inputsave();
local x = vim.fn.input('test')
vim.fn.inputrestore();
print(x)
