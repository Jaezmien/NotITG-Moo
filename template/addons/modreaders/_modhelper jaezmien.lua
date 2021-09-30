local helper = {}

-- insert mod helper stuff here
-------------------------------

function helper.mod_bounce(beat, length, start, apex, bmod, bease, invert, plr, extra)
	if length > beat then length = length-beat end
	local i,o = 'out', 'in'
	if invert then i, o = o, i end
	ease {beat, start, bmod, plr = plr, extra = extra}
	{beat             , length/2, melody[i..bease],  apex, bmod, plr = plr}
	{beat + (length/2), length/2, melody[o..bease], start, bmod, plr = plr}
end

function helper.func_bounce(beat, length, start, apex, func, ease, invert)
	if length > beat then length = length-beat end
	local i,o = 'out', 'in'
	if invert then i, o = o, i end
	ease_func {beat             , length/2, start, apex, func, melody[i..ease]}
	{beat + (length/2), length/2, apex, start, func, melody[o..ease]}
end

function helper.mod_beat(beat,strength)
	ease {beat-0.5, strength or 2000 ,'beat'}
	{beat+0.5, 0 , 'beat'}
end

-- stolen from hal mirin template
function helper.mod_wiggle(beat, len, mease, amt, step, mod, abs, plr)
	if len > beat then len = len-beat end
    local j = 0
    for i = 0, len, step do
        local f = math.mod(j,2)*2-1
        ease{beat - (step/2) + i, step, mease, (i ~= len) and (abs and ((amt/2)+((amt/2)*f)) or amt*f) or 0, mod, plr = plr}
        j = j + 1
    end
end
function helper.mod_wiggle2(beat, len, mease, amt, step, mod, abs, plr)
	if len > beat then len = len-beat end
    local j = 0
    for i = 0, len, step do
        local f = math.mod(j,2)*2-1
		local amtm = 1-(i/len)
        ease{beat - (step/2) + i, step, mease, (i ~= len) and (abs and ((amt/2)+((amt/2)*f)) or amt*f)*amtm or 0, mod, plr = plr}
        j = j + 1
    end
end

-- xero
function helper.column_reverse(a, b, c, d)

	return {
		Split = (-a-b+c+d)/2,
		Cross = (-a+b+c-d)/2,
		Alternate = (-a+b-c+d)/2,
		Reverse = a,
	}
	
end

if not OPENITG or version_minimum('V1') then
	function helper.column_hide(beat, col, hide, plr)
		local col = col-1
		local val = hide and 100 or 0
	
		ease
		{
			beat,
			val, 'stealth'..col,
			val, 'dark'..col,
			val, 'hidenoteflashes'.. col,
			plr = plr
		}
	end
end

-- Guide: 1 beat = 100
redirs{'drivendrop', function(val, pn)
	local bpm = GAMESTATE:GetCurBPS() * 60
	local rate = pmods[pn].xmod
	pmods[pn].centered = (bpm/128*rate)*(val*0.5*0.67)
end}
redirs{'oitgtiny', function(val, pn)
	pmods[pn].mini = val
	pmods[pn].flip = -val*0.1
end}

-------------------------------
-- insert mod helper stuff here

return helper