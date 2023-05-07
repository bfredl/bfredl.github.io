vim.api.nvim_create_autocmd('CmdlineChanged', {
    pattern = ':',
    callback = function ()
        local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
    end
})
