from collections import defaultdict

lines = list(open("maaaa"))

lines

tracecount = defaultdict(int)
onecount = defaultdict(int)
allcount = 0

i = 0
while i < len(lines):
    line = lines[i]
    if line.startswith("@freeto["):
        kollect = []
        while True:
            i = i + 1
            theline = lines[i].strip()
            if theline.startswith("0x"):
                kollect.append(theline)
            else:
                break
        x,y = theline.split()
        if x != "]:":
            raise "gooof"
        drr = ':'.join(kollect)
        ival = int(y)
        allcount += ival
        tracecount[drr] += ival
        position = 1
        onecount[kollect[position]] += ival
    i = i + 1
print(allcount)

sum(onecount.values())

laa = sorted(onecount.items(), key=lambda x: x[1])
laa[-10:]

print()
for item,jtem in laa:
    print(item)
    #print(f'0x{int(item, base=0)-0x13362fb:x}')
    print("count_"+str(jtem))
f'0x{0x555556ef307e-0x199f07e:x}'
