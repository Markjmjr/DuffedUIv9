local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Hook, Skin = Aurora.Hook, Aurora.Skin
local Color = Aurora.Color

do --[[ FrameXML\HelpBrowser.lua ]]
    local selected
    function Hook.HelpFrame_SetSelectedButton(button)
        if selected and selected ~= button then
            selected:UnlockHighlight()
            selected:Enable()
        end

        button:LockHighlight()
        selected = button
    end
end

do --[[ FrameXML\HelpBrowser.xml ]]
    function Skin.HelpFrameButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button.selected:SetTexture("")
    end
    function Skin.BrowserButtonTemplate(Button)
        Skin.FrameTypeButton(Button)
        Button:SetBackdropOption("offsets", {
            left = 5,
            right = 5,
            top = 5,
            bottom = 5,
        })
    end
    function Skin.BrowserTemplate(Browser)
        Skin.InsetFrameTemplate(Browser.BrowserInset)
        Skin.BrowserButtonTemplate(Browser.settings)
        Skin.BrowserButtonTemplate(Browser.home)
        Skin.NavButtonPrevious(Browser.back)
        Skin.NavButtonNext(Browser.forward)
        Skin.BrowserButtonTemplate(Browser.reload)
        Skin.BrowserButtonTemplate(Browser.stop)
    end
end

function private.FrameXML.HelpBrowser()
    _G.hooksecurefunc("HelpFrame_SetSelectedButton", Hook.HelpFrame_SetSelectedButton)


    ---------------
    -- HelpBrowser --
    ---------------
    local HelpBrowser = _G.HelpBrowser
    Skin.TranslucentFrameTemplate(HelpBrowser)

    local streaks, buttonDiv, vertDivTop, vertDivBottom, vertDivMiddle = select(10, HelpBrowser:GetRegions())
    streaks:Hide()

    if private.isRetail then
        Skin.DialogHeaderTemplate(HelpBrowser.Header)
    else
        local header = HelpBrowser.header
        header:SetAlpha(0)

        local text = header:GetRegions()
        text:SetParent(HelpBrowser)
        text:ClearAllPoints()
        text:SetPoint("TOPLEFT")
        text:SetPoint("BOTTOMRIGHT", HelpBrowser, "TOPRIGHT", 0, -private.FRAME_TITLE_HEIGHT)
    end

    Skin.UIPanelCloseButton(_G.HelpFrameCloseButton)

    Skin.InsetFrameTemplate(HelpBrowser.leftInset)
    local LeftShadow, RightShadow, TopShadow, BottomShadow = select(2, HelpBrowser.leftInset:GetRegions())
    LeftShadow:Hide()
    RightShadow:Hide()
    TopShadow:Hide()
    BottomShadow:Hide()

    Skin.InsetFrameTemplate(HelpBrowser.mainInset)

    Skin.HelpFrameButtonTemplate(HelpBrowser.button1)
    Hook.HelpFrame_SetSelectedButton(HelpBrowser.button1)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button2)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button5)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button3)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button4)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button16)
    Skin.HelpFrameButtonTemplate(HelpBrowser.button6)

    Skin.HelpFrameButtonTemplate(HelpBrowser.asec.ticketButton)
    Skin.UIPanelButtonTemplate(_G.HelpFrameCharacterStuckStuck)
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone.IconTexture, HelpBrowser.stuck)
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone:GetPushedTexture())
    Base.CropIcon(_G.HelpFrameCharacterStuckHearthstone:GetHighlightTexture())

    Skin.GameMenuButtonTemplate(HelpBrowser.bug.submitButton)
    _G.HelpFrameReportBugScrollFrame:ClearAllPoints()
    _G.HelpFrameReportBugScrollFrame:SetPoint("BOTTOMLEFT", 154, 70)
    Skin.UIPanelScrollBarTemplate(_G.HelpFrameReportBugScrollFrame.ScrollBar)
    local bugEditBorder = select(3, HelpBrowser.bug:GetChildren())
    Base.SetBackdrop(bugEditBorder, Color.frame)
    bugEditBorder:SetBackdropBorderColor(Color.button)

    Skin.GameMenuButtonTemplate(HelpBrowser.suggestion.submitButton)
    _G.HelpFrameSubmitSuggestionScrollFrame:ClearAllPoints()
    _G.HelpFrameSubmitSuggestionScrollFrame:SetPoint("BOTTOMLEFT", 154, 130)
    Skin.UIPanelScrollBarTemplate(_G.HelpFrameSubmitSuggestionScrollFrame.ScrollBar)
    local suggestionEditBorder = select(3, HelpBrowser.suggestion:GetChildren())
    Base.SetBackdrop(suggestionEditBorder, Color.frame)
    suggestionEditBorder:SetBackdropBorderColor(Color.button)

    Skin.BrowserTemplate(_G.HelpBrowser)

    buttonDiv:SetColorTexture(1, 1, 1, 0.5)
    buttonDiv:SetSize(150, 1)
    buttonDiv:SetPoint("TOP", HelpBrowser.button5, "BOTTOM", -1, -14)

    vertDivTop:Hide()
    vertDivBottom:Hide()
    vertDivMiddle:Hide()


    ----------------------------
    -- BrowserSettingsTooltip --
    ----------------------------
    local BrowserSettingsTooltip = _G.BrowserSettingsTooltip
    Skin.TooltipBorderedFrameTemplate(BrowserSettingsTooltip)
    Skin.UIPanelButtonTemplate(BrowserSettingsTooltip.CookiesButton)


    -----------------------
    -- TicketStatusFrame --
    -----------------------
    Base.SetBackdrop(_G.TicketStatusFrameButton)


    --------------------------
    -- ReportCheatingDialog --
    --------------------------
    local ReportCheatingDialog = _G.ReportCheatingDialog
    if private.isRetail then
        Skin.DialogBorderTemplate(ReportCheatingDialog.Border)
    else
        Skin.DialogBorderTemplate(ReportCheatingDialog)
    end
    Base.CreateBackdrop(ReportCheatingDialog.CommentFrame, private.backdrop, {
        bg = _G.ReportCheatingDialogCommentFrameMiddle,

        l = _G.ReportCheatingDialogCommentFrameLeft,
        r = _G.ReportCheatingDialogCommentFrameRight,
        t = _G.ReportCheatingDialogCommentFrameTop,
        b = _G.ReportCheatingDialogCommentFrameBottom,

        tl = _G.ReportCheatingDialogCommentFrameTopLeft,
        tr = _G.ReportCheatingDialogCommentFrameTopRight,
        bl = _G.ReportCheatingDialogCommentFrameBottomLeft,
        br = _G.ReportCheatingDialogCommentFrameBottomRight,

        borderLayer = "BACKGROUND",
        borderSublevel = -7,
    })
    Base.SetBackdrop(ReportCheatingDialog.CommentFrame, Color.frame)
    ReportCheatingDialog.CommentFrame:SetBackdropBorderColor(Color.button)
    Skin.UIPanelButtonTemplate(ReportCheatingDialog.reportButton)
    Skin.UIPanelButtonTemplate(_G.ReportCheatingDialogCancelButton)
end
