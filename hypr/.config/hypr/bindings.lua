-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")


-- ############################################################################
-- MY OVERRIDES: hjkl instead of arrow keys
-- ############################################################################
--
-- Arrow keys sit behind a keyboard layer, so every default that used them is
-- rebound to H/J/K/L (H=left  J=down  K=up  L=right) with the same modifiers.
--
-- Order matters (this file loads top to bottom, after Omarchy's defaults):
-- everything is unbound first, then rebound, because SUPER+J/K/L and
-- SUPER+ALT+K are reused for a different action and the originals move.
--
--   Focus window              SUPER + hjkl
--   Swap window               SUPER + SHIFT + hjkl
--   Move workspace to monitor SUPER + SHIFT + ALT + hjkl
--   Move window into group    SUPER + ALT + hjkl
--   Screenshot region picker  plain hjkl (added; Omarchy's arrows still work)
--
-- Displaced defaults (their old chord is now a direction key):
--   Toggle window split       SUPER + J      ->  SUPER + CTRL + SHIFT + J
--   Keybindings               SUPER + K      ->  SUPER + B  (B for bindings)
--   Toggle workspace layout   SUPER + L      ->  SUPER + CTRL + SHIFT + L
--   Tmux keybindings          SUPER + ALT + K ->  SUPER + CTRL + ALT + K
--   Toggle dictation          SUPER + CTRL + X ->  SUPER + D  (D for dictate)
--
-- Dropped with no replacement: group prev/next on SUPER + CTRL + LEFT/RIGHT.
-- SUPER + CTRL + H/L are Hardware menu / Lock system, so they stay as they are.
-- SUPER + ALT + TAB (and + SHIFT + TAB) already do the same thing.

-- ---- unbind: arrow chords ----
local arrow_mods = { "SUPER", "SUPER + SHIFT", "SUPER + SHIFT + ALT", "SUPER + ALT" }
local arrows = { "LEFT", "RIGHT", "UP", "DOWN" }

for _, mods in ipairs(arrow_mods) do
  for _, arrow in ipairs(arrows) do
    hl.unbind(mods .. " + " .. arrow)
  end
end

hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")

-- ---- unbind: defaults that move to make room for hjkl ----
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + ALT + K")

-- ---- hjkl direction binds ----
-- key = the hjkl key, dir = Hyprland's direction letter, name = word used by
-- omarchy-capture-region; focus/swap/monitor/group match Omarchy's descriptions.
local directions = {
  { key = "H", dir = "l", name = "left", focus = "left", swap = "to the left", monitor = "left", group = "left" },
  { key = "J", dir = "d", name = "down", focus = "below", swap = "down", monitor = "down", group = "bottom" },
  { key = "K", dir = "u", name = "up", focus = "above", swap = "up", monitor = "up", group = "top" },
  { key = "L", dir = "r", name = "right", focus = "right", swap = "to the right", monitor = "right", group = "right" },
}

for _, d in ipairs(directions) do
  o.bind("SUPER + " .. d.key, "Focus on " .. d.focus .. " window", hl.dsp.focus({ direction = d.dir }))
  o.bind("SUPER + SHIFT + " .. d.key, "Swap window " .. d.swap, hl.dsp.window.swap({ direction = d.dir }))
  o.bind("SUPER + SHIFT + ALT + " .. d.key, "Move workspace to " .. d.monitor .. " monitor", hl.dsp.workspace.move({ monitor = d.dir }))
  o.bind("SUPER + ALT + " .. d.key, "Move window to group on " .. d.group, hl.dsp.window.move({ into_group = d.dir }))
end

-- ---- displaced defaults, rebound ----
o.bind("SUPER + CTRL + SHIFT + J", "Toggle window split", hl.dsp.layout("togglesplit"))
o.bind("SUPER + B", "Keybindings", "omarchy-menu-keybindings")
o.bind("SUPER + CTRL + SHIFT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
o.bind("SUPER + CTRL + ALT + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

-- ---- dictation: shorter toggle ----
-- Same guard as Omarchy's voxtype.lua, so this is a no-op where voxtype is
-- missing. F9 push-to-talk is left as shipped.
if o.cmd_present("voxtype") then
  hl.unbind("SUPER + CTRL + X")
  o.bind("SUPER + D", "Toggle dictation", "voxtype record toggle")
end

-- ---- screenshot region picker: hjkl selects the window to capture ----
-- Same pattern as Omarchy's own handler (utilities.lua): the binds exist only
-- while a slurp selection layer is on screen, so plain h/j/k/l can't leak into
-- normal typing. Omarchy's arrow binds are registered separately and stay.
local picker_layers = 0
local picker_binds = {}

hl.on("layer.opened", function(layer)
  if layer.namespace == "selection" then
    picker_layers = picker_layers + 1
    if picker_layers == 1 then
      for _, d in ipairs(directions) do
        table.insert(
          picker_binds,
          hl.bind(d.key, hl.dsp.exec_cmd("omarchy-capture-region --select-window " .. d.name), { description = "Select window to capture" })
        )
      end
    end
  end
end)

hl.on("layer.closed", function(layer)
  if layer.namespace == "selection" and picker_layers > 0 then
    picker_layers = picker_layers - 1
    if picker_layers == 0 then
      for _, keybind in ipairs(picker_binds) do
        keybind:unbind()
      end
      picker_binds = {}
    end
  end
end)

-- ---- end: MY OVERRIDES ----


-- ############################################################################
-- REFERENCE: Omarchy's default keybindings (snapshot of omarchy 4.0.0.alpha)
-- ############################################################################
--
-- Everything below is a COMMENTED-OUT copy of Omarchy's shipped bindings, taken
-- from /usr/share/omarchy/default/hypr/bindings/. It does nothing on its own:
-- Omarchy still loads the real defaults first, and this file loads after them.
-- It exists so you can change bindings one at a time, in your own dotfiles.
--
-- HOW TO CHANGE A BINDING
--   1. Find it below and copy the o.bind(...) line, uncommented (in nvim: select
--      it and press `gc`), into MY OVERRIDES above. Leave this snapshot as is.
--   2. Add an unbind ABOVE it for the ORIGINAL key, otherwise the default and
--      your version both stay bound:
--          hl.unbind("SUPER + SPACE")
--   3. Edit the key, description or command on the uncommented line.
--      Example: SUPER+SPACE opens the root menu instead of the launcher:
--          hl.unbind("SUPER + SPACE")
--          o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")
--   4. Save. Hyprland reloads on file change; or run `hyprctl reload`.
--
-- TO DROP A DEFAULT WITHOUT REPLACING IT: uncomment nothing, just add
--      hl.unbind("<its keys>")
--
-- NOTES
--   - Lines look like "-- -- text" where Omarchy's own comment was preserved.
--     Toggling the block with `gc` turns those back into ordinary comments.
--   - Some sections use helpers or `local` variables (clipboard, selection
--     binds, bar panels). Uncomment a whole section, not a single line, if you
--     need one of those.
--   - This is a snapshot. After `omarchy-update`, compare against
--     /usr/share/omarchy/default/hypr/bindings/ or run
--     `omarchy menu keybindings --print` for the live list.
--   - To turn off ALL defaults and start from your own list, set
--     omarchy_default_bindings = false in hyprland.lua (before the
--     require("default.hypr.omarchy") line).
--
-- Sections: media | clipboard | tiling | utilities | voxtype | applications

-- ============================================================================
-- Media, volume, brightness  (omarchy: default/hypr/bindings/media.lua)
-- Locked = works on the lock screen; repeating = fires while held.
-- ============================================================================

-- -- Volume, brightness, keyboard backlight, and touchpad controls.
-- o.bind("XF86AudioRaiseVolume", "Volume up", "omarchy-audio-output-volume raise", { locked = true, repeating = true })
-- o.bind("XF86AudioLowerVolume", "Volume down", "omarchy-audio-output-volume lower", { locked = true, repeating = true })
-- o.bind("XF86AudioMute", "Mute", "omarchy-audio-output-volume mute-toggle", { locked = true })
-- o.bind("XF86AudioMicMute", "Mute microphone", "omarchy-audio-input-mute", { locked = true })
-- o.bind("XF86MonBrightnessUp", "Brightness up", "omarchy-brightness-display +5%", { locked = true, repeating = true })
-- o.bind("XF86MonBrightnessDown", "Brightness down", "omarchy-brightness-display 5%-", { locked = true, repeating = true })
-- o.bind("SHIFT + XF86MonBrightnessUp", "Brightness maximum", "omarchy-brightness-display 100%", { locked = true, repeating = true })
-- o.bind("SHIFT + XF86MonBrightnessDown", "Brightness minimum", "omarchy-brightness-display 1%", { locked = true, repeating = true })
-- o.bind("XF86KbdBrightnessUp", "Keyboard brightness up", "omarchy-brightness-keyboard up", { locked = true, repeating = true })
-- o.bind("XF86KbdBrightnessDown", "Keyboard brightness down", "omarchy-brightness-keyboard down", { locked = true, repeating = true })
-- o.bind("XF86KbdLightOnOff", "Keyboard backlight cycle", "omarchy-brightness-keyboard cycle", { locked = true })
-- o.bind_toggle("XF86TouchpadToggle", "Toggle touchpad", "touchpad", { locked = true })
-- o.bind("XF86TouchpadOn", "Enable touchpad", "omarchy-toggle-touchpad on", { locked = true })
-- o.bind("XF86TouchpadOff", "Disable touchpad", "omarchy-toggle-touchpad off", { locked = true })
--
-- -- Precise volume and brightness controls.
-- o.bind("ALT + XF86AudioRaiseVolume", "Volume up precise", "omarchy-audio-output-volume +1", { locked = true, repeating = true })
-- o.bind("ALT + XF86AudioLowerVolume", "Volume down precise", "omarchy-audio-output-volume -1", { locked = true, repeating = true })
-- o.bind("ALT + XF86MonBrightnessUp", "Brightness up precise", "omarchy-brightness-display +1%", { locked = true, repeating = true })
-- o.bind("ALT + XF86MonBrightnessDown", "Brightness down precise", "omarchy-brightness-display 1%-", { locked = true, repeating = true })
--
-- -- Media controls.
-- o.bind("XF86AudioNext", "Next track", "omarchy-shell media next", { locked = true })
-- o.bind("ALT + XF86AudioPlay", "Next track", "omarchy-shell media next", { locked = true })
-- o.bind("XF86AudioPause", "Pause", "omarchy-shell media playPause", { locked = true })
-- o.bind("XF86AudioPlay", "Play", "omarchy-shell media playPause", { locked = true })
-- o.bind("XF86AudioPrev", "Previous track", "omarchy-shell media previous", { locked = true })
-- o.bind("ALT + SHIFT + XF86AudioPlay", "Previous track", "omarchy-shell media previous", { locked = true })
-- o.bind("XF86Eject", "Eject media", "eject", { locked = true })
--
-- o.bind("SHIFT + XF86AudioMute", "Switch audio output", "omarchy-audio-output-switch", { locked = true })
-- o.bind("SHIFT + XF86AudioPause", "Switch media source", "omarchy-audio-source-switch", { locked = true })
-- o.bind("SHIFT + XF86AudioPlay", "Switch media source", "omarchy-audio-source-switch", { locked = true })

-- ---- end: Media, volume, brightness ----

-- ============================================================================
-- Universal clipboard  (omarchy: default/hypr/bindings/clipboard.lua)
-- SUPER+C/V/X work the same in every app; terminals get Ctrl+Insert / Shift+Insert. The helper functions must be uncommented together with the binds.
-- ============================================================================

-- -- Send with explicit mods to the focused surface by omitting the window target,
-- -- so universal clipboard shortcuts reach both normal windows and focused
-- -- layer-shell surfaces such as Omarchy panels. A virtual keyboard (wtype) won't
-- -- do: the physically held SUPER merges into the injected chord at the seat.
-- -- The down/up split works around Hyprland send_shortcut sometimes leaving
-- -- synthetic key state stuck/repeating.
-- -- https://github.com/hyprwm/Hyprland/discussions/14099
-- local function send_shortcut_once(mods, key)
--   return function()
--     hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
--
--     hl.timer(function()
--       hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
--     end, { timeout = 50, type = "oneshot" })
--   end
-- end
--
-- -- Lean on the terminal tag from default/hypr/apps/terminals.lua so there's one
-- -- definition of what counts as a terminal. Dynamic tags carry a trailing "*".
-- local function active_window_is_terminal()
--   local window = hl.get_active_window()
--   if not window then
--     return false
--   end
--
--   for _, tag in ipairs(window.tags or {}) do
--     if tag:gsub("%*$", "") == "terminal" then
--       return true
--     end
--   end
--
--   return false
-- end
--
-- local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
--   return function()
--     if active_window_is_terminal() then
--       send_shortcut_once(terminal_mods, terminal_key)()
--     else
--       send_shortcut_once(default_mods, default_key)()
--     end
--   end
-- end
--
-- o.bind("SUPER + C", "Universal copy", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"))
-- o.bind("SUPER + V", "Universal paste", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"))
-- o.bind("SUPER + X", "Universal cut", send_shortcut_once("CTRL", "X"))
-- o.bind("SUPER + CTRL + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

-- ---- end: Universal clipboard ----

-- ============================================================================
-- Windows, workspaces, groups  (omarchy: default/hypr/bindings/tiling.lua)
-- Focus, move, resize, workspaces 1-10, scratchpad, groups, mouse drag/scroll.
-- ============================================================================

-- o.bind("SUPER + W", "Close window", hl.dsp.window.close())
-- o.bind("CTRL + ALT + DELETE", "Close all windows", "omarchy-hyprland-window-close-all")
--
-- o.bind("SUPER + J", "Toggle window split", hl.dsp.layout("togglesplit"))
-- o.bind("SUPER + P", "Pseudo window", hl.dsp.window.pseudo())
-- o.bind("SUPER + T", "Toggle window floating/tiling", hl.dsp.window.float({ action = "toggle" }))
-- o.bind("SUPER + F", "Full screen", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
-- o.bind("SUPER + CTRL + F", "Tiled full screen", "omarchy-hyprland-window-tiled-fullscreen-toggle")
-- o.bind("SUPER + ALT + F", "Full width", hl.dsp.window.fullscreen({ mode = "maximized" }))
-- o.bind("SUPER + O", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
-- o.bind("SUPER + ALT + Home", "Save window width", "omarchy-hyprland-window-width save")
-- o.bind("SUPER + Home", "Restore window width", "omarchy-hyprland-window-width restore")
-- o.bind("SUPER + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
--
-- o.bind("SUPER + LEFT", "Focus on left window", hl.dsp.focus({ direction = "l" }))
-- o.bind("SUPER + RIGHT", "Focus on right window", hl.dsp.focus({ direction = "r" }))
-- o.bind("SUPER + UP", "Focus on above window", hl.dsp.focus({ direction = "u" }))
-- o.bind("SUPER + DOWN", "Focus on below window", hl.dsp.focus({ direction = "d" }))
--
-- for workspace = 1, 10 do
--   local key = "code:" .. tostring(workspace + 9)
--   o.bind("SUPER + " .. key, "Switch to workspace " .. workspace, hl.dsp.focus({ workspace = tostring(workspace) }))
--   o.bind("SUPER + SHIFT + " .. key, "Move window to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace) }))
--   o.bind("SUPER + SHIFT + ALT + " .. key, "Move window silently to workspace " .. workspace, hl.dsp.window.move({ workspace = tostring(workspace), follow = false }))
-- end
--
-- o.bind("SUPER + S", "Toggle scratchpad", hl.dsp.workspace.toggle_special("scratchpad"))
-- o.bind("SUPER + ALT + S", "Move window to scratchpad", hl.dsp.window.move({ workspace = "special:scratchpad", follow = false }))
--
-- o.bind("SUPER + TAB", "Next workspace", hl.dsp.focus({ workspace = "e+1" }))
-- o.bind("SUPER + SHIFT + TAB", "Previous workspace", hl.dsp.focus({ workspace = "e-1" }))
-- o.bind("SUPER + CTRL + TAB", "Former workspace", hl.dsp.focus({ workspace = "previous" }))
--
-- o.bind("SUPER + SHIFT + ALT + LEFT", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
-- o.bind("SUPER + SHIFT + ALT + RIGHT", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
-- o.bind("SUPER + SHIFT + ALT + UP", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
-- o.bind("SUPER + SHIFT + ALT + DOWN", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))
--
-- o.bind("SUPER + SHIFT + LEFT", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
-- o.bind("SUPER + SHIFT + RIGHT", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
-- o.bind("SUPER + SHIFT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
-- o.bind("SUPER + SHIFT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))
--
-- o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
-- o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))
-- o.bind("ALT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
-- o.bind("ALT + SHIFT + TAB", "Reveal active window on top", hl.dsp.window.bring_to_top())
--
-- o.bind("CTRL + ALT + TAB", "Focus on next monitor", hl.dsp.focus({ monitor = "+1" }))
-- o.bind("CTRL + ALT + SHIFT + TAB", "Focus on previous monitor", hl.dsp.focus({ monitor = "-1" }))
--
-- o.bind("SUPER + code:20", "Expand window left", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
-- o.bind("SUPER + code:21", "Shrink window left", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
-- o.bind("SUPER + SHIFT + code:20", "Shrink window up", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))
-- o.bind("SUPER + SHIFT + code:21", "Expand window down", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
--
-- o.bind("SUPER + ALT + code:20", "Expand window left a little", hl.dsp.window.resize({ x = -25, y = 0, relative = true }))
-- o.bind("SUPER + ALT + code:21", "Shrink window left a little", hl.dsp.window.resize({ x = 25, y = 0, relative = true }))
-- o.bind("SUPER + SHIFT + ALT + code:20", "Shrink window up a little", hl.dsp.window.resize({ x = 0, y = -25, relative = true }))
-- o.bind("SUPER + SHIFT + ALT + code:21", "Expand window down a little", hl.dsp.window.resize({ x = 0, y = 25, relative = true }))
--
-- o.bind("SUPER + CTRL + code:20", "Expand window left a lot", hl.dsp.window.resize({ x = -300, y = 0, relative = true }))
-- o.bind("SUPER + CTRL + code:21", "Shrink window left a lot", hl.dsp.window.resize({ x = 300, y = 0, relative = true }))
-- o.bind("SUPER + CTRL + SHIFT + code:20", "Shrink window up a lot", hl.dsp.window.resize({ x = 0, y = -300, relative = true }))
-- o.bind("SUPER + CTRL + SHIFT + code:21", "Expand window down a lot", hl.dsp.window.resize({ x = 0, y = 300, relative = true }))
--
-- o.bind("SUPER + mouse_down", "Scroll active workspace forward", hl.dsp.focus({ workspace = "e+1" }))
-- o.bind("SUPER + mouse_up", "Scroll active workspace backward", hl.dsp.focus({ workspace = "e-1" }))
--
-- o.bind("SUPER + mouse:272", "Move window", hl.dsp.window.drag(), { mouse = true })
-- o.bind("SUPER + mouse:273", "Resize window", hl.dsp.window.resize(), { mouse = true })
--
-- o.bind("SUPER + G", "Toggle window grouping", hl.dsp.group.toggle())
-- o.bind("SUPER + ALT + G", "Move active window out of group", hl.dsp.window.move({ out_of_group = true }))
--
-- o.bind("SUPER + ALT + LEFT", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
-- o.bind("SUPER + ALT + RIGHT", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
-- o.bind("SUPER + ALT + UP", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
-- o.bind("SUPER + ALT + DOWN", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))
--
-- o.bind("SUPER + ALT + TAB", "Next window in group", hl.dsp.group.next())
-- o.bind("SUPER + ALT + SHIFT + TAB", "Previous window in group", hl.dsp.group.prev())
--
-- o.bind("SUPER + CTRL + LEFT", "Move grouped window focus left", hl.dsp.group.prev())
-- o.bind("SUPER + CTRL + RIGHT", "Move grouped window focus right", hl.dsp.group.next())
--
-- o.bind("SUPER + ALT + mouse_down", "Next window in group", hl.dsp.group.next())
-- o.bind("SUPER + ALT + mouse_up", "Previous window in group", hl.dsp.group.prev())
--
-- for index = 1, 5 do
--   o.bind("SUPER + ALT + code:" .. tostring(index + 9), "Switch to group window " .. index, hl.dsp.group.active({ index = index }))
-- end
--
-- o.bind("SUPER + SLASH", "Monitor scaling up", "omarchy-hyprland-monitor-scaling up")
-- o.bind("SUPER + ALT + SLASH", "Monitor scaling down", "omarchy-hyprland-monitor-scaling down")

-- ---- end: Windows, workspaces, groups ----

-- ============================================================================
-- Menus, notifications, capture, panels  (omarchy: default/hypr/bindings/utilities.lua)
-- Includes the region-selection binds that only exist while a screenshot selection is open.
-- ============================================================================

-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle")
-- o.bind("SUPER + ALT + SPACE", "Apps menu", "omarchy-menu toggle apps")
-- o.bind("SUPER + CTRL + E", "Emojis", "omarchy-shell shell toggle omarchy.emojis")
-- o.bind("SUPER + CTRL + C", "Capture menu", "omarchy-menu toggle capture")
-- o.bind("SUPER + CTRL + O", "Toggle menu", "omarchy-menu toggle toggle")
-- o.bind("SUPER + CTRL + H", "Hardware menu", "omarchy-menu toggle hardware")
-- o.bind("SUPER + SHIFT + code:201", "Omarchy menu", "omarchy-menu toggle root")
-- o.bind("SUPER + ESCAPE", "System menu", "omarchy-menu toggle system")
-- o.bind("XF86PowerOff", "Power menu", "omarchy-menu toggle system", { locked = true })
-- o.bind("SUPER + K", "Keybindings", "omarchy-menu-keybindings")
-- o.bind("SUPER + ALT + K", "Tmux keybindings", "omarchy-menu-tmux-keybindings")
-- o.bind("SUPER + CTRL + K", "Herdr keybindings", "omarchy-menu-herdr-keybindings")
-- o.bind("SUPER + CTRL + Q", "Calculator", "omacalc")
-- o.bind("XF86Calculator", "Calculator", "omacalc")
--
-- o.bind_toggle("SUPER + SHIFT + SPACE", "Toggle top bar", "bar")
-- o.bind("SUPER + CTRL + SPACE", "Background switcher", "omarchy-menu toggle background")
-- o.bind("SUPER + SHIFT + CTRL + SPACE", "Theme menu", "omarchy-menu toggle theme")
-- o.bind("SUPER + BACKSPACE", "Toggle window transparency", "omarchy-hyprland-window-transparency-toggle")
-- o.bind("SUPER + SHIFT + BACKSPACE", "Toggle window gaps", "omarchy-hyprland-window-gaps-toggle")
-- o.bind("SUPER + CTRL + BACKSPACE", "Toggle single-window square aspect", "omarchy-hyprland-window-single-square-aspect-toggle")
--
-- -- xkbcommon names the comma keysym "comma"; the upper-case "COMMA" does not match.
-- o.bind("SUPER + comma", "Dismiss last notification", "omarchy-shell notifications dismissOne")
-- o.bind("SUPER + SHIFT + comma", "Dismiss all notifications", "omarchy-shell notifications dismissAll")
-- o.bind_toggle("SUPER + CTRL + comma", "Toggle silencing notifications", "notification-silencing")
-- o.bind("SUPER + ALT + comma", "Invoke last notification", "omarchy-shell notifications invokeLast")
-- o.bind("SUPER + SHIFT + ALT + comma", "Open notification history", "omarchy-shell notifications showHistory")
--
-- o.bind_toggle("SUPER + CTRL + I", "Toggle locking on idle", "idle")
-- o.bind_toggle("SUPER + CTRL + N", "Toggle nightlight", "nightlight")
-- o.bind("SUPER + CTRL + Delete", "Toggle laptop display", "omarchy-hyprland-monitor-internal toggle")
-- o.bind("SUPER + CTRL + ALT + Delete", "Toggle laptop display mirroring", "omarchy-hyprland-monitor-internal-mirror toggle")
-- o.bind("switch:on:Lid Switch", nil, "omarchy-system-lid-close", { locked = true })
-- o.bind("switch:off:Lid Switch", nil, "omarchy-hyprland-monitor-clamshell", { locked = true })
--
-- o.bind("PRINT", "Screenshot", "omarchy-capture-screenshot")
-- o.bind("ALT + PRINT", "Screenrecording", "omarchy-capture-screenrecording --stop-recording || omarchy-menu toggle trigger.capture.screenrecord")
-- o.bind("SUPER + ALT + code:34", "Make webcam overlay smaller", "omarchy-capture-webcam-resize smaller")
-- o.bind("SUPER + ALT + code:35", "Make webcam overlay larger", "omarchy-capture-webcam-resize larger")
-- o.bind("SUPER + PRINT", "Color picker", "pkill hyprpicker || hyprpicker -a")
-- o.bind("SUPER + CTRL + PRINT", "Extract text (OCR) from screenshot", "omarchy-capture-text")
--
-- -- Keyboard control for the slurp region picker (see omarchy-capture-region).
-- -- The binds live exactly as long as a selection layer is on screen (slurp
-- -- opens one per monitor), so they cannot leak or get stuck.
-- -- Unbinding by key would take a same-key binding out of the user's own config
-- -- with it, so each handle is kept and removed individually.
-- local selection_layers = 0
-- local selection_binds = {}
--
-- hl.on("layer.opened", function(layer)
--   if layer.namespace == "selection" then
--     selection_layers = selection_layers + 1
--     if selection_layers == 1 then
--       selection_binds = {
--         hl.bind("RETURN", hl.dsp.exec_cmd("omarchy-capture-region --take-window"), { description = "Capture highlighted window" }),
--         hl.bind("CTRL + RETURN", hl.dsp.exec_cmd("omarchy-capture-region --take-fullscreen"), { description = "Capture entire screen" }),
--         hl.bind("TAB", hl.dsp.exec_cmd("omarchy-capture-region --select-window next"), { description = "Select next window to capture" }),
--         hl.bind("CTRL + TAB", hl.dsp.exec_cmd("omarchy-capture-region --select-window prev"), { description = "Select previous window to capture" }),
--       }
--       for _, direction in ipairs({ "left", "right", "up", "down" }) do
--         table.insert(
--           selection_binds,
--           hl.bind(direction:upper(), hl.dsp.exec_cmd("omarchy-capture-region --select-window " .. direction), { description = "Select window to capture" })
--         )
--       end
--     end
--   end
-- end)
--
-- hl.on("layer.closed", function(layer)
--   if layer.namespace == "selection" and selection_layers > 0 then
--     selection_layers = selection_layers - 1
--     if selection_layers == 0 then
--       for _, keybind in ipairs(selection_binds) do
--         keybind:unbind()
--       end
--       selection_binds = {}
--     end
--   end
-- end)
--
-- o.bind("SUPER + CTRL + S", "Share", "omarchy-menu toggle share")
--
-- o.bind("SUPER + CTRL + PERIOD", "Transcode", "omarchy-transcode")
--
-- o.bind("SUPER + CTRL + R", "Set reminder", "omarchy-menu toggle reminder-set")
-- o.bind("SUPER + CTRL + ALT + R", "Show reminders", "omarchy-reminder show")
-- o.bind("SUPER + SHIFT + CTRL + R", "Clear reminders", "omarchy-reminder clear")
--
-- o.bind("SUPER + CTRL + ALT + T", "Show time", "omarchy-notification-time")
-- o.bind("SUPER + CTRL + ALT + B", "Show battery remaining", "omarchy-notification-battery")
-- o.bind("SUPER + CTRL + ALT + W", "Toggle weather", "omarchy-notification-weather")
--
-- o.bind("SUPER + SHIFT + CTRL + A", "Agent", "omarchy-agent --pick")
-- o.bind("SUPER + CTRL + A", "Audio", "omarchy-shell shell toggle omarchy.audio")
-- o.bind("SUPER + CTRL + B", "Bluetooth", "omarchy-shell shell toggle omarchy.bluetooth")
-- o.bind("SUPER + CTRL + D", "Display", "omarchy-shell shell toggle omarchy.monitor")
-- o.bind("SUPER + CTRL + ALT + D", "Calendar", "omarchy-shell shell toggle omarchy.clock")
-- o.bind("SUPER + CTRL + W", "Network", "omarchy-shell shell toggle omarchy.network")
-- o.bind("SUPER + CTRL + P", "Power", "omarchy-shell shell toggle omarchy.power")
-- o.bind("SUPER + CTRL + T", "Activity", { tui = "btop" })
--
-- -- The letters above name a panel; the numbers count them. 1 is the leftmost
-- -- panel in the bar's right section, and a widget with no panel of its own (the
-- -- tray) is not counted, so the number matches the icon a user would point at.
-- -- A bar with fewer panels than this leaves the tail of the range doing nothing.
-- for panel = 1, 9 do
--   o.bind(
--     "SUPER + CTRL + code:" .. tostring(panel + 9),
--     "Bar panel " .. panel,
--     "omarchy-shell -q shell togglePanelAt right " .. panel
--   )
-- end
--
-- o.bind("SUPER + CTRL + Z", "Zoom in", function()
--   local zoom = hl.get_config("cursor.zoom_factor") or 1
--   hl.config({ cursor = { zoom_factor = zoom + 1 } })
-- end)
--
-- o.bind("SUPER + CTRL + ALT + Z", "Reset zoom", function()
--   hl.config({ cursor = { zoom_factor = 1 } })
-- end)
--
-- o.bind("SUPER + CTRL + L", "Lock system", "omarchy-system-lock")

-- ---- end: Menus, notifications, capture, panels ----

-- ============================================================================
-- Dictation (voxtype)  (omarchy: default/hypr/bindings/voxtype.lua)
-- Only bound if the voxtype command is installed.
-- ============================================================================

-- if o.cmd_present("voxtype") then
--   o.bind("SUPER + CTRL + X", "Toggle dictation", "voxtype record toggle")
--   o.bind("F9", "Start dictation (push-to-talk)", "voxtype record start")
--   o.bind("F9", "Stop dictation (push-to-talk)", "voxtype record stop", { release = true })
-- end

-- ---- end: Dictation (voxtype) ----

-- ============================================================================
-- Applications and web apps  (omarchy: default/hypr/bindings/applications.lua)
-- Loaded optionally; the block inside o.preinstalled_bindings_enabled() covers preinstalled apps and web apps.
-- ============================================================================

-- -- Essential application bindings.
-- o.bind("SUPER + RETURN", "Terminal", { omarchy = "terminal" })
-- o.bind("SUPER + SHIFT + RETURN", "Browser", { omarchy = "browser" })
-- o.bind("SUPER + SHIFT + F", "File manager", { omarchy = "nautilus" })
-- o.bind("SUPER + ALT + SHIFT + F", "File manager (cwd)", { omarchy = "nautilus-cwd" })
-- o.bind("SUPER + SHIFT + B", "Browser", { omarchy = "browser" })
-- o.bind("SUPER + SHIFT + ALT + B", "Browser (private)", { omarchy = "browser --private" })
-- o.bind("SUPER + SHIFT + N", "Editor", { omarchy = "editor" })
--
-- if o.preinstalled_bindings_enabled() then
--   -- Bindings for preinstalled Omarchy applications, TUIs, and web apps.
--   o.bind("SUPER + ALT + RETURN", "Tmux", { omarchy = "terminal-tmux" })
--   o.bind("SUPER + CTRL + RETURN", "Herdr", { omarchy = "terminal-herdr" })
--   o.bind("SUPER + SHIFT + M", "Music", { omarchy = "spotify" })
--   o.bind("SUPER + SHIFT + ALT + M", "Music TUI", { tui = "cliamp", focus = true })
--   o.bind("SUPER + SHIFT + D", "Docker", { tui = "omarchy-launch-docker-tui" })
--   o.bind("SUPER + SHIFT + G", "Signal", { omarchy = "signal" })
--   o.bind("SUPER + SHIFT + O", "Obsidian", { launch = "obsidian", focus = "^obsidian$" })
--   o.bind("SUPER + SHIFT + W", "Omawrite", { launch = "omawrite" })
--   o.bind("SUPER + SHIFT + SLASH", "Passwords", { omarchy = "1password" })
--
--   o.bind("SUPER + SHIFT + A", "ChatGPT", { webapp = "https://chatgpt.com" })
--   o.bind("SUPER + SHIFT + ALT + A", "Grok", { webapp = "https://grok.com" })
--   o.bind("SUPER + SHIFT + C", "Calendar", { webapp = "https://app.hey.com/calendar/weeks/" })
--   o.bind("SUPER + SHIFT + E", "Email", { webapp = "https://app.hey.com" })
--   o.bind("SUPER + SHIFT + ALT + E", "New email", { webapp = "https://app.hey.com/messages/new?display=standalone&new_window=true" })
--   o.bind("SUPER + SHIFT + Y", "YouTube", { webapp = "https://youtube.com/" })
--   o.bind("SUPER + SHIFT + ALT + G", "WhatsApp", { webapp = "https://web.whatsapp.com/", focus = true })
--   o.bind( "SUPER + SHIFT + CTRL + G", "Google Messages", { webapp = "https://messages.google.com/web/conversations", focus = true })
--   o.bind("SUPER + SHIFT + P", "Google Photos", { webapp = "https://photos.google.com/", focus = true })
--   o.bind("SUPER + SHIFT + S", "Google Maps", { webapp = "https://maps.google.com/", focus = true })
--   o.bind("SUPER + SHIFT + X", "X", { webapp = "https://x.com/" })
--   o.bind("SUPER + SHIFT + ALT + X", "X Post", { webapp = "https://x.com/compose/post" })
-- end

-- ---- end: Applications and web apps ----
