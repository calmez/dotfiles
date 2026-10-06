-- ~/.config/hypr/hyprland.lua
-- Port of the preveous hyprland.conf to the Lua format (Hyprland >= 0.55).
-- Minimal & fast, rofi + Waybar, Super modifier, multi-monitor.

-- ---------------------------------------------------------------- monitors
-- Adjust names/positions with: hyprctl monitors
local monitor_main = hl.monitor({ output = "DP-3", mode = "5120x1440@60", position = "0x0", scale = 1 })
local monitor_side = hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "5120x360", scale = 1 })

-- ---------------------------------------------------------------- env vars
hl.env("XCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- ---------------------------------------------------------------- config
hl.config({
	input = {
		kb_layout = "us", -- change to your layout (us, de, ...)
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
			tap_to_click = true,
		},
	},
	general = {
		gaps_in = 1,
		gaps_out = 1,
		border_size = 1,
		col = {
			active_border = "rgba(ffffffff)",
			inactive_border = "rgba(282828ff)",
		},
		layout = "dwindle",
		resize_on_border = true,
	},
	decoration = {
		rounding = 2,
		blur = { enabled = false },
		shadow = { enabled = false },
	},
	master = {
		new_status = "master",
	},
	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
		vrr = 1,
	},
})

-- ---------------------------------------------------------------- animations (fast)
hl.curve("fast", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "fast" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "fast" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "fast" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "fast" })

-- ---------------------------------------------------------------- autostart
hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("playerctld daemon")
	hl.exec_cmd("/usr/libexec/kf6/polkit-kde-authentication-agent-1")
	hl.exec_cmd('eval "$(ssh-agent -s)"')
end)

-- ---------------------------------------------------------------- keybinds
local mod = "SUPER"

hl.bind(
	mod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("ghostty")) -- or kitty / foot
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("rofi -show drun -show-icons"))
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.exec_cmd("rofi -show run"))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("dolphin"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("rofi -show combi"))
hl.bind(mod .. " + Q", hl.dsp.window.close())

-- window focus (vim keys)
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "d" }))

-- window movement
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))

-- window manipulation
hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mod .. " + F", hl.dsp.window.float())
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + S", hl.dsp.workspace.toggle_special("magic"))

-- workspaces (10)
for i = 1, 10 do
	local key = tostring(i % 10) -- 10 -> "0"
	hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- multi-monitor: switch focus between monitors, throw windows across
hl.bind(mod .. " + CTRL + COMMA", hl.dsp.focus({ monitor = "l" }))
hl.bind(mod .. " + CTRL + PERIOD", hl.dsp.focus({ monitor = "r" }))
hl.bind(mod .. " + SHIFT + CTRL + COMMA", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + CTRL + PERIOD", hl.dsp.window.move({ monitor = "r" }))

-- scroll through workspaces
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- screenshots (grim + slurp)
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("grim ~/Pictures/screenshot-$(date +%s).png"))

-- media keys (PipeWire)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ repeating = true }
)
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true })

-- session
hl.bind(mod .. " + SHIFT + M", hl.dsp.exit())
hl.bind(mod .. " + SHIFT + R", hl.dsp.force_renderer_reload())

-- move/resize with mouse
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- resize with keyboard
hl.bind(mod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

-- ---------------------------------------------------------------- window rules
hl.window_rule({ match = { class = "pavucontrol" }, float = true })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true })
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true })

-- application-specific workspaces
--hl.window_rule({ match = { class = "firefox" }, workspace = 2 })
--hl.window_rule({ match = { class = "code" }, workspace = 3 })

-- workspace moving
hl.bind(mod .. " + SHIFT + LEFT", hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(mod .. " + SHIFT + RIGHT", hl.dsp.workspace.move({ monitor = "r" }))
