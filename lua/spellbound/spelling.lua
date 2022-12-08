-- Spelling
-- all the direct functional logic for spelling exists here


local spelling = {}

-- set spelling language on and or off
function spelling.activate_spelling()
  vim.cmd('setlocal spell spelllang=' .. vim.g.spellbound_settings.language)
  vim.cmd('hi SpellBad cterm=underline ctermfg=Red ctermbg=none')
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

-- Fix spelling error closest to the left/right of the cursor.
-- Will return to the original cursor position prior to the spell
-- correction if `g:return_to_position` is set as true.
--- @param direction string: accepts 'left'/'right' to fix spelling in the given direction
local function fix_spelling_error(direction)
  local direction_map = { left = '[s1z=', right = ']s1z=' }
  if direction_map[direction] == nil then
    error("Arg 'direction' must be either 'left' or 'right'")
  end
  local cmd = 'norm ' .. direction_map[direction]
  if vim.g.spellbound_settings.return_to_position then
    local view = vim.fn.winsaveview()
    vim.cmd(cmd)
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
