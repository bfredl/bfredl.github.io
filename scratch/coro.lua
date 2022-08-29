function coroutinize(f, ...)
    local co = coroutine.create(f)
    local function exec(...)
        local ok, data = coroutine.resume(co, ...)
        if not ok then
            error(debug.traceback(co, data))
        end
        if coroutine.status(co) ~= "dead" then
            data(exec)
        end
    end
    exec(...)
end

coroutinize(function()
  print('x')
  for i = 1,10 do
    coroutine.yield(vim.schedule)
    os.execute"sleep 0.3"
    print('foo', i)
  end
  print('y')
end)

