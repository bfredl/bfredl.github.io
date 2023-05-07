function doit()
end
vim.api.nvim_create_autocmd({"TextChangedT"}, {
  callback = function()
    ge = ge or 0
    ge = ge + 1
    print(ge)
  end})
