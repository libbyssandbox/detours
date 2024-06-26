local Detours = libbys:FindModule("Detours")

local function ContextValidateBone(ctx, bone)
	if not IsValid(bone) then
		ctx:throw("Invalid bone!")
		return false
	end

	return bone
end

local function Bone_OnlyOwnerPlayer(name)
	Detours:CreateExpression2(name, function(ctx, args)
		local bone = ContextValidateBone(ctx, args[1])
		if not bone then return Vector(0, 0, 0) end

		local entity = bone:GetEntity()

		if entity:IsPlayer() and entity ~= ctx.player then
			ctx:throw(string.format("You can't call bone:%s on other players!", name))
			return Vector(0, 0, 0)
		end

		return _OriginalFunction_(ctx, args)
	end)
end

Bone_OnlyOwnerPlayer("pos(b:)")
