import sys,os
import os.path as path

def dedup(itr):
    l = []
    for item in itr:
        if item not in l:
            l.append(item)
    return l

PATH = os.environ['PATH']
paths = PATH.split(':')
paths = filter(path.exists,paths)
paths = dedup(paths)
new_PATH = ':'.join(paths)
print (new_PATH)
