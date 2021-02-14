local reader = {}

-- insert modreader stuff here
------------------------------

reader.init_modsp1 = '';
reader.init_modsp2 = '';

reader.mods = {}
reader.mods_ease = {}
reader.mods2 = {}
reader.mod_perframes = {}
reader.mod_actions = {}
local curaction = 1

local first_seen_beat = GAMESTATE:GetSongBeat()
local setup = false
local update = function()
    local beat = GAMESTATE:GetSongBeat()

    if not setup then
        local comp = function(a,b) return a[1]<b[1] end
        table.sort( reader.mod_actions, comp )
        setup = true
    end

    local disable = false;

    if disable then return end
    if beat <= first_seen_beat + 0.1 then return end -- performance coding!! --

    for pn=1,2 do
        -- mod_do( 'clearall', pn )
        if reader['init_modsp'..pn] then mod_do( reader['init_modsp'..pn], pn ) end
    end

    for i,v in pairs( reader.mods ) do
        if v and table.getn(v) > 3 and v[1] and v[2] and v[3] and v[4] then
            if beat >=v[1] then
                if (v[4] == 'len' and beat <=v[1]+v[2]) or (v[4] == 'end' and beat <=v[2]) then
                    if table.getn(v) == 5 then
                        mod_do(v[3],v[5]);
                    else
                        mod_do(v[3]);
                    end
                end
            end
        else
            v[1] = 0;
            v[2] = 0;
            v[3] = '';
            v[4] = 'error';
            SCREENMAN:SystemMessage('Bad mod in beat-based table (line '..i..')');
        end
    end

    local time = get_song_time()
    for i,v in pairs( reader.mods2 ) do
        if v and table.getn(v) > 3 and v[1] and v[2] and v[3] and v[4] then
            if time >=v[1] then
                if (v[4] == 'len' and time <=v[1]+v[2]) or (v[4] == 'end' and time <=v[2]) then
                    if table.getn(v) == 5 then
                        mod_do(v[3],v[5]);
                    else
                        mod_do(v[3]);
                    end
                end
            end
        else
            v[1] = 0;
            v[2] = 0;
            v[3] = 'error';
            v[4] = 'error';
            SCREENMAN:SystemMessage('Bad mod in time-based table (line '..i..')');
        end
    end

    for i,v in pairs( reader.mods_ease ) do
        if v and table.getn(v) > 6 and v[1] and v[2] and v[3] and v[4] and v[5] and v[6] and v[7] then
            if beat >=v[1] then
                if (v[6] == 'len' and beat <=v[1]+v[2]) or (v[6] == 'end' and beat <=v[2]) then
                    local strength = v[7](beat - v[1], v[3], v[4] - v[3], v[6] == 'end' and v[2] - v[1] or v[2], v[10], v[11])
                    if type(v[5]) == 'string' then
                        local modstr = v[5] == 'xmod' and strength..'x' or (v[5] == 'cmod' and 'C'..strength or strength..' '..v[5])
                        mod_do('*-1 '..modstr,v[8]);
                    elseif type(v[5]) == 'function' then
                        v[5](strength)
                    end
                elseif (v[9] and ((v[6] == 'len' and beat <=v[1]+v[2]+v[9]) or (v[6] == 'end' and beat <=v[9]))) then
                    if type(v[5]) == 'string' then
                        local modstr = v[5] == 'xmod' and v[4]..'x' or (v[5] == 'cmod' and 'C'..v[4] or v[4]..' '..v[5])
                        mod_do('*-1 '..modstr,v[8]);
                    elseif type(v[5]) == 'function' then
                        v[5](v[4])
                    end
                end
            end
        else
            SCREENMAN:SystemMessage('Ease Error! (line '..i..' | beat: '.. v[1] .. ' | mod: '.. v[5] ..')');
        end
    end

    if table.getn( reader.mod_perframes )>0 then
        for i=1,table.getn(reader.mod_perframes) do
            local a = reader.mod_perframes[i]
            if beat > a[1] and beat < a[2] then
                a[3](beat,delta_time);
            end
        end
    end

    while curaction<=table.getn( reader.mod_actions ) and GAMESTATE:GetSongBeat()>= reader.mod_actions[curaction][1] do
        local mod_action = reader.mod_actions[ curaction ]
        if mod_action[3] or GAMESTATE:GetSongBeat() < mod_action[1]+2 then
            if type(mod_action[2]) == 'function' then
                mod_action[2]()
            elseif type(mod_action[2]) == 'string' then
                MESSAGEMAN:Broadcast( mod_action[2] );
            end
        end
        curaction = curaction+1;
    end
end
------------------------------
-- insert modreader stuff here

return reader, {
    func = update,
    clear = true,
}