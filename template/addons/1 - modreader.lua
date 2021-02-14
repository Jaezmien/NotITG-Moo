modreader = {}

--

local activation_rate = FUCK_EXE and '*-1 ' or '*9999 '
mod_do = function(mod, pn) GAMESTATE:ApplyGameCommand('mod,' .. string.gsub(mod, '(%*%-%d) ', activation_rate), pn) end
if version_minimum('V2') then mod_do = function(mod, pn) GAMESTATE:ApplyModifiers(mod, pn) end end

--

local files;

if (config.minimum_build == 'OpenITG') or not FUCK_EXE then
    files = config.default_reader or {'exschwasion'}
else
    files = { GAMESTATE:GetFileStructure(song_dir .. 'template/addons/modreaders/') }
end

local readers = {}
for _, v in pairs(files) do
    if string.sub(v, -4) == '.lua' and string.sub(v, 1, 1) ~= '_' then
        table.insert(readers, string.sub(v, 1, -5))
    end -- Discard other files
end

local updates = {}
local updates_clear = false

for _, v in pairs(readers) do
    local reader, fUpdate = lua('template/addons/modreaders/' .. v)
    if reader then
        local helper = lua { 'template/addons/modreaders/_modhelper ' .. v, env = reader }
        if type(helper) ~= 'table' then helper = {} end

        setmetatable(reader, {__index = melody, __newindex = melody})
        setmetatable(helper, {__index = reader, __newindex = reader})

        modreader[v] = helper
        updates[v] = fUpdate.func
        if fUpdate.clear == true then updates_clear = true
        elseif fUpdate.clear == false and updates_clear then

            if fUpdate.disable then
                fUpdate.disable()
            else
                modreader[v] = nil; updates[v] = nil
                print('[Mod Reader]', 'A template requested `clearall` functionality, which breaks "'.. v ..'" reader. Ignoring...')
            end

        end

        if modreader[v] then print('[Mod Reader]', 'Loaded ' .. v .. ' mod reader') end
    end
end

update_hooks{ 'modreader update', function()

    if updates_clear then mod_do('*-1 clearall') end

    for id,func in pairs( updates ) do
        local res, err = pcall( func )
        if not res then
            print('[Mod Reader]', id .. ' reader error')
            print( err )
            updates[ id ] = nil
        end
    end

end }