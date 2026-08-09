local Workspace = game:GetService("Workspace")

print("====================================")
print("FRUIT DEBUG INICIADO")
print("====================================")

local function debugObject(object)

	if object:IsA("Model") then
		print(
			"[MODEL DETECTADO]",
			object:GetFullName(),
			"| Name:",
			object.Name
		)
	end
end

-- Objetos que já existem
for _, object in ipairs(Workspace:GetDescendants()) do
	debugObject(object)
end

-- Objetos novos
Workspace.DescendantAdded:Connect(function(object)

	task.defer(function()
		debugObject(object)
	end)
end)
