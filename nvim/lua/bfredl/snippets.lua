local newsym
if false then
local syms = vim.fn["julia_latex_symbols#get_dict"]()

newsym = {}
for k,v in pairs(syms) do
  if string.sub(k,1,1) == "\\" then
    newsym[string.sub(k,2)] = v
  end
end

f= io.open('timp', 'w')
f:write(vim.inspect(newsym))
f:close()
else
  --newsym = require'bfredl.julia_symbols'
end

local h = {}
h.snippets = {
  _global = {
    todob = "TODO(bfredl):";
    todou = "TODO(upstream):";
    todon = "TODO(neovim):";
    f = "FIXME:";
    re = "return"; -- TODO(bfredl): redundant, integrate snippets with ibus-chords properly
  };
  lua = {
    fun = [[function $1($2)
$0
end]];
    r = [[require]];
    l = [[local $1 = $0]];
  };
  c = {
    vp = "(void *)";
    ['for'] = [[for ($1 $2 = $3; $2 < $4; $2++) {
$0
}]];
  };
  julia = newsym
}

function h.setup_ls()
  ls.add_snippets("c", {
    p("while", "while (${1:true}) {\n\t$0\n}");
  }, {key="c"})
  ls.add_snippets("zig", {
    p("ifc", "if (${1:true}) |${2:x}| {\n\t$0\n}");
    p("c", "const $1 = $0;");
    p("bb", "${1:label}: {\n\t$0\n\tbreak :$1 null;\n}");
  }, {key="zig"})
  ls.add_snippets("lua", {
    p("snap", "screen:snapshot_util()");
  }, {key="zig"})
end

function h.setup(b)
  -- TODO: integrate with deadkeys chords natively
  b.aucmd('FileType', {'c', 'cpp'}, function()
    vim.keymap.set('i', '<Plug>ch:KR', function()
      vim.snippet.expand("for (${1:int} ${2:x} = ${3:0}; $2 < ${4:N}; $2++) {\n\t$0\n}")
    end, {buffer=true})
  end)
end
return h
