-- Spelling
-- all the direct functional logic for spelling exists here


SPELLING = {}

-- set spelling language on and or off
function SPELLING.activate_spelling()
  vim.cmd('setlocal spell spelllang=' .. vim.g.spellbound_settings.language)
  vim.cmd('hi SpellBad cterm=underline ctermfg=Red ctermbg=none')
end

-- toggle spelling on/off
function SPELLING.spelling_toggle()
  if vim.o.spell == false then
    print('Spelling On')
    SPELLING.activate_spelling()
  else
    print('Spelling Off')
    vim.cmd('setlocal nospell')
  end
end

return SPELLING
