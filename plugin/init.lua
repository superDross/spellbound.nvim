-- main start up file
if vim.fn.has("nvim-0.7.0") == 0 then
  vim.api.nvim_err_writeln("spellbound requires at least nvim-0.7.0")
  return
end

-- make sure this file is loaded only once
if vim.g.loaded_spellbound == 1 then
  return
end
vim.g.loaded_spellbound = 1

require('spellbound').setup()
