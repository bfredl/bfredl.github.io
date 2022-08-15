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
  newsym = require'bfredl.julia_symbols'
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

local ls = require'luasnip'
local lse = require'luasnip.extras'
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local res = ls.restore_node
local r = lse.rep
local l = lse.lambda
local p = ls.parser.parse_snippet
local fmt = require'luasnip.extras.fmt'.fmt

-- s("for", { t"for (", i(1, "int"), t" ", i(2, "i"), t" = ", i(3, "0"), t"; ", r(2), t' < ', i(4, 'len'), t'; ', r(2), t{'++) {', '\t'}, i(0), t{'','}'}});
function h.setup()
  ls.config.set_config {
    history = true;
    updateevents = 'TextChanged,TextChangedI';
  }
  ls.add_snippets("c", {
    s("for", fmt("for ({} {} = {}; {} < {}; {}++) {{\n\t{}\n}}",
                 { i(1, "size_t"), i(2, "i"), i(3, "0"), r(2), i(4, 'len'), r(2), i(0)}));
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
return h
