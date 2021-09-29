--[[
    Jaezmien's Wierd Mod Reader Syntax v2
    
    -------------------------------------------
    pmods
	> This is how the mod reader is storing the player's mods
	> Thanks to layering, you can have the same mod at the same time with different values!
	> Here are the different ways you can use it:
	>
	> pmods( layer )[ player_number ].mod = value -- Sets the mod for a specific player on a specific layer**
	> pmods( layer ).mod = value                  -- Sets the mod for all players* on a specific layer
	> pmods[ player_number ].mod = value          -- Sets the mod for a specific player on the default layer**
	> pmods.mod = value                           -- Sets the mod for all players* on the default layer

	* Do remember that "all players" mean whatever you have set as default! (Template default, 8 for v4, otherwise, 2)
	** You can also grab the mod value from these!
    -------------------------------------------
    redirs
    > This is a table that you can use to create a mod that uses a function
    > For example the `xmod` mod converts regular mod format into the proper XMod format.
    > You can also do the following:
    >   -- Create a redirect that, just applies flip for now
    >   redirs['flip_alternative'] = function(value,pn)
    >       return '*-1 '.. value ..' flip'
    >   end
    >   pmods.flip_alternative = 100 -- Applies `flip_alternative` to all players.
	> Just need to change the value? Just return a number!
	>	redirs['reverse'] = function(v) return v == 100 and 99.99 or v end
	>	(This is already done in the template)
	>
	> Not only that, you can also use it as a pseudo-aux by supplying a nil value (or an empty function):
	>  redirs['wiggleAux'] = nil
    >
    > There's also the alternative method:
    >   redirs{'mod name', function/nil}

    -------------------------------------------
    ease
    > Eases a mod value to another value
    > Base Format:
    >   ease{ start_beat, length*, ease*, [mods]... }
    >
    > Mods Format:
    >   `new_value (optional), mod_string`. (Can be followed by more mods)
    >   The new value will be determined by the last seen number (default, 100)
    >       `200, 'Drunk', 300, 'Tipsy'` will apply 200% Drunk and 300% Tipsy
    >       `'invert', 'flip'`           will apply 100% Invert and 100% Flip
	>		`0, 'dizzy'`                 will apply 0 dizzy
    >   There's also optional parameters:
    >       `layer` (Number) = Will use the provided layer instead of the default
    >       `plr` (Number[2] / Number) = Will call either a specific player or players instead of the default.
    >
    > Like Ky_Dash and Xero's Mod Reader. This returns the table itself, so you can stack call these!
    >
    > Example:
    >   ease
    >   { 0, 360, 'rotationz' } -- Apply 360 rotationz
    >   { 0, 5, linear, 0, 'rotationz', 100, 'drunk' } -- Set rotationz to 0, and drunk to 100 in 5 beats, with linear ease.

    * Optional. Both must not provided for the ease to run for one frame.

	-------------------------------------------
    clear
	> Clears all active mods and re-applies the init mods. (Except for eases)
	> Format:
	>	{ beat }

	-------------------------------------------
    easef
    > Does an Exschwasion func_ease
    > Format:
    >   { beat_start, beat_length*, value_min, value_max, function, ease** }
    >   There's also optional parameters:
    >       `extra` (Number[]) = Used for extra parameters on specific eases

    * Length is `len` by default. If the value is higher than `start_beat`, it will be treated as `end`
    ** Optional, will use `linear` if not specified.

    -------------------------------------------
    func
    > `func` does two things:
    >   Perframe, with the format:
    >       { beat_start, beat_end, function }
    >   Message broadcast with the format:
    >       { beat_start, function (string/function) }
    >       `persist` (number/boolean) is optional.
    >           If it's a number, it will run the function if the song started past `beat_start+4` and the beat haven't gotten past the persist number.
    >           If it's a boolean, it will always run the function if the song started past `beat_start+4`.

    -------------------------------------------
    Extra stuffs:
        Dont want P1 and P2 to be the default players for some mod lines?
        Use `set_default_pn` to set the new players.
        Format:
            `set_default_pn( min, max ) -- [min - max]`
            `set_default_pn( {min, max} ) -- [min - max]`
            `set_default_pn( max ) -- [1 - max]`
            `set_default_pn() -- [1 - 2]`

		Want to change which layer is used by default?
		Use `set_default_layer` to change it.
		The number passed is clamped from 1 to what is used in setting.lua's config.modreader.jaezmien.layers (or by default, 2)
		Example
			`set_default_layer( 1 )`

		The default mods are `*-1 overhead, *-1 1x`

		Don't want the mods to apply? Set `apply_mods` to false.
            
    Oh! And even though this is in a mod reader environment, any variables created here will be visible in the `melody` env, so you don't have to worry about that.
]]

set_default_pn( 1, 2 ) -- change default player range
set_default_layer( 1 ) -- change default layer

-- Insert mods here! --
-----------------------

-- pmods.beat = 100