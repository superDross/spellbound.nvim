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
  -- update user settings with default values
  _update_config(vim.g.spellbound_settings, default_config)
end

return CONFIG
