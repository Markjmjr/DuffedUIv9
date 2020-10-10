local D, C, L = unpack(select(2, ...))

local update = CreateFrame('Frame')

local function IsAddOnEnabled(addon)
    return GetAddOnEnableState(D['MyName'], addon) == 2 or 1
end

function update:DisableAddOns()
    if IsAddOnEnabled('AddOnSkins') then DisableAddOn('AddOnSkins') end
    if IsAddOnEnabled('ProjectAzilroka') then DisableAddOn('ProjectAzilroka') end
end

function update:Load()
    if DuffedUIData.firstlogin == true then return end

    self:DisableAddOns()
        
    if DuffedUIData then DuffedUIData = nil end
    if DuffedUIDataPerChar then D['SetPerCharVariable']('DuffedUIDataPerChar', nil) end
    
    DuffedUIData.firstlogin = true
    D['Install']()
end

update:RegisterEvent('PLAYER_LOGIN')
update:SetScript('OnEvent', function(self, event, ...)
    update:Load()
end)