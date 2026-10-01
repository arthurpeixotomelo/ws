local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local mux = wezterm.mux
local gui = wezterm.gui

wezterm.on("update-status", function(window, pane)
    local success, stdout, stderr = wezterm.run_child_process({
        "nu", "~/ws/config/wezterm/status.nu"
    })

    if success then
        window:set_right_status(stdout)
    end
end)

config.default_prog = { '/usr/bin/nu' }

return config