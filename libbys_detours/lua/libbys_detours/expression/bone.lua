local Detours = libbys:FindModule("Detours")
local Helpers = libbys:FindModule("DetourHelpers")

local function Bone_OnlyOwnerPlayer(name)
	Detours:CreateExpression2(name, function(ctx, args)
		local bone = Helpers:ContextValidObject(ctx, args[1], "Invalid bone!")
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
Bone_OnlyOwnerPlayer("velL(b:)")
Bone_OnlyOwnerPlayer("toWorld(b:v)")
Bone_OnlyOwnerPlayer("toLocal(b:v)")
Bone_OnlyOwnerPlayer("bearing(b:v)")
Bone_OnlyOwnerPlayer("elevation(b:v)")
Bone_OnlyOwnerPlayer("heading(b:v)")
Bone_OnlyOwnerPlayer("massCenter(b:)")
