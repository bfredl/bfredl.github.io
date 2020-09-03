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
  local w = a.nvim_open_win(b, false, {
    relative="editor";
    width=args.w or 30;
    height=args.h or 1;
    row=args.r or 2;
    col=args.c or 5;
    style=args.style or "minimal";
  })
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
    table.insert(h.toclose, w)
  end
  if args.update and a.nvim_win_is_valid(args.update) then
    -- TODO: actually reconfigure the existing window
    a.nvim_win_close(args.update, false)
  end
  return w
end

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
  for _, w in ipairs(h.toclose) do
    if a.nvim_win_is_valid(w) then a.nvim_win_close(w, false) end
  end
  h.toclose = {}
end

if first_run then
  vim.cmd [[autocmd VimEnter * lua _G._bfredl.vimenter(true)]]
else
  h.vimenter(false)
end
