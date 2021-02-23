meths = b.a
local ns = meths.create_namespace 'test'
meths.buf_set_extmark(0, ns, 0, 0, { virt_text={{'|', 'LineNr'}}, virt_text_style='overlay'})
meths.buf_set_extmark(0, ns, 0, 4, { virt_text={{'|', 'NonText'}}, virt_text_style='overlay'})
meths.buf_set_extmark(0, ns, 0, 10, { virt_text={{'foo'}, {'bar', 'MoreMsg'}, {'!!', 'ErrorMsg'}}, virt_text_style='overlay'})
