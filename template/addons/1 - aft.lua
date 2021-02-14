if config.allow_d3d_render and not version_minimum('V4') then
    Trace('## DISABLE config.allow_d3d_render TO USE AFTS ##')
    return
end

aft = {}

aft.mult = 1.0
aft.renderer = 'OpenGL'
aft.nvidia = false

if string.find(string.lower(PREFSMAN:GetPreference('LastSeenVideoDriver')),'nvidia') or string.find(string.lower(DISPLAY:GetVendor()), 'nvidia') then
    aft.nvidia = true
    aft.mult = 0.9
end

local sf_ogl = string.find(string.lower(PREFSMAN:GetPreference('VideoRenderers')),'opengl')
local sf_d3d = string.find(string.lower(PREFSMAN:GetPreference('VideoRenderers')), 'd3d')
if not sf_ogl or sf_d3d and sf_ogl and sf_d3d < sf_ogl then
    aft.renderer = 'D3D'
end

aft.sprites = {}
aft.afts = {}

aft.get_sprite = function(id) return aft.sprites[id] end
aft.get_aft = function(id) return aft.afts[id] end

aft.set_sprite = function(self, id, aftid, autounhide)
    self:basezoomx((SCREEN_WIDTH / DISPLAY:GetDisplayWidth()))
    self:basezoomy(-1 * (SCREEN_HEIGHT / DISPLAY:GetDisplayHeight()))
    self:hidden(1)

    aft.sprites[id] = self

    if aftid and aft.get_aft(aftid) then
        local aft_id = aftid
        local auto_unhide = autounhide
        if auto_unhide then
            self:addcommand('InitializeAFTsMessage',
                melody(function(_)
                    _:SetTexture(aft.get_aft(aft_id):GetTexture())
                    _:hidden(0)
                end)
            )
        else
            self:addcommand('InitializeAFTsMessage',
                melody(function(_)
                    _:SetTexture(aft.get_aft(aft_id):GetTexture())
                end)
            )
        end
    elseif aftid and not aft.get_aft(aftid) then
        print('## AFT ERROR - AFT ID ('..aftid..') DOESN\'T EXIST ##')
    end
end
aft.set_aft = function(self, id, db, ab, fl, pt)
    self:SetWidth(DISPLAY:GetDisplayWidth())
    self:SetHeight(DISPLAY:GetDisplayHeight())
    self:EnableDepthBuffer(db or false)
    self:EnableAlphaBuffer(ab or true)
    self:EnableFloat(fl or false)
    self:EnablePreserveTexture(pt or true)
    self:sleep(0.04)
    self:Create()

    aft.afts[id] = self
end
