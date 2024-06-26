local Detours = libbys:FindModule("Detours")

Detours:CreateExpression2("hideChat(n)", function(ctx)
	ctx:throw("You cannot use hideChat")
end)
