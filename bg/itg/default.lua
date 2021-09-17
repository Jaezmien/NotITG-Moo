return Def.ActorFrame{
  Name= "xtl_actor_q",
  Def.Sprite{
    Name= "xtl_actor_r",
    OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT),
    Texture= "gradient-back.png",
  },
  Def.Sprite{
    Name= "xtl_actor_s",
    OnCommand= cmd(horizalign,left;vertalign,bottom;x,-melody.SCREEN_CENTER_X;y,melody.SCREEN_CENTER_Y),
    Texture= "squares-left.png",
  },
  Def.Sprite{
    Name= "xtl_actor_t",
    OnCommand= cmd(horizalign,right;vertalign,top;x,melody.SCREEN_CENTER_X;y,-melody.SCREEN_CENTER_Y),
    Texture= "squares-right.png",
  },
  Def.Sprite{
    Name= "xtl_actor_u",
    OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT),
    Texture= "gradient-overlay.png",
  },
  Def.Sprite{
    Name= "xtl_actor_v",
    OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT;diffusealpha,0.4;blend,"BlendMode_Add"),
    Texture= "lines.png",
  },
  Def.Sprite{
    Name= "xtl_actor_w",
    Texture= "text.png",
  },
  Def.Quad{
    Name= "xtl_actor_x",
    OnCommand= cmd(zoomto,melody.SCREEN_WIDTH,melody.SCREEN_HEIGHT;diffuse,color('0,0,0,0.4')),
  },
}
