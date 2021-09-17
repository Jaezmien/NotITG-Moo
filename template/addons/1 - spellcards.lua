spellcards = {}
--
local cards = {}
local labels = {}
--
spellcards.spellcard = function(bstart, bend, name, difficulty, color)
    color = color or {1, 1, 1, 1}
    table.insert(cards, {bstart, bend, name, difficulty, color})
    return spellcards -- Allows command chain
end
spellcards.label = function(bstart, name)
    table.insert(labels, {bstart, name})
    return spellcards
end
spellcards.clear = function()
    cards = {}
    labels = {}
    return spellcards
end
--
spellcards.push = function()
	if not FUCK_EXE then return end
    if tonumber(GAMESTATE:GetVersionDate()) < 20170714  then return false end

    local s = GAMESTATE:GetCurrentSong()

    if table.getn(cards) > 0 then
        s:SetNumSpellCards(table.getn(cards))
        for i = 1, table.getn(cards) do
            local a = cards[i]
            s:SetSpellCardTiming(i - 1, a[1], a[2])
            s:SetSpellCardName(i - 1, a[3])
            s:SetSpellCardDifficulty(i - 1, a[4])
            s:SetSpellCardColor(i - 1, a[5][1], a[5][2], a[5][3], a[5][4])
        end
    end

    if table.getn(labels) > 0 then
        s:ClearLabels()
        for i = 1, table.getn(labels) do
            s:AddLabel(labels[i][1], labels[i][2])
        end
    end
    
    --
    spellcards = setmetatable({},{
        __index = function(self,key)
            if key == 'cards' then
                return cards
            elseif key == 'labels' then
                return labels
            else
                return nil
            end
        end
    })
end