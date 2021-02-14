lerp = function(a, b, t) return a + (b - a) * t end
function deg_to_rad(d) return d * math.pi / 1.8 end

sound = function(str)
    SOUND:PlayOnce(song_dir .. str .. '.ogg')
end

char_states = {
    -- + Special Characters (1)
        [' '] = 0,
        ['space'] = 0,
        ['!'] = 1,
        ['&quot;'] = 2,
        ['"'] = 2,
        ['#'] = 3,
        ['$'] = 4,
        ['%'] = 5,
        ['&'] = 6,
        ['\''] = 7,
        ['('] = 8,
        [')'] = 9,
        ['*'] = 10,
        ['+'] = 11,
        [','] = 12,
        ['-'] = 13,
        ['.'] = 14,
        ['/'] = 15,
    -- + Special Characters (1)

    -- + Numbers
        ['0'] = 16,
        ['1'] = 17,
        ['2'] = 18,
        ['3'] = 19,
        ['4'] = 20,
        ['5'] = 21,
        ['6'] = 22,
        ['7'] = 23,
        ['8'] = 24,
        ['9'] = 25,
    -- + Numbers

    -- + Special Characters (2)
        [':'] = 26,
        [';'] = 27,
        ['<'] = 28,
        ['='] = 29,
        ['>'] = 30,
        ['?'] = 31,
        ['@'] = 32,
        -- + Special Characters (2)

        -- + Uppercase Letters
        ['A'] = 33,
        ['B'] = 34,
        ['C'] = 35,
        ['D'] = 36,
        ['E'] = 37,
        ['F'] = 38,
        ['G'] = 39,
        ['H'] = 40,
        ['I'] = 41,
        ['J'] = 42,
        ['K'] = 43,
        ['L'] = 44,
        ['M'] = 45,
        ['N'] = 46,
        ['O'] = 47,
        ['P'] = 48,
        ['Q'] = 49,
        ['R'] = 50,
        ['S'] = 51,
        ['T'] = 52,
        ['U'] = 53,
        ['V'] = 54,
        ['W'] = 55,
        ['X'] = 56,
        ['Y'] = 57,
        ['Z'] = 58,
    -- + Uppercase Letters

    -- + Special Characters (3)
        ['['] = 59,
        ['\\'] = 60,
        [']'] = 61,
        ['^'] = 62,
        ['_'] = 63,
        ['`'] = 64,
    -- + Special Characters (3)

    -- + Lowercase Letters
        ['a'] = 65,
        ['b'] = 66,
        ['c'] = 67,
        ['d'] = 68,
        ['e'] = 69,
        ['f'] = 70,
        ['g'] = 71,
        ['h'] = 72,
        ['i'] = 73,
        ['j'] = 74,
        ['k'] = 75,
        ['l'] = 76,
        ['m'] = 77,
        ['n'] = 78,
        ['o'] = 79,
        ['p'] = 80,
        ['q'] = 81,
        ['r'] = 82,
        ['s'] = 83,
        ['t'] = 84,
        ['u'] = 85,
        ['v'] = 86,
        ['w'] = 87,
        ['x'] = 88,
        ['y'] = 89,
        ['z'] = 90,
    -- + Lowercase Letters

    -- + Special Characters (4)
        ['{'] = 91,
        ['|'] = 92,
        ['}'] = 93,
        ['~'] = 94
    -- + Special Characters (4)
}

ini = PROFILEMAN:GetMachineProfile():GetSaved()

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