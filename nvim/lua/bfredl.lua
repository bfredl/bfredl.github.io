-- logic: first_run, setup module and _G {{{
local first_run = not _G.bfredl
if first_run then
  _G.bfredl = {}
end
local h = _G.bfredl
_G.b = _G.bfredl -- for convenience

-- TODO(bfredl):: _G.h should be shorthand for the _last_ edited/reloaded .lua module
_G.h = _G.bfredl


-- }}}
 -- packages {{{
require'packer'.startup(function ()
  use 'norcalli/snippets.nvim'
  use 'norcalli/nvim-colorizer.lua'
  use 'vim-conf-live/pres.vim'
  use 'norek/bork'

  use 'nvim-lua/plenary.nvim'

  use '~/dev/nvim-miniyank'
  use '~/dev/nvim-bufmngr'
  use '~/dev/nvim-luadev'
  use '~/dev/ibus-chords'
end)

-- }}}
-- util {{{
--
function h.unprefix(str, pre, to)
  local res = nil
  if vim.startswith(str, pre) then
    local val = string.sub(str, string.len(pre)+1)
    if to then
      return to(val)
    else
      return val
    end
  end
  return nil
end

h.counter = h.counter or 0
function h.id()
  h.counter = h.counter + 1
  return h.counter
end
-- }}}
-- API shortcuts {{{

h.a = {}
h.buf, h.win, h.tabpage = {}, {}, {}
local a, buf, win, tabpage = h.a, h.buf, h.win, h.tabpage
_G.a, _G.buf, _G.win, _G.tabpage = h.a, h.buf, h.win, h.tabpage

for k,v in pairs(vim.api) do
  a[k] = v
  h.unprefix(k, 'nvim_', function (x)
    a[x] = v
    h.unprefix(x, 'buf_', function (m)
      buf[m] = v
    end)
    h.unprefix(x, 'win_', function (m)
      win[m] = v
    end)
    h.unprefix(x, 'tabpage_', function (m)
      tabpage[m] = v
    end)
    h.unprefix(x, '_buf_', function (m)
      buf['_'..m] = v
    end)
  end)
end

local v = vim.cmd
function h.exec(block)
  a.exec(block, false)
end
local exec = h.exec
-- }}}
-- them basic bindings {{{
-- test
v [[map <Plug>ch:mw <cmd>lua print("howdy")<cr>]]

-- TODO(bfredl): reload all the filetypes when reloading bfredl.lua
v [[
  augroup bfredlft
    au FileType lua noremap <Plug>ch:,l <cmd>update<cr><cmd>luafile %<cr>
    au FileType lua noremap <Plug>ch:un <cmd>update<cr><cmd>luafile %<cr>
  augroup END
]]

-- }}}
-- vimenter stuff {{{
local colors
function h.vimenter(startup)
  require'plenary.reload'.reload_module'bfredl.'
  h.snippets_setup()
  colors = require'bfredl.colors'
  colors.defaults()
  h.colors = colors
  if startup then
    if a._fork_serve then
      _G.prepfork = true
       a._fork_serve()
      _G.postfork = true
       -- because reasons
       a._stupid_test()
    end
  end
end -- }}}
function h.snippets_setup() -- {{{
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
end -- }}}
-- xcolor {{{
function h.xcolor()
 local out = io.popen("xcolor"):read("*a")
 return vim.trim(out)
end
v 'inoremap <F3> <c-r>=v:lua.bfredl.init.xcolor()<cr>'
-- }}}
-- floaty stuff {{{
h.toclose = h.toclose or {}

function h.f(args)
  local b,w, oc
  if args.update and win.is_valid(args.update) then
    w = args.update
    b = win.get_buf(w)
    oc = win.get_config(w)
  end
  if args.buf and buf.is_valid(args.buf) then
    b = args.buf
  else
    b = a.nvim_create_buf(false, true)
  end
  local firstline = ""
  local text
  if args.text then
    if type(args.text) == "string" then
      text = vim.split(args.text, '\n', true)
    else
      text = args.text
    end
    firstline = text[1] or ""
    a.nvim_buf_set_lines(b, 0, -1, true, text)
  end

  local p_rows, p_cols = vim.o.lines-1, vim.o.columns
  if args.win then
    p_rows = win.get_height(args.win)
    p_cols = win.get_width(args.win)
  end

  local width=args.w or (oc and oc.width)
  if not width then
    if firstline then
      width = a.strwidth(firstline)
    else
      width = 10
    end
  end
  if width < 1 then width = 1 end
  local height=args.h or (oc and oc.height)
  if not height then
    if text then
      height = #text
    else
      height = 1
    end
  end
  if args.center == true or args.center == "r" then
    args.r = (p_rows - height) / 2
  end
  if args.center == true or args.center == "c" then
    args.c = (p_cols - width) / 2
  end
	local relative = args.relative
  if not relative then
		if args.win then
			relative = 'win'
    else
      relative = 'editor'
    end
	end
  local config = {
    relative=relative;
    win=args.win;
    width=width;
    height=height;
    row=args.r or 2;
    col=args.c or 5;
    style=args.style or "minimal";
    focusable=args.focusable;
  }
  if w then
    win.set_config(w, config)
    if args.enter then
      a.nvim_set_current_win(w)
    end
  else
    w = a.nvim_open_win(b, args.enter, config)
  end
  if args.blend then
    win.set_option(w, 'winblend', args.blend)
  end
  if args.bg then
    local bg
    if string.sub(args.bg, 1, 1) == "#" then
      -- TODO(bfredl):be smart and reuse hl ids.
      bg = "XXTMP"..h.id()
      colors.def_hi(bg, {bg=args.bg, fg=args.fg})
    else
      bg = args.bg
    end
    win.set_option(w, 'winhl', 'Normal:'..bg)
  end
  if args.chold then
    h.toclose[w] = true
  end
  if args.replace and win.is_valid(args.replace) then
    win.close(args.replace, false)
  end

  local ret
  return buf.call(b, function()
    local ret
    if args.cat then
      if args.term then error('FY!') end
      args.term = {'cat', vim.fn.expand(args.cat, ':p')}
    end
    if args.term then
      vim.fn.termopen(args.term)
    end
    if args.ft then
      v ([[set ft=]]..args.ft)
    end
    -- already curwin/curbuf but be nice
    if args.fn then
      ret = args.fn(b,w)
    end
    return ret or w
  end)
end
_G.f = h.f -- HAIII
-- }}}
-- autocmds {{
exec [[
  augroup bfredlua
    au CursorHold * lua _G.bfredl.cursorhold()
  augroup END
]]

function h.cursorhold()
  for w, k in pairs(h.toclose) do
    if not win.is_valid(w) then
      h.toclose[w] = nil
    elseif k and a.get_current_win() ~= w then
      win.close(w, false)
      h.toclose[w] = nil
    end
  end
end
-- }}}
-- logic {{{
if first_run then
  v [[autocmd VimEnter * lua _G.bfredl.vimenter(true)]]
else
  h.vimenter(false)
end
-- }}}
