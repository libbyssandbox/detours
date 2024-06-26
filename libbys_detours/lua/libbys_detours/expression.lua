local Detours = libbys:FindModule("Detours")

local function ContextValidateEntity(ctx, entity)
	if not IsValid(entity) then
		ctx:throw("Invalid entity!")
		return false
	end

	return entity
end

Detours:CreateExpression2("pos(e:)", function(ctx, args)
	local entity = ContextValidateEntity(ctx, args[1])
	if not entity then return Vector(0, 0, 0) end

	if entity:IsPlayer() and entity ~= ctx.player then
		ctx:throw("You can't call :pos on other players!")
		return Vector(0, 0, 0)
	end

	return _OriginalFunction_(ctx, args)
end)
