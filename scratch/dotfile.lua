nss = a.create_namespace 'sssss'
for i = 1,22 do
  a.buf_set_extmark(1, nss, 2, i, {end_row=3, end_col=i})
  -- GO TO BED, IN A MUNKY
end
require'luadev'.print(a._buf_dotfile_extmarks(1))
