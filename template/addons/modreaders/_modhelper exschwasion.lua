local helper = {}

-- insert mod helper stuff here
-------------------------------
function helper.mod_insert(beat,len,mod,t,pn)
    if not t then t = 'len' end
    table.insert(mods,{beat,len,mod,t,pn});
end
function helper.mod2_insert(beat,len,mod,t,pn)
    if not t then t = 'len' end
    table.insert(mods2,{beat,len,mod,t,pn});
end
function helper.mod_ease(beat,len,str1,str2,mod,t,ease,pn,sus,opt1,opt2)
    table.insert(mods_ease,{beat,len,str1,str2,mod,t,ease,pn,sus,opt1,opt2});
end
function helper.mod_perframe(start_beat,end_beat,f)
    table.insert(mod_perframes,{start_beat,end_beat,f});
end
function helper.mod_message(beat,msg,p)
    table.insert(mod_actions,{beat,msg,p});
end

function helper.simple_m0d(beat,strength,mult,mod,pn)
    if not strength then strength = 400 end
    if not mult then mult = 1 end
    if not mod then mod = 'drunk' end
    
    local alive = math.max(2*mult*math.abs(strength)/100,0.25)
    
    table.insert(mods,{beat,0.3,'*100000 '..strength..' '..mod,'len',pn});
    table.insert(mods,{beat+.2,alive,'*'..((1/mult)*math.abs(strength)/100)..' no '..mod,'len',pn});
end
function helper.simple_m0d2(beat,strength,mult,mod,pn)
    if not strength then strength = 400 end
    if not mult then mult = 1 end
    if not mod then mod = 'drunk' end
    
    local alive = math.max(10*mult*math.abs(strength)/100,0.25)
    
    table.insert(mods,{beat,0.3,'*'..math.abs(strength/10)..' '..strength..' '..mod,'len',pn});
    table.insert(mods,{beat+.3,alive,'*'..((1/mult)*math.abs(strength)/100)..' no '..mod,'len',pn});
end
function helper.simple_m0d3(beat,strength,duration,bpm,mod,pn)
    if not strength then strength = 400 end
    if not duration then duration = 1 end
    if not bpm then bpm = 120 end
    if not mod then mod = 'drunk' end
    
    local alive = duration * (60/bpm)
    local str = (1/(duration * 60/bpm)) * (math.abs(strength)/100)
    
    table.insert(mods,{beat-duration,duration,'*'..str..' '..strength..' '..mod,'len',pn});
    table.insert(mods,{beat,duration*1.1,'*'..str..' no '..mod,'len',pn});
end

function helper.mod_wiggle(beat,num,div,amt,speed,mod,pn,first)
    if not speed then speed = 1 end
    local fluct = 1
    for i=0,(num-1) do
        b = beat+(i/div)
        local m = 1
        if i==0 and not first then m = 0.5 end
        table.insert(mods,{b,1,'*'..math.abs(m*speed*amt/10)..' '..(amt*fluct)..' '..mod..'','len',pn});
        fluct = fluct*-1;
    end
    table.insert(mods,{beat+(num/div),1,'*'..math.abs(amt*speed/20)..' no '..mod..'','len',pn});
end
--like wiggle, but springier
--beat,strength,num,mod,pn
function helper.mod_spring(beat,strength,num,mod,pn)
    local fluct = 1;
    for i=0,num do
        if i==0 then mult = 0.5 else mult = 1 end
        local amt = (num-i)/num
        local b = beat+(0.05*i)
        
        table.insert(mods,{b,0.3,'*'..math.max(math.abs(1000*strength*mult*amt),1)..' '..(strength*amt*fluct)..' '..mod,'len',pn});
        
        fluct = fluct*-1;
    end
end
function helper.mod_springt(beat,strength,dur,mod,pn)
    local fluct = 1;
    dur = math.max(dur,0.02)
    for i=0,dur-.01,0.02 do
        local mult = 1;
        local amt = (dur-i)/dur
        local b = beat+i
        
        table.insert(mods2,{b,0.02,'*100000 '..(strength*amt*fluct)..' '..mod,'len',pn});
        
        fluct = fluct*-1;
    end
    table.insert(mods2,{beat+dur,0.1,'*100000 no '..mod,'len',pn});
end
function helper.mod_springt2(beat,strength,dur,mod,pn)
    local fluct = 1;
    for i=0,dur-.01,0.02 do
        local b = beat+i
        
        table.insert(mods2,{b,0.02,'*100000 '..(strength*fluct)..' '..mod,'len',pn});
        
        fluct = fluct*-1;
    end
    table.insert(mods2,{beat+dur,0.1,'*100000 no '..mod,'len',pn});
end
--beat,strength,num,period,mod,pn
function helper.mod_spring_adjustable(beat,strength,num,period,mod,pn, first)
    local fluct = 1;
    for i=0,num do
        if i==0 then mult = 0.5 else mult = 1 end
        local amt = (num-i)/num
        local b = beat+(period*0.5*i)
        
        local m = 1
        if i==0 and not first then m = 0.5 end
        
        table.insert(mods,{b,0.3,'*'..math.max(m*math.abs((0.2/period)*strength*mult*amt),1)..' '..(strength*amt*fluct)..' '..mod,'len',pn});
        
        fluct = fluct*-1;
    end
end

function helper.mod_beat(beat,strength,pn)
    if not strength then strength = 1000 end;
    table.insert(mods,{beat-.5,1,'*10000 '..strength..' beat','len',pn});
    table.insert(mods,{beat+.5,0.25,'*10000 no beat','len',pn});
end

function helper.switcheroo_reset()
    switcheroo_flip = {0,0,0};
    switcheroo_invert = {0,0,0};
end
helper.switcheroo_flip = {0,0,0};
helper.switcheroo_invert = {0,0,0};
helper.switcheroo_width = 1;
helper.switcheroos = {normal = {0,0}, ldur = {0,0}, reset = {0,0},
    flip = {100,0}, rudl = {100,0}, invert = {0,100}, dlru = {0,100},
    ludr = {25,-75}, rdul = {75,75}, drlu = {25,125}, ulrd = {75,-125}, urld = {100,-100}}
function helper.switcheroo_add(beat,which,speed,len,pn)

    if not speed then speed = 1000000 end
    
    local mpn = 3
    if pn then mpn = pn end
    
    local w = {0,0}
    
    if type(which) == 'string' then w = switcheroos[which] end
    if type(which) == 'table' then w = which end
    
    if w then
        local targf = (helper.switcheroos[which][1]*helper.switcheroo_width) + ( 50 - helper.switcheroo_width*50 )
        local targi = (helper.switcheroos[which][2]*helper.switcheroo_width)
        local sw_modlist = ''
        if helper.switcheroo_flip[mpn] ~= targf then
            sw_modlist = sw_modlist..'*'..(0.01*speed*math.abs(targf-helper.switcheroo_flip[mpn]))..' '..(targf)..' flip,'
        else
            sw_modlist = sw_modlist..'*1 '..(targf)..' flip,'
        end
        if helper.switcheroo_invert[mpn] ~= targi then
            sw_modlist = sw_modlist..'*'..(0.01*speed*math.abs(targi-helper.switcheroo_invert[mpn]))..' '..(targi)..' invert'
        else
            sw_modlist = sw_modlist..'*1 '..(targi)..' invert'
        end
        table.insert(mods,{beat,len,sw_modlist,'len',pn});
        
        --Trace('SPEED: '..(0.01*speed*math.abs(targf-switcheroo_flip)));
        --Trace(sw_modlist);
        
        if mpn == 3 then
            for apn=1,3 do
                helper.switcheroo_flip[apn] = targf;
                helper.switcheroo_invert[apn] = targi;
            end
        else
            helper.switcheroo_flip[mpn] = targf;
            helper.switcheroo_invert[mpn] = targi;
        end
    
    end
    
end

function helper.mod_sugarkiller(beat,duration,speed,minstealth,maxstealth,pn)
    if not minstealth then minstealth = 50 end
    if not maxstealth then maxstealth = 85 end
    if not speed then speed = 1 end
    local dur = duration
    if not dur then dur = 1 end
    dur = dur*speed;
    for i=0,math.max(dur-1,0) do
        table.insert(mods,{beat+(i*0.5),.25/speed,'*10000 Invert, *10000 no flip, *10000 '..maxstealth..'% Stealth','len',pn})
        table.insert(mods,{beat+(i*0.5)+.25/speed,.25/speed,'*10000 Flip, *10000 no invert, *10000 '..maxstealth..'% Stealth','len',pn})
        table.insert(mods,{beat+(i*0.5)+.50/speed,.25/speed,'*10000 Flip,*10000 -100% Invert,*10000 '..maxstealth..'% Stealth','len',pn})
        if i == math.max(dur-1,0) then
            table.insert(mods,{beat+(i*0.5)+.75/speed,.25/speed,'*10000 No Flip,*10000 No Invert,*10000 no Stealth','len',pn})
        else
            table.insert(mods,{beat+(i*0.5)+.75/speed,.25/speed,'*10000 No Flip,*10000 No Invert,*10000 '..minstealth..'% Stealth','len',pn})
        end
    end
end

function helper.reverseRotation(angleX, angleY, angleZ)
    local DEG_TO_RAD = math.pi / 180
    angleX, angleY, angleZ = DEG_TO_RAD * angleX, DEG_TO_RAD * angleY, DEG_TO_RAD * angleZ
    local sinX = math.sin(angleX);
    local cosX = math.cos(angleX);
    local sinY = math.sin(angleY);
    local cosY = math.cos(angleY);
    local sinZ = math.sin(angleZ);
    local cosZ = math.cos(angleZ);
    return 100 * math.atan2(-cosX*sinY*sinZ-sinX*cosZ,cosX*cosY), 100 * math.asin(-cosX*sinY*cosZ+sinX*sinZ), 100 * math.atan2(-sinX*sinY*cosZ-cosX*sinZ,cosY*cosZ)
end

--dumb random function
function helper.randomXD(t)
    if t == 0 then return 0.5 else
    return math.mod(math.sin(t * 3229.3) * 43758.5453, 1) end
end

function helper.mod_bounce(beat,length,start,apex,mod,ease,pn)
    helper.mod_ease(beat, (length/2), start, apex, mod, 'len', _G['out'..ease],pn)
    helper.mod_ease(beat+(length/2), (length/2), apex, start, mod, 'len', _G['in'..ease],pn,0.2)
end

function helper.func_bounce(beat,length,start,apex,func,ease)
    helper.func_ease(beat,(length/2),start,apex,func,'len',_G['out'..tostring(ease)])
    helper.func_ease(beat+(length/2),(length/2),apex,start,func,'len',_G['in'..tostring(ease)],nil,0.2)
end

--stolen from hal thank you very cool
function helper.ease_wiggle(beatS,beatE,amt,inc,str,ease,len,pn)
    local rotStart = 0
    local prevRot = amt
    local curRot = -amt
    local measure = tostring(len)
    local asdf = 0
    if measure == 'end' then
        asdf = beatE
    elseif measure == 'len' then
        asdf = (beatS+beatE)
    end
    for i = beatS,asdf,inc do
        local rotStart = i==beatS and 0 or prevRot
        local rotEnd = i==asdf and 0 or curRot
        helper.mod_ease(i-inc, inc, rotStart, rotEnd, str, 'len', ease, pn)
        prevRot = prevRot *-1
        curRot = curRot *-1
    end
end

function helper.ease_wiggleAbs(beatS,beatE,amt,inc,str,ease,len,pn)
    local rotStart = 0
    local prevRot = 0
    local curRot = amt
    local counter = 1
    local measure = tostring(len)
    local asdf = 0
    if measure == 'end' then
        asdf = beatE
    elseif measure == 'len' then
        asdf = (beatS+beatE)
    end
    for i = beatS,asdf-inc,inc do
        if counter == -1 then
            prevRot,curRot = amt, 0
        elseif counter == 1 then
            prevRot,curRot = 0, amt
        end
        helper.mod_ease(i, inc, prevRot, curRot, str, 'len', ease, pn)
        counter = counter*-1
    end
end
-------------------------------
-- insert mod helper stuff here

return helper