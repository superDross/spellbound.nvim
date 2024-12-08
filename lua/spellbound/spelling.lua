-- Spelling
-- all the direct functional logic for spelling exists here

local highlight = require('spellbound.highlight')
local spelling = {}

-- set spelling language on and or off
function spelling.activate_spelling()
  vim.cmd('setlocal spell spelllang=' .. vim.g.spellbound_settings.language)
  vim.cmd('set spellsuggest=best,' .. vim.g.spellbound_settings.number_suggestions)
  vim.cmd('set spelloptions=camel,noplainbuffer')
  local hl_cfg = vim.g.spellbound_settings.highlight
  vim.api.nvim_set_hl(0, 'SpellBoundFixHighlight', {
    bg = hl_cfg.bg_colour,
    fg = hl_cfg.fg_colour,
  })
end

-- toggle spelling on/off
function spelling.spelling_toggle()
  if vim.o.spell == false then
    vim.notify('Spelling On')
    spelling.activate_spelling()
  else
    vim.notify('Spelling Off')
    vim.cmd([[
      setlocal nospell
      highlight clear SpellBoundFixHighlight
    ]])
  end
end

-- fix the spelling error and highlight the word that was fixed
--- @param direction string: accepts 'left'/'right' to fix spelling in the given direction
local function fix_spelling(direction)
  local direction_map = { left = '[s1z=', right = ']s1z=' }
  if direction_map[direction] == nil then
    error("Arg 'direction' must be either 'left' or 'right'")
  end
  local cmd = 'norm ' .. direction_map[direction]
  vim.cmd(cmd)
  highlight.under_cursor()
end

-- return the current view of the cursor with the current line length
local function save_custom_view()
  local view = vim.fn.winsaveview()
  view['line_length'] = vim.fn.col('$')
  return view
end

-- return the view of the original cursor position after spelling fix according
-- to the direction of the spell correction and line length changes
--- @param direction string: accepts 'left'/'right' to fix spelling in the given direction
local function fix_spelling_and_return(direction)
  local before = save_custom_view()
  fix_spelling(direction)
  local after = save_custom_view()

  if (before.lnum == after.lnum) and
      (before.line_length ~= after.line_length) and
      (direction == 'left')
  then
    before['col'] = before['col'] + (after['line_length'] - before['line_length'])
  end

  return before
end

-- Fix spelling error closest to the left/right of the cursor.
-- Will return to the original cursor position prior to the spell
-- correction if `g:return_to_position` is set as true.
--- @param direction string: accepts 'left'/'right' to fix spelling in the given direction
local function fix_spelling_error(direction)
  if vim.o.spell == false then
    error('You must toggle spelling on before fixing spelling errors')
  end
  if vim.g.spellbound_settings.return_to_position then
    local view = fix_spelling_and_return(direction)
    vim.fn.winrestview(view)
  else
    fix_spelling(direction)
  end
end

-- Fix the nearest spelling mistake to the left of the cursor
function spelling.fix_leftmost_spelling()
  fix_spelling_error('left')
end

-- Fix the nearest spelling mistake to the right of the cursor
function spelling.fix_rightmost_spelling()
  fix_spelling_error('right')
end

return spelling
