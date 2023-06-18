--this creates a menu for the addon.
--IIfA = IIfA		-- necessary for initial load of the lua script, so it know

local LAM = LibAddonMenu2

local id, guildName, deleteHouse, restoreHouse, name

IIfA.fontFaces = {}
IIfA.fontFaces["ProseAntique"] = "EsoUI/Common/Fonts/ProseAntiquePSMT.otf"
IIfA.fontFaces["Consolas"] = "EsoUI/Common/Fonts/consola.ttf"
IIfA.fontFaces["Futura Condensed"] = "EsoUI/Common/Fonts/FTN57.otf"
IIfA.fontFaces["Futura Condensed Bold"] = "EsoUI/Common/Fonts/FTN87.otf"
IIfA.fontFaces["Futura Condensed Light"] = "EsoUI/Common/Fonts/FTN47.otf"
IIfA.fontFaces["Futura STD Condensed"] = "EsoUI/Common/Fonts/FuturaSTD-Condensed.otf"
IIfA.fontFaces["Futura STD Condensed Bold"] = "EsoUI/Common/Fonts/FuturaSTD-CondensedBold.otf"
IIfA.fontFaces["Futura STD Condensed Light"] = "EsoUI/Common/Fonts/FuturaSTD-CondensedLight.otf"
IIfA.fontFaces["Skyrim Handwritten"] = "EsoUI/Common/Fonts/Handwritten_Bold.otf"
IIfA.fontFaces["Trajan Pro"] = "EsoUI/Common/Fonts/trajanpro-regular.otf"
IIfA.fontFaces["Univers 55"] = "EsoUI/Common/Fonts/univers55.otf"
--IIfA.fontFaces["Univers LT Std 55"]	= "EsoUI/Common/Fonts/univers55.otf"
IIfA.fontFaces["Univers 57"] = "EsoUI/Common/Fonts/univers57.otf"
--IIfA.fontFaces["Univers LT Std 57 Cn"]	= "EsoUI/Common/Fonts/univers57.otf"
IIfA.fontFaces["Univers 67"] = "EsoUI/Common/Fonts/univers67.otf"
--IIfA.fontFaces["Univers LT Std 57 Cn Lt"]	= "EsoUI/Common/Fonts/univers67.otf"

local effectList = {
  GetString(IIFA_FONT_EFFECT_NONE),
  GetString(IIFA_FONT_EFFECT_OUTLINE),
  GetString(IIFA_FONT_EFFECT_THINOUTLINE),
  GetString(IIFA_FONT_EFFECT_THICKOUTLINE),
  GetString(IIFA_FONT_EFFECT_SHADOW),
  GetString(IIFA_FONT_EFFECT_SOFTSHADOWTHIN),
  GetString(IIFA_FONT_EFFECT_SOFTSHADOWTHICK),
}
-- do not translate these as they are used to add an effect to the font
local effectValues = { "none", "outline", "thin-outline", "thick-outline", "shadow", "soft-shadow-thin", "soft-shadow-thick" }

IIfA.fontRef = {}
local faceList = {}
local faceValues = {}

local function buildFontRef()
  local varName, Data

  for varName, Data in pairs(IIfA:GetFontList()) do
    if Data ~= 'Tooltip Default' and Data ~= "Custom" then
      local gData = _G[Data]
      if gData and gData.GetFontInfo then
        local fName, fSize, fEffect = gData:GetFontInfo()
        if fEffect == nil or fEffect == "" then
          fEffect = "none"
        end
        IIfA.fontRef[fName:lower() .. "|" .. fSize .. "|" .. fEffect:lower()] = Data
      end
    end
  end

  local idx
  local data
  for idx, data in pairs(IIfA.fontFaces) do
    faceList[#faceList + 1] = idx
    faceValues[#faceValues + 1] = data:lower()
  end
end

local function getGuildBanks()
  local guildBanks = {}
  local guildName, guildData
  if IIfA.guildBanks then
    for guildName, guildData in pairs(IIfA.guildBanks) do
      if guildData.bCollectData == nil then
        guildData.bCollectData = true
      end
      table.insert(guildBanks, guildName)
    end
  end
  return guildBanks
end

--[[checkboxData = {
	type = "checkbox",
	name = "My Checkbox", -- or string id or function returning a string
	getFunc = function() return db.var end,
	setFunc = function(value) db.var = value doStuff() end,
	tooltip = "Checkbox's tooltip text.", -- or string id or function returning a string (optional)
	width = "full", -- or "half" (optional)
	disabled = function() return db.someBooleanSetting end,	--or boolean (optional)
	warning = "Will need to reload the UI.", -- or string id or function returning a string (optional)
	default = defaults.var,	-- a boolean or function that returns a boolean (optional)
	reference = "MyAddonCheckbox", -- unique global reference to control (optional)
}	]]

local function getGuildBankName(guildNum)
  if guildNum > GetNumGuilds() then return end
  id = GetGuildId(guildNum)
  return GetGuildName(id)
end

local function getGuildBankKeepDataSetting(guildNum)
  guildName = getGuildBankName(guildNum)

  if IIfA.guildBanks[guildName] == nil then return false end

  if IIfA.guildBanks[guildName].bCollectData == nil then
    IIfA.guildBanks[guildName].bCollectData = true
  end

  return IIfA.guildBanks[guildName].bCollectData
end

local function setGuildBankKeepDataSetting(guildNum, newSetting)
  guildName = getGuildBankName(guildNum)
  if guildName ~= nil then
    IIfA.guildBanks[guildName].bCollectData = newSetting
  end
end

function IIfA:CreateOptionsMenu()
  local deleteChar, deleteGBank

  buildFontRef()

  local optionsData = {
    { type = "header",
      name = GetString(IIFA_GLOBAL_SETTINGS_HEADER),
    },
    {
      type = "checkbox",
      name = GetString(IIFA_ACCOUNT_WIDE_NAME),
      tooltip = GetString(IIFA_ACCOUNT_WIDE_TT),
      getFunc = function() return IIfA.data.saveSettingsGlobally end,
      setFunc = function(value)
        IIfA.data.saveSettingsGlobally = value
      end
    },
    {
      type = "checkbox",
      name = GetString(IIFA_DEBUGGING_NAME),
      tooltip = GetString(IIFA_DEBUGGING_TT),
      getFunc = function() return IIfA.data.bDebug end,
      setFunc = function(value) IIfA.data.bDebug = value end,
    },

    {
      type = "submenu",
      name = GetString(IIFA_MANAGE_DATA),
      tooltip = GetString(IIFA_MANAGE_DATA_TT), --(optional)
      controls = {
        {  -- button begin
          type = "button",
          name = GetString(IIFA_DATA_WIPE_DATABASE),
          tooltip = GetString(IIFA_DATA_WIPE_DATABASE_TT),
          func = function()
            IIfA.database = {}
            IIfA:ScanCurrentCharacterAndBank()
            IIfA:RefreshInventoryScroll()
          end,
        }, -- button end

        { type = "description",
          title = GetString(IIFA_DATA_WIPE_DATABASE_DESC),
          text = GetString(IIFA_DATA_WIPE_DATABASE_WARN),
        },
        {
          type = "dropdown",
          name = GetString(IIFA_DELETE_UNTRACK_CHAR),
          choices = IIfA:GetCharacterList(),
          getFunc = function() return end,
          setFunc = function(choice)
            deleteChar = nil;
            deleteChar = choice
          end,
        }, --dropdown end

        {  -- button begin
          type = "button",
          name = GetString(IIFA_DATA_DELETE_CHARACTER),
          tooltip = GetString(IIFA_DATA_DELETE_CHARACTER_TT),
          func = function() IIfA:DeleteCharacterData(deleteChar) end,
        }, -- button end

        {
          type = "divider",
        },

        {
          type = "checkbox",
          name = GetString(IIFA_DATA_IGNORE_BACKPACK),
          tooltip = GetString(IIFA_DATA_IGNORE_BACKPACK_TT),
          getFunc = function() return IIfA:IsCharacterInventoryIgnored() end,
          setFunc = function(...) IIfA:IgnoreCharacterInventory(...) end,
        }, -- checkbox end

        {
          type = "checkbox",
          name = GetString(IIFA_DATA_IGNORE_EQUIPMENT),
          tooltip = GetString(IIFA_DATA_IGNORE_EQUIPMENT_TT),
          getFunc = function() return IIfA:IsCharacterEquipIgnored() end,
          setFunc = function(...) IIfA:IgnoreCharacterEquip(...) end,
        }, -- checkbox end


        {
          type = "divider",
        },


        { type = "description",
          title = GetString(IIFA_DATA_GUILDBANK_DELETE_DESC),
          text = GetString(IIFA_DATA_GUILDBANK_DELETE_WARN),
        },
        {  -- dropdown begin
          type = "dropdown",
          name = GetString(IIFA_DATA_GUILDBANK_TO_DELETE),
          choices = getGuildBanks(),
          getFunc = function() return end,
          setFunc = function(choice)
            deleteGBank = nil;
            deleteGBank = choice
          end,

        }, -- dropdown end

        {  -- button begin
          type = "button",
          name = GetString(IIFA_DATA_GUILDBANK_DELETE),
          tooltip = GetString(IIFA_DATA_GUILDBANK_DELETE_TT),
          func = function() IIfA:DeleteGuildData(deleteGBank) end,
        }, -- button end


      }, -- Collected Guild Bank Data controls end

    }, -- Collected Guild Bank Data submenu end

    {
      type = "submenu",
      name = GetString(IIFA_DATA_GUILDBANK_OPTIONS),
      tooltip = GetString(IIFA_DATA_GUILDBANK_OPTIONS_TT),
      controls = {}
    },

    {
      type = "submenu",
      name = GetString(IIFA_HOUSES_HEADER),
      controls = {

        {
          type = "checkbox",
          name = GetString(IIFA_DATA_COLLECT_OPTIONS),
          tooltip = GetString(IIFA_DATA_COLLECT_OPTIONS_TT),
          getFunc = function() return IIfA.data.b_collectHouses end,
          setFunc = function(value) IIfA:SetHouseTracking(value) end,
        }, -- checkbox end

        { type = "description",
          title = GetString(IIFA_DATA_IGNORE_HOUSES_DESC),
          text = GetString(IIFA_DATA_IGNORE_HOUSES_WARN),
        },
        {    --dropdown houses to delete or un-track
          type = "dropdown",
          name = GetString(IIFA_DATA_HOUSES_TO_DELETE),
          choices = IIfA:GetTrackedHouseNames(),
          getFunc = function() return end,
          setFunc = function(choice)
            deleteHouse = nil;
            deleteHouse = choice
          end,
        }, --dropdown end
        {  -- button begin
          type = "button",
          width = "half",
          name = GetString(IIFA_DATA_HOUSES_DELETE),
          tooltip = GetString(IIFA_DATA_HOUSES_DELETE_TT),
          func = function() IIfA:SetTrackingForHouse(deleteHouse, false) end,
        }, -- button end
        {
          type = "dropdown",
          name = GetString(IIFA_DATA_HOUSES_TO_RETRACK),
          choices = IIfA:GetIgnoredHouseNames(),
          getFunc = function() return end,
          setFunc = function(choice)
            restoreHouse = nil;
            restoreHouse = choice
          end,
        }, --dropdown end
        {  -- button begin
          type = "button",
          name = GetString(IIFA_DATA_HOUSES_UNIGNORE_DESC),
          tooltip = GetString(IIFA_DATA_HOUSES_UNIGNORE_WARN),
          width = "half",
          func = function() IIfA:SetTrackingForHouse(restoreHouse, true) end,
        }, -- button end
      },
    },

    {
      type = "submenu",
      name = GetString(IIFA_HIGHLIT_PACK_SIZE_DESC),
      tooltip = GetString(IIFA_HIGHLIT_PACK_SIZE_TT), --(optional)
      controls = {
        {
          type = "slider",
          name = GetString(IIFA_USED_SPACE_THRESHOLD),
          tooltip = GetString(IIFA_USED_SPACE_THRESHOLD_TT),
          getFunc = function() return IIfA.data.BagSpaceWarn.threshold end,
          setFunc = function(choice) IIfA.data.BagSpaceWarn.threshold = choice end,
          min = 1,
          max = 100,
          step = 1, --(optional)
          clampInput = true, -- boolean, if set to false the input won't clamp to min and max and allow any number instead (optional)
          decimals = 0, -- when specified the input value is rounded to the specified number of decimals (optional)
          default = 85, -- default value or function that returns the default value (optional)
        }, -- slider end

        {
          type = "colorpicker",
          name = GetString(IIFA_USED_SPACE_COLOR),
          tooltip = GetString(IIFA_USED_SPACE_COLOR_TT),
          getFunc = function() return IIfA.data.BagSpaceWarn.r, IIfA.data.BagSpaceWarn.g, IIfA.data.BagSpaceWarn.b end,
          setFunc = function(r, g, b, a)
            IIfA.data.BagSpaceWarn.r = r
            IIfA.data.BagSpaceWarn.g = g
            IIfA.data.BagSpaceWarn.b = b
            IIfA.CharBagFrame.ColorWarn = IIfA.CharBagFrame:rgb2hex(IIfA.data.BagSpaceWarn)
            IIfA.CharBagFrame:RepaintSpaceUsed()
          end, --(alpha is optional)
          default = { r = 230 / 255, g = 130 / 255, b = 0 },
        }, -- colorpicker end

        {
          type = "slider",
          name = GetString(IIFA_ALERT_SPACE_THRESHOLD),
          tooltip = GetString(IIFA_ALERT_SPACE_THRESHOLD_TT),
          getFunc = function() return IIfA.data.BagSpaceAlert.threshold end,
          setFunc = function(choice) IIfA.data.BagSpaceAlert.threshold = choice end,
          min = 1,
          max = 100,
          step = 1, --(optional)
          clampInput = true, -- boolean, if set to false the input won't clamp to min and max and allow any number instead (optional)
          decimals = 0, -- when specified the input value is rounded to the specified number of decimals (optional)
          default = 95, -- default value or function that returns the default value (optional)
        }, -- slider end

        {
          type = "colorpicker",
          name = GetString(IIFA_ALERT_SPACE_COLOR),
          tooltip = GetString(IIFA_ALERT_SPACE_COLOR_TT),
          getFunc = function() return IIfA.data.BagSpaceAlert.r, IIfA.data.BagSpaceAlert.g, IIfA.data.BagSpaceAlert.b end,
          setFunc = function(r, g, b, a)
            IIfA.data.BagSpaceAlert.r = r
            IIfA.data.BagSpaceAlert.g = g
            IIfA.data.BagSpaceAlert.b = b
            IIfA.CharBagFrame.ColorAlert = IIfA.CharBagFrame:rgb2hex(IIfA.data.BagSpaceAlert)
            IIfA.CharBagFrame:RepaintSpaceUsed()
          end, --(alpha is optional)
          default = { r = 1, g = 1, b = 0 },
        }, -- colorpicker end

        {
          type = "colorpicker",
          name = GetString(IIFA_USED_SPACE_FULL_COLOR),
          tooltip = GetString(IIFA_USED_SPACE_FULL_COLOR_TT),
          getFunc = function() return IIfA.data.BagSpaceFull.r, IIfA.data.BagSpaceFull.g, IIfA.data.BagSpaceFull.b end,
          setFunc = function(r, g, b, a)
            IIfA.data.BagSpaceFull.r = r
            IIfA.data.BagSpaceFull.g = g
            IIfA.data.BagSpaceFull.b = b
            IIfA.CharBagFrame.ColorFull = IIfA.CharBagFrame:rgb2hex(IIfA.data.BagSpaceFull)
            IIfA.CharBagFrame:RepaintSpaceUsed()
          end, --(alpha is optional)
          --				width = "full", --or "half" (optional)
          default = { r = 255, g = 0, b = 0 },
        }, -- colorpicker end

      },
    },

    {  -- header: Global/Per Char settings
      type = "header",
      name = GetString(IIFA_ACCOUNT_WIDE_SETTINGS),
    },


    {  -- submenu: tooltips
      type = "submenu",
      name = GetString(IIFA_MANAGE_TOOLTIPS),
      tooltip = GetString(IIFA_MANAGE_TOOLTIPS_TT),
      controls = { -- tooltips
        {
          type = "dropdown",
          name = GetString(IIFA_MANAGE_TOOLTIP_SHOW),
          tooltip = GetString(IIFA_MANAGE_TOOLTIP_SHOW_TT),
          choices = { GetString(IIFA_MANAGE_TOOLTIP_SHOW_ALWAYS), GetString(IIFA_MANAGE_TOOLTIP_SHOW_IIFA), GetString(IIFA_MANAGE_TOOLTIP_SHOW_NEVER) },
          getFunc = function() return IIfA:GetSettings().showToolTipWhen end,
          setFunc = function(value) IIfA:GetSettings().showToolTipWhen = value end,
        }, -- checkbox end

        {
          type = "checkbox",
          name = GetString(IIFA_SHOW_SEPARATE_FRAME),
          tooltip = GetString(IIFA_SHOW_SEPARATE_FRAME_TT),
          getFunc = function() return IIfA:GetSettings().bInSeparateFrame end,
          setFunc = function(value) IIfA:GetSettings().bInSeparateFrame = value end,
        }, -- checkbox end

        {
          type = "checkbox",
          name = GetString(IIFA_SHOW_STYLE_INFO),
          tooltip = GetString(IIFA_SHOW_STYLE_INFO_TT),
          getFunc = function() return IIfA:GetSettings().showStyleInfo end,
          setFunc = function(value) IIfA:GetSettings().showStyleInfo = value end,
        }, -- checkbox end

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_CHARACTERS),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_CHARACTERS_TT),
          getFunc = function() return IIfA.colorHandlerToon:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerToon:SetRGBA(...)
            IIfA:GetSettings().TextColorsToon = IIfA.colorHandlerToon:ToHex()
          end
        },

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_BANKS),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_BANKS_TT),
          getFunc = function() return IIfA.colorHandlerBank:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerBank:SetRGBA(...)
            IIfA:GetSettings().TextColorsBank = IIfA.colorHandlerBank:ToHex()
          end
        },

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_GUILDBANKS),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_GUILDBANKS_TT),
          getFunc = function() return IIfA.colorHandlerGBank:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerGBank:SetRGBA(...)
            IIfA:GetSettings().TextColorsGBank = IIfA.colorHandlerGBank:ToHex()
          end
        },

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_HOUSECHESTS),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_HOUSECHESTS_TT),
          getFunc = function() return IIfA.colorHandlerHouseChest:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerHouseChest:SetRGBA(...)
            IIfA:GetSettings().TextColorsHouseChest = IIfA.colorHandlerHouseChest:ToHex()
          end
        },

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_HOUSE_CONTENTS),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_HOUSE_CONTENTS_TT),
          getFunc = function() return IIfA.colorHandlerHouse:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerHouse:SetRGBA(...)
            IIfA:GetSettings().TextColorsHouse = IIfA.colorHandlerHouse:ToHex()
          end
        },

        {
          type = "colorpicker",
          name = GetString(IIFA_TOOLTIP_COLOR_CRAFT_BAG),
          tooltip = GetString(IIFA_TOOLTIP_COLOR_CRAFT_BAG_TT),
          getFunc = function() return IIfA.colorHandlerCraftBag:UnpackRGBA() end,
          setFunc = function(...)
            IIfA.colorHandlerCraftBag:SetRGBA(...)
            IIfA:GetSettings().TextColorsCraftBag = IIfA.colorHandlerCraftBag:ToHex()
          end
        },

        {
          type = "dropdown",
          name = GetString(IIFA_TOOLTIP_FONT_CUSTOM),
          tooltip = GetString(IIFA_TOOLTIP_FONT_CUSTOM_TT),
          choices = IIfA:GetFontList(),
          scrollable = true,
          --sort = "name-up",
          getFunc = function() return (IIfA:GetSettings().in2TooltipsFont or IIfA.defaults.in2TooltipsFont) end,
          setFunc = function(choice)
            IIfA:StatusAlert("[IIfA]:TooltipsFontChanged[" .. choice .. "]")
            IIfA:SetTooltipFont(choice)
          end
        },
        {
          type = "dropdown",
          name = GetString(IIFA_TOOLTIP_FONT_SELECTED),
          tooltip = GetString(IIFA_TOOLTIP_FONT_SELECTED_TT),
          choices = faceList,
          choicesValues = faceValues,
          scrollable = true,
          reference = "IIfA_FontFace",
          sort = "name-up",
          getFunc = function() return (IIfA:GetSettings().TooltipFontFace or IIfA.defaults.TooltipFontFace) end,
          setFunc = function(choice)
            IIfA:StatusAlert("[IIfA]:TooltipFontFaceChanged[" .. choice .. "]")
            IIfA:SetTooltipFont(nil, choice, nil, nil)
          end
        },
        {
          type = "slider",
          name = GetString(IIFA_TOOLTIP_FONT_SIZE),
          tooltip = GetString(IIFA_TOOLTIP_FONT_SIZE_TT),
          min = 5,
          max = 40,
          step = 1,
          reference = "IIfA_FontSize",
          getFunc = function() return IIfA:GetSettings().TooltipFontSize or IIfA.defaults.TooltipFontSize end,
          setFunc = function(value)
            IIfA:StatusAlert("[IIfA]:TooltipFontSizeChanged[" .. value .. "]")
            IIfA:SetTooltipFont(nil, nil, value, nil)
          end,
        },
        {
          type = "dropdown",
          name = GetString(IIFA_TOOLTIP_FONT_EFFECT),
          tooltip = GetString(IIFA_TOOLTIP_FONT_EFFECT_TT),
          choices = effectList,
          choicesValues = effectValues,
          scrollable = true,
          reference = "IIfA_FontEffect",
          getFunc = function() return (IIfA:GetSettings().TooltipFontEffect or IIfA.defaults.TooltipFontEffect) end,
          setFunc = function(choice)
            IIfA:StatusAlert("[IIfA]:TooltipFontEffectChanged[" .. choice .. "]")
            IIfA:SetTooltipFont(nil, nil, nil, choice)
          end
        },

      }, -- controls end

    }, -- tooltipOptionsSubWindow end

    {  -- checkbox: item count on the right
      type = "checkbox",
      name = GetString(IIFA_SHOW_ITEM_COUNT_RIGHT),
      tooltip = GetString(IIFA_SHOW_ITEM_COUNT_RIGHT_TT),
      getFunc = function() return IIfA:GetSettings().showItemCountOnRight end,
      setFunc = function(value)
        IIfA:StatusAlert("[IIfA]:ItemCountOnRight[" .. tostring(value) .. "]")
        IIfA:GetSettings().showItemCountOnRight = value
        IIfA:SetItemCountPosition()
      end,
    },

    {  -- checkbox: show item count/slot count stats
      type = "checkbox",
      name = GetString(IIFA_SHOW_STATS_BELOW_LIST),
      tooltip = GetString(IIFA_SHOW_STATS_BELOW_LIST_TT),
      getFunc = function() return IIfA:GetSettings().showItemStats end,
      setFunc = function(value)
        IIfA:StatusAlert("[IIfA]:ItemStats[" .. tostring(value) .. "]")
        IIfA:GetSettings().showItemStats = value
        IIFA_GUI_ListHolder_Counts:SetHidden(not value)
      end,
    },

    {
      type = "dropdown",
      name = GetString(IIFA_DEFAULT_INVENTORY_FRAME_VIEW),
      tooltip = GetString(IIFA_DEFAULT_INVENTORY_FRAME_VIEW_TT),
      choices = IIfA.dropdownLocNames,
      default = IIfA:GetSettings().in2DefaultInventoryFrameView,
      scrollable = true,
      getFunc = function() return IIfA:GetSettings().in2DefaultInventoryFrameView end,
      setFunc = function(value)
        IIfA:StatusAlert("[IIfA]:DefaultInventoryFrameView[" .. value .. "]")
        IIfA:GetSettings().in2DefaultInventoryFrameView = value
        ZO_ComboBox_ObjectFromContainer(IIFA_GUI_Header_Dropdown_Main):SetSelectedItem(value)
        IIfA:SetInventoryListFilter(value)
        return
      end
      -- warning = "Will need to reload the UI",	--(optional)
    },

    { -- checkbox: Focus search box on UI toggle
      type = "checkbox",
      name = GetString(IIFA_FOCUS_STATS_SEARCHBOX),
      tooltip = GetString(IIFA_FOCUS_STATS_SEARCHBOX_TT),
      getFunc = function() return not IIfA:GetSettings().dontFocusSearch end,
      setFunc = function(value) IIfA:GetSettings().dontFocusSearch = not value end,
    }, -- checkbox end

    {
      type = "checkbox",
      name = GetString(IIFA_FILTER_INCLUDE_SETNAME),
      tooltip = GetString(IIFA_FILTER_INCLUDE_SETNAME_TT),
      getFunc = function() return IIfA:GetSettings().bFilterOnSetNameToo end,
      setFunc = function(value) IIfA:GetSettings().bFilterOnSetNameToo = value end,
    }, -- checkbox end

    {
      type = "checkbox",
      name = GetString(IIFA_FILTER_SETNAME_ONLY),
      tooltip = GetString(IIFA_FILTER_SETNAME_ONLY_TT),
      getFunc = function() return IIfA:GetSettings().bFilterOnSetName end,
      setFunc = function(value)
        IIfA:GetSettings().bFilterOnSetName = value
        IIfA.bFilterOnSetName = value
      end,
    }, -- checkbox end

    {
      type = "checkbox",
      name = GetString(IIFA_ENABLE_SEARCH_IIFA_MENU),
      tooltip = GetString(IIFA_ENABLE_SEARCH_IIFA_MENU_TT),
      getFunc = function() return IIfA:GetSettings().bAddContextMenuEntrySearchInIIfA end,
      setFunc = function(value)
        IIfA:GetSettings().bAddContextMenuEntrySearchInIIfA = value
        IIfA.bAddContextMenuEntrySearchInIIfA = value
      end,
      disabled = function() return LibCustomMenu == nil or false end,
      requiresReload = true,
    }, -- checkbox end

    {  -- checkbox: show close button
      type = "checkbox",
      name = GetString(IIFA_HIDE_CLOSE_BUTTON),
      tooltip = GetString(IIFA_HIDE_CLOSE_BUTTON_TT),
      getFunc = function() return IIfA:GetSettings().hideCloseButton or false end,
      setFunc = function(value)
        IIfA:StatusAlert("[IIfA]:hideCloseButton[" .. tostring(value) .. "]")
        IIfA:GetSettings().hideCloseButton = value
        IIFA_GUI_Header_Hide:SetHidden(value)
      end,
    },

    {
      type = "header",
      name = GetString(IIFA_SCENE_TOGGLES),
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_INVENTORY),
      tooltip = GetString(IIFA_SCENE_TOGGLE_INVENTORY_TT),
      getFunc = function() return IIfA:GetSceneVisible("inventory") end,
      setFunc = function(value) IIfA:SetSceneVisible("inventory", value) end,

    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_BANK),
      tooltip = GetString(IIFA_SCENE_TOGGLE_BANK_TT),
      getFunc = function() return IIfA:GetSceneVisible("bank") end,
      setFunc = function(value) IIfA:SetSceneVisible("bank", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_GUILDBANK),
      tooltip = GetString(IIFA_SCENE_TOGGLE_GUILDBANK_TT),
      getFunc = function() return IIfA:GetSceneVisible("guildBank") end,
      setFunc = function(value) IIfA:SetSceneVisible("guildBank", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_GUILDSTORE),
      tooltip = GetString(IIFA_SCENE_TOGGLE_GUILDSTORE_TT),
      getFunc = function() return IIfA:GetSceneVisible("tradinghouse") end,
      setFunc = function(value) IIfA:SetSceneVisible("tradinghouse", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_CRAFTING),
      tooltip = GetString(IIFA_SCENE_TOGGLE_CRAFTING_TT),
      getFunc = function() return IIfA:GetSceneVisible("smithing") end,
      setFunc = function(value) IIfA:SetSceneVisible("smithing", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_ALCHEMY),
      tooltip = GetString(IIFA_SCENE_TOGGLE_ALCHEMY_TT),
      getFunc = function() return IIfA:GetSceneVisible("alchemy") end,
      setFunc = function(value) IIfA:SetSceneVisible("alchemy", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_VENDOR),
      tooltip = GetString(IIFA_SCENE_TOGGLE_VENDOR_TT),
      getFunc = function() return IIfA:GetSceneVisible("store") end,
      setFunc = function(value) IIfA:SetSceneVisible("store", value) end,
    },

    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_STABLES),
      tooltip = GetString(IIFA_SCENE_TOGGLE_STABLES_TT),
      getFunc = function() return IIfA:GetSceneVisible("stables") end,
      setFunc = function(value) IIfA:SetSceneVisible("stables", value) end,
    },


    {
      type = "checkbox",
      name = GetString(IIFA_SCENE_TOGGLE_TRADING),
      tooltip = GetString(IIFA_SCENE_TOGGLE_TRADING_TT),
      getFunc = function() return IIfA:GetSceneVisible("trade") end,
      setFunc = function(value) IIfA:SetSceneVisible("trade", value) end,
    },

    -- options data end
  }

  if FCOIS then
    optionsData[#optionsData + 1] = --Other addons
    {
      type = "header",
      name = GetString(IIFA_OTHER_ADDONS_HEADER),
    }
    optionsData[#optionsData + 1] = --FCOItemSaver
    {
      type = "submenu",
      name = GetString(IIFA_FCOITEMSAVER_MENU_MANAGE_SETTINGS),
      tooltip = GetString(IIFA_FCOITEMSAVER_MENU_MANAGE_SETTINGS_TT),
      controls = {
        {
          type = "checkbox",
          name = GetString(IIFA_FCOITEMSAVER_MENU_SHOW_MARKERS),
          tooltip = GetString(IIFA_FCOITEMSAVER_MENU_SHOW_MARKERS_TT),
          getFunc = function() return IIfA:GetSettings().FCOISshowMarkerIcons end,
          setFunc = function(value) IIfA:GetSettings().FCOISshowMarkerIcons = value end,
        },
      },
    }
  end


  -- run through list of options, find one with empty controls, add in the submenu for guild banks options
  local i, data
  for i, data in ipairs(optionsData) do
    if data.controls ~= nil then
      if #data.controls == 0 then
        data.controls[1] = {
          type = "checkbox",
          name = GetString(IIFA_DATA_GUILDBANK_COLLECT_DATA),
          tooltip = GetString(IIFA_DATA_GUILDBANK_COLLECT_DATA_TT),
          warning = GetString(IIFA_DATA_GUILDBANK_COLLECT_DATA_WARN),
          getFunc = function() return IIfA.data.bCollectGuildBankData end,
          setFunc = function(value)
            IIfA.data.bCollectGuildBankData = value
            IIfA.trackedBags[BAG_GUILDBANK] = value
          end,
        }
        for i = 1, GetNumGuilds() do
          local id = GetGuildId(i)
          local guildName = GetGuildName(id)
          data.controls[i + 1] = {
            type = "checkbox",
            name = string.format(GetString(IIFA_DATA_COLLECT_DATA_FOR), guildName),
            tooltip = GetString(IIFA_DATA_COLLECT_GUILDBANKS_DATA_TT),
            warning = GetString(IIFA_DATA_COLLECT_GUILDBANKS_DATA_WARN),
            getFunc = function() return getGuildBankKeepDataSetting(i) end,
            setFunc = function(value) setGuildBankKeepDataSetting(i, value) end,
            disabled = function() return (not IIfA.data.bCollectGuildBankData) end,
          }
        end
      end
    end
  end

  LAM:RegisterOptionControls("IIfA_OptionsPanel", optionsData)

end

function IIfA:CreateSettingsWindow(savedVars, defaults)

  local panelData = {
    type = "panel",
    name = IIfA.name,
    displayName = name,
    author = IIfA.author,
    version = IIfA.version,
    slashCommand = "/iifa", --(optional) will register a keybind to open to this panel
    registerForRefresh = true, --boolean (optional) (will refresh all options controls when a setting is changed and when the panel is shown)
    registerForDefaults = true  --boolean (optional) (will set all options controls back to default values)
  }

  LAM:RegisterAddonPanel("IIfA_OptionsPanel", panelData)

  self:CreateOptionsMenu()

end

function IIfA:GetFontList()
  local apiVer = GetAPIVersion()
  if self.data.fontList == nil or IIfA.data.fontList[apiVer] == nil then
    self.data.fontList = {}
    self.data.fontList[apiVer] = {}

    local fonts = {}
    local varname, value
    for varname, value in zo_insecurePairs(_G) do
      if (type(value) == "userdata" and value.GetFontInfo) then
        fonts[#fonts + 1] = varname
      end
    end
    table.sort(fonts)
    local newList = { "Tooltip Default", "Custom" }
    for varname, value in pairs(fonts) do
      newList[#newList + 1] = value
    end
    self.data.fontList[apiVer] = newList
  end

  return self.data.fontList[apiVer]
end


--get LAM DDLB control, then use this to update contents
-- control:UpdateChoices(dropdownData.choices, dropdownData.choicesValues)

