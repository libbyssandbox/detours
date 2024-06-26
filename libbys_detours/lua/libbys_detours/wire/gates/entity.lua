local Detours = libbys:FindModule("Detours")

local function Entity_OnlyOwnerPlayer(name, default)
	Detours:CreateGate(name, function(gate, entity, ...)
		if not IsValid(entity) then return _OriginalFunction_(gate, entity, ...) end

		if entity:IsPlayer() and entity ~= WireLib.GetOwner(gate) then
			return default * 1
		end

		return _OriginalFunction_(gate, entity)
	end)
end

Entity_OnlyOwnerPlayer("entity_pos", vector_origin)
Entity_OnlyOwnerPlayer("entity_vell", vector_origin)
Entity_OnlyOwnerPlayer("entity_wor2loc", vector_origin)
Entity_OnlyOwnerPlayer("entity_loc2wor", vector_origin)
Entity_OnlyOwnerPlayer("entity_masscenter", vector_origin)
Entity_OnlyOwnerPlayer("entity_bearing", 0)
Entity_OnlyOwnerPlayer("entity_elevation", 0)

Detours:CreateGate("entity_heading", function(gate, entity, position)
	if not IsValid(entity) then return _OriginalFunction_(gate, entity, position) end

	if entity:IsPlayer() and entity ~= WireLib.GetOwner(gate) then
		return 0, 0, Angle(0, 0, 0)
	end

	return _OriginalFunction_(gate, entity)
end)
