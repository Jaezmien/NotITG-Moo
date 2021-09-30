return Def.ActorFrame{
	Def.Sprite{
		OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT),
		Texture= "gradient-back.png",
	},
	Def.Sprite{
		OnCommand= cmd(horizalign,left;vertalign,bottom;x,-melody.SCREEN_CENTER_X;y,melody.SCREEN_CENTER_Y),
		Texture= "squares-left.png",
	},
	Def.Sprite{
		OnCommand= cmd(horizalign,right;vertalign,top;x,melody.SCREEN_CENTER_X;y,-melody.SCREEN_CENTER_Y),
		Texture= "squares-right.png",
	},
	Def.Sprite{
		OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT),
		Texture= "gradient-overlay.png",
	},
	Def.Sprite{
		OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT;diffusealpha,0.4;blend,"BlendMode_Add"),
		Texture= "lines.png",
	},
	Def.Sprite{
		Texture= "text.png",
	},
	Def.Quad{
		OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT;diffuse,color('0,0,0,0.4')),
	},
}