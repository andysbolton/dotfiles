-- Pull in the wezterm API
local wezterm = require 'wezterm'
local mux = wezterm.mux
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.color_scheme = 'TokyoNight (Gogh)'
config.font = wezterm.font 'CaskaydiaCove NF'
config.default_prog = { 'pwsh' }
config.font_size = 11
config.line_height = 1.1
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.use_dead_keys = false

-- Dump any object to string
local function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then
        k = '"' .. k .. '"'
      end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

-- Equivalent to POSIX basename(3)
-- Given "/foo/bar" returns "bar"
-- Given "c:\\foo\\bar" returns "bar"
function basename(s)
  return string.gsub(s, '(.*[/\\])(.*)', '%2')
end

function fmt_working_dir(s)
  s = string.gsub(s, 'file://', '')
  -- clean up leftover front slash if it exists
  s = string.gsub(s, '^/', '')
  fmt_profile = string.gsub(wezterm.home_dir, "\\", "/")
  s = string.gsub(s, fmt_profile, '~')
  -- TODO: find a better way to format home directory if we're in WSL
  s = string.gsub(s, 'work/home/asbolton', '~')
  return s
end

local tab_title = function(tab_info)
  local baseexe = basename(tab_info.active_pane.foreground_process_name)
  fmt_dir = fmt_working_dir(tab_info.active_pane.current_working_dir)
  return baseexe .. ' @ ' .. fmt_dir
end

wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local mux_window = wezterm.mux.get_window(tab.window_id)
  local mux_tab = mux_window:active_tab()
  local mux_tab_cols = mux_tab:get_size().cols

  -- Calculate active/inactive tab cols
  -- In general, active tab cols > inactive tab cols
  local tab_count = #tabs
  local inactive_tab_cols = math.floor(mux_tab_cols / tab_count)
  local active_tab_cols = mux_tab_cols - (tab_count - 1) * inactive_tab_cols

  local title = tab_title(tab)
  title = ' ' .. title .. ' '
  local title_cols = wezterm.column_width(title)
  local icon = ' ⦿'

  -- Divide into 3 areas and center the title
  if tab.is_active then
    local rest_cols = math.max(active_tab_cols - title_cols, 0)
    local right_cols = math.ceil(rest_cols / 2)
    local left_cols = rest_cols - right_cols
    return {
      -- left
      { Foreground = { Color = 'Fuchsia' } },
      { Text = wezterm.pad_right(icon, left_cols) },
      -- center
      { Foreground = { Color = '#46BDFF' } },
      { Attribute = { Italic = true } },
      { Text = title },
      -- right
      { Text = wezterm.pad_right('', right_cols) },
    }
  else
    local rest_cols = math.max(inactive_tab_cols - title_cols, 0)
    local right_cols = math.ceil(rest_cols / 2)
    local left_cols = rest_cols - right_cols
    return {
      -- left
      { Text = wezterm.pad_right('', left_cols) },
      -- center
      { Attribute = { Italic = true } },
      { Text = title },
      -- right
      { Text = wezterm.pad_right('', right_cols) },
    }
  end
end)

wezterm.on('gui-startup', function()
  local tab, pane, window = mux.spawn_window({})
  window:gui_window():maximize()
end)

config.leader = { key = 'a', mods = 'CTRL' }
config.keys = {
  { key = 'Z', mods = 'CTRL', action = wezterm.action.ActivateCopyMode },
  { key = '8', mods = 'CTRL', action = act.PaneSelect },
  {
    key = 'H',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'J',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Down', 5 },
  },
  { key = 'K', mods = 'LEADER', action = act.AdjustPaneSize { 'Up', 5 } },
  {
    key = 'L',
    mods = 'LEADER',
    action = act.AdjustPaneSize { 'Right', 5 },
  },
}

return config
