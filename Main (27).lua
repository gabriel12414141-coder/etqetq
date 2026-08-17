local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local fruits = {}

local function getPart(obj)
	if obj:IsA("BasePart") then
		return obj
	end

	if obj:IsA("Model") then
		return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function isFruit(obj)
	-- NOME EXATO
	if obj.Name ~= "Fruit" then
		return false
	end

	-- Somente objetos físicos
	if not obj:IsA("BasePart") and not obj:IsA("Model") then
		return false
	end

	local part = getPart(obj)

	if not part then
		return false
	end

	-- Precisa estar diretamente no Workspace
	-- ou dentro de uma pasta do Workspace,
	-- mas não dentro de personagem/tool
	if not obj:IsDescendantOf(Workspace) then
		return false
	end

	if obj:FindFirstAncestorOfClass("Tool") then
		return false
	end

	if obj:FindFirstAncestorOfClass("Model")
		and obj:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid") then
		return false
	end

	return true
end

local function createESP(obj)
	if not isFruit(obj) or fruits[obj] then
		return
	end

	local part = getPart(obj)

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitESP"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(80, 32)
	gui.StudsOffset = Vector3.new(0, 3, 0)

	-- Sem limite de distância
	gui.MaxDistance = 0
	gui.AlwaysOnTop = true

	gui.Parent = part

	local text = Instance.new("TextLabel")
	text.BackgroundTransparency = 1
	text.Size = UDim2.fromScale(1, 1)
	text.Font = Enum.Font.Gotham
	text.TextSize = 12
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextStrokeTransparency = 0.4
	text.Text = "Fruit"
	text.Parent = gui

	fruits[obj] = {
		part = part,
		gui = gui,
		text = text
	}

	obj.AncestryChanged:Connect(function(_, parent)
		if not parent then
			fruits[obj] = nil

			if gui then
				gui:Destroy()
			end
		end
	end)
end

-- Detecta somente "Fruit" exato
for _, obj in ipairs(Workspace:GetDescendants()) do
	createESP(obj)
end

Workspace.DescendantAdded:Connect(function(obj)
	task.defer(function()
		createESP(obj)
	end)
end)

-- Distância em metros
RunService.RenderStepped:Connect(function()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for obj, data in pairs(fruits) do
		if obj.Parent and data.part and data.part.Parent then
			local studs = (root.Position - data.part.Position).Magnitude
			local meters = studs * 0.28

			data.text.Text = string.format("Fruit\n%.0f m", meters)
		end
	end
end)
