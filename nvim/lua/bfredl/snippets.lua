
local syms = vim.fn["julia_latex_symbols#get_dict"]()
local newsym = {}
for k,v in pairs(syms) do
  if string.sub(k,1,1) == "\\" then
    newsym[string.sub(k,2)] = v
  end
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

function h.setup() -- {{{
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = h.snippets
end
return h
