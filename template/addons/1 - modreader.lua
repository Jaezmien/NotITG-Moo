modreader = {}
config.modreader = config.modreader or {}

--

if OPENITG then
	local activation_rate = FUCK_EXE and '*-1 ' or '*9999 '
	mod_do = function(mod, pn) GAMESTATE:ApplyGameCommand('mod,' .. string.gsub(mod, '(%*%-%d) ', activation_rate), pn) end
	if version_minimum('V2') then mod_do = function(mod, pn) GAMESTATE:ApplyModifiers(mod, pn) end end
else
	local poptions = {}
	function mod_do(mod, pn)
		if not pn then for pn=1,2 do mod_do(mod, pn) end; return; end
		return poptions[pn]:FromString( string.gsub(mod, '(%*%-%d) ', '*9999 ') )
	end
	for pn=1,2 do
		if GAMESTATE:IsPlayerEnabled(pn-1) then poptions[pn] = GAMESTATE:GetPlayerState(pn - 1):GetPlayerOptions('ModsLevel_Song') end
	end
end

--

local files = {}
local function get_helper(pure, req)
	local helpers = {}
	for i,v in ipairs( files ) do
		if string.sub( v, 1, 1 ) == "_" then helpers[v]=v end
	end

	-- first we check for an X.lua, that means it's compatible for both versions
	-- otherwise, we need to grab the compatible file
	return (helpers[ "_modhelper " .. pure .. ".lua" ]) or
			(req and helpers[ "_modhelper " .. pure .. "." .. req .. ".lua" ]) or
			(_print("[Mod Reader]", "Could not find a compatible reader for " .. pure) and nil)
end

if OPENITG then
	if (config.minimum_build == 'OpenITG') or not FUCK_EXE then
		files = config.modreader._default or {'exschwasion'}
		if table.getn( files ) == 1 and string.sub(v, 1, 1) ~= "_" then table.insert( files, "_modhelper " .. files[1] ) end
		for i,v in ipairs( files ) do
			if string.sub(v, -4) ~= '.lua' then files[i] = v .. '.lua' end
		end
	else
		files = { GAMESTATE:GetFileStructure(song_dir .. 'template/addons/modreaders/') }
	end
else -- outfox
	files = FILEMAN:GetDirListing( song_dir .. "template/addons/modreaders/" )
end

local readers = {}
for _, v in pairs(files) do
	if string.sub(v, -4) == '.lua' and string.sub(v, 1, 1) ~= '_' then

		local condition = true -- both compatible
		if string.sub(v, -11, -5) == ".notitg" and not FUCK_EXE then condition = false; end -- notitg only
		if string.sub(v, -11, -5) == ".outfox" and OPENITG then condition = false; end -- outfox only
		
		if condition then
			local name = string.sub(v, 1, -5)
			local pure = name
			local cond = nil
			if string.sub(name, -7) == ".notitg" or string.sub(name, -7) == ".outfox" then
				pure = string.sub( name, 1, -8 )
				cond = string.sub(name, -6)
			end

			config.modreader[ pure ] = config.modreader[ pure ] or {}

			table.insert(readers, {
				name = name,
				pure_name = pure,
				condition = cond
			})
		end
	end -- Discard other files
end

local updates = {}
local updates_clear = false

for _, v in pairs(readers) do
	local reader, options = lua('template/addons/modreaders/' .. v.name)
	if type(reader) == 'table' then
		local helper = {}
		do
			local helper_filename = get_helper( v.pure_name, v.condition )
			if helper_filename then
				helper = lua{ 'template/addons/modreaders/' .. helper_filename, env = reader }
			end
		end
		if type(helper) ~= 'table' then helper = {} end

		setmetatable(reader, {__index = melody})
		setmetatable(helper, {__index = reader, __newindex = melody})

		local reader_name = v.pure_name

		modreader[reader_name] = helper
		updates[reader_name] = options.func
		if options.clear == true then updates_clear = true
		elseif options.clear == false and updates_clear then

			if options.disable then
				options.disable()
				_print('[Mod Reader]', 'A template requested `clearall` functionality, "'.. reader_name ..'" reader will stop applying mods.')
			else
				modreader[reader_name] = nil; updates[reader_name] = nil
				_print('[Mod Reader]', 'A template requested `clearall` functionality, which breaks "'.. reader_name ..'" reader. Ignoring...')
			end

		end

		if modreader[reader_name] then _print('[Mod Reader]', 'Loaded ' .. reader_name .. ' mod reader') end
	end
end

update_hooks{ 'modreader update', function()

	if updates_clear then mod_do('*-1 clearall') end

	for id,func in pairs( updates ) do
		local res, err = pcall( func )
		if not res then
			_print('[Mod Reader]', id .. ' reader error')
			_print( err )
			updates[ id ] = nil
		end
	end

end }