--========================================================
-- FRUIT RECOGNITION SYSTEM
-- Para Roblox Studio / seu próprio jogo
--========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local FRUIT_FOLDER_NAME = "Fruits"
local SCAN_INTERVAL = 0.5

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

--========================================================
-- REMOVE GUI ANTIGO
--========================================================

local oldGui = PlayerGui:FindFirstChild("FruitRecognition")
if oldGui then
	oldGui:Destroy()
end

--========================================================
-- GUI
--========================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitRecognition"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 300, 0, 380)
Main.Position = UDim2.new(0, 20, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.BorderSizePixel = 0
Main.Parent = Gui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Main

--========================================================
-- TÍTULO
--========================================================

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.new(0, 10, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🍎 Fruit Recognition"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.Parent = Main

--========================================================
-- STATUS
--========================================================

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.new(0, 10, 0, 50)
Status.BackgroundTransparency = 1
Status.Text = "Procurando frutas..."
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.TextSize = 14
Status.Font = Enum.Font.Gotham
Status.Parent = Main

--========================================================
-- LISTA
--========================================================

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Size = UDim2.new(1, -20, 1, -95)
List.Position = UDim2.new(0, 10, 0, 90)
List.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
List.BorderSizePixel = 0
List.ScrollBarThickness = 5
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.Name
Layout.Parent = List

--========================================================
-- FUNÇÃO: NORMALIZAR NOME
--========================================================

local function NormalizeName(name)
	name = tostring(name)

	-- Remove "Fruit" do final
	name = name:gsub("%s+[Ff]ruit$", "")

	-- Remove espaços extras
	name = name:gsub("^%s+", "")
	name = name:gsub("%s+$", "")

	return name
end

--========================================================
-- FUNÇÃO: VERIFICAR SE É FRUTA
--========================================================

local function IsFruit(object)
	if not object then
		return false
	end

	local normalized = NormalizeName(object.Name)

	return FruitNames[normalized] == true
end

--========================================================
-- CRIAR ITEM NA LISTA
--========================================================

local function CreateFruitEntry(name, object)
	local Entry = Instance.new("Frame")
	Entry.Size = UDim2.new(1, -10, 0, 55)
	Entry.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Entry.BorderSizePixel = 0
	Entry.Parent = List

	local EntryCorner = Instance.new("UICorner")
	EntryCorner.CornerRadius = UDim.new(0, 8)
	EntryCorner.Parent = Entry

	local NameLabel = Instance.new("TextLabel")
	NameLabel.Size = UDim2.new(1, -20, 0, 28)
	NameLabel.Position = UDim2.new(0, 10, 0, 4)
	NameLabel.BackgroundTransparency = 1
	NameLabel.Text = "🍏 " .. name .. " Fruit"
	NameLabel.TextColor3 = Color3.new(1, 1, 1)
	NameLabel.TextSize = 16
	NameLabel.Font = Enum.Font.GothamBold
	NameLabel.TextXAlignment = Enum.TextXAlignment.Left
	NameLabel.Parent = Entry

	local DistanceLabel = Instance.new("TextLabel")
	DistanceLabel.Size = UDim2.new(1, -20, 0, 18)
	DistanceLabel.Position = UDim2.new(0, 10, 0, 32)
	DistanceLabel.BackgroundTransparency = 1
	DistanceLabel.Text = "Detectada"
	DistanceLabel.TextColor3 = Color3.fromRGB(120, 220, 120)
	DistanceLabel.TextSize = 12
	DistanceLabel.Font = Enum.Font.Gotham
	DistanceLabel.TextXAlignment = Enum.TextXAlignment.Left
	DistanceLabel.Parent = Entry

	return Entry, DistanceLabel
end

--========================================================
-- OBTER POSIÇÃO DO OBJETO
--========================================================

local function GetPosition(object)
	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		return object:GetPivot().Position
	end

	return nil
end

--========================================================
-- SCAN
--========================================================

local Detected = {}

local function ScanFruits()
	local folder = workspace:FindFirstChild(FRUIT_FOLDER_NAME)

	if not folder then
		Status.Text = "Pasta Fruits não encontrada"
		Status.TextColor3 = Color3.fromRGB(255, 180, 80)
		return
	end

	Status.Text = "Escaneando..."
	Status.TextColor3 = Color3.fromRGB(180, 180, 180)

	local Current = {}

	for _, object in ipairs(folder:GetDescendants()) do

		if IsFruit(object) then

			local fruitName = NormalizeName(object.Name)

			Current[object] = {
				Name = fruitName,
				Object = object
			}

			if not Detected[object] then
				Detected[object] = true

				local entry, distanceLabel =
					CreateFruitEntry(fruitName, object)

				Detected[object] = {
					Entry = entry,
					DistanceLabel = distanceLabel,
					Name = fruitName
				}
			end
		end
	end

	-- Remover frutas que desapareceram
	for object, data in pairs(Detected) do

		if typeof(data) == "table" and data.Entry then

			if not Current[object] then
				if data.Entry then
					data.Entry:Destroy()
				end

				Detected[object] = nil
			end
		end
	end

	local Count = 0

	for object, data in pairs(Current) do
		if data then
			Count += 1
		end
	end

	Status.Text = Count .. " fruta(s) detectada(s)"

	Status.TextColor3 =
		Count > 0
		and Color3.fromRGB(100, 255, 120)
		or Color3.fromRGB(180, 180, 180)

	List.CanvasSize = UDim2.new(
		0,
		0,
		0,
		Layout.AbsoluteContentSize.Y + 10
	)
end

--========================================================
-- DISTÂNCIA
--========================================================

local function UpdateDistances()

	local Character = Player.Character

	if not Character then
		return
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	for object, data in pairs(Detected) do

		if typeof(data) == "table"
			and data.Entry
			and object
			and object.Parent then

			local position = GetPosition(object)

			if position then

				local distance =
					(Root.Position - position).Magnitude

				data.DistanceLabel.Text =
					"📍 " .. math.floor(distance) .. " studs"

			end
		end
	end
end

--========================================================
-- LOOP
--========================================================

task.spawn(function()

	while Gui.Parent do

		ScanFruits()

		task.wait(SCAN_INTERVAL)

	end

end)

RunService.RenderStepped:Connect(function()

	UpdateDistances()

end)

--========================================================
-- DETECÇÃO IMEDIATA
--========================================================

local folder = workspace:FindFirstChild(FRUIT_FOLDER_NAME)

if folder then

	folder.DescendantAdded:Connect(function()

		task.wait(0.1)

		ScanFruits()

	end)

	folder.DescendantRemoving:Connect(function()

		task.wait()

		ScanFruits()

	end)

end
