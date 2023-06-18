local LCA = LibCombatAlerts

CombatAlerts = {
	name = "CombatAlerts",

	title = "Combat Alerts",
	version = "1.16.1",

	slashCommand = "/cca",

	-- Default settings
	defaults = {
		panelLeft = 400,
		panelTop = 300,
		nearbyLeft = 1200,
		nearbyTop = 300,
		nearbyEnabled = false,
		debugEnabled = false,
		debugLog = { },
		crushing = false,
		lokiStance = false,
		maxCastMS = 4000,
		projectileTimingAdjustment = 0.8,
		castAlertsEnabled = true,
		castAlertsSound = true,
		verboseCasts = false,
		crshift = true,
		extTDC = false,
		extMA = false,
		dsrPortSounds = false,
		dsrDelugeBlame = false,
		dsrShowWave = false,
	},

	pollingInterval = 100, -- 0.1 seconds
	castUpdateInterval = 50, -- 0.05 seconds, 20 FPS
	bannerUpdateInterval = 75, -- 0.075 seconds
	panelRows = 3,
	nearbyRows = 2,

	dodgeDuration = GetAbilityDuration(28549),
	dodgeText = "Dodge!",
	incomingText = GetString(SI_INTERFACE_OPTIONS_COMBAT_SCT_INCOMING_ENABLED),

	zoneId = 0,
	isVet = false,
	isDamage = false,
	isHealer = false,
	isTank = false,
	initialized = false,
	listening = false,
	continuousListen = false,
	units = { },
	bosses = { },

	divertNextEvent = nil,

	currentBoss = "",

	castAlerts = {
		nextId = 0,
		fillWidth = 200,
		bars = { },
		active = { },
		sources = { },
		polling = false,
	},

	activeBanners = { },

	guardUnit = nil,

	maelstrom = {
		lastObelisk = 0,
	},

	maw = {
		enabled = false,
		smashes = { },
	},

	hof = {
		shockTargets = { },
		feedback = {
			shieldTime = 0,
			launchTime = 0,
			travelTime = 0,
			strength = 0,
			abilityId = 0,
			alert = false,
		},
		overchargeHealth = { },
		overchargeTether = { },
	},

	scalecaller = {
		blastAll = 0,
		blastId = 0,
	},

	fanglair = {
		tigerId = 0,
		nextGrip = 0,
	},

	cloudrest = {
		shadowRealm = false,
		executeStart = 0,
		banefulPrev = 0,
		banefulCast = 0,
		zmajaTaunt = 0,
		lastCharge = 0,
		flare = {
			previous = 0,
			stop = 0,
			units = { },
			preyed = { },
			switcher = "",
		},
	},

	march = {
		lastMechanic = 0,
	},

	brp = {
		spirits = 0,
	},

	frostvault = {
		effluviumEnd = 0,
		skeevCharged = 0,
		skeevMode = false,
	},

	sunspire = {
		lokiGrounded = false,
		tomb = 0, -- 0: inactive, 1: casting, 2: activating, 3: active, 4: between casts
		tombPrev = 0,
		tombNext = 0,
		tombId = 0,
		tombActive = 0,
		tombDeadline = 0,
		tombText = "",
		tombTextNext = "",
		atroNext = 0,
		breathPrev = 0,
		breathInitial = false,
		bottomActive = false,
		translation = 0, -- 1: initial 2s, 2: interrupt, 3: between casts
		translationNext = 0,
		translationDeadline = 0,
		lastFocusFire = 0,
		lastSoulTear = 0,
		battleFury = { },
	},

	fane = {
		geyserActive = false,
		geyserDuration = 22000,
		nextGeyserEnd = 0,
		lastGeyserEnd = 0,
		lastGeyserPlug = 0,
		direMawId = 0,
		spawns = { },
	},

	maarselok = {
		lastSeed = 0,
		wickedBonds = nil,
		shagraths = { },
	},

	ka = {
		leaperMonitor = false,
		meteor = {
			units = { },
		},
		ichor = {
			endTime = 0,
			counter = 0,
		},
		panelMode = 0,
		lastHarpoon = 0,
		chains = 0,
		groundIchor = {
			result = 0,
			abilityId = 0,
		},
	},

	stonethorn = {
		memoryGame = {
			enabled = false,
			idx = 1,
			ids = { 0, 0, 0, 0 },
			disembowel = 0,
		},
	},

	rg = {
		astralShields = 0,
	},

	wf = {
		lastWall = 0,
	},

	tide = {
		bombs = { },
		link1 = "",
	},

	dsr = {
		panel = true,
		multi = {
			previous = 0,
			count = 0,
			id = -1,
		},
		brands = {
			fire = { },
			frost = { },
		},
		wave = {
			stop = 0,
			targeted = false,
		},
		deluge = {
			units = { },
		},
		delugePrevErup = 0,
		guardians = {
			hearts = 0,
			units = { },
			statuses = { },
		},
		bridge = {
			channels = { },
			units = { },
		},
		maelstrom = {
			prev = 0,
			duration = 0,
		},
		stormEnd = 0,
		stormIcon = "",
	},

	ld = {
		soul1 = "",
		orbs = { ids = {} },
		orbCooldown = 0,
	},

	u37 = {
		choking = 0,
		bash = 0,
		darklight = { },
		hellfire = { },
		meteor = {
			unitId = -1,
			alertId = -1,
		},
	},

	u38 = {
		bombs = { },
		lastInferno = 0,
	},
}

local function OnAddOnLoaded( eventCode, addonName )
	if (addonName ~= CombatAlerts.name) then return end

	EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_ADD_ON_LOADED)

	CombatAlerts.vars = ZO_SavedVars:NewAccountWide("CombatAlertsSavedVariables", 1, nil, CombatAlerts.defaults, nil, "$InstallationWide")

	SLASH_COMMANDS[CombatAlerts.slashCommand] = CombatAlerts.HandleSlashCommand

	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_PLAYER_ACTIVATED, CombatAlerts.PlayerActivated)
	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_RAID_TRIAL_STARTED, CombatAlerts.OnRaidTrialStarted)
	EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_RAID_TRIAL_COMPLETE, CombatAlerts.OnRaidTrialComplete)
end

LCA.RunAfterInitialLoadscreen(function( )
	RedirectTexture("/CombatAlerts/art/arrow-cw.dds", LCA.GetTexture("arrow-cw"))
	RedirectTexture("/CombatAlerts/art/arrow-ccw.dds", LCA.GetTexture("arrow-ccw"))
end)

local function UnpackRGBA( rgba )
	local a = rgba % 256
	rgba = (rgba - a) / 256
	local b = rgba % 256
	rgba = (rgba - b) / 256
	local g = rgba % 256
	rgba = (rgba - g) / 256
	local r = rgba % 256

	return r / 255, g / 255, b / 255, a / 255
end

function CombatAlerts.HandleSlashCommand( command )
	command = string.lower(command)

	if (command == "move") then
		CombatAlerts.ToggleTestPanel(true)
	elseif (command == "nearby") then
		CombatAlerts.vars.nearbyEnabled = not CombatAlerts.vars.nearbyEnabled
		CombatAlerts.ToggleNearby(CombatAlerts.vars.nearbyEnabled)
	elseif (command == "crushing") then
		CombatAlerts.vars.crushing = not CombatAlerts.vars.crushing
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] %s: %s",
			CombatAlerts.title,
			CombatAlertsData.cloudrest.crushingName,
			GetString(CombatAlerts.vars.crushing and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "casts") then
		CombatAlerts.vars.castAlertsEnabled = not CombatAlerts.vars.castAlertsEnabled
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cast Alerts: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.castAlertsEnabled and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "castsounds") then
		CombatAlerts.vars.castAlertsSound = not CombatAlerts.vars.castAlertsSound
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cast Alert Sounds: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.castAlertsSound and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "lokistance") then
		CombatAlerts.vars.lokiStance = not CombatAlerts.vars.lokiStance
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Lokkestiiz Defensive Stance: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.lokiStance and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "crshift") then
		CombatAlerts.vars.crshift = not CombatAlerts.vars.crshift
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Cloudrest Shifting Shadows Cone: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.crshift and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "vma") then
		CombatAlerts.vars.extMA = not CombatAlerts.vars.extMA
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Maelstrom Extensions: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.extMA and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "tdcext") then
		CombatAlerts.vars.extTDC = not CombatAlerts.vars.extTDC
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Magma Incarnate Catastrophe: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.extTDC and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "dsrportsounds") then
		CombatAlerts.vars.dsrPortSounds = not CombatAlerts.vars.dsrPortSounds
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Dreadsail twins teleport position sounds: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.dsrPortSounds and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "dsrdelugeblame") then
		CombatAlerts.vars.dsrDelugeBlame = not CombatAlerts.vars.dsrDelugeBlame
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Dreadsail deluge blame: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.dsrDelugeBlame and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	elseif (command == "dsrshowwave") then
		CombatAlerts.vars.dsrShowWave = not CombatAlerts.vars.dsrShowWave
		CHAT_ROUTER:AddSystemMessage(string.format(
			"[%s] Dreadsail verbose Crashing Wave: %s",
			CombatAlerts.title,
			GetString(CombatAlerts.vars.dsrShowWave and SI_CHECK_BUTTON_ON or SI_CHECK_BUTTON_OFF)
		))
	else
		CHAT_ROUTER:AddSystemMessage(CombatAlerts.title)
		CHAT_ROUTER:AddSystemMessage("/cca move – Move status display")
		CHAT_ROUTER:AddSystemMessage("/cca nearby – Toggle the Nearby Players panel")
		CHAT_ROUTER:AddSystemMessage("/cca casts – Enable/Disable Cast Alerts")
		CHAT_ROUTER:AddSystemMessage("/cca castsounds – Enable/Disable Cast Alert Sounds")
		CHAT_ROUTER:AddSystemMessage("/cca crushing – Toggle Crushing Darkness alert aura")
		CHAT_ROUTER:AddSystemMessage("/cca crshift – Toggle Shifting Shadows dodge timer")
		CHAT_ROUTER:AddSystemMessage("/cca vma – Toggle Maelstrom Arena extensions")
		CHAT_ROUTER:AddSystemMessage("/cca dsrportsounds – Toggle Dreadsail twins teleport position sounds")
	end
end

function CombatAlerts.PlayerActivated( eventCode, initial )
	CombatAlerts.zoneId = GetZoneId(GetUnitZoneIndex("player"))
	CombatAlerts.isVet = GetCurrentZoneDungeonDifficulty() == DUNGEON_DIFFICULTY_VETERAN

	if (not CombatAlerts.initialized) then
		CombatAlerts.initialized = true

		CombatAlerts.InitializeUI()
		CombatAlerts.CheckLegacy()

		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_PLAYER_COMBAT_STATE, CombatAlerts.PlayerCombatState)

		if (IsUnitInCombat("player")) then
			CombatAlerts.PlayerCombatState(nil, true)
		end

		CombatAlerts.ToggleNearby(CombatAlerts.vars.nearbyEnabled)
		CombatAlerts.InitializeDSRPanel()
	end

	if (CombatAlertsData.bossCheckZoneIds[CombatAlerts.zoneId]) then
		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_BOSSES_CHANGED, CombatAlerts.BossesChanged)
		CombatAlerts.currentBoss = ""
		CombatAlerts.BossesChanged()
	else
		CombatAlerts.BossesChanged()
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_BOSSES_CHANGED)
	end

	if (CombatAlerts.zoneId ~= CombatAlertsData.ka.zone) then
		CombatAlerts.KynesLeaperMonitor(false)
	end

	CombatAlerts.ThornMemoryGame(CombatAlerts.isVet and CombatAlerts.zoneId == CombatAlertsData.stonethorn.memoryGame.zoneId)
end

function CombatAlerts.PlayerCombatState( eventCode, inCombat )
	if (inCombat) then
		CombatAlerts.StartListening()
	else
		-- Avoid false positives of combat end, often caused by combat rezzes
		zo_callLater(function() if (not IsUnitInCombat("player")) then CombatAlerts.StopListening() end end, 3000)
	end
end

function CombatAlerts.StartListening( )
	if (not CombatAlerts.listening) then
		CombatAlerts.listening = true
		CombatAlerts.castAlerts.sources = { }
		CombatAlerts.sunspire.tombId = 0
		CombatAlerts.maarselok.wickedBonds = nil
		CombatAlerts.maarselok.shagraths = { }
		CombatAlerts.hof.overchargeHealth = { }
		CombatAlerts.hof.overchargeTether = { }

		if (CombatAlerts.zoneId == CombatAlertsData.ka.zone and string.find(string.lower(GetUnitName("boss1")), CombatAlertsData.ka.vrolName)) then
			CombatAlerts.ka.lastHarpoon = GetGameTimeMilliseconds()
			CombatAlerts.ka.panelMode = 1
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(CombatAlertsData.ka.shockingHarpoon), true, true)
		end

		EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_COMBAT_EVENT, CombatAlerts.CombatEvent)

		if (CombatAlertsData.effectTrackingZoneIds[CombatAlerts.zoneId]) then
			CombatAlerts.units = { }
			CombatAlerts.bosses = { }
			EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_EFFECT_CHANGED, CombatAlerts.EffectChanged)
		end
	end

	CombatAlerts.isDamage, CombatAlerts.isHealer, CombatAlerts.isTank = GetPlayerRoles()
end

function CombatAlerts.StopListening( )
	if (CombatAlerts.listening and not CombatAlerts.continuousListen) then
		CombatAlerts.listening = false
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_COMBAT_EVENT)
		EVENT_MANAGER:UnregisterForEvent(CombatAlerts.name, EVENT_EFFECT_CHANGED)

		if (CombatAlerts.panel.autoHide) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
		CombatAlerts.AlertBorder(false)
	end
end

function CombatAlerts.ToggleContinuousListen( enable )
	if (enable) then
		CombatAlerts.continuousListen = true
		CombatAlerts.StartListening()
	else
		CombatAlerts.continuousListen = false
		CombatAlerts.PlayerCombatState(nil, false)
	end
end

function CombatAlerts.OnCombatEvent( ... )
	-- eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId, overflow
end

local function ValidUnit( unitId )
	return unitId and unitId ~= 0
end

function CombatAlerts.CombatEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (CombatAlerts.divertNextEvent) then
		local fn = CombatAlerts.divertNextEvent
		CombatAlerts.divertNextEvent = nil
		if (fn(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)) then
			return
		end
	end


	-- Perfect Roll ------------------------------------------------------------

	if (result == ACTION_RESULT_BEGIN and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.dodge.ids[abilityId]) then
		local options = CombatAlertsData.dodge.ids[abilityId]
		if (CombatAlerts.isVet or not options.vet) then
			local offset = options.offset or 0
			local id = CombatAlerts.AlertCast(abilityId, sourceName, hitValue + offset, options)
			if (options[3] and ValidUnit(sourceUnitId)) then
				CombatAlerts.castAlerts.sources[sourceUnitId] = id
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and targetType == COMBAT_UNIT_TYPE_PLAYER and sourceType ~= COMBAT_UNIT_TYPE_PLAYER and abilityId > 100000 and hitValue >= 1000 and CombatAlerts.vars.verboseCasts) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -1, 0, false, { 1, 1, 1, 0.2 }, { 1, 1, 1, 0.4 } })
		CombatAlerts.AlertChat(LocalizeString("<<t:1>> [<<2>>] (<<3>>ms) from <<4>>", GetAbilityName(abilityId), abilityId, hitValue, sourceName))
	elseif (CombatAlertsData.dodge.interrupts[result] and CombatAlerts.castAlerts.sources[targetUnitId]) then
		CombatAlerts.CastAlertsStop(CombatAlerts.castAlerts.sources[targetUnitId])


	-- Guard Tracking ----------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.general.guard and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.guardUnit = targetUnitId
	elseif (result == ACTION_RESULT_EFFECT_FADED and abilityId == CombatAlertsData.general.guard and targetUnitId == CombatAlerts.guardUnit) then
		CombatAlerts.guardUnit = nil


	-- Misc --------------------------------------------------------------------
	elseif (result == ACTION_RESULT_BEGIN and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.misc.shadowStrike.id and hitValue == CombatAlertsData.misc.shadowStrike.channel) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue + CombatAlertsData.misc.shadowStrike.cast, { -2, 2 })

	-- Maelstrom Arena ---------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.webspinner and hitValue == 0) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC00FFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.ghost and hitValue == 0 and CombatAlerts.vars.extMA) then
		CombatAlerts.Alert(nil, "GHOST", 0xFFD700FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.turretoccupied and hitValue == 0 and CombatAlerts.vars.extMA) then
		CombatAlerts.Alert(nil, "SENTRY", 0xCD7F32FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.troll and CombatAlerts.vars.extMA) then
		CombatAlerts.Alert(nil, "TROLL", 0xFFFFFFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.enrage and CombatAlerts.vars.extMA) then
		CombatAlerts.Alert(nil, "ENRAGE", 0xC21E56FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.hoarvor and CombatAlerts.vars.extMA) then
		CombatAlerts.Alert(nil, "HOARVOR", 0x006400FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maelstrom.artifacts and CombatAlerts.vars.extMA) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.maelstrom.lastObelisk >= 3000) then
			CombatAlerts.maelstrom.lastObelisk = currentTime
			CombatAlerts.Alert(nil, "OBELISK", 0xFFD700FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
		end


	-- Maw of Lorkhaj ----------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.maw.curseProjectile and hitValue > 500) then
		CombatAlerts.AlertCast(CombatAlertsData.maw.curseEffect, nil, hitValue, { 0, 0, false, { 1, 0, 0.6, 0.8 } })
		local distance = CombatAlerts.GetClosestGroupMember()
		if (distance >= 0 and distance < 3.1) then
			PlaySound(SOUNDS.DUEL_START)
		end


	-- Halls of Fabrication ----------------------------------------------------

	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.hof.standingInAoe[abilityId]) then
		local params = CombatAlertsData.hof.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.hof.centurionAwaken) then
		if (CombatAlerts.hof.shockTargets[targetUnitId] and GetGameTimeMilliseconds() - CombatAlerts.hof.shockTargets[targetUnitId] <= 4000) then
			CombatAlerts.hof.shockTargets[targetUnitId] = nil
			CombatAlerts.Alert(nil, "Spinner Awaken", 0x66CCFFFF, SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
		elseif (CombatAlerts.isTank) then
			CombatAlerts.Alert(nil, "Steamer Awaken", 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.hof.centurionShockTarget) then
		CombatAlerts.hof.shockTargets[targetUnitId] = GetGameTimeMilliseconds()
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.hof.shockAura and hitValue == 1) then
		CombatAlerts.Alert(nil, CombatAlertsData.hof.shockFieldName, 0x66CCFFFF, SOUNDS.DUEL_START, 1500)
	elseif (abilityId == CombatAlertsData.hof.feedback or abilityId == CombatAlertsData.hof.feedbackShield) then
		CombatAlerts.HallsFeedbackEvent(eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId)
	elseif (abilityId == CombatAlertsData.hof.gore and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		local id = "hofpurgeables"
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.ScreenBorderEnable(0xFFDD0066, nil, id)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.ScreenBorderDisable(id)
		end
	elseif (abilityId == CombatAlertsData.hof.overchargeHealth) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.hof.overchargeHealth[targetUnitId] = hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.hof.overchargeHealth[targetUnitId] = 0
		end
	elseif (abilityId == CombatAlertsData.hof.overchargeTether) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.hof.overchargeTether[targetUnitId] = hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.hof.overchargeTether[targetUnitId] = 0
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.hof.fireWhirl) then
		local stacks = (CombatAlerts.hof.overchargeHealth[targetUnitId] or 0) + (CombatAlerts.hof.overchargeTether[targetUnitId] or 0)
		if (stacks > 0) then
			CombatAlerts.Alert(CombatAlerts.incomingText, string.format(CombatAlertsData.hof.fireWhirlEmpoweredText, stacks), 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
		end


	-- Scalecaller Peak --------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.scalecaller.blastIds[abilityId]) then
		if (GetGameTimeMilliseconds() - CombatAlerts.scalecaller.blastAll >= 2500) then
			CombatAlerts.scalecaller.blastId = abilityId
			CombatAlerts.divertNextEvent = CombatAlerts.ScalecallerBreathEvent
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.scalecaller.beamId and hitValue == 3000) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)


	-- Fang Lair ---------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.fanglair.grip) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.fanglair.tigerId = targetUnitId
			CombatAlerts.FangLairResetTimer(CombatAlertsData.fanglair.interval)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.fanglair.tigerId = 0
		end
	elseif (abilityId == CombatAlertsData.fanglair.stare) then
		if (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.FangLairResetTimer(CombatAlertsData.fanglair.interval)
		elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlerts.vars.debugEnabled) then
			CombatAlerts.Debug(string.format("Tiger Pounce: %dms deviation from expectation", GetGameTimeMilliseconds() - CombatAlerts.fanglair.nextGrip))
		end
	elseif (result == ACTION_RESULT_FEARED and abilityId == CombatAlertsData.fanglair.fear) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlertsData.fanglair.grip), targetName, 0xFF00CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.fanglair.dormant and targetUnitId == CombatAlerts.fanglair.tigerId) then
		CombatAlerts.FangLairResetTimer(hitValue)


	-- Cloudrest ---------------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_FADED and abilityId == CombatAlertsData.cloudrest.amulet) then
		CombatAlerts.cloudrest.executeStart = GetGameTimeMilliseconds()
		CombatAlerts.cloudrest.banefulPrev = CombatAlerts.cloudrest.executeStart
		CombatAlerts.TogglePanel(true, { CombatAlertsData.cloudrest.banefulName, CombatAlertsData.cloudrest.flareName }, true, true)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.baneful) then
		CombatAlerts.cloudrest.banefulPrev = GetGameTimeMilliseconds()
		CombatAlerts.cloudrest.banefulCast = hitValue
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.cloudrest.flare[abilityId]) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.cloudrest.flare.previous >= 1000) then
			CombatAlerts.cloudrest.flare.previous = currentTime
			CombatAlerts.cloudrest.flare.units[1] = targetUnitId
		else
			CombatAlerts.cloudrest.flare.stop = currentTime + CombatAlertsData.cloudrest.flareDuration
			CombatAlerts.cloudrest.flare.units[2] = targetUnitId

			CombatAlerts.cloudrest.flare.switcher = ""

			if ( CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]] and CombatAlerts.units[targetUnitId] and
			     CombatAlerts.GetDistance(CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]].tag, CombatAlerts.units[targetUnitId].tag) < 7 ) then
				local switcherUnitId = targetUnitId

				if (abilityId ~= CombatAlertsData.cloudrest.flare.execute or GetGroupMemberSelectedRole(CombatAlerts.units[targetUnitId].tag) == LFG_ROLE_HEAL) then
					switcherUnitId = CombatAlerts.cloudrest.flare.units[1]
				end

				CombatAlerts.cloudrest.flare.switcher = string.format(" (%s)", CombatAlerts.units[switcherUnitId].name)
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.sparkles and GetGameTimeMilliseconds() <= CombatAlerts.cloudrest.zmajaTaunt) then
		zo_callLater(function() CombatAlerts.Alert(CombatAlerts.incomingText, "Sparkles", 0x66CCFFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000) end, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.beadCharge and not CombatAlerts.cloudrest.shadowRealm) then
		CombatAlerts.cloudrest.lastCharge = GetGameTimeMilliseconds()
		CombatAlerts.Alert(nil, "Malicious Sphere Charge", 0xFF0033FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.cloudrest.beadSpawn and not CombatAlerts.cloudrest.shadowRealm) then
		if (GetGameTimeMilliseconds() - CombatAlerts.cloudrest.lastCharge > 2000) then
			CombatAlerts.Alert(CombatAlerts.incomingText, CombatAlertsData.cloudrest.beadName, 0xFF0033FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.cloudrest.shiftShadows.start and CombatAlerts.vars.crshift) then
		local id = CombatAlerts.AlertCast(CombatAlertsData.cloudrest.shiftShadows.name, nil, hitValue, { 500, 0, false, { 0.7, 0.3, 1, 0.3 }, { 0.7, 0.3, 1, 0.7 } })
		if (ValidUnit(targetUnitId)) then
			CombatAlerts.castAlerts.sources[targetUnitId] = id
		end
	elseif (result == ACTION_RESULT_STUNNED and abilityId == CombatAlertsData.cloudrest.shiftShadows.stop and CombatAlerts.castAlerts.sources[targetUnitId]) then
		CombatAlerts.CastAlertsStop(CombatAlerts.castAlerts.sources[targetUnitId])
	elseif (CombatAlerts.vars.crushing and result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.cloudrest.crushing and GetGameTimeMilliseconds() > CombatAlerts.cloudrest.zmajaTaunt) then
		CombatAlerts.AlertBorder(true, 10000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.cloudrest.overload) then
		CombatAlerts.AlertBorder(true, hitValue, "blue")
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.cloudrest.shadowRealm[abilityId]) then
		CombatAlerts.cloudrest.shadowRealm = true
		CombatAlerts.AlertBorder(false)
	elseif (result == ACTION_RESULT_EFFECT_FADED and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.cloudrest.shadowRealm[abilityId]) then
		CombatAlerts.cloudrest.shadowRealm = false
	elseif (result == ACTION_RESULT_DIED and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertBorder(false)


	-- March of Sacrifices -----------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.march.fireId) then
		local _, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
		if (effectiveMax >= CombatAlertsData.march.hardHealth) then
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -3, 1 })
		end
	elseif ((result == ACTION_RESULT_BEGIN or result == ACTION_RESULT_EFFECT_GAINED_DURATION) and CombatAlertsData.march[abilityId]) then
		if (GetGameTimeMilliseconds() - CombatAlerts.march.lastMechanic >= 3000) then
			CombatAlerts.march.lastMechanic = GetGameTimeMilliseconds()

			local mechanic = CombatAlertsData.march[CombatAlertsData.march[abilityId]]
			CombatAlerts.Alert(nil, mechanic.name, mechanic.color, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
		end


	-- Moon Hunter Keep --------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.moonhunter.root) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 1 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.moonhunter.pounce) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 2 })
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.moonhunter.switch) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3366FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)


	-- Blackrose Prison --------------------------------------------------------

	elseif ((result == ACTION_RESULT_EFFECT_GAINED or result == ACTION_RESULT_EFFECT_GAINED_DURATION) and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.brp.roots[abilityId] and hitValue == CombatAlertsData.brp.roots.duration) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 1 })
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.brp.spirit.increments[abilityId] and hitValue == 1) then
		CombatAlerts.brp.spirits = CombatAlerts.brp.spirits + 1
		CombatAlerts.BlackroseSpiritUpdatePanel()
	elseif (result == ACTION_RESULT_EFFECT_FADED and abilityId == CombatAlertsData.brp.spirit.golden) then
		CombatAlerts.brp.spirits = CombatAlerts.brp.spirits - 1
		CombatAlerts.BlackroseSpiritUpdatePanel()
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.brp.spirit.ignition) then
		CombatAlerts.brp.spirits = 0
		CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), false, true)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.brp.spirit.scream) then
		zo_callLater(function() CombatAlerts.TogglePanel(false) end, hitValue)


	-- Frostvault --------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.frostvault.effluvium) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.frostvault.effluviumEnd = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
			if (CombatAlerts.frostvault.skeevMode) then
				CombatAlerts.frostvault.skeevMode = false
				CombatAlerts.panel.label:SetText(GetFormattedAbilityName(abilityId))
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.frostvault.effluviumEnd = GetGameTimeMilliseconds()
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.frostvault.ignitionIds[abilityId]) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), GetFormattedAbilityName(CombatAlertsData.frostvault.embers), 0xFF6600FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.frostvault.grind) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.AlertCast(abilityId, sourceName, 2700, { 1200, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		else
			local _, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
			if (effectiveMax >= CombatAlertsData.frostvault.hardHealth) then
				CombatAlerts.AlertCast(CombatAlertsData.frostvault.whipping, nil, 1600, { 500, 2, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
			end
		end
	elseif (not CombatAlerts.frostvault.skeevMode and result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.frostvault.skeevCharged) then
		CombatAlerts.frostvault.skeevMode = true
		CombatAlerts.frostvault.skeevCharged = GetGameTimeMilliseconds()
		CombatAlerts.panel.label:SetText(GetFormattedAbilityName(CombatAlertsData.frostvault.skeevWipe))
		CombatAlerts.panel.data:SetColor(1, 1, 1, 1)


	-- Depths of Malatar -------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.malatar.decrepify and not CombatAlerts.isTank) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xFFCC00FF, SOUNDS.OBJECTIVE_DISCOVERED, 2500)


	-- Sunspire -------------------------------------------------------

	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.sunspire.standingInAoe[abilityId]) then
		local params = CombatAlertsData.sunspire.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.tomb) then
		local currentTime = GetGameTimeMilliseconds()
		local elapsed = currentTime - CombatAlerts.sunspire.tombPrev
		if ((elapsed >= 60000 and CombatAlerts.sunspire.tombId ~= 1) or elapsed >= 70000) then
			CombatAlerts.sunspire.tombId = 0
		end

		CombatAlerts.sunspire.tombText = string.format("%s #%d", GetFormattedAbilityName(abilityId), CombatAlerts.sunspire.tombId + 1)
		CombatAlerts.sunspire.tombId = (CombatAlerts.sunspire.tombId + 1) % 3
		CombatAlerts.sunspire.tombTextNext = string.format("%s #%d", GetFormattedAbilityName(abilityId), CombatAlerts.sunspire.tombId + 1)
		CombatAlerts.sunspire.lokiGrounded = true

		CombatAlerts.Alert(nil, CombatAlerts.sunspire.tombText, 0xFF00FFFF, SOUNDS.OBJECTIVE_DISCOVERED, 3000)
		CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombText)

		CombatAlerts.sunspire.tombState = 1
		CombatAlerts.sunspire.tombPrev = currentTime
		CombatAlerts.sunspire.tombNext = currentTime + 23000
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.negate) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF00FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.ignite) then
		CombatAlerts.Alert("Flame Atronach", GetFormattedAbilityName(abilityId), 0x0066FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.geyser and not CombatAlerts.isTank) then
		if (GetGameTimeMilliseconds() < CombatAlerts.sunspire.lastFocusFire + 90000) then
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x0099CCFF, SOUNDS.DUEL_START, hitValue)
			elseif (CombatAlerts.DistanceCheck(targetUnitId, 2.7)) then
				CombatAlerts.Alert(CombatAlerts.units[targetUnitId].name, GetFormattedAbilityName(abilityId), 0x0099CCFF, SOUNDS.DUEL_START, hitValue)
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and targetType ~= COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.sunspire.glacialFist) then
		if (CombatAlerts.DistanceCheck(targetUnitId, 4)) then
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.focusFire) then
		CombatAlerts.sunspire.lastFocusFire = GetGameTimeMilliseconds()
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.isHealer) and CombatAlertsData.sunspire.breathIds[abilityId]) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.sunspire.breathPrev >= 6000) then
			CombatAlerts.sunspire.breathPrev = currentTime
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				targetName = CombatAlerts.incomingText
				CombatAlerts.sunspire.breathInitial = true
			elseif (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
				CombatAlerts.sunspire.breathInitial = false
			end
			CombatAlerts.Alert(targetName, GetFormattedAbilityName(abilityId), 0xEECC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		elseif (CombatAlerts.sunspire.breathInitial) then
			CombatAlerts.sunspire.breathInitial = false
			CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 1, 0, 0.6, 0.6 }, { 1, 0, 0.6, 1 } })
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.soulTear) then
		CombatAlerts.sunspire.lastSoulTear = GetGameTimeMilliseconds()
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId) .. " — Heal!", 0x9933FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.sunspire.thrash) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Block or Dodge", 0xFF0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0 })
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.sunspire.sweepingIds[abilityId] and hitValue < 2500) then
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Block — " .. CombatAlertsData.sunspire.sweepingIds[abilityId], 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 3000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.sunspire.meteor) then
		CombatAlerts.Alert(nil, CombatAlertsData.sunspire.meteorName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		CombatAlerts.CastAlertsStart(CombatAlertsData.sunspire.meteorIcon, CombatAlertsData.sunspire.meteorName, hitValue, nil, nil, { hitValue, "Move!", 1, 0.4, 0, 0.5, nil })
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.sunspire.battleFury) then
		CombatAlerts.sunspire.battleFury[targetUnitId] = GetGameTimeMilliseconds() + hitValue
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.sunspire.chillingComet) then
		local currentTime = GetGameTimeMilliseconds()
		local enrageTime = CombatAlerts.sunspire.battleFury[sourceUnitId] or 0
		if (currentTime < enrageTime or currentTime < CombatAlerts.sunspire.lastSoulTear + 8000) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x33CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2500)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.sunspire.summonFrost) then
		CombatAlerts.sunspire.atroNext = GetGameTimeMilliseconds() + 90000
	elseif (abilityId == CombatAlertsData.sunspire.icyPresence) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.sunspire.lokiGrounded = true
			CombatAlerts.sunspire.atroNext = 0
			CombatAlerts.sunspire.tombState = 0
			CombatAlerts.sunspire.tombActive = 0
			CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(CombatAlertsData.sunspire.tomb), GetFormattedAbilityName(CombatAlertsData.sunspire.summonFrost) }, true, true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.lokiGrounded = false
		end
	elseif (abilityId == CombatAlertsData.sunspire.timeBreach and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.sunspire.bottomActive = true
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.bottomActive = false
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (abilityId == CombatAlertsData.sunspire.translation) then
		if (result == ACTION_RESULT_BEGIN and hitValue == 2000) then
			CombatAlerts.sunspire.translation = 1
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
		elseif (result == ACTION_RESULT_BEGIN and hitValue == 5000) then
			CombatAlerts.sunspire.translation = 2
			CombatAlerts.sunspire.translationDeadline = GetGameTimeMilliseconds() + hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.sunspire.translation = 3
			CombatAlerts.sunspire.translationNext = GetGameTimeMilliseconds() + 20000
		end
	elseif (CombatAlerts.vars.lokiStance and CombatAlerts.zoneId == CombatAlertsData.sunspire.zone and abilityId == CombatAlertsData.sunspire.defensiveStance and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end


	-- Moongrave Fane ----------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.rockslide) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xEECC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (abilityId == CombatAlertsData.fane.geyser) then
		if (result == ACTION_RESULT_BEGIN) then
			if (hitValue <= 5000) then
				CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Stop Damage", 0xFF0000FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
				if (not CombatAlerts.panel.enabled) then
					CombatAlerts.fane.nextGeyserEnd = 0
					CombatAlerts.fane.lastGeyserEnd = 0
				end
				local currentTime = GetGameTimeMilliseconds()
			else
				CombatAlerts.fane.geyserActive = true
				CombatAlerts.fane.geyserDuration = hitValue
				CombatAlerts.fane.lastGeyserPlug = 0
				CombatAlerts.fane.nextGeyserEnd = GetGameTimeMilliseconds() + hitValue
				CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(abilityId), GetFormattedAbilityName(CombatAlertsData.fane.geyserPlug) }, true, true)
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.fane.geyserActive = false
			CombatAlerts.fane.lastGeyserEnd = GetGameTimeMilliseconds()
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), "Resume Damage", 0x00FF00FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.geyserPlug and CombatAlerts.isVet) then
		local currentTime = GetGameTimeMilliseconds()
		CombatAlerts.AlertChat(string.format(
			"%s: %d%s",
			GetFormattedAbilityName(abilityId),
			hitValue,
			(hitValue > 1) and string.format(" (+%dms)", currentTime - CombatAlerts.fane.lastGeyserPlug) or ""
		))
		CombatAlerts.fane.lastGeyserPlug = currentTime
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.shackles) then
		PlaySound(SOUNDS.CHAMPION_POINTS_COMMITTED)
	elseif (abilityId == CombatAlertsData.fane.drain and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.wound and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertChat(LocalizeString("|c3399FF<<1>>|r applied |cCC0000<<t:2>>|r", sourceName, GetAbilityName(abilityId)))
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.fane.megabat) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC0044FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.fane.spawn and hitValue == 1 and CombatAlerts.zoneId == CombatAlertsData.fane.zone and CombatAlerts.isTank) then
		if (string.find(string.lower(GetUnitName("boss1")), "grundwulf")) then
			local current, _, effectiveMax = GetUnitPower("boss1", POWERTYPE_HEALTH)
			local health = current / effectiveMax
			if (health < 0.8) then
				CombatAlerts.fane.direMawId = targetUnitId
				CombatAlerts.fane.spawns[targetUnitId] = health
				local spawnDireMaw = function( )
					if (CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId]) then
						CombatAlerts.Debug(string.format("Hollowfang Dire-Maw spawned at %.1f%%", CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId] * 100))
						CombatAlerts.fane.spawns[CombatAlerts.fane.direMawId] = nil
						CombatAlerts.Alert(CombatAlerts.incomingText, "Hollowfang Dire-Maw", 0x0099CCFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
					end
				end
				zo_callLater(spawnDireMaw, 50)
			end
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.fane.spawnFilters[abilityId] and CombatAlerts.isTank) then
		CombatAlerts.fane.spawns[targetUnitId] = nil


	-- Lair of Maarselok -------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.unrelenting4) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { 0, 0, false, { 1, 0, 0.6, 0.8 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.unrelenting5) then
		CombatAlerts.AlertCast(abilityId, nil, 3100, { 700, 0, false, { 0.3, 0.9, 1, 0.3 }, { 0, 0.5, 1, 0.6 } })
	elseif (abilityId == CombatAlertsData.maarselok.bonds) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.maarselok.wickedBonds = CombatAlertsData.maarselok.bondsMax
			CombatAlerts.MaarselokEnablePanel(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.maarselok.wickedBonds = 0
			CombatAlerts.maarselok.nextBondage = GetGameTimeMilliseconds() + 25000
		elseif (result == ACTION_RESULT_DAMAGE_SHIELDED) then
			if (not CombatAlerts.maarselok.wickedBonds) then
				CombatAlerts.maarselok.wickedBonds = CombatAlertsData.maarselok.bondsMax
			end
			CombatAlerts.maarselok.wickedBonds = CombatAlerts.maarselok.wickedBonds - hitValue
			if (CombatAlerts.maarselok.wickedBonds < 0) then
				CombatAlerts.maarselok.wickedBonds = 0
			end
			CombatAlerts.MaarselokEnablePanel(true)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.seed) then
		CombatAlerts.maarselok.lastSeed = GetGameTimeMilliseconds()
		CombatAlerts.MaarselokEnablePanel(false)
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x00FF00FF, SOUNDS.OBJECTIVE_DISCOVERED, 3000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.maarselok.sweepingBreath) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 3000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.maarselok.headbutt) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xFF0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (abilityId == CombatAlertsData.maarselok.blaze and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (abilityId == CombatAlertsData.maarselok.talons and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.maarselok.shagrath and CombatAlerts.isVet) then
		CombatAlerts.maarselok.shagraths[targetUnitId] = true
	elseif (result == ACTION_RESULT_DIED and CombatAlerts.maarselok.shagraths[targetUnitId] and abilityId == CombatAlertsData.maarselok.shagrathSpit and CombatAlerts.isVet) then
		CombatAlerts.AlertChat("|cCC0000Failed:|r |H0:achievement:2581:0:0|h|h")


	-- Unhallowed Grave --------------------------------------------------------

	elseif (abilityId == CombatAlertsData.uhg.ruin and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.uhg.soulShatterIds[abilityId]) then
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlertsData.uhg.soulShatter), "Shelter Behind Pillars", 0x3399CCFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.uppercut and targetType == COMBAT_UNIT_TYPE_PLAYER and string.find(string.lower(GetUnitName("boss1")), "kjalnar")) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -2, 2 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.abyss) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.confinement) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.brimstone) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 8)) then
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), CombatAlerts.units[targetUnitId].name, 0xCC3300FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.uhg.breath) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue, { -2, 0, false, { 0.6, 0.8, 1, 0.4 }, { 0.6, 0.8, 1, 0.8 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.icereach.shockHeavy and targetType == COMBAT_UNIT_TYPE_PLAYER and hitValue > 1000) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -2, 2 })


	-- Kyne's Aegis ------------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.crashingWave.cast) then
		local id = CombatAlerts.AlertCast(CombatAlertsData.ka.crashingWave.name, nil, hitValue, { 650, 2, false, { 0.3, 0.9, 1, 0.6 }, { 0, 0.5, 1, 1 } })
		if (ValidUnit(targetUnitId)) then
			CombatAlerts.castAlerts.sources[targetUnitId] = id
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.spear) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.DistanceCheck(targetUnitId, 4.2)) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.hailShield) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xEEEEFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.gust) then
		CombatAlerts.Alert("Gryphon", GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.slam) then
		CombatAlerts.Alert("Sea Adder", GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.ka.totems[abilityId]) then
		local totem = CombatAlertsData.ka.totems[abilityId]
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), GetFormattedAbilityName(totem[1]), totem[2], SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.frigidFog) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 5.3)) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.DUEL_START, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.shockingHarpoon) then
		CombatAlerts.ka.lastHarpoon = GetGameTimeMilliseconds()
		CombatAlerts.ka.panelMode = 1
		CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)

		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.fountain) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.chaurus.spawn) then
		CombatAlerts.ka.chaurus = GetGameTimeMilliseconds()
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.chaurus.projectile and CombatAlerts.ka.chaurus) then
		CombatAlerts.Debug(string.format("Chaurus Bile: %dms since spawn", GetGameTimeMilliseconds() - CombatAlerts.ka.chaurus))
		CombatAlerts.ka.chaurus = nil
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.ka.knights[abilityId] and hitValue == 1) then
		local knight = CombatAlertsData.ka.knights[abilityId]
		if (not knight[3] or CombatAlerts.isTank) then
			CombatAlerts.Alert(CombatAlertsData.ka.knights.spawnText, LocalizeString(knight[1], GetAbilityName(abilityId)), knight[2], SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.sanguinePrison) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC00FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.sanguineGrasp and hitValue > 4000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.frenzy and not CombatAlerts.isTank) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3366FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.callLightning and hitValue < 3000) then
		CombatAlerts.ka.chains = 0
		CombatAlerts.ka.panelMode = 2
		CombatAlerts.TogglePanel(true, { "Completed", "Position" }, true, true)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.proxLightning) then
		CombatAlerts.AlertBorder(true, 1000, "blue")
		PlaySound(SOUNDS.DUEL_FORFEIT)
		CombatAlerts.ka.chains = CombatAlerts.ka.chains + 1
		if (CombatAlerts.ka.chains == 4) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (CombatAlertsData.ka.meteor.ids[abilityId] and targetUnitId) then
		local currentTime = GetGameTimeMilliseconds()
		if ((result == ACTION_RESULT_EFFECT_GAINED and hitValue > 1000) or result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			local hitTime = currentTime + hitValue
			local paramId = CombatAlertsData.ka.meteor.ids[abilityId]
			if (paramId == 2 and zo_abs(CombatAlerts.ka.ichor.endTime - hitTime) < 1600) then
				paramId = 3
			end
			CombatAlerts.ka.meteor.units[targetUnitId] = hitTime
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				CombatAlerts.ka.meteor.selfId = targetUnitId
			end
			CombatAlerts.ka.meteor.params = CombatAlertsData.ka.meteor.params[paramId]
			CombatAlerts.ka.meteor.duration = hitValue
			if (not CombatAlerts.ka.meteor.bannerId and not (CombatAlerts.ka.meteor.params.excludeTanks and CombatAlerts.isTank and targetType ~= COMBAT_UNIT_TYPE_PLAYER)) then
				CombatAlerts.ka.meteor.bannerId = CombatAlerts.AlertBannerEx(nil, nil, nil, CombatAlerts.ka.meteor.params.id, false, SOUNDS.CHAMPION_POINTS_COMMITTED, CombatAlerts.KynesMeteorUpdate)
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			if (CombatAlerts.ka.meteor.units[targetUnitId] and CombatAlerts.ka.meteor.units[targetUnitId] - CombatAlerts.ka.meteor.duration < currentTime - 10) then
				CombatAlerts.ka.meteor.units[targetUnitId] = nil
			end
		end
	elseif (abilityId == CombatAlertsData.ka.ichorTimer) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.ka.panelMode = 3
			CombatAlerts.ka.ichor.endTime = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.ka.ichor.counter = 0
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(CombatAlertsData.ka.ichorEruption), true, true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (abilityId == CombatAlertsData.ka.apotheosis) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.ka.apotId = targetUnitId
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.ka.apotId = nil
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ka.hemorrhage) then
		-- Change the color of existing Instability alert
		CombatAlerts.ka.meteor.params = CombatAlertsData.ka.meteor.params[3]
		-- Disabled the apotheosis check in Update 29
		--if (targetUnitId == CombatAlerts.ka.apotId and not CombatAlerts.isTank) then
		if (not CombatAlerts.isTank) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId) .. " — Block", 0xFF99FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.ka.bloodCounter) then
		CombatAlerts.ka.ichor.counter = hitValue
	elseif (CombatAlertsData.damageEvents[result] and CombatAlertsData.ka.groundIchor[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			local ichorParams = CombatAlertsData.ka.groundIchor[abilityId]
			if (not (ichorParams[2] and CombatAlerts.isTank)) then
				CombatAlerts.AlertBorder(true, ichorParams[1])
			end
		elseif (targetUnitId == CombatAlerts.guardUnit) then
			CombatAlerts.ka.groundIchor.result = result
			CombatAlerts.ka.groundIchor.abilityId = abilityId
			CombatAlerts.divertNextEvent = CombatAlerts.KynesGroundIchorGuardEvent
		end
	elseif (abilityId == CombatAlertsData.ka.toxicTide and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end


	-- Stonethorn --------------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.annihilate) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.scatter and hitValue < 3000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.dive) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFFCC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.stonethorn.charges[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3399FF, CombatAlerts.isTank and SOUNDS.CHAMPION_POINTS_COMMITTED or SOUNDS.DUEL_START, 1500)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, CombatAlertsData.stonethorn.charges[abilityId])) then
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), CombatAlerts.units[targetUnitId].name, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	elseif (abilityId == CombatAlertsData.stonethorn.chaurus and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.AlertBorder(true)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false)
		end
	elseif (CombatAlertsData.damageEvents[result] and abilityId == CombatAlertsData.stonethorn.wwtaunt and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.stonethorn.huskId = targetUnitId
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.cannon and targetUnitId == CombatAlerts.stonethorn.huskId) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.mark) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.discharge) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.stonethorn.bottled) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x3399CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)


	-- Flames of Ambition ------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.foa.prison) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x009900FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)


	-- Rockgrove ---------------------------------------------------------------

	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.rg.standingInAoe[abilityId]) then
		local params = CombatAlertsData.rg.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.rg.blitz[abilityId]) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.rg.cinder) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x00CCFFFF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)
		local id = CombatAlerts.AlertCast(abilityId, nil, 2500, { -2, 0, true, { 0, 0.8, 1, 0.2 }, { 0, 0.8, 1, 0.6 } })
		if (ValidUnit(sourceUnitId)) then
			CombatAlerts.castAlerts.sources[sourceUnitId] = id
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.rg.convoke) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x00FFFFFF, SOUNDS.OBJECTIVE_DISCOVERED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.rg.meteorSwarm) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF9900FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 3000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.rg.meteorCall) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF9900FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.rg.astralShield) then
		CombatAlerts.rg.astralShields = CombatAlerts.rg.astralShields + 1
		CombatAlerts.ConsolidatedCall("Astral", 50, function( )
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId) .. string.format(" (%d)", CombatAlerts.rg.astralShields), 0x00FFFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
			CombatAlerts.rg.astralShields = 0
		end)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.rg.eye[abilityId]) then
		CombatAlerts.Alert(nil, CombatAlertsData.rg.eye[abilityId], 0xFF0066FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 4000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.rg.takingAim) then
		local id = CombatAlerts.AlertCast(abilityId, sourceName, 3000, { -3, 2, true })
		if (ValidUnit(sourceUnitId)) then
			CombatAlerts.castAlerts.sources[sourceUnitId] = id
		end


	-- Waking Flame ------------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.wf.wall) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.wf.lastWall > 5000) then
			CombatAlerts.wf.lastWall = currentTime
			CombatAlerts.Alert(nil, "Wall", 0xFFFF00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.wf.blades and hitValue < 1000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x0099FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.wf.gaze and hitValue < 2000) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x6633FFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.wf.mending and hitValue < 2000 and GetUnitName("boss1") ~= "") then
		CombatAlerts.Alert("Interrupt", GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.wf.stacks[abilityId] and CombatAlerts.isVet) then
		local stacks
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			stacks = hitValue
		elseif (result == ACTION_RESULT_EFFECT_FADED and hitValue > 100) then
			stacks = 0
		end
		if (stacks) then
			CombatAlerts.AlertChat(string.format("%s: %d", GetFormattedAbilityName(abilityId), stacks))
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.wf.soulstorm and hitValue > 1000) then
		CombatAlerts.AlertCast(abilityId, nil, hitValue - 200, { -3, 2 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.wf.outburst) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.wf.catastrophe.cast and CombatAlerts.vars.extTDC) then
		CombatAlerts.AlertCast(CombatAlertsData.wf.catastrophe.name, nil, hitValue, { -2, 0, false, { 0.7, 0.3, 1, 0.3 }, { 0.7, 0.3, 1, 0.7 } })


	-- Ascending Tide ----------------------------------------------------------

	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.at.standingInAoe[abilityId]) then
		local params = CombatAlertsData.at.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.at.fear[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.bomb1) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		CombatAlerts.tide.bombs = { }
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.at.bomb2) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		table.insert(CombatAlerts.tide.bombs, targetName)
		if (#CombatAlerts.tide.bombs > 1) then
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), table.concat(CombatAlerts.tide.bombs, " / "), 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
			CombatAlerts.tide.bombs = { }
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.kindred) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF3366FF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.pursue) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.spout and hitValue < 1000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.daggerstorm) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF6600FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.at.links[abilityId]) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		if (CombatAlertsData.at.links[abilityId] == 1) then
			CombatAlerts.tide.link1 = targetName
		else
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), string.format("%s / %s", CombatAlerts.tide.link1, targetName), 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
			CombatAlerts.tide.link1 = ""
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.at.current and hitValue < 1500) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		elseif (CombatAlerts.isHealer) then
			if (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
			end
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.at.gryphons[abilityId]) then
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlertsData.at.gryphons.call), CombatAlertsData.at.gryphons[abilityId], 0xFF9900FF, SOUNDS.OBJECTIVE_DISCOVERED, 2000)


	-- Dreadsail Reef ----------------------------------------------------------

	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.dsr.standingInAoe[abilityId]) then
		local params = CombatAlertsData.dsr.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end
	elseif (abilityId == CombatAlertsData.dsr.targeted and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.AlertBorder(true, hitValue, "violet")
			LCA.PlaySounds("DUEL_BOUNDARY_WARNING", 3, 200, "DUEL_BOUNDARY_WARNING", 2, 150, "FRIEND_INVITE_RECEIVED", 2)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.AlertBorder(false, nil, "violet")
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.dsr.cinderShot) then
		LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 4, 125, "FRIEND_INVITE_RECEIVED", 3, 125, "FRIEND_INVITE_RECEIVED", 2)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.dsr.marksman.target) then
		local id = CombatAlerts.AlertCast(CombatAlertsData.dsr.marksman.damage, sourceName, 3000, { -3, 2, true })
		if (ValidUnit(sourceUnitId)) then
			CombatAlerts.castAlerts.sources[sourceUnitId] = id
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.multi[abilityId]) then
		-- Reset the counter
		local multi = CombatAlerts.dsr.multi
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - multi.previous > 10000) then
			multi.previous = currentTime
			multi.count = 0
		end
		multi.count = multi.count + 1
		local bannerText = zo_strformat("<<i:1>> Teleport Position", multi.count)
		if (multi.count == 1) then
			multi.id = CombatAlerts.StartBanner(nil, bannerText, 0xFF3333FF, nil, true, nil, true)
			LCA.PlaySounds("DUEL_BOUNDARY_WARNING", 5)
			zo_callLater(function()
				CombatAlerts.DisableBanner(multi.id)
			end, 6500)
		else
			CombatAlerts.ModifyBanner(multi.id, nil, bannerText, 0xFF3333FF)
			if (CombatAlerts.vars.dsrPortSounds) then
				LCA.PlaySounds("DUEL_BOUNDARY_WARNING", 2)
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.dsr.imminent[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF00CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		elseif (CombatAlerts.isTank) then
			if (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
			end
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xFF00CCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, hitValue)
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.dsr.summon[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), CombatAlertsData.dsr.summon[abilityId], SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.summon2[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), CombatAlertsData.dsr.summon2[abilityId], SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.brands[abilityId] and targetType == COMBAT_UNIT_TYPE_PLAYER and hitValue == 1) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	--[[
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.dsr.brands.start) then
		-- Make sure we are fully reset at the start of the mechanic
		CombatAlerts.dsr.brands = {
			fire = { },
			frost = { },
			count = (select(3, GetUnitPower("boss1", COMBAT_MECHANIC_FLAGS_HEALTH)) >= CombatAlertsData.dsr.brands.hmHealth) and 2 or 1,
		}
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.brands[abilityId] and hitValue == 1) then
		local key = CombatAlertsData.dsr.brands[abilityId]
		local brands = CombatAlerts.dsr.brands
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			brands.playerKey = key
			brands.playerName = targetName
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		end
		table.insert(brands[key], targetName)
		if (#brands.fire == brands.count and #brands.frost == brands.count and brands.playerKey) then
			table.sort(brands.fire)
			table.sort(brands.frost)
			local partnerKey = CombatAlertsData.dsr.brands[brands.playerKey]
			local suggested
			if (brands[brands.playerKey][1] == brands.playerName) then
				suggested = brands[partnerKey][1]
			elseif (brands.count == 2 and brands[brands.playerKey][2] == brands.playerName) then
				suggested = brands[partnerKey][2]
			end
			if (suggested and CombatAlerts.panel.tag == "dsr1") then
				CombatAlerts.panel.rows[3].data:SetText(suggested)
				CombatAlerts.panel.rows[3]:SetHidden(false)
			end
		end
	elseif (result == ACTION_RESULT_EFFECT_FADED and CombatAlertsData.dsr.brands.removal[abilityId]) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlerts.panel.tag == "dsr1") then
			CombatAlerts.panel.rows[3]:SetHidden(true)
		end
		if (CombatAlerts.dsr.brands.count) then
			CombatAlerts.dsr.brands = {
				fire = { },
				frost = { },
			}
		end
	]]--
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.dsr.replication) then
		if (CombatAlerts.dsr.panel and CombatAlerts.panel.tag ~= "dsr2") then
			CombatAlerts.TogglePanel(true, zo_strformat("<<1>>", GetUnitName("boss1")), true, true)
			CombatAlerts.dsr.guardians = {
				hearts = 0,
				units = { },
				statuses = { },
			}
			CombatAlerts.panel.tag = "dsr2"
		end
		if (ValidUnit(targetUnitId)) then
			CombatAlerts.dsr.guardians.statuses[targetUnitId] = {
				color = 0xFF00FF,
				text = GetFormattedAbilityName(abilityId),
			}
			zo_callLater(function() CombatAlerts.dsr.guardians.statuses[targetUnitId] = nil end, hitValue)
		end
	elseif (abilityId == CombatAlertsData.dsr.heartburn and ValidUnit(targetUnitId)) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.dsr.guardians.hearts = CombatAlerts.dsr.guardians.hearts + 1
			CombatAlerts.dsr.guardians.units[targetUnitId] = {
				number = CombatAlerts.dsr.guardians.hearts,
				stop = GetGameTimeMilliseconds() + hitValue,
			}
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.dsr.guardians.units[targetUnitId] = nil
		end
	elseif (CombatAlertsData.dsr.heartburnResult[abilityId] and ValidUnit(targetUnitId)) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.dsr.guardians.statuses[targetUnitId] = CombatAlertsData.dsr.heartburnResult[abilityId]
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.dsr.guardians.statuses[targetUnitId] = nil
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.dsr.wave.start) then
		CombatAlerts.dsr.wave.stop = GetGameTimeMilliseconds() + hitValue
		CombatAlerts.dsr.wave.targeted = false
		zo_callLater(function()
			if (CombatAlerts.vars.dsrShowWave or CombatAlerts.dsr.wave.targeted) then
				CombatAlerts.AlertCast(CombatAlertsData.dsr.wave.damage, nil, CombatAlerts.dsr.wave.stop - GetGameTimeMilliseconds(), CombatAlerts.dsr.wave.targeted and { 750, 2 } or { 750, 0, false, { 0.8, 1, 1, 0.4 }, { 0.6, 1, 1, 0.6 } })
			end
		end, 300)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.dsr.wave.target and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.dsr.wave.targeted = true
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.dsr.deluge.start) then
		-- Probably unnecessary, but make sure we are fully reset at the start of the mechanic
		CombatAlerts.DreadsailDelugeReset()
		CombatAlerts.dsr.delugeFailures = nil
	elseif (result == ACTION_RESULT_DAMAGE and CombatAlertsData.dsr.deluge.damage[abilityId] and CombatAlerts.dsr.delugeFailures) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime - CombatAlerts.dsr.delugePrevErup > 1000) then
			if (CombatAlerts.vars.dsrDelugeBlame) then
				CombatAlerts.AlertChat(string.format("%s: %s", GetFormattedAbilityName(abilityId), table.concat(CombatAlerts.dsr.delugeFailures, ", ")))
			end
			CombatAlerts.dsr.delugePrevErup = currentTime
		end
		CombatAlerts.dsr.delugeFailures = nil
	elseif (targetUnitId and CombatAlertsData.dsr.deluge[abilityId]) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.dsr.deluge.units[targetUnitId] = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.dsr.deluge.duration = hitValue
			if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
				CombatAlerts.dsr.deluge.selfId = targetUnitId
				CombatAlerts.CastAlertsStart(CombatAlertsData.dsr.deluge.icon, GetFormattedAbilityName(abilityId), hitValue, nil, { 0.3, 0.9, 1, 0.6 }, { 1750, "Swim!", 0, 0.5, 1, 1, SOUNDS.FRIEND_INVITE_RECEIVED })
				LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 3, 200, "DUEL_BOUNDARY_WARNING", 1, 150, "DUEL_BOUNDARY_WARNING", 2, 150, "DUEL_BOUNDARY_WARNING", 3)
			end
			if (not CombatAlerts.dsr.deluge.bannerId) then
				CombatAlerts.dsr.deluge.bannerId = CombatAlerts.AlertBannerEx(nil, nil, nil, nil, false, nil, CombatAlerts.DreadsailDelugeUpdate)
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.dsr.deluge.units[targetUnitId] = nil
		end
	elseif (abilityId == CombatAlertsData.dsr.storm.tracker) then
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.dsr.stormEnd = GetGameTimeMilliseconds() + hitValue
			CombatAlerts.dsr.stormIcon = ""
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.dsr.stormEnd = 0
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.storm[abilityId]) then
		CombatAlerts.Alert(nil, string.format("%s  %s", GetFormattedAbilityName(abilityId), zo_iconFormatInheritColor(CombatAlertsData.dsr.storm[abilityId], 64, 64)), 0x00CCCCFF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		CombatAlerts.dsr.stormIcon = zo_iconFormatInheritColor(CombatAlertsData.dsr.storm[abilityId], 24, 24)
	elseif (abilityId == CombatAlertsData.dsr.maelstrom) then
		if (result == ACTION_RESULT_BEGIN and hitValue == 500) then
			CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCCCC66FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			CombatAlerts.dsr.maelstrom = {
				prev = GetGameTimeMilliseconds(),
				duration = hitValue,
			}
			if (CombatAlerts.dsr.panel and CombatAlerts.panel.tag ~= "dsr3") then
				CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(abilityId), GetFormattedAbilityName(CombatAlertsData.dsr.storm.name), "Channelers" }, true, true)
				CombatAlerts.dsr.stormEnd = 0
				CombatAlerts.dsr.bridge = {
					channels = { },
					units = { },
				}
				CombatAlerts.panel.tag = "dsr3"
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.dsr.maelstrom.duration = 0
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.dsr.bridge.summons[abilityId] and hitValue > 1000 and CombatAlerts.isVet) then
		CombatAlerts.dsr.bridge.order = CombatAlertsData.dsr.bridge.summons[abilityId]
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.dsr.bridge.channelers[abilityId] and hitValue == 1) then
		local message = GetFormattedAbilityName(CombatAlertsData.dsr.bridge.platform)
		if (CombatAlerts.dsr.bridge.order) then
			message = string.format("%s #%d", message, CombatAlerts.dsr.bridge.order)
			CombatAlerts.dsr.bridge.order = nil
		end
		CombatAlerts.Alert(nil, message, CombatAlertsData.dsr.bridge.channelers[abilityId], SOUNDS.OBJECTIVE_DISCOVERED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.dsr.bridge.channels[abilityId] and ValidUnit(targetUnitId)) then
		if (hitValue < 5000) then
			table.insert(CombatAlerts.dsr.bridge.channels, {
				name = GetFormattedAbilityName(abilityId),
				color = CombatAlertsData.dsr.bridge.channels[abilityId],
				time = 0,
			})
			CombatAlerts.dsr.bridge.units[targetUnitId] = #CombatAlerts.dsr.bridge.channels
		elseif (CombatAlerts.dsr.bridge.units[targetUnitId]) then
			CombatAlerts.dsr.bridge.channels[CombatAlerts.dsr.bridge.units[targetUnitId]].time = GetGameTimeMilliseconds() + hitValue
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.dsr.bridge.stop and targetUnitId and CombatAlerts.dsr.bridge.units[targetUnitId]) then
		CombatAlerts.dsr.bridge.channels[CombatAlerts.dsr.bridge.units[targetUnitId]].time = nil
		CombatAlerts.dsr.bridge.units[targetUnitId] = nil


	-- Lost Depths -------------------------------------------------------------

	elseif (result == ACTION_RESULT_EFFECT_GAINED and targetType == COMBAT_UNIT_TYPE_PLAYER and abilityId == CombatAlertsData.ld.sunbolt and hitValue > 1000) then
		local adjustedTime = hitValue - 500
		CombatAlerts.AlertCast(abilityId, nil, adjustedTime, { adjustedTime, 0, false, { 0, 0.8, 0, 0.3 }, { 0, 0.8, 0, 0.6 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ld.fear) then
		local name = GetFormattedAbilityName(abilityId)
		CombatAlerts.Alert(nil, name, 0xFF3366FF, SOUNDS.DUEL_START, 2000)
		CombatAlerts.CastAlertsStart(CombatAlertsData.ld.fearDamage, name, hitValue, nil, nil, { hitValue, "Turn Away!", 1, 0.2, 0.4, 0.5, nil })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ld.barrage) then
		local id = CombatAlerts.AlertCast(abilityId, nil, hitValue, { -3, 0, false, { 0.7, 0.3, 1, 0.3 }, { 0.7, 0.3, 1, 0.7 } })
		if (ValidUnit(targetUnitId)) then
			CombatAlerts.castAlerts.sources[targetUnitId] = id
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and CombatAlertsData.ld.soulSplit[abilityId]) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		if (CombatAlertsData.ld.soulSplit[abilityId] == 1) then
			CombatAlerts.ld.soul1 = targetName
			if (select(3, GetUnitPower("boss1", COMBAT_MECHANIC_FLAGS_HEALTH)) < CombatAlertsData.ld.soulSplit.hmHealth) then
				CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
			end
		else
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), string.format("%s / %s", CombatAlerts.ld.soul1, targetName), 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
			CombatAlerts.ld.soul1 = ""
		end
	elseif (CombatAlertsData.ld.orbs[abilityId] and ValidUnit(targetUnitId)) then
		local currentTime = GetGameTimeMilliseconds()
		if (currentTime > CombatAlerts.ld.orbCooldown) then
			if (CombatAlerts.panel.tag ~= "gdorbs") then
				CombatAlerts.ld.orbs = { ids = {} }
				CombatAlerts.TogglePanel(true, "Sea Orbs", true, true)
				CombatAlerts.panel.tag = "gdorbs"
			end
			local params = CombatAlertsData.ld.orbs[abilityId]
			if (result == params[1]) then
				if (not CombatAlerts.ld.orbs[targetUnitId]) then
					table.insert(CombatAlerts.ld.orbs.ids, targetUnitId)
				end
				CombatAlerts.ld.orbs[targetUnitId] = currentTime + params[2]
			end
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.ld.orbs.afterlife) then
		CombatAlerts.ld.orbs = { ids = {} }
		CombatAlerts.ld.orbCooldown = GetGameTimeMilliseconds() + 10000
	elseif (CombatAlertsData.ld.purgeables[abilityId] and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		local id = "u35purgeables"
		if (result == ACTION_RESULT_EFFECT_GAINED) then
			CombatAlerts.ScreenBorderEnable(0xFFDD0066, nil, id)
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.ScreenBorderDisable(id)
		end
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.ld.banners[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), CombatAlertsData.ld.banners[abilityId], SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.ld.standingInAoe[abilityId]) then
		local params = CombatAlertsData.ld.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end


	-- Scribes of Fate ---------------------------------------------------------

	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.manipulate and hitValue < 2000) then
		CombatAlerts.Alert(CombatAlerts.incomingText, GetFormattedAbilityName(abilityId), 0xFFCC33FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.verge.boss) then
		local sound = SOUNDS.DUEL_START
		if (CombatAlerts.isTank) then sound = nil end
		if (targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.Alert(nil, zo_strformat(CombatAlertsData.u37.verge.name, "You"), 0xCC3399FF, sound, 1000)
		elseif (CombatAlerts.DistanceCheck(targetUnitId, 5)) then
			CombatAlerts.Alert(nil, zo_strformat(CombatAlertsData.u37.verge.name, CombatAlerts.units[targetUnitId].name), 0xCC3399FF, sound, 1000)
		end
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.u37.verge.shade) then
		CombatAlerts.Alert(nil, zo_strformat(CombatAlertsData.u37.verge.name, "Boss"), 0xCC3399FF, nil, 1000)
		LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 1, 100, "DUEL_BOUNDARY_WARNING", 2)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.u37.summonNix and CombatAlerts.isTank) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF9900FF, nil, 2000)
	elseif (abilityId == CombatAlertsData.u37.choking) then
		CombatAlerts.u37.choking = GetGameTimeMilliseconds() + hitValue
		if (result == ACTION_RESULT_EFFECT_GAINED_DURATION) then
			if (CombatAlerts.panel.tag ~= "u37cp") then
				CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
				CombatAlerts.panel.tag = "u37cp"
			end
		elseif (result == ACTION_RESULT_EFFECT_FADED) then
			CombatAlerts.TogglePanel(false, nil, true)
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.darklight.start and hitValue < 2000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCCFF33FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
		CombatAlerts.u37.darklight = { }
		if (CombatAlerts.panel.tag ~= "u37dl") then
			CombatAlerts.TogglePanel(true, CombatAlertsData.u37.darklight.name, false, true)
			CombatAlerts.panel.tag = "u37dl"
		end
	elseif (abilityId == CombatAlertsData.u37.darklight.star) then
		if ((result == ACTION_RESULT_EFFECT_GAINED or result == ACTION_RESULT_EFFECT_FADED) and ValidUnit(targetUnitId)) then
			if (result == ACTION_RESULT_EFFECT_GAINED) then
				CombatAlerts.u37.darklight[targetUnitId] = true
			elseif (result == ACTION_RESULT_EFFECT_FADED) then
				CombatAlerts.u37.darklight[targetUnitId] = nil
			end
			CombatAlerts.panel.data:SetText(zo_strformat("<<1>> <<z:2>>", LCA.CountTable(CombatAlerts.u37.darklight), GetString(SI_LCA_ACTIVE)))
		end
	elseif (abilityId == CombatAlertsData.u37.hellfire) then
		if ((result == ACTION_RESULT_EFFECT_GAINED or result == ACTION_RESULT_EFFECT_FADED) and ValidUnit(targetUnitId)) then
			if (CombatAlerts.panel.tag ~= "u37hf") then
				CombatAlerts.u37.hellfire = { }
				CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), false, true)
				CombatAlerts.panel.tag = "u37hf"
			end
			if (result == ACTION_RESULT_EFFECT_GAINED) then
				CombatAlerts.u37.hellfire[targetUnitId] = true
			elseif (result == ACTION_RESULT_EFFECT_FADED) then
				CombatAlerts.u37.hellfire[targetUnitId] = nil
			end
			CombatAlerts.panel.data:SetText(zo_strformat("<<1>> <<z:2>>", LCA.CountTable(CombatAlerts.u37.hellfire), GetString(SI_LCA_ACTIVE)))
		end
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.effusion and targetType == COMBAT_UNIT_TYPE_PLAYER and hitValue > 1500) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, { -3, 2 })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.bash and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.u37.bash = GetGameTimeMilliseconds() + hitValue + 200
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.slash and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue, (GetGameTimeMilliseconds() > CombatAlerts.u37.bash) and { -2, 2 } or { 0, 0, false, { 1, 0, 0.6, 0.8 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.parasite) then
		CombatAlerts.AlertCast(CombatAlertsData.u37.parasiteSack, nil, 1700, { 400, 0, false, { 0.8, 0, 0, 0.6 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.ironAtro and CombatAlerts.isTank) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF9900FF, nil, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.thirst and CombatAlerts.isTank) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xCC0000FF, nil, 1500)
		LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 1, 100, "DUEL_BOUNDARY_WARNING", 2)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u37.web and hitValue < 2000) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == CombatAlertsData.u37.trapTrip) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.AlertChat(string.format("[%s] %s: %s", CombatAlertsData.u37.trapName, GetFormattedAbilityName(abilityId), targetName))
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.u37.meteor.start) then
		local id = CombatAlerts.CastAlertsStart(CombatAlertsData.u37.meteor.damage, GetFormattedAbilityName(CombatAlertsData.u37.meteor.damage), hitValue, CombatAlertsData.u37.meteor.timer, nil, { hitValue, "Block!", 1, 0.4, 0, 0.5, nil })
		if (ValidUnit(targetUnitId)) then
			CombatAlerts.u37.meteor = { unitId = targetUnitId, alertId = id }
		else
			CombatAlerts.u37.meteor = { unitId = -1, alertId = -1 }
		end
	elseif (result == ACTION_RESULT_DIED and targetUnitId == CombatAlerts.u37.meteor.unitId) then
		CombatAlerts.CastAlertsStop(CombatAlerts.u37.meteor.alertId)
		CombatAlerts.u37.meteor = { unitId = -1, alertId = -1 }
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.u37.banners[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), CombatAlertsData.u37.banners[abilityId], nil, 1250)
	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.u37.standingInAoe[abilityId]) then
		local params = CombatAlertsData.u37.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end


	-- Sanity's Edge -----------------------------------------------------------
	-- General
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.u38.banners[abilityId]) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), CombatAlertsData.u38.banners[abilityId], SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
	elseif (CombatAlertsData.damageEvents[result] and targetType == COMBAT_UNIT_TYPE_PLAYER and CombatAlertsData.u38.standingInAoe[abilityId]) then
		local params = CombatAlertsData.u38.standingInAoe[abilityId]
		if (not (params[2] and CombatAlerts.isTank)) then
			CombatAlerts.AlertBorder(true, params[1])
		end

	-- Boss 1
	elseif (result == ACTION_RESULT_BEGIN and CombatAlertsData.u38.charge[abilityId]) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(nil, LocalizeString("<<t:1>> (<<2>>)", GetAbilityName(abilityId), targetName), 0xFF00FFFF, nil, 1500)
		LCA.PlaySounds("DUEL_BOUNDARY_WARNING", 1, 150, "DUEL_BOUNDARY_WARNING", 2, 250, "FRIEND_INVITE_RECEIVED", 3)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.shrapnel.start and hitValue < 2000) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(CombatAlertsData.u38.shrapnel.name), 0xFFFFFFFF, nil, 1500)
		LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 1, 150, "DUEL_BOUNDARY_WARNING", 2, 150, "DUEL_BOUNDARY_WARNING", 3, 150, "DUEL_BOUNDARY_WARNING", 4)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.frostBomb1) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, nil, 2500)
	elseif (abilityId == CombatAlertsData.u38.frostBomb2) then
		if (result == ACTION_RESULT_BEGIN) then
			CombatAlerts.u38.bombs = { }
		elseif (result == ACTION_RESULT_EFFECT_GAINED) then
			if (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
			end
			table.insert(CombatAlerts.u38.bombs, targetName)
			if (#CombatAlerts.u38.bombs > 1) then
				CombatAlerts.Alert(GetFormattedAbilityName(abilityId), table.concat(CombatAlerts.u38.bombs, " / "), 0x66CCFFFF, nil, 2500)
				CombatAlerts.u38.bombs = { }
			end
		end

	-- Boss 2
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.chainLightning) then
		if (CombatAlerts.units[targetUnitId]) then
			targetName = CombatAlerts.units[targetUnitId].name
		end
		CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0x66CCFFFF, nil, 1500)
	elseif (result == ACTION_RESULT_EFFECT_GAINED and CombatAlertsData.u38.mantles[abilityId] and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x00CC99FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2500)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.inferno.cast and hitValue < 2000) then
		CombatAlerts.u38.lastInferno = GetGameTimeMilliseconds()
		if (CombatAlerts.panel.tag ~= "u38b2") then
			CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), true, true)
			CombatAlerts.panel.tag = "u38b2"
		end
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0xFF6600FF, nil, 1500)
		LCA.PlaySounds("FRIEND_INVITE_RECEIVED", 1, 150, "FRIEND_INVITE_RECEIVED", 1, 150, "DUEL_BOUNDARY_WARNING", 3)
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.u38.inferno.meteor and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertCast(CombatAlertsData.u38.inferno.sunburst, sourceName, hitValue, { -3, 0, false, { 1, 0.4, 0, 0.5 } })

	-- Boss 3
	elseif (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.u38.poison and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.Alert(nil, GetFormattedAbilityName(abilityId), 0x00CC00FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 2000)
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.sunburst and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.AlertCast(abilityId, sourceName, hitValue + 800, { -3, 0, false, { 1, 0.4, 0, 0.5 } })
	elseif (result == ACTION_RESULT_BEGIN and abilityId == CombatAlertsData.u38.phobia) then
		if (targetType == COMBAT_UNIT_TYPE_PLAYER or CombatAlerts.isTank) then
			if (CombatAlerts.units[targetUnitId]) then
				targetName = CombatAlerts.units[targetUnitId].name
			end
			CombatAlerts.Alert(GetFormattedAbilityName(abilityId), targetName, 0xCC3399FF, SOUNDS.CHAMPION_POINTS_COMMITTED, 1500)
		end
	end
end

function CombatAlerts.EffectChanged( eventCode, changeType, effectSlot, effectName, unitTag, beginTime, endTime, stackCount, iconName, buffType, effectType, abilityType, statusEffectType, unitName, unitId, abilityId, sourceType )
	CombatAlerts.IdentifyUnit(unitTag, unitName, unitId)


	-- Maw of Lorkhaj ----------------------------------------------------------

	if (CombatAlerts.maw.enabled and abilityId == CombatAlertsData.maw.weakened and zo_strsub(unitTag, 1, 5) == "group") then
		local unit = GetUnitDisplayName(unitTag)

		if (changeType ~= EFFECT_RESULT_FADED) then
			CombatAlerts.maw.smashes[unit] = stackCount
			CombatAlerts.MawUpdatePanel(true)
		else
			CombatAlerts.maw.smashes[unit] = nil
			CombatAlerts.MawUpdatePanel()
		end


	-- Cloudrest ---------------------------------------------------------------

	elseif (abilityId == CombatAlertsData.cloudrest.preyed) then
		local unit = GetUnitDisplayName(unitTag)

		if (unit and not CombatAlerts.isDamage) then
			if (not CombatAlerts.panel.enabled) then
				CombatAlerts.cloudrest.preyed = { }
				CombatAlerts.TogglePanel(true, GetFormattedAbilityName(abilityId), false, true)
			end

			if (changeType ~= EFFECT_RESULT_FADED) then
				CombatAlerts.cloudrest.preyed[unit] = stackCount
				CombatAlerts.CloudrestPreyedUpdatePanel(true)
			else
				CombatAlerts.cloudrest.preyed[unit] = nil
				CombatAlerts.CloudrestPreyedUpdatePanel()
			end
		end
	elseif (abilityId == CombatAlertsData.general.taunt and unitTag == "boss1" and string.find(string.lower(GetUnitName(unitTag)), CombatAlertsData.cloudrest.zmaja)) then
		if (changeType == EFFECT_RESULT_GAINED) then
			CombatAlerts.cloudrest.zmajaTaunt = GetGameTimeMilliseconds() + GetAbilityDuration(abilityId)
		elseif (changeType == EFFECT_RESULT_FADED) then
			CombatAlerts.cloudrest.zmajaTaunt = 0
		end


	-- Sunspire -------------------------------------------------------

	elseif (abilityId == CombatAlertsData.sunspire.tombArming and changeType == EFFECT_RESULT_GAINED) then
		CombatAlerts.sunspire.tombState = 2
	elseif (abilityId == CombatAlertsData.sunspire.tombArmed) then
		if (changeType == EFFECT_RESULT_GAINED) then
			CombatAlerts.sunspire.tombActive = CombatAlerts.sunspire.tombActive + 1
			CombatAlerts.sunspire.tombState = 3
			CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombText)

			local deadline = GetGameTimeMilliseconds() + GetAbilityDuration(abilityId)
			if (deadline - CombatAlerts.sunspire.tombDeadline > 1000) then
				CombatAlerts.sunspire.tombDeadline = deadline
			end
		elseif (changeType == EFFECT_RESULT_FADED) then
			CombatAlerts.sunspire.tombActive = CombatAlerts.sunspire.tombActive - 1
			if (CombatAlerts.sunspire.tombActive == 0) then
				CombatAlerts.sunspire.tombState = 4
				CombatAlerts.panel.label:SetText(CombatAlerts.sunspire.tombTextNext)
			end
		end


	-- Dreadsail Reef ----------------------------------------------------------

	elseif (CombatAlerts.dsr.panel and CombatAlertsData.dsr.dome[abilityId]) then
		local unit = GetUnitDisplayName(unitTag)

		if (unit and unit ~= "") then
			if (not CombatAlerts.panel.enabled) then
				CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(CombatAlertsData.dsr.dome.ice), GetFormattedAbilityName(CombatAlertsData.dsr.dome.fire), GetString("SI_ATTRIBUTES", ATTRIBUTE_HEALTH) }, true, true)
				CombatAlerts.panel.tag = "dsr1"
				CombatAlerts.panel.rows[1].label:SetColor(0.4, 0.8, 1, 1)
				CombatAlerts.panel.rows[2].label:SetColor(1, 0.4, 0, 1)
			end

			local control = CombatAlerts.panel.rows[CombatAlertsData.dsr.dome[abilityId]].data

			if (changeType ~= EFFECT_RESULT_FADED) then
				control:SetText(zo_strformat("<<1>>: <<2>> <<m:3>>", unit, stackCount, "stack||stacks^p"))
				if (stackCount > 20) then
					control:SetColor(1, 0.4, 0.4, 1)
				else
					control:SetColor(1, 1, 1, 1)
				end
			else
				control:SetText("")
				control:SetColor(1, 1, 1, 1)
			end
		end
	end
end

function CombatAlerts.BossesChanged( eventCode )
	local bossName = string.lower(GetUnitName("boss1"))

	if (CombatAlerts.currentBoss ~= bossName) then
		CombatAlerts.currentBoss = bossName
	else
		return
	end

	if (CombatAlerts.isVet and string.find(bossName, CombatAlertsData.maw.name)) then
		_, _, CombatAlerts.isTank = GetPlayerRoles()
		if (CombatAlerts.isTank or CombatAlerts.vars.debugEnabled) then
			CombatAlerts.MawTogglePanel(true)
		end
	elseif (CombatAlertsData.fanglair.names[bossName]) then
		CombatAlerts.FangLairToggleTimer(true)
	else
		CombatAlerts.MawTogglePanel(false)
		CombatAlerts.FangLairToggleTimer(false)
	end
end

function CombatAlerts.OnRaidTrialStarted( trialName, weekly )
	if (GetCurrentParticipatingRaidId() == 13) then
		CombatAlerts.KynesLeaperMonitor(not IsAchievementComplete(2816))
	end
end

function CombatAlerts.OnRaidTrialComplete( trialName, score, totalTime )
	CombatAlerts.KynesLeaperMonitor(false)
end

do
	local name = CombatAlerts.name .. "KynesLeaperMonitor"

	local LeaperMonitorEvent = function( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
		if (CombatAlertsData.damageEvents[result] and CombatAlertsData.ka.lightningBolt[abilityId] and targetType == COMBAT_UNIT_TYPE_PLAYER) then
			CombatAlerts.AlertChat(LocalizeString("Failed |H1:achievement:2816:0:0|h|h (<<1>>)", sourceName))
			if (not CombatAlerts.vars.debugEnabled) then
				CombatAlerts.KynesLeaperMonitor(false)
			end
		end
	end

	function CombatAlerts.KynesLeaperMonitor( enable )
		if (enable and not CombatAlerts.ka.leaperMonitor) then
			CombatAlerts.ka.leaperMonitor = true
			CombatAlerts.AlertChat("Starting |H1:achievement:2816:0:0|h|h monitoring...")
			EVENT_MANAGER:RegisterForEvent(name, EVENT_COMBAT_EVENT, LeaperMonitorEvent)
			EVENT_MANAGER:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_TARGET_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
		elseif (not enable and CombatAlerts.ka.leaperMonitor) then
			CombatAlerts.ka.leaperMonitor = false
			CombatAlerts.AlertChat("Stopping |H1:achievement:2816:0:0|h|h monitoring...")
			EVENT_MANAGER:UnregisterForEvent(name, EVENT_COMBAT_EVENT)
		end
	end
end

do
	local name = CombatAlerts.name .. "ThornMemoryGame"
	local mg, mgd

	local IsImbued = function( unitId )
		for i = 1, 4 do
			if (unitId == mg.ids[i]) then
				return(true)
			end
		end
		return(false)
	end

	local MemoryGameEvent = function( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
		if (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.imbued) then
			mg.ids[mg.idx] = targetUnitId
			mg.idx = (mg.idx % 4) + 1
		elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.gutted and IsImbued(targetUnitId) and GetGameTimeMilliseconds() > mg.disembowel) then
			CombatAlerts.AlertChat("[Memory Game] Imbued target gutted by |c00FF00player|r")
		elseif (result == ACTION_RESULT_EFFECT_GAINED and abilityId == mgd.disembowel and IsImbued(targetUnitId)) then
			mg.disembowel = GetGameTimeMilliseconds() + 2500
			CombatAlerts.AlertChat("[Memory Game] Imbued target gutted by |cFF0000boss|r")
		end
	end

	function CombatAlerts.ThornMemoryGame( enable )
		mg = CombatAlerts.stonethorn.memoryGame
		mgd = CombatAlertsData.stonethorn.memoryGame
		if (enable and not mg.enabled) then
			mg.enabled = true
			EVENT_MANAGER:RegisterForEvent(name, EVENT_COMBAT_EVENT, MemoryGameEvent)
			EVENT_MANAGER:AddFilterForEvent(name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_EFFECT_GAINED)
		elseif (not enable and mg.enabled) then
			mg.enabled = false
			EVENT_MANAGER:UnregisterForEvent(name, EVENT_COMBAT_EVENT)
		end
	end
end

function CombatAlerts.Poll( )
	if (CombatAlerts.zoneId == CombatAlertsData.fanglair.zone) then
		local time = CombatAlerts.fanglair.nextGrip - GetGameTimeMilliseconds()

		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(time))

		if (time >= 5500 or not IsUnitInCombat("player")) then
			CombatAlerts.panel.data:SetColor(1, 1, 1, 1)
		elseif (time <= 0) then
			CombatAlerts.panel.data:SetColor(1, 0, 0, 1)
		else
			CombatAlerts.panel.data:SetColor(1, 0.5, 0, 1)
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.frostvault.zone) then
		if (CombatAlerts.frostvault.skeevMode) then
			CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(GetGameTimeMilliseconds() - CombatAlerts.frostvault.skeevCharged))
			return
		end

		local time = CombatAlerts.frostvault.effluviumEnd - GetGameTimeMilliseconds()

		if (time > 0) then
			CombatAlerts.panel.data:SetColor(1, 1, 1, 1)
		else
			time = time * -1
			if (time < 11500) then
				CombatAlerts.panel.data:SetColor(0, 1, 0, 1)
			else
				CombatAlerts.panel.data:SetColor(1, 0.5, 0, 1)
			end
		end

		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(time, true))
	elseif (CombatAlerts.zoneId == CombatAlertsData.cloudrest.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time = currentTime - CombatAlerts.cloudrest.banefulPrev

		local timeText = CombatAlerts.FormatTime(time, true)
		if (time >= 21500 and currentTime <= CombatAlerts.cloudrest.flare.stop) then
			timeText = string.format("%s (%s)", timeText, CombatAlertsData.cloudrest.flareName)
		end

		CombatAlerts.panel.rows[1].data:SetText(timeText)

		if (CombatAlerts.cloudrest.executeStart ~= CombatAlerts.cloudrest.banefulPrev) then
			if (time < CombatAlerts.cloudrest.banefulCast) then
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.incomingText)
				CombatAlerts.panel.SetRowColor(1, 1, 0, 0.5, 1)
			elseif (time < 17500) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			elseif (time < 19500) then
				CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			end
		else
			if (time < 6500) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			elseif (time < 8500) then
				CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			end
		end

		if (currentTime <= CombatAlerts.cloudrest.flare.stop and CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]] and CombatAlerts.units[CombatAlerts.cloudrest.flare.units[2]]) then
			local dist = CombatAlerts.GetDistance(CombatAlerts.units[CombatAlerts.cloudrest.flare.units[1]].tag, CombatAlerts.units[CombatAlerts.cloudrest.flare.units[2]].tag)

			CombatAlerts.panel.rows[2].data:SetText(string.format("%.1fm%s", dist, CombatAlerts.cloudrest.flare.switcher))

			if (dist < 6) then
				CombatAlerts.panel.SetRowColor(2, 1, 0, 0, 1)
			elseif (dist < 7) then
				CombatAlerts.panel.SetRowColor(2, 1, 0.5, 0, 1)
			elseif (dist < 7.5) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 0, 1, 0, 1)
			end
		else
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.sunspire.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time

		if (CombatAlerts.sunspire.bottomActive) then
			if (CombatAlerts.sunspire.translation == 1) then
				CombatAlerts.panel.rows[1].data:SetText("Do not interrupt")
				CombatAlerts.panel.rows[1].data:SetColor(0, 0.75, 1, 1)
			elseif (CombatAlerts.sunspire.translation == 2) then
				time = CombatAlerts.sunspire.translationDeadline - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. " to interrupt")
				if (time < 2000) then
					CombatAlerts.panel.rows[1].data:SetColor(1, 0, 0, 1)
				else
					CombatAlerts.panel.rows[1].data:SetColor(1, 1, 0, 1)
				end
			elseif (CombatAlerts.sunspire.translation == 3) then
				time = CombatAlerts.sunspire.translationNext - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true) .. " to pins")
				if (time < 3500) then
					CombatAlerts.panel.rows[1].data:SetColor(1, 0.5, 0, 1)
				else
					CombatAlerts.panel.rows[1].data:SetColor(1, 1, 1, 1)
				end
			end
		else
			if (CombatAlerts.sunspire.tombState == 0 or (CombatAlerts.sunspire.tombState == 4 and not CombatAlerts.sunspire.lokiGrounded)) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 0)
			elseif (CombatAlerts.sunspire.tombState == 1) then
				CombatAlerts.panel.rows[1].data:SetText("Spawning")
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			elseif (CombatAlerts.sunspire.tombState == 2) then
				CombatAlerts.panel.rows[1].data:SetText("Activating")
				CombatAlerts.panel.SetRowColor(1, 1, 0, 1, 1)
			elseif (CombatAlerts.sunspire.tombState == 3) then
				time = CombatAlerts.sunspire.tombDeadline - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. " to shatter")
				if (time < 3000) then
					CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
				else
					CombatAlerts.panel.SetRowColor(1, 0.25, 0.75, 1, 1)
				end
			elseif (CombatAlerts.sunspire.tombState == 4) then
				time = CombatAlerts.sunspire.tombNext - currentTime
				CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true) .. " to spawn")
				CombatAlerts.panel.SetRowColor(1, 0, 0.8, 0, 1)
			end

			if (not CombatAlerts.sunspire.lokiGrounded or CombatAlerts.sunspire.atroNext == 0) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
			else
				time = CombatAlerts.sunspire.atroNext - currentTime
				CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time))

				if (time < 10500) then
					CombatAlerts.panel.SetRowColor(2, 1, 0.5, 0, 1)
				else
					CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 1)
				end
			end

		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.fane.zone) then
		local currentTime = GetGameTimeMilliseconds()
		local time

		if (CombatAlerts.fane.geyserActive) then
			time = CombatAlerts.fane.nextGeyserEnd - currentTime
			CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
		else
			time = currentTime - CombatAlerts.fane.lastGeyserEnd
			CombatAlerts.panel.SetRowColor(1, 0, 1, 0, 1)
		end

		CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true))

		time = currentTime - CombatAlerts.fane.lastGeyserPlug

		if (time > CombatAlerts.fane.geyserDuration or not CombatAlerts.fane.geyserActive) then
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		else
			if (time < 3000) then
				CombatAlerts.panel.SetRowColor(2, 0, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			end

			CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time, true, true))
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.maarselok.zone) then
		local currentTime = GetGameTimeMilliseconds()

		if (not CombatAlerts.maarselok.wickedBonds) then
			CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 0)
		elseif (CombatAlerts.maarselok.wickedBonds == 0 and CombatAlerts.maarselok.nextBondage) then
			local time = CombatAlerts.maarselok.nextBondage - currentTime
			CombatAlerts.panel.rows[1].data:SetText("Free for " .. CombatAlerts.FormatTime(time, true))
			CombatAlerts.panel.SetRowColor(1, 0, 1, 0, 1)
		else
			CombatAlerts.panel.rows[1].data:SetText(string.format("%dk", (CombatAlerts.maarselok.wickedBonds + 500) / 1000))
			CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
		end

		if (CombatAlerts.maarselok.lastSeed == 0 or not CombatAlerts.maarselok.wickedBonds) then
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		else
			local time = currentTime - CombatAlerts.maarselok.lastSeed
			CombatAlerts.panel.rows[2].data:SetText(CombatAlerts.FormatTime(time, true))
			if (time < 64500) then
				CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(2, 1, 1, 0, 1)
			end
		end
	elseif (CombatAlerts.zoneId == CombatAlertsData.ka.zone) then
		if (CombatAlerts.ka.panelMode == 1) then
			local time = GetGameTimeMilliseconds() - CombatAlerts.ka.lastHarpoon
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true))
			if (time < 38000) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0.5, 0, 1)
			end
		elseif (CombatAlerts.ka.panelMode == 2) then
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.ka.chains)
			CombatAlerts.panel.rows[2].data:SetText(string.format("%.1fm", CombatAlerts.GetDistance("player", CombatAlertsData.ka.falgRoomCenter)))
		elseif (CombatAlerts.ka.panelMode == 3) then
			local time = CombatAlerts.ka.ichor.endTime - GetGameTimeMilliseconds()
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, false, true) .. string.format(" (%d)", CombatAlerts.ka.ichor.counter))
			if (time < 3000 and CombatAlerts.ka.ichor.counter > 1) then
				CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
			elseif (CombatAlerts.ka.ichor.counter > 0) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 0, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			end
		end
	elseif (CombatAlerts.panel.tag == "dsr1") then
		local results = { }
		for i = 1, 2 do
			local unitTag = "boss" .. i
			local current, _, effectiveMax = GetUnitPower(unitTag, COMBAT_MECHANIC_FLAGS_HEALTH)
			if (effectiveMax > 0) then
				table.insert(results, string.format("|c%06X%d%%|r", CombatAlertsData.dsr.twinsColors[i], zo_round(100 * current / effectiveMax)))
			end
		end
		CombatAlerts.panel.rows[3].data:SetText(table.concat(results, " / "))
	elseif (CombatAlerts.panel.tag == "dsr2") then
		local currentTime = GetGameTimeMilliseconds()
		local data = CombatAlerts.dsr.guardians
		local defaultStatus = string.format("|c00FFFF%s|r", GetString(SI_LCA_ACTIVE))

		-- Heartburn status
		local hearts = { }
		for unitId, heart in pairs(data.units) do
			local unitTag = CombatAlerts.bosses[unitId]
			if (unitTag) then
				local time = heart.stop - currentTime
				local color = 0xFFFFFF
				if (time < 10000) then
					color = 0xFF0000
				elseif (time < 20000) then
					color = 0xFFCC00
				end
				hearts[unitTag] = string.format(
					"|cFFFF00%s|r %d (|c%06X%s|r)",
					GetFormattedAbilityName(CombatAlertsData.dsr.heartburn),
					heart.number,
					color,
					CombatAlerts.FormatTime(time, true)
				)
			end
		end

		-- General status
		local statuses = { }
		for unitId, status in pairs(data.statuses) do
			local unitTag = CombatAlerts.bosses[unitId]
			if (unitTag) then
				statuses[unitTag] = string.format(" (|c%06X%s|r)", status.color, status.text)
			end
		end

		-- Boss status
		local rows = { }
		for i = 1, MAX_BOSSES do
			local unitTag = "boss" .. i
			local current, _, effectiveMax = GetUnitPower(unitTag, COMBAT_MECHANIC_FLAGS_HEALTH)
			if (current > 0) then
				table.insert(rows, string.format("#%d: %d%% – %s%s", i, zo_round(100 * current / effectiveMax), hearts[unitTag] or defaultStatus, statuses[unitTag] or ""))
			end
		end

		CombatAlerts.panel.rows[1].data:SetText(table.concat(rows, "\n"))
	elseif (CombatAlerts.panel.tag == "dsr3") then
		local currentTime = GetGameTimeMilliseconds()

		-- Maelstrom
		local time = currentTime - CombatAlerts.dsr.maelstrom.prev
		local remain = CombatAlerts.dsr.maelstrom.duration - time
		if (remain > -500) then
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(remain, true, true))
			CombatAlerts.panel.SetRowColor(1, 1, 0.4, 0.4, 1)
		else
			CombatAlerts.panel.rows[1].data:SetText(CombatAlerts.FormatTime(time, true))
			if (time <= 29000) then
				CombatAlerts.panel.SetRowColor(1, 1, 1, 1, 1)
			else
				CombatAlerts.panel.SetRowColor(1, 1, 0.5, 0, 1)
			end
		end

		-- Winter Storm
		time = CombatAlerts.dsr.stormEnd - currentTime
		if (time > 0) then
			CombatAlerts.panel.rows[2].data:SetText(string.format("%s  %s", CombatAlerts.FormatTime(time, true, true), CombatAlerts.dsr.stormIcon))
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 1)
		else
			CombatAlerts.panel.rows[2].data:SetText("")
			CombatAlerts.panel.SetRowColor(2, 1, 1, 1, 0)
		end

		-- Summon Channelers
		local results = { }
		for i, channel in ipairs(CombatAlerts.dsr.bridge.channels) do
			if (channel.time) then
				local remaining = channel.time - currentTime
				if (channel.time == 0 or remaining > -2000) then
					table.insert(results, string.format("#%d: |c%06X%s|r%s", i, channel.color, channel.name, channel.time > 0 and string.format(" (%s)", CombatAlerts.FormatTime(remaining, true)) or ""))
				end
			end
		end
		if (#results > 0) then
			CombatAlerts.panel.rows[3].data:SetText(table.concat(results, "\n"))
			CombatAlerts.panel.rows[3]:SetHidden(false)
		else
			CombatAlerts.panel.rows[3]:SetHidden(true)
		end
	elseif (CombatAlerts.panel.tag == "gdorbs") then
		local currentTime = GetGameTimeMilliseconds()

		local lines = { }
		for i, id in ipairs(CombatAlerts.ld.orbs.ids) do
			local remaining = CombatAlerts.ld.orbs[id] - currentTime
			local ratio = remaining / 12500
			if (ratio > 1) then
				ratio = 1
			elseif (ratio < 0) then
				ratio = 0
			end
			table.insert(lines, string.format(
				"|c%06X#%d: %s|r",
				LCA.PackRGB(LCA.HSLToRGB(ratio / 3, 1, 0.5)),
				i,
				(remaining < 20000) and CombatAlerts.FormatTime(remaining, true, true) or "OK"
			))
		end

		CombatAlerts.panel.data:SetText(table.concat(lines, "\n"))
	elseif (CombatAlerts.panel.tag == "u37cp") then
		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(CombatAlerts.u37.choking - GetGameTimeMilliseconds(), true))
	elseif (CombatAlerts.panel.tag == "u38b2") then
		CombatAlerts.panel.data:SetText(CombatAlerts.FormatTime(GetGameTimeMilliseconds() - CombatAlerts.u38.lastInferno, true))
	end
end

function CombatAlerts.ToggleTestPanel( enable )
	if (CombatAlerts.panel.enabled) then return end

	if (enable) then
		CombatAlerts.panel.label:SetText(CombatAlerts.title)
		CombatAlerts.panel.data:SetText(CombatAlerts.version)
		CombatAlerts.panel.row:SetHidden(false)

		zo_callLater(function() CombatAlerts.ToggleTestPanel(false) end, 20000)
	end

	CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, enable)
end

function CombatAlerts.TogglePanel( enable, label, usePolling, autoHide )
	CombatAlerts.panel.autoHide = autoHide

	if (enable and not CombatAlerts.panel.enabled) then
		CombatAlerts.panel.enabled = true

		if (type(label) == "table") then
			for i = 1, #label do
				CombatAlerts.panel.rows[i].label:SetText(label[i])
				CombatAlerts.panel.rows[i].data:SetText("")
				CombatAlerts.panel.rows[i]:SetHidden(false)
			end
		else
			CombatAlerts.panel.label:SetText(label)
			CombatAlerts.panel.data:SetText("")
			CombatAlerts.panel.row:SetHidden(false)
		end

		if (usePolling) then
			EVENT_MANAGER:RegisterForUpdate(CombatAlerts.name, CombatAlerts.pollingInterval, CombatAlerts.Poll)
			CombatAlerts.Poll()
		end

		CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, true)
	elseif (not enable and CombatAlerts.panel.enabled) then
		CombatAlerts.panel.enabled = false
		CombatAlerts.panel.tag = nil

		if (usePolling) then
			EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.name)
		end

		for i = 1, CombatAlerts.panelRows do
			CombatAlerts.panel.SetRowColor(i, 1, 1, 1, 1)
			CombatAlerts.panel.rows[i]:SetHidden(true)
		end

		CombatAlerts.ToggleUIFragment(CombatAlerts.panel.fragment, false)
	end
end

function CombatAlerts.ToggleNearby( enable )
	local NearbyPoll = function( )
		-- Show the title text for 5 seconds before displaying data
		if (GetGameTimeMilliseconds() - CombatAlerts.nearby.enabledTime < 5000) then return end

		local a = { 999, nil }
		local b = { 999, nil }
		local result = { { "", "" }, { "", "" } }

		for i = 1, GetGroupSize() do
			local unitTag = GetGroupUnitTagByIndex(i)
			if ((not AreUnitsEqual("player", unitTag)) and IsUnitInGroupSupportRange(unitTag)) then
				local dist = CombatAlerts.GetDistance("player", unitTag)
				if (dist < a[1]) then
					b = a
					a = { dist, unitTag }
				elseif (dist < b[1]) then
					b = { dist, unitTag }
				end
			end
		end

		if (a[2]) then
			result[1] = { string.format("%.1fm", a[1]), GetUnitDisplayName(a[2]) }
			if (b[2]) then
				result[2] = { string.format("%.1fm", b[1]), GetUnitDisplayName(b[2]) }
			end
			CombatAlerts.nearby.placeholder:SetText("")
		else
			CombatAlerts.nearby.placeholder:SetText("No Players Nearby")
		end

		for i = 1, 2 do
			CombatAlerts.nearby.rows[i].range:SetText(result[i][1])
			CombatAlerts.nearby.rows[i].name:SetText(result[i][2])
		end
	end

	local name = CombatAlerts.name .. "Nearby"

	if (enable and not CombatAlerts.nearby.enabled) then
		CombatAlerts.nearby.enabled = true

		CombatAlerts.nearby.placeholder:SetText("Nearby Players")
		CombatAlerts.nearby.enabledTime = GetGameTimeMilliseconds()

		for i = 1, 2 do
			CombatAlerts.nearby.rows[i].range:SetText("")
			CombatAlerts.nearby.rows[i].name:SetText("")
		end

		EVENT_MANAGER:RegisterForUpdate(name, CombatAlerts.pollingInterval, NearbyPoll)

		CombatAlerts.ToggleUIFragment(CombatAlerts.nearby.fragment, true)
	elseif (not enable and CombatAlerts.nearby.enabled) then
		CombatAlerts.nearby.enabled = false

		EVENT_MANAGER:UnregisterForUpdate(name)

		CombatAlerts.ToggleUIFragment(CombatAlerts.nearby.fragment, false)
	end
end

function CombatAlerts.MawTogglePanel( enable )
	CombatAlerts.maw.enabled = enable
	CombatAlerts.maw.smashes = { }
	CombatAlerts.MawUpdatePanel()
	CombatAlerts.TogglePanel(enable, GetFormattedAbilityName(CombatAlertsData.maw.smash))
end

function CombatAlerts.MawUpdatePanel( flashAlert )
	local units = { }
	local status = ""

	for unit in pairs(CombatAlerts.maw.smashes) do table.insert(units, unit) end
	table.sort(units)
	for i, unit in ipairs(units) do
		local color = (CombatAlerts.maw.smashes[unit] == 2) and "FFCC00" or "FFFFFF"
		status = status .. string.format("|c%s%d – %s|r\n", color, CombatAlerts.maw.smashes[unit], unit)
	end

	CombatAlerts.panel.data:SetText(status)

	if (flashAlert) then
		CombatAlerts.panel.label:SetColor(1, 0, 0, 1)
		PlaySound(SOUNDS.OBJECTIVE_DISCOVERED)
		zo_callLater(function() CombatAlerts.panel.label:SetColor(1, 1, 1, 1) end, 1500)
	end
end

function CombatAlerts.CloudrestPreyedUpdatePanel( )
	local units = { }
	local status = ""

	for unit in pairs(CombatAlerts.cloudrest.preyed) do table.insert(units, unit) end
	table.sort(units)
	for i, unit in ipairs(units) do
		local color = (CombatAlerts.cloudrest.preyed[unit] > 6) and "FF9900" or "FFFFFF"
		status = status .. string.format("|c%s%d – %s|r\n", color, CombatAlerts.cloudrest.preyed[unit], unit)
	end

	CombatAlerts.panel.data:SetText(status)
end

function CombatAlerts.BlackroseSpiritUpdatePanel( )
	CombatAlerts.ConsolidatedCall("Spirits", 25, function( )
		local spirits = CombatAlerts.brp.spirits
		if (spirits == 0) then
			CombatAlerts.panel.SetRowColor(1, 0, 1, 0, 1)
		elseif (spirits == 1) then
			CombatAlerts.panel.SetRowColor(1, 1, 1, 0, 1)
		elseif (spirits == 2) then
			CombatAlerts.panel.SetRowColor(1, 1, 0.5, 0, 1)
		else
			CombatAlerts.panel.SetRowColor(1, 1, 0, 0, 1)
		end
		CombatAlerts.panel.data:SetText(spirits)
	end)
end

function CombatAlerts.FangLairToggleTimer( enable )
	CombatAlerts.fanglair.nextGrip = 0
	CombatAlerts.ToggleContinuousListen(enable)
	CombatAlerts.TogglePanel(enable, GetFormattedAbilityName(CombatAlertsData.fanglair.grip), true)
end

function CombatAlerts.FangLairResetTimer( interval )
	local nextGrip = GetGameTimeMilliseconds() + interval
	if (CombatAlerts.fanglair.nextGrip < nextGrip) then
		CombatAlerts.fanglair.nextGrip = nextGrip
	end
end

function CombatAlerts.MaarselokEnablePanel( resetSeed )
	if (not CombatAlerts.panel.enabled) then
		if (resetSeed) then CombatAlerts.maarselok.lastSeed = 0 end
		CombatAlerts.TogglePanel(true, { GetFormattedAbilityName(CombatAlertsData.maarselok.bonds), GetFormattedAbilityName(CombatAlertsData.maarselok.seed) }, true, true)
	end
end

function CombatAlerts.ScalecallerBreathEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == ACTION_RESULT_BEGIN and CombatAlertsData.scalecaller.blastIds[abilityId]) then
		CombatAlerts.scalecaller.blastAll = GetGameTimeMilliseconds()
	else
		CombatAlerts.Alert(GetFormattedAbilityName(CombatAlerts.scalecaller.blastId), CombatAlertsData.scalecaller.blastIds[CombatAlerts.scalecaller.blastId], 0x00CC00FF, SOUNDS.DUEL_START, 2000)
	end

	return(true)
end

function CombatAlerts.HallsFeedbackEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == ACTION_RESULT_EFFECT_GAINED_DURATION and abilityId == CombatAlertsData.hof.feedback and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.launchTime = GetGameTimeMilliseconds()
		CombatAlerts.hof.feedback.travelTime = hitValue
		if (CombatAlerts.hof.feedback.launchTime - CombatAlerts.hof.feedback.shieldTime < 100) then
			-- Shield event happened before launch event (unexpected)
			CombatAlerts.hof.feedback.alert = true
		end
	elseif (result == ACTION_RESULT_DAMAGE_SHIELDED and abilityId == CombatAlertsData.hof.feedbackShield and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.strength = hitValue
		CombatAlerts.divertNextEvent = CombatAlerts.HallsFeedbackEvent
	elseif (CombatAlertsData.damageEvents[result] and hitValue == 0 and sourceType == COMBAT_UNIT_TYPE_PLAYER) then
		CombatAlerts.hof.feedback.shieldTime = GetGameTimeMilliseconds()
		CombatAlerts.hof.feedback.abilityId = abilityId
		if (CombatAlerts.hof.feedback.shieldTime - CombatAlerts.hof.feedback.launchTime < 100) then
			-- Shield event happened after launch event (expected)
			CombatAlerts.hof.feedback.alert = true
		end
	end

	if (CombatAlerts.hof.feedback.alert) then
		CombatAlerts.hof.feedback.alert = false

		CombatAlerts.AlertChat(LocalizeString(
			"Incoming <<1>> <<t:2>> from <<t:3>> in <<4>>ms",
			CombatAlerts.hof.feedback.strength,
			GetAbilityName(CombatAlertsData.hof.feedback),
			GetAbilityName(CombatAlerts.hof.feedback.abilityId),
			CombatAlerts.hof.feedback.travelTime)
		)

		if (CombatAlerts.hof.feedback.strength >= 7500) then
			CombatAlerts.AlertCast(CombatAlertsData.hof.feedback, nil, CombatAlerts.hof.feedback.travelTime, { 0, 0, false, { 0, 0.5, 1, 1 } })
			if (CombatAlerts.hof.feedback.strength >= 12000) then
				PlaySound(SOUNDS.DUEL_START)
			end
		end

		CombatAlerts.hof.feedback.launchTime = 0
		CombatAlerts.hof.feedback.shieldTime = 0
	end

	return(true)
end

function CombatAlerts.KynesGroundIchorGuardEvent( eventCode, result, isError, abilityName, abilityGraphic, abilityActionSlotType, sourceName, sourceType, targetName, targetType, hitValue, powerType, damageType, log, sourceUnitId, targetUnitId, abilityId )
	if (result == CombatAlerts.ka.groundIchor.result and abilityId == CombatAlerts.ka.groundIchor.abilityId and targetType == COMBAT_UNIT_TYPE_PLAYER) then
		return(true)
	else
		return(false)
	end
end

function CombatAlerts.KynesMeteorUpdate( )
	local currentTime = GetGameTimeMilliseconds()
	local nextHit = nil
	local nearby = 0
	local onSelf = false
	for unitId, hitTime in pairs(CombatAlerts.ka.meteor.units) do
		if (currentTime > hitTime + 100) then
			CombatAlerts.ka.meteor.units[unitId] = nil
		else
			if (not nextHit or nextHit > hitTime) then
				nextHit = hitTime
			end
			if (unitId == CombatAlerts.ka.meteor.selfId) then
				onSelf = true
				nearby = nearby + 1
			elseif (CombatAlerts.DistanceCheck(unitId, 5.5)) then
				nearby = nearby + 1
			end
		end
	end

	if (nextHit) then
		local params = CombatAlerts.ka.meteor.params

		local color = 0xDDFFDDFF
		if (nearby == 1) then
			color = 0xFFAADDFF
		elseif (nearby > 1) then
			color = 0xFF0000FF
		end

		CombatAlerts.ModifyBanner(
			CombatAlerts.ka.meteor.bannerId,
			nil,
			GetFormattedAbilityName(params.id) .. ((onSelf) and " (You)" or " (Others)"),
			(onSelf) and params.colorSelf or params.colorOthers,
			1 - ((nextHit - currentTime) / CombatAlerts.ka.meteor.duration),
			nearby,
			color,
			true
		)
	else
		CombatAlerts.DisableBanner(CombatAlerts.ka.meteor.bannerId)
		CombatAlerts.ka.meteor = { units = { } }
	end
end

function CombatAlerts.DreadsailDelugeReset( )
	if (CombatAlerts.dsr.deluge.bannerId) then
		CombatAlerts.DisableBanner(CombatAlerts.dsr.deluge.bannerId)
	end
	CombatAlerts.dsr.deluge = { units = { } }
end

function CombatAlerts.DreadsailDelugeUpdate( )
	local currentTime = GetGameTimeMilliseconds()
	local nextHit = nil
	local nearby = 0
	local onSelf = false
	local failures = nil
	for unitId, hitTime in pairs(CombatAlerts.dsr.deluge.units) do
		if (currentTime > hitTime + 100) then
			CombatAlerts.dsr.deluge.units[unitId] = nil
		else
			if (not nextHit or nextHit > hitTime) then
				nextHit = hitTime
			end

			if (unitId == CombatAlerts.dsr.deluge.selfId) then
				onSelf = true
			end

			local unitTag = CombatAlerts.units[unitId] and CombatAlerts.units[unitId].tag

			if (unitTag and not IsUnitSwimming(unitTag)) then
				if (onSelf or CombatAlerts.DistanceCheck(unitId, 19.1)) then
					nearby = nearby + 1
				end

				local name = CombatAlerts.units[unitId].name
				if (not failures) then
					failures = { name }
				else
					table.insert(failures, name)
				end
			end
		end
	end

	if (failures) then
		CombatAlerts.dsr.delugeFailures = failures
	end

	if (nextHit) then
		local params = CombatAlertsData.dsr.deluge

		CombatAlerts.ModifyBanner(
			CombatAlerts.dsr.deluge.bannerId,
			nil,
			GetFormattedAbilityName(params.start) .. ((onSelf) and " (You)" or " (Others)"),
			(onSelf) and params.colorSelf or params.colorOthers,
			1 - ((nextHit - currentTime) / CombatAlerts.dsr.deluge.duration),
			nearby,
			(nearby == 0) and 0x00FF00FF or 0xFF0000FF,
			true
		)
	else
		CombatAlerts.DreadsailDelugeReset()
	end
end

do
	local DISABLED = "Vanilla status panels for Dreadsail Reef suppressed by external addon request"
	local ENABLED = "Vanilla status panels for Dreadsail Reef re-enabled"

	function CombatAlerts.ToggleDSRPanel( enabled )
		local message
		if (not enabled and CombatAlerts.dsr.panel) then
			message = DISABLED
		elseif (enabled and not CombatAlerts.dsr.panel) then
			message = ENABLED
		end
		if (message) then
			CombatAlerts.dsr.panel = enabled
			CHAT_ROUTER:AddSystemMessage(string.format("[%s] %s", CombatAlerts.title, message))
		end
	end

	function CombatAlerts.InitializeDSRPanel( )
		if (not CombatAlerts.dsr.panel) then
			CHAT_ROUTER:AddSystemMessage(string.format("[%s] %s", CombatAlerts.title, DISABLED))
		end
	end
end

function CombatAlerts.ToggleUIFragment( fragment, enable )
	if (enable) then
		SCENE_MANAGER:GetScene("hud"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):AddFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):AddFragment(fragment)
	else
		SCENE_MANAGER:GetScene("hud"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("hudui"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBar"):RemoveFragment(fragment)
		SCENE_MANAGER:GetScene("siegeBarUI"):RemoveFragment(fragment)
	end
end

function CombatAlerts.IdentifyUnit( unitTag, unitName, unitId )
	if (not CombatAlerts.units[unitId] and zo_strsub(unitTag, 1, 5) == "group") then
		CombatAlerts.units[unitId] = {
			tag = unitTag,
			name = GetUnitDisplayName(unitTag) or unitName,
		}
	elseif (not CombatAlerts.bosses[unitId] and zo_strsub(unitTag, 1, 4) == "boss") then
		CombatAlerts.bosses[unitId] = unitTag
	end
end

function CombatAlerts.FormatTime( ms, useShort, useCountdown )
	if (ms < 0) then ms = 0 end

	if (not useCountdown) then
		ms = ms + 500 -- So that floor() rounds to nearest
	end

	if (useCountdown and ms < 3000) then
		return(string.format("%.1fs", ms / 1000))
	elseif (useShort or useCountdown) then
		return(string.format("%ds", zo_floor(ms / 1000)))
	else
		return(string.format(
			"%d:%02d",
			zo_floor(ms / 60000),
			zo_floor(ms / 1000) % 60
		))
	end
end

function CombatAlerts.GetDistance( unitTag1, unitTag2, useHeight, validate )
	local zone1, x1, y1, z1 = GetUnitWorldPosition(unitTag1)
	local zone2, x2, y2, z2

	if (type(unitTag2) == "table") then
		x2 = unitTag2[1]
		y2 = unitTag2[2]
		z2 = unitTag2[3]
	else
		zone2, x2, y2, z2 = GetUnitWorldPosition(unitTag2)
	end

	if (validate and (zone1 == 0 or zone1 ~= zone2)) then
		return(-1)
	elseif (useHeight) then
		return(zo_sqrt((x1 - x2)^2 + (y1 - y2)^2 + (z1 - z2)^2) / 100)
	else
		return(zo_sqrt((x1 - x2)^2 + (z1 - z2)^2) / 100)
	end
end

function CombatAlerts.DistanceCheck( unitId, distance )
	if (unitId and CombatAlerts.units[unitId]) then
		local unitTag = CombatAlerts.units[unitId].tag
		if (IsUnitInGroupSupportRange(unitTag)) then
			local _, x1, _, z1 = GetUnitWorldPosition("player")
			local _, x2, _, z2 = GetUnitWorldPosition(unitTag)
			return(zo_sqrt((x1 - x2)^2 + (z1 - z2)^2) <= distance * 100)
		end
	end
	return(false)
end

function CombatAlerts.GetClosestGroupMember( )
	local player = GetUnitDisplayName("player")
	local resultDistance = -1
	local resultUnit = ""

	for i = 1, GetGroupSize() do
		local unitTag = GetGroupUnitTagByIndex(i)
		if (GetUnitDisplayName(unitTag) ~= player) then
			local distance = CombatAlerts.GetDistance("player", unitTag, false, true)
			if (distance >= 0 and (distance < resultDistance or resultDistance == -1)) then
				resultDistance = distance
				resultUnit = unitTag
			end
		end
	end

	return resultDistance, resultUnit
end

function CombatAlerts.CastAlertsStart( abilityIconId, caption, duration, durationMax, color, action )
	local currentTime = GetGameTimeMilliseconds()
	local id = CombatAlerts.castAlerts.nextId
	CombatAlerts.castAlerts.nextId = CombatAlerts.castAlerts.nextId + 1

	for i = 1, #CombatAlerts.castAlerts.bars do
		local bar = CombatAlerts.castAlerts.bars[i]

		if (not bar.id) then
			CombatAlerts.castAlerts.active[id] = i

			bar.id = id
			bar.delayed = durationMax and duration > durationMax
			bar.duration = (bar.delayed) and durationMax or duration
			bar.endTime = currentTime + duration

			if (action) then
	 			bar.action.time = action[1]
				bar.action.text = action[2]
				bar.action.r = action[3]
				bar.action.g = action[4]
				bar.action.b = action[5]
				bar.action.a = action[6]
				bar.action.sound = action[7]
			else
	 			bar.action.time = 0
	 		end

			if (not color) then color = { 1, 0, 0, 0.5 } end

			bar.ui.caption:SetText(caption)
			bar.ui.icon:SetTexture(GetAbilityIcon(abilityIconId))
			bar.ui.fill:SetCenterColor(color[1], color[2], color[3], color[4])
			bar.ui.fill:SetWidth(0)
			bar.ui.timer:SetText("")
			bar.ui.action:SetText("")

			if (bar.action.time > 0 and bar.action.time < bar.duration) then
				bar.ui.marker:SetAnchor(LEFT, bar.ui.fill, LEFT, CombatAlerts.castAlerts.fillWidth * (1 - bar.action.time / bar.duration), 0)
				bar.ui.marker:SetCenterColor(bar.action.r, bar.action.g, bar.action.b, bar.action.a)
				bar.ui.marker:SetHidden(false)
			else
				bar.ui.marker:SetHidden(true)
			end

			if (not bar.delayed) then
				bar.ui.control:SetAlpha(1)
			end
			CombatAlerts.CastAlertsCheck()
			CombatAlerts.CastAlertsUpdate()

			return(id)
		end
	end

	return(nil)
end

function CombatAlerts.CastAlertsStop( id )
	local index = id and CombatAlerts.castAlerts.active[id]
	if (index) then
		CombatAlerts.castAlerts.active[id] = nil
		CombatAlerts.castAlerts.bars[index].id = nil
		CombatAlerts.castAlerts.bars[index].ui.control:SetAlpha(0)
		CombatAlerts.CastAlertsCheck()
	end
end

function CombatAlerts.CastAlertsUpdate( )
	local currentTime = GetGameTimeMilliseconds()

	for i = 1, #CombatAlerts.castAlerts.bars do
		local bar = CombatAlerts.castAlerts.bars[i]

		if (bar.id) then
			local shouldUpdate = true
			local time = bar.endTime - currentTime

			if (time < -100) then
				CombatAlerts.CastAlertsStop(bar.id)
				shouldUpdate = false
			elseif (time < 0) then
				time = 0
			end

			if (bar.delayed) then
				if (time < bar.duration) then
					bar.delayed = false
					bar.ui.control:SetAlpha(1)
				else
					shouldUpdate = false
				end
			end

			if (shouldUpdate) then
				bar.ui.fill:SetWidth(CombatAlerts.castAlerts.fillWidth * (bar.duration - time) / bar.duration)
				bar.ui.timer:SetText(string.format("%.1fs", time / 1000))

				if (bar.action.time > 0 and time <= bar.action.time) then
					bar.action.time = 0
					bar.ui.marker:SetHidden(true)

					if (bar.action.text) then
						bar.ui.action:SetText(bar.action.text)
					end

					bar.ui.fill:SetCenterColor(bar.action.r, bar.action.g, bar.action.b, bar.action.a)

					if (bar.action.sound) then
						PlaySound(bar.action.sound)
					end
				end
			end
		end
	end
end

function CombatAlerts.CastAlertsCheck( )
	local count = 0

	for i = 1, #CombatAlerts.castAlerts.bars do
		if (CombatAlerts.castAlerts.bars[i].id) then
			count = count + 1
		end
	end

	if (count >= 1 and not CombatAlerts.castAlerts.polling) then
		CombatAlerts.castAlerts.polling = true
		EVENT_MANAGER:RegisterForUpdate(CombatAlerts.name .. "CastAlertsUpdate", CombatAlerts.castUpdateInterval, CombatAlerts.CastAlertsUpdate)
	elseif (count == 0 and CombatAlerts.castAlerts.polling) then
		CombatAlerts.castAlerts.polling = false
		EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.name .. "CastAlertsUpdate")
	end
end

function CombatAlerts.InitializeUI( )
	CombatAlertsNotifications:ClearAnchors()
	CombatAlertsNotifications:SetAnchor(BOTTOM, GuiRoot, CENTER, 0, -100)
	CombatAlertsNotifications:SetHidden(false)

	CombatAlerts.banners = { }

	for i = 1, 2 do
		local control = CombatAlertsNotifications:GetNamedChild("Banner" .. i)
		local radial = control:GetNamedChild("Radial")
		table.insert(CombatAlerts.banners, {
			name = CombatAlerts.name .. "Banner" .. i,
			active = false,
			locked = false,
			control = control,
			minor = control:GetNamedChild("Minor"),
			major = control:GetNamedChild("Major"),
			radial = {
				control = radial,
				border = radial:GetNamedChild("Border"),
				icon = radial:GetNamedChild("Icon"),
				label = radial:GetNamedChild("Label"),
			},
		})
		control:SetAlpha(0)
	end

	for i = 1, 3 do
		local control = CombatAlertsNotifications:GetNamedChild("Cast" .. i)
		table.insert(CombatAlerts.castAlerts.bars, {
			id = nil,
			ui = {
				control = control,
				caption = control:GetNamedChild("Caption"),
				icon = control:GetNamedChild("Icon"),
				fill = control:GetNamedChild("Fill"),
				marker = control:GetNamedChild("Marker"),
				timer = control:GetNamedChild("Timer"),
				action = control:GetNamedChild("Action"),
			},
			delayed = false,
			duration = 0,
			endTime = 0,
			action = {
				time = 0,
				text = "",
				r = 0,
				g = 0,
				b = 0,
				a = 0,
				sound = nil,
			},
		})
		control:SetAlpha(0)
	end

	CombatAlertsPanel:ClearAnchors()
	CombatAlertsPanel:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, CombatAlerts.vars.panelLeft, CombatAlerts.vars.panelTop)
	CombatAlerts.panel = {
		enabled = false,
		autoHide = false,
		rows = { },
		fragment = ZO_HUDFadeSceneFragment:New(CombatAlertsPanel),

		OnMoveStop = function( )
			CombatAlerts.vars.panelLeft = CombatAlertsPanel:GetLeft()
			CombatAlerts.vars.panelTop = CombatAlertsPanel:GetTop()
		end,

		SetRowColor = function( i, r, g, b, a )
			CombatAlerts.panel.rows[i].label:SetColor(r, g, b, a)
			CombatAlerts.panel.rows[i].data:SetColor(r, g, b, a)
		end,
	}

	for i = 1, CombatAlerts.panelRows do
		CombatAlerts.panel.rows[i] = CombatAlertsPanel:GetNamedChild("Row" .. i)
		CombatAlerts.panel.rows[i].label = CombatAlerts.panel.rows[i]:GetNamedChild("Label")
		CombatAlerts.panel.rows[i].data = CombatAlerts.panel.rows[i]:GetNamedChild("Data")
	end

	-- Shortcuts for single-row usage
	CombatAlerts.panel.row = CombatAlerts.panel.rows[1]
	CombatAlerts.panel.label = CombatAlerts.panel.row.label
	CombatAlerts.panel.data = CombatAlerts.panel.row.data

	CombatAlertsNearby:ClearAnchors()
	CombatAlertsNearby:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, CombatAlerts.vars.nearbyLeft, CombatAlerts.vars.nearbyTop)
	CombatAlerts.nearby = {
		enabled = false,
		enabledTime = 0,
		rows = { },
		placeholder = CombatAlertsNearby:GetNamedChild("Placeholder"),
		fragment = ZO_HUDFadeSceneFragment:New(CombatAlertsNearby),

		OnMoveStop = function( )
			CombatAlerts.vars.nearbyLeft = CombatAlertsNearby:GetLeft()
			CombatAlerts.vars.nearbyTop = CombatAlertsNearby:GetTop()
		end,
	}

	for i = 1, CombatAlerts.nearbyRows do
		CombatAlerts.nearby.rows[i] = CombatAlertsNearby:GetNamedChild("Row" .. i)
		CombatAlerts.nearby.rows[i].range = CombatAlerts.nearby.rows[i]:GetNamedChild("Range")
		CombatAlerts.nearby.rows[i].name = CombatAlerts.nearby.rows[i]:GetNamedChild("Name")
	end
end

function CombatAlerts.StartBanner( textMinor, textMajor, color, icon, show, sound, lock )
	local id = (CombatAlerts.banners[1].active and not CombatAlerts.banners[2].active) and 2 or 1
	if (CombatAlerts.banners[id].locked) then
		id = (id == 1) and 2 or 1
	end

	CombatAlerts.banners[id].active = true
	CombatAlerts.ModifyBanner(id, textMinor, textMajor, color)

	if (icon) then
		if (type(icon) == "number") then
			icon = GetAbilityIcon(icon)
		end
		CombatAlerts.banners[id].radial.border:StartFixedCooldown(0, CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_REMAINING, false)
		CombatAlerts.banners[id].radial.icon:SetTexture(icon)
		CombatAlerts.banners[id].radial.label:SetText("")
		CombatAlerts.banners[id].radial.control:SetHidden(false)
	else
		CombatAlerts.banners[id].radial.control:SetHidden(true)
	end

	if (show) then
		CombatAlerts.banners[id].control:SetAlpha(1)
	end

	if (sound) then
		PlaySound(sound)
	end

	if (lock == true) then
		CombatAlerts.banners[id].locked = true
	else
		CombatAlerts.banners[id].locked = false
	end

	return(id)
end

function CombatAlerts.ModifyBanner( id, textMinor, textMajor, color, radialPercent, radialText, radialColor, show )
	if (not textMinor or textMinor == "") then textMinor = " " end
	if (not textMajor or textMajor == "") then textMajor = " " end
	if (not color) then color = 0xFFFFFFFF end

	CombatAlerts.banners[id].minor:SetText(textMinor)
	CombatAlerts.banners[id].major:SetText(textMajor)
	CombatAlerts.banners[id].major:SetColor(UnpackRGBA(color))

	if (radialPercent) then
		CombatAlerts.banners[id].radial.border:StartFixedCooldown(radialPercent, CD_TYPE_RADIAL, CD_TIME_TYPE_TIME_REMAINING, false)
	end

	if (radialText) then
		CombatAlerts.banners[id].radial.label:SetText(radialText)
	end

	if (radialColor) then
		CombatAlerts.banners[id].radial.border:SetFillColor(UnpackRGBA(radialColor))
		CombatAlerts.banners[id].radial.label:SetColor(UnpackRGBA(radialColor))
	end

	if (show == true) then
		CombatAlerts.banners[id].control:SetAlpha(1)
	elseif (show == false) then
		CombatAlerts.banners[id].control:SetAlpha(0)
	end
end

function CombatAlerts.DisableBanner( id )
	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	CombatAlerts.banners[id].active = false
	CombatAlerts.banners[id].locked = false
	CombatAlerts.banners[id].radial.control:SetHidden(true)
	CombatAlerts.banners[id].control:SetAlpha(0)
end

function CombatAlerts.Alert( textMinor, textMajor, color, sound, duration )
	if (not duration) then duration = 2000 end

	local id = CombatAlerts.StartBanner(textMinor, textMajor, color, nil, true, sound)

	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	EVENT_MANAGER:RegisterForUpdate(
		CombatAlerts.banners[id].name,
		duration,
		function( )
			CombatAlerts.DisableBanner(id)
		end
	)

	return(id)
end

function CombatAlerts.AlertBannerEx( textMinor, textMajor, color, icon, show, sound, callback )
	local id = CombatAlerts.StartBanner(textMinor, textMajor, color, icon, show, sound, true)

	EVENT_MANAGER:UnregisterForUpdate(CombatAlerts.banners[id].name)
	EVENT_MANAGER:RegisterForUpdate(CombatAlerts.banners[id].name, CombatAlerts.bannerUpdateInterval, callback)

	return(id)
end

function CombatAlerts.AlertCast( abilityId, sourceName, duration, options )
	if (not CombatAlerts.vars.castAlertsEnabled) then
		return(nil)
	end

	if (not options) then
		options = { 0, 0, false, nil, nil }
	end

	local caption, time, text, r, g, b, a, sound

	if (sourceName and sourceName ~= "") then
		caption = LocalizeString("<<t:1>> (<<2>>)", GetAbilityName(abilityId), sourceName)
	else
		caption = LocalizeString("<<t:1>>", GetAbilityName(abilityId))
	end

	if (options[1] == -1) then
		local _, maxRange = GetAbilityRange(abilityId)
		options[1] = (maxRange <= 700) and -2 or -3
	end

	if (options[1] > 0) then
		time = options[1]
	elseif (options[1] == -2) then
		time = CombatAlerts.dodgeDuration
	elseif (options[1] == -3) then
		time = CombatAlerts.dodgeDuration * CombatAlerts.vars.projectileTimingAdjustment
	else
		time = 0
	end

	text = nil
	sound = nil

	if (options[2] == 1 or (options[2] == 2 and not CombatAlerts.isTank)) then
		text = CombatAlerts.dodgeText
		if (CombatAlerts.vars.castAlertsSound) then
			sound = SOUNDS.DUEL_START
		end
	end

	color = (options[4]) and options[4] or { 1, 0.7, 0, 0.5 }

	if (options[5]) then
		r = options[5][1]
		g = options[5][2]
		b = options[5][3]
		a = options[5][4]
	elseif (options[4]) then
		r = options[4][1]
		g = options[4][2]
		b = options[4][3]
		a = options[4][4]
	else
		r = 0.8
		g = 0
		b = 0
		a = 0.9
	end

	return CombatAlerts.CastAlertsStart(abilityId, caption, duration, CombatAlerts.vars.maxCastMS, color, { time, text, r, g, b, a, sound })
end

do
	local Border
	local function GetBorder( )
		if (not Border) then
			Border = LCA_ScreenBorder:New()
		end
		return Border
	end

	function CombatAlerts.ScreenBorderEnable( color, duration, borderIdOverride )
		return GetBorder():Enable(color, duration, borderIdOverride)
	end

	function CombatAlerts.ScreenBorderDisable( borderId )
		GetBorder():Disable(borderId)
	end

	-- Legacy compatibility
	function CombatAlerts.AlertBorder( enable, duration, color )
		local colors = {
			["green"] = 0x00AA0088,
			["blue"] = 0x22AAFF99,
			["violet"] = 0xAA00FF77,
		}

		if (type(color) ~= "string" or not colors[color]) then
			color = "green"
		end
		local id = "LegacyAlertBorder_" .. color

		if (enable) then
			GetBorder():Enable(colors[color], duration, id)
		else
			GetBorder():Disable(id)
		end
	end
end

function CombatAlerts.AlertSound( soundId, delayForNext, ... )
	PlaySound(SOUNDS[soundId])
	if (type(delayForNext) == "number") then
		local args = { ... }
		if (#args > 0) then
			zo_callLater(function() CombatAlerts.AlertSound(unpack(args)) end, delayForNext)
		end
	end
end

function CombatAlerts.AlertChat( message )
	CHAT_ROUTER:AddSystemMessage(os.date("[%H:%M:%S] ", GetTimeStamp()) .. message)
end

function CombatAlerts.ConsolidatedCall( key, delay, func )
	local name = string.format("%s_%s", CombatAlerts.name, key)
	EVENT_MANAGER:UnregisterForUpdate(name)
	EVENT_MANAGER:RegisterForUpdate(
		name,
		delay,
		function( )
			EVENT_MANAGER:UnregisterForUpdate(name)
			func()
		end
	)
end

function CombatAlerts.Debug( message )
	if (CombatAlerts.vars.debugEnabled) then
		CHAT_ROUTER:AddSystemMessage(message)
		table.insert(CombatAlerts.vars.debugLog, string.format("[%d / %d / %s] %s", GetTimeStamp(), GetGameTimeMilliseconds(), LocalizeString("<<C:1>>", GetZoneNameByIndex(GetUnitZoneIndex("player"))), message))
	end
end

function CombatAlerts.CheckLegacy( )
	if (PerfectRoll) then
		zo_callLater(
			function() EVENT_MANAGER:UnregisterForEvent(PerfectRoll.name, EVENT_PLAYER_COMBAT_STATE) end,
			3000
		)
	end
end

EVENT_MANAGER:RegisterForEvent(CombatAlerts.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)
