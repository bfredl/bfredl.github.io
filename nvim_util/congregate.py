from collections import defaultdict

lines = list(open("wabang"))

lines

tracecount = defaultdict(int)
onecount = defaultdict(int)
allcount = 0

i = 0
while i < len(lines):
    line = lines[i]
    if line.startswith("@whereto["):
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
        onecount[kollect[-1]] += ival
    i = i + 1
print(allcount)

onecount
