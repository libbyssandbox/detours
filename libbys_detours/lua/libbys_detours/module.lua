AddCSLuaFile()

libbys:StartModule("Detours")
do
	function SetupConfig(self)
		self.m_ReplacementFev = { __index = _G }

		self.m_Backups = {}
		self.m_Backups.m_Originals = {}
		self.m_Backups.m_Replacements = {}
	end

	function OnConfigValueChanged(self, key, old, new)
		if string.find(key, ".", 1, true) then
			-- Assume it's an index
			local _, FunctionName, FunctionLocation = string.ToIndex(key)

			if new then
				FunctionLocation[FunctionName] = self.m_Backups.m_Replacements[key]
			else
				FunctionLocation[FunctionName] = self.m_Backups.m_Originals[key]
			end

			return
		end
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

		if self.m_Backups.m_Originals[location] then
			-- Use the old original
			OriginalFunction = self.m_Backups.m_Originals[location]
		else
			self.m_Backups.m_Originals[location] = OriginalFunction
		end

		self.m_Backups.m_Replacements[location] = self:SetupReplacementFenv(OriginalFunction, replacement)

		self:SetConfigValue(location, true)
	end

	function RestoreGeneric(self, location)
		self:SetConfigValue(location, false)
	end

	function SetAllDetours(self, status)
		for k, _ in next, self:GetConfig() do
			if string.find(k, ".", 1, true) then
				self:SetConfigValue(k, status)
			end
		end
	end

	function OnEnabled(self)
		if not self:GetConfigValue("Loaded") then
			include("libbys_detours/generic.lua")

			self:SetConfigValue("Loaded", true)
		else
			self:SetAllDetours(true)
		end
	end

	function OnDisabled(self)
		self:SetAllDetours(false)
	end
end
libbys:FinishModule()
