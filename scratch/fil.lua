local handle = io.popen("git rev-parse --is-inside-work-tree")
local isGit = handle:read("*a")
print(isGit)
