-- Adapted from
-- Tweener's easing functions (Penner's Easing Equations)
-- and http://code.google.com/p/tweener/ (jstweener javascript version)
--
-- Modified by Jaezmien to use only one main parameter
--
--[[
	Disclaimer for Robert Penner's Easing Equations license:
	TERMS OF USE - EASING EQUATIONS
	Open source under the BSD License.
	Copyright © 2001 Robert Penner
	All rights reserved.
	Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
		* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
		* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
		* Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.
	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
]]
-- For all easing functions:
-- t = elapsed time (0-1)
-- b = begin (0)
-- c = change == ending - beginning (0)
-- d = duration (total time) (1)

local pi, pow, sin, cos, sqrt, asin =
	math.pi, math.pow, math.sin, math.cos, math.sqrt, math.asin

local _convert_ease = function( e )
	return function( t, b, c, d, a, p )
		return b + e( t/d, a, p ) * c
	end
end
convert_ease = setmetatable({}, {
	__call = function(s, k)
		s[k] = s[k] or _convert_ease( k )
		return s[k]
	end
})

mix = function(x, y, c)
	c = c or 0.5
	return function(t, a, p)
		if t < c then return x( t*2, a, p ) * c end
		return c + y( (t*2)-1, a, p ) * (1-c)
	end
end

-- from mirin template
flip = setmetatable({}, {
	__call = function(s, k)
		s[k] = s[k] or function(t) return 1 - k(t) end
		return s[k]
	end
})

local easeParam = function( ease )
	local param = function( a, p )
		return function( t )
			return ease( t, a, p )
		end
	end
	return setmetatable({},{
		__index = function(_, k)
			if k == "param" or k == "params" then return param end
			return nil
		end,
		__call = function(_, t, a, p) return ease( t, a, p ) end
	})
end

-- Tweener's easing functions

linear = function(t) return t end

inQuad = function(t) return t * t end
outQuad = function(t) return -1 * t * (t - 2) end
inOutQuad = mix( inQuad, outQuad )
outInQuad = mix( outQuad, inQuad )

inCubic = function(t) return t * t * t end
outCubic = function(t) t =  t - 1; return (t * t * t) + 1 end
inOutCubic = mix( inCubic, outCubic )
outInCubic = mix( outCubic, inCubic )

inQuart = function(t) return t * t * t * t end
outQuart = function(t) t = t - 1; return -1 * ( (t * t * t * t)-1 ) end
inOutQuart = mix( inQuart, outQuart )
outInQuart = mix( outQuart, inQuart )

inQuint = function(t) return t * t * t * t * t end
outQuint = function(t) t = t - 1; return (t * t * t * t * t) + 1 end
inOutQuint = mix( inQuint, outQuint )
outInQuint = mix( outQuint, inQuint )

inSine = function(t) return -1 * cos(t * (pi / 2)) + 1 end
outSine = function(t) return sin(t * (pi / 2)) end
inOutSine = function(t) return -1 / 2 * (cos(pi * t) - 1) end
outInSine = mix( outSine, inSine )

inExpo = function(t) return t == 0 and 0 or ( pow(2, 10 * (t-1)) - 1 * 0.001 ) end
outExpo = function(t) return t == 1 and 1 or ( 1.001 * (-pow(2, -10 * t) + 1) ) end
inOutExpo = function(t)
	if t == 0 or t == 1 then return t end
	t = t * 2
	if t < 1 then return 0.5 * pow(2, 10 * (t - 1)) - 1 * 0.0005
	else
		t = t - 1
		return 0.5 * 1.0005 * (-pow(2, -10 * t) + 2)
	end
end
outInExpo = mix( outExpo, inExpo )

inCirc = function(t) return -1 * (sqrt(1 - (t * t)) - 1) end
outCirc = function(t) t = t - 1; return sqrt(1 - (t * t)) end
inOutCirc = mix( inCirc, outCirc )
outInCirc = mix( outCirc, inCirc )

-- a: amplitude
-- p: period
local _inElastic = function(t, a, p)
	if t == 0 or t == 1 then return t end
	if not p then p = 0.3 end

	local s
	if not a or a < 1 then a = 1; s = p / 4
	else s = p / (2 * pi) * asin(1 / a)
	end

	t = t - 1;
	return -(a * pow(2, 10 * t) * sin((t - s) * (2 * pi) / p))
end; inElastic = easeParam( _inElastic )
local _outElastic = function(t, a, p)
	if t == 0 or t == 1 then return t end
	if not p then p = 0.3 end

	local s
	if not a or a < 1 then a = 1; s = p / 4
	else s = p / (2 * pi) * asin(1 / a)
	end
	return a * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) + 1
end; outElastic = easeParam( _outElastic )


-- p = period
-- a = amplitude
local _inOutElastic = function(t, a, p)
	if t == 0 or t == 1 then return t end
	if not p then p = 0.3 * 1.5 end
	if not a then a = 0 end

	local s
	if not a or a < 1 then a = 1; s = p / 4
	else s = p / (2 * pi) * asin(1 / a)
	end

	t = t * 2
	if t < 1 then
		t = t - 1; return -0.5 * (a * pow(2, 10 * t) * sin((t - s) * (2 * pi) / p))
	else
		t = t - 1; return a * pow(2, -10 * t) * sin((t - s) * (2 * pi) / p) * 0.5 + 1
	end
end; inOutElastic = easeParam( _inOutElastic )
outInElastic = easeParam( mix(outElastic, inElastic) )

inBack = function(t, s) s = s or 1.70158; return t * t * ((s + 1) * t - s) end
outBack = function(t, s) s = s or 1.70158; t = t - 1; return t * t * ((s + 1) * t + s) + 1 end
inOutBack = function(t, s)
	s = (s or 1.70158) * 1.525
	t = t * 2
	if t < 1 then return 0.5 * (t * t * ((s + 1) * t - s))
	else t = t - 2; return 0.5 * (t * t * ((s + 1) * t + s) + 2)
	end
end
outInBack = easeParam( mix(outBack, inBack) )

local _outBounce = function(t)
	if t < 1 / 2.75 then
		return 7.5625 * t * t
	elseif t < 2 / 2.75 then
		t = t - (1.5 / 2.75); return 7.5625 * t * t + 0.75
	elseif t < 2.5 / 2.75 then
		t = t - (2.25 / 2.75); return 7.5625 * t * t + 0.9375
	else
		t = t - (2.625 / 2.75); return 7.5625 * t * t + 0.984375
	end
end
outBounce = _outBounce
inBounce = function(t) return 1 - outBounce(1 - t) end
inOutBounce = mix( inBounce, outBounce )
outInBounce = mix( outBounce, inBounce )

-- OpenITG eases
accelerate = inQuad
decelerate = function(t) return 1 - (1 - t) * (1 - t) end
bouncebegin = function(t) return 1 - sin( 1.1 + t * (pi - 1.1) ) / 0.89 end
bounceend = function(t) return sin( 1.1 + (1 - t) * (pi) ) / 0.89  end
spring = function(t) return 1 - cos( t * pi * 2.5 ) / ( 1 + t * 3 ) end