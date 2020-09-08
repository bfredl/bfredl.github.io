local a = vim.api
_G.a = vim.api
tema = a.nvim_create_namespace("temazo")

a.nvim__theme_def(tema, "EndOfBuffer", {background=1234})
a.nvim__theme_def(tema, "Statement", {background=100000, foreground=1234})

runn = {}
mt = {__call = function(...) local a = {...} table.insert(runn, a) end}
metatema = setmetatable({}, mt)

a.nvim__theme_set_provider(tema, metatema)
a.nvim__theme_set(tema, false)

-- later on, do
-- print(vim.inspect(runn[1]))
