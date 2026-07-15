local ri = _G.ri
local a = vim.api
local h = ri.chainfire or {}
ri.chainfire = h

h.ft = {}
h.ft_quickcheck = {}

function bmap(mode)
  return function(lhs)
    return function(rhs)
      return a.nvim_buf_set_keymap(0, mode, lhs, rhs, {noremap=true})
    end
  end
end
local bimap = bmap'i'
function h.brackety()
  bmap'' '[[' "<cmd>call rust#Jump('n', 'Back')<CR>"
  bmap'' ']]' "<cmd>call rust#Jump('n', 'Forward')<CR>"
  bmap'' '[[' "<cmd>call rust#Jump('v', 'Back')<CR>"
  bmap'' ']]' "<cmd>call rust#Jump('v', 'Forward')<CR>"
  bmap'' '[[' "<cmd>call rust#Jump('o', 'Back')<CR>"
  bmap'' ']]' "<cmd>call rust#Jump('o', 'Forward')<CR>"
end
function h.ft.c()
  bimap '¶)' ')'
  bimap '¶,' ','
  bimap '¶<space>' '<space>'
  bimap '¶' '<space>'
  h.brackety()
  if h.has_clangd then
    h.clangd()
  end
  vim.treesitter.start()
end
function h.ft.lua()
  bmap 'n' '<Plug>ch:un' '<Plug>(Luadev-RunLine)'
  bmap 'n' '<Plug>ch:ud' '<Plug>(Luadev-RunWord)'
  bmap 'v' '<Plug>ch:un' '<Plug>(Luadev-Run)'
  bmap 'i' '<Plug>ch:.u' '<Plug>(Luadev-Complete)'
end
function h.ft.zig()
  vim.treesitter.start()
  h.brackety()
end

h.augroup = vim.api.nvim_create_augroup("RiChainFire", { clear = true })
local function aucmd(which, opts)
  opts.group = ri.augroup
  return vim.api.nvim_create_autocmd(which, opts)
end

aucmd({'BufRead','BufNewFile'}, { pattern='*.h', callback=function()
  if string.match(a.nvim_buf_get_name(0), 'DelugeFirmware') then
    vim.cmd 'setfiletype cpp'
  else
    vim.bo.filetype = 'c'
  end
end})

aucmd('FileType', { callback = function(ev)
  local func = h.ft[ev.match]
  if func then func() end
end})
do
  local func = h.ft[vim.bo.filetype]
  if func then func() end
end

h.ns_quickcheck = a.nvim_create_namespace'ri.chainfire.ns_quickcheck'
aucmd({'TextChanged','TextChangedI'}, { callback = function(ev)
  local func = h.ft_quickcheck[vim.bo.filetype]
  if func then h.do_quickcheck(func) end
end})

function h.do_quickcheck(cb)
  local lines = a.nvim_buf_get_lines(0, 0, -1, true)
  local data = table.concat(lines, '\n') .. '\n'
  cb(data, function(res)
    local items = vim.fn.getqflist{lines=res}
    diags = vim.diagnostic.fromqflist(items.items)

    vim.diagnostic.set(h.ns_quickcheck, 0, diags, {})
  end)
end

function h.ft_quickcheck.lua(text, cb)
  status, err = loadstring(text, '@<stdin>')
  cb({status and '' or err})
end

function h.ft_quickcheck.zig(text, cb)
  local cmd = vim.system({'zig', 'ast-check'}, {stdin=text}, vim.schedule_wrap(function(res)
    if res.code == 0 then
      cb({''})
    else
      local lines = vim.split(res.stderr, '\n')
      cb(lines)
    end
  end))
end

-- TODO(ri): LSP CODE IS NOT INTEGRATED
-- LSP {{{
function h.root_pattern(pat)
  return vim.fs.dirname(vim.fs.find(pat, { upward = true })[1])
end
function h.client_capabilities(over)
  return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), over)
end

function h.clangd()
  vim.lsp.start {
    name = 'clangd';
    cmd = {h.clangd_path, '-query-driver=/home/bfredl/dev/DelugeFirmware/toolchain/v16/linux-x86_64/arm-none-eabi-gcc/bin/arm-none-eabi-*'};
    root_dir = h.root_pattern {
      'compile_commands.json';
      'compile_flags.txt';
      '.clangd';
      '.git';
    };
    capabilities = h.client_capabilities {
      textDocument = {
        completion = { editsNearCursor = true; };
      };
      offsetEncoding = { 'utf-8', 'utf-16' };
      positionEncodings = { 'utf-8', 'utf-16' }; -- electric boogalo
    }
   }
end

function h.luals()
  vim.lsp.start {
    name = 'luaLS';
    cmd = {'lua-language-server'};
    root_dir = h.root_pattern {
      '.git';
      '.luarc.json';
      '.luarc.jsonc';
    };
    capabilities = h.client_capabilities {
    };
    on_init = function(client)
      client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
        Lua = {
          runtime = { version = 'LuaJIT'; };
          -- Make the server aware of Neovim runtime files
          workspace = {
            checkThirdParty = false;
            library = {
              vim.env.VIMRUNTIME;
              -- "${3rd}/luv/library"
              -- "${3rd}/busted/library",
            };
          };
        };
      })
    end;
  }
end

-- TODO(ri): DISABLEMENT SYSTEM
h.has_clangd = false
if not vim.g.ri_nolsp then
  h.clangd_path = "/home/bfredl/local/llvm17-release/bin/clangd"
  h.has_clangd = vim.fn.executable(h.clangd_path) ~= 0
  if not h.has_clangd then
    h.clangd_path = "clangd"
    h.has_clangd = vim.fn.executable(h.clangd_path) ~= 0
  end
  if false and vim.fn.executable('typescript-language-server') ~= 0 then
    ri.aucmd('FileType', {'javascript', 'typescript'}, function() 
      vim.lsp.start {
        name = 'tsserver';
        cmd = {'typescript-language-server', '--stdio'};
        root_dir = h.root_pattern { '.git'; };
      }
    end)
  end
  if vim.fn.executable('zls') ~= 0 then
  end
  if vim.fn.executable 'jedi-language-server' ~= 0 then
  end
  if false and vim.fn.executable 'lua-language-server' ~= 0 then
    ri.aucmd('FileType', {'lua'}, function()
      h.luals()
    end)
  end
  if false and vim.fn.executable('pylsp') ~= 0 then
    h.aucmd('FileType', {'python'}, function()
     vim.lsp.start {
        name = 'pylsp';
        cmd = {'pylsp'};
        root_dir = h.root_pattern { '.git'; 'setup.py'; };
      }
    end)
  end
end

-- }}}

return chainfire
