ffi = require'ffi'
ffi.load("/usr/lib/libgit2.so", true)
git2 = require'git2'
repo = git2.Repository.open('/home/bjorn/config2/')
head = repo:head()
db = repo:odb()
re = head:resolve()
s = head:target()
so = db:read(s)
so:data()
git2.Object(repo)
sc = git2.Commit.lookup(repo, s)
st = sc:tree()
st:entrycount()
e = st:entry_byindex(1)
e:name()
blob = e:object(repo)
blob:rawcontent()

head:name()
index = repo:index()
repo:workdir()
repo:config()

