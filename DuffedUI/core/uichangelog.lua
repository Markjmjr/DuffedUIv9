local D, C, L = unpack(select(2, ...))

local _G = _G
local string_gmatch = _G.string.gmatch

local CreateFrame = _G.CreateFrame
	
local UI_CHANGELOG = {
   "Changes:",
		"• New AuraWatch, Thx Azil for the lib!",
		"• This give us speeeeeeeed for Raidframes",
		"• Bugfix AddOnSkins Alerts Frame",
		"• Bugifx AddOnSkins PvP Frame",
		"• Bugifx AddOnSkins Worldmap",
		"• Change values in SMB to bring back buttons to Minimap (Mail, Queue, Tracker)",
		"• Healcomm for Maintankframes",
		"• Healcomm for Player- and Targetframes",
		"• Rangecheck for Target-, ToT- and Maintankframes",
		"• Kill option frequentUpdates on Raidframes ... allways true now",
		"• Changelog on Login is back",
		--"• ",
	" ",
	"Special:",
		"• Pawn users have to deactivate the upgrade border under Pawn tooltip options.",
	" ",
	"Notes:",
		"• For the old friendslist use Enhanced Friendslist from Project Azilroka.",
		"• For skins use AddOnSkins because most of the skins are removed.",
		"• For skinning the Chatbubbles in Instance/Raids download the Texturekit from Github.",
}

local function ModifiedString(string)
    local count = string.find(string, ":")
    local newString = string

    if count then
        local prefix = string.sub(string, 0, count)
        local suffix = string.sub(string, count + 1)
        local subHeader = string.find(string, "•")

        if subHeader then
            newString = tostring("|cFFFFFF00"..prefix.."|r"..suffix)
        else
            newString = tostring("|cffC41F3B"..prefix.."|r"..suffix)
        end
    end

    for pattern in string_gmatch(string, "('.*')") do
        newString = newString:gsub(pattern, "|cffC41F3B"..pattern:gsub("'", "").."|r")
    end

    return newString
end

local function GetUIChangelogInfo(i)
    for line, info in pairs(UI_CHANGELOG) do
        if line == i then
            return info
        end
    end
end

local function CreateUIChangelog()
	if not D.AboutPanel.Changelog then return end
    D.AboutPanel.Changelog:SetScript("OnShow", function(self)
        if self.show then
            return
		end

		local offset = 36

		local titleText = self:CreateFontString(nil, "OVERLAY")
		titleText:SetFont(C['media']['font'], 20, "")
		titleText:SetPoint("CENTER", self, "TOP", 0, -16)
		titleText:SetText(D.Title.." Changelog " .. D.Version)

		local headerBar = self:CreateTexture(nil, "ARTWORK")
		headerBar:SetTexture("Interface\\LFGFrame\\UI-LFG-SEPARATOR")
		headerBar:SetTexCoord(0, 0.6640625, 0, 0.3125)
		headerBar:SetVertexColor(1, 1, 1)
		headerBar:SetPoint("CENTER", titleText)
		headerBar:SetSize(titleText:GetWidth() + 4, 30)

        for i = 1, #UI_CHANGELOG do
            local button = CreateFrame("Frame", "Button"..i, self)
            button:SetSize(375, 16)
            button:SetPoint("TOPLEFT", self, "TOPLEFT", 5, -offset)

            if i <= #UI_CHANGELOG then
                local string = ModifiedString(GetUIChangelogInfo(i))

                button.Text = button:CreateFontString(nil, "OVERLAY")
                button.Text:SetFont(C['media']['font'], 12, "")
                button.Text:SetPoint("CENTER")
                button.Text:SetPoint("LEFT", 0, 0)
                button.Text:SetText(string)
                button.Text:SetWordWrap(false)
            end
            offset = offset + 16
		end

		self.show = true
    end)
end

CreateUIChangelog()