AddCSLuaFile()

libbys:StartModule("DetourHelpers")
do
	function ContextValidObject(self, ctx, object, message)
		if not IsValid(object) then
			ctx:throw(message or "Invalid object!")
			return false
		end

		return object
	end
end
libbys:FinishModule()
