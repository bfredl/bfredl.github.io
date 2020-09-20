ffi = require'ffi'
ffi.load("/usr/lib/libgit2.so", true)
git2 = require'git2'
repo = git2.Repository.open('/home/bjorn/config2/')
head = repo:head()
head:name()
index = repo:index()
repo:workdir()
repo:config()

