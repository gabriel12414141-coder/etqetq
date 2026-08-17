local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local fruits = {}

local function getFruitPart(object)
	-- Só aceita Part ou Model
	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		return object.PrimaryPart or object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function isRealFruit(object)
	-- Nome EXATAMENTE "Fruit"
	if object.Name ~= "Fruit" then
		return false
	end

	-- Precisa ser uma estrutura física
	local part = getFruitPart(object)
	if not part then
		return false
	end

	-- Ignora objetos que estejam dentro de personagens
	if object:FindFirstAncestorOfClass("Humanoid") then
		return false
	end

	-- Ignora objetos dentro de ferramentas
	if object:FindFirstAncestorOfClass("Tool") then
		return false
	end

	return true
end

local function addFruit(object)
	if not isRealFruit(object) then
		return
	end

	if fruits[object] then
		return
	end

	local part = getFruitPart(object)
	if not part then
		return
	end

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitESP"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(80, 30)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 10000
	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 11
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.5
	label.Text = "Fruit"
	label.Parent = gui

	fruits[object] = {
		part = part,
		gui = gui,
		label = label
	}

	object.AncestryChanged:Connect(function(_, parent)
		if not parent then
			fruits[object] = nil
			if gui then
				gui:Destroy()
			end
		end
	end)
end

-- Detecta apenas objetos existentes
for _, object in ipairs(Workspace:GetDescendants()) do
	addFruit(object)
end

-- Detecta novos objetos
Workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		addFruit(object)
	end)
end)

-- Atualiza distância
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(fruits) do
		if object.Parent and data.part and data.part.Parent then
			local distance = (root.Position - data.part.Position).Magnitude

			-- 1 stud ≈ 0,28 metro
			local meters = distance * 0.28

			data.label.Text = string.format("Fruit\n%.0f m", meters)
		end
	end
end)
