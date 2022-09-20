-- Config
-- provides default config and ability to override said defaults


CONFIG = {}

local default_config = {
  mappings = {
    fix_right = '<C-l>',
    fix_left = '<C-h>',
    toggle_map = '<C-s>'
  },
  language = 'en_gb',
  autospell_filetypes = { '*.txt', '*.md', '*.rst' },
  autospell_gitfiles = true,
}

local function _update_config(settings, key)
  -- iterate over user settings and update default config with user k/v
  for k, v in pairs(settings) do
    if type(v) == 'table' then
      _update_config(v, key[k])
    else
      key[k] = v
    end
  end
  -- update settings
  vim.g.spellbound_settings = default_config
end

function CONFIG.update_config()
  -- update the default config with the users settings and override
  -- the global spellbound_settings with it
  _update_config(vim.g.spellbound_settings, default_config)
end

return CONFIG
