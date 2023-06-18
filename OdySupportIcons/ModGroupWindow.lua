local aigwUpdateLeader = nil
local gwConfig         = {
    ["dead"]     = false,
    ["mechanic"] = false,
    ["raid"]     = false,
    ["leader"]   = false,
    ["tank"]     = false,
    ["healer"]   = false,
    ["dps"]      = false,
    ["bg"]       = false,
    ["custom"]   = false,
    ["unique"]   = false,
    ["anim"]     = true,
}

local function GroupWindowStopAnimation( anim )
    if anim then
        anim.gfx = nil

        if anim.timeline:IsPlaying() then
            anim.timeline:Stop()
        end
    end
end

function OSI.GroupWindowContextMenu()
    -- create context menu for group list
    local onMouseUp = GROUP_LIST.GroupListRow_OnMouseUp
    function GROUP_LIST:GroupListRow_OnMouseUp( control, button, upInside )
        onMouseUp( self, control, button, upInside )
        local unit = ZO_ScrollList_GetData( control )
        if button == MOUSE_BUTTON_INDEX_RIGHT and upInside then
            local allow = OSI.GetOption( "raidallow" )
            local name  = string.lower( unit.displayName )
            local show  = false
            -- avoid changing icons assigned by raidlead
            if ( not allow or not OSI.raidlead or not OSI.raidlead[name] or not HodorReflexes ) then
                if OSI.special[name] and OSI.special[name].texture ~= OSI.users[name] then
                    AddMenuItem( "Change Custom Icon", function() OSI.ChooseCustomIconForUnit( name ) end )
                    AddMenuItem( "Remove Custom Icon", function() OSI.RemoveCustomIconFromUnit( name ) end )
                else
                    AddMenuItem( "Assign Custom Icon", function() OSI.ChooseCustomIconForUnit( name ) end )
                end
                show = true
            end
            -- add raidlead commands
            if AreUnitsEqual( "player", GetGroupLeaderUnitTag() ) and allow and OSI.GetOption( "raidforce" ) and HodorReflexes then
                if OSI.raidlead and OSI.raidlead[name] then
                    AddMenuItem( "Change Raid Icon", function() OSI.ChooseRaidIconForUnit( name ) end )
                    AddMenuItem( "Remove Raid Icon", function() OSI.RemoveRaidIconForUnit( name ) end )
                else
                    AddMenuItem( "Assign Raid Icon", function() OSI.ChooseRaidIconForUnit( name ) end )
                end
                if OSI.raidlead then
                    AddMenuItem( "Remove all Raid Icons", function() OSI.RemoveAllRaidIcons() end )
                end
                show = true
            end
            if show then
                self:ShowMenu( control )
            end
        end
    end
end

function OSI.GroupWindowHook()
    -- show custom icons in group list
    local setupEntry = GROUP_LIST.SetupGroupEntry
    function GROUP_LIST:SetupGroupEntry( control, data )
        setupEntry( self, control, data )

        local gwroles   = OSI.GetOption( "gwroles" )
        gwConfig.raid   = OSI.GetOption( "raidallow" )
        gwConfig.dead   = OSI.GetOption( "gwdead" )
        gwConfig.tank   = gwroles
        gwConfig.healer = gwroles
        gwConfig.dps    = gwroles
        gwConfig.bg     = gwroles
        gwConfig.custom = OSI.GetOption( "gwuse" )
        gwConfig.unique = OSI.GetOption( "gwunique" )

        local displayName        = string.lower( data.displayName )
        local tex, col, _, hodor = OSI.GetIconDataForPlayer( data.displayName, gwConfig, data.unitTag )
        local icon               = control.leaderIcon
        local status             = icon:GetNamedChild( "Overlay" )
        local anim               = control.animData

        if tex then
            if not status then
                status = icon:CreateControl( icon:GetName() .. "Overlay", CT_TEXTURE )
                status:ClearAnchors()
                status:SetParent( icon )
                status:SetAnchor( TOPLEFT, icon, TOPLEFT, 2, 2 )
                status:SetDimensions( icon:GetWidth() - 4, icon:GetHeight() - 4 )
                status:SetDrawLayer( 1 )
            end

            status:SetHidden( false )
            status:SetTexture( tex )
            status:SetDesaturation( data.online and 0 or 1 )
            status:SetColor( col[1], col[2], col[3], 1 )

            icon:SetDrawLayer( 2 )
            icon:SetHidden( false )
            icon:SetTexture( ( OSI.GetOption( "gwcrown" ) and data.leader ) and "odysupporticons/icons/status/status-lead.dds" or OSI.STATUS[PLAYER_STATUS_OFFLINE] )

            if hodor then
                if not anim then
                    local timeline = ANIMATION_MANAGER:CreateTimeline()
                    timeline:SetPlaybackType( ANIMATION_PLAYBACK_LOOP, LOOP_INDEFINITELY )
                    timeline:SetHandler( "OnStop", function() status:SetTextureCoords( 0, 1, 0, 1 ) end )

                    anim = {
                        ["timeline"] = timeline,
                        ["ctrl"]     = timeline:InsertAnimation( ANIMATION_TEXTURE, status ),
                        ["gfx"]      = nil,
                    }
                    
                    control.animData = anim
                end

                if anim.gfx ~= tex then
                    anim.gfx = tex

                    anim.ctrl:SetImageData( hodor[2], hodor[3] )
                    anim.ctrl:SetFramerate( hodor[4] )
                    anim.timeline:PlayFromStart()
                end
            else
                GroupWindowStopAnimation( anim )
            end
        else
            -- use default leader icon
            if data.leader then
                icon:SetTexture( "esoui/art/lfg/lfg_leader_icon.dds" )
                icon:SetHidden( false )
            -- hide icon otherwise
            else
                icon:SetHidden( true )
            end

            GroupWindowStopAnimation( anim )

            if status then
                status:SetHidden( true )
            end
        end
    end

    -- show custom icons in gamepad group list
    local setupRow = GROUP_LIST_GAMEPAD.SetupRow
    function GROUP_LIST_GAMEPAD:SetupRow( control, data, selected )
        setupRow( self, control, data, selected )

        local gwroles   = OSI.GetOption( "gwroles" )
        gwConfig.raid   = OSI.GetOption( "raidallow" )
        gwConfig.dead   = OSI.GetOption( "gwdead" )
        gwConfig.leader = gwroles
        gwConfig.tank   = gwroles
        gwConfig.healer = gwroles
        gwConfig.dps    = gwroles
        gwConfig.bg     = gwroles
        gwConfig.custom = OSI.GetOption( "gwuse" )
        gwConfig.unique = OSI.GetOption( "gwunique" )

        local displayName = string.lower( data.displayName )
        local nameControl = control:GetNamedChild( "DisplayName" )
        local tex         = OSI.GetIconDataForPlayer( data.displayName, gwConfig, data.unitTag )

        if not tex then
            if data.leader then
                -- use default leader icon
                tex = "EsoUI/Art/UnitFrames/Gamepad/gp_Group_Leader.dds"
            else
                -- use empty icon otherwise
                tex = OSI.STATUS[PLAYER_STATUS_OFFLINE]
            end
        end

        nameControl:SetText( zo_iconTextFormat( tex, 32, 32, ZO_FormatUserFacingDisplayName( data.displayName ) ) )
    end
end

function OSI.OverloadAIGW()
    if AIGW then
        if OSI.GetOption( "gwuse" ) or OSI.GetOption( "gwunique" ) or OSI.GetOption( "gwdead" ) or OSI.GetOption( "gwroles" ) or ( OSI.GetOption( "raidallow" ) and HodorReflexes ) then
            if not aigwUpdateLeader then
                aigwUpdateLeader  = AIGW.updateLeader
                AIGW.updateLeader = function() end
            end
        else
            if aigwUpdateLeader then
                AIGW.updateLeader = aigwUpdateLeader
                aigwUpdateLeader  = nil
            end
        end
    end
end
