-- bg loads first, let's load the template here!
local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

do
	melody = nil
	local res, err = pcall( loadfile(song_dir .. "template/init.lua") )
	if melody_error or not res then
		if err then print( err ) end
		melody_error = nil; return Def.ActorFrame{}
	end
end

local t = Def.ActorFrame {}
t[#t+1] = Def.Quad {
	OnCommand=function(self) self:diffusealpha( 0 ):queuecommand('Setup') end,
	SetupCommand=melody.setup
}
t[#t+1] = loadfile( song_dir .. "bg/bg.lua" )()
return t