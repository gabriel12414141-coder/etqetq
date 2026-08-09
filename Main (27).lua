```lua
--============================================================
-- FRUIT RECOGNITION SYSTEM
-- Roblox Studio - LocalScript
--
-- Procura automaticamente:
-- Fruit
-- Fruits
-- SpawnedFruit
-- SpawnedFruits
-- MyFruitFolder
-- Qualquer Folder contendo "fruit"
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÕES
--============================================================

local SCAN_INTERVAL = 0.5

-- Frutas reconhecidas
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
	["Leopard"] = true,
}

--============================================================
-- LIMPAR GUI ANTIGO
--============================================================

local oldGui = PlayerGui:FindFirstChild("FruitRecognition")

if oldGui then
	oldGui:Destroy()
end

--============================================================
-- GUI PRINCIPAL
--============================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitRecognition"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--============================================================
-- JANELA
--============================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 420)
Main.Position = UDim2.new(0, 20, 0.5, -210)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

--============================================================
-- TÍTULO
--============================================================

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🍎 Fruit Recognition"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

--============================================================
-- STATUS
--============================================================

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 48)
Status.BackgroundTransparency = 1
Status.Text = "Inicializando..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--============================================================
-- LISTA
--============================================================

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Size = UDim2.new(1, -20, 1, -90)
List.Position = UDim2.new(0, 10, 0, 85)
List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
List.BorderSizePixel = 0
List.ScrollBarThickness = 5
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.Name
Layout.Parent = List

--============================================================
-- NORMALIZAR NOME
--============================================================

local function NormalizeName(name)

	name = tostring(name)

	-- Remove "Fruit" do final
	name = name:gsub("%s+[Ff]ruit$", "")

	-- Remove espaços extras
	name = name:gsub("^%s+", "")
	name = name:gsub("%s+$", "")

	return name
end

--============================================================
-- VERIFICAR SE É UMA FRUTA
--============================================================

local function IsFruit(object)

	if not object then
		return false
	end

	local normalized = NormalizeName(object.Name)

	return FruitNames[normalized] == true
end

--============================================================
-- LOCALIZAR PASTAS DE FRUTAS
--============================================================

local function IsFruitFolder(object)

	if not object:IsA("Folder") then
		return false
	end

	local name = object.Name:lower()

	-- Nomes exatos
	if name == "fruit" or name == "fruits" then
		return true
	end

	-- Qualquer nome contendo "fruit"
	if string.find(name, "fruit", 1, true) then
		return true
	end

	return false
end

--============================================================
-- PEGAR TODAS AS PASTAS
--============================================================

local function GetFruitFolders()

	local folders = {}

	for _, object in ipairs(workspace:GetDescendants()) do

		if IsFruitFolder(object) then
			table.insert(folders, object)
		end

	end

	return folders
end

--============================================================
-- PEGAR POSIÇÃO
--============================================================

local function GetPosition(object)

	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		return object:GetPivot().Position
	end

	if object:IsA("Attachment") then
		return object.WorldPosition
	end

	return nil
end

--============================================================
-- CRIAR ITEM
--============================================================

local function CreateFruitEntry(name)

	local Entry = Instance.new("Frame")
	Entry.Name = name
	Entry.Size = UDim2.new(1, -10, 0, 60)
	Entry.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Entry.BorderSizePixel = 0
	Entry.Parent = List

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 8)
	Corner.Parent = Entry

	-- Nome
	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -20, 0, 27)
	NameLabel.Position = UDim2.new(0, 10, 0, 4)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = "🍏 " .. name .. " Fruit"
	NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	NameLabel.TextSize = 16
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = Entry

	-- Distância
	local DistanceLabel = Instance.new("TextLabel")
	DistanceLabel.Size = UDim2.new(1, -20, 0, 20)
	DistanceLabel.Position = UDim2.new(0, 10, 0, 33)
	DistanceLabel.BackgroundTransparency = 1
	DistanceLabel.Text = "📍 Calculando..."
	DistanceLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
	DistanceLabel.TextSize = 12
	DistanceLabel.Font = Enum.Font.Gotham
	DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
	DistanceLabel.Parent = Entry

	return Entry, DistanceLabel
end

--============================================================
-- TABELA DE FRUTAS DETECTADAS
--============================================================

local Detected = {}

--============================================================
-- SCAN PRINCIPAL
--============================================================

local function ScanFruits()

	local Current = {}

	local folders = GetFruitFolders()

	for _, folder in ipairs(folders) do

		for _, object in ipairs(folder:GetDescendants()) do

			if IsFruit(object) then

				local fruitName = NormalizeName(object.Name)

				Current[object] = fruitName

				-- Nova fruta
				if not Detected[object] then

					local Entry, DistanceLabel =
						CreateFruitEntry(fruitName)

					Detected[object] = {
						Name = fruitName,
						Entry = Entry,
						DistanceLabel = DistanceLabel
					}

				end

			end

		end

	end

	--========================================================
	-- REMOVER FRUTAS QUE SUMIRAM
	--========================================================

	for object, data in pairs(Detected) do

		if not Current[object] then

			if data.Entry then
				data.Entry:Destroy()
			end

			Detected[object] = nil

		end

	end

	--========================================================
	-- CONTAGEM
	--========================================================

	local count = 0

	for _ in pairs(Current) do
		count += 1
	end

	Status.Text = count .. " fruta(s) detectada(s)"

	if count > 0 then
		Status.TextColor3 = Color3.fromRGB(100, 255, 120)
	else
		Status.TextColor3 = Color3.fromRGB(180, 180, 180)
	end

	-- Atualizar tamanho da lista
	task.defer(function()

		List.CanvasSize = UDim2.new(
			0,
			0,
			0,
			Layout.AbsoluteContentSize.Y + 10
		)

	end)
end

--============================================================
-- ATUALIZAR DISTÂNCIAS
--============================================================

local function UpdateDistances()

	local Character = Player.Character

	if not Character then
		return
	end

	local Root =
		Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	for object, data in pairs(Detected) do

		if object
			and object.Parent
			and data.DistanceLabel then

			local position = GetPosition(object)

			if position then

				local distance =
					(Root.Position - position).Magnitude

				data.DistanceLabel.Text =
					"📍 " .. math.floor(distance) .. " studs"

			else

				data.DistanceLabel.Text =
					"📍 Posição desconhecida"

			end

		end

	end
end

--============================================================
-- MONITORAR NOVOS OBJETOS
--============================================================

workspace.DescendantAdded:Connect(function(object)

	-- Pequeno atraso para garantir que
	-- a fruta tenha terminado de carregar.
	task.delay(0.1, function()

		if Gui.Parent then
			ScanFruits()
		end

	end)

end)

workspace.DescendantRemoving:Connect(function()

	task.delay(0.05, function()

		if Gui.Parent then
			ScanFruits()
		end

	end)

end)

--============================================================
-- LOOP DE SCAN
--============================================================

task.spawn(function()

	while Gui.Parent do

		ScanFruits()

		task.wait(SCAN_INTERVAL)

	end

end)

--============================================================
-- LOOP DE DISTÂNCIA
--============================================================

RunService.RenderStepped:Connect(function()

	if Gui.Parent then
		UpdateDistances()
	end

end)

--============================================================
-- PRIMEIRO SCAN
--============================================================

task.wait(1)

ScanFruits()

Status.Text = "Sistema pronto"
Status.TextColor3 = Color3.fromRGB(100, 255, 120)
```
