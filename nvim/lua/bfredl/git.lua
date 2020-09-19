ffi = require'ffi'
ffi.load("/usr/lib/libgit2.so", true)
ffi.cdef [[ void git_libgit2_init(void); ]]
ffi.C.git_libgit2_init()
git2 = require'git2'
repo = git2.Repository.open('/home/bjorn/config2/')
