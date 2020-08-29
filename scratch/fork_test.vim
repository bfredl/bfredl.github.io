let x = sockconnect("pipe", "/tmp/temazo2", {'rpc':1})
echo rpcrequest(x, "nvim_eval", "getpid()")
echo rpcrequest(x, "nvim__fork_to")
let y = sockconnect("pipe", "/tmp/nvimpI7fQ7/0", {'rpc':1})
echo rpcrequest(y, "nvim_eval", "getpid()")
" still works:
echo rpcrequest(x, "nvim_eval", "getpid()")
echo rpcrequest(y, "nvim_exec_lua", "return postfork", [])

