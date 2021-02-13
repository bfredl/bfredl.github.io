function myomni(findstart, base)
  vim.fn.complete(3, {'aa', 'rooo', 'bee'})
  return -2
end
vim.bo.omnifunc='v:lua.myomni'
