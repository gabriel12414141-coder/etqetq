--============================================================
-- FRUIT RECOGNITION - AUTO FOLDER
-- Roblox Studio / LocalScript
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- FRUTAS RECONHECIDAS
--============================================================

local FruitNames = {
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
	["Kitsune"] = true,
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
	["Control"] = true,
	["Spirit"] = true,
	["Dragon"] = true,
	["Yeti"] = true,
	["Gas"] = true,
	["Leopard"] = true
}

--============================================================
-- LIMPAR GUI ANTIGO
--============================================================

local old = playerGui:FindFirstChild("FruitRecognition")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "FruitRecognition"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 330, 0, 430)
main.Position = UDim2.new(0, 20, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

--============================================================
-- TÍTULO
--============================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = "🍎 Fruit Recognition"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 45)
status.Position = UDim2.new(0, 10, 0, 48)
status.BackgroundTransparency = 1
status.Text = "Procurando..."
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

--============================================================
-- LISTA
--============================================================

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -105)
list.Position = UDim2.new(0, 10, 0, 100)
list.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = list

--============================================================
-- NORMALIZAR NOME
--============================================================

local function normalizeName(name)

	name = tostring(name)

	name = name:gsub("%s*[Ff]ruit%s*$", "")
	name = name:gsub("^%s+", "")
	name = name:gsub("%s+$", "")

	return name
end

--============================================================
-- RECONHECER FRUTA
--============================================================

local function isFruit(object)

	if not object then
		return false
	end

	local name = normalizeName(object.Name)

	return FruitNames[name] == true
end

--============================================================
-- ENCONTRAR PASTAS
--============================================================

local function getFruitFolders()

	local folders = {}

	for _, object in ipairs(workspace:GetDescendants()) do

		if object:IsA("Folder") then

			local lowerName = object.Name:lower()

			-- Fruit
			-- Fruits
			-- SpawnedFruit
			-- SpawnedFruits
			-- MyFruitFolder
			-- etc.

			if string.find(lowerName, "fruit", 1, true) then

				table.insert(folders, object)

			end

		end

	end

	return folders
end

--============================================================
-- POSIÇÃO
--============================================================

local function getPosition(object)

	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		return object:GetPivot().Position
	end

	return nil
end

--============================================================
-- DADOS
--============================================================

local detected = {}

--============================================================
-- CRIAR ITEM
--============================================================

local function createEntry(name)

	local entry = Instance.new("Frame")
	entry.Size = UDim2.new(1, -10, 0, 60)
	entry.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	entry.BorderSizePixel = 0
	entry.Parent = list

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = entry

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -20, 0, 28)
	nameLabel.Position = UDim2.new(0, 10, 0, 3)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = "🍏 " .. name .. " Fruit"
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 16
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = entry

	local distance = Instance.new("TextLabel")
	distance.Size = UDim2.new(1, -20, 0, 20)
	distance.Position = UDim2.new(0, 10, 0, 32)
	distance.BackgroundTransparency = 1
	distance.Text = "📍 Calculando..."
	distance.TextColor3 = Color3.fromRGB(100, 255, 120)
	distance.TextSize = 12
	distance.Font = Enum.Font.Gotham
	distance.TextXAlignment = Enum.TextXAlignment.Left
	distance.Parent = entry

	return entry, distance
end

--============================================================
-- SCAN
--============================================================

local function scan()

	local current = {}

	local folders = getFruitFolders()

	local folderCount = #folders

	for _, folder in ipairs(folders) do

		for _, object in ipairs(folder:GetDescendants()) do

			if isFruit(object) then

				current[object] = true

				if not detected[object] then

					local name = normalizeName(object.Name)

					local entry, distance =
						createEntry(name)

					detected[object] = {
						entry = entry,
						distance = distance
					}

				end

			end

		end

	end

	--========================================================
	-- REMOVER FRUTAS QUE SUMIRAM
	--========================================================

	for object, data in pairs(detected) do

		if not current[object] then

			if data.entry then
				data.entry:Destroy()
			end

			detected[object] = nil

		end

	end

	--========================================================
	-- CONTAGEM
	--========================================================

	local fruitCount = 0

	for _ in pairs(current) do
		fruitCount += 1
	end

	if folderCount == 0 then

		status.Text =
			"Nenhuma pasta contendo 'Fruit' encontrada.\n" ..
			"Pastas verificadas: Workspace"

		status.TextColor3 =
			Color3.fromRGB(255, 180, 80)

	else

		status.Text =
			folderCount .. " pasta(s) encontrada(s) • " ..
			fruitCount .. " fruta(s)"

		status.TextColor3 =
			Color3.fromRGB(100, 255, 120)

	end

	task.defer(function()

		list.CanvasSize = UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 10
		)

	end)
end

--============================================================
-- DISTÂNCIA
--============================================================

local function updateDistances()

	local character = player.Character

	if not character then
		return
	end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(detected) do

		if object and object.Parent then

			local position = getPosition(object)

			if position then

				local distance =
					(root.Position - position).Magnitude

				data.distance.Text =
					"📍 " .. math.floor(distance) .. " studs"

			end

		end

	end
end

--============================================================
-- NOVOS OBJETOS
--============================================================

workspace.DescendantAdded:Connect(function()

	task.wait(0.1)

	if gui.Parent then
		scan()
	end

end)

workspace.DescendantRemoving:Connect(function()

	task.wait(0.05)

	if gui.Parent then
		scan()
	end

end)

--============================================================
-- LOOP
--============================================================

task.spawn(function()

	while gui.Parent do

		scan()

		task.wait(0.5)

	end

end)

RunService.RenderStepped:Connect(function()

	if gui.Parent then
		updateDistances()
	end

end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

task.wait(1)

scan()
