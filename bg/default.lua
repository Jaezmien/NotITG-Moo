-- bg loads first, let's load the template here!
local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

do
	melody = nil
	loadfile(song_dir .. "template/init.lua")()
	if melody_error then melody_error = nil; return Def.ActorFrame{} end
end

local t = Def.ActorFrame {}
t[#t+1] = loadfile( song_dir .. "bg/bg.lua" )()
return t