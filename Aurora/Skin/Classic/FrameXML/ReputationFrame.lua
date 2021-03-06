local _, private = ...
if private.isRetail then return end

--[[ Lua Globals ]]
-- luacheck: globals next type

--[[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        _G.ReputationBar1:SetPoint("TOPRIGHT", -34, -49)
    end
    function Hook.ReputationFrame_Update(self)
        for i = 1, _G.NUM_FACTIONS_DISPLAYED do
            local factionRow = _G["ReputationBar"..i]
            if factionRow.index then
                local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(factionRow.index)

                local bd = factionRow._bdFrame or factionRow
                if atWarWith then
                    Base.SetBackdropColor(bd, Color.red)
                else
                    Base.SetBackdropColor(bd, Color.button)
                end

                if factionRow.index == _G.GetSelectedFaction() then
                    if _G.ReputationDetailFrame:IsShown() then
                        bd:SetBackdropBorderColor(Color.highlight)
                    end
                end
            end
        end
    end
end

do --[[ FrameXML\ReputationFrame.xml ]]
    local function OnEnter(button)
        (button._bdFrame or button):SetBackdropBorderColor(Color.highlight)
    end
    local function OnLeave(button)
        if (_G.GetSelectedFaction() ~= button.index) or (not _G.ReputationDetailFrame:IsShown()) then
            local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(button.index)
            if atWarWith then
                (button._bdFrame or button):SetBackdropBorderColor(Color.red)
            else
                (button._bdFrame or button):SetBackdropBorderColor(Color.button)
            end
        end
    end

    function Skin.ReputationHeaderTemplate(Button)
        Skin.ExpandOrCollapse(Button)
        Button:SetBackdropOption("offsets", {
            left = 3,
            right = 286,
            top = 0,
            bottom = 0,
        })
    end
    function Skin.ReputationBarTemplate(StatusBar)
        Skin.FrameTypeStatusBar(StatusBar)
        StatusBar:HookScript("OnEnter", OnEnter)
        StatusBar:HookScript("OnLeave", OnLeave)

        local bdFrame = _G.CreateFrame("Frame", nil, StatusBar)
        bdFrame:SetFrameLevel(StatusBar:GetFrameLevel() - 1)
        bdFrame:SetPoint("TOPRIGHT", 3, 3)
        bdFrame:SetPoint("BOTTOMLEFT", -133, -3)
        Base.SetBackdrop(bdFrame, Color.button)
        StatusBar._bdFrame = bdFrame

        local name = StatusBar:GetName()
        _G[name.."FactionName"]:SetPoint("LEFT", bdFrame, 5, 0)
        _G[name.."FactionName"]:SetPoint("RIGHT", StatusBar,"LEFT" , -5, 0)

        _G[name.."ReputationBarLeft"]:Hide()
        _G[name.."ReputationBarRight"]:Hide()

        _G[name.."Highlight2"]:SetAlpha(0)
        _G[name.."Highlight1"]:SetAlpha(0)
    end
end

function private.FrameXML.ReputationFrame()
    _G.ReputationFrame:HookScript("OnShow", Hook.ReputationFrame_OnShow)
    _G.hooksecurefunc("ReputationFrame_Update", Hook.ReputationFrame_Update)

    ---------------------
    -- ReputationFrame --
    ---------------------
    local bg = _G.CharacterFrame:GetBackdropTexture("bg")

    local tl, tr, bl, br = _G.ReputationFrame:GetRegions()
    tl:Hide()
    tr:Hide()
    bl:Hide()
    br:Hide()

    _G.ReputationHeader1:ClearAllPoints()
    _G.ReputationHeader1:SetPoint("TOPLEFT", bg, 10, -45)
    for i = 1, _G.NUM_FACTIONS_DISPLAYED do
        local factionRow = _G["ReputationBar"..i]
        local factionHeader = _G["ReputationHeader"..i]
        Skin.ReputationBarTemplate(factionRow)
        Skin.ReputationHeaderTemplate(factionHeader)

        if i > 1 then
            factionHeader:ClearAllPoints()
            factionHeader:SetPoint("TOPLEFT", _G["ReputationHeader"..i-1], "BOTTOMLEFT", 0, -10)
        end
        factionRow:SetPoint("TOPLEFT", factionHeader, 152, 0)
    end

    _G.ReputationFrameFactionLabel:SetPoint("TOPLEFT", 80, -40)
    _G.ReputationFrameStandingLabel:SetPoint("TOPLEFT", 220, -40)

    _G.ReputationListScrollFrame:SetPoint("TOPLEFT", bg, 4, -4)
    _G.ReputationListScrollFrame:SetPoint("BOTTOMRIGHT", bg, -23, 4)

    Skin.FauxScrollFrameTemplate(_G.ReputationListScrollFrame)
    local top, bottom = _G.ReputationListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()


    Skin.MainMenuBarWatchBarTemplate(_G.ReputationWatchBar)


    ---------------------------
    -- ReputationDetailFrame --
    ---------------------------
    _G.ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)
    Skin.DialogBorderTemplate(_G.ReputationDetailFrame)

    _G.ReputationDetailFactionName:SetPoint("TOPLEFT", 10, -10)
    _G.ReputationDetailFactionName:SetPoint("TOPRIGHT", -10, -10)
    _G.ReputationDetailFactionDescription:SetPoint("TOPLEFT", _G.ReputationDetailFactionName, "BOTTOMLEFT", 0, -5)
    _G.ReputationDetailFactionDescription:SetPoint("TOPRIGHT", _G.ReputationDetailFactionName, "BOTTOMRIGHT", 0, -5)

    local detailBG = _G.select(3, _G.ReputationDetailFrame:GetRegions())
    detailBG:SetPoint("TOPLEFT", 1, -1)
    detailBG:SetPoint("BOTTOMRIGHT", _G.ReputationDetailFrame, "TOPRIGHT", -1, -142)
    detailBG:SetColorTexture(Color.button:GetRGB())
    _G.ReputationDetailCorner:Hide()

    _G.ReputationDetailDivider:SetColorTexture(Color.frame:GetRGB())
    _G.ReputationDetailDivider:ClearAllPoints()
    _G.ReputationDetailDivider:SetPoint("BOTTOMLEFT", detailBG)
    _G.ReputationDetailDivider:SetPoint("BOTTOMRIGHT", detailBG)
    _G.ReputationDetailDivider:SetHeight(1)

    Skin.UIPanelCloseButton(_G.ReputationDetailCloseButton)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailAtWarCheckBox) -- BlizzWTF: doesn't use the template, but it should
    _G.ReputationDetailAtWarCheckBox:SetPoint("TOPLEFT", detailBG, "BOTTOMLEFT", 10, -6)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailInactiveCheckBox)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailMainScreenCheckBox)
end
