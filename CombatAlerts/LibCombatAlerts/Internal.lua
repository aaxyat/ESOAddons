--------------------------------------------------------------------------------
-- DO NOT USE THIS LIBRARY. IT IS A WORK IN PROGRESS, ITS INTERFACES ARE NOT
-- STABLE AND IT IS NOT INTENDED FOR USE BY OTHERS AT THIS TIME. THIS MESSAGE
-- WILL BE REMOVED ONCE THIS LIBRARY IS DEEMED SUITABLE FOR GENERAL USE.
--------------------------------------------------------------------------------

local LCCC = LibCodesCommonCode

if (LibCombatAlerts) then return end
local Public = { }
LibCombatAlerts = Public


--------------------------------------------------------------------------------
-- Internal Components
--------------------------------------------------------------------------------

local Internal = {
	name = "LibCombatAlerts",

	unitIdsGroup = { },
	unitIdsBoss = { },
}
LibCombatAlertsInternal = Internal

do
	local cachedPath = nil

	local function GetRootPath( )
		local am = GetAddOnManager()
		for i = 1, am:GetNumAddOns() do
			if (am:GetAddOnInfo(i) == Internal.name) then
				return zo_strsub(am:GetAddOnRootDirectoryPath(i), 13, -1)
			end
		end
		return string.format("/%s/", Internal.name)
	end

	function Internal.GetRootPath( )
		if (not cachedPath) then
			cachedPath = GetRootPath()
		end
		return cachedPath
	end
end
