IIfA = {}

-- --------------------------------------------------------------
--	Global Variables
-- --------------------------------------------------------------

IIfA.name = "Inventory Insight"
IIfA.version = "3.65"
IIfA.author = "AssemblerManiac, manavortex, |cff9b15Sharlikran|r"
IIfA.defaultAlertSound = nil
IIfA.colorHandler = nil
IIfA.isGuildBankReady = false
IIfA.TooltipLink = nil
IIfA.CurrSceneName = "hud"
IIfA.bFilterOnSetName = false
IIfA.searchFilter = ""
IIfA.trackedHouses = {}
IIfA.houseNameToIdTbl = {}
IIfA.EMPTY_STRING = ""
IIfA.BagSlotInfo = {}    -- 8-4-18 AM - make sure the table exists in case something tries to reference it before it's created.
IIfA.ScrollSortUp = true
IIfA.ActiveFilter = 0
IIfA.ActiveSubFilter = 0
IIfA.InventoryFilter = GetString(IIFA_LOCATION_NAME_ALL)

IIfA.InventoryListFilter = GetString(IIFA_DROPDOWN_QUALITY_MENU_ANY)
IIfA.InventoryListFilterQuality = 99

IIfA.trackedBags = {
  [BAG_WORN] = true,
  [BAG_BACKPACK] = true,
  [BAG_BANK] = true,
  [BAG_SUBSCRIBER_BANK] = true,
  [BAG_GUILDBANK] = true,
  [BAG_VIRTUAL] = true,
  [BAG_HOUSE_BANK_ONE] = true,
  [BAG_HOUSE_BANK_TWO] = true,
  [BAG_HOUSE_BANK_THREE] = true,
  [BAG_HOUSE_BANK_FOUR] = true,
  [BAG_HOUSE_BANK_FIVE] = true,
  [BAG_HOUSE_BANK_SIX] = true,
  [BAG_HOUSE_BANK_SEVEN] = true,
  [BAG_HOUSE_BANK_EIGHT] = true,
  [BAG_HOUSE_BANK_NINE] = true,
  [BAG_HOUSE_BANK_TEN] = true,
}

IIfA.dropdownLocNames = {
  GetString(IIFA_LOCATION_NAME_ALL),
  GetString(IIFA_LOCATION_NAME_ALL_BANKS),
  GetString(IIFA_LOCATION_NAME_ALL_GUILDBANKS),
  GetString(IIFA_LOCATION_NAME_ALL_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_ALL_STORAGE),
  GetString(IIFA_LOCATION_NAME_EVERYTHING),
  GetString(IIFA_LOCATION_NAME_BANK_ONLY),
  GetString(IIFA_LOCATION_NAME_BANK_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_BANK_CURRENT_CHARACTER),
  GetString(IIFA_LOCATION_NAME_BANK_OTHER_CHARACTERS),
  GetString(IIFA_LOCATION_NAME_CRAFT_BAG),
  GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE),
  GetString(IIFA_LOCATION_NAME_ALL_HOUSES),
}

IIfA.dropdownLocNamesTT = {
  [GetString(IIFA_LOCATION_NAME_ALL_STORAGE)] = GetString(IIFA_LOCATION_NAME_ALL_STORAGE_TT),
  [GetString(IIFA_LOCATION_NAME_EVERYTHING)] = GetString(IIFA_LOCATION_NAME_EVERYTHING_TT),
  [GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE)] = GetString(IIFA_LOCATION_NAME_HOUSING_STORAGE_TT),
}

IIfA.loggerName = 'InventoryInsight'
if LibDebugLogger then
  IIfA.logger = LibDebugLogger.Create(IIfA.loggerName)
end

local logger
local viewer
if DebugLogViewer then viewer = true else viewer = false end
if LibDebugLogger then logger = true else logger = false end

local function create_log(log_type, log_content)
  if not viewer and log_type == "Info" then
    CHAT_ROUTER:AddSystemMessage(log_content)
    return
  end
  if logger and log_type == "Debug" then
    IIfA.logger:Debug(log_content)
  end
  if logger and log_type == "Info" then
    IIfA.logger:Info(log_content)
  end
  if logger and log_type == "Verbose" then
    IIfA.logger:Verbose(log_content)
  end
  if logger and log_type == "Warn" then
    IIfA.logger:Warn(log_content)
  end
end

local function emit_message(log_type, text)
  if (text == "") then
    text = "[Empty String]"
  end
  create_log(log_type, text)
end

local function emit_table(log_type, t, indent, table_history)
  indent = indent or "."
  table_history = table_history or {}

  for k, v in pairs(t) do
    local vType = type(v)

    emit_message(log_type, indent .. "(" .. vType .. "): " .. tostring(k) .. " = " .. tostring(v))

    if (vType == "table") then
      if (table_history[v]) then
        emit_message(log_type, indent .. "Avoiding cycle on table...")
      else
        table_history[v] = true
        emit_table(log_type, v, indent .. "  ", table_history)
      end
    end
  end
end

function IIfA:dm(log_type, ...)
  for i = 1, select("#", ...) do
    local value = select(i, ...)
    if (type(value) == "table") then
      emit_table(log_type, value)
    else
      emit_message(log_type, tostring(value))
    end
  end
end
