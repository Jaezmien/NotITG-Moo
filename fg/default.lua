-- dont load if template fails
if melody_error then melody_error = nil; return Def.ActorFrame{} end

local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

local t = Def.ActorFrame {}
t[#t+1] = Def.Actor {
	Name="I may be sleeping, but I preserve the world.", -- so true bestie
	InitCommand=function(self) self:sleep(9e9) end
}
t[#t+1] = loadfile( song_dir .. "fg/fg.lua" )()
return t