local Detours = libbys:FindModule("Detours")

local ToolList = weapons.GetStored("gmod_tool").Tool
local ExpressionTool = ToolList["wire_expression2"]

if not istable(ExpressionTool) then
	FormatErrorNoHalt("Can't find tool 'wire_expression2'")
	return
end

Detours:CreateFromKey(ExpressionTool, "Do_RightClick", function(tool)
	local Owner = tool:GetOwner()
	local Chip = Owner:GetEyeTrace().Entity

	if not IsValid(Chip) or Chip:GetClass() ~= "gmod_wire_expression2" then
		return _OriginalFunction_(tool)
	end

	if IsValid(Chip) and Chip:GetClass() == "gmod_wire_expression2" then
		if Chip.player == Owner then
			return _OriginalFunction_(tool)
		elseif WireLib.CanTool(Owner, Chip, "wire_expression2") then
			tool:Download(Owner, Chip)
			Owner:SetAnimation(PLAYER_ATTACK1)

			-- Remove BetterChatPrint call
			return
		else
			return _OriginalFunction_(tool)
		end
	end

	return _OriginalFunction_(tool)
end)
