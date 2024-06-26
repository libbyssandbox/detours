local Detours = libbys:FindModule("Detours")
local Helpers = libbys:FindModule("DetourHelpers")

local function Bone_OnlyOwnerPlayer(name, default)
	Detours:CreateExpression2(name, function(ctx, args)
		local bone = Helpers:ContextValidObject(ctx, args[1], "Invalid bone!")
		if not bone then return default * 1 end

		local entity = bone:GetEntity()

		if entity:IsPlayer() and entity ~= ctx.player then
			ctx:throw(Format("You can't call bone:%s on other players!", name))
			return default * 1
		end

		return _OriginalFunction_(ctx, args)
	end)
end

Bone_OnlyOwnerPlayer("pos(b:)", vector_origin)
Bone_OnlyOwnerPlayer("velL(b:)", vector_origin)
Bone_OnlyOwnerPlayer("toWorld(b:v)", vector_origin)
Bone_OnlyOwnerPlayer("toLocal(b:v)", vector_origin)
Bone_OnlyOwnerPlayer("bearing(b:v)", 0)
Bone_OnlyOwnerPlayer("elevation(b:v)", 0)
Bone_OnlyOwnerPlayer("heading(b:v)", angle_zero)
Bone_OnlyOwnerPlayer("massCenter(b:)", vector_origin)
