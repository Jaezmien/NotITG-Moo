local t = Def.ActorFrame{}

-- Environment Setup
melody = setmetatable({}, { __index = _G, __call = function(s,a) if a then setfenv(a,s); return a; end setfenv(2,s) end })
_M = melody
melody()

local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

-- Miscellaneous
do
	function SystemMessage(msg) SCREENMAN:SystemMessage( tostring(msg) ) end
	function __error(msg) SystemMessage(msg); _G.melody_error = true end
	function args_unpack(arg) return (table.getn(arg)==1 and type(arg[1])=='table') and unpack(arg) or arg end
end

-- Lua loader
do
	local format, gsub, lower, gfind, find, sub = string.format, string.gsub, string.lower, string.gfind, string.find, string.sub
	local getn, insert, concat, remove = table.getn, table.insert, table.concat, table.remove

	local function size(t)
		local n = 0;
		for _ in pairs(t) do n=n+1; end
		return n
	end

	lua = {}
	lua.cache = {}
	lua.load = function(filename)
		local func, error = loadfile( song_dir .. filename )
		if func then dir = w; return func end

		return func or ("[Error] " .. error)
	end
	lua._do_error = function( func, args )
		if args.ignore_error then return end
		if args.error then args.error(func)
		elseif args.show_error~=false then print(func) end
	end
	lua.__call = function(s, x, y, z)
		local args = (type(x) == 'table' and not y and not z) and x or {x, y, z}
		local filename = lower( args[1] )
		if sub(filename, -4)~='.lua' then filename=filename..'.lua' end
		if lua.cache[filename] then return unpack(lua.cache[filename]) end

		local func = lua.load(filename)
		if type(func)=='string' then lua._do_error( func, args ); return end
		if type(func)~='function' then return end

		local env = args[2] or args.env or _G.melody
		if not getmetatable(env) then setmetatable(env, {__index=melody, __newindex=melody}) end
		
		local args = args[3] or args.args or {}
		env.__args = args
		setfenv(func, env)
		local result = { pcall(func) }
		env.__args = nil

		if result[1]==false then lua._do_error( result[2], args ); return end
		remove( result, 1 )
		if args.cache ~= false and size(result) > 0 then
			lua.cache[filename]=result; return unpack(result)
		end
	end

	setmetatable(lua,lua)
end

-- Load Template
print('[!]', 'Setting up template...')
lua('template/main')

print('[!]', 'Doing checks...')
check() 
if melody_error then return end

print('[!]', 'Loading addons...')
addons:load()
for _,addon in ipairs( addons ) do
	t[#t+1] = addon
end

return t