
local ffi = require('ffi')
local NULL = ffi.cast('void*', 0)
local libnvim = ffi.C -- fubbit
local Preprocess = require('test.unit.preprocess')
local formatc = require('test.unit.formatc')

-- some things are just too complex for the LuaJIT C parser to digest. We
-- usually don't need them anyway.
local function filter_complex_blocks(body)
  local result = {}

  for line in body:gmatch("[^\r\n]+") do
    if not (string.find(line, "(^)", 1, true) ~= nil
            or string.find(line, "_ISwupper", 1, true)
            or string.find(line, "_Float")
            or string.find(line, "msgpack_zone_push_finalizer")
            or string.find(line, "msgpack_unpacker_reserve_buffer")
            or string.find(line, "UUID_NULL")  -- static const uuid_t UUID_NULL = {...}
            or string.find(line, "inline _Bool")) then
      result[#result + 1] = line
    end
  end

  return table.concat(result, "\n")
end

local previous_defines_init = ''
local preprocess_cache_init = {}
local previous_defines_mod = ''
local preprocess_cache_mod = nil

local theflag = true

-- use this helper to import C files, you can pass multiple paths at once,
-- this helper will return the C namespace of the nvim library.
cimport = function(...)
  local previous_defines, preprocess_cache, cdefs
  if theflag and preprocess_cache_mod then
    preprocess_cache = preprocess_cache_mod
    previous_defines = previous_defines_mod
    cdefs = cdefs_mod
  else
    preprocess_cache = preprocess_cache_init
    previous_defines = previous_defines_init
    cdefs = cdefs_init
  end
  for _, path in ipairs({...}) do
    if not (path:sub(1, 1) == '/' or path:sub(1, 1) == '.'
            or path:sub(2, 2) == ':') then
      path = './' .. path
    end
    if not preprocess_cache[path] then
      local body
      body, previous_defines = Preprocess.preprocess(previous_defines, path)
      -- format it (so that the lines are "unique" statements), also filter out
      -- Objective-C blocks
      if os.getenv('NVIM_TEST_PRINT_I') == '1' then
        local lnum = 0
        for line in body:gmatch('[^\n]+') do
          lnum = lnum + 1
          print(lnum, line)
        end
      end
      body = formatc(body)
      body = filter_complex_blocks(body)
      -- add the formatted lines to a set
      local new_cdefs = Set:new()
      for line in body:gmatch("[^\r\n]+") do
        line = trim(line)
        -- give each #pragma pack an unique id, so that they don't get removed
        -- if they are inserted into the set
        -- (they are needed in the right order with the struct definitions,
        -- otherwise luajit has wrong memory layouts for the sturcts)
        if line:match("#pragma%s+pack") then
          line = line .. " // " .. pragma_pack_id
          pragma_pack_id = pragma_pack_id + 1
        end
        new_cdefs:add(line)
      end

      -- subtract the lines we've already imported from the new lines, then add
      -- the new unique lines to the old lines (so they won't be imported again)
      new_cdefs:diff(cdefs)
      cdefs:union(new_cdefs)
      -- request a sorted version of the new lines (same relative order as the
      -- original preprocessed file) and feed that to the LuaJIT ffi
      local new_lines = new_cdefs:to_table()
      if os.getenv('NVIM_TEST_PRINT_CDEF') == '1' then
        for lnum, line in ipairs(new_lines) do
          print(lnum, line)
        end
      end
      body = table.concat(new_lines, '\n')

      preprocess_cache[path] = body
    end
    cimportstr(preprocess_cache, path)
  end
  return libnvim
end


local function cimportstr(preprocess_cache, path)
  if imported:contains(path) then
    return lib
  end
  local body = preprocess_cache[path]
  if body == '' then
    return lib
  end
  cdef(body)
  imported:add(path)

  return lib
end

function tt(path)
    return cimport(path)
end
