local uv = require'luv'
  -- Create a new signal handler
local signal = uv.new_signal()
-- Define a handler function
uv.signal_start(signal, "sigpipe", function(signal)
  print("warning: got SIGPIPE")
end)

uv.kill(uv.getpid(), 'sigpipe')

uv.run()

