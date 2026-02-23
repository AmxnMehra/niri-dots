-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.
-- or, changing the font size and color scheme.
config.font_size = 15
config.font = wezterm.font("JetBrains Mono Nerd Font")
config.color_scheme = "Wean (Gogh)"
config.window_background_opacity = 0.5
config.text_background_opacity = 0.5
config.use_fancy_tab_bar = false
config.window_frame = {
	active_titlebar_bg = "rgba(0,0,0,0)",
}

-- Finally, return the configuration to wezterm:
return config
