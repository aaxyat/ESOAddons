BugCatcher.bugSack = true

local LOM = LibOmniMessage
local LAM = LibAddonMenu2
local SF = LibSFUtils

function BugCatcher.createBugSack()

  BugCatcher.frame   = GetWindowManager():CreateTopLevelWindow("BugCatcher_Sack")
  BugCatcher.texture = GetWindowManager():CreateControl("BugCatcher_Sack_Icon", BugCatcher.frame, CT_TEXTURE)

  BugCatcher.frame:SetDimensions(30, 30)
  BugCatcher.frame:SetMouseEnabled(true)
  BugCatcher.frame:SetHandler("OnMouseUp",    BugCatcher.clickHandler)
  BugCatcher.frame:SetHandler("OnMouseEnter", function() BugCatcher.tooltipHandler(true)  end)
  BugCatcher.frame:SetHandler("OnMouseExit",  function() BugCatcher.tooltipHandler(false) end)
  BugCatcher.frame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, 15, 15)
  BugCatcher.frame:SetAlpha(0.5)
  BugCatcher.frame:SetHidden(true)

  BugCatcher.texture:SetDimensions(30, 30)
  BugCatcher.texture:SetAnchor(LEFT, BugCatcher.frame, LEFT, 0, 0)
  BugCatcher.texture:SetTexture("/esoui/art/tooltips/icon_bag.dds")

  EVENT_MANAGER:RegisterForEvent("BugCatcher_Pushed", EVENT_ACTION_LAYER_PUSHED, BugCatcher.showSack)
  EVENT_MANAGER:RegisterForEvent("BugCatcher_Popped", EVENT_ACTION_LAYER_POPPED, BugCatcher.hideSack)

  BugCatcher.iconHandler(BugCatcher_Panel)

  CALLBACK_MANAGER:RegisterCallback("LAM-RefreshPanel", BugCatcher.iconHandler)
end

function BugCatcher.iconHandler(panel)
  if panel ~= BugCatcher_Panel then return end

  BugCatcher.frame:SetAlpha((#BugCatcherDB > 0) and 1.0 or 0.5)

  if BugCatcher.tipVisible then
    BugCatcher.tooltipHandler()
  end
end

function BugCatcher.tooltipHandler(state)
  if state == false then
    ZO_Tooltips_HideTextTooltip()

    BugCatcher.tipVisible = nil

    return
  end

  InitializeTooltip(InformationTooltip, BugCatcher.frame, TOP, 0, 5)
  InformationTooltip:AddLine(LOM:Format("<<LOM-RED>>BugCatcher<<LOM-CLEAR>>", {RED=LOM.redColor, CLEAR=LOM.clearColor}), "ZoFontTooltipTitle")

  ZO_Tooltip_AddDivider(InformationTooltip)

  InformationTooltip:AddLine(LOM:Format("<<LOM-YELLOW>><<LOM-CLICK>>:<<LOM-WHITE>> Show Bug Log",                      {YELLOW=LOM.yellowColor, CLICK="Click",                 WHITE=LOM.clearToWhite}))
  InformationTooltip:AddLine(LOM:Format("<<LOM-YELLOW>><<LOM-ALT>> + <<LOM-CLICK>>:<<LOM-WHITE>> Wipe bugs",        {YELLOW=LOM.yellowColor, ALT="Alt",      CLICK="Click", WHITE=LOM.clearToWhite}))

  ZO_Tooltip_AddDivider(InformationTooltip)

  InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>If the sack is faded out, you have no bugs.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))
  InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>If the sack isn't faded out, you have bugs.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))

  ZO_Tooltip_AddDivider(InformationTooltip)

  if #BugCatcherDB == 30 then
       InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>>The sack is full, no more bugs can be stored. Please show or wipe your bugs as soon as possible.<<LOM-CLEAR>>", {GREY=LOM.greyColor, CLEAR=LOM.clearColor}))

  else InformationTooltip:AddLine(LOM:Format("<<LOM-GREY>><<LOM-COUNT>> bug<<LOM-PLURAL>> currently stored.<<LOM-CLEAR>>", {GREY=LOM.greyColor, COUNT=(#BugCatcherDB or 0), PLURAL=(#BugCatcherDB == 1 and "" or "s"), CLEAR=LOM.clearColor})) end

  BugCatcher.tipVisible = true
end

function BugCatcher.clickHandler()
  if IsAltKeyDown() then
    BugCatcher.wipeBugs()

  else
    LAM:OpenToPanel(BugCatcher_Panel)
    LAM:OpenToPanel(BugCatcher_Panel)
  end
end

function BugCatcher.showSack()
  if not ZO_GameMenu_InGameNavigationContainer:IsHidden() then
    BugCatcher.frame:SetHidden(false)
  end
end

function BugCatcher.hideSack()
  BugCatcher.frame:SetHidden(true)
end