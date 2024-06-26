local Detours = libbys:FindModule("Detours")

Detours:CreateExpression2("pos(e:)", function(ctx, args)
	local entity = args[1]

	if not IsValid(entity) then
		return _OriginalFunction_(ctx, args)
	end

	if entity:IsPlayer() and entity ~= ctx.player then
		ctx:throw("You can't call :pos on other players!")
		return Vector(0, 0, 0)
	end

	return _OriginalFunction_(ctx, args)
end)
