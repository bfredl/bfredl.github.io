--"a\xcc\x80\xcc\x81"

intext = "foobar"
intext = [[
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed
do eiusmod tempor incididunt ut labore et dolore magna aliqua.
Ut enim ad minim veniam, quis nostrud exercitation
ullamco laboris nisi ut aliquip ex ea commodo consequat.
Duis aute irure dolor in reprehenderit in voluptate velit
esse cillum dolore eu fugiat nulla pariatur. Excepteur
sint occaecat cupidatat non proident, sunt in culpa qui
officia deserunt mollit anim id est laborum.
]]
f = {}
for i = 1,#intext do
  f[#f+1] = string.sub(intext,i,i)
  if string.sub(intext,i,i) ~= "\n" then
    for i = 1,6 do
      randval = math.random(32)-1
      f[#f+1] = "\204".. string.char(128+randval)
    end
  end
end
print(table.concat(f))


