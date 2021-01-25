local EMPTY_BLOCK = " "
-- local LIGHTS_BLOCK = "+"
-- local LIGHTS_BLOCK = "·"
local LIGHTS_BLOCK = "•"
-- local LIGHTS_BLOCK = "●"

local palette = {}

palette.plasma = {
  "#f7c6a5",
  "#F79DA4",
  "#f773a3",
  "#bb739d",
  "#7f7297",
  "#548dc7",
  "#28a8f7",
  "#14c294",
  "#00db30",
  "#7cde2b",
  "#f7e026",
  "#f7bf13",
  "#f79e00",
  "#f74f26",
  "#f7004b",
  "#f76378",
}


local function lerp(a, b, interp)
  return a + (b - a) * interp
end

local function get_time()
  local fn = vim.fn
  return fn.reltimefloat(fn.reltime())
end

--

local Window = {win_id = nil, buf_id = nil}

function Window:new(width, height, hl_group)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  local api = vim.api

  self.width = width
  self.height = height

  local top = ((api.nvim_get_option("lines") - height) / 2) - 4
  -- local top = ((api.nvim_get_option("lines") - height) / 2) - 4
  local top = 2
  local left = (api.nvim_get_option("columns") - width) / 2 +1

  local opts = {}
  opts.relative = "editor"
  opts.row = top
  opts.col = left
  opts.width = width
  opts.height = height
  opts.focusable = false
  opts.style = "minimal"

  self.buf_id = api.nvim_create_buf(0, 1)
  self.win_id = api.nvim_open_win(self.buf_id, false, opts)
  api.nvim_win_set_option(self.win_id, "winblend",0)
  -- api.nvim_win_set_option(self.win_id, "winhl", "Normal:" .. hl_group)


  return o
end

--

local function init_lights(display)
  local lights_str_array = {}
  local api = vim.api
  COUNTER = -1
  -- COUNTER = 255
  local lights_string = "│ " .. (LIGHTS_BLOCK .. EMPTY_BLOCK):rep(32) .. "│"
  -- local byteidx = vim.fn.byteidx
  local top = "╭" .. string.rep("─", 65) .. "╮"
  local bot = "╰" .. string.rep("─", 65) .. "╯"
  table.insert(lights_str_array, top)
  for i = 1, 32 do
    table.insert(lights_str_array, lights_string)
  end
  table.insert(lights_str_array, bot)

  api.nvim_buf_set_lines(display.buf_id, 2, -1, false, lights_str_array)

--
  print("?>> " .. #lights_string)
  local lights_str_byteindex = {}
  -- parse the string
  for i = 1, vim.fn.strdisplaywidth(lights_string) do
    local char = vim.fn.strcharpart(lights_string, i-1, 1)
    if char == LIGHTS_BLOCK then
      local byte_idx = vim.fn.byteidx(lights_string, i -1)
      if  byte_idx + LIGHTS_BLOCK:len() >= #lights_string then
        print("BOOOO")
      end
      table.insert(lights_str_byteindex, { byte_start = byte_idx, byte_end = byte_idx + LIGHTS_BLOCK:len() })
    end
  end

  -- print(vim.inspect(lights_str_byteindex))
  return lights_str_byteindex
end

--
local function draw_lights(display, delta_time, line_bytes, hl_names)
  local add_highlight = vim.api.nvim_buf_add_highlight
  local start_line = 2

  local idx_start, idx_end
  local sin, cos, flr, fmod, sqrt = math.sin, math.cos, math.floor, math.fmod, math.sqrt
  local x2, y2, v1, v2
  local r, g, b, w
  local a2 = COUNTER * 8

  local avg, col
  for x = 1, 32 do
    x2 = x / 1024
    idx_start = line_bytes[x].byte_start
    idx_end = line_bytes[x].byte_end --or line_bytes[x] +2--TODO: take care of last column
    for y = 1, 32 do
      -- if x == 1 and y == 1 then
      --   print(vim.inspect(line_bytes[x]))
      -- end
      y2 = y / 512
      v1 = 128 * sin(y2 + a2)
      v2 = sin(sqrt(COUNTER + 256 - x2 + y2) /8 )

      r  = 56 * cos(a2 + x / v1 + v2)
      g  = 48 * sin((x + y) / v1 * v2)
      b  = 40 * cos((x * v2 - y) / v1)
      w = flr(32 - r+g)
      avg = flr((56 + r) + (48 -g) + (40 + b)  + w /4)

      col = fmod(avg, 16) + 1
      -- if x == 32 then
      --   print(idx_end)
      -- end
      add_highlight(display.buf_id, display.namespace, hl_names[col], y - 1 + start_line, idx_start, idx_end)
    end
  end

  COUNTER = COUNTER + delta_time / 32
  if COUNTER > 255 then
    COUNTER = 0
  end
end

--

local Demo = {
  display = nil,
  interval = 16,
  }

function Demo:new()
  local o = {}
  setmetatable(o, self)
  self.__index = self

  self.display = {}
  self.border_win = nil
  self.dim_buffer = nil
  self.hl_groups = {}

  return o
end

function Demo:init()
  local api = vim.api
  -- setup palette

  for i, value in ipairs(palette.plasma) do
    local hl_name = "plasma_" .. i
    vim.cmd(("highlight %s guifg=%s guibg=%s"):format(hl_name, value, "#222020"))
    self.hl_groups[i] = hl_name
  end

  vim.cmd("highlight windowbg_1 guibg=#222020")

  -- setup main window
  vim.o.showtabline = 0
  vim.o.laststatus = 0 -- TODO: make sure autocommands don't override this
  vim.cmd [[ hi Cursor blend = 100 ]]

  -- create a new tab with 3 vertical splits
  vim.cmd [[ tabnew ]]
  local original_win = api.nvim_get_current_win()
  vim.cmd [[ leftabove vnew ]]
  vim.cmd("vertical resize " .. (vim.o.columns - 67) / 2)
  api.nvim_set_current_win(original_win)
  vim.cmd [[rightbelow vnew ]]
  api.nvim_set_current_win(original_win)
  vim.cmd("vertical resize " .. 67)
  self.display.win_id = original_win
  api.nvim_win_set_option(self.display.win_id, "winhighlight", "Normal:Comment")


  vim.wo.cursorline = false
  vim.o.signcolumn = "no"
  self.display.buf_id = api.nvim_create_buf(false, true)
  api.nvim_win_set_buf(self.display.win_id, self.display.buf_id)
  -- api.nvim_win_set_option(self.display.win_id, "winhighlight", "Normal:windowbg_1")
  self.display.namespace = vim.api.nvim_create_namespace("lights")

  -- create a ~~display~~ dimming overlay window
  self.overlay = Window:new(64, 32, "windowbg_1")
end

function Demo:start()
  local api = vim.api
  local clear_namespace = api.nvim_buf_clear_namespace
  local line_byte_index = init_lights(self.display)

  local delta_time, t
  local frames_rendered = 0

  -- TODO: some of these should be instance variables
  -- create a timer handle -- TODO: check we don't have a timer running
  local timer = vim.loop.new_timer()

  local start_time = get_time()
  local time_last_frame = start_time
  local elapsed_time = 0
  local update_time = 16 -- milliseconds
  local update_speed = 1.0 -- time multiplier

  -- update loop
  timer:start(0, update_time, vim.schedule_wrap(
    function()
      t = get_time()
      delta_time = t - time_last_frame
      time_last_frame = t
      elapsed_time = elapsed_time + (delta_time * update_speed)

      if (elapsed_time <= 440) then
        -- set overlay opacity
        local opacity = math.floor(lerp(-40, 110, math.sin(elapsed_time / 2) * -1))
        if opacity <=0 then opacity = opacity * -1 end
        if opacity > 100 then opacity = 100 end
        -- print(opacity)
        api.nvim_win_set_option(self.overlay.win_id, "winblend", opacity)

        clear_namespace(self.display.buf_id, self.display.namespace, 0, -1)
        draw_lights(self.display, delta_time, line_byte_index, self.hl_groups)
        frames_rendered = frames_rendered + 1
      else
        timer:close()
        print(frames_rendered .. " frames rendered in " .. elapsed_time .. " seconds.")
      end
    end))
end


local M = {}
function M.start()
  local demo = Demo:new()
  demo:init()
  demo:start()
end
_G.h = M

return M
