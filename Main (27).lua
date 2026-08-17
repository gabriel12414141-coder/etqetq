local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local fruitLabels = {}

local function getPart(object)
	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		return object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function createFruitESP(object)
	if object.Name ~= "Fruit" then
		return
	end

	if fruitLabels[object] then
		return
	end

	local part = getPart(object)
	if not part then
		return
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "FruitNotifier"
	billboard.Adornee = part
	billboard.Size = UDim2.fromOffset(90, 35)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 10000
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Text = "Fruit\n0 m"
	label.TextSize = 12
	label.Font = Enum.Font.Gotham
	label.TextStrokeTransparency = 0.5
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Parent = billboard

	fruitLabels[object] = {
		gui = billboard,
		label = label,
		part = part
	}

	object.AncestryChanged:Connect(function(_, parent)
		if not parent then
			fruitLabels[object] = nil
			billboard:Destroy()
		end
	end)
end

-- Frutas que já existem
for _, object in ipairs(Workspace:GetDescendants()) do
	createFruitESP(object)
end

-- Novas frutas
Workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		createFruitESP(object)
	end)
end)

-- Atualiza a distância
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(fruitLabels) do
		if object.Parent and data.part and data.part.Parent then
			local distance = (root.Position - data.part.Position).Magnitude

			-- Conversão aproximada de studs para metros
			local meters = distance * 0.28

			data.label.Text = string.format("Fruit\n%.0f m", meters)
		end
	end
end)
