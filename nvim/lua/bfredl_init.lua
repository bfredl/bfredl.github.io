-- locgic: first_run {{{
local first_run = not _G._bfredl
if first_run then
  _G._bfredl = {}
end
-- }}}
local h = _G._bfredl
local a = vim.api
local v = vim.cmd

function h.exec(block)
  a.nvim_exec(block, false)
end
local exec = h.exec

_G.b = _G._bfredl -- for convenience
-- TODO(bfredl):: _G.h should be shorthand for the currently edited/reloaded .lua module
_G.h = _G._bfredl
_G.a = vim.api -- S H O R T C U T to the API:s

h.counter = h.counter or 0
function h.id()
  h.counter = h.counter + 1
  return h.counter
end

-- test
v [[map <Plug>ch:mw <cmd>lua print("howdy")<cr>]]

require'packer'.startup(function ()
  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim-colorizer.lua'

  use '~/dev/nvim-miniyank'
  use '~/dev/nvim-bufmngr'
  use '~/dev/nvim-luadev'
  use '~/dev/ibus-chords'
end)

function h.snippets_setup()
  local s = require'snippets'
  s.use_suggested_mappings()
  s.snippets = {
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
    };
  }
end

function h.xcolor()
 local out = io.popen("xcolor"):read("*a")
 return vim.trim(out)
end
v 'inoremap <F3> <c-r>=v:lua._bfredl.xcolor()<cr>'

h.toclose = h.toclose or {}

function h.f(args)
  local b,w, oc
  if args.update and a.nvim_win_is_valid(args.update) then
    w = args.update
    b = a.nvim_win_get_buf(w)
    oc = a.nvim_win_get_config(w)
  end

  local b = a.nvim_create_buf(false, true)
  if args.text then
    local text
    if type(args.text) == "string" then
      text = vim.split(text, '\n', true)
    else
      text = args.text
    end
    a.nvim_buf_set_lines(b, 0, -1, true, text)
  end

  local width=args.w or (oc and oc.width) or 30;
  local height=args.h or (oc and oc.height) or 1;
  if args.center == true or args.center == "r" then
    args.r = (vim.o.lines - height) / 2
  end
  if args.center == true or args.center == "c" then
    args.c = (vim.o.columns - width) / 2
  end
  local config = {
    relative="editor";
    width=width;
    height=height;
    row=args.r or 2;
    col=args.c or 5;
    style=args.style or "minimal";
  }
  if w then
    a.nvim_win_set_config(w, config)
    if args.enter then
      a.nvim_set_current_win(w)
    end
  else
    w = a.nvim_open_win(b, args.enter, config)
  end
  if args.blend then
    a.nvim_win_set_option(w, 'winblend', args.blend)
  end
  if args.bg then
    local bg
    if string.sub(args.bg, 1, 1) == "#" then
      -- TODO(bfredl):be smart and reuse hl ids.
      bg = "XXTMP"..h.id()
      require'bfredl_hl'.def_hi(bg, {bg=args.bg})
    else
      bg = args.bg
    end
    a.nvim_win_set_option(w, 'winhl', 'Normal:'..bg)
  end
  if args.chold then
    h.toclose[w] = true
  end
  if args.replace and a.nvim_win_is_valid(args.replace) then
    a.nvim_win_close(args.replace, false)
  end

  local ret
  if args.fn then
    ret = a.nvim__buf_do(b, args.fn)
  end
  return ret or w
end
_G.f = h.f -- HAIII

function h.vimenter(startup)
  h.snippets_setup()
  -- TODO(bfredl): can the reload?
  require'bfredl_hl'.defaults()
  if startup then
    if a.nvim__fork_serve then
      _G.prepfork = true
       a.nvim__fork_serve()
      _G.postfork = true
       -- because reasons
       a.nvim__stupid_test()
    end
  end
end

exec [[
  augroup bfredlua
    au CursorHold * lua _bfredl.cursorhold()
  augroup END
]]

function h.cursorhold()
  for w, k in pairs(h.toclose) do
    if not a.nvim_win_is_valid(w) then
      h.toclose[w] = nil
    elseif k and a.nvim_get_current_win() ~= w then
      a.nvim_win_close(w, false)
      h.toclose[w] = nil
    end
  end
end

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G._bfredl.vimenter(true)]]
else
  h.vimenter(false)
end
