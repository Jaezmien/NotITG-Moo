local function Plr(pn) return melody['P'..pn] end

init_modsp1 = '*-1 2.5x, *-1 overhead';
init_modsp2 = '*-1 2.5x, *-1 overhead';

-- beat based mods
--valid ease types are:
	--linear
	--inQuad    outQuad    inOutQuad    outInQuad
	--inCubic   outCubic   inOutCubic   outInCubic
	--inQuart   outQuart   inOutQuart   outInQuart
	--inQuint   outQuint   inOutQuint   outInQuint
	--inSine    outSine    inOutSine    outInSine
	--inExpo    outExpo    inOutExpo    outInExpo
	--inCirc    outCirc    inOutCirc    outInCirc
	--inElastic outElastic inOutElastic outInElastic    --can take 2 optional parameters - amplitude & period
	--inBack    outBack    inOutBack    outInBack       --can take 1 optional parameter  - spring amount
    --inBounce  outBounce  inOutBounce  outInBounce
    
-- format: { beat_start, beat_end, mod_string, len_or_end, player_number}
mods = {
    
}

-- time based mods
-- format: { time_start, time_end, mod_string, len_or_end, player_number}
mods2 = {

}

-- beat based ease mods and functions
-- format: { beat_start, beat_end, mod_start, mod_end, mod, ease, len_or_end, player_number, persist, ease_extra_1, ease_extra_2}
mods_ease = {

}

-- you can now write perframe stuff without having to scroll down!
-- format: { beat_start, beat_end, function }
mod_perframes = {

}

--this is both a message broadcaster and a function runner
--if you put {beat,'String'}, then 'String' is broadcast as a message on that beat
--if you put {beat,function() somecode end}, then function() is run at that beat
-- format: { beat_start, function, persist }
mod_actions = {
    
}