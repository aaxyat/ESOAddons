--------------------------------------------------------------------------------
-- DO NOT USE THIS LIBRARY. IT IS A WORK IN PROGRESS, ITS INTERFACES ARE NOT
-- STABLE AND IT IS NOT INTENDED FOR USE BY OTHERS AT THIS TIME. THIS MESSAGE
-- WILL BE REMOVED ONCE THIS LIBRARY IS DEEMED SUITABLE FOR GENERAL USE.
--------------------------------------------------------------------------------

local LCCC = LibCodesCommonCode
local Internal = LibCombatAlertsInternal
local Public = LibCombatAlerts


--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Public Functions
--------------------------------------------------------------------------------

Public.UnpackRGBA = LCCC.Int32ToRGBA
Public.UnpackRGB = LCCC.Int24ToRGB
Public.PackRGBA = LCCC.RGBAToInt32
Public.PackRGB = LCCC.RGBToInt24
Public.HSLToRGB = LCCC.HSLToRGB
Public.RunAfterInitialLoadscreen = LCCC.RunAfterInitialLoadscreen
Public.CountTable = LCCC.CountTable

function Public.GetAbilityName( abilityId )
	local name = GetAbilityName(abilityId)
	return (name ~= "") and zo_strformat("<<t:1>>", name) or string.format("[#%d]", abilityId)
end

function Public.PlaySounds( soundId, amplification, delayForNext, ... )
	local sound = soundId and SOUNDS[soundId]
	if (sound) then
		for i = 1, amplification or 1 do
			PlaySound(sound)
		end
	end
	if (type(delayForNext) == "number") then
		local args = { ... }
		if (#args > 0) then
			zo_callLater(function() Public.PlaySounds(unpack(args)) end, delayForNext)
		end
	end
end

function Public.GetTexture( id )
	local path = type(id) == "string" and Internal.Textures[id]
	if (path) then
		return string.format("%sart/%s", Internal.GetRootPath(), path)
	else
		return ""
	end
end
