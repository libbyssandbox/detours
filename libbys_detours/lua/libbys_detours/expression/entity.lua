local Detours = libbys:FindModule("Detours")
local Helpers = libbys:FindModule("DetourHelpers")

local function Entity_OnlyOwnerPlayer(name)
	Detours:CreateExpression2(name, function(ctx, args)
		local entity = Helpers:ContextValidObject(ctx, args[1], "Invalid entity!")
		if not entity then return Vector(0, 0, 0) end

		if entity:IsPlayer() and entity ~= ctx.player then
			ctx:throw(string.format("You can't call entity:%s on other players!", name))
			return Vector(0, 0, 0)
		end

		return _OriginalFunction_(ctx, args)
	end)
end

-- Prevent messing with other players
Entity_OnlyOwnerPlayer("pos(e:)")
Entity_OnlyOwnerPlayer("velL(e:)")
Entity_OnlyOwnerPlayer("velAtPoint(e:v)")
Entity_OnlyOwnerPlayer("toWorld(e:v)")
Entity_OnlyOwnerPlayer("toLocal(e:v)")
Entity_OnlyOwnerPlayer("toWorldAxis(e:v)")
Entity_OnlyOwnerPlayer("toLocalAxis(e:v)")
Entity_OnlyOwnerPlayer("bearing(e:v)")
Entity_OnlyOwnerPlayer("elevation(e:v)")
Entity_OnlyOwnerPlayer("heading(e:v)")
Entity_OnlyOwnerPlayer("massCenter(e:)")
Entity_OnlyOwnerPlayer("boxCenterW(e:)")
Entity_OnlyOwnerPlayer("aabbWorldMin(e:)")
Entity_OnlyOwnerPlayer("aabbWorldMax(e:)")
Entity_OnlyOwnerPlayer("aabbWorldSize(e:)")
Entity_OnlyOwnerPlayer("attachmentPos(e:n)")
Entity_OnlyOwnerPlayer("attachmentPos(e:s)")
Entity_OnlyOwnerPlayer("nearestPoint(e:v)")

-- Prevent "ghost"
Detours:CreateExpression2("noCollideAll(e:n)", function(ctx, args)
	local entity = Helpers:ContextValidObject(ctx, args[1], "Invalid entity!")
	if not entity then return end

	if entity:IsPlayer() then
		ctx:throw("You cannot set the collision group of a player!")
		return
	end

	return _OriginalFunction_(ctx, args)
end)
