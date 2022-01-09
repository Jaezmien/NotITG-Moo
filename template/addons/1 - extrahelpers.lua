function lerp(a, b, t) return a + (b - a) * t end
function deg_to_rad(d) return d * math.pi / 1.8 end
function sound(str) SOUND:PlayOnce(song_dir .. str .. '.ogg') end

ini = OPENITG and PROFILEMAN:GetMachineProfile():GetSaved() or PROFILEMAN:GetMachineProfile():GetUserTable() -- TODO: check if getusertable is alternative

--

-- V3.1 compat
local function hex_to_dec(hex_str) return tonumber(hex_str,16) end
function hex_to_rgb(hex_str)
    local hex = string.sub(hex_str,2)
    if string.len(hex) == 3 then -- https://gist.github.com/fernandohenriques/12661bf250c8c2d8047188222cab7e28
        return ( hex_to_dec(string.sub(hex,1,1)*17)/255 ),( hex_to_dec(string.sub(hex,2,2)*17)/255 ),( hex_to_dec(string.sub(hex,3,3)*17)/255 ),1
    else -- https://gist.github.com/jasonbradley/4357406
        return ( hex_to_dec(string.sub(hex,1,2))/255 ),( hex_to_dec(string.sub(hex,3,4))/255 ),( hex_to_dec(string.sub(hex,5,6))/255 ),1
    end
end

function actor_block(actor)
    actor:x( 0 )
    actor:y( 0 )
    actor:stretchto( 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT )
end

--

function set_judgments_normal()
    mod_plr(function(p, pn)
        local jud = proxy.get_proxy('P'.. pn ..' Judgment')
        local com = proxy.get_proxy('P'.. pn ..' Combo')

        local jud_h = jud:GetTarget():GetChild(''):GetHeight()
        local jud_w = jud:GetTarget():GetChild(''):GetWidth()

        local mult = pn==1 and -1 or 1

        jud:x( mod_plr_origin[pn][1] )
        jud:y( mod_plr_origin[pn][2] )
        com:x( mod_plr_origin[pn][1] )
        com:y( mod_plr_origin[pn][2] )
    end)
end
function set_judgments_side()
    mod_plr(function(p, pn)
        local jud = proxy.get_proxy('P'.. pn ..' Judgment')
        local com = proxy.get_proxy('P'.. pn ..' Combo')

        local jud_w = jud:GetTarget():GetChild(''):GetWidth()

        jud:y( SCREEN_CENTER_Y )
        com:y( SCREEN_CENTER_Y )

        if pn==1 then
            jud:x( (jud_w/2)*0.7 )
            com:x( (jud_w/2)*0.7 )
        else
            jud:x( SCREEN_WIDTH - (jud_w/2)*0.7 )
            com:x( SCREEN_WIDTH - (jud_w/2)*0.7 )
        end
    end)
end
function set_judgments_top()
    mod_plr(function(p, pn)
        local jud = proxy.get_proxy('P'.. pn ..' Judgment')
        local com = proxy.get_proxy('P'.. pn ..' Combo')

        local jud_h = jud:GetTarget():GetChild(''):GetHeight() * 0.7
        local jud_w = jud:GetTarget():GetChild(''):GetWidth() * 0.7
        local com_h = com:GetTarget():GetChild(''):GetHeight() * 0.7

        local mult = pn==1 and -1 or 1

        jud:x( mod_plr_origin[pn][1] )
        jud:y( jud_h )
        com:x( mod_plr_origin[pn][1] + (jud_w * 0.8) * mult )
        com:y( com_h+10 )
    end)
end
function set_judgments_bottom()
    mod_plr(function(p, pn)
        local jud = proxy.get_proxy('P'.. pn ..' Judgment')
        local com = proxy.get_proxy('P'.. pn ..' Combo')

        local jud_h = jud:GetTarget():GetChild(''):GetHeight() * 0.7
        local jud_w = jud:GetTarget():GetChild(''):GetWidth() * 0.7
        local com_h = com:GetTarget():GetChild(''):GetHeight() * 0.7

        local mult = pn==1 and -1 or 1

        jud:x( mod_plr_origin[pn][1] )
        jud:y( SCREEN_HEIGHT - (jud_h) + 30 )
        com:x( mod_plr_origin[pn][1] + (jud_w * 0.8) * mult )
        com:y( SCREEN_HEIGHT - (com_h) - 30 - 30 )
    end)
end
