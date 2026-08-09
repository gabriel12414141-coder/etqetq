--============================================================
-- FRUIT NOTIFIER REWORK v2
-- Roblox Studio - LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local MAX_DISTANCE = 2000
local SCAN_INTERVAL = 0.35
local UPDATE_INTERVAL = 0.10

-- 1 stud = 1 metro no sistema visual
local STUD_TO_METER = 1

--============================================================
-- FRUTAS VÁLIDAS
--============================================================

local ValidFruits = {
	Rocket = true,
	Spin = true,
	Blade = true,
	Spring = true,
	Bomb = true,
	Smoke = true,
	Spike = true,
	Flame = true,
	Ice = true,
	Sand = true,
	Dark = true,
	Eagle = true,
	Diamond = true,
	Light = true,
	Rubber = true,
	Ghost = true,
	Magma = true,
	Quake = true,
	Buddha = true,
	Love = true,
	Creation = true,
	Spider = true,
	Sound = true,
	Phoenix = true,
	Portal = true,
	Lightning = true,
	Pain = true,
	Blizzard = true,
	Gravity = true,
	Mammoth = true,
	["T-Rex"] = true,
	Dough = true,
	Shadow = true,
	Venom = true,
	Gas = true,
	Spirit = true,
	Tiger = true,
	Yeti = true,
	Kitsune = true,
	Control = true,
	Dragon = true,
}

--============================================================
-- ESTADO
--============================================================

local Detected = {}
local Markers = {}

local MarkersEnabled = true
local Minimized = false

--============================================================
-- GUI
--============================================================

local old = PlayerGui:FindFirstChild("FruitNotifierRework")

if old then
	old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FruitNotifierRework"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--============================================================
-- FUNÇÕES GUI
--============================================================

local function Corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = obj
	return c
end

local function Stroke(obj)
	local s = Instance.new("UIStroke")
	s.Thickness = 1
	s.Transparency = 0.45
	s.Parent = obj
	return s
end

--============================================================
-- JANELA
--============================================================

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 320, 0, 430)
Main.Position = UDim2.new(0, 25, 0.5, -215)
Main.BackgroundColor3 = Color3.fromRGB(17, 17, 23)
Main.BackgroundTransparency = 0.08
Main.Parent = ScreenGui

Corner(Main, 12)
Stroke(Main)

--============================================================
-- HEADER
--============================================================

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundTransparency = 1
Header.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -60, 0, 32)
Title.Position = UDim2.new(0, 15, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🍎  FRUIT NOTIFIER"
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -60, 0, 20)
Status.Position = UDim2.new(0, 16, 0, 36)
Status.BackgroundTransparency = 1
Status.Text = "● SISTEMA ATIVO"
Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Header

local Minimize = Instance.new("TextButton")
Minimize.Size = UDim2.new(0, 38, 0, 38)
Minimize.Position = UDim2.new(1, -48, 0, 12)
Minimize.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Minimize.Text = "—"
Minimize.TextSize = 21
Minimize.Font = Enum.Font.GothamBold
Minimize.Parent = Header

Corner(Minimize, 8)

--============================================================
-- CONTADOR
--============================================================

local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(1, -30, 0, 25)
Counter.Position = UDim2.new(0, 15, 0, 68)
Counter.BackgroundTransparency = 1
Counter.Text = "Frutas encontradas: 0"
Counter.TextSize = 14
Counter.Font = Enum.Font.GothamMedium
Counter.TextXAlignment = Enum.TextXAlignment.Left
Counter.Parent = Main

--============================================================
-- LISTA
--============================================================

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Size = UDim2.new(1, -20, 0, 260)
List.Position = UDim2.new(0, 10, 0, 100)
List.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
List.BackgroundTransparency = 0.1
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Main

Corner(List, 9)

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = List

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 7)
Padding.PaddingBottom = UDim.new(0, 7)
Padding.PaddingLeft = UDim.new(0, 7)
Padding.PaddingRight = UDim.new(0, 7)
Padding.Parent = List

--============================================================
-- BOTÕES
--============================================================

local MarkerButton = Instance.new("TextButton")
MarkerButton.Size = UDim2.new(0.48, -5, 0, 45)
MarkerButton.Position = UDim2.new(0, 10, 1, -55)
MarkerButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MarkerButton.Text = "👁 MARCADORES: ON"
MarkerButton.TextSize = 12
MarkerButton.Font = Enum.Font.GothamBold
MarkerButton.Parent = Main

Corner(MarkerButton, 8)

local ClearButton = Instance.new("TextButton")
ClearButton.Size = UDim2.new(0.48, -5, 0, 45)
ClearButton.Position = UDim2.new(0.52, -5, 1, -55)
ClearButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
ClearButton.Text = "🗑 LIMPAR"
ClearButton.TextSize = 12
ClearButton.Font = Enum.Font.GothamBold
ClearButton.Parent = Main

Corner(ClearButton, 8)

--============================================================
-- NORMALIZAÇÃO
--============================================================

local function normalizeName(name)

	if typeof(name) ~= "string" then
		return nil
	end

	name = name:gsub("%s+", " ")
	name = name:match("^%s*(.-)%s*$")

	-- Obrigatoriamente:
	-- Nome Fruit

	local baseName = name:match("^(.-)%s+Fruit$")

	if not baseName then
		return nil
	end

	baseName = baseName:match("^%s*(.-)%s*$")

	if ValidFruits[baseName] then
		return baseName
	end

	return nil
end

--============================================================
-- IDENTIFICA FRUTA
--============================================================

local function IdentifyFruit(instance)

	if not instance then
		return nil
	end

	-- 1. Nome do próprio objeto
	local fruit = normalizeName(instance.Name)

	if fruit then
		return fruit
	end

	-- 2. Atributos
	for _, attribute in ipairs({
		"FruitName",
		"Fruit",
	}) do

		local value = instance:GetAttribute(attribute)

		if typeof(value) == "string" then

			fruit = normalizeName(value)

			if fruit then
				return fruit
			end
		end
	end

	-- 3. Verifica alguns pais
	local parent = instance.Parent

	local depth = 0

	while parent and depth < 4 do

		fruit = normalizeName(parent.Name)

		if fruit then
			return fruit
		end

		parent = parent.Parent
		depth += 1
	end

	return nil
end

--============================================================
-- ACHA UMA BASEPART
--============================================================

local function GetBasePart(object)

	if not object then
		return nil
	end

	-- O próprio objeto
	if object:IsA("BasePart") then
		return object
	end

	-- Se for Model
	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		local part = object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		if part then
			return part
		end
	end

	-- Tool
	if object:IsA("Tool") then

		local handle = object:FindFirstChild("Handle")

		if handle and handle:IsA("BasePart") then
			return handle
		end

		local part = object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		if part then
			return part
		end
	end

	-- Qualquer outro container
	local part = object:FindFirstChildWhichIsA(
		"BasePart",
		true
	)

	return part
end

--============================================================
-- POSIÇÃO
--============================================================

local function GetPosition(object)

	local part = GetBasePart(object)

	if not part then
		return nil
	end

	return part.Position
end

--============================================================
-- CRIAR MARCADOR
--============================================================

local function CreateMarker(object, fruitName)

	if not MarkersEnabled then
		return
	end

	if Markers[object] then
		return
	end

	local part = GetBasePart(object)

	if not part then
		return
	end

	local Billboard = Instance.new("BillboardGui")

	Billboard.Name = "FruitMarker"

	Billboard.Adornee = part

	Billboard.Size = UDim2.new(0, 210, 0, 65)

	Billboard.StudsOffset = Vector3.new(
		0,
		5,
		0
	)

	Billboard.AlwaysOnTop = true

	Billboard.MaxDistance = MAX_DISTANCE

	Billboard.Parent = part

	--========================================================
	-- NOME
	--========================================================

	local NameLabel = Instance.new("TextLabel")

	NameLabel.Size = UDim2.new(1, 0, 0, 32)

	NameLabel.BackgroundTransparency = 1

	NameLabel.Text = fruitName .. " Fruit"

	NameLabel.TextSize = 18

	NameLabel.Font = Enum.Font.GothamBold

	NameLabel.TextStrokeTransparency = 0

	NameLabel.Parent = Billboard

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel = Instance.new("TextLabel")

	DistanceLabel.Size = UDim2.new(1, 0, 0, 25)

	DistanceLabel.Position = UDim2.new(0, 0, 0, 31)

	DistanceLabel.BackgroundTransparency = 1

	DistanceLabel.Text = "0 m"

	DistanceLabel.TextSize = 14

	DistanceLabel.Font = Enum.Font.GothamMedium

	DistanceLabel.TextStrokeTransparency = 0

	DistanceLabel.Parent = Billboard

	Markers[object] = {
		Gui = Billboard,
		Distance = DistanceLabel,
		Name = NameLabel,
	}
end

--============================================================
-- REMOVER MARCADOR
--============================================================

local function RemoveMarker(object)

	local marker = Markers[object]

	if marker then

		if marker.Gui then
			marker.Gui:Destroy()
		end

		Markers[object] = nil
	end
end

--============================================================
-- DISTÂNCIA
--============================================================

local function GetDistance(object)

	local character = LocalPlayer.Character

	if not character then
		return nil
	end

	local root = character:FindFirstChild(
		"HumanoidRootPart"
	)

	if not root then
		return nil
	end

	local position = GetPosition(object)

	if not position then
		return nil
	end

	return (
		root.Position - position
	).Magnitude * STUD_TO_METER
end

--============================================================
-- ADICIONA FRUTA
--============================================================

local function RegisterFruit(object, fruitName)

	if not object then
		return
	end

	if not object:IsDescendantOf(workspace) then
		return
	end

	local distance = GetDistance(object)

	if not distance then
		return
	end

	if distance > MAX_DISTANCE then
		return
	end

	Detected[object] = {
		Object = object,
		Name = fruitName,
		Distance = distance,
	}

	CreateMarker(object, fruitName)
end

--============================================================
-- TENTA DETECTAR OBJETO
--============================================================

local function TryDetect(object)

	if not object then
		return
	end

	local fruitName = IdentifyFruit(object)

	if not fruitName then
		return
	end

	RegisterFruit(object, fruitName)
end

--============================================================
-- SCAN COMPLETO
--============================================================

local function FullScan()

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		TryDetect(object)

	end
end

--============================================================
-- ATUALIZA DISTÂNCIAS
--============================================================

local function UpdateDistances()

	for object, data in pairs(Detected) do

		if not object
			or not object.Parent
			or not object:IsDescendantOf(workspace) then

			Detected[object] = nil
			RemoveMarker(object)

			continue
		end

		local distance = GetDistance(object)

		if not distance then
			continue
		end

		data.Distance = distance

		if distance > MAX_DISTANCE then

			Detected[object] = nil
			RemoveMarker(object)

			continue
		end

		local marker = Markers[object]

		if marker then

			marker.Distance.Text =
				string.format(
					"%d m",
					math.floor(distance)
				)

		end
	end
end

--============================================================
-- ATUALIZA LISTA
--============================================================

local function UpdateList()

	for _, child in ipairs(
		List:GetChildren()
	) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local fruits = {}

	for object, data in pairs(Detected) do

		if object and object.Parent then
			table.insert(fruits, data)
		end
	end

	table.sort(
		fruits,
		function(a, b)
			return a.Distance < b.Distance
		end
	)

	for index, data in ipairs(fruits) do

		local item = Instance.new("Frame")

		item.Size = UDim2.new(1, 0, 0, 48)

		item.BackgroundColor3 =
			Color3.fromRGB(27, 27, 36)

		item.LayoutOrder = index

		item.Parent = List

		Corner(item, 7)

		local Name = Instance.new("TextLabel")

		Name.Size = UDim2.new(
			1,
			-100,
			1,
			0
		)

		Name.Position = UDim2.new(
			0,
			10,
			0,
			0
		)

		Name.BackgroundTransparency = 1

		Name.Text =
			data.Name .. " Fruit"

		Name.TextSize = 13

		Name.Font =
			Enum.Font.GothamBold

		Name.TextXAlignment =
			Enum.TextXAlignment.Left

		Name.Parent = item

		local Distance = Instance.new("TextLabel")

		Distance.Size = UDim2.new(
			0,
			85,
			1,
			0
		)

		Distance.Position = UDim2.new(
			1,
			-90,
			0,
			0
		)

		Distance.BackgroundTransparency = 1

		Distance.Text =
			string.format(
				"%d m",
				math.floor(data.Distance)
			)

		Distance.TextSize = 13

		Distance.Font =
			Enum.Font.GothamBold

		Distance.TextXAlignment =
			Enum.TextXAlignment.Right

		Distance.Parent = item
	end

	Counter.Text =
		"Frutas encontradas: "
		.. tostring(#fruits)

	task.defer(function()

		List.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				Layout.AbsoluteContentSize.Y + 15
			)

	end)
end

--============================================================
-- MARCADORES ON/OFF
--============================================================

MarkerButton.MouseButton1Click:Connect(function()

	MarkersEnabled = not MarkersEnabled

	if MarkersEnabled then

		MarkerButton.Text =
			"👁 MARCADORES: ON"

		for object, data in pairs(Detected) do

			CreateMarker(
				object,
				data.Name
			)

		end

	else

		MarkerButton.Text =
			"👁 MARCADORES: OFF"

		for object in pairs(Markers) do
			RemoveMarker(object)
		end
	end
end)

--============================================================
-- LIMPAR
--============================================================

ClearButton.MouseButton1Click:Connect(function()

	for object in pairs(Detected) do
		RemoveMarker(object)
	end

	table.clear(Detected)

	UpdateList()
end)

--============================================================
-- MINIMIZAR
--============================================================

Minimize.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	if Minimized then

		Main.Size =
			UDim2.new(0, 320, 0, 65)

		Counter.Visible = false
		List.Visible = false
		MarkerButton.Visible = false
		ClearButton.Visible = false

		Minimize.Text = "+"

	else

		Main.Size =
			UDim2.new(0, 320, 0, 430)

		Counter.Visible = true
		List.Visible = true
		MarkerButton.Visible = true
		ClearButton.Visible = true

		Minimize.Text = "—"
	end
end)

--============================================================
-- ARRASTAR
--============================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		dragging = true

		dragStart = input.Position
		startPosition = Main.Position
	end
end)

Header.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~=
		Enum.UserInputType.MouseMovement then
		return
	end

	local delta =
		input.Position - dragStart

	Main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,

		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end)

--============================================================
-- NOVOS OBJETOS
--============================================================

workspace.DescendantAdded:Connect(function(object)

	task.wait()

	if object and object.Parent then
		TryDetect(object)
	end
end)

--============================================================
-- OBJETOS REMOVIDOS
--============================================================

workspace.DescendantRemoving:Connect(function(object)

	if Detected[object] then
		Detected[object] = nil
	end

	if Markers[object] then
		RemoveMarker(object)
	end
end)

--============================================================
-- LOOP
--============================================================

task.spawn(function()

	while ScreenGui.Parent do

		FullScan()

		task.wait(SCAN_INTERVAL)
	end
end)

task.spawn(function()

	while ScreenGui.Parent do

		UpdateDistances()
		UpdateList()

		task.wait(UPDATE_INTERVAL)
	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

Status.Text = "● SISTEMA ATIVO"

-- Faz uma busca imediatamente
FullScan()
UpdateDistances()
UpdateList()

print(
	"[FruitNotifier] Rework iniciado."
)

print(
	"[FruitNotifier] Whitelist: 42 frutas."
)
