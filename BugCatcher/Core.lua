-- BugCatcher Object Creation

--BugCatcher = {}

local tempDB, msg = {}
local LAM = LibAddonMenu2
local LOM = LibOmniMessage
local SF = LibSFUtils

-- BugCatcher colors
local red     = SF_Color:New("ffaaaa")
local green   = SF_Color:New("aaffaa")
local blue    = SF_Color:New("aaaaff")

local yellow  = SF_Color:New("ffffaa")
local cyan    = SF_Color:New("aaffff")
local purple  = SF_Color:New("ffaaff")
local grey    = SF_Color:New("dddddd")

local white = SF_Color:New("ffffff")


-- BugCatcher Setup Functions

function BugCatcher.doSetup()
end

local function onLoad(_, addonName)
  if addonName ~= "BugCatcher" then return end

  EVENT_MANAGER:UnregisterForEvent("BugCatcher_OnLoad")

  BugCatcher.databaseHandler()

  BugCatcher.doMessage = function(textMessage, formatTable)
      LOM:Send(SF.str(blue:Colorize("Bug Catcher"),white:Colorize(textMessage)), formatTable)
    end

  msg = BugCatcher.doMessage or function() end

  BugCatcherDB.bugPage = BugCatcherDB.bugPage or 1

  BugCatcher.panelData = {
    type                    = "panel",
    name                    = BugCatcher.name,
    displayName             = BugCatcher.displayName,
	author                  = BugCatcher.author,
	version                 = BugCatcher.version,
	slashCommand            = "/bugs",
    registerForRefresh      = true
  }

  BugCatcher.optionsData = {
    {
      type                    = "header",
      name                    = BugCatcher.setName
    },

    {
      type                    = "description",
      name                    = "Bug Information",
      text                    = BugCatcher.setDescription
    },

    {
      type                    = "editbox",
      name                    = "",
      getFunc                 = BugCatcher.setEditBox,
      setFunc                 = function() end,
      isMultiline             = true,
      isExtraWide             = true,
      disabled                = function() return #BugCatcherDB == 0 end,
      width                   = "full",
      reference               = "BugCatcher_EditBox"
    },

    {
      type                    = "button",
      name                    = "< < <",
      func                    = BugCatcher.previousBug,
      disabled                = function() return BugCatcherDB.bugPage == 1 end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "> > >",
      func                    = BugCatcher.nextBug,
      disabled                = function() return BugCatcherDB.bugPage == ((#BugCatcherDB == 0) and 1 or #BugCatcherDB) and true or false end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "Dismiss Bug",
      func                    = BugCatcher.dismissBug,
      disabled                = function() return #BugCatcherDB == 0 end,
      width                   = "half"
    },

    {
      type                    = "button",
      name                    = "Wipe All Bugs",
      func                    = BugCatcher.wipeBugs,
      disabled                = function() return #BugCatcherDB == 0 end,
      width                   = "half"
    }
  }

  LAM:RegisterAddonPanel("BugCatcher_Panel",     BugCatcher.panelData)
  LAM:RegisterOptionControls("BugCatcher_Panel", BugCatcher.optionsData)

  if BugCatcher.bugSack then BugCatcher.createBugSack() end

  CALLBACK_MANAGER:RegisterCallback("LAM-RefreshPanel", BugCatcher.setEditBoxSize)

  BugCatcher.isLoaded = true
end

-- BugCatcher LibAddonMenu Functions

function BugCatcher.setName()
  local page = ((#BugCatcherDB == 0) and "<<LOM-CYAN>>No Bugs Found<<LOM-CLEAR>>" or "<<LOM-CYAN>>Bug <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-CURRENT_PAGE>><<LOM-CLEAR>><<LOM-CYAN>> of <<LOM-CLEAR>><<LOM-YELLOW>><<LOM-MAX_PAGE>>")

  return LOM:Format(page, {CYAN=LOM.cyanColor, YELLOW=LOM.yellowColor, CLEAR=LOM.clearColor, CURRENT_PAGE=BugCatcherDB.bugPage, MAX_PAGE=#BugCatcherDB})
end

local desc_template = SF.str(cyan:Colorize("Caught "), yellow:Colorize("<<LOM-COUNT>>"), 
					  cyan:Colorize(" duplicate<<LOM-PLURAL>>, last seen on "), yellow:Colorize("<<LOM-TIME>>"), 
					  cyan:Colorize("."))
local timeStamp_template = SF.str(yellow:Colorize("<<LOM-DATE>>"), cyan:Colorize(" at "), 
					  yellow.Colorize("<<LOM-TIME>><<LOM-AMPM>>"))
function BugCatcher.setDescription()
  local desc             = desc_template
  local date, time, ampm = (BugCatcherDB.time[BugCatcherDB[BugCatcherDB.bugPage]] or ""):match("(.*) (.*) (.*)")
  local timeStamp        = LOM:Format(timeStamp_template, {DATE=(date or "?"), TIME=(time or "?"), AMPM=((ampm or ""):gsub("[.]", "") or "?")})

  return LOM:Format((#BugCatcherDB > 0 and desc or cyan:Colorize("Nothing to see here.")), {COUNT=(BugCatcherDB.count[BugCatcherDB[BugCatcherDB.bugPage]] or 0), PLURAL=((BugCatcherDB.count[BugCatcherDB[BugCatcherDB.bugPage]] or 0) == 1 and "" or "s"), TIME=(timeStamp or "an unknown time")})
end

function BugCatcher.setEditBox()
  return (#BugCatcherDB == 0 and "" or BugCatcherDB[BugCatcherDB.bugPage])
end

function BugCatcher.previousBug()
  BugCatcherDB.bugPage = (BugCatcherDB.bugPage and BugCatcherDB.bugPage > 1) and BugCatcherDB.bugPage - 1 or BugCatcherDB.bugPage
end

function BugCatcher.nextBug()
  BugCatcherDB.bugPage = (BugCatcherDB.bugPage and BugCatcherDB.bugPage ~= #BugCatcherDB) and BugCatcherDB.bugPage + 1 or BugCatcherDB.bugPage
end

function BugCatcher.setEditBoxSize(panel)
  if panel ~= BugCatcher_Panel then return end

  if BugCatcher_EditBox then
    BugCatcher_EditBox:SetHeight(24 * 14)
    BugCatcher_EditBox.container:SetHeight(24 * 14)
  end
end

-- BugCatcher Core Functions

function BugCatcher.databaseHandler(wipeBugs)
  if not BugCatcherDB or wipeBugs then
    BugCatcherDB = { time = {}, count = {} }
  end
end

function BugCatcher.readyCheck()
  if BugCatcher.isLoaded then
    local bugIndex

    for bugIndex = 1, #tempDB do
      BugCatcher.errorHandler(_, tempDB[bugIndex])

      tempDB[bugIndex] = nil
    end

  else
    zo_callLater(BugCatcher.readyCheck, 500)
  end
end

function BugCatcher.errorHandler(_, errorString)
  ZO_ERROR_FRAME:HideCurrentError()

  if not BugCatcher.isLoaded then
    tempDB[#tempDB + 1] = errorString

    zo_callLater(BugCatcher.readyCheck, 500)

    return
  end

  if type(errorString or 0) ~= "string" then return end

  for errorIndex = 1, #BugCatcherDB do
    if (errorString:find("stack traceback") and (BugCatcherDB[errorIndex]:match("^.-stack traceback") == errorString:match("^.-stack traceback"))) or (BugCatcherDB[errorIndex] == errorString) then
      BugCatcherDB.count[errorString] = (BugCatcherDB.count[errorString] or 0) + 1

      BugCatcher.iconHandler(BugCatcher_Panel)

      return
    end
  end

  zo_callLater(function() msg("Caught a bug (<<LOM-COUNT>> in total).", {COUNT=(#BugCatcherDB or 0)}) end, 2000)

  BugCatcherDB[#BugCatcherDB + 1] = errorString
  BugCatcherDB.time[errorString]       = LOM:Format("<<LOM-DATE>> <<LOM-TIME>>", {DATE=(GetDateStringFromTimestamp(GetTimeStamp()) or "?"), TIME=(ZO_FormatClockTime() or "?")})

  BugCatcher.iconHandler(BugCatcher_Panel)
end

function BugCatcher.dismissBug()
  table.remove(BugCatcherDB, BugCatcherDB.bugPage)

  BugCatcherDB.bugPage = (BugCatcherDB.bugPage == 1) and 1 or (BugCatcherDB.bugPage - 1)

  BugCatcher.iconHandler(BugCatcher_Panel)
end

function BugCatcher.wipeBugs()
  if #BugCatcherDB == 0 then return end

  BugCatcher.databaseHandler(true)

  BugCatcherDB.bugPage = 1

  BugCatcher.iconHandler(BugCatcher_Panel)
end

-- BugCatcher Initialization

  EVENT_MANAGER:RegisterForEvent("BugCatcher_ErrorHandler", EVENT_LUA_ERROR,
      BugCatcher.errorHandler)
  EVENT_MANAGER:RegisterForEvent("BugCatcher_MemoryHandler", EVENT_LUA_LOW_MEMORY,
      BugCatcher.errorHandler)
	  
  EVENT_MANAGER:RegisterForEvent("BugCatcher_OnLoad", EVENT_ADD_ON_LOADED, onLoad)
