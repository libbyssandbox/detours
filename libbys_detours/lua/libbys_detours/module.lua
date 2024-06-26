AddCSLuaFile()

libbys:StartModule("Detours")
do
	function SetupConfig(self)
		self.m_ReplacementFev = { __index = _G }

		self.m_Backups = {}
		self.m_Backups.m_Originals = {}
		self.m_Backups.m_Replacements = {}
	end

	function GetStoreKey(self, location, key)
		return Format("%s[\"%s\"]", location, key)
	end

	function GetStorageTable(self, location, key, value)
		return {
			FunctionLocation = location,
			FunctionName = key,
			Function = value
		}
	end

	function BackupOriginalFunction(self, location, key, value)
		local StoreKey = self:GetStoreKey(location, key)

		if not self.m_Backups.m_Originals[StoreKey] then
			self.m_Backups.m_Originals[StoreKey] = self:GetStorageTable(location, key, value)
		end
	end

	function StoreReplacement(self, location, key, value)
		local StoreKey = self:GetStoreKey(location, key)

		local OriginalFunction = self.m_Backups.m_Originals[StoreKey].Function

		self.m_Backups.m_Replacements[StoreKey] = self:GetStorageTable(location, key, self:SetupReplacementFenv(OriginalFunction, value))
	end

	function OnConfigValueChanged(self, key, old, new)
		local OriginalData = self.m_Backups.m_Originals[key]
		local ReplacementData = self.m_Backups.m_Replacements[key]

		if OriginalData and ReplacementData then
			if new then
				OriginalData.FunctionLocation[OriginalData.FunctionName] = ReplacementData.Function
			else
				OriginalData.FunctionLocation[OriginalData.FunctionName] = OriginalData.Function
			end
		end
	end

	function SetupReplacementFenv(self, original, replacement)
		local Fenv = setmetatable({}, self.m_ReplacementFev)
		Fenv["_OriginalFunction_"] = original

		return setfenv(replacement, Fenv)
	end

	function CreateFromKey(self, location, key, replacement)
		local OriginalFunction = location[key]

		if not isfunction(OriginalFunction) then
			FormatError("Can't find function for detouring '%s'", self:GetStoreKey(location, key))
		end

		local StoreKey = self:GetStoreKey(location, key)

		self:SetConfigValue(StoreKey, false)
			self:BackupOriginalFunction(location, key, OriginalFunction)
			self:StoreReplacement(location, key, replacement)
		self:SetConfigValue(StoreKey, true)
	end

	function CreateGeneric(self, location, replacement)
		local OriginalFunction, FunctionName, FunctionLocation = string.ToIndex(location)

		if not isfunction(OriginalFunction) then
			FormatError("Can't find function for detouring '%s'", location)
		end

		self:CreateFromKey(FunctionLocation, FunctionName, replacement)
	end

	function CreateExpression2(self, name, replacement)
		local FunctionData = wire_expression2_funcs[name]

		if not istable(FunctionData) or not isfunction(FunctionData[3]) then
			FormatError("Can't find Expression2 function for detouring '%s'", name)
		end

		self:CreateFromKey(FunctionData, 3, replacement)
	end

	function SetAllDetours(self, status)
		for k, _ in next, self.m_Backups.m_Originals do
			self:SetConfigValue(k, status)
		end
	end

	function PostGamemodeLoaded()
		include("libbys_detours/generic.lua")

		if SERVER then
			include("libbys_detours/expression.lua")
		end
	end

	function OnEnabled(self)
		if not self:GetConfigValue("Loaded") then
			self:AddHook("PostGamemodeLoaded", self.PostGamemodeLoaded)

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
