meths = b.a
local ns = meths.create_namespace 'test'
for i = 1,9 do
  meths.buf_set_extmark(0, ns, i, 0, { virt_text={{'|', 'LineNr'}}, virt_text_pos='overlay'})
  if i == 3 or (i >= 6 and i <= 9) then
    meths.buf_set_extmark(0, ns, i, 4, { virt_text={{'|', 'NonText'}}, virt_text_pos='overlay'})
  end
end

meths.buf_set_extmark(0, ns, 9, 10, { virt_text={{'foo'}, {'bar', 'MoreMsg'}, {'!!', 'ErrorMsg'}}, virt_text_pos='overlay'})
