meths = b.a
ns = meths.create_namespace 'test'
meths.buf_clear_namespace(0, ns, 0, -1)
vim.cmd [[hi Boldy gui=bold blend=50]]
meths.buf_set_extmark(0, ns, 4, 0, { virt_text={{'|', 'LineNr'}}, virt_text_pos='overlay'})
meths.buf_set_extmark(0, ns, 5, 22, { virt_text={{'r aaaaa', 'Boldy'}}, virt_text_pos='overlay', hl_mode='combine'})
meths.buf_set_extmark(0, ns, 6, 15, { virt_text={{'fuu   u u u  ee', 'Boldy'}}, virt_text_pos='overlay', hl_mode='blend', virt_text_hide=true})

for i = 1,9 do
  if i == 3 or (i >= 6 and i <= 9) then
    --meths.buf_set_extmark(0, ns, i, 4, { virt_text={{'|', 'NonText'}}, virt_text_pos='overlay'})
  end
end

meths.buf_set_extmark(0, ns, 9, 10, { virt_text={{'foo'}, {'bar', 'MoreMsg'}, {'!!', 'ErrorMsg'}}, virt_text_pos='overlay'})
