a = b.a
x = a.create_buf(1,1)
w = f {buf=x, w=79, h=31}


t = a.open_term(x, {on_input=input})
path = "/home/bjorn/config2/docs/pres/smile2.cat"
a.chan_send(t, io.open(path, "r"):read("*a"))

