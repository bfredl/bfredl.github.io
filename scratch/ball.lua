vim.cmd [[luafile redball.lua]]

byttar = {}
for _,c in ipairs(redball) do
  table.insert(byttar, string.char(c))
end

vallle = table.concat(byttar)

fil = io.open("dummmpar.mpack", 'w')
fil:write(vallle)
fil:close()


tablet = vim.mpack.decode(vallle)


