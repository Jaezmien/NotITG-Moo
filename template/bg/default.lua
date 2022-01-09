local t = Def.ActorFrame {}

-- bg loads first, let's load the template here!
local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

do
	melody = nil
	local res, err = pcall( loadfile(song_dir .. "template/init.lua") )
	if melody_error or not res then
		if err then print( err ) end
		melody_error = nil; melody = nil; return Def.ActorFrame{}
	end
	t[#t+1] = res
end

t[#t+1] = loadfile( song_dir .. "bg/bg.lua" )()
return t