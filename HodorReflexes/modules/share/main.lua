HodorReflexes.modules.share = {
	name = "HodorReflexes_Share",
	version = "1.0.0",

	uiLocked = true,

	default = {
		damageRowColor = {0, 1, 0, 0.36},

		accountWide = false,
		enabled = true,
		disablePvP = true,
		enableUltimateShare = 0,
		enableMiscUltimateShare = false,
		enableDamageShare = false,
		enableColosShare = false,
		enableAtronachShare = false,
		enableUltimateList = false,
		enableMiscUltimateList = false,
		enableAtronachList = false,
		enableDamageList = 0,
		enableColosList = false,
		enableHornIcon = true,
		hornCountdownType = 'horn_self',
		hornCountdownColor = {1, 0.5, 0, 1},
		hornIconScale = 1,
		enableUltimateIcons = true,
		enableMiscUltimateIcons = true,
		enableAtronachIcons = true,
		enableDamageIcons = true,
		enableColosIcons = true,
		enableAnimIcons = true,
		enableColoredNames = true,
		enableAnimations = true, -- animated messages
		colosPriority = 'default',
		colosSupportRange = true,
		enableColosCountdown = true,
		colosCountdownBossOnly = true,
		colosCountdownColor = {1, 0, 1, 1},
		colosCountdownText = GetString(HR_COLOS_COUNTDOWN_DEFAULT_TEXT),
		selfishMode = false,
		-- raw and percent visibility
		showHornPercentValue = 1,
		showHornRawValue = 1,
		showColosPercentValue = 1,
		showColosRawValue = 1,
		showAtronachPercentValue = 1,
		showAtronachRawValue = 1,
		-- my icon and name
		myIconPathFull = '',
		myIconNameRaw = '',
		myIconNameFormatted = '',
		myIconColor1 = {1, 1, 1},
		myIconColor2 = {1, 1, 1},
		myIconGradient = false,
		-- style
		enableMapPins = false,
		styleDamageHeaderOpacity = 0.8,
		styleDamageRowEvenOpacity = 0.65,
		styleDamageRowOddOpacity = 0.45,
		styleDamageNumFont = 'gamepad',
		styleBossDamageColor = 'b2ffb2',
		styleTotalDamageColor = 'faffb2',
		styleHornColor =  {0, 1, 1},
		styleForceColor = {1, 1, 0},
		styleColosColor = {1, 1, 0},
		styleAtronachColor = {0, 1, 1},
		styleBerserkColor = {1, 1, 0},
		styleZeroTimerOpacity = 0.7,
		styleTimerBlink = true,
	},

	sv = nil, -- saved variables
	sw = nil, -- account wide saved variables

	refreshRateList = 700, -- time in ms between players list updates

	playersData = {}, -- see M.UpdatePlayerData
}

local HR = HodorReflexes
local M = HR.modules.share
local SV = nil -- shortcut for M.sv
local SW = nil -- shortcut for M.sw

local LDS = LibDataShare
local LC = LibCombat
local EM = EVENT_MANAGER

local controlsVisible = false -- current state of UI controls
local countdownVisible = false

-- Ultimate types.
local ULT_MISC = 0
local ULT_HORN = 1
local ULT_COLOS = 2
local ULT_ATRO = 3
--local ULT_ULT4 = 4
--local ULT_ULT5 = 5
--local ULT_ULT6 = 6
--local ULT_ULT7 = 7
local ULT_HORN_COLOS = 8
local ULT_HORN_ATRO = 9
--local ULT_HORN_ULT4 = 10
--local ULT_HORN_ULT5 = 11
--local ULT_HORN_ULT6 = 12
--local ULT_HORN_ULT7 = 13
local ULT_COLOS_ATRO = 14 -- this can't exist
--local ULT_COLOS_ULT4 = 15
--local ULT_COLOS_ULT5 = 16
--local ULT_COLOS_ULT6 = 17
--local ULT_COLOS_ULT7 = 18
--local ULT_ATRO_ULT4 = 19
--local ULT_ATRO_ULT5 = 20
--local ULT_ATRO_ULT6 = 21
--local ULT_ATRO_ULT7 = 22
--local ULT_ULT4_ULT5 = 23
--local ULT_ULT4_ULT6 = 24
--local ULT_ULT4_ULT7 = 25
--local ULT_ULT5_ULT6 = 26
--local ULT_ULT5_ULT7 = 27
--local ULT_ULT6_ULT7 = 28

--local ULT_NEW = 7 ultis in total (max) - 0-28 possible combinations

local CLASSID_SORC = 2
local CLASSID_TEMPLAR = 6

-- Damage types.
local DAMAGE_UNKNOWN = 0
local DAMAGE_TOTAL = 1
local DAMAGE_BOSS = 2
--local DAMAGE_NEW = 2 (max)

-- Ability costs are only updated when player is activated or enters combat
-- to avoid calling an expensive function GetAbilityCost() too often.
local ABILITY_COST_HORN  = 250
local ABILITY_COST_COLOS = 225
local ABILITY_COST_ATRONACH = 200

local playerTag = '' -- real group tag instead of "player"
--local playersData = M.playersData
local ultPool, dpsPool, clsPool, miscUltPool, atronachPool -- control pools (https://www.esoui.com/forums/showthread.php?t=143)

local isUltControlRefresh = true

local hornSlotted = false -- player has war horn slotted
local colosSlotted = false -- player has colossus slotted
local atronachSlotted = false

local myHorn = false -- it's player's turn to horn
local anyHorn = false -- any horn is ready
local hornOrder = 10 -- -- current player's position in the horn list
local hornEnd, forceEnd = 0, 0
local hornActive, forceActive = false, false

local colosOrder = 10 -- Current player's order in the colossus chain
local colosEnd = 0 -- Colossus end time
local mvEnd = 0 -- Major Vulnerability end time

local atronachEnd = 0 -- atronach end time
local berserkEnd = 0 -- major berserk end time
local atronachActive, berserkActive = false, false

local countdownTimeline = nil -- Horn and Colossus animation timeline

local DATA_PREFIX = 100000000000

local isNecro = GetUnitClassId('player') == 5
local isSorc = GetUnitClassId('player') == 2
local classIcons = {}
for i = 1, GetNumClasses() do
	local id, _, _, _, _, _, icon, _, _, _ = GetClassInfo(i)
	classIcons[id] = icon
end

function M.OverwriteClassIcons(ci)
	classIcons = ci
end

local hasSaxhleel -- player has Saxhleel set equipped

local isDuel = false -- is player currently dueling
local isTestRunning = false

-- https://springrts.com/wiki/Lua_Performance
-- Always use zo_floor, zo_min, etc. instead of math.* functions!
local strformat = string.format
local tsort = table.sort
local time = GetGameTimeMilliseconds

local share
local units = HR.units
local player = HR.player
local combat = HR.combat
local hud = HR.hud

local ULT_FRAGMENT, DPS_FRAGMENT, CLS_FRAGMENT, CNT_FRAGMENT, HRN_FRAGMENT, HNT_FRAGMENT, MISCULT_FRAGMENT, ATRO_FRAGMENT -- HUD fragments

local exitInstancePending = false

local sendExitInstanceButton = {
	name = GetString(HR_SEND_EXIT_INSTANCE),
	keybind = 'HR_SEND_EXIT_INSTANCE',
	callback = function() M.SendExitInstance() end,
	alignment = KEYBIND_STRIP_ALIGN_CENTER,
}

local function encodeData(dmgType, ultType, ult, dmg, dps)
	local dmgTypeZone = 27*110+110 -- 3080
	local ultReduced = zo_ceil(ult / 5)
	local rawData = DATA_PREFIX
	local head = dmgType * dmgTypeZone -- 0-3080, 3080 - 6160, 6160-9240
	local head2 = ultType * 110 + ultReduced
	local compressedUlt = (head + head2) * 10000000
	rawData = rawData + zo_min(dps, 999) -- add DPS
	rawData = rawData + zo_min(dmg, 9999) * 1000-- add DMG
	rawData = rawData + compressedUlt -- add compressed ulti & ultiType & dmgType
	return rawData
end

local function decodeData(rawData)
	local dmgTypeZone = 27*110+110 -- 3080
	local head = zo_floor(rawData / 10000000 % 10000)
	local dmgType = zo_floor(head / dmgTypeZone)
	local ultType = zo_floor((head % dmgTypeZone) / 110)
	if dmgType >= 0 and dmgType <= 2 and ultType >= 0 and ultType <= 27 then -- extra check to avoid conflicts
		local ult = zo_ceil(((head % dmgTypeZone) - ultType * 110) * 5)
		local dmg = zo_floor(rawData % 10000000 / 1000)
		local dps = zo_floor(rawData % 1000)
		return true, dmgType, ultType, ult, dmg, dps
	end

	return false, nil, nil, nil, nil, nil
end

-- Check player ultimates for horn/colossus to share them only when they are slotted
local function CheckSlottedUlts()
	colosSlotted = false
	hornSlotted = false
	atronachSlotted = false

	-- Check backbar ult first, cuz we are smart coderz
	local ult1 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_BACKUP)
	local ult2 = GetSlotBoundId(ACTION_BAR_ULTIMATE_SLOT_INDEX + 1, HOTBAR_CATEGORY_PRIMARY)
	-- Check both slots for aggressive horn first, cuz we are smart coderz
	if ult1 == 40223 or ult2 == 40223 or ult1 == 38563 or ult2 == 38563 or ult1 == 40220 or ult2 == 40220 then
		hornSlotted = true
	end
	-- Check morphed colos first
	if isNecro and (ult1 == 122395 or ult2 == 122395 or ult1 == 122388 or ult2 == 122388 or ult1 == 122174 or ult2 == 122174) then
		colosSlotted = true
	end
	-- check for sorc attro -- check greater storm attro first
	if isSorc and(ult1 == 23492 or ult2 == 23492 or ult1 == 23634 or ult2 == 23634 or ult1 == 23495 or ult2 == 23495) then
		atronachSlotted = true
	end
end

local function CheckEquippedSets()
	local _, _, _, n, _, _, p = GetItemLinkSetInfo("|H0:item:173857:364:50:0:0:0:0:0:0:0:0:0:0:0:1:0:0:1:0:0:0|h|h", true)
	local num = n + (p or 0)
	hasSaxhleel = num >= 3 -- we assume player has full set if he wears at least 3 items (2 can be on backbar)
end

-- Check if variable is a non empty string.
local function IsValidString(s)
	return type(s) == 'string' and s ~= ''
end

-- Check if variable is a valid color.
local function IsValidColor(c)
	return type(c) == 'table' and #c >= 3
end

local function roundDownToFive(number)
	local rounded = zo_floor(number / 5) * 5
	if rounded > number then
		return rounded - 5
	else
		return rounded
	end
end

-- Send player's ultimate and damage via map ping.
-- This function must always be called from SendAttempt(), which checks whether it's safe to send data.
local function SendData()
	local pingType, ultType, ult, dmg, dps = DAMAGE_UNKNOWN, ULT_HORN, 0, 0, 0
	local shareHorn = SV.enableUltimateShare ~= 0 and (hornSlotted and SV.enableUltimateShare or hasSaxhleel and type(SV.enableUltimateShare) == 'number' and SV.enableUltimateShare > 0)
	local shareColos = SV.enableColosShare and colosSlotted
	local shareAtronach = SV.enableAtronachShare and atronachSlotted
	local shareMiscUltimates = SV.enableMiscUltimateShare
	if M.IsEnabled() then
		ultType = ULT_MISC
		ult = roundDownToFive(zo_min(500, GetUnitPower("player", POWERTYPE_ULTIMATE)))
		if shareColos then
			ultType = shareHorn and ULT_HORN_COLOS or ULT_COLOS
		elseif shareHorn and shareAtronach then
			ultType = ULT_HORN_ATRO
		elseif shareHorn then
			ultType = ULT_HORN
		elseif shareAtronach then
			ultType = ULT_ATRO
		-- TODO: test if it works
		elseif not shareMiscUltimates then
			ult = 0
		end
		if SV.enableDamageShare then
			pingType, dmg, dps = M.GetPlayerDamage()
			if dmg == 0 or dps == 0 then
				pingType = DAMAGE_UNKNOWN
			end
		end
	end

	local rawData = encodeData(pingType, ultType, ult, dmg, dps)

	share:SendData(rawData)

	-- Own pings are not processed, so we update our data manually.
	M.UpdatePlayerData(playerTag, pingType, ultType, ult, dmg, dps, lastPingTime)
end

-- Send a number between 1 and 449953.
-- If force is true, then data is sent immediately, otherwise it's queued.
-- If callback function is provided, then it will be called right after the data has been sent (so it might not be received yet).
-- TODO: pillager send
function M.SendCustomData(data, force, callback)
	if data > 0 and data < share:GetMapSize() then
		if force then
			local result = share:SendData(data)
			if type(callback) == "function" then
				callback(result)
			end
			return result
		else
			return share:QueueData(data, callback)
		end
	else
		return false
	end
end

local function SendExitInstance()
	if exitInstancePending then return end -- prevent button spam
	-- Leave yourself only after the ping is sent.
	M.SendCustomData(22, false, function()
		if CanExitInstanceImmediately() then
			zo_callLater(function()
				exitInstancePending = false
				ExitInstanceImmediately()
			end, 100)
		end
	end)
	exitInstancePending = true
end

-- Send ping to force everyone in the group to exit the current instance (raid leader only).
function M.SendExitInstance()
	if IsUnitGroupLeader('player') then
		if HR.sv.confirmExitInstance then
			LibAddonMenu2.util.ShowConfirmationDialog(GetString(HR_BINDING_SEND_EXIT_INSTANCE), GetString(HR_SEND_EXIT_INSTANCE_CONFIRM), function()
				SendExitInstance()
			end)
		else
			SendExitInstance()
		end
	end
end

-- This function is called every 100ms and attempts to send player's data ping.
local function SendAttempt()
	if LDS:IsSendWindow() then
		SendData()
	end
end

-- Clean playersData from players who are not in the group anymore.
local function CleanGroupData(force)

	-- Find all offline players and players who are not in the current group anymore and remove them
	if not force and units.IsGrouped('player') then
		-- Find online players in the current group
		local newPlayers = {}
		for i = 1, GetGroupSize() do
			local tag = GetGroupUnitTagByIndex(i)
			local userId = units.GetDisplayName(tag)
			if userId and units.IsOnline(tag) then
				newPlayers[userId] = {tag, units.GetName(tag)}
			end
		end
		-- Remove offline players from playersData
		for userId, data in pairs(M.playersData) do
			local newData = newPlayers[userId]
			-- We need to compare character names, because the same user can have 2+ characters in group
			if newData and data.name == newData[2] then
				-- Update group tag, because it can change when group changes
				data.tag = newData[1]
				-- Player is not in the group anymore or on another character, clear his data
			else
				-- Stop animations
				HR.anim.UnregisterUser(userId)
				-- Release controls
				if data.ultRow then ultPool:ReleaseObject(data.ultRow.poolKey) end
				if data.dpsRow then dpsPool:ReleaseObject(data.dpsRow.poolKey) end
				if data.clsRow then clsPool:ReleaseObject(data.clsRow.poolKey) end
				if data.miscUltRow then miscUltPool:ReleaseObject(data.miscUltRow.poolKey) end
				if data.atronachRow then atronachPool:ReleaseObject(data.atronachRow.poolKey) end
				-- Clear player data
				M.playersData[userId] = nil
			end
		end
	else
		-- Player is not grouped. Delete everyone!
		-- Stop animations
		for userId in pairs(M.playersData) do
			HR.anim.UnregisterUser(userId)
		end
		-- Clear players data list
		M.playersData = {}
		-- Release all controls
		ultPool:ReleaseAllObjects()
		miscUltPool:ReleaseAllObjects()
		dpsPool:ReleaseAllObjects()
		clsPool:ReleaseAllObjects()
		atronachPool:ReleaseAllObjects()
	end

end

function M.RegisterCustomDataCallback(callback)
	M.cm:RegisterCallback('CustomData', callback)
end

function M.UnregisterCustomDataCallback(callback)
	M.cm:UnregisterCallback('CustomData', callback)
end

function M.UpdateAbilityCosts()
-- TEMP remove cost calculation because its not needed anymore
	--ABILITY_COST_HORN  = GetAbilityCost(40223)
	--ABILITY_COST_COLOS = GetAbilityCost(122395)
	--ABILITY_COST_ATRONACH = GetAbilityCost(23492)

end

local function CreateSceneFragments()

	local function UltFragmentCondition()
		return SV.enableUltimateList and controlsVisible
	end

	local function MiscUltFragmentCondition()
		return SV.enableMiscUltimateList and controlsVisible
	end

	local function DpsFragmentCondition()
		return M.IsDamageListVisible() and controlsVisible
	end

	local function ClsFragmentCondition()
		return SV.enableColosList and controlsVisible
	end

	local function AtronachFragmentCondition()
		return SV.enableAtronachList and controlsVisible
	end

	local function CntFragmentCondition()
		-- Changing label text here is not a clean approach, but it allows us to just call CNT_FRAGMENT:Refresh() to do it
		local result = false
		if not controlsVisible or not SV.enableColosCountdown or isDuel then
			result = false
		elseif not M.uiLocked then -- unlocked UI, show default notification
			HodorReflexes_Share_ColosCountdown_Label:SetText(strformat("%s: |cFFFF002.5|r", SV.colosCountdownText))
			result = true
		elseif colosOrder == 0 and IsUnitInCombat('player') and M.GetUltPercentage(GetUnitPower("player", POWERTYPE_ULTIMATE), ABILITY_COST_COLOS) >= 100 and (DoesUnitExist('boss1') or DoesUnitExist('boss2') or player.GetCurrentHouseId() > 0) then
			local t = time()
			local count = mvEnd - t - 1000
			if colosEnd - t < 0 and count <= 5000 then -- show if colos is not being casted by anyone and major vuln remaining time is below 5000
				if count > 0 then
					HodorReflexes_Share_ColosCountdown_Label:SetText(strformat("%s: |cFFFF00%0.1f|r", SV.colosCountdownText, count / 1000))
				else
					HodorReflexes_Share_ColosCountdown_Label:SetText(strformat("%s: |cFF0000%s!|r", SV.colosCountdownText, GetString(HR_NOW)))
				end
				result = true
			end
		end
		return result
	end

	local function HntFragmentCondition()
		-- Changing label text here is not a clean approach, but it allows us to just call CNT_FRAGMENT:Refresh() to do it
		local result = false
		if not controlsVisible or SV.hornCountdownType == 'none' or isDuel then
			result = false
		elseif not M.uiLocked then -- unlocked UI, show default notification
			HodorReflexes_Share_HornCountdown_Label:SetText(strformat("%s: |cFFFF003.0|r", GetString(HR_HORN)))
			result = true
		elseif IsUnitInCombat('player') and ((SV.hornCountdownType == 'horn_all' or SV.hornCountdownType == 'force_all') and anyHorn or (SV.hornCountdownType == 'horn_self' or SV.hornCountdownType == 'force_self') and myHorn and hornOrder == 1) then
			local t = GetFrameTimeSeconds()
			local count = 0
			if SV.hornCountdownType == 'horn_all' or SV.hornCountdownType == 'horn_self' then
				count = hornEnd - t
			else
				count = forceEnd - t
			end
			if count < 3.5 then
				if count > 0 then
					HodorReflexes_Share_HornCountdown_Label:SetText(strformat("%s: |cFFFF00%0.1f|r", GetString(HR_HORN), count))
				else
					HodorReflexes_Share_HornCountdown_Label:SetText(strformat("%s: |cFF0000%s!|r", GetString(HR_HORN), GetString(HR_NOW)))
				end
				result = true
			end
		end
		return result
	end

	local function HrnFragmentCondition()
		return SV.enableHornIcon and (controlsVisible and myHorn and not forceActive or not M.uiLocked)
	end

	ULT_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_Ultimates, UltFragmentCondition)
	MISCULT_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_MiscUltimates, MiscUltFragmentCondition)
	ATRO_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_Atronach, AtronachFragmentCondition)
	DPS_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_Damage, DpsFragmentCondition)
	CLS_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_Colos, ClsFragmentCondition)
	CNT_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_ColosCountdown, CntFragmentCondition)
	HNT_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_HornCountdown, HntFragmentCondition)
	HRN_FRAGMENT = hud.AddSimpleFragment(HodorReflexes_Share_HornIcon, HrnFragmentCondition)

end

local function CreateControlPools()

	local function CreateUltRow(pool)
		return ZO_ObjectPool_CreateControl('HodorReflexes_Share_UltimateRow', pool, HodorReflexes_Share_Ultimates)
	end

	local function CreateMiscUltRow(pool)
		return ZO_ObjectPool_CreateControl('HodorReflexes_Share_MiscUltimatesRow', pool, HodorReflexes_Share_MiscUltimates)
	end

	local function CreateDpsRow(pool)
		local control = ZO_ObjectPool_CreateControl('HodorReflexes_Share_DamageRow', pool, HodorReflexes_Share_Damage)
		control:GetNamedChild('_Value'):SetFont(M.GetDamageNumFont())
		return control
	end

	local function CreateClsRow(pool)
		return ZO_ObjectPool_CreateControl('HodorReflexes_Share_ColosRow', pool, HodorReflexes_Share_Colos)
	end

	local function CreateAtronachRow(pool)
		return ZO_ObjectPool_CreateControl('HodorReflexes_Share_AtronachRow', pool, HodorReflexes_Share_Atronach)
	end

	ultPool = ZO_ObjectPool:New(CreateUltRow, ZO_ObjectPool_DefaultResetControl)
	miscUltPool = ZO_ObjectPool:New(CreateMiscUltRow, ZO_ObjectPool_DefaultResetControl)
	dpsPool = ZO_ObjectPool:New(CreateDpsRow, ZO_ObjectPool_DefaultResetControl)
	clsPool = ZO_ObjectPool:New(CreateClsRow, ZO_ObjectPool_DefaultResetControl)
	atronachPool = ZO_ObjectPool:New(CreateAtronachRow, ZO_ObjectPool_DefaultResetControl)

end

function M.GetDamageNumFont()
	if SW.styleDamageNumFont == 'gamepad' then
		return '$(GAMEPAD_MEDIUM_FONT)|$(KB_19)|outline'
	else
		return '$(MEDIUM_FONT)|$(KB_17)|outline'
	end
end

function M.ApplyStyle()
	if not SW.enableMapPins then
		-- Hide pings on the world map
		ZO_PreHook(ZO_MapPin, 'ShouldShowPin', function(self)
			return self.m_PinType == MAP_PIN_TYPE_PING
		end)
		-- Hide pins on the compass
		COMPASS.container:SetAlphaDropoffBehavior(MAP_PIN_TYPE_PING, 0, 0, 0, 0)
	end

	HodorReflexes_Share_Damage_BG:SetAlpha(SW.styleDamageHeaderOpacity)

	local font = M.GetDamageNumFont()
	for _, control in pairs(dpsPool.m_Active) do
		control:GetNamedChild('_Value'):SetFont(font)
	end
	for _, control in pairs(dpsPool.m_Free) do
		control:GetNamedChild('_Value'):SetFont(font)
	end
end

function M.Initialize()

	-- Register Vvardenfell map for data sharing.
	share = LDS:RegisterMap("Hodor Reflexes", 30, M.ProcessData)

	-- Create callback manager
	M.cm = M.cm or ZO_CallbackObject:New()

	-- Retrieve savedVariables
	M.sw = ZO_SavedVars:NewAccountWide(HR.svName, HR.svVersion, 'share', M.default)
	if M.sw.accountWide then
		M.sv = M.sw
	else
		M.sv = ZO_SavedVars:NewCharacterIdSettings(HR.svName, HR.svVersion, 'share', M.default)
		M.sv.accountWide = false
	end
	SV = M.sv
	SW = M.sw

	-- Load user icon, if he has one.
	local userId = GetUnitDisplayName('player')
	local userIcon = player.GetIconForUserId(userId)
	HodorReflexes_Updated_Icon5:SetTextureCoords(0, 1, 0, 1)
	if HR.anim.RegisterUser(userId) then
		HR.anim.RegisterUserControl(userId, HodorReflexes_Updated_Icon5)
		HR.anim.RunUserAnimations(userId)
	elseif userIcon then
		HodorReflexes_Updated_Icon5:SetTexture(userIcon)
	end

	-- Show version update window and notify player if his icon is missing.
	zo_callLater(function()
		if not HodorReflexes_Updated_Icon5:IsTextureLoaded() then
			d(strformat("|cFF6600%s|r", GetString(HR_MISSING_ICON)))
		end
		-- Version update window.
		if SW.lastIconsVersion ~= HR.version then
			SW.lastIconsVersion = HR.version
			PlaySound(SOUNDS.BOOK_COLLECTION_COMPLETED)
			HodorReflexes_Updated:SetHidden(false)
		end
	end, 1000)

	-- Set default values for custom name and color.
	if not IsValidString(SW.myIconPathFull) then
		SW.myIconPathFull = userIcon or 'HodorReflexes/esologo.dds'
	end
	if not IsValidString(SW.myIconNameRaw) then
		SW.myIconNameRaw = player.GetAliasForUserId(userId)
		if SW.myIconNameRaw == '' then SW.myIconNameRaw = UndecorateDisplayName(userId) end
	end
	if not IsValidString(SW.myIconNameFormatted) then
		SW.myIconNameFormatted = SW.myIconNameRaw
	end
	if not IsValidColor(SW.myIconColor1) then
		SW.myIconColor1 = M.default.myIconColor1
	end
	if not IsValidColor(SW.myIconColor2) then
		SW.myIconColor2 = M.default.myIconColor2
	end

	-- Fix enableDamageList value.
	if SV.enableDamageList == false then
		SV.enableDamageList = 0
	elseif SV.enableDamageList == true then
		SV.enableDamageList = 1
	end

	-- Bindings
	ZO_CreateStringId('SI_BINDING_NAME_HR_SEND_EXIT_INSTANCE', GetString(HR_BINDING_SEND_EXIT_INSTANCE))
	ZO_CreateStringId('SI_BINDING_NAME_HR_SHARE_TOGGLE_DPS', GetString(HR_BINDING_DPS_SHARE))

	-- Build settings menus
	M.BuildMenu()
	M.BuildIconsMenu()
	M.BuildStyleMenu()

	-- Create scene fragments for controls
	CreateSceneFragments()

	-- Restore colors and positions
	M.RestorePosition()
	M.RestoreColors()

	HR.RegisterCallback(HR_EVENT_PLAYER_ACTIVATED, function() M.ToggleEnabled() end)

	-- Create control pools
	CreateControlPools()

	-- Create control animations
	M.ToggleAnimations(SW.enableAnimations, false)

	M.ApplyStyle()

	-- Add hotkey to exit instance
	local function OnStateChanged(oldState, newState)
		if newState == SCENE_FRAGMENT_SHOWING and IsUnitGroupLeader('player') then
			KEYBIND_STRIP:AddKeybindButton(sendExitInstanceButton)
		elseif newState == SCENE_FRAGMENT_HIDING then
			KEYBIND_STRIP:RemoveKeybindButton(sendExitInstanceButton)
		end
	end
	KEYBOARD_GROUP_MENU_SCENE:RegisterCallback('StateChange', OnStateChanged)
	GAMEPAD_GROUP_SCENE:RegisterCallback('StateChange', OnStateChanged)

end

function M.IsEnabled()

	return SW.enabled and (not SW.disablePvP or not IsPlayerInAvAWorld() and not IsActiveWorldBattleground())

end

function M.ToggleEnabled()

	--M.UpdateAbilityCosts()

	local colosIds = {122380, 122391, 122398} -- colossus ability cast
	--local mvIds = {122177, 122397, 122389, 163060, 106754} -- major vuln applied (unmorphed, stam, mag, kynmarcher's cruelty effect, turning tide set)

	---------------------------
	-- Unregister everything --
	---------------------------
	combat.Unregister() -- reset combat data

	-- HodorReflexes callbacks
	HR.UnregisterCallback(HR_EVENT_COMBAT_START, M.CombatStart)
	HR.UnregisterCallback(HR_EVENT_COMBAT_END, M.CombatEnd)
	HR.UnregisterCallback(HR_EVENT_UNITS_UPDATED, M.GroupChanged)

	-- Colossus cast
	for i, id in ipairs(colosIds) do
		EM:UnregisterForEvent(M.name .. "ColosCast" .. i, EVENT_COMBAT_EVENT)
	end

	-- Major Vulnerability
	EM:UnregisterForEvent(M.name .. "MV", EVENT_EFFECT_CHANGED)

	-- Duel
	isDuel = GetDuelInfo() > 0

	-- Check slotted ults
	EM:UnregisterForEvent(M.name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED)

	-------------------------------------------------------
	-- Register everything again if the addon is enabled --
	-------------------------------------------------------
	if M.IsEnabled() then

		-- Disable all conflicting addons.
		LDS:ResolveConflicts()

		-- HodorReflexes callbacks
		HR.RegisterCallback(HR_EVENT_COMBAT_START, M.CombatStart)
		HR.RegisterCallback(HR_EVENT_COMBAT_END, M.CombatEnd)
		HR.RegisterCallback(HR_EVENT_UNITS_UPDATED, M.GroupChanged)

		-- Colossus cast
		for i, id in ipairs(colosIds) do
			local eventName = strformat("%sColosCast%d", M.name, i)
			EM:RegisterForEvent(eventName, EVENT_COMBAT_EVENT, M.ColosCast)
			EM:AddFilterForEvent(eventName, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id)
			EM:AddFilterForEvent(eventName, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
		end

		-- Atronach cast
		local atronachIds = {23634, 23492, 23495}
		for i, id in ipairs(atronachIds) do
			local eventName = strformat("%sAtronachCast%d", M.name, i)
			EM:RegisterForEvent(eventName, EVENT_COMBAT_EVENT, M.AtronachCast)
			EM:AddFilterForEvent(eventName, EVENT_COMBAT_EVENT, REGISTER_FILTER_ABILITY_ID, id)
			EM:AddFilterForEvent(eventName, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
		end

		-- Vulnerability applied
		EM:RegisterForEvent(M.name .. "MV", EVENT_EFFECT_CHANGED, M.MajorVulnerability)
		EM:AddFilterForEvent(M.name .. "MV", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 106754)

		-- major berserk applied
		EM:RegisterForEvent(M.name .. "MajorBerserk", EVENT_EFFECT_CHANGED, M.MajorBerserk)
		EM:AddFilterForEvent(M.name .. "MajorBerserk", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 61745)


		CheckSlottedUlts()
		EM:RegisterForEvent(M.name, EVENT_ACTION_SLOTS_ALL_HOTBARS_UPDATED, CheckSlottedUlts)

		-- Equipped items changed.
		CheckEquippedSets()
		EM:RegisterForEvent(M.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, CheckEquippedSets)
		EM:AddFilterForEvent(M.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)

		-- Register combat extension
		combat.Register()

	end

	M.ToggleHornDuration()

end

function M.GroupChanged()

	M.ToggleShare()

	-- Stop running test and clean group data
	if isTestRunning then
		CleanGroupData(true)
		isTestRunning = false
		M.LockUI()
	else
		CleanGroupData()
	end

	-- Update lists every M.refreshRateList if the player is grouped
	EM:UnregisterForUpdate(M.name .. "RefreshControls")
	if units.IsGrouped('player') then
		playerTag = units.GetPlayerTag()
		if M.IsEnabled() then
			EM:RegisterForUpdate(M.name .. "RefreshControls", M.refreshRateList, M.RefreshControls)
		end
	end

end

-- War Horn and Major Force.
do
	local eventNameTick = M.name .. "HornTick"
	local lastHornTime = 0
	local blinkerHorn = 0
	local blinkerForce = 0

	-- Enable/disable war horn duration in the ultimates list.
	function M.ToggleHornDuration()

		local hornId  = {38564, 40221, 40224, 61747}

		-- Stop tracking War Horn
		for i = 1, #hornId do
			EM:UnregisterForEvent(M.name .. 'Horn' .. i,  EVENT_EFFECT_CHANGED)
		end
		-- Track War Horn
		if M.IsEnabled() then
			for i = 1, #hornId do
				local eventName = strformat('%sHorn%d', M.name, i)
				EM:RegisterForEvent(eventName, EVENT_EFFECT_CHANGED, M.OnHornEffectChanged)
				if SV.selfishMode then
					EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG, 'player', REGISTER_FILTER_ABILITY_ID, hornId[i])
				else
					EM:AddFilterForEvent(eventName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_UNIT_TAG_PREFIX, 'group', REGISTER_FILTER_ABILITY_ID, hornId[i])
				end
			end
		else
			EM:UnregisterForUpdate(eventNameTick)
		end

	end

	local function HornTick()

		local t = GetFrameTimeSeconds()
		local forceRemain = forceEnd - t
		local hornRemain = hornEnd - t
		hornActive = SW.styleTimerBlink and hornRemain > -2 or hornRemain > 0
		forceActive = SW.styleTimerBlink and forceRemain > -2 or forceRemain > 0

		if hornActive then
			if hornRemain > 0 then
				HodorReflexes_Share_Ultimates_HornDuration:SetText(strformat('%5.1f', hornRemain))
				blinkerHorn = 0
			else
				HodorReflexes_Share_Ultimates_HornDuration:SetText(blinkerHorn % 4 < 2 and '' or '  0.0')
				blinkerHorn = blinkerHorn + 1
			end
		else
			HodorReflexes_Share_Ultimates_HornDuration:SetText('  0.0')
			HodorReflexes_Share_Ultimates_HornDuration:SetAlpha(SW.styleZeroTimerOpacity)
			HodorReflexes_Share_Ultimates_HornIcon:SetAlpha(SW.styleZeroTimerOpacity)
		end

		if forceActive then
			if forceRemain > 0 then
				HodorReflexes_Share_Ultimates_ForceDuration:SetText(strformat('%5.1f', forceRemain))
				blinkerForce = 0
			else
				HodorReflexes_Share_Ultimates_ForceDuration:SetText(blinkerForce % 4 < 2 and '' or '  0.0')
				blinkerForce = blinkerForce + 1
			end
		else
			HodorReflexes_Share_Ultimates_ForceDuration:SetText('  0.0')
			HodorReflexes_Share_Ultimates_ForceDuration:SetAlpha(SW.styleZeroTimerOpacity)
			HodorReflexes_Share_Ultimates_ForceIcon:SetAlpha(SW.styleZeroTimerOpacity)
		end

		if not hornActive and not forceActive then
			EM:UnregisterForUpdate(eventNameTick)
		end

		HNT_FRAGMENT:Refresh()
	end

	function M.OnHornEffectChanged(_, change, _, _, _, beginTime, endTime, _, _, _, _, _, _, _, _, abilityId)
		-- War Horn or Major Force cast
		if change == EFFECT_RESULT_GAINED then
			local t = time()
			if abilityId == 61747 then
				forceEnd = endTime
				HodorReflexes_Share_Ultimates_ForceDuration:SetAlpha(1)
				HodorReflexes_Share_Ultimates_ForceIcon:SetAlpha(1)
			else
				hornEnd = endTime
				HodorReflexes_Share_Ultimates_HornDuration:SetAlpha(1)
				HodorReflexes_Share_Ultimates_HornIcon:SetAlpha(1)
			end
			if t - lastHornTime > 100 then -- don't register for update for each group member
				lastHornTime = t
				EM:UnregisterForUpdate(eventNameTick)
				EM:RegisterForUpdate(eventNameTick, 100, HornTick)
				zo_callLater(HornTick, 50) -- wait 50ms for major force to apply
			end
		end
	end
end

-- Colossus and Invulnerability.
do
	local eventNameTick = M.name .. "ColosTick"
	local blinker = 0

	local function ColosTick()
		local t = time()
		if mvEnd < t - 2000 or not SW.styleTimerBlink and mvEnd <= t then
			EM:UnregisterForUpdate(eventNameTick)
			HodorReflexes_Share_Colos_Duration:SetText('  0.0')
			HodorReflexes_Share_Colos_Duration:SetAlpha(SW.styleZeroTimerOpacity)
			HodorReflexes_Share_Colos_Icon:SetAlpha(SW.styleZeroTimerOpacity)
		else
			if mvEnd < t then
				HodorReflexes_Share_Colos_Duration:SetText(blinker % 4 < 2 and '' or '  0.0')
				blinker = blinker + 1
			else
				HodorReflexes_Share_Colos_Duration:SetText(strformat('%5.1f', (mvEnd - t) / 1000))
				blinker = 0
			end
		end
		CNT_FRAGMENT:Refresh()
	end

	-- Someone cast colossus.
	function M.ColosCast(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, targetUnitId)
		-- Don't do anything if colossus list is disabled
		if not SV.enableColosList then return end

		local unitTag = units.GetTag(targetUnitId)
		local userId = units.GetDisplayName(unitTag)
		local data = userId and M.playersData[userId]
		if data and data.ult > 0 then -- reset ult % in the colossus list
			data.ult = 1
			data.ultTime = time() + LDS:GetPingRate() -- don't let the next incoming ping overwrite this value
			M.UpdateUltimates()
		end

		-- Ignore this cast if the caster is out of range
		if not isTestRunning and SV.colosSupportRange and (not unitTag or not M.IsUnitNearby(unitTag)) then return end

		colosEnd = time() + 3000
	end

	function M.MajorVulnerability(_, changeType, _, _, _, beginTime, endTime, _, _, _, _, _, _, _, _, abilityId)
		if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED and endTime > 0 then
			-- Convert endTime to time() format
			endTime = zo_ceil(endTime * 1000)
			-- Prevent registering ColosTick multiple times within a short time span
			if mvEnd < endTime - 200 then
				mvEnd = endTime
				EM:UnregisterForUpdate(eventNameTick)
				EM:RegisterForUpdate(eventNameTick, 100, ColosTick)
				HodorReflexes_Share_Colos_Duration:SetAlpha(1)
				HodorReflexes_Share_Colos_Icon:SetAlpha(1)
				ColosTick()
			end
		end
	end
end

-- Atronach and major berserk.
do
	local eventNameTick = M.name .. "AtronachTick"
	local blinkerAtronach = 0
	local blinkerBerserk = 0

	local function AtronachTick()
		local t = time()

		if atronachEnd < t - 2000 or not SW.styleTimerBlink and atronachEnd <= t then
			HodorReflexes_Share_Atronach_AtronachDuration:SetText('  0.0')
			HodorReflexes_Share_Atronach_AtronachDuration:SetAlpha(SW.styleZeroTimerOpacity)
			HodorReflexes_Share_Atronach_AtronachIcon:SetAlpha(SW.styleZeroTimerOpacity)
			atronachActive = false
		else
			if atronachEnd < t then
				HodorReflexes_Share_Atronach_AtronachDuration:SetText(blinkerAtronach % 4 < 2 and '' or '  0.0')
				blinkerAtronach = blinkerAtronach + 1
			else
				HodorReflexes_Share_Atronach_AtronachDuration:SetText(strformat('%5.1f', (atronachEnd - t) / 1000))
				blinkerAtronach = 0
			end
			atronachActive = true
		end

		if berserkEnd < t - 2000 or not SW.styleTimerBlink and berserkEnd <= t then
			HodorReflexes_Share_Atronach_BerserkDuration:SetText('  0.0')
			HodorReflexes_Share_Atronach_BerserkDuration:SetAlpha(SW.styleZeroTimerOpacity)
			HodorReflexes_Share_Atronach_BerserkIcon:SetAlpha(SW.styleZeroTimerOpacity)
			berserkActive = false
		else
			if berserkEnd < t then
				HodorReflexes_Share_Atronach_BerserkDuration:SetText(blinkerBerserk % 4 < 2 and '' or '  0.0')
				blinkerBerserk = blinkerBerserk + 1
			else
				HodorReflexes_Share_Atronach_BerserkDuration:SetText(strformat('%5.1f', (berserkEnd - t) / 1000))
				blinkerBerserk = 0
			end
			berserkActive = true
		end

		if not atronachActive and not berserkActive then
			EM:UnregisterForUpdate(eventNameTick)
		end
	end

	function M.AtronachCast(_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, targetUnitId)
		---- Someone cast atronach.
		-- Don't do anything if colossus list is disabled
		if not SV.enableAtronachList then return end

		local unitTag = units.GetTag(targetUnitId)
		local userId = units.GetDisplayName(unitTag)
		local data = userId and M.playersData[userId]
		if data and data.ult > 0 then -- reset ult % in the colossus list
			data.ult = 1
			data.ultTime = time() + LDS:GetPingRate() -- don't let the next incoming ping overwrite this value
			M.UpdateUltimates()
		end

		-- Ignore this cast if the caster is out of range
		if not isTestRunning and SV.atronachSupportRange and (not unitTag or not M.IsUnitNearby(unitTag)) then return end

		EM:UnregisterForUpdate(eventNameTick)
		EM:RegisterForUpdate(eventNameTick, 100, AtronachTick)

		HodorReflexes_Share_Atronach_AtronachDuration:SetAlpha(1)
		HodorReflexes_Share_Atronach_AtronachIcon:SetAlpha(1)
		atronachEnd = time() + 15000

	end

	function M.MajorBerserk(_, changeType, _, _, _, beginTime, endTime, _, _, _, _, _, _, _, _, abilityId)
		if changeType == EFFECT_RESULT_GAINED or changeType == EFFECT_RESULT_UPDATED and endTime > 0 then
			-- Convert endTime to time() format
			endTime = zo_ceil(endTime * 1000)
			--if abilityId == 61745 then
			--	d("double check abilityID " .. abilityId)
			--end
			-- Prevent registering ColosTick multiple times within a short time span

			if berserkEnd < endTime - 200 then
				berserkEnd = endTime
				EM:UnregisterForUpdate(eventNameTick)
				EM:RegisterForUpdate(eventNameTick, 100, AtronachTick)
				HodorReflexes_Share_Atronach_BerserkDuration:SetAlpha(1)
				HodorReflexes_Share_Atronach_BerserkIcon:SetAlpha(1)
				zo_callLater(AtronachTick, 50) -- wait 50ms for major berserk to apply
			end
		end
	end
end


-- Process data decoded from a map ping.
function M.ProcessData(tag, data, ms)
	-- Custom data ping.
	if data > 0 and data < share:GetMapSize() then
		if data == 22 and IsUnitGroupLeader(tag) then
			-- Group leader wants everybody to exit the instance
			HR.ExitInstance()
		else
			M.cm:FireCallbacks('CustomData', tag, data)
		end
		-- Data is encoded between DATA_PREFIX and DATA_PREFIX * 2
	elseif (data >= DATA_PREFIX and data < DATA_PREFIX * 2) then
		local success, pingType, ultType, ult, dmg, dps = decodeData(data)
		--d(ult)
		if success == false then return end

		M.UpdatePlayerData(tag, pingType, ultType, ult, dmg, dps, ms or time())

	end
end

function M.RefreshControls()
	if isUltControlRefresh then
		if SV.enableUltimateList or SV.enableColosList or SV.enableMiscUltimateList then
			M.UpdateUltimates()
		else
			-- if both lists are disabled, then make sure horn and colos notifications are hidden
			myHorn = false
			hornOrder = 10
			colosOrder = 10
		end
	else
		if M.IsDamageListVisible() then
			M.UpdateDamage()
		end
	end
	isUltControlRefresh = not isUltControlRefresh
end

-- Enable/disable sharing.
function M.ToggleShare()
	EM:UnregisterForUpdate(M.name .. "SendData")
	if units.IsGrouped('player') then
		if M.IsEnabled() and (SV.enableUltimateShare and SV.enableUltimateShare ~= 0 or SV.enableDamageShare or SV.enableColosShare or SV.enableMiscUltimateShare or SV.enableAtronachShare) then
			-- Enable data sharing
			EM:RegisterForUpdate(M.name .. "SendData", 100, SendAttempt)
		else
			share:QueueData(0) -- send zero values
		end
	end
	M.RefreshVisibility()
end

function M.RefreshVisibility()
	controlsVisible = not M.uiLocked or M.IsEnabled() and units.IsGrouped('player')
	-- Refresh fragments
	ULT_FRAGMENT:Refresh()
	MISCULT_FRAGMENT:Refresh()
	ATRO_FRAGMENT:Refresh()
	DPS_FRAGMENT:Refresh()
	CLS_FRAGMENT:Refresh()
	CNT_FRAGMENT:Refresh()
	HNT_FRAGMENT:Refresh()
	HRN_FRAGMENT:Refresh()
end

-- Returns true if the damage list should be shown, false otherwise.
function M.IsDamageListVisible()
	if SV.enableDamageList == 1 then
		return true
	elseif SV.enableDamageList == 2 then
		return not IsUnitInCombat('player')
	elseif SV.enableDamageList == 3 then
		return not IsUnitInCombat('player') or not DoesUnitExist('boss1') and not DoesUnitExist('boss2')
	else
		return false
	end
end

-- return the ultimate in percent from 0-100. from 100-200 its scaled acordingly. The costReduction is also taken into account
function M.GetUltPercentage(raw, abilityCost, costReduction)
	local ultPercentage = 0

	if not costReduction then
		costReduction = 0
	end
	abilityCost = abilityCost - zo_floor((abilityCost / 100 * costReduction))

	if raw <= abilityCost then
		-- When ult is not ready, we show real %
		return zo_floor(raw/abilityCost*100)
	else
		-- If ult is ready, then adjust % to show 200% only at 500 points
		return zo_min(200, 100 + zo_floor(100 * (raw - abilityCost) / (500 - abilityCost)))
	end

	return zo_min(200, ultPercentage)
end
--
--function M.GetUltType()
--	if SV.enableUltimateShare and SV.enableUltimateShare ~= 0 and SV.enableColosShare then
--		return ULT_HORN_COLOS
--	elseif SV.enableColosShare then
--		return ULT_COLOS
--	else
--		return ULT_HORN
--	end
--end

function M.GetDamageTypeName(t)
	local names = {
		[DAMAGE_UNKNOWN] = GetString(HR_DAMAGE),
		[DAMAGE_TOTAL] = strformat('|c%s%s|r |c%s(DPS)|r', SW.styleBossDamageColor, GetString(HR_TOTAL_DAMAGE), SW.styleTotalDamageColor),
		[DAMAGE_BOSS] = strformat('|c%s%s|r |c%s(%s)|r', SW.styleBossDamageColor, GetString(HR_BOSS_DPS), SW.styleTotalDamageColor, GetString(HR_TOTAL_DPS)),
	}
	return names[t] and names[t] or strformat('|c%s%s|r |c%s(DPS)|r', SW.styleBossDamageColor, GetString(HR_MISC_DAMAGE), SW.styleTotalDamageColor)
end

-- Return damage type, total damage or boss dps (if it's a boss fight), total dps
function M.GetPlayerDamage()
	local data = combat.GetData()
	if data.DPSOut == 0 then return DAMAGE_UNKNOWN, 0, 0 end
	local bossUnits, bossDamage, bossTime = combat.GetBossTargetDamage()
	if bossUnits > 0 then
		return DAMAGE_BOSS, zo_floor(bossDamage / bossTime / 100), zo_floor(data.DPSOut / 1000)
	else
		return DAMAGE_TOTAL, zo_floor(combat.GetFullDamage() / 10000), zo_floor(data.DPSOut / 1000)
	end
end

function M.IsUnitNearby(tag)
	if IsUnitInGroupSupportRange(tag) then
		return true
	elseif not IsGroupMemberInRemoteRegion(tag) then -- same instance (works for overland zones too)
		local zoneId = player.GetCurrentZoneId()
		if zoneId == 975 then -- hof
			-- maybe return true for 1st and last bosses, but need some feedback and tests
			return false
		elseif zoneId == 1000 then -- asylum
			-- there are only bosses in AS
			-- and if unit is out of support range, then he is probably in the same boss fight anyway
			return true
		elseif zoneId == 1121 then -- sunspire
			if IsUnitInCombat('player') and DoesUnitExist('boss1') then
				-- during boss fights everyone is ported to the same room
				-- but on the last boss we need to exclude portal group
				local _, hp = GetUnitPower('boss1', POWERTYPE_HEALTH)
				if hp == 27266052 or hp == 103494192 or hp == 129367744 then -- normal, vet, hm TODO: Update values & include DSR & RG
					return false -- not in support range (already checked above)
				else
					return true
				end
			end
		end
	end
	return false
end

-- Set control text and color.
local function SetControlText(control, text, color)
	control:SetText(text)
	if color then
		control:SetColor(unpack(color))
	else
		control:SetColor(1, 1, 1)
	end
end

-- Set control texture and reset coordinates.
local function SetControlIcon(control, fileName)
	control:SetTextureCoords(0, 1, 0, 1)
	control:SetTexture(fileName)
end

-- Create horn, damage and colossus rows.
local function CreateControlsForUser(userId, playerData)
	-- Set user name and icon
	local isPlayer = playerData.isPlayer
	local userIcon = player.GetIconForUserId(userId)
	local userName = player.GetAliasForUserId(userId, SW.enableColoredNames)

	-- Default player icon (if he doesn't have a custom icon or disabled them)
	local classId = playerData.classId
	local defaultIcon = classIcons[classId] and classIcons[classId] or 'esoui/art/campaign/campaignbrowser_guestcampaign.dds'

	-- War Horn row
	local ultRow, ultKey = ultPool:AcquireObject()
	ultRow.poolKey = ultKey
	SetControlText(ultRow:GetNamedChild('_Name'), userName)
	SetControlIcon(ultRow:GetNamedChild('_Icon'), SW.enableUltimateIcons and userIcon or defaultIcon)

	-- miscUltimates row
	local miscUltRow, miscUltKey = miscUltPool:AcquireObject()
	miscUltRow.poolKey = miscUltKey
	SetControlText(miscUltRow:GetNamedChild('_Name'), userName)
	SetControlIcon(miscUltRow:GetNamedChild('_Icon'), SW.enableMiscUltimateIcons and userIcon or defaultIcon)

	-- Colossus row
	local clsRow, clsKey
	if classId == 5 then -- create colossus control for necros only
		clsRow, clsKey = clsPool:AcquireObject()
		clsRow.poolKey = clsKey
		SetControlText(clsRow:GetNamedChild('_Name'), userName)
		SetControlIcon(clsRow:GetNamedChild('_Icon'), SW.enableColosIcons and userIcon or defaultIcon)
	end

	-- atronach Row
	local atronachRow, atronachKey
	if classId == 2 then -- create atronach control only for sorcs only
		atronachRow, atronachKey = atronachPool:AcquireObject()
		atronachRow.poolKey = atronachKey
		SetControlText(atronachRow:GetNamedChild('_Name'), userName)
		SetControlIcon(atronachRow:GetNamedChild('_Icon'), SW.enableAtronachIcons and userIcon or defaultIcon)
	end

	-- Damage row
	local dpsRow, dpsKey = dpsPool:AcquireObject()
	dpsRow.poolKey = dpsKey
	SetControlText(dpsRow:GetNamedChild('_Name'), userName)
	SetControlIcon(dpsRow:GetNamedChild('_Icon'), SW.enableDamageIcons and userIcon or defaultIcon)


	-- Register icon animation if user has one
	if SW.enableAnimIcons and HR.anim.RegisterUser(userId) then
		if SW.enableUltimateIcons then HR.anim.RegisterUserControl(userId, ultRow:GetNamedChild('_Icon')) end
		if SW.enableMiscUltimateIcons then HR.anim.RegisterUserControl(userId, miscUltRow:GetNamedChild('_Icon')) end
		if SW.enableDamageIcons then HR.anim.RegisterUserControl(userId, dpsRow:GetNamedChild('_Icon')) end
		if atronachRow and SW.enableAtronachIcons then HR.anim.RegisterUserControl(userId, atronachRow:GetNamedChild('_Icon')) end
		if clsRow and SW.enableColosIcons then HR.anim.RegisterUserControl(userId, clsRow:GetNamedChild('_Icon')) end
		HR.anim.RunUserAnimations(userId)
	end

	playerData.ultRow = ultRow
	playerData.dpsRow = dpsRow
	playerData.clsRow = clsRow
	playerData.miscUltRow = miscUltRow
	playerData.atronachRow = atronachRow
	M.playersData[userId] = playerData
end

-- Store player's data in the playersData array.
function M.UpdatePlayerData(tag, pingType, ultType, ult, dmg, dps, dataTime)
	-- It takes 1-2 seconds for units to fetch group data after reloadui,
	-- so make sure it's finished.
	if not units.IsGrouped(tag) then return end

	-- dataTime is time when player data was received
	if not dataTime then dataTime = time() end

	local userId = units.GetDisplayName(tag)
	local playerData = M.playersData[userId]

	-- Player already exists, only update values
	if playerData then
		-- Player's group tag can change any time
		playerData.tag = tag

		-- Only update ult and damage values if the data is fresh
		-- e.g. ult can be set to 1 when a player uses colossus before received ping is processed
		if playerData.ultTime < dataTime then
			playerData.ult = ult
			playerData.ultType = ultType
			playerData.ultTime = dataTime
		end
		if playerData.dmgTime < dataTime then
			playerData.dmg = dmg
			playerData.dps = dps
			playerData.dmgType = pingType
			playerData.dmgTime = dataTime
		end

		-- Create controls for a new player
	elseif IsValidString(userId) then
		playerData = {
			tag = tag,
			name = units.GetName(tag),
			classId = units.GetClassId(tag),
			isPlayer = units.IsPlayer(tag),
			ult = ult,
			ultType = ultType,
			ultTime = dataTime,
			dmg = dmg,
			dps = dps,
			dmgType = pingType,
			dmgTime = dataTime,
		}
		CreateControlsForUser(userId, playerData)
	end
end

-- War Horn Icon.
do
	local isIconInitialized = false
	local animation

	-- Set textures and create animation only when it's needed.
	local function InitializeHornIcon()
		if not isIconInitialized then
			HodorReflexes_Share_HornIcon_TextureHighlight:SetTexture('EsoUI/Art/ActionBar/abilityHighlightAnimation.dds')
			animation = CreateSimpleAnimation(ANIMATION_TEXTURE, HodorReflexes_Share_HornIcon_TextureHighlight)
			animation:SetImageData(64, 1)
			animation:SetFramerate(30)
			animation:GetTimeline():SetPlaybackType(ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY)
			isIconInitialized = true
		end
	end

	-- Calculate a number of players in 20m range.
	local function UpdateHornIcon()

		if not forceActive then
			local n = 0 -- number of players in range
			local all = true -- all dds are in range
			local label = HodorReflexes_Share_HornIcon_Label
			local bg = HodorReflexes_Share_HornIcon_BG

			local _, x1, y1, z1 = GetUnitWorldPosition('player')
			for i = 1, GetGroupSize() do
				local tag = GetGroupUnitTagByIndex(i)
				local distance = 21
				if IsUnitInGroupSupportRange(tag) then -- check group range first to avoid unneeded calculations
					local _, x2, y2, z2 = GetUnitWorldPosition(tag)
					distance = zo_sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2 + (z1 - z2) ^ 2) / 100
				end
				if distance < 20 then
					n = n + 1
				elseif GetGroupMemberSelectedRole(tag) == LFG_ROLE_DPS then
					all = false
				end
			end

			label:SetText(n > 0 and n or '')
			if all then
				label:SetColor(hornOrder == 1 and 0 or 1, 1, 0)
				bg:SetColor(hornOrder == 1 and 0 or 1, 1, 0)
			else
				label:SetColor(1, 1, 1)
				bg:SetColor(0, 0, 0)
			end
		end

		HRN_FRAGMENT:Refresh()

	end

	-- Update myHorn value and horn icon if it's enabled.
	local function ToggleMyHorn(myHornNew)
		myHorn = myHornNew
		if SV.enableHornIcon then
			InitializeHornIcon()
			EM:UnregisterForUpdate(M.name .. 'UpdateHornIcon')
			if myHorn then
				-- Play icon animation
				animation:GetTimeline():PlayFromStart()
				-- Start updating the icon
				EM:RegisterForUpdate(M.name .. 'UpdateHornIcon', 200, UpdateHornIcon)
				UpdateHornIcon()
			else
				-- Stop icon animation and hide it
				animation:GetTimeline():Stop()
				HRN_FRAGMENT:Refresh()
			end
		end
	end

	-- Refresh ultimates list.
	function M.UpdateUltimates()

		local rowsHorn = {}
		local rowsColos = {}
		local rowsMiscUlt = {}
		local rowsAtronach = {}

		-- Update rows
		for name, data in pairs(M.playersData) do
			local tag = data.tag
			local ultRow = data.ultRow
			local miscUltRow = data.miscUltRow
			local clsRow = data.clsRow
			local atronachRow = data.atronachRow
			local costReduction = 0

			-- calculate cost reduction
			if data.classId == CLASSID_SORC then
				costReduction = 15
			end
			if data.classId == CLASSID_TEMPLAR then
				costReduction = 5
			end

			-- Only shows rows for online players with non empty ult %
			if data.ult > 0 and (isTestRunning or units.IsOnline(tag)) then
				-- Get horn and colos values based on ultType
				local horn, colos, atro = 0, 0, 0 -- ult %
				local misc = 0 -- ult raw for no special ultType
				local colorHorn, colorColos, colorAtronach = 'FFFFFF', 'FFFFFF', 'FFFFFF'
				if data.ultType == ULT_MISC then
					misc = data.ult
				elseif data.ultType == ULT_HORN then
					horn = M.GetUltPercentage(data.ult, ABILITY_COST_HORN, costReduction)
				elseif data.ultType == ULT_COLOS then
					colos = M.GetUltPercentage(data.ult, ABILITY_COST_COLOS, costReduction)
				elseif data.ultType == ULT_HORN_COLOS then
					horn = M.GetUltPercentage(data.ult, ABILITY_COST_HORN, costReduction)
					colos = M.GetUltPercentage(data.ult, ABILITY_COST_COLOS, costReduction)
				elseif data.ultType == ULT_ATRO then
					atro = M.GetUltPercentage(data.ult, ABILITY_COST_ATRONACH, costReduction)
				elseif data.ultType == ULT_HORN_ATRO then
					atro = M.GetUltPercentage(data.ult, ABILITY_COST_ATRONACH, costReduction)
					horn = M.GetUltPercentage(data.ult, ABILITY_COST_HORN, costReduction)
				end
				-- War Horn
				if ultRow then
					if horn > 0 then
						if horn >= 100 then colorHorn = '00FF00' elseif horn >= 80 then colorHorn = 'FFFF00' end
						ultRow:GetNamedChild('_Value'):SetText(strformat('|c%s%d%%|r', colorHorn, zo_min(200, horn)))
						ultRow:GetNamedChild('_Value'):SetScale(SV.showHornPercentValue)
						ultRow:GetNamedChild('_RawValue'):SetText(strformat('|c%s%d|r', "FFFFFF", zo_min(500, data.ult)))
						ultRow:GetNamedChild('_RawValue'):SetScale(SV.showHornRawValue)
						ultRow:SetHidden(false)
						rowsHorn[#rowsHorn + 1] = {tag, horn, data}
					else
						ultRow:SetHidden(true)
					end
				end
				-- Colossus
				if clsRow then
					if colos > 0 and not IsUnitDead(tag) and (not SV.colosSupportRange or isTestRunning or M.IsUnitNearby(tag)) then
						if colos >= 100 then colorColos = '00FF00' elseif colos >= 80 then colorColos = 'FFFF00' end
						clsRow:GetNamedChild('_Value'):SetText(strformat('|c%s%d%%|r', colorColos, zo_min(200, colos)))
						clsRow:GetNamedChild('_Value'):SetScale(SV.showColosPercentValue)
						clsRow:GetNamedChild('_RawValue'):SetText(strformat('|c%s%d|r', "FFFFFF", zo_min(500, data.ult)))
						clsRow:GetNamedChild('_RawValue'):SetScale(SV.showColosRawValue)
						clsRow:SetHidden(false)
						rowsColos[#rowsColos + 1] = {tag, colos, data}
					else
						clsRow:SetHidden(true)
					end
				end
				-- atro
				if atronachRow then
					if atro > 0 and not IsUnitDead(tag) then
						if atro >= 100 then colorAtronach = '00FF00' elseif atro >= 80 then colorAtronach = 'FFFF00' end
						atronachRow:GetNamedChild('_Value'):SetText(strformat('|c%s%d%%|r', colorAtronach, zo_min(200, atro)))
						atronachRow:GetNamedChild('_Value'):SetScale(SV.showAtronachPercentValue)
						atronachRow:GetNamedChild('_RawValue'):SetText(strformat('|c%s%d|r', "FFFFFF", zo_min(500, data.ult)))
						atronachRow:GetNamedChild('_RawValue'):SetScale(SV.showAtronachRawValue)
						atronachRow:SetHidden(false)
						rowsAtronach[#rowsAtronach + 1] = {tag, atro, data}
					else
						atronachRow:SetHidden(true)
					end
				end
				-- misc ultimates
				if miscUltRow then
					--if misc > 0 then
					if misc > 0 then
						miscUltRow:GetNamedChild('_RawValue'):SetText(strformat('|c%s%d|r', "FFFFFF", zo_min(500, data.ult)))
						miscUltRow:SetHidden(false)
						rowsMiscUlt[#rowsMiscUlt + 1] = {tag, misc, data}
					else
						miscUltRow:SetHidden(true)
					end
				end
			else
				if ultRow then ultRow:SetHidden(true) end
				if clsRow then clsRow:SetHidden(true) end
				if miscUltRow then miscUltRow:SetHidden(true) end
				if atronachRow then atronachRow:SetHidden(true) end
			end
		end

		-- sort row function
		local function sortRows(a, b)
			if a[2] == b[2] then return a[1] < b[1] else return a[2] > b[2] end
		end

		-- Sort by unitTag if % are the same
		tsort(rowsHorn,sortRows)
		tsort(rowsColos, sortRows)
		tsort(rowsMiscUlt, sortRows)
		tsort(rowsAtronach, sortRows)

		-- Order horn rows
		local myHornNew = false
		local anyHornNew = false
		for i, row in ipairs(rowsHorn) do
			local playerData = row[3]
			playerData.ultRow:ClearAnchors()
			playerData.ultRow:SetAnchor(TOPLEFT, HodorReflexes_Share_Ultimates, TOPLEFT, 0, i*24)
			-- We call M.GetHornPercent() instead of using row[2] value for better precision
			if playerData.isPlayer and M.GetUltPercentage(GetUnitPower("player", POWERTYPE_ULTIMATE), ABILITY_COST_HORN) >= 100 then
				myHornNew = true
				hornOrder = i
			end
			-- Check if there is any ready horn
			if row[2] >= 100 then
				anyHornNew = true
			end
		end
		if myHornNew ~= myHorn then ToggleMyHorn(myHornNew) end
		anyHorn = anyHornNew

		for i, row in ipairs(rowsMiscUlt) do
			local playerData = row[3]
			playerData.miscUltRow:ClearAnchors()
			playerData.miscUltRow:SetAnchor(TOPLEFT, HodorReflexes_Share_MiscUltimates, TOPLEFT, 0, i*24)
		end

		for i, row in ipairs(rowsAtronach) do
			local playerData = row[3]
			playerData.atronachRow:ClearAnchors()
			playerData.atronachRow:SetAnchor(TOPLEFT, HodorReflexes_Share_Atronach, TOPLEFT, 0, i*24)
		end

		-- Order colos rows
		local ultOrderFound = false -- found player in a list of ults
		for i, row in ipairs(rowsColos) do
			local playerData = row[3]
			playerData.clsRow:ClearAnchors()
			playerData.clsRow:SetAnchor(TOPLEFT, HodorReflexes_Share_Colos, TOPLEFT, 0, i*24)
			if playerData.isPlayer then
				colosOrder = i - 1
				ultOrderFound = true
			end
		end
		if not ultOrderFound then colosOrder = 10 end -- if player is not in the list, then don't show him any notifications

		CNT_FRAGMENT:Refresh()
		HNT_FRAGMENT:Refresh()
	end
end

function M.sortByDamage(a, b)
	if a[3] == b[3] then return a[2] > b[2] end
	return a[3] > b[3] -- sort by damage type
end

-- Refresh damage list.
function M.UpdateDamage()
	local rows = {}
	local dmgType = nil

	-- Update rows
	for name, data in pairs(M.playersData) do
		local tag = data.tag
		-- Only shows rows for online players with non empty damage
		if data.dmg > 0 and (isTestRunning or units.IsOnline(tag)) then
			-- Generate damage string
			local dmgStr = ''
			if data.dmgType == DAMAGE_TOTAL then
				dmgStr = strformat('|c%s%0.2fM|r |c%s(%dK)|r|u0:2::|u', SW.styleBossDamageColor, data.dmg / 100, SW.styleTotalDamageColor, data.dps)
			else
				dmgStr = strformat('|c%s%0.1fK|r |c%s(%dK)|r|u0:2::|u', SW.styleBossDamageColor, data.dmg / 10, SW.styleTotalDamageColor, data.dps)
			end
			data.dpsRow:GetNamedChild('_Value'):SetText(dmgStr)
			rows[#rows + 1] = {name, data.dmg, data.dmgType}

			-- Update general damage type
			if dmgType == nil then
				dmgType = data.dmgType
			elseif dmgType ~= data.dmgType then
				dmgType = -1
			end
		else
			data.dpsRow:SetHidden(true)
		end
	end
	tsort(rows, M.sortByDamage)

	-- Show rows
	for i, row in ipairs(rows) do
		local playerData = M.playersData[row[1]]
		playerData.dpsRow:ClearAnchors()
		playerData.dpsRow:SetAnchor(TOPLEFT, HodorReflexes_Share_Damage, TOPLEFT, 0, i*22)
		playerData.dpsRow:SetAnchor(TOPRIGHT, HodorReflexes_Share_Damage, TOPRIGHT, 0, i*22)
		playerData.dpsRow:SetHidden(false)
		-- Row color
		local customColor = false
		if playerData.isPlayer then
			local r, g, b, o = unpack(SW.damageRowColor)
			if o ~= 0 then
				customColor = true
				playerData.dpsRow:GetNamedChild('_BG'):SetColor(r, g, b, o or 0.5)
			end
		end
		if not customColor then
			playerData.dpsRow:GetNamedChild('_BG'):SetColor(0, 0, 0, zo_mod(i, 2) == 0 and SW.styleDamageRowEvenOpacity or SW.styleDamageRowOddOpacity)
		end
	end

	HodorReflexes_Share_Damage_Title:SetText(strformat('%s', M.GetDamageTypeName(dmgType == nil and 1 or dmgType)))
	local t = combat.GetCombatTime()
	HodorReflexes_Share_Damage_Time:SetText(t > 0 and strformat('%d:%04.1f|u0:2::|u', t / 60, t % 60) or '')
end

function M.CombatStart()
	--M.UpdateAbilityCosts()
	-- Reset damage values, so the player won't send old dps to a new fight before he does new damage
	combat.Reset()
	M.ResetFight()
end

function M.CombatEnd(confirmed)
	-- We refresh controls without confirmation to show damage list instantly if it's hidden during combat.
	if not confirmed then
		M.RefreshVisibility()
	else
		M.ResetFight()
	end
end

function M.ResetFight()
	mvEnd = 0
	isDuel = GetDuelInfo() > 0
	M.RefreshVisibility()
end

function M.UnlockUI()
	M.uiLocked = false
	M.RefreshVisibility()
	hud.UnlockControls(HodorReflexes_Share_Ultimates, HodorReflexes_Share_MiscUltimates, HodorReflexes_Share_Damage, HodorReflexes_Share_Colos, HodorReflexes_Share_ColosCountdown, HodorReflexes_Share_HornCountdown, HodorReflexes_Share_HornIcon, HodorReflexes_Share_Atronach)
end

function M.LockUI()
	M.uiLocked = true
	M.RefreshVisibility()
	hud.LockControls(HodorReflexes_Share_Ultimates, HodorReflexes_Share_MiscUltimates, HodorReflexes_Share_Damage, HodorReflexes_Share_Colos, HodorReflexes_Share_ColosCountdown, HodorReflexes_Share_HornCountdown, HodorReflexes_Share_HornIcon, HodorReflexes_Share_Atronach)
end

function M.ToggleDamageShare()
	SV.enableDamageShare = not SV.enableDamageShare
	M.ToggleShare()
end

function M.ToggleMiscUltimatesShare()
	SV.enableMiscUltimateShare = not SV.enableMiscUltimateShare
end

function M.ToggleAtronachShare()
	SV.enableAtronachShare = not SV.enableAtronachShare
end

function M.RestorePosition()

	local ultimateLeft = SV.ultimateLeft
	local ultimateTop = SV.ultimateTop

	local miscUltimateLeft = SV.miscUltimateLeft
	local miscUltimateTop = SV.miscUltimateTop

	local damageLeft = SV.damageLeft
	local damageTop = SV.damageTop

	local colosLeft = SV.colosLeft
	local colosTop = SV.colosTop

	local atronachLeft = SV.atronachLeft
	local atronachTop = SV.atronachTop

	local hornCountdownCenterX = SV.hornCountdownCenterX
	local hornCountdownCenterY = SV.hornCountdownCenterY

	local colosCountdownCenterX = SV.colosCountdownCenterX
	local colosCountdownCenterY = SV.colosCountdownCenterY

	local hornIconCenterX = SV.hornIconCenterX
	local hornIconCenterY = SV.hornIconCenterY

	if ultimateLeft or ultimateTop then
		HodorReflexes_Share_Ultimates:ClearAnchors()
		HodorReflexes_Share_Ultimates:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, ultimateLeft, ultimateTop)
	end

	if miscUltimateLeft or miscUltimateTop then
		HodorReflexes_Share_MiscUltimates:ClearAnchors()
		HodorReflexes_Share_MiscUltimates:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, miscUltimateLeft, miscUltimateTop)
	end

	if damageLeft or damageTop then
		HodorReflexes_Share_Damage:ClearAnchors()
		HodorReflexes_Share_Damage:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, damageLeft, damageTop)
	end

	if colosLeft or colosTop then
		HodorReflexes_Share_Colos:ClearAnchors()
		HodorReflexes_Share_Colos:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, colosLeft, colosTop)
	end

	if atronachLeft or atronachTop then
		HodorReflexes_Share_Atronach:ClearAnchors()
		HodorReflexes_Share_Atronach:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, atronachLeft, atronachTop)
	end

	if hornCountdownCenterX or hornCountdownCenterY then
		HodorReflexes_Share_HornCountdown:ClearAnchors()
		HodorReflexes_Share_HornCountdown:SetAnchor(CENTER, GuiRoot, TOPLEFT, hornCountdownCenterX, hornCountdownCenterY)
	end

	if colosCountdownCenterX or colosCountdownCenterY then
		HodorReflexes_Share_ColosCountdown:ClearAnchors()
		HodorReflexes_Share_ColosCountdown:SetAnchor(CENTER, GuiRoot, TOPLEFT, colosCountdownCenterX, colosCountdownCenterY)
	end

	if hornIconCenterX or hornIconCenterY then
		HodorReflexes_Share_HornIcon:ClearAnchors()
		HodorReflexes_Share_HornIcon:SetAnchor(CENTER, GuiRoot, TOPLEFT, hornIconCenterX, hornIconCenterY)
	end
	HodorReflexes_Share_HornIcon:SetScale(SV.hornIconScale)

end

function M.RestoreColors()

	HodorReflexes_Share_HornCountdown_Label:SetColor(unpack(SV.hornCountdownColor))
	HodorReflexes_Share_ColosCountdown_Label:SetColor(unpack(SV.colosCountdownColor))

	HodorReflexes_Share_Ultimates_HornDuration:SetColor(unpack(SW.styleHornColor))
	HodorReflexes_Share_Ultimates_ForceDuration:SetColor(unpack(SW.styleForceColor))
	HodorReflexes_Share_Colos_Duration:SetColor(unpack(SW.styleColosColor))
	HodorReflexes_Share_Atronach_AtronachDuration:SetColor(unpack(SW.styleAtronachColor))
	HodorReflexes_Share_Atronach_BerserkDuration:SetColor(unpack(SW.styleBerserkColor))

	HodorReflexes_Share_Ultimates_HornDuration:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Ultimates_ForceDuration:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Colos_Duration:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Atronach_AtronachDuration:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Atronach_BerserkDuration:SetAlpha(SW.styleZeroTimerOpacity)

	HodorReflexes_Share_Ultimates_HornIcon:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Ultimates_ForceIcon:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Colos_Icon:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Atronach_AtronachIcon:SetAlpha(SW.styleZeroTimerOpacity)
	HodorReflexes_Share_Atronach_BerserkIcon:SetAlpha(SW.styleZeroTimerOpacity)

end

-- Toggle message animations. Update account wide variables if needed.
function M.ToggleAnimations(enabled, updateSW)

	enabled = enabled and true or false

	-- Create timeline only if animations are enabled.
	if enabled and not countdownTimeline then
		countdownTimeline = ANIMATION_MANAGER:CreateTimeline()
		local anim1 = countdownTimeline:InsertAnimation(ANIMATION_SCALE, HodorReflexes_Share_ColosCountdown)
		anim1:SetScaleValues(0.9, 1.1)
		anim1:SetDuration(400)
		anim1:SetEasingFunction(ZO_EaseInOutCubic)
		local anim2 = countdownTimeline:InsertAnimation(ANIMATION_SCALE, HodorReflexes_Share_HornCountdown)
		anim2:SetScaleValues(0.9, 1.1)
		anim2:SetDuration(400)
		anim2:SetEasingFunction(ZO_EaseInOutCubic)
		countdownTimeline:SetPlaybackType(ANIMATION_PLAYBACK_PING_PONG, LOOP_INDEFINITELY)
	end

	if enabled then
		-- Play animations.
		countdownTimeline:SetEnabled(true)
		countdownTimeline:PlayFromStart()
	elseif countdownTimeline then
		-- Stop animations and restore scales.
		countdownTimeline:SetEnabled(false)
		HodorReflexes_Share_ColosCountdown:SetScale(1)
		HodorReflexes_Share_HornCountdown:SetScale(1)
	end

	if updateSW then
		SW.enableAnimations = enabled
	end

end

function M.UltimatesOnMoveStop()

	SV.ultimateLeft = HodorReflexes_Share_Ultimates:GetLeft()
	SV.ultimateTop = HodorReflexes_Share_Ultimates:GetTop()

end

function M.MiscUltimatesOnMoveStop()

	SV.miscUltimateLeft = HodorReflexes_Share_MiscUltimates:GetLeft()
	SV.miscUltimateTop = HodorReflexes_Share_MiscUltimates:GetTop()

end

function M.DamageOnMoveStop()

	SV.damageLeft = HodorReflexes_Share_Damage:GetLeft()
	SV.damageTop = HodorReflexes_Share_Damage:GetTop()

end

function M.ColosOnMoveStop()

	SV.colosLeft = HodorReflexes_Share_Colos:GetLeft()
	SV.colosTop = HodorReflexes_Share_Colos:GetTop()

end

function M.AtronachOnMoveStop()

	SV.atronachLeft = HodorReflexes_Share_Atronach:GetLeft()
	SV.atronachTop = HodorReflexes_Share_Atronach:GetTop()

end

function M.HornCountdownOnMoveStop()

	SV.hornCountdownCenterX, SV.hornCountdownCenterY = HodorReflexes_Share_HornCountdown:GetCenter()

	HodorReflexes_Share_HornCountdown:ClearAnchors()
	HodorReflexes_Share_HornCountdown:SetAnchor(CENTER, GuiRoot, TOPLEFT, SV.hornCountdownCenterX, SV.hornCountdownCenterY)

end

function M.ColosCountdownOnMoveStop()

	SV.colosCountdownCenterX, SV.colosCountdownCenterY = HodorReflexes_Share_ColosCountdown:GetCenter()

	HodorReflexes_Share_ColosCountdown:ClearAnchors()
	HodorReflexes_Share_ColosCountdown:SetAnchor(CENTER, GuiRoot, TOPLEFT, SV.colosCountdownCenterX, SV.colosCountdownCenterY)

end

function M.HornIconOnMoveStop()

	SV.hornIconCenterX, SV.hornIconCenterY = HodorReflexes_Share_HornIcon:GetCenter()

	HodorReflexes_Share_HornIcon:ClearAnchors()
	HodorReflexes_Share_HornIcon:SetAnchor(CENTER, GuiRoot, TOPLEFT, SV.hornIconCenterX, SV.hornIconCenterY)

end

function M.HornIconOnMouseWheel(delta)
	SV.hornIconScale = zo_max(0.5, zo_min(2, SV.hornIconScale + delta * 0.1))
	HodorReflexes_Share_HornIcon:SetScale(SV.hornIconScale)
end

-- Show a random list of players.
local function ToggleTest(players)

	if isTestRunning then
		CleanGroupData(true)
		isTestRunning = false
		M.LockUI()
		d(strformat('|cFF0000%s|r', GetString(HR_TEST_STOPPED)))
		return
	else
		d(strformat('|c00FF00%s|r', GetString(HR_TEST_STARTED)))
		isTestRunning = true
	end

	players = players or {'@WarfireX', '@LikoXie', '@andy.s', '@Alcast', '@NefasQS', '@Wheel5', '@PK44', '@LokiClermeil', '@m00nyONE'}

	local function GetRandomPlayerData(name)
		local dmg = zo_random(500, 1200)
		local playerData = {
			tag = name,
			name = name,
			classId = zo_random() < 0.5 and zo_random(1, 6) or 5, -- 50% chance for necro
			isPlayer = name == GetUnitDisplayName('player'),
			ult = zo_random(1, 500),
			ultType = 0,
			ultTime = time(),
			dmg = dmg,
			dps = dmg * 0.15,
			dmgType = DAMAGE_BOSS,
			dmgTime = time(),
		}
		if playerData.classId == 5 then
			playerData.ultType = ULT_HORN_COLOS
		end
		if playerData.classId == 2 then
			playerData.ultType = ULT_ATRO
		end

		return playerData
	end

	for _, name in ipairs(players) do
		CreateControlsForUser(name, GetRandomPlayerData(name))
	end

	M.UpdateUltimates()
	M.UpdateDamage()

	M.OnHornEffectChanged(0, EFFECT_RESULT_GAINED, 0, 0, 0, GetFrameTimeSeconds(), GetFrameTimeSeconds() + 30, 0, 0, 0, 0, 0, 0, 0, 0, 40224)
	M.OnHornEffectChanged(0, EFFECT_RESULT_GAINED, 0, 0, 0, GetFrameTimeSeconds(), GetFrameTimeSeconds() + 10, 0, 0, 0, 0, 0, 0, 0, 0, 61747)
	M.ColosCast(0, ACTION_RESULT_EFFECT_GAINED)
	M.MajorVulnerability(0, EFFECT_RESULT_GAINED, 0, 0, 0, 0, GetFrameTimeSeconds() + 12)
	M.AtronachCast(0, ACTION_RESULT_EFFECT_GAINED)
	M.MajorBerserk(0, EFFECT_RESULT_GAINED, 0, 0, 0, 0, GetFrameTimeSeconds() + 10)

	M.UnlockUI()

end

SLASH_COMMANDS["/hodor.share"] = function(str)
	local players = zo_strmatch(str, "^test%s*(.*)")
	if players then
		if IsUnitGrouped("player") then
			d(strformat("|cFF0000%s|r", GetString(HR_TEST_LEAVE_GROUP)))
		else
			ToggleTest(IsValidString(players) and {zo_strsplit(" ", players)})
		end
	end
end

RuESO_doubleNamesNPC = nil -- disable RuESO double names, because it breaks CMX boss detection