local D, C, L = unpack(select(2, ...))

local update = CreateFrame('Frame')
local db = DuffedUIDataPerChar
local firstlogin = db.firstlogin

function update:DisableAddOns()
    if IsAddOnLoaded('AddOnSkins') then DisableAddOn('AddOnSkins') end
    if IsAddOnLoaded('ProjectAzilroka') then DisableAddOn('ProjectAzilroka') end
end

function update:Load()
    if firstlogin == true then return end

    self:DisableAddOns()
        
    if DuffedUIData then DuffedUIData = nil end
    if DuffedUIDataPerChar then D['SetPerCharVariable']('DuffedUIDataPerChar', nil) end
    
    firstlogin = true
    D['Install']()
end

update:RegisterEvent('PLAYER_LOGIN')
update:RegisterEvent('PLAYER_ENTERING_WORLD')
update:SetScript('OnEvent', function(self, event, ...)
    update:Load()
end)