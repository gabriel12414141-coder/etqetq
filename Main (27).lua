--============================================================
-- FRUIT NOTIFIER REWORK v3 - PERFORMANCE
-- Roblox Studio / LocalScript
--
-- Foco:
--  * Baixo uso de CPU
--  * Sem GetDescendants() em loop
--  * Detecção incremental
--  * Cache das frutas
--  * GUI atualizado somente quando necessário
--  * Nome + distância acima da fruta
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local CONFIG = {
	MaxDistance = 2000,

	-- Frequência de atualização das distâncias
	DistanceUpdateRate = 0.15,

	-- Frequência da lista
	ListUpdateRate = 0.40,

	-- Conversão visual
	StudToMeter = 1,

	-- Tamanho máximo do histórico/lista
	MaxListItems = 50,

	-- Marcadores
	MarkerMaxDistance = 2000,
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
-- ESTADO
--============================================================

local Fruits = {}
local Markers = {}

local MarkersEnabled = true
local Minimized = false

local Character
local RootPart

local ListDirty = true

--============================================================
-- CHARACTER
--============================================================

local function UpdateCharacter(character)

	Character = character

	RootPart = character:WaitForChild(
		"HumanoidRootPart",
		10
	)
end

if Player.Character then
	task.spawn(function()
		UpdateCharacter(Player.Character)
	end)
end

Player.CharacterAdded:Connect(UpdateCharacter)

--============================================================
-- GUI
--============================================================

local OldGui = PlayerGui:FindFirstChild(
	"FruitNotifierRework"
)

if OldGui then
	OldGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FruitNotifierRework"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = PlayerGui

--============================================================
-- HELPERS
--============================================================

local function AddCorner(object, radius)

	local corner = Instance.new("UICorner")

	corner.CornerRadius = UDim.new(
		0,
		radius
	)

	corner.Parent = object

	return corner
end

local function AddStroke(object)

	local stroke = Instance.new("UIStroke")

	stroke.Thickness = 1
	stroke.Transparency = 0.5

	stroke.Parent = object

	return stroke
end

--============================================================
-- MAIN
--============================================================

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = UDim2.new(
	0,
	320,
	0,
	420
)

Main.Position = UDim2.new(
	0,
	25,
	0.5,
	-210
)

Main.BackgroundColor3 = Color3.fromRGB(
	17,
	17,
	23
)

Main.BackgroundTransparency = 0.08

Main.Parent = ScreenGui

AddCorner(Main, 12)
AddStroke(Main)

--============================================================
-- HEADER
--============================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(
	1,
	0,
	0,
	65
)

Header.BackgroundTransparency = 1

Header.Parent = Main

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(
	1,
	-60,
	0,
	32
)

Title.Position = UDim2.new(
	0,
	15,
	0,
	5
)

Title.BackgroundTransparency = 1

Title.Text = "🍎  FRUIT NOTIFIER"

Title.TextSize = 19
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent = Header

local Status = Instance.new("TextLabel")

Status.Size = UDim2.new(
	1,
	-60,
	0,
	20
)

Status.Position = UDim2.new(
	0,
	16,
	0,
	37
)

Status.BackgroundTransparency = 1

Status.Text = "● SISTEMA ATIVO"

Status.TextSize = 12
Status.Font = Enum.Font.GothamMedium

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent = Header

local MinimizeButton = Instance.new("TextButton")

MinimizeButton.Size = UDim2.new(
	0,
	38,
	0,
	38
)

MinimizeButton.Position = UDim2.new(
	1,
	-48,
	0,
	12
)

MinimizeButton.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

MinimizeButton.Text = "—"

MinimizeButton.TextSize = 21
MinimizeButton.Font =
	Enum.Font.GothamBold

MinimizeButton.Parent = Header

AddCorner(MinimizeButton, 8)

--============================================================
-- COUNTER
--============================================================

local Counter = Instance.new("TextLabel")

Counter.Size = UDim2.new(
	1,
	-30,
	0,
	25
)

Counter.Position = UDim2.new(
	0,
	15,
	0,
	70
)

Counter.BackgroundTransparency = 1

Counter.Text =
	"Frutas encontradas: 0"

Counter.TextSize = 14

Counter.Font =
	Enum.Font.GothamMedium

Counter.TextXAlignment =
	Enum.TextXAlignment.Left

Counter.Parent = Main

--============================================================
-- LISTA
--============================================================

local List = Instance.new("ScrollingFrame")

List.Name = "FruitList"

List.Size = UDim2.new(
	1,
	-20,
	0,
	250
)

List.Position = UDim2.new(
	0,
	10,
	0,
	100
)

List.BackgroundColor3 =
	Color3.fromRGB(10, 10, 15)

List.BackgroundTransparency = 0.1

List.BorderSizePixel = 0

List.ScrollBarThickness = 4

List.CanvasSize =
	UDim2.new(0, 0, 0, 0)

List.Parent = Main

AddCorner(List, 9)

local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(
	0,
	5
)

Layout.SortOrder =
	Enum.SortOrder.LayoutOrder

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

MarkerButton.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

MarkerButton.Text =
	"👁 MARCADORES: ON"

MarkerButton.TextSize = 12

MarkerButton.Font =
	Enum.Font.GothamBold

MarkerButton.Parent = Main

AddCorner(MarkerButton, 8)

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

ClearButton.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

ClearButton.Text = "🗑 LIMPAR"

ClearButton.TextSize = 12

ClearButton.Font =
	Enum.Font.GothamBold

ClearButton.Parent = Main

AddCorner(ClearButton, 8)

--============================================================
-- NORMALIZAÇÃO
--============================================================

local function NormalizeFruitName(name)

	if typeof(name) ~= "string" then
		return nil
	end

	name = name:gsub("%s+", " ")

	name = name:match("^%s*(.-)%s*$")

	local baseName =
		name:match("^(.-)%s+Fruit$")

	if not baseName then
		return nil
	end

	baseName =
		baseName:match("^%s*(.-)%s*$")

	if ValidFruits[baseName] then
		return baseName
	end

	return nil
end

--============================================================
-- IDENTIFICA FRUTA
--============================================================

local function IdentifyFruit(object)

	if not object then
		return nil
	end

	-- Nome principal
	local fruit =
		NormalizeFruitName(object.Name)

	if fruit then
		return fruit
	end

	-- Atributos
	local attributes = {
		"FruitName",
		"Fruit",
	}

	for _, attributeName in ipairs(attributes) do

		local value =
			object:GetAttribute(
				attributeName
			)

		if typeof(value) == "string" then

			fruit =
				NormalizeFruitName(value)

			if fruit then
				return fruit
			end
		end
	end

	-- Pais próximos
	local parent = object.Parent

	for _ = 1, 3 do

		if not parent then
			break
		end

		fruit =
			NormalizeFruitName(
				parent.Name
			)

		if fruit then
			return fruit
		end

		parent = parent.Parent
	end

	return nil
end

--============================================================
-- BASEPART
--============================================================

local function GetBasePart(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	if object:IsA("Tool") then

		local handle =
			object:FindFirstChild("Handle")

		if handle and
			handle:IsA("BasePart") then

			return handle
		end
	end

	return object:FindFirstChildWhichIsA(
		"BasePart",
		true
	)
end

--============================================================
-- MARCADOR
--============================================================

local function CreateMarker(object, fruitName)

	if not MarkersEnabled then
		return
	end

	if Markers[object] then
		return
	end

	local part =
		GetBasePart(object)

	if not part then
		return
	end

	local Billboard =
		Instance.new("BillboardGui")

	Billboard.Name =
		"FruitMarker"

	Billboard.Adornee =
		part

	Billboard.Size =
		UDim2.new(
			0,
			210,
			0,
			65
		)

	Billboard.StudsOffset =
		Vector3.new(
			0,
			5,
			0
		)

	Billboard.AlwaysOnTop = true

	Billboard.MaxDistance =
		CONFIG.MarkerMaxDistance

	Billboard.Parent = part

	local NameLabel =
		Instance.new("TextLabel")

	NameLabel.Size =
		UDim2.new(
			1,
			0,
			0,
			32
		)

	NameLabel.BackgroundTransparency = 1

	NameLabel.Text =
		fruitName .. " Fruit"

	NameLabel.TextSize = 18

	NameLabel.Font =
		Enum.Font.GothamBold

	NameLabel.TextStrokeTransparency = 0

	NameLabel.Parent = Billboard

	local DistanceLabel =
		Instance.new("TextLabel")

	DistanceLabel.Size =
		UDim2.new(
			1,
			0,
			0,
			25
		)

	DistanceLabel.Position =
		UDim2.new(
			0,
			0,
			0,
			31
		)

	DistanceLabel.BackgroundTransparency = 1

	DistanceLabel.Text = "0 m"

	DistanceLabel.TextSize = 14

	DistanceLabel.Font =
		Enum.Font.GothamMedium

	DistanceLabel.TextStrokeTransparency = 0

	DistanceLabel.Parent = Billboard

	Markers[object] = {
		Gui = Billboard,
		Distance = DistanceLabel,
	}
end

--============================================================
-- REMOVE MARCADOR
--============================================================

local function RemoveMarker(object)

	local marker =
		Markers[object]

	if not marker then
		return
	end

	if marker.Gui then
		marker.Gui:Destroy()
	end

	Markers[object] = nil
end

--============================================================
-- DISTÂNCIA
--============================================================

local function GetDistance(object)

	if not RootPart then
		return nil
	end

	local part =
		GetBasePart(object)

	if not part then
		return nil
	end

	return (
		RootPart.Position -
		part.Position
	).Magnitude * CONFIG.StudToMeter
end

--============================================================
-- REGISTRAR
--============================================================

local function RegisterFruit(object, fruitName)

	if Fruits[object] then
		return
	end

	local distance =
		GetDistance(object)

	if not distance then
		return
	end

	if distance > CONFIG.MaxDistance then
		return
	end

	Fruits[object] = {
		Object = object,
		Name = fruitName,
		Distance = distance,
	}

	CreateMarker(
		object,
		fruitName
	)

	ListDirty = true
end

--============================================================
-- DETECTAR UM OBJETO
--============================================================

local function DetectObject(object)

	if not object then
		return
	end

	-- Evita analisar objetos que nunca
	-- podem conter uma fruta.
	if not (
		object:IsA("Model")
		or object:IsA("BasePart")
		or object:IsA("Tool")
	) then

		return
	end

	local fruitName =
		IdentifyFruit(object)

	if not fruitName then
		return
	end

	RegisterFruit(
		object,
		fruitName
	)
end

--============================================================
-- SCAN INICIAL
--
-- Executado SOMENTE uma vez.
--============================================================

local function InitialScan()

	local descendants =
		workspace:GetDescendants()

	for _, object in ipairs(descendants) do

		DetectObject(object)

	end

	ListDirty = true
end

--============================================================
-- NOVOS OBJETOS
--
-- Depois do scan inicial não usamos
-- GetDescendants novamente.
--============================================================

workspace.DescendantAdded:Connect(
	function(object)

		-- Espera o objeto terminar de ser criado
		task.defer(function()

			if object and object.Parent then

				DetectObject(object)

			end

		end)
	end
)

--============================================================
-- REMOÇÃO
--============================================================

workspace.DescendantRemoving:Connect(
	function(object)

		if Fruits[object] then

			Fruits[object] = nil

			ListDirty = true
		end

		if Markers[object] then
			RemoveMarker(object)
		end
	end
)

--============================================================
-- ATUALIZA DISTÂNCIAS
--============================================================

local function UpdateDistances()

	local changed = false

	for object, data in pairs(Fruits) do

		if not object
			or not object.Parent then

			Fruits[object] = nil

			RemoveMarker(object)

			changed = true

			continue
		end

		local distance =
			GetDistance(object)

		if not distance then
			continue
		end

		data.Distance = distance

		local marker =
			Markers[object]

		if marker then

			marker.Distance.Text =
				string.format(
					"%d m",
					math.floor(distance)
				)
		end

		if distance >
			CONFIG.MaxDistance then

			Fruits[object] = nil

			RemoveMarker(object)

			changed = true
		end
	end

	if changed then
		ListDirty = true
	end
end

--============================================================
-- ATUALIZA LISTA
--
-- Só reconstrói quando necessário.
--============================================================

local function UpdateList()

	if not ListDirty then
		return
	end

	ListDirty = false

	for _, child in ipairs(
		List:GetChildren()
	) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local array = {}

	for _, data in pairs(Fruits) do

		table.insert(
			array,
			data
		)
	end

	table.sort(
		array,
		function(a, b)
			return a.Distance <
				b.Distance
		end
	)

	local total =
		math.min(
			#array,
			CONFIG.MaxListItems
		)

	for index = 1, total do

		local data = array[index]

		local Item =
			Instance.new("Frame")

		Item.Size =
			UDim2.new(
				1,
				0,
				0,
				48
			)

		Item.BackgroundColor3 =
			Color3.fromRGB(
				27,
				27,
				36
			)

		Item.LayoutOrder =
			index

		Item.Parent = List

		AddCorner(Item, 7)

		local Name =
			Instance.new("TextLabel")

		Name.Size =
			UDim2.new(
				1,
				-100,
				1,
				0
			)

		Name.Position =
			UDim2.new(
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

		Name.Parent = Item

		local Distance =
			Instance.new("TextLabel")

		Distance.Size =
			UDim2.new(
				0,
				85,
				1,
				0
			)

		Distance.Position =
			UDim2.new(
				1,
				-90,
				0,
				0
			)

		Distance.BackgroundTransparency = 1

		Distance.Text =
			string.format(
				"%d m",
				math.floor(
					data.Distance
				)
			)

		Distance.TextSize = 13

		Distance.Font =
			Enum.Font.GothamBold

		Distance.TextXAlignment =
			Enum.TextXAlignment.Right

		Distance.Parent = Item
	end

	Counter.Text =
		"Frutas encontradas: "
		.. tostring(#array)

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
-- MARCADORES
--============================================================

MarkerButton.MouseButton1Click:Connect(
	function()

		MarkersEnabled =
			not MarkersEnabled

		if MarkersEnabled then

			MarkerButton.Text =
				"👁 MARCADORES: ON"

			for object, data in
				pairs(Fruits) do

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
	end
)

--============================================================
-- LIMPAR
--============================================================

ClearButton.MouseButton1Click:Connect(
	function()

		for object in pairs(Fruits) do
			RemoveMarker(object)
		end

		table.clear(Fruits)

		ListDirty = true

		UpdateList()
	end
)

--============================================================
-- MINIMIZAR
--============================================================

MinimizeButton.MouseButton1Click:Connect(
	function()

		Minimized =
			not Minimized

		if Minimized then

			Main.Size =
				UDim2.new(
					0,
					320,
					0,
					65
				)

			Counter.Visible = false
			List.Visible = false
			MarkerButton.Visible = false
			ClearButton.Visible = false

			MinimizeButton.Text = "+"

		else

			Main.Size =
				UDim2.new(
					0,
					320,
					0,
					420
				)

			Counter.Visible = true
			List.Visible = true
			MarkerButton.Visible = true
			ClearButton.Visible = true

			MinimizeButton.Text = "—"
		end
	end
)

--============================================================
-- ARRASTAR
--============================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = true

			DragStart =
				input.Position

			StartPosition =
				Main.Position
		end
	end
)

Header.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging = false
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not Dragging then
			return
		end

		if input.UserInputType ~=
			Enum.UserInputType.MouseMovement then

			return
		end

		local delta =
			input.Position -
			DragStart

		Main.Position =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + delta.X,
				StartPosition.Y.Scale,
				StartPosition.Y.Offset + delta.Y
			)
	end
)

--============================================================
-- LOOP DE DISTÂNCIA
--
-- Não procura objetos aqui.
-- Apenas atualiza frutas que já foram
-- detectadas.
--============================================================

task.spawn(function()

	while ScreenGui.Parent do

		UpdateDistances()

		task.wait(
			CONFIG.DistanceUpdateRate
		)
	end
end)

--============================================================
-- LOOP DO GUI
--
-- Só atualiza quando a lista estiver suja.
--============================================================

task.spawn(function()

	while ScreenGui.Parent do

		UpdateList()

		task.wait(
			CONFIG.ListUpdateRate
		)
	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

Status.Text =
	"● SISTEMA ATIVO"

-- Scan único
task.spawn(function()

	InitialScan()

	UpdateList()

	print(
		"[FruitNotifier v3] Inicializado."
	)

end)
