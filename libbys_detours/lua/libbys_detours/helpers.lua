AddCSLuaFile()

local Detours = libbys:FindModule("Detours")

libbys:StartModule("DetourHelpers")
do
	function ContextValidObject(self, ctx, object, message)
		if not IsValid(object) then
			ctx:throw(message or "Invalid object!")
			return false
		end

		return object
	end

	function KillPartFunction(self, part, name)
		Detours:CreatePacPart(part, name, function() return end)
	end
end
libbys:FinishModule()
