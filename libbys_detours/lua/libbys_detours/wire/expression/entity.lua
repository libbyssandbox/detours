local Detours = libbys:FindModule("Detours")
local Helpers = libbys:FindModule("DetourHelpers")

local function Entity_OnlyOwnerPlayer(name, default)
	Detours:CreateExpression2(name, function(ctx, args)
		local entity = Helpers:ContextValidObject(ctx, args[1], "Invalid entity!")
		if not entity then return default * 1 end

		if entity:IsPlayer() and entity ~= ctx.player then
			ctx:throw(Format("You can't call entity:%s on other players!", name))
			return default * 1
		end

		return _OriginalFunction_(ctx, args)
	end)
end

-- Prevent messing with other players
Entity_OnlyOwnerPlayer("pos(e:)", vector_origin)
Entity_OnlyOwnerPlayer("velL(e:)", vector_origin)
Entity_OnlyOwnerPlayer("velAtPoint(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("toWorld(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("toLocal(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("toWorldAxis(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("toLocalAxis(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("bearing(e:v)", 0)
Entity_OnlyOwnerPlayer("elevation(e:v)", 0)
Entity_OnlyOwnerPlayer("heading(e:v)", angle_zero)
Entity_OnlyOwnerPlayer("massCenter(e:)", vector_origin)
Entity_OnlyOwnerPlayer("boxCenterW(e:)", vector_origin)
Entity_OnlyOwnerPlayer("aabbWorldMin(e:)", vector_origin)
Entity_OnlyOwnerPlayer("aabbWorldMax(e:)", vector_origin)
Entity_OnlyOwnerPlayer("aabbWorldSize(e:)", vector_origin)
Entity_OnlyOwnerPlayer("attachmentPos(e:n)", vector_origin)
Entity_OnlyOwnerPlayer("attachmentPos(e:s)", vector_origin)
Entity_OnlyOwnerPlayer("nearestPoint(e:v)", vector_origin)
Entity_OnlyOwnerPlayer("shootPos(e:)", vector_origin) -- Technically belongs in player

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
