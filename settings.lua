-- Override settings here, or setup variables before loading any addons --
-- n = NotITG only, o = Outfox only                                     --
--------------------------------------------------------------------------

-- [n] OpenITG compatibility
-- config.addons_files = {}

-- [n] (OpenITG, V1, V2, V3, V3.1, V4, V4.0.1, V4.2). Defaults to the lastest NotITG version this template handles.
-- config.minimum_build = 'OpenITG'

-- [?] Hides the topscreen elements automatically
-- config.autohide_elements = false

-- [?] Restrict only two player mode on the file.
-- config.force_two_players = false

-- [n] Set allowed resolution ratios. By default this check is disabled.
-- config.allowed_resolutions = { 4/3, 16/9 }

-- [?] Use a custom update rate instead of luaeffect
-- config.custom_update = 60
-- [?] (If above is enabled), use deltatime update instead of queuecommand
-- config.custom_update_type = true

-- [n] (V3.1 below), allow players with D3D enabled.
-- config.allow_d3d_render = not FUCK_EXE

-- [?] modreader.lua config
config.modreader = {}
-- [m] OpenITG compatibility
-- config.modreader._default = { 'exschwasion' }

-- [?] Any miscellaneous checks are done here
config.misc_checks = true