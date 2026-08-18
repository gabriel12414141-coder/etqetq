local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local detected = {}
local pending = {}

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
		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function createESP(object)
	if not object or not object.Parent then
		return false
	end

	if not isFruitName(object.Name) then
		return false
	end

	if detected[object] then
		return true
	end

	local part = getPart(object)

	if not part then
		return false
	end

	detected[object] = true
	pending[object] = nil

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitNotifier"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(140, 45)

	-- Fica acima da fruta
	gui.StudsOffset = Vector3.new(0, 4, 0)

	-- Sem limite de distância
	gui.MaxDistance = 0
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0

	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.Name = "FruitInfo"
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)

	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextColor3 = Color3.new(1, 1, 1)

	label.TextStrokeTransparency = 0.15
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

	return true
end

-- Tenta encontrar a parte da fruta várias vezes
local function detectWithRetry(object)
	if pending[object] then
		return
	end

	if not isFruitName(object.Name) then
		return
	end

	pending[object] = true

	task.spawn(function()

		-- Tenta imediatamente
		if createESP(object) then
			return
		end

		-- Tenta novamente enquanto o objeto termina de carregar
		for i = 1, 12 do
			if not object.Parent then
				pending[object] = nil
				return
			end

			task.wait(0.1)

			if createESP(object) then
				return
			end
		end

		pending[object] = nil
	end)
end

-- Detecta o que já existe
for _, object in ipairs(Workspace:GetDescendants()) do
	if isFruitName(object.Name) then
		detectWithRetry(object)
	end
end

-- Detecta novas frutas
Workspace.DescendantAdded:Connect(function(object)

	-- Se o próprio objeto for a fruta
	if isFruitName(object.Name) then
		detectWithRetry(object)
	end

	-- Se for uma parte adicionada dentro de uma fruta
	local parent = object.Parent

	if parent and isFruitName(parent.Name) then
		detectWithRetry(parent)
	end
end)

-- Verificação de segurança:
-- procura frutas novas a cada 0.5 segundo
task.spawn(function()
	while true do
		task.wait(0.5)

		for _, object in ipairs(Workspace:GetDescendants()) do
			if isFruitName(object.Name) and not detected[object] then
				detectWithRetry(object)
			end
		end
	end
end)
