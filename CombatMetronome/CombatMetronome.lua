-- local Util = DAL:Use("DariansUtilities", 6)
-- CombatMetronome = DAL:Def("CombatMetronome", 4, 1, {
--     onLoad = function(self) self:Init() end,
-- })

CombatMetronome = {
    name = "CombatMetronome",
    major = 5,
    minor = 2,
    version = "1.5.2"
}

local LAM = LibAddonMenu2
local Util = DariansUtilities

Util.onLoad(CombatMetronome, function(self) self:Init() end)

local MIN_WIDTH = 50
local MAX_WIDTH = 500
local MIN_HEIGHT = 10
local MAX_HEIGHT = 100

local INTERVAL = 200


ZO_CreateStringId("SI_BINDING_NAME_COMBATMETRONOME_FORCE", "Force display")

local sounds = {
    "Justice_PickpocketFailed",
    "Dialog_Decline",
    "Ability_Ultimate_Ready_Sound", 
    "Quest_Shared", 
    "Champion_PointsCommitted", 
    "GroupElection_Requested", 
    "Duel_Boundary_Warning",
}

-- local hasSoundPlayed = false

function CombatMetronome:Update()
    local latency = math.min(GetLatency(), self.config.maxLatency)
    local time = GetFrameTimeMilliseconds()

    local interval = false
    if time > self.lastInterval + INTERVAL then
        self.lastInterval = time
        interval = true
    end

    if self.currentEvent then
        local ability = self.currentEvent.ability
        local start = self.currentEvent.start

        local duration = math.max(ability.heavy and 0 or (self.gcd or 1000), ability.delay) + self.currentEvent.adjust

        if ability.heavy then
            if self.config.displayPingOnHeavy then
                duration = duration + latency
            else
                latency = 0
            end
        end

        if time > start + duration then
            self.currentEvent = nil
            self.bar:SetHidden(true)
        else
            -- Sound contributed to by Seltiix --

            local length = duration - latency

            if not self.soundTockPlayed and self.config.soundTockEnabled and time > start + (length / 2) - self.config.soundTockOffset then
                self.soundTockPlayed = true
                PlaySound(self.config.soundTockEffect)
            end

            if not self.soundTickPlayed and self.config.soundTickEnabled and time > start + length - self.config.soundTickOffset then
                self.soundTickPlayed = true
                PlaySound(self.config.soundTickEffect)
            end

            self.bar.segments[2].progress = (1 - (time - start) / duration)
            self.bar.segments[1].progress = latency / duration
            self.bar:Update()
            self.bar:SetHidden(false)
        end
    else
        self.bar:SetHidden(true)
    end
end

function CombatMetronome:UpdateLabels()
    local time = GetFrameTimeMilliseconds()

    local showResources = Util.Targeting.isUnitValidCombatTarget("reticleover", self.config.showResourcesForGuard)
                          or IsUnitInCombat("player")
                          or self.force

    if showResources and self.config.showUltimate then        
        local ult = GetUnitPower("player", POWERTYPE_ULTIMATE)
        self.ultLabel:SetText(ult)
        self.ultLabel:SetHidden(false)
    else
        self.ultLabel:SetHidden(true)
    end

    if showResources and self.config.showStamina then
        local stam, _, maxStam = GetUnitPower("player", POWERTYPE_STAMINA)
        self.stamLabel:SetText(stam == maxStam and "" or string.format("%i%%", 100 * stam / maxStam))
        self.stamLabel:SetHidden(false)
    else
        self.stamLabel:SetHidden(true)
    end

    local hp, _, maxHp = GetUnitPower("reticleover", POWERTYPE_HEALTH)
    if showResources and self.config.showHealth and hp > 0 then
        local showAbsolute = not self.inCombat or hp == maxHp

        if 100 * (hp / maxHp) < self.config.hpHighlightThreshold then
            self.hpLabel:SetColor(1, 0, 0, 1)
            -- self.hpLabel:SetAnchor(CENTER, GuiRoot, CENTER, 0, 50)
            self.hpLabel:SetFont(Util.Text.getFontString(nil, 50, "outline"))

            local PERIOD = 1000

            local mix = (1 + math.sin(time * math.pi * 2 / PERIOD)) / 2
            local colour = Util.Vectors.mix({ 1, 1, 1, 1 }, { 1, 0, 0, 1 }, mix)

            self.hpLabel:SetColor(unpack(colour))

        else
            self.hpLabel:SetColor(1, 1, 1, 1)
            -- self.hpLabel:SetAnchor(BOTTOMRIGHT, self.frame.body, TOPRIGHT, 0, 0)
            self.hpLabel:SetFont(Util.Text.getFontString(nil, 30, "outline"))
        end

        self.hpLabel:SetText((showAbsolute or self.force)
            and Util.Text.formatNumberCompact(hp)
            or  string.format("%i%%", 100 * hp / maxHp)
        )
        self.hpLabel:SetHidden(false)
    else
        self.hpLabel:SetHidden(true)
    end
end

function CombatMetronome:HandleCombatEvents(...)
    local e = Util.CombatEvent:New(...)

    if e:IsPlayerTarget() and not e:IsError() then
        local r = e:GetResult()
        if r == ACTION_RESULT_KNOCKBACK
        or r == ACTION_RESULT_PACIFIED
        or r == ACTION_RESULT_STAGGERED
        or r == ACTION_RESULT_STUNNED
        or r == ACTION_RESULT_INTERRUPTED then
            self.currentEvent = nil
            return
        end
    end
end

local DEFAULT_SAVED_VARS = {
    ["xOffset"] = math.floor((GuiRoot:GetWidth() - 250) / 2),
    ["yOffset"] = math.floor((GuiRoot:GetHeight() - 40) / 2),
    ["width"] = 250,
    ["height"] = 40,
    ["backgroundColour"] = { 0, 0, 0, 0.5 },
    ["progressColour"] = { 1, 0.84, 0.24, 0.63 },
    ["pingColour"] = { 1, 0, 0, 0.63 },
    ["gcdAdjust"] = 0,
    ["align"] = "Center",
    ["showOOC"] = true,
    ["displayPingOnHeavy"] = true,
    ["debug"] = false,
    ["globalHeavyAdjust"] = 25,
    ["globalAbilityAdjust"] = 25,
    ["abilityAdjusts"] = { },
    ["showUltimate"] = true,
    ["showStamina"] = true,
    ["showHealth"] = true,
    ["showResourcesForGuard"] = false,
    ["maxLatency"] = 150,
    ["global"] = false,
    ["hpHighlightThreshold"] = 25,
    ["reticleHp"] = false,
    ["soundTickEnabled"] = false,
    ["soundTickEffect"] = "Justice_PickpocketFailed",
    ["soundTickOffset"] = 200,
    ["soundTockEnabled"] = false,
    ["soundTockEffect"] = "Dialog_Decline",
    ["soundTockOffset"] = 300,
}

function CombatMetronome:Init()
    self.config = ZO_SavedVars:NewCharacterIdSettings("CombatMetronomeSavedVars", 1, nil, DEFAULT_SAVED_VARS)
    if self.config.global then
        self.config = ZO_SavedVars:NewAccountWide("CombatMetronomeSavedVars", 1, nil, DEFAULT_SAVED_VARS)
        self.config.global = true
    end

    self.log = self.config.debug

    self.inCombat = IsUnitInCombat("player")
    self.currentEvent = nil

    self.gcd = 1000

    self.unlocked = false
    self:BuildUI()
    self:BuildMenu()

    self.lastInterval = 0

    EVENT_MANAGER:RegisterForUpdate(
        self.name.."Update",
        1000 / 60,
        function(...) self:Update() end
    )

    EVENT_MANAGER:RegisterForUpdate(
        self.name.."UpdateLabels",
        1000 / 60,
        function(...) self:UpdateLabels() end
    )

    EVENT_MANAGER:RegisterForEvent(
        self.name.."CombatStateChange",
        EVENT_PLAYER_COMBAT_STATE,
        function(_, inCombat) 
            self.inCombat = inCombat == true
            -- self.stamGradient:Reset()
        end
    )
    
    EVENT_MANAGER:RegisterForEvent(
        self.name.."SlotUsed",
        EVENT_ACTION_SLOT_ABILITY_USED,
        function(e, slot)
            local ability = Util.Ability:ForId(GetSlotBoundId(slot))
            -- log("Abilty used - ", ability.name)
            if (ability and ability.heavy) then
                -- log("Cancelling heavy")
                self.currentEvent = nil
            end
        end
    )

    Util.Ability.Tracker.CombatMetronome = self
    Util.Ability.Tracker:Start()
end

function CombatMetronome:HandleAbilityUsed(event)
    -- if not (self.inCombat or self.config.showOOC) then return end

    self.soundTickPlayed = false
    self.soundTockPlayed = false

    local ability = event.ability

    event.adjust = (self.config.abilityAdjusts[ability.id] or 0)
                    + ((ability.instant and self.config.gcdAdjust)
                    or (ability.heavy and self.config.globalHeavyAdjust)
                    or self.config.globalAbilityAdjust)

    self.currentEvent = event
    self.gcd = Util.Ability.Tracker.gcd
end

function CombatMetronome:BuildUI()

    -- Create Bar Frame

    if not self.frame then
        self.frame = Util.Controls:NewFrame(self.name.."Frame")
        self.frame:SetDimensionConstraints(MIN_WIDTH, MIN_HEIGHT, MAX_WIDTH, MAX_HEIGHT)
        self.frame:SetHandler("OnMoveStop", function(...)
            self.config.xOffset = math.floor(self.frame:GetLeft())
            self.config.yOffset = math.floor(self.frame:GetTop())
            self:BuildUI()
        end)
        self.frame:SetHandler("OnResizeStop", function(...)
            self.config.width = math.floor(self.frame:GetWidth())
            self.config.height = math.floor(self.frame:GetHeight())
            self.BuildUI()
        end)
    end
    self.frame:SetDimensions(self.config.width, self.config.height)
    self.frame:ClearAnchors()
    self.frame:SetAnchor(TOPLEFT, GuiRoot, TOPLEFT, self.config.xOffset, self.config.yOffset)

    -- Create Timer Bar

    self.bar = self.bar or Util.Bar:New(self.name.."TimerBar", self.frame)
    self.bar.background:SetCenterColor(unpack(self.config.backgroundColour))
    self.bar.background:SetDimensions(self.config.width, self.config.height)
    self.bar.background:ClearAnchors()
    self.bar.background:SetAnchorFill()
    self.bar.align = ((self.config.align == "Left") and LEFT)
                  or ((self.config.align == "Center") and CENTER)
                  or  RIGHT
    self.bar:UpdateSegment(1, {
        colour = self.config.pingColour,
    })
    self.bar:UpdateSegment(2, {
        colour = self.config.progressColour,
        clip = true,
    })
    self.bar:SetHidden(true)

    -- Create Label Frame

    self.labelFrame = self.labelFrame or Util.Controls:NewFrame(self.name.."LabelFrame")
    self.labelFrame:SetDimensions(self.config.width, 50)
    self.labelFrame:ClearAnchors()
    self.labelFrame:SetAnchor(BOTTOM, self.frame, TOP, 0, 0)

    -- Create Ultimate Label

    self.ultLabel = self.ultLabel or WINDOW_MANAGER:CreateControl(self.name.."UltLabel", self.labelFrame, CT_LABEL)
    self.ultLabel:ClearAnchors()
    self.ultLabel:SetAnchor(BOTTOM, self.labelFrame, BOTTOM, 0, 0)
    self.ultLabel:SetColor(1, 1, 1, 1)

    self.ultLabel:SetFont(Util.Text.getFontString(nil, 50, "outline"))
    self.ultLabel:SetHidden(false)
    self.ultLabel:SetText("")

    -- Create Stamina Label

    self.stamLabel = self.stamLabel or WINDOW_MANAGER:CreateControl(self.name.."StamLabel", self.labelFrame, CT_LABEL)
    self.stamLabel:ClearAnchors()
    self.stamLabel:SetAnchor(BOTTOMLEFT, self.labelFrame, BOTTOMLEFT, 0, 0)
    self.stamLabel:SetColor(1, 1, 1, 1)
    self.stamLabel:SetFont(Util.Text.getFontString(nil, 30, "outline"))
    self.stamLabel:SetHidden(false)
    self.stamLabel:SetText("")

    -- Create Target Health Label

    self.hpLabel = self.hpLabel or WINDOW_MANAGER:CreateControl(self.name.."HPLabel", self.labelFrame, CT_LABEL)
    self.hpLabel:ClearAnchors()
    if self.config.reticleHp then
        self.hpLabel:SetAnchor(LEFT, GuiRoot, CENTER, 40, 0)
    else
        self.hpLabel:SetAnchor(BOTTOMRIGHT, self.labelFrame, BOTTOMRIGHT, 0, 0)
    end
    self.hpLabel:SetColor(1, 1, 1, 1)
    self.hpLabel:SetFont(Util.Text.getFontString(nil, 30, "outline"))
    self.hpLabel:SetHidden(false)
    self.hpLabel:SetText("")
end

-- MENU

local ABILITY_ADJUST_PLACEHOLDER = "Add ability adjust"
local MAX_ADJUST = 200

function CombatMetronome:UpdateAdjustChoices()
    local names = self.menu.abilityAdjustChoices

    for k in pairs(names) do names[k] = nil end

    for id, adj in pairs(self.config.abilityAdjusts) do
        local name = GetAbilityName(id)
        names[#names + 1] = name
    end

    if #names == 0 then
        names[1] = ABILITY_ADJUST_PLACEHOLDER
        self.menu.curSkillName = ABILITY_ADJUST_PLACEHOLDER
        self.menu.curSkillId = -1
    else
        if not self.config.abilityAdjusts[self.menu.curSkillId] then
            for id, _ in pairs(self.config.abilityAdjusts) do
                self.menu.curSkillId = id
                self.menu.curSkillName = GetAbilityName(id)
                break
            end
        end
    end

    local panelControls = self.menu.panel.controlsToRefresh
    for i = 1, #panelControls do
        local control = panelControls[i]
        if (control.data and control.data.name == "Select skill adjust") then
            control:UpdateChoices()
            control:UpdateValue()
            break
        end
    end
end

function CombatMetronome:BuildMenu()
    -- sounds = { }
    -- for _, sound in pairs(SOUNDS) do
    --     sounds[#sounds + 1] = sound
    -- end

    self.menu = { }
    self.menu.abilityAdjustChoices = { }
    self.menu.curSkillName = ABILITY_ADJUST_PLACEHOLDER
    self.menu.curSkillId = -1
    self.menu.metadata = {
        type = "panel",
        name = "Combat Metronome",
        displayName = "Combat Metronome",
        author = "Darianopolis",
        version = ""..self.version,
        slashCommand = "/cm",
        registerForRefresh = true,
    }
    self.menu.options = {
        {
            type = "header",
            name = "Settings"
        },
        {
            type = "checkbox",
            name = "Account Wide",
            tooltip = "Check for account wide addon settings",
            getFunc = function() return self.config.global end,
            setFunc = function(value) 
                if self.config.global == value then return end

                if value then
                    self.config.global = true
                    self.config = ZO_SavedVars:NewAccountWide(
                        "CombatMetronomeSavedVars", 1, nil, DEFAULT_SAVED_VARS
                    )
                    self.config.global = true
                else
                    self.config = ZO_SavedVars:NewCharacterIdSettings(
                        "CombatMetronomeSavedVars", 1, nil, DEFAULT_SAVED_VARS
                    )
                    self.config.global = false
                end

                self.config.global = value
                self:UpdateAdjustChoices()
                self:BuildUI()
            end,
        },
        {
            type = "header",
            name = "Position / Size",  
        },
        {
            type = "checkbox",
            name = "Unlock",
            tooltip = "Reposition / resize bar by dragging center / edges.",
            getFunc = function() return self.frame.IsUnlocked() end,
            setFunc = function(value)
                self.frame:SetUnlocked(value)
            end,
        },
        {
            type = "slider",
            name = "X Offset",
            min = 0,
            max = math.floor(GuiRoot:GetWidth() - self.config.width),
            step = 1,
            getFunc = function() return self.config.xOffset end,
            setFunc = function(value) 
                self.config.xOffset = value 
                self:BuildUI()
            end,
        },
        {
            type = "button",
            name = "Center Horizontally",
            func = function()
                self.config.xOffset = math.floor((GuiRoot:GetWidth() - self.config.width) / 2)
                self:BuildUI()
            end
        },
        {
            type = "slider",
            name = "Y Offset",
            min = 0,
            max = math.floor(GuiRoot:GetHeight() - self.config.height),
            step = 1,
            getFunc = function() return self.config.yOffset end,
            setFunc = function(value) 
                self.config.yOffset = value 
                self:BuildUI()
            end,
        },
        {
            type = "button",
            name = "Center Vertically",
            func = function()
                self.config.yOffset = math.floor((GuiRoot:GetHeight() - self.config.height) / 2)
                self:BuildUI()
            end
        },
        {
            type = "slider",
            name = "Width",
            min = MIN_WIDTH,
            max = MAX_WIDTH,
            step = 1,
            getFunc = function() return self.config.width end,
            setFunc = function(value) 
                self.config.width = value 
                self:BuildUI()
            end,
        },
        {
            type = "slider",
            name = "Height",
            min = MIN_HEIGHT,
            max = MAX_HEIGHT,
            step = 1,
            getFunc = function() return self.config.height end,
            setFunc = function(value) 
                self.config.height = value 
                self:BuildUI()
            end,
        },
        {
            type = "header",
            name = "Colour / Layout",
        },
        {
            type = "colorpicker",
            name = "Background Colour",
            tooltip = "Colour of the bar background",
            getFunc = function() return unpack(self.config.backgroundColour) end,
            setFunc = function(r, g, b, a)
                self.config.backgroundColour = {r, g, b, a}
                self:BuildUI()
            end,
        },
        {
            type = "colorpicker",
            name = "Progress Colour",
            tooltip = "Colour of the progress bar",
            getFunc = function() return unpack(self.config.progressColour) end,
            setFunc = function(r, g, b, a)
                self.config.progressColour = {r, g, b, a}
                self:BuildUI()
            end,
        },
        {
            type = "colorpicker",
            name = "Ping Colour",
            tooltip = "Colour of the ping zone",
            getFunc = function() return unpack(self.config.pingColour) end,
            setFunc = function(r, g, b, a)
                self.config.pingColour = {r, g, b, a}
                self:BuildUI()
            end,
        },
        {
            type = "dropdown",
            name = "Alignment",
            tooltip = "Alignment of the progress bar",
            choices = {"Left", "Center", "Right"},
            getFunc = function() return self.config.align end,
            setFunc = function(value)
                self.config.align = value
                self:BuildUI()
            end,
        },

        -- RESOURCES

        {
            type = "header",
            name = "Resources",
        },
        {
            type = "checkbox",
            name = "Show Ultimate",
            tooltip = "Toggle show ultimate above cast bar",
            getFunc = function() return self.config.showUltimate end,
            setFunc = function(value) self.config.showUltimate = value end,
        },
        {
            type = "checkbox",
            name = "Show Stamina",
            tooltip = "Toggle show stamina above cast bar",
            getFunc = function() return self.config.showStamina end,
            setFunc = function(value) self.config.showStamina = value end,
        },
        {
            type = "checkbox",
            name = "Show Target Health",
            tooltip = "Toggle show target health above cast bar",
            getFunc = function() return self.config.showHealth end,
            setFunc = function(value) self.config.showHealth = value end,
        },
        {
            type = "checkbox",
            name = "Attach Target Health to reticle",
            tooltip = "Attach Target Health to side of reticle",
            getFunc = function() return self.config.reticleHp end,
            setFunc = function(value) 
                self.config.reticleHp = value
                self:BuildUI()
            end,
        },
        {
            type = "slider",
            name = "Target Health execute highlight threshold",
            tooltip = "Set the threshold for target health highlighting (Set 0% for no highlight)",
            min = 0,
            max = 100,
            getFunc = function() return self.config.hpHighlightThreshold end,
            setFunc = function(value) self.config.hpHighlightThreshold = value end,
        },
        {
            type = "checkbox",
            name = "Show resources when targeting guard",
            tooltip = "Show resources when targeting guard",
            getFunc = function() return self.config.showResourcesForGuard end,
            setFunc = function(value) self.config.showResourcesForGuard = value end,
        },

        -- BEHAVIOUR

        {
            type = "header",
            name = "Behaviour"
        },
        {
            type = "slider",
            name = "Max latency",
            tooltip = "Set the maximum display latency",
            min = 0,
            max = 1000,
            step = 1,
            getFunc = function() return self.config.maxLatency end,
            setFunc = function(value) self.config.maxLatency = value end,
        },
        {
            type = "slider",
            name = "GCD Adjust",
            tooltip = "Increase/decrease the displayed GCD length",
            min = -MAX_ADJUST,
            max = MAX_ADJUST,
            step = 1,
            getFunc = function() return self.config.gcdAdjust end,
            setFunc = function(value) 
                self.config.gcdAdjust = value 
                self:BuildUI()
            end,
        },
        {
            type = "slider",
            name = "Global Heavy Attack Adjust",
            tooltip = "Increase/decrease the baseline heavy attack cast time. Additional adjustments to specific heavy types are made in addition to this",
            min = -MAX_ADJUST,
            max = MAX_ADJUST,
            step = 1,
            getFunc = function() return self.config.globalHeavyAdjust end,
            setFunc = function(value) 
                self.config.globalHeavyAdjust = value 
            end
        },
        {
            type = "slider",
            name = "Global Ability Cast Adjust",
            tooltip = "Increase/decrease the baseline ability cast time. Additional adjustments to specific abilites are made in addition to this",
            min = -MAX_ADJUST,
            max = MAX_ADJUST,
            step = 1,
            getFunc = function() return self.config.globalAbilityAdjust end,
            setFunc = function(value)
                self.config.globalAbilityAdjust = value
            end
        },
        -- {
        --     type = "checkbox",
        --     name = "Show OOC",
        --     tooltip = "Track GCDs whilst out of combat",
        --     getFunc = function() return self.config.showOOC end,
        --     setFunc = function(value)
        --         self.config.showOOC = value
        --     end
        -- },
        {
            type = "checkbox",
            name = "Display ping zone on heavy attacks",
            tooltip = "Displays heavy attacks with ping zone - Heavy attack cast will finish at start on entering ping zone "
                                .."(heavy attack timing is calculated locally). This is for visual consistency",
            getFunc = function() return self.config.displayPingOnHeavy end,
            setFunc = function(value)
                self.config.displayPingOnHeavy = value
            end
        },

        -- ABILITY TIMER ADJUSTS --

        {
            type = "header",
            name = "Ability timer adjusts",
            description = "Adjusts timers on specific skills - This is applied ON TOP of relevant global adjust",
        },
        {
            type = "editbox",
            name = "Add skill to adjust",
            isMultiline = false,
            getFunc = function() return "" end,
            setFunc = function(name)
                if not name or #name == 0 then return end
                for id = 0, 100000 do
                    if GetAbilityName(id) == name then
                        _=self.log and log("Found ability for ", name, " id = ", id)
                        self.menu.curSkillName = name
                        self.menu.curSkillId = id
                        self.config.abilityAdjusts[id] = 0
                        self:UpdateAdjustChoices()
                        return
                    end
                end
                log("CM - Could not find valid ability named ", name, "!")
            end
        },
        {
            type = "dropdown",
            name = "Select skill adjust",
            choices = self.menu.abilityAdjustChoices,
            getFunc = function() return self.menu.curSkillName end,
            setFunc = function(value) 
                self.menu.curSkillName = value
                for id, adj in pairs(self.config.abilityAdjusts) do
                    if GetAbilityName(id) == value then
                        self.menu.curSkillId = id
                    end
                end
            end
        },
        {
            type = "slider",
            name = "Modify skill adjust",
            min = -MAX_ADJUST,
            max = MAX_ADJUST,
            step = 1,
            getFunc = function() return self.config.abilityAdjusts[self.menu.curSkillId] or 0 end,
            setFunc = function(value)
                if self.config.abilityAdjusts[self.menu.curSkillId] then
                    self.config.abilityAdjusts[self.menu.curSkillId] = value
                end
            end
        },
        {
            type = "button",
            name = "Remove skill adjust",
            func = function()
                _=DLog and log("Removing skill ", self.menu.curSkillName, " id: ", self.menu.curSkillId)
                self.config.abilityAdjusts[self.menu.curSkillId] = nil
                self:UpdateAdjustChoices()
            end
        },

        -- SOUND (Seltiix) --

        {
            type = "header",
            name = "Sound",  
        },

        {
            type = "checkbox",
            name = "Sound 'tick'",
            tooltip = "Enable sound 'tick'",
            getFunc = function() return self.config.soundTickEnabled end,
            setFunc = function(state)
                self.config.soundTickEnabled = state
            end,
        },
        {
            type = "dropdown",
            name = "Sound 'tick' effect",
            choices = sounds,
            getFunc = function() return self.config.soundTickEffect end,
            setFunc = function(value)
                self.config.soundTickEffect = value
                PlaySound(value)
            end,
        },
        {
            type = "slider",
            name = "Sound 'tick' offset",
            min = 0,
            max = 1000,
            step =  1,
            getFunc = function() return self.config.soundTickOffset end,
            setFunc = function(value)
                self.config.soundTickOffset = value
            end,
        },

        {
            type = "checkbox",
            name = "Sound 'tock'",
            tooltip = "Offcycle sound cue",
            getFunc = function() return self.config.soundTockEnabled end,
            setFunc = function(state)
                self.config.soundTockEnabled = state
            end,
        },
        {
            type = "dropdown",
            name = "Sound 'tock' effect",
            choices = sounds,
            getFunc = function() return self.config.soundTockEffect end,
            setFunc = function(value)
                self.config.soundTockEffect = value
                PlaySound(value)
            end,
        },
        {
            type = "slider",
            name = "Sound 'tock' offset",
            min = 0,
            max = 1000,
            step = 1,
            getFunc = function() return self.config.soundTockOffset end,
            setFunc = function(value)
                self.config.soundTockOffset = value
            end,
        },

        -- EXPERIMENTAL -- 

        {
            type = "header",
            name = "Experimental",
            description = "Features under development"
        },
        {
            type = "checkbox",
            name = "Debug",
            getFunc = function() return self.config.debug end,
            setFunc = function(value)
                self.config.debug = value
                self.log = value
            end
        }
    }

    self.menu.panel = LAM:RegisterAddonPanel(self.name.."Options", self.menu.metadata)
    LAM:RegisterOptionControls(self.name.."Options", self.menu.options)

    self:UpdateAdjustChoices()
end

-- LOAD HOOK

-- EVENT_MANAGER:RegisterForEvent(CombatMetronome.name.."Load", EVENT_ADD_ON_LOADED, function(...)
--     if (CombatMetronome.loaded) then return end
--     CombatMetronome.loaded = true

--     CombatMetronome:Init()
-- end)