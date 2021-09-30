melody.bg = Def.ActorFrame {}
local bg = melody.bg
--
bg[#bg+1] = LoadActor("itg") .. {
	Name= "itg",
	OnCommand= cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y),
}
--
return bg