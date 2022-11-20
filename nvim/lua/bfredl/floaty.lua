local h = _G._bfredl_floaty or {}
local colors = require'bfredl.colors'
local u = require'bfredl.util'
local a, win, buf = u.a, u.win, u.buf

_G._bfredl_floaty = h

h.toclose = h.toclose or {}

function h.f(args)
  local b,w, oc
  if args.update and a.win_is_valid(args.update) then
    w = args.update
    b = win.get_buf(w)
    oc = win.get_config(w)
  end
  if args.buf and buf.is_valid(args.buf) then
    b = args.buf
  else
    b = a.create_buf(false, true)
  end
  local firstline = nil
  local text
  if args.text then
    if type(args.text) == "string" then
      text = vim.split(args.text, '\n', true)
    else
      text = args.text
    end
    firstline = text[1] or ""
    buf.set_lines(b, 0, -1, true, text)
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
    if args.c then
      args.c = args.c - width / 2
    else
      args.c = (p_cols - width) / 2
    end
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
    border=args.border;
    zindex=args.zindex;
  }
  if w then
    win.set_config(w, config)
    if args.enter then
      a.set_current_win(w)
    end
  else
    w = a.open_win(b, args.enter, config)
  end
  if args.blend then
    win.set_option(w, 'winblend', args.blend)
  end
  if args.bg then
    local bg
    if string.sub(args.bg, 1, 1) == "#" then
      -- TODO(bfredl):be smart and reuse hl ids.
      bg = "XXTMP"..u.id()
      colors.def_hi(bg, {bg=args.bg, fg=args.fg})
    else
      bg = args.bg
    end
    oldhl = win.get_option(w, 'winhl')
    win.set_option(w, 'winhl', oldhl..(#oldhl > 0 and ',' or '')..'Normal:'..bg)
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
      vim.cmd ([[set ft=]]..args.ft)
    end
    -- already curwin/curbuf but be nice
    if args.fn then
      ret = args.fn(b,w)
    end
    return ret or w
  end)
end

vim.cmd [[
  augroup bfredl_floaty
    au CursorHold * lua _G._bfredl_floaty.cursorhold()
  augroup END
]]

function h.cursorhold()
  for w, k in pairs(h.toclose) do
    if not a.win_is_valid(w) then
      h.toclose[w] = nil
    elseif k and a.get_current_win() ~= w then
      a.win_close(w, false)
      h.toclose[w] = nil
    end
  end
end

return h
