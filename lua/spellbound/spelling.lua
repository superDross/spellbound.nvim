-- Spelling
-- all the direct functional logic for spelling exists here


local spelling = {}

-- set spelling language on and or off
function spelling.activate_spelling()
  vim.cmd('setlocal spell spelllang=' .. vim.g.spellbound_settings.language)
  vim.cmd('set spellsuggest=best,' .. vim.g.spellbound_settings.number_suggestions)
end

-- toggle spelling on/off
function spelling.spelling_toggle()
  if vim.o.spell == false then
    vim.notify('Spelling On')
    spelling.activate_spelling()
  else
    vim.notify('Spelling Off')
    vim.cmd('setlocal nospell')
  end
end

-- return the current view of the cursor with the current line length
local function save_custom_view()
  local view = vim.fn.winsaveview()
  view['line_length'] = vim.fn.col('$')
  return view
end

-- return to the original cursor position prior to the spell adjustment according
-- to the direction of the spell correction and line length changes
--- @param cmd string: the command to execute to fix the spelling
--- @param direction string: accepts 'left'/'right' to fix spelling in the given direction
local function return_to_position_view(cmd, direction)
  local before = save_custom_view()
  vim.cmd(cmd)
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
  local direction_map = { left = '[s1z=', right = ']s1z=' }
  if direction_map[direction] == nil then
    error("Arg 'direction' must be either 'left' or 'right'")
  end
  local cmd = 'norm ' .. direction_map[direction]
  if vim.g.spellbound_settings.return_to_position then
    local view = return_to_position_view(cmd, direction)
    vim.fn.winrestview(view)
  else
    vim.cmd(cmd)
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
