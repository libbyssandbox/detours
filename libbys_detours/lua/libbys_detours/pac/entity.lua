local Detours = libbys:FindModule("Detours")
local Helpers = libbys:FindModule("DetourHelpers")

-- "legacy"
Helpers:KillPartFunction("entity", "SetSize")
Helpers:KillPartFunction("entity", "SetScale")

-- New
Helpers:KillPartFunction("entity2", "SetStandingHullHeight")
Helpers:KillPartFunction("entity2", "SetCrouchingHullHeight")
Helpers:KillPartFunction("entity2", "SetHullWidth")

-- Thank god for inheritance
Helpers:KillPartFunction("entity2", "SetSize")
Helpers:KillPartFunction("entity2", "SetScale")
