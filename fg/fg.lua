melody.fg = Def.ActorFrame {}
local t = melody.fg

t[#t+1] = Def.Quad {
	InitCommand=melody(function(self)
		function am_bl(mult) return (GAMESTATE:GetCurBPS()) * (mult or 1) end

		init_hooks{'mods init',function()
			-- lua{'fg/mods', env=modreader.jaezmien}
		end}
	end)
}

-- Foreground actors here --

t[#t+1] = Def.ActorFrame {
	Name="Judgments",

	Def.ActorProxy {
		Name="P1 Judgment",
		InitializeProxiesMessageCommand=melody(function(self)
			proxy.create_proxy( self, jud1, 'P1 Judgment' )
            self:zoom( 0.7 )
            self:xy( mod_plr_origin[1][1] , mod_plr_origin[1][2] )
            jud1:hidden(1)
            jud1:sleep(9E9)
		end)
	},
	Def.ActorProxy {
		Name="P1 Combo",
		InitializeProxiesMessageCommand=melody(function(self)
			proxy.create_proxy( self, com1, 'P1 Combo' )
            self:zoom( 0.7 )
            self:xy( mod_plr_origin[1][1] , mod_plr_origin[1][2] )
            com1:hidden(1)
            com1:sleep(9E9)
		end)
	},

	Def.ActorProxy {
		Name="P2 Judgment",
		InitializeProxiesMessageCommand=melody(function(self)
			proxy.create_proxy( self, jud2, 'P2 Judgment' )
            self:zoom( 0.7 )
            self:xy( mod_plr_origin[2][1] , mod_plr_origin[2][2] )
            jud1:hidden(1)
            jud1:sleep(9E9)
		end)
	},
	Def.ActorProxy {
		Name="P2 Combo",
		InitializeProxiesMessageCommand=melody(function(self)
			proxy.create_proxy( self, com2, 'P2 Combo' )
            self:zoom( 0.7 )
            self:xy( mod_plr_origin[2][1] , mod_plr_origin[2][2] )
            com1:hidden(1)
            com1:sleep(9E9)
		end)
	}
}

return t