local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local fruits = {}
local retrying = {}

local VALID_FRUITS = {
	["Fruit"] = true,

	["Rocket"] = true,
	["Spin"] = true,
	["Blade"] = true,
	["Spring"] = true,
	["Bomb"] = true,
	["Smoke"] = true,
	["Spike"] = true,
	["Flame"] = true,
	["Ice"] = true,
	["Sand"] = true,
	["Dark"] = true,
	["Eagle"] = true,
	["Diamond"] = true,
	["Light"] = true,
	["Rubber"] = true,
	["Ghost"] = true,
	["Magma"] = true,
	["Quake"] = true,
	["Buddha"] = true,
	["Love"] = true,
	["Creation"] = true,
	["Spider"] = true,
	["Sound"] = true,
	["Phoenix"] = true,
	["Portal"] = true,
	["Lightning"] = true,
	["Pain"] = true,
	["Blizzard"] = true,
	["Gravity"] = true,
	["Mammoth"] = true,
	["T-Rex"] = true,
	["Dough"] = true,
	["Shadow"] = true,
	["Venom"] = true,
	["Gas"] = true,
	["Spirit"] = true,
	["Tiger"] = true,
	["Yeti"] = true,
	["Kitsune"] = true,
	["Control"] = true,
	["Dragon"] = true,
}

local function isFruitName(name)
	if VALID_FRUITS[name] then
		return true
	end

	for fruitName in pairs(VALID_FRUITS) do
		if fruitName ~= "Fruit" then
			if name == fruitName .. " Fruit"
				or name == fruitName .. "Fruit" then
				return true
			end
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
	if fruits[object] then
		return
	end

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitNotifier"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(120, 40)
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
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.2
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.Text = object.Name .. "\n0 m"
	label.Parent = gui

	fruits[object] = {
		part = part,
		gui = gui,
		label = label
	}
end

local function detect(object)
	if not object.Parent then
		return
	end

	if not isFruitName(object.Name) then
		return
	end

	if fruits[object] or retrying[object] then
		return
	end

	local part = getPart(object)

	if part then
		createESP(object, part)
		return
	end

	-- Aguarda a parte física aparecer
	retrying[object] = true

	task.spawn(function()
		for i = 1, 10 do
			if not object.Parent then
				break
			end

			task.wait(0.1)

			local newPart = getPart(object)

			if newPart then
				createESP(object, newPart)
				break
			end
		end

		retrying[object] = nil
	end)
end

-- Detecta o que já existe UMA vez
for _, object in ipairs(Workspace:GetDescendants()) do
	if isFruitName(object.Name) then
		detect(object)
	end
end

-- Detecta objetos novos
Workspace.DescendantAdded:Connect(function(object)

	if isFruitName(object.Name) then
		detect(object)
		return
	end

	-- Caso o Handle/Part apareça depois da fruta
	local parent = object.Parent

	if parent and isFruitName(parent.Name) then
		detect(parent)
	end
end)

-- UMA única atualização para todas as frutas
local updateTimer = 0

RunService.Heartbeat:Connect(function(dt)
	updateTimer += dt

	-- Atualiza aproximadamente 10 vezes por segundo,
	-- suficiente para a distância sem sobrecarregar.
	if updateTimer < 0.1 then
		return
	end

	updateTimer = 0

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(fruits) do
		if not object.Parent or not data.part.Parent then
			if data.gui then
				data.gui:Destroy()
			end

			fruits[object] = nil
		else
			local distance = (root.Position - data.part.Position).Magnitude
			local meters = distance * 0.28

			data.label.Text = object.Name .. string.format("\n%.0f m", meters)
		end
	end
end)
