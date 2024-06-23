AddCSLuaFile()

local Detours = libbys:FindModule("Detours")

Detours:CreateGeneric("util.SHA256", function(str)
	print("hashing ", str)
	return _OriginalFunction_(str)
end)
