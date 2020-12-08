-- ensure packer is in packpath
vim.cmd [[packadd packer.nvim]]

local function get_description(file_path)
  local description

  -- find first line that doesn't begin with a special character
  local line_num = 1
  for line in io.lines(file_path) do
    if line_num > 1 and line_num <= 30 then
      -- trim leading spaces
      line = line:gsub("^%s+", "")
      if line:match("^[^#^<^>^!^=%^-%^*]") and line:match("^[^!%[]") then
        description = line
        break
      end
    end
    line_num = line_num +1
  end

  if description then
    -- match the first sentence
    local shortened = description:match("^(.*)%.%s")
    description = shortened or description

    -- remove trailing period
    description = description:gsub("%.$", "")

    -- de-linkify markdown style links
    local link_title
    link_title = description:match("%[(.+)]%(.*%)")  -- `[foo](bar)`
    if link_title then
      description = description:gsub("%[.+]%(.*%)", link_title)
    end

    link_title = description:match("%[(.+)]%[.*]")   -- `[foo][bar]`
    if link_title then
      description = description:gsub("%[.+]%[.*]", link_title)
    end

    -- remove `command` style
    local enclosed = description:match("`(.*)`")
    if enclosed then
      description = description:gsub("`.*`", enclosed)
    end

    -- opinionated grammar restructure
    description = description:gsub("^This is a", "A")
  else
    description = "!!!!!!!"
  end

  return description
end


local packer = require("packer")
local plugin_utils = require("packer.plugin_utils")

if not packer then
  print("This lense is intended for use with Packer plugin manager.")
  return
end


-- lowest takes precedence: favors /doc/*.txt over readme.md
local function readme_file_pattern(plugin_name)
  return {
    "/README.md",
    "/README.markdown",
    -- "/doc/" .. plugin_name .. ".txt",
    -- "/doc/" .. plugin_name:gsub("^vim%-", "") .. ".txt",
  }
end

-- hardcoded workarounds for missing/non-standard markdown layouts! =)
local preset = {
  ["nvim-treesitter"] = "Treesitter configurations and abstraction layer for Neovim",
  ["snippets"] = "An advanced snippets engine for Neovim",
  ["vim-parenmatch"] = "A fast alternative to matchparen that highlights matching parenthesis based on the value of matchpairs",
  ["vim-signature"] = "A plugin to place, toggle and display marks.",
  ["vim-wordmotion"] = "More useful word motions for Vim",
  ["packer"] = "A use-package inspired plugin/package management for Neovim"
}


local subdir_names = {"opt", "start"}
local plugins = {}
plugins[subdir_names[1]], plugins[subdir_names[2]] = plugin_utils.list_installed_plugins()

for _, plugin_subdir in pairs(subdir_names) do
  for plugin_path, _ in pairs(plugins[plugin_subdir]) do
    local plugin_name = vim.fn.fnamemodify(plugin_path, ":t:r")
    local file_path, file_found, md_file_path
    for _, extension in pairs(readme_file_pattern(plugin_name)) do
      file_path = plugin_path .. extension
      file_found = io.open(file_path)
      if file_found then
        io.close(file_found)
        md_file_path = file_path
      end
    end

    local description
    if preset[plugin_name] ~= nil then
      description = preset[plugin_name]
    elseif md_file_path then
      description = get_description(md_file_path)
    else
      description = "!!!!!!!!!"
    end

    local output = string.format("%-7s %-30s : %s", "[" ..tostring(plugin_subdir).."]", plugin_name, description)
    print(output)
  end
end
