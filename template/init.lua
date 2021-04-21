--+ Miscellaneous +--
do
    -- Table
    do
        table = setmetatable({}, {__index = _G.table})
        table.contains = function(t, val)
            for _, v in pairs(t) do if v == val then return true end end
            return false
        end
        table.shuffle = function(t)
            for i=table.getn(t), 2, -1 do
                local j = math.random(i, table.getn(t))
                t[i], t[j] = t[j], t[i]
            end
            return t
        end
        table.clone = function(orig)
            local orig_type = type(orig)
            local copy
            if orig_type == 'table' then
                copy = {}
                for orig_key, orig_value in next, orig, nil do
                    copy[table.clone(orig_key)] = table.clone(orig_value)
                end
                setmetatable(copy, table.clone(getmetatable(orig)))
            else -- number, string, boolean, etc
                copy = orig
            end
            return copy
        end
        table.weak_clone = function(orig)
            if type(orig) ~= 'table' then return orig end

            local t = {}
            for k,v in pairs(orig) do
                t[k] = ( type(v) == 'table' ) and table.weak_clone(v) or v
            end

            return t
        end
        table.index_from_key = function(t, key)
            for i, v in pairs(t) do if v == key then return i end end
            return nil
        end
        table.to_array = function(t)
            local a = {}
            for _, v in pairs(t) do table.insert(a, v) end
            return a
        end
    end

    -- Math
    do
        math = setmetatable({}, {__index = _G.math})
        math.round = function(a, b)
            local decim = math.pow(10, b or 0)
            return (math.floor(a * decim + 0.5)) / decim
        end
        math.round2 = function(a, b)
            return tonumber(string.format("%." .. (b or 0) .. "f", a))
        end -- rounding but no add
        math.mod = function(a, b) b=b or 1; return a - math.floor(a / b) * b; end
        math.clamp = function(val, min, max) return math.max(min, math.min(max, val)); end
        math.norm = function(val, old_min, old_max, new_min, new_max)
            new_min = new_min or 0
            new_max = new_max or 1
            return (new_max - new_min) * ((val - old_min) / (old_max - old_min)) + new_min;
        end
        math.dist1d = function(a, b)
            local x = type(a) == 'table' and unpack(a) or a
            local y = type(b) == 'table' and unpack(b) or b
            local d = y - x
            return math.sqrt(d * d)
        end
        math.dist2d = function(a, b)
            local x = type(a) == 'userdata' and {a:GetX(), a:GetY()} or a
            local y = type(b) == 'userdata' and {b:GetX(), b:GetY()} or b
            local dx = y[1] - x[1]
            local dy = y[2] - x[2]
            return math.sqrt(dx * dx + dy * dy)
        end
        math.dist = math.dist2d -- shortcut
        math.dist3d = function(a, b)
            local x = type(a) == 'userdata' and {a:GetX(), a:GetY(), a:GetZ()} or a
            local y = type(b) == 'userdata' and {b:GetX(), b:GetY(), a:GetZ()} or b
            local dx = y[1] - x[1]
            local dy = y[2] - x[2]
            local dz = y[3] - x[3]
            return math.sqrt(dx * dx + dy * dy + dz * dz)
        end
        math.random_float = function(min, max)
            if min==max then return min end
            if min > max then min,max=max,min end
            return math.random() * (max - min) + min
        end
    end
end

--+ Configuration +--
do

    -- See settings.lua for more info
    config = {
        addons_files = {},
        minimum_build = 'V4.0.1',
        autohide_elements = true,
        force_twoplayers = true,
        allowed_resolutions = nil,
        custom_update = nil,
        custom_update_type = false,
        allow_d3d_renderer = false,
        default_modreader = {},
        misc_checks = true,
    }
    
    nitg_versions = {
        ['V1']     = 20161226,
        ['V2']     = 20170405,
        ['V3']     = 20180617,
        ['V3.1']   = 20180909,
        ['V4']     = 20200112,
        ['V4.0.1'] = 20200126
    }
    
    function version_minimum(ver)
        if config.minimum_build == 'OpenITG' then return (ver == 'OpenITG') end
        return FUCK_EXE and (tonumber(GAMESTATE:GetVersionDate()) >= nitg_versions[ver])
    end

    print('[@]', 'Loading custom settings...')
    lua('settings')

end

--+ Variables +--
do
    song_time = 0

    mod_plr = setmetatable({}, {
        __call = function(s, ...)
            if type(arg[1]) == 'function' then
                for i, v in pairs(s) do if v then arg[1](v, i) end end
            elseif type(arg[1]) == 'string' then
                for _, v in pairs(s) do if v then v:cmd(arg[1]) end end
            end
        end
    })
    mod_plr_origin = {{0, 0}, {0, 0}}

    SCREEN_FOV = function(fov) return 360 / math.pi * math.atan(math.tan(math.pi * (1 / (360 / fov))) * _G.SCREEN_WIDTH / _G.SCREEN_HEIGHT * 0.75) end
    if not version_minimum('V4') then
        SCREEN_WIDTH = 480 * PREFSMAN:GetPreference('DisplayAspectRatio')
        SCREEN_CENTER_X = SCREEN_WIDTH / 2
    end
    SCREEN_WIDTH_MULT = SCREEN_WIDTH / 640
    SCREEN_HEIGHT_MULT = SCREEN_HEIGHT / 480

    -- Note: +8 on gameplay, +4 on editor
    local last_beat_offset = FUCK_EXE and ( GAMESTATE:IsEditMode() and 8 or 4 ) or 0
    last_beat = FUCK_EXE and (GAMESTATE:GetCurrentSong():GetBeatFromElapsedTime(GAMESTATE:GetCurrentSong():MusicLengthSeconds()) + last_beat_offset) or 999

    song_dir = GAMESTATE:GetCurrentSong():GetSongDir()
end

--+ Functions +--
do
    get_song_time = version_minimum('V2') and (function() return GAMESTATE:GetSongTime() end) or (function() return song_time end) -- OITG compatibility

    function actor_type(actor)
        local checks = {
            ['customtexturerect'] = 'Sprite',
            ['fov'] = 'ActorFrame',
            ['start'] = 'ActorSound',
            ['EnableAlphaBuffer'] = 'ActorFrameTexture',
            ['settext'] = 'BitmapText',
            ['setstateone'] = 'Model',
            ['SetVertexPosition'] = 'Polygon'
        }
        for k, v in pairs(checks) do
            if actor[k] then
                return v == 'Sprite' and (actor:GetTexture() and 'Sprite' or 'Quad') or v
            end
        end
        return 'Quad'
    end
    
    function check()

        if config.minimum_build ~= 'OpenITG' then
            if not FUCK_EXE then
                __error('NotITG ' .. config.minimum_build .. ' beyond is needed to play this file')
                return
            end
            if not version_minimum(config.minimum_build) then
                __error('Outdated NotITG Version detected, this file only works on ' .. config.minimum_build .. ' onwards')
                return
            end
        end
        -- i'd use DisplayAspectRatio for anamorphic widescreen
        -- but there are times where the decimal points of the aspect ratio not matching the ratio float.
        if config.allowed_resolutions and not table.contains(config.allowed_resolutions, PREFSMAN:GetPreference('DisplayWidth') / PREFSMAN:GetPreference('DisplayHeight')) then
            __error('Invalid resolution detected')
            return
        end
        if config.force_twoplayers and not (GAMESTATE:IsPlayerEnabled(0) and GAMESTATE:IsPlayerEnabled(1)) then
            if (not FUCK_EXE) or (FUCK_EXE and not GAMESTATE:IsEditMode()) then
                __error('Two players are needed to play this file')
                return
            end
        end
    
        if config.misc_checks ~= true then
            local add = type(config.misc_checks) == "string" and ": "..(config.misc_checks) or "";
            __error('Miscellaneous check returned invalid' .. add)
            return
        end

    end
end

--+ Addons +--
do
    addons = {}
    addons.index = 0
    addons.continue = true
    function addons:load()
        
        if (config.minimum_build == 'OpenITG') or not FUCK_EXE then
            for _,v in pairs(config.addons_files) do table.insert(self,v) end
            return
        end

        local files = { GAMESTATE:GetFileStructure(song_dir .. 'template/addons/') }
        for _, v in pairs(files) do
            if (string.sub(v, -4) == '.xml' or string.sub(v, -4) == '.lua') and string.sub(v, 1, 1) ~= '_' then
                table.insert(self, v)
            end
        end

    end
    function addons:get()
        local count = self.index + 1

        local stop = false
        while self[count] and string.sub(self[count], -4) == '.lua' do
            if stop then break end
            print('[@]', 'Loading Lua Addon >> ' .. self[count])
            lua{
                'template/addons/' .. self[count],
                error = function(err)
                    print('[@]','<Error>','An error has occured while loading the addon')
                    print('[@]', err)
                    __error('An error has occured while loading an addon')
                    stop = true
                end,
            }
            count=count+1
        end

        if not addons[count] or melody_error then self.continue = false; return false; end
        
        self.index = count
        return true
    end
    function addons:grab_xml()
        print('[@]', 'Loading XML Addon >> ' .. self[self.index])
        return 'addons/' .. self[self.index]
    end
    for i,v in ipairs(addons) do print(i,v) end
end 

--+ Hooks +--
do

    local function sanitize(t)
        return type(t[1])=='table' and t[1][1], t[1][2]  or t[1], t[2]
    end
    local function create_hook(t)
        local t = t
        return setmetatable(
            {},
            {
                __call = function(self, ...)
                    if not arg or table.getn(arg)==0 then
                        for _,v in pairs(self) do v() end;
                        return
                    end

                    local name, func = sanitize(arg)
                    if type( name )~='string' or type( func )~='function' then return print('[@]', '<Error>', 'Invalid '.. t ..' hook, ignoring') end
                    self[ name ] = func
                end
            }
        )
    end

    setup_hooks = create_hook('setup')
    init_hooks = create_hook('init')
    update_hooks = create_hook('update')

end

--+ Setup +--
do

    function setup(self)

        if config.autohide_elements then
            for i, v in pairs({ 'LifeP1', 'LifeP2', 'ScoreP1', 'ScoreP2', 'BPMDisplay', 'LifeFrame', 'ScoreFrame', 'Overlay', 'Underlay' }) do
                if SCREENMAN:GetTopScreen():GetChild(v) then
                    SCREENMAN:GetTopScreen():GetChild(v):hidden(1)
                end
            end
        end
    
        for pn = 1, 2 do
            local plr = SCREENMAN:GetTopScreen():GetChild('PlayerP' .. pn) or nil
            table.insert(mod_plr, plr)
            if plr then
    
                melody['P' .. pn] = plr
                melody['jud' .. pn] = plr:GetChild('Judgment')
                melody['com' .. pn] = plr:GetChild('Combo')
                mod_plr_origin[pn][1] = plr:GetX()
                mod_plr_origin[pn][2] = plr:GetY()
                if config.minimum_build == 'OpenITG' then
                    melody['jud' .. pn]:zoom(0.7)
                    melody['com' .. pn]:zoom(0.7)
                else
                    melody['P' .. pn]:GetChild('NoteField'):cmd('rotationx,0;rotationy,0;rotationz,0;zoomz,1;')
                    for ex = pn + 2, 8, 2 do
                        melody['P' .. ex] = SCREENMAN:GetTopScreen():GetChild('PlayerP' .. ex)
                    end
                end
    
            end
        end
        -- Bug with V4 and V4.0.1
        if FUCK_EXE and version_minimum('V4') then
            if GAMESTATE:IsEditMode() then
                for pn=1, 8 do

                    if melody['P' .. pn] then melody['P' .. pn]:cmd('x2,0;y2,0;z2,0;zoomx2,1;zoomy2,1;zoomz2,1;rotationx2,0;rotationy2,0;rotationz2,0;skewx2,0;skewy2,0') end

                end
            end
        end
    
        local i_res, i_err = pcall(setup_hooks)
        if not i_res then SystemMessage(i_err); return end
    
        if FUCK_EXE then
            MESSAGEMAN:Broadcast('InitializeProxies')
            MESSAGEMAN:Broadcast('InitializeAFTs')
        end
    
        local o_res, o_err = pcall(init_hooks)
        if not o_res then SystemMessage(o_err); return end
    
        if config.custom_update and config.custom_update_type ~= false then
            self:addcommand('Update', function(self)
                update()
                self:sleep(1 / config.custom_update)
                self:queuecommand('Update')
            end)
            self:queuecommand('Update')
        else
            self:addcommand('Update', melody.update)
            self:luaeffect('Update')
        end

    end

end

--+ Update +--
do

    delta_time = 0
    local accumulator = 0
    local global_delta_time = os and os.clock() or GlobalClock:GetSecsIntoEffect()
    
    local first_seen_beat = GAMESTATE:GetSongBeat()
    update = function()

        local beat = GAMESTATE:GetSongBeat()
        if beat <= first_seen_beat + 0.1 then return end

        --

        local cur_delta_time = os and os.clock() or GlobalClock:GetSecsIntoEffect()
        local _delta_time = cur_delta_time - global_delta_time
        
        if config.custom_update_type then
            accumulator = accumulator + _delta_time
            delta_time = config.custom_update_type    
            if accumulator >= config.custom_update then
                local res, err = pcall(update_hooks)
                if not res then SystemMessage( err ); update = function() end end
                accumulator = accumulator - config.custom_update
            end
        else
            delta_time = _delta_time
            local res, err = pcall(update_hooks)
            if not res then SystemMessage( err ); update = function() end end
        end
        
        global_delta_time = cur_delta_time

    end

end