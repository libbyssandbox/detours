AddCSLuaFile()

local Detours = libbys:FindModule("Detours")

Detours:CreateExpression2("pos(e:)", function(...)
	print(...)
	return Vector()
end)
