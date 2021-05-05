local ns = a.create_namespace'laa'
--
a.buf_clear_namespace(0, ns, 0, -1)
a.buf_set_extmark(0, ns, 2, 0, { virt_text = {{'xy', 'ErrorMsg'}}, virt_text_win_col=0})
a.buf_set_extmark(0, ns, 3, 0, { virt_text = {{'++', 'LineNr'}}, virt_text_win_col=2})
a.buf_set_extmark(0, ns, 1, 0, { virt_text = {{'harra', 'Identifier'}}, virt_text_pos="right_align"})

