x = a.create_buf(1,1)
w = f {buf=x, w=50, h=10}

stream = ''

function input(_,a,b,data)
  stream = stream .. data
end

t = a.open_term(x, {on_input=input})
