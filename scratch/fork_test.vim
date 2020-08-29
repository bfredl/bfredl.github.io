let x = sockconnect("pipe", "/tmp/temazo", {'rpc':1})
echo rpcrequest(x, "nvim_eval", "getpid()")
echo rpcrequest(x, "nvim__fork_to")
let y = sockconnect("pipe", "/tmp/nvimv2ywyZ/0", {'rpc':1})
echo rpcrequest(y, "nvim_eval", "getpid()")
" still works:
echo rpcrequest(x, "nvim_eval", "getpid()")
