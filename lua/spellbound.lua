-- SpellBound.nvim - spelling configurations and mapping tool
-- Author:      David Ross <https://github.com/superDross/>


local spelling = require('spellbound.spelling')
local config = require('spellbound.config')

local M = {}


local function setup_mappings(user_map)
  local map_opts = { noremap = true, silent = true }
  -- spelling toggle key map
  vim.keymap.set(
    'n',
    vim.g.spellbound_settings.mappings.toggle_map,
    function() spelling.spelling_toggle() end,
    map_opts
  )
  -- fix right most spelling error with first spelling suggestion
  vim.keymap.set(
    'n',
    vim.g.spellbound_settings.mappings.fix_right,
    ']s1z=',
    map_opts
  )
  -- fix left most spelling error with first spelling suggestion
  vim.keymap.set(
    'n',
    vim.g.spellbound_settings.mappings.fix_left,
    '[s1z=',
    map_opts
  )
end

local function setup_commands()
  local cmd = vim.api.nvim_create_user_command
  cmd(
    'SpellingToggle',
    function() spelling.spelling_toggle() end,
    {}
  )
end

local function setup_autocommands()
  local spelling_group = vim.api.nvim_create_augroup(
    'spelling',
    { clear = true }
  )
  vim.api.nvim_create_autocmd(
    { 'BufRead', 'BufNewFile' }, {
    pattern = { '*.md', '*.txt', '*.rst' },
    callback = function() spelling.activate_spelling() end,
    group = spelling_group,
  })
  vim.api.nvim_create_autocmd('FileType', {
    pattern  = { 'gitcommit', 'gitrebase' },
    callback = function() spelling.activate_spelling() end,
    group    = spelling_group,
  })
end

function M.setup()
  config.update_config()
  setup_commands()
  setup_autocommands()
  setup_mappings()
end

return M