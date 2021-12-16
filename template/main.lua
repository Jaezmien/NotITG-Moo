--+ Miscellaneous +--
do
	local function is_actor(actor)
		if OPENITG then return type(actor) == "userdata" end
		return type(actor) == "table" and actor._Line and actor._Dir and actor._Source
	end

	-- Table
	do
		table = setmetatable({}, {__index = _G.table})
		table.contains = function(t, x) for _,v in pairs(t) do if v==x then return true end end return false end
		table.shuffle = function(t) local l=table.getn(t); for i=l,2,-1 do local j =math.random(i, l); t[i],t[j]=t[j],t[i] end; return t end
		table.clone = function(t)
			local ot = type(t); if ot ~= 'table' then return t end
			local copy = {}; for ok, ov in pairs(t) do copy[table.clone(ok)] = table.clone(ov) end
			setmetatable(copy, table.clone(getmetatable(t))); return copy
		end
		table.weak_clone = function(t)
			if type(t) ~= 'table' then return t end;
			local _t = {}; for k,v in pairs(t) do _t[k] = (type(v) == 'table') and table.weak_clone(v) or v end; return _t
		end
		table.index_from_value = function(t, k) for i,v in pairs(t) do if v==k then return i end end return nil end
		table.to_array = function(t) local a = {}; for _, v in pairs(t) do table.insert(a, v) end; return a end
	end

	-- Math
	do
		math = setmetatable({}, {__index = _G.math})
		math.round = function(a, b) b = math.pow(10, b or 0); return (math.floor(a * b + 0.5)) / b end
		math.round2 = function(a, b) return tonumber(string.format("%.".. (b or 0) .."f", a)) end -- rounding but no add
		math.mod = function(a, b) b=b or 1; return a - math.floor(a / b) * b; end
		math.clamp = function(val, mn, mx) return math.max(mn, math.min(mx, val)); end
		math.norm = function(val, _min, _max, min, max) min = min or 0; max = max or 1; return (max - min) * ((val - _min) / (_max - _min)) + min; end
		math.dist1d = function(a, b)
			local x,y = (type(a) == 'table' and unpack(a) or a), (type(b) == 'table' and unpack(b) or b)
			local d = y-x; return math.sqrt(d * d)
		end
		math.dist2d = function(a, b)
			local x,y = (is_actor(a) and {a:GetX(), a:GetY()} or a), (is_actor(b) and {b:GetX(), b:GetY()} or b)
			local dx,dy = (y[1]-x[1]), (y[2]-x[2]); return math.sqrt(dx * dx + dy * dy)
		end
		math.dist = math.dist2d -- shortcut
		math.dist3d = function(a, b)
			local x,y = (is_actor(a) and {a:GetX(), a:GetY(), a:GetZ()} or a), (is_actor(b) and {b:GetX(), b:GetY(), a:GetZ()} or b) 
			local dx,dy,dz = (y[1]-x[1]), (y[2]-x[2]), (y[3]-x[3]); return math.sqrt(dx * dx + dy * dy + dz * dz)
		end
		math.random_float = function(mn, mx) if mn==mx then return mn end if mn > mx then mn,mx=mx,mn end return math.random() * (mx - mn) + mn end
	end
end

--+ Configuration +--
do

	-- See settings.lua for more info
	config = {
		-- ITG
		addons_files = {},
		minimum_build = 'V4.2',
		allowed_resolutions = nil,
		allow_d3d_renderer = false,
		default_modreader = {},

		-- General
		autohide_elements = true,
		force_twoplayers = true,
		custom_update = nil,
		custom_update_type = false,
		misc_checks = true,
	}

	function version_minimum() return true end
	if OPENITG then
		nitg_versions = {
			['V1']     = 20161226,
			['V2']     = 20170405,
			['V3']     = 20180617,
			['V3.1']   = 20180909,
			['V4']     = 20200112,
			['V4.0.1'] = 20200126,
			['V4.2']    = 20210420,
		}
		
		function version_minimum(ver)
			if config.minimum_build == 'OpenITG' then return (ver == 'OpenITG') end
			return FUCK_EXE and (tonumber(GAMESTATE:GetVersionDate()) >= nitg_versions[ver])
		end
	end

	_print('[@]', 'Loading custom settings...')
	lua('settings')

end

-- prevent outfox from reparsing
local function do_actor_cmd( actor, cmdstr )
	local t = 'cmd'
	actor[t]( actor, cmdstr )
end

do
	song_time = 0

	mod_plr = setmetatable({}, {
		__call = function(s, action)
			if type(action) == 'function' then
				for i,v in ipairs(s) do if v then action(v, i) end end
			elseif type(action) == 'string' and OPENITG then
				for _,v in ipairs(s) do if v then do_actor_cmd(v,action) end end
			end
		end
	})
	mod_plr_origin = {{0, 0}, {0, 0}}

	SCREEN_FOV = function(fov) return 360 / math.pi * math.atan(math.tan(math.pi * (1 / (360 / fov))) * _G.SCREEN_WIDTH / _G.SCREEN_HEIGHT * 0.75) end
	if OPENITG then
		SCREEN_WIDTH = 480 * PREFSMAN:GetPreference('DisplayAspectRatio')
		SCREEN_CENTER_X = SCREEN_WIDTH / 2
		SCREEN_WIDTH_MULT = SCREEN_WIDTH / 640
		SCREEN_HEIGHT_MULT = SCREEN_HEIGHT / 480
	else
		local sw = 480 * PREFSMAN:GetPreference("DisplayAspectRatio")
		local sh = 640 / PREFSMAN:GetPreference("DisplayAspectRatio")
		SCREEN_WIDTH_MULT = sw / 640
		SCREEN_HEIGHT_MULT = sh / 480
	end

	if OPENITG then
		local last_beat_offset = FUCK_EXE and ( GAMESTATE:IsEditMode() and 8 or 4 ) or 0
		last_beat = FUCK_EXE and (GAMESTATE:GetCurrentSong():GetBeatFromElapsedTime(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) + last_beat_offset) or 999
	end

	song_dir = GAMESTATE:GetCurrentSong():GetSongDir()
end

do
	get_song_time = function()
		return (
			OPENITG and (version_minimum('V2') and GAMESTATE:GetSongTime() or song_time)
			or (PREFSMAN:GetPreference('GlobalOffsetSeconds') + GAMESTATE:GetCurMusicSeconds())
		)
	end
	get_os_time = function()
		return (
			OPENITG and (os and os.clock() or GlobalClock:GetSecsIntoEffect())
			or GetTimeSinceStart()
		)
	end
	
	function check()

		if OPENITG then
			if config.minimum_build ~= 'OpenITG' then
				if not FUCK_EXE then
					__error('NotITG ' .. config.minimum_build .. ' beyond is needed to play this file')
					return
				end
				if not version_minimum(config.minimum_build) then
					__error('Outdated NotITG Version detected, this file only works on ' .. config.minimum_build .. ' onwards')
					return
				end
			end

			-- i'd use DisplayAspectRatio for anamorphic widescreen
			-- but there are times where the decimal points of the aspect ratio not matching the ratio float.
			if config.allowed_resolutions and not table.contains(config.allowed_resolutions, PREFSMAN:GetPreference('DisplayWidth') / PREFSMAN:GetPreference('DisplayHeight')) then
				__error('Invalid resolution detected')
				return
			end
		end

		if config.force_twoplayers and not (GAMESTATE:IsPlayerEnabled(0) and GAMESTATE:IsPlayerEnabled(1)) then
			__error('Two players are needed to play this file')
			return
		end
	
		if config.misc_checks ~= true then
			local add = type(config.misc_checks) == "string" and ": "..(config.misc_checks) or "";
			__error('Miscellaneous check returned invalid' .. add)
			return
		end

	end
end

--+ Addons +--
do
    addons = {}
    function addons:load()

		if (config.minimum_build == 'OpenITG') or (not FUCK_EXE and OPENITG) then
			for _,v in pairs(config.addons_files) do table.insert(self,v) end
			return
		end

		local files = (
			OPENITG and { GAMESTATE:GetFileStructure(song_dir .. 'template/addons/') }
			or FILEMAN:GetDirListing( song_dir .. "template/addons/" )
		)

        for _, v in ipairs(files) do
			local cond = (OPENITG and (string.sub(v, -4) == '.xml')) or (string.sub(v, -4) == '.lua')
            if cond and string.sub(v, 1, 1) ~= '_' then

				local condition = true -- both compatible
				if string.sub(v, -12, -5) == ".notitg" and not OPENITG then condition = false; -- notitg only
				elseif string.sub(v, -12, -5) == ".outfox" and OPENITG then condition = false; -- outfox only
				end
				
				if condition then
					if OPENITG then table.insert(self, v)
					else
						_print("[@]", "Loading Addon >> " .. v)
						local addon = lua( "template/addons/" .. v )
						if type(addon) == "table" then table.insert(self, addon) end
					end
				end
            end
        end

    end
	
	-- OpenITG
	addons.continue = true
	addons.index = 0
	function addons:get()
        local count = self.index + 1

        local stop = false
        while (not stop) and (self[count] and string.sub(self[count], -4) == '.lua') do
            _print('[@]', 'Loading Lua Addon >> ' .. self[count])
            lua{
                'template/addons/' .. self[count],
                error = function(err)
                    _print('[@]','<Error>','An error has occured while loading the addon')
                    _print('[@]', err)
                    __error('An error has occured while loading an addon')
                    stop = true
                end,
            }
            count=count+1
        end

        if not addons[count] or melody_error then self.continue = false; return false; end
        
        self.index = count
        return true
    end
    function addons:grab_xml()
        _print('[@]', 'Loading XML Addon >> ' .. self[self.index])
        return 'addons/' .. self[self.index]
    end
end 

--+ Hooks +--
do
    local function create_hook(t)
        local t = t
        return setmetatable(
            {},
            {
                __call = function(self, x, y)
					local arg = (type(x) == 'table' and not y) and x or {x, y}
                    if not arg or table.getn(arg)==0 then for _,v in pairs(self) do v() end; return end

                    local name, func = arg[1], arg[2]
                    if type( name )~='string' or type( func )~='function' then return print('[@]', '<Error>', 'Invalid '.. t ..' hook, ignoring') end
                    self[ name ] = func
                end
            }
        )
    end

    setup_hooks = create_hook('setup')
    init_hooks = create_hook('init')
    update_hooks = create_hook('update')
end

--+ Setup +--
do

    function setup(self)

		if config.autohide_elements then
			for i, v in ipairs({ 'LifeP1', 'LifeP2', 'ScoreP1', 'ScoreP2', 'BPMDisplay', 'LifeFrame', 'ScoreFrame', 'Overlay', 'Underlay' }) do
				if SCREENMAN:GetTopScreen():GetChild(v) then
					SCREENMAN:GetTopScreen():GetChild(v):hidden(1)
				end
			end
		end
	
		for pn = 1, 2 do
			local plr = SCREENMAN:GetTopScreen():GetChild('PlayerP' .. pn) or nil
			table.insert(mod_plr, plr)
			if plr then
				_M['P' .. pn] = plr
				_M['jud' .. pn] = plr:GetChild('Judgment')
				_M['com' .. pn] = plr:GetChild('Combo')
				mod_plr_origin[pn][1] = plr:GetX()
				mod_plr_origin[pn][2] = plr:GetY()

				if OPENITG then
					if config.minimum_build == 'OpenITG' then
						_M['jud' .. pn]:zoom(0.7)
						_M['com' .. pn]:zoom(0.7)
					else
						do_actor_cmd( _M['P' .. pn]:GetChild('NoteField'), 'rotationx,0;rotationy,0;rotationz,0;zoomz,1' )
						for ex = pn + 2, 8, 2 do
							_M['P' .. ex] = SCREENMAN:GetTopScreen():GetChild('PlayerP' .. ex)
						end
					end
				end
			end
		end
	
		local i_res, i_err = pcall(setup_hooks)
		if not i_res then SystemMessage(i_err); return end
	
		if not OPENITG or FUCK_EXE then
			MESSAGEMAN:Broadcast('InitializeProxies')
			MESSAGEMAN:Broadcast('InitializeAFTs')
		end
	
		local o_res, o_err = pcall(init_hooks)
		if not o_res then SystemMessage(o_err); return end
	
		if config.custom_update and config.custom_update_type == false then
			self:addcommand('Update', function(self)
				update()
				self:sleep(1 / config.custom_update)
				self:queuecommand('Update')
			end)
			self:queuecommand('Update')
		else
			self:addcommand('Update', melody.update)
			self:luaeffect('Update')
		end

	end

end

--+ Update +--
do

    delta_time = 0
    local accumulator = 0
    local global_delta_time = get_os_time()
    
    local first_seen_beat = GAMESTATE:GetSongBeat()
    update = function()

        local beat = GAMESTATE:GetSongBeat()
        if beat <= first_seen_beat + 0.1 then return end

        --

        local cur_delta_time = get_os_time()
        local _delta_time = cur_delta_time - global_delta_time
        
        if config.custom_update_type then
            accumulator = accumulator + _delta_time
            delta_time = config.custom_update 
            if accumulator >= config.custom_update then
                local res, err = pcall(update_hooks)
                if not res then SystemMessage( err ); update = function() end end
                accumulator = accumulator - config.custom_update
            end
        else
            delta_time = _delta_time
            local res, err = pcall(update_hooks)
            if not res then SystemMessage( err ); update = function() end end
        end
        
        global_delta_time = cur_delta_time

    end

end