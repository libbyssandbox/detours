libbys:StartModule("Detours")
do
	function SetupConfig(self)
		self.m_ReplacementFev = { __index = _G }

		self.m_Backups = {}
		self.m_Backups.m_Generic = {}
	end

	function SetupReplacementFenv(self, original, replacement)
		local Fenv = setmetatable({}, self.m_ReplacementFev)
		Fenv["_OriginalFunction_"] = original

		return setfenv(replacement, Fenv)
	end

	function CreateGeneric(self, location, replacement)
		local OriginalFunction, FunctionName, FunctionLocation = string.ToIndex(location)

		if not isfunction(OriginalFunction) then
			FormatError("Can't find function for detouring '%s'", location)
		end

		if self.m_Backups.m_Generic[location] then
			FormatErrorNoHalt("Detour for function '%s' already exists, using old original", location)

			OriginalFunction = self.m_Backups.m_Generic[location]
		else
			self.m_Backups.m_Generic[location] = OriginalFunction
		end

		FunctionLocation[FunctionName] = self:SetupReplacementFenv(OriginalFunction, replacement)
	end

	function RestoreGeneric(self, location)
		local OriginalFunction = self.m_Backups.m_Generic[location]

		if not isfunction(OriginalFunction) then
			FormatError("Missing restore for function '%s'", location)
		end

		local _, FunctionName, FunctionLocation = string.ToIndex(location)
		FunctionLocation[FunctionName] = OriginalFunction

		self.m_Backups.m_Generic[location] = nil
	end

	function OnEnabled(self)
		include("libbys_detours/generic/create.lua")
	end

	function OnDisabled(self)
		include("libbys_detours/generic/destroy.lua")
	end
end
libbys:FinishModule()
