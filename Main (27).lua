local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local detected = {}
local waiting = {}

local FRUITS = {
	"Rocket","Spin","Blade","Spring","Bomb","Smoke","Spike","Flame",
	"Ice","Sand","Dark","Eagle","Diamond","Light","Rubber","Ghost",
	"Magma","Quake","Buddha","Love","Creation","Spider","Sound",
	"Phoenix","Portal","Lightning","Pain","Blizzard","Gravity",
	"Mammoth","T-Rex","Dough","Shadow","Venom","Gas","Spirit",
	"Tiger","Yeti","Kitsune","Control","Dragon"
}

local function isFruitName(name)
	if name == "Fruit" then
		return true
	end

	for _, fruit in ipairs(FRUITS) do
		if name == fruit .. " Fruit" or name == fruit .. "Fruit" then
			return true
		end
	end

	return false
end

local function getPart(object)
	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		return object.PrimaryPart
			or object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function createESP(object, part)

	if detected[object] then
		return
	end

	detected[object] = true
	waiting[object] = nil

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitNotifier"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(130, 45)
	gui.StudsOffset = Vector3.new(0, 4, 0)

	-- Sem limite de distância
	gui.MaxDistance = 0
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0

	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)

	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextScaled = false

	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.2
	label.TextStrokeColor3 = Color3.new(0, 0, 0)

	label.Text = object.Name .. "\n0 m"
	label.Parent = gui

	local connection

	connection = RunService.RenderStepped:Connect(function()

		if not object.Parent or not part.Parent then
			connection:Disconnect()

			detected[object] = nil

			if gui then
				gui:Destroy()
			end

			return
		end

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if root then
			local studs = (root.Position - part.Position).Magnitude
			local meters = studs * 0.28

			label.Text = object.Name .. string.format("\n%.0f m", meters)
		end
	end)
end

local function detectFruit(object)

	if not isFruitName(object.Name) then
		return
	end

	if detected[object] or waiting[object] then
		return
	end

	local part = getPart(object)

	-- Se a parte já existe, cria imediatamente
	if part then
		createESP(object, part)
		return
	end

	-- Se a parte ainda não existe, espera sem ficar escaneando o Workspace
	waiting[object] = true

	task.spawn(function()

		for _ = 1, 20 do

			if not object.Parent then
				waiting[object] = nil
				return
			end

			task.wait(0.1)

			local newPart = getPart(object)

			if newPart then
				createESP(object, newPart)
				return
			end
		end

		waiting[object] = nil
	end)
end

-- Frutas que já existem
for _, object in ipairs(Workspace:GetDescendants()) do
	detectFruit(object)
end

-- Novas frutas
Workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		detectFruit(object)
	end)
end)
