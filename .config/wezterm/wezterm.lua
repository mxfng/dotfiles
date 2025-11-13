local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action
local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").moon

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

config.term = "xterm-256color"

config.force_reverse_video_cursor = true
config.colors = theme.colors()

config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.macos_window_background_blur = 70

config.font_size = is_darwin() and 13 or 11

config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false

-- Tab bar styling to be more minimal
-- config.use_fancy_tab_bar = false

-- Mouse support
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},
}

-- Scrollback buffer
config.scrollback_lines = 50000

config.leader = {
	key = "a",
	mods = "CTRL",
	timeout_milliseconds = 2000,
}

config.keys = {
	-- tmux-style bindings with leader key (Ctrl-a)
	-- Send Ctrl-a when pressing it twice
	{ key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },

	-- Split panes
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "_", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },

	-- Navigate panes with vim keys
	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	-- Swap panes with vim keys
	-- NOTE: PaneSelect prompts the user which pane to swap with; non-parity with other WMs
	{ key = "H", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "J", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "K", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },
	{ key = "L", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActive" }) },

	-- Resize panes with vim keys
	{ key = "h", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "j", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "k", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "l", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Right", 5 }) },

	-- New tab/window
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },

	-- Close pane
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },

	-- Toggle pane zoom
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- Copy mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },

	-- Navigate tabs/windows
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },

	-- Tab navigator
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },

	-- Select tab by number
	{ key = "1", mods = "LEADER", action = act.ActivateTab(0) },
	{ key = "2", mods = "LEADER", action = act.ActivateTab(1) },
	{ key = "3", mods = "LEADER", action = act.ActivateTab(2) },
	{ key = "4", mods = "LEADER", action = act.ActivateTab(3) },
	{ key = "5", mods = "LEADER", action = act.ActivateTab(4) },
	{ key = "6", mods = "LEADER", action = act.ActivateTab(5) },
	{ key = "7", mods = "LEADER", action = act.ActivateTab(6) },
	{ key = "8", mods = "LEADER", action = act.ActivateTab(7) },
	{ key = "9", mods = "LEADER", action = act.ActivateTab(8) },

	-- Utility bindings
	{ key = "D", mods = "SHIFT|CTRL|SUPER", action = act.ShowDebugOverlay },
}

-- Vi mode in copy mode
config.key_tables = {
	copy_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "q", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
		{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
		{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
		{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
		{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
		{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
		{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
		{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
		{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
		{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
		{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
		{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
		{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
		{
			key = "y",
			mods = "NONE",
			action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
		},
		{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
		{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("PageUp") },
		{ key = "d", mods = "CTRL", action = act.CopyMode("PageDown") },
		{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
	},
	search_mode = {
		{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
		{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
		{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
		{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
		{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
		{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
	},
}

return config
