--============================================================
-- FRUIT NOTIFIER REWORK
-- Roblox Studio / LocalScript
-- Coloque em:
-- StarterPlayer > StarterPlayerScripts
--============================================================

--============================================================
-- SERVIÇOS
--============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

--============================================================
-- CONFIGURAÇÕES
--============================================================

local CONFIG = {

	-- Distância máxima para detectar
	MaxDistance = 2000,

	-- Distância máxima para mostrar marcador
	MaxMarkerDistance = 2000,

	-- Atualização
	ScanInterval = 0.25,
	DistanceUpdateInterval = 0.10,

	-- Conversão de studs para metros.
	-- Roblox usa studs. Aqui usamos 1 stud ≈ 1 metro.
	StudsToMeters = 1,

	-- Nome dos marcadores
	ShowName = true,
	ShowDistance = true,

	-- GUI
	PanelWidth = 310,
	PanelHeight = 390,

	-- Cores
	BackgroundTransparency = 0.12,
}

--============================================================
-- WHITELIST
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
-- ORDEM DAS FRUTAS
--============================================================

local FruitOrder = {
	"Rocket",
	"Spin",
	"Blade",
	"Spring",
	"Bomb",
	"Smoke",
	"Spike",
	"Flame",
	"Ice",
	"Sand",
	"Dark",
	"Eagle",
	"Diamond",
	"Light",
	"Rubber",
	"Ghost",
	"Magma",
	"Quake",
	"Buddha",
	"Love",
	"Creation",
	"Spider",
	"Sound",
	"Phoenix",
	"Portal",
	"Lightning",
	"Pain",
	"Blizzard",
	"Gravity",
	"Mammoth",
	"T-Rex",
	"Dough",
	"Shadow",
	"Venom",
	"Gas",
	"Spirit",
	"Tiger",
	"Yeti",
	"Kitsune",
	"Control",
	"Dragon",
}

--============================================================
-- FUNÇÕES DE NORMALIZAÇÃO
--============================================================

local function trim(text)
	return text:match("^%s*(.-)%s*$")
end

local function normalizeName(text)
	if not text then
		return nil
	end

	text = tostring(text)

	text = text:gsub("%s+", " ")
	text = trim(text)

	-- Aceita somente nomes terminados em " Fruit"
	local fruitName = text:match("^(.-)%s+Fruit$")

	if not fruitName then
		return nil
	end

	fruitName = trim(fruitName)

	if ValidFruits[fruitName] then
		return fruitName
	end

	return nil
end

--============================================================
-- OBTÉM A POSIÇÃO DE UM OBJETO
--============================================================

local function getObjectPosition(object)

	if not object then
		return nil
	end

	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		local primary = object.PrimaryPart

		if primary then
			return primary.Position
		end

		local part = object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		if part then
			return part.Position
		end
	end

	return nil
end

--============================================================
-- GUI PRINCIPAL
--============================================================

local playerGui = player:WaitForChild("PlayerGui")

-- Remove GUI antigo
local oldGui = playerGui:FindFirstChild("FruitNotifierRework")

if oldGui then
	oldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FruitNotifierRework"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = playerGui

--============================================================
-- FUNÇÃO PARA CRIAR CANTOS
--============================================================

local function addCorner(object, radius)

	local corner = Instance.new("UICorner")

	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = object

	return corner
end

--============================================================
-- FUNÇÃO PARA CRIAR BORDA
--============================================================

local function addStroke(object)

	local stroke = Instance.new("UIStroke")

	stroke.Thickness = 1
	stroke.Transparency = 0.5

	stroke.Parent = object

	return stroke
end

--============================================================
-- PAINEL
--============================================================

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = UDim2.new(
	0,
	CONFIG.PanelWidth,
	0,
	CONFIG.PanelHeight
)

Main.Position = UDim2.new(
	0,
	25,
	0.5,
	-CONFIG.PanelHeight / 2
)

Main.BackgroundTransparency = CONFIG.BackgroundTransparency
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)

Main.Parent = ScreenGui

addCorner(Main, 12)
addStroke(Main)

--============================================================
-- CABEÇALHO
--============================================================

local Header = Instance.new("Frame")

Header.Name = "Header"

Header.Size = UDim2.new(1, 0, 0, 62)

Header.BackgroundTransparency = 1

Header.Parent = Main

--============================================================
-- TÍTULO
--============================================================

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(
	1,
	-70,
	0,
	32
)

Title.Position = UDim2.new(
	0,
	15,
	0,
	6
)

Title.BackgroundTransparency = 1

Title.Text = "🍎  FRUIT NOTIFIER"

Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = Header

--============================================================
-- STATUS
--============================================================

local Status = Instance.new("TextLabel")

Status.Size = UDim2.new(
	1,
	-70,
	0,
	20
)

Status.Position = UDim2.new(
	0,
	16,
	0,
	36
)

Status.BackgroundTransparency = 1

Status.Text = "●  SISTEMA ATIVO"

Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium

Status.TextXAlignment = Enum.TextXAlignment.Left

Status.Parent = Header

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local Minimize = Instance.new("TextButton")

Minimize.Size = UDim2.new(
	0,
	38,
	0,
	38
)

Minimize.Position = UDim2.new(
	1,
	-48,
	0,
	12
)

Minimize.BackgroundColor3 = Color3.fromRGB(
	35,
	35,
	45
)

Minimize.Text = "—"

Minimize.TextSize = 22

Minimize.Font = Enum.Font.GothamBold

Minimize.Parent = Header

addCorner(Minimize, 8)

--============================================================
-- CONTADOR
--============================================================

local Counter = Instance.new("TextLabel")

Counter.Size = UDim2.new(
	1,
	-30,
	0,
	30
)

Counter.Position = UDim2.new(
	0,
	15,
	0,
	68
)

Counter.BackgroundTransparency = 1

Counter.Text = "Frutas encontradas: 0"

Counter.TextSize = 14
Counter.Font = Enum.Font.GothamMedium

Counter.TextXAlignment = Enum.TextXAlignment.Left

Counter.Parent = Main

--============================================================
-- SCROLL
--============================================================

local Scroll = Instance.new("ScrollingFrame")

Scroll.Name = "FruitList"

Scroll.Size = UDim2.new(
	1,
	-20,
	0,
	220
)

Scroll.Position = UDim2.new(
	0,
	10,
	0,
	103
)

Scroll.BackgroundColor3 = Color3.fromRGB(
	12,
	12,
	17
)

Scroll.BackgroundTransparency = 0.15

Scroll.BorderSizePixel = 0

Scroll.ScrollBarThickness = 4

Scroll.CanvasSize = UDim2.new(
	0,
	0,
	0,
	0
)

Scroll.Parent = Main

addCorner(Scroll, 9)

local ListLayout = Instance.new("UIListLayout")

ListLayout.Padding = UDim.new(0, 5)

ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

ListLayout.Parent = Scroll

local ListPadding = Instance.new("UIPadding")

ListPadding.PaddingTop = UDim.new(0, 7)
ListPadding.PaddingBottom = UDim.new(0, 7)
ListPadding.PaddingLeft = UDim.new(0, 7)
ListPadding.PaddingRight = UDim.new(0, 7)

ListPadding.Parent = Scroll

--============================================================
-- BOTÃO DOS MARCADORES
--============================================================

local MarkerButton = Instance.new("TextButton")

MarkerButton.Size = UDim2.new(
	0.48,
	-5,
	0,
	42
)

MarkerButton.Position = UDim2.new(
	0,
	10,
	1,
	-52
)

MarkerButton.BackgroundColor3 = Color3.fromRGB(
	35,
	35,
	45
)

MarkerButton.Text = "👁  MARCADORES: ON"

MarkerButton.TextSize = 12

MarkerButton.Font = Enum.Font.GothamBold

MarkerButton.Parent = Main

addCorner(MarkerButton, 8)

--============================================================
-- BOTÃO LIMPAR
--============================================================

local ClearButton = Instance.new("TextButton")

ClearButton.Size = UDim2.new(
	0.48,
	-5,
	0,
	42
)

ClearButton.Position = UDim2.new(
	0.52,
	-5,
	1,
	-52
)

ClearButton.BackgroundColor3 = Color3.fromRGB(
	35,
	35,
	45
)

ClearButton.Text = "🗑  LIMPAR"

ClearButton.TextSize = 12

ClearButton.Font = Enum.Font.GothamBold

ClearButton.Parent = Main

addCorner(ClearButton, 8)

--============================================================
-- ESTADO
--============================================================

local MarkersEnabled = true
local Minimized = false

local DetectedFruits = {}

local MarkerObjects = {}

--============================================================
-- CRIA MARCADOR
--============================================================

local function createMarker(object, fruitName)

	if not MarkersEnabled then
		return
	end

	if MarkerObjects[object] then
		return
	end

	local adornee = object

	if object:IsA("Model") then

		local part = object.PrimaryPart

		if not part then
			part = object:FindFirstChildWhichIsA(
				"BasePart",
				true
			)
		end

		adornee = part
	end

	if not adornee or not adornee:IsA("BasePart") then
		return
	end

	local Billboard = Instance.new("BillboardGui")

	Billboard.Name = "FruitMarker"

	Billboard.Adornee = adornee

	Billboard.Size = UDim2.new(
		0,
		180,
		0,
		60
	)

	Billboard.StudsOffset = Vector3.new(
		0,
		4,
		0
	)

	Billboard.AlwaysOnTop = true

	Billboard.MaxDistance = CONFIG.MaxMarkerDistance

	Billboard.Parent = adornee

	--========================================================
	-- NOME
	--========================================================

	local NameLabel = Instance.new("TextLabel")

	NameLabel.Name = "FruitName"

	NameLabel.Size = UDim2.new(
		1,
		0,
		0,
		30
	)

	NameLabel.BackgroundTransparency = 1

	NameLabel.Text = fruitName .. " Fruit"

	NameLabel.TextSize = 18

	NameLabel.Font = Enum.Font.GothamBold

	NameLabel.TextStrokeTransparency = 0.25

	NameLabel.Parent = Billboard

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel = Instance.new("TextLabel")

	DistanceLabel.Name = "Distance"

	DistanceLabel.Size = UDim2.new(
		1,
		0,
		0,
		22
	)

	DistanceLabel.Position = UDim2.new(
		0,
		0,
		0,
		29
	)

	DistanceLabel.BackgroundTransparency = 1

	DistanceLabel.Text = "0 m"

	DistanceLabel.TextSize = 14

	DistanceLabel.Font = Enum.Font.GothamMedium

	DistanceLabel.TextStrokeTransparency = 0.3

	DistanceLabel.Parent = Billboard

	MarkerObjects[object] = {
		Billboard = Billboard,
		Distance = DistanceLabel,
		Name = NameLabel,
		FruitName = fruitName,
	}
end

--============================================================
-- REMOVE MARCADOR
--============================================================

local function removeMarker(object)

	local data = MarkerObjects[object]

	if not data then
		return
	end

	if data.Billboard then
		data.Billboard:Destroy()
	end

	MarkerObjects[object] = nil
end

--============================================================
-- CRIA ITEM DA LISTA
--============================================================

local function createListItem(fruitData, index)

	local item = Instance.new("Frame")

	item.Name = "Fruit_" .. tostring(index)

	item.Size = UDim2.new(
		1,
		0,
		0,
		48
	)

	item.BackgroundColor3 = Color3.fromRGB(
		28,
		28,
		37
	)

	item.BorderSizePixel = 0

	item.Parent = Scroll

	addCorner(item, 7)

	--========================================================
	-- NOME
	--========================================================

	local Name = Instance.new("TextLabel")

	Name.Size = UDim2.new(
		1,
		-90,
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

	Name.Text = fruitData.Name .. " Fruit"

	Name.TextSize = 13

	Name.Font = Enum.Font.GothamBold

	Name.TextXAlignment = Enum.TextXAlignment.Left

	Name.Parent = item

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local Distance = Instance.new("TextLabel")

	Distance.Size = UDim2.new(
		0,
		80,
		1,
		0
	)

	Distance.Position = UDim2.new(
		1,
		-85,
		0,
		0
	)

	Distance.BackgroundTransparency = 1

	Distance.Text = tostring(
		math.floor(fruitData.Distance)
	) .. " m"

	Distance.TextSize = 13

	Distance.Font = Enum.Font.GothamBold

	Distance.TextXAlignment = Enum.TextXAlignment.Right

	Distance.Parent = item
end

--============================================================
-- ATUALIZA LISTA
--============================================================

local function updateList()

	for _, child in ipairs(Scroll:GetChildren()) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local sorted = {}

	for object, data in pairs(DetectedFruits) do

		if object and object.Parent then
			table.insert(sorted, data)
		end
	end

	table.sort(
		sorted,
		function(a, b)

			return a.Distance < b.Distance

		end
	)

	for index, data in ipairs(sorted) do

		createListItem(
			data,
			index
		)
	end

	Counter.Text =
		"Frutas encontradas: "
		.. tostring(#sorted)

	task.defer(function()

		Scroll.CanvasSize = UDim2.new(
			0,
			0,
			0,
			ListLayout.AbsoluteContentSize.Y + 15
		)

	end)
end

--============================================================
-- VERIFICA SE É UMA FRUTA
--============================================================

local function identifyFruit(object)

	if not object then
		return nil
	end

	-- Primeiro tenta o nome do objeto
	local result = normalizeName(object.Name)

	if result then
		return result
	end

	-- Caso a fruta esteja dentro de outro objeto,
	-- procura atributos de nome.
	local attributes = {
		"FruitName",
		"Fruit",
		"Name",
	}

	for _, attributeName in ipairs(attributes) do

		local value = object:GetAttribute(
			attributeName
		)

		if typeof(value) == "string" then

			local detected = normalizeName(value)

			if detected then
				return detected
			end
		end
	end

	return nil
end

--============================================================
-- VERIFICA UM OBJETO
--============================================================

local function processObject(object)

	if not object then
		return
	end

	local fruitName = identifyFruit(object)

	if not fruitName then
		return
	end

	local character = player.Character

	if not character then
		return
	end

	local root = character:FindFirstChild(
		"HumanoidRootPart"
	)

	if not root then
		return
	end

	local position = getObjectPosition(object)

	if not position then
		return
	end

	local distanceStuds =
		(root.Position - position).Magnitude

	local distance =
		distanceStuds * CONFIG.StudsToMeters

	if distance > CONFIG.MaxDistance then

		if DetectedFruits[object] then
			DetectedFruits[object] = nil
			removeMarker(object)
		end

		return
	end

	if not DetectedFruits[object] then

		DetectedFruits[object] = {

			Object = object,

			Name = fruitName,

			Distance = distance,

		}

		createMarker(
			object,
			fruitName
		)

	else

		DetectedFruits[object].Distance =
			distance

	end
end

--============================================================
-- SCAN WORKSPACE
--============================================================

local function scanWorkspace()

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		processObject(object)

	end
end

--============================================================
-- ATUALIZA DISTÂNCIAS
--============================================================

local function updateDistances()

	local character = player.Character

	if not character then
		return
	end

	local root = character:FindFirstChild(
		"HumanoidRootPart"
	)

	if not root then
		return
	end

	for object, data in pairs(DetectedFruits) do

		if not object
			or not object.Parent then

			DetectedFruits[object] = nil

			removeMarker(object)

		else

			local position =
				getObjectPosition(object)

			if position then

				local distanceStuds =
					(root.Position - position).Magnitude

				local distance =
					distanceStuds
					* CONFIG.StudsToMeters

				data.Distance = distance

				--================================================
				-- ATUALIZA MARCADOR
				--================================================

				local marker =
					MarkerObjects[object]

				if marker then

					marker.Distance.Text =
						math.floor(distance)
						.. " m"

				end

				--================================================
				-- REMOVE SE FICOU LONGE
				--================================================

				if distance > CONFIG.MaxDistance then

					DetectedFruits[object] = nil

					removeMarker(object)

				end
			end
		end
	end
end

--============================================================
-- LIMPAR
--============================================================

local function clearAll()

	for object in pairs(DetectedFruits) do

		removeMarker(object)

	end

	table.clear(DetectedFruits)

	updateList()

end

--============================================================
-- BOTÃO MARCADORES
--============================================================

MarkerButton.MouseButton1Click:Connect(function()

	MarkersEnabled = not MarkersEnabled

	if MarkersEnabled then

		MarkerButton.Text =
			"👁  MARCADORES: ON"

		for object, data in pairs(
			DetectedFruits
		) do

			createMarker(
				object,
				data.Name
			)

		end

	else

		MarkerButton.Text =
			"👁  MARCADORES: OFF"

		for object in pairs(
			MarkerObjects
		) do

			removeMarker(object)

		end
	end
end)

--============================================================
-- BOTÃO LIMPAR
--============================================================

ClearButton.MouseButton1Click:Connect(function()

	clearAll()

end)

--============================================================
-- MINIMIZAR
--============================================================

Minimize.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	if Minimized then

		Main.Size = UDim2.new(
			0,
			CONFIG.PanelWidth,
			0,
			62
		)

		Counter.Visible = false
		Scroll.Visible = false
		MarkerButton.Visible = false
		ClearButton.Visible = false

		Minimize.Text = "+"

	else

		Main.Size = UDim2.new(
			0,
			CONFIG.PanelWidth,
			0,
			CONFIG.PanelHeight
		)

		Counter.Visible = true
		Scroll.Visible = true
		MarkerButton.Visible = true
		ClearButton.Visible = true

		Minimize.Text = "—"

	end
end)

--============================================================
-- ARRASTAR GUI
--============================================================

local dragging = false

local dragStart
local startPosition

Header.InputBegan:Connect(function(input)

	if input.UserInputType
		== Enum.UserInputType.MouseButton1 then

		dragging = true

		dragStart = input.Position

		startPosition = Main.Position

	end
end)

Header.InputEnded:Connect(function(input)

	if input.UserInputType
		== Enum.UserInputType.MouseButton1 then

		dragging = false

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType
		~= Enum.UserInputType.MouseMovement then

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

	-- Pequeno atraso para permitir que
	-- Model/Part termine de ser montado.

	task.delay(
		0.05,
		function()

			if object
				and object.Parent then

				processObject(object)

			end

		end
	)

end)

--============================================================
-- OBJETOS REMOVIDOS
--============================================================

workspace.DescendantRemoving:Connect(function(object)

	if DetectedFruits[object] then

		DetectedFruits[object] = nil

	end

	if MarkerObjects[object] then

		removeMarker(object)

	end

end)

--============================================================
-- LOOP PRINCIPAL
--============================================================

task.spawn(function()

	while ScreenGui.Parent do

		scanWorkspace()

		task.wait(
			CONFIG.ScanInterval
		)

	end

end)

--============================================================
-- LOOP DE DISTÂNCIA
--============================================================

task.spawn(function()

	local accumulated = 0

	while ScreenGui.Parent do

		updateDistances()

		accumulated +=
			CONFIG.DistanceUpdateInterval

		if accumulated >= 0.25 then

			accumulated = 0

			updateList()

		end

		task.wait(
			CONFIG.DistanceUpdateInterval
		)

	end

end)

--============================================================
-- FINALIZAÇÃO
--============================================================

Status.Text = "●  SISTEMA ATIVO"

print(
	"[FruitNotifierRework] Sistema iniciado."
)

print(
	"[FruitNotifierRework] "
	.. tostring(#FruitOrder)
	.. " frutas cadastradas."
)
