-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'TokyoNight (Gogh)'
config.font = wezterm.font 'CaskaydiaCove NF'
config.default_prog = { 'pwsh' }
-- config.window_decorations = "TITLE"
config.font_size = 12
config.line_height = 1.1
config.use_dead_keys = false
-- config.window_frame = {
--   font = wezterm.font { family = 'Noto Sans', weight = 'Regular' },
--  }

wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
 end)

-- and finally, return the configuration to wezterm
return config
