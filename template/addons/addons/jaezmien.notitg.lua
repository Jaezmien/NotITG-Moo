local reader = {}

-- insert modreader stuff here
------------------------------

-- this mod reader is held on by toothpicks and glue please send help

local max_pn = version_minimum('V2') and 8 or 2

reader.apply_mods = true -- to enable mod reader functions without actually applying mods

reader.init = {}
for pn=1, max_pn do reader.init[ pn ] = { 100, 'overhead' } end

local last_seen_beat = GAMESTATE:GetSongBeat()

local unpack_args = function(args)
	local t

	if type(args[1])=='table' then t = args[1]
	elseif type(args)=='table' then t = args
	else t = { args }  end

	return t
end

local default_min_pn = 1
local default_max_pn = 2
reader.set_default_pn = function(dmin_pn,dmax_pn)
	if type(dmin_pn) == 'table' then
		local dmax_pn, dmin_pn = dmin_pn[2], dmin_pn[1]
		default_min_pn, default_max_pn = math.max(1, dmin_pn), math.min(max_pn, dmax_pn)
	elseif dmin_pn and max_pn then
		default_min_pn, default_max_pn = math.max(1, dmin_pn), math.min(max_pn, dmax_pn)
	elseif dmin_pn and not max_pn then
		default_min_pn, default_max_pn = 1, math.min(max_pn, dmin_pn)
	else
		default_min_pn, default_max_pn = 1, 2
	end
end

--+

local pmods_target = {} -- For the ease reader
local pmods_target_offset = {}
local pmods_core = {} -- For case-insensitive
local pmods_core_offset = {}
local pmods = {} -- For the user
local pmods_offset = {}

local redirs = {}
local eases = {}
local funcs_ease = {}
local funcs = {}

--

local function set_pmods()
	for pn=1, max_pn do
		local plr = pn
		pmods_core[ pn ] = {}
		pmods_target[ pn ] = setmetatable( {} , { __index = function() return 0 end } )
		local core = pmods_core[ pn ]
		local target = pmods_target[ pn ]
		pmods[ pn ] = setmetatable(
			{},
			{
				__index = function(t, k)
					return core[ string.lower(k) ] or core[ redirs[string.lower(k)] ] or 0
				end, -- Return 0 for invalid mods / inactive mods
				__newindex = function(t, k, v)
					local key = string.lower(k)

					local modstring = '*-1 '.. v ..' '

					if redirs[ key ] then
						if type( redirs[key] ) == 'string' then modstring = modstring .. redirs[key]
						elseif type( redirs[key] ) == 'function' then
							local ret = redirs[ key ]( v , plr )
							if ret == nil then return else modstring = ret end
						end
					else
						modstring = modstring .. key
					end

					core[ key ] = v;
					target[ key ] = v;
					
					if reader.apply_mods then mod_do( modstring, plr ) end
				end,
			}
		)
		
		pmods_core_offset[ pn ] = {}
		pmods_target_offset[ pn ] = setmetatable( {} , { __index = function() return 0 end } )
		local core_offset = pmods_core_offset[ pn ]
		local target_offset = pmods_target_offset[ pn ]
		pmods_offset[ pn ] = setmetatable(
			{},
			{
				__index = function(t, k)
					return core_offset[ string.lower(k) ] or core_offset[ redirs[string.lower(k)] ] or 0
				end, -- Return 0 for invalid mods / inactive mods
				__newindex = function(t, k, v)
					local key = string.lower(k)
					core_offset[ key ] = v; 
					target_offset[ key ] = v;
					local offset = pmods[ plr ][ key ]

					local modstring = '*-1 '.. offset + v ..' '

					if redirs[ key ] then
						if type( redirs[key] ) == 'string' then modstring = modstring .. redirs[key]
						elseif type( redirs[key] ) == 'function' then
							local ret = redirs[ key ]( offset + v , plr )
							if ret == nil then return else modstring = ret end
						end
					else
						modstring = modstring .. key
					end

					if reader.apply_mods then mod_do( modstring, plr ) end
				end,
			}
		)
	end
end

reader.pmods = {}
setmetatable(
	reader.pmods,
	{
		__index = function(t, k) return pmods[k] end,
		__newindex = function(t, k, v) for pn=default_min_pn, default_max_pn do pmods[pn][k] = v end
		end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			
			if type(args[1]) == 'function' then
				if args.plr then
					if type(args.plr)=='table' then
						for _,pn in pairs( args.plr ) do args[1]( pmods[pn], pn ) end
					else
						args[1]( pmods[args.plr], args.plr )
					end
				else
					for pn=default_min_pn, default_max_pn do
						args[1]( pmods[pn], pn )
					end
				end
			end
			return t
		end,
	}
)

reader.pmods_offset = {}
setmetatable(
	reader.pmods_offset,
	{
		__index = function(t, k) return pmods_offset[k] end,
		__newindex = function(t, k, v) for pn=default_min_pn, default_max_pn do pmods_offset[pn][k] = v end
		end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			
			if type(args[1]) == 'function' then
				if args.plr then
					if type(args.plr)=='table' then
						for _,pn in pairs( args.plr ) do args[1]( pmods_offset[pn], pn ) end
					else
						args[1]( pmods_offset[args.plr], args.plr )
					end
				else
					for pn=default_min_pn, default_max_pn do
						args[1]( pmods_offset[pn], pn )
					end
				end
			end
			return t
		end,
	}
)

reader.redirs = {}
setmetatable(
	reader.redirs,
	{
		__index = function(t, k) return redirs[ string.lower(k) ] end,
		__newindex = function(t, k, v) redirs[ string.lower(k) ] = v end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			if type(args[1]) ~= 'string' or
				(type(args[2]) ~= 'string' and type(args[2]) ~= 'function' and type(args[2]) ~= 'nil') then
				print("[Mods] Invalid alias, ignoring...")
			else
				redirs[ args[1] ] = args[2] or (function() end)
			end
			return t
		end,
	}
)
reader.redirs[ 'xmod' ] = function(x) return '*-1 ' .. x ..'x' end
reader.redirs[ 'cmod' ] = function(c) return '*-1 c' .. c end

reader.ease = {}
setmetatable(
	reader.ease,
	{
		__newindex = function() end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			local el = {}
			if type(args[1]) ~= 'number' then
				print("[Mods] Invalid beat start, ignoring..."); return t
			end
			el.beat_start = args[1]
			
			local index = 2
			-- Beat end
			if type( args[ index ] ) == 'number' and type( args[ index+1 ] ) ~= 'string' then
				el.beat_length = args[ index ] > el.beat_start and ( args[ index ]-el.beat_start ) or args[ index ] -- end/len > len
				index = index+1
			else
				el.beat_length = 0
			end
			-- Ease function
			if type( args[ index ] ) == 'function' then
				if args[ index ](1,0,1,1) == 1 then el.ease = args[index]; end
				index=index+1
			else
				el.ease = args.ease or linear
			end
			-- Mods
			el.mods = {}
			local mod_value = 0
			while args[ index ] do
				if type( args[index] ) == 'number' then
					mod_value = args[ index ]
				elseif type( args[index] ) == 'string' then
					el.mods[ string.lower(args[index] ) ] = mod_value
				else
					print("[Mods] Invalid mod table, ignoring..."); return t
				end
				index = index + 1
			end
			el.extra = args.extra or {1,1}
			el.offset = args.offset or false
			
			-- Player arg
			if args.plr then
				if type( args.plr ) == 'table' then
					for _,pn in pairs( args.plr ) do
						local c_el = table.weak_clone( el )
						c_el.plr = pn
						c_el.index = table.getn(eases)+1
						table.insert( eases, c_el )
					end
				else
					el.plr = args.plr
					el.index = table.getn(eases)+1
					table.insert( eases, el )
				end
			else
				for pn=default_min_pn,default_max_pn do
					local c_el = table.weak_clone( el )
					c_el.plr = pn
					c_el.index = table.getn(eases)+1
					table.insert( eases, c_el )
				end
			end
			return t
		end,
	}
)

reader.ease_offset = {}
setmetatable(
	reader.ease_offset,
	{
		__newindex = function() end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			args.offset = true
			reader.ease( args )
			return t
		end,
	}
)

reader.func_ease = {}
setmetatable(
	reader.func_ease,
	{
		__newindex = function() end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			local el = {}
			el.beat_start = args[1]
			el.beat_length = args[2] > el.beat_start and ( args[2] - el.beat_start ) or args[2]
			el.range = {
				args[3], args[4]
			}
			el.func = args[5]
			el.ease = args[6] or args.ease or linear
			el.extra = args.extra or {1, 1}
			table.insert( funcs_ease, el )
			return t
		end,
	}
)

reader.func = {}
setmetatable(
	reader.func,
	{
		__newindex = function() end,
		__call = function(t, ...)
			local args = unpack_args( arg )
			local el = {}
			
			if type( args[1] ) ~= 'number' then
				print('[Mods] Invalid function beat start, ignoring...'); return t
			end
			el.beat_start = args[1]
			local index = 2
			if type( args[index] ) == 'number' then
				el.beat_end = args[ index ]
				if el.beat_end < last_seen_beat then return t; end -- Ignore if old
				index = index + 1
			else
				el.persist = nil

				if args.persist then
					if type(args.persist) == 'number' then
						el.persist = args.persist
					elseif type(args.persist) == 'boolean' then
						el.persist = 9e9
					end
				end

				if el.beat_start < last_seen_beat then
					if el.persist then
						if el.beat_start + el.persist < last_seen_beat then return t; end
					else return t; end
				end
			end

			el.func = args[ index ]

			if not el.func then
				print('[Mods] Invalid func, ignoring...'); return t
			end

			table.insert( funcs, el )
			return t
		end,
	}
)

local setup = false
reader.clear = function()
	ease = {}
	ease_offset = {}
	funcs_ease = {}
	funcs = {}
	--
	setup = false
end

set_pmods()

reader.pmods.xmod = 1

local function parse_mod( mod, value, pn, apply_offset )
	local modstring 

	if apply_offset then
		if pmods_offset[pn][mod] ~= 0 then
			value = value + pmods_offset[pn][mod]
		end
	end

	if redirs[ mod ] then
		local redir_type = type( redirs[mod] ) 
		if redir_type == 'string' then
			mod = redirs[ mod ] 
			modstring = '*-1 ' .. value .. ' ' .. mod
		elseif redir_type == 'function' then
			modstring = redirs[ mod ]( value, pn )
		end
	else
		modstring = '*-1 ' .. value .. ' ' .. mod
	end

	return modstring
end

local update = function()
	local beat = GAMESTATE:GetSongBeat()
	if beat == last_seen_beat then return end
	last_seen_beat = beat

	if not setup then
		if reader.apply_mods then mod_do( 'clearall' ) end
		for pn, mods in pairs( reader.init ) do
			local modstrings = {}
			local mod_value = 0
			for _, v in pairs( mods ) do
				if type( v ) == 'number' then
					mod_value = v
				elseif type( v ) == 'string' then
					table.insert( modstrings, '*-1 '.. mod_value ..' '.. v )
					if v == 'xmod' or v == 'cmod' or v == 'mmod' then
						pmods[ pn ][ v ] = mod_value
					end
				end
			end
			if table.getn( modstrings ) > 0 then
				if reader.apply_mods then mod_do( table.concat(modstrings, ',') , pn ) end
			end
		end
		
		table.sort( eases , function(x,y)
			if (x.beat_start == y.beat_start) then return x.index < y.index end -- oh well
			return (x.beat_start < y.beat_start)
		end )
		table.sort( funcs_ease , function(x,y) return (x.beat_start < y.beat_start) end )
		table.sort( funcs      , function(x,y) return (x.beat_start < y.beat_start) end )

		setup = true
	end

	-- Table Readers

	for index,ease in pairs( eases ) do
		
		if beat >= ease.beat_start then

			local m1 = ease.offset and pmods_core_offset or pmods_core
			local m2 = ease.offset and pmods_target_offset or pmods_target

			if not ease.set then
				for mod, value in pairs( ease.mods ) do
					ease.mods[ mod ] = value - m2[ ease.plr ][ mod ]
					m2[ ease.plr ][ mod ] = m2[ ease.plr ][ mod ] + ease.mods[ mod ]
				end
				ease.set = true
			end

			if ease.beat_length > 0 and beat < ease.beat_start + ease.beat_length then

				-- Do the thing
				local percent = ease.ease(
					beat - ease.beat_start,
					0, 1,
					ease.beat_length,

					ease.extra[1],
					ease.extra[2]
				) - 1
				for mod, value in pairs( ease.mods ) do
					m1[ ease.plr ][ mod ] = m2[ ease.plr ][ mod ] + percent * value
				end

			else

				-- Do the thing one more time
				for mod, value in pairs( ease.mods ) do
					m1[ ease.plr ][ mod ] = m2[ ease.plr ][ mod ]
				end

				eases[ index ] = nil

			end

		else
			break
		end

	end

	for index, func in pairs( funcs_ease ) do
		
		if beat >= func.beat_start then

			if beat < func.beat_start + func.beat_length then
				
				local percent = func.ease(
					beat - func.beat_start,
					func.range[1],
					func.range[2] - func.range[1],
					func.beat_length,

					func.extra[1],
					func.extra[2]
				)
				func.func( percent )

			else
				func.func( func.range[2] )

				funcs_ease[ index ] = nil
			end

		else
			break
		end

	end

	for index,func in pairs( funcs ) do

		if beat >= func.beat_start then

			if func.beat_end then
				func.func( beat )
				if beat > func.beat_end then
					funcs[ index ] = nil
				end
			else
				if beat <= func.beat_start+4 or (func.persist and beat <= func.persist) then
					if type(func.func) == 'string' then MESSAGEMAN:Broadcast( func.func )
					else func.func( beat ) end
				
					funcs[ index ] = nil
				end
			end

		else
			break
		end

	end

	-- Player Mods
	if reader.apply_mods then

		for pn, mods in pairs( pmods_core ) do
			if melody['P' .. pn ] and melody['P' .. pn]:IsAwake() then

				local modifiers = {}

				for mod, value in pairs( mods ) do
					
					local modstring

					modstring = parse_mod( mod, value, pn, true )
					if value == 0 then
						mods[ mod ] = nil
					end

					if modstring then
						table.insert( modifiers, modstring )
					end

				end
				
				if table.getn( modifiers ) > 0 then mod_do( table.concat(modifiers, ','), pn ) end

			end
		end
		for pn, mods in pairs( pmods_core_offset ) do
			if melody['P' .. pn] and melody['P' .. pn]:IsAwake() then

				local modifiers = {}

				for mod, value in pairs( mods ) do

					-- if layer 1 is active, dont run it
					if pmods[ pn ][ mod ] == 0 then
						local modstring

						modstring = parse_mod( mod, value, pn, false )
						if value == 0 then
							mods[ mod ] = nil
						end

						if modstring then
							table.insert( modifiers, modstring )
						end
					end

				end

				if table.getn( modifiers ) > 0 then mod_do( table.concat(modifiers, ','), pn ) end

			end
		end
		
	end

end
------------------------------
-- insert modreader stuff here

return reader, {
	func = update,
	clear = false,
	disable = function() reader.apply_mods = false end,
}