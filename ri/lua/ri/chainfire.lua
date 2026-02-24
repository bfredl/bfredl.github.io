local ri = _G.ri
local chainfire = ri.chainfire or {}
ri.chainfire = chainfire
local h = chainfire

local ft = {}
chainfire.ft = ft

function bmapmode(mode)
  return function(lhs)
    return function(rhs)
      return a.nvim_buf_set_keymap(0, mode, lhs, rhs, {noremap=true})
    end
  end
end
local bimap = bmapmode'i'
function ft.c()
  bimap '¶)' ')'
  bimap '¶,' ','
  bimap '¶<space>' '<space>'
  bimap '¶' '<space>'
  if h.has_clangd then
    h.clangd()
  end
end

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup("RiChainFire", { clear = true });
  callback = function(ev)
    local func = ft[ev.match]
    if func then func() end
  end
})

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
