--============================================================
-- FRUIT NOTIFIER REWORK v4
-- PERFORMANCE + DETECÇÃO ROBUSTA
--
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--
-- Recursos:
-- • Nome acima da fruta
-- • Distância em metros
-- • Lista lateral
-- • Detecção incremental
-- • Cache
-- • Sem GetDescendants em loop
-- • Não recria a lista a cada frame
-- • Detecta Model / Tool / BasePart
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local MAX_DISTANCE = 2500

local DISTANCE_UPDATE = 0.20
local LIST_UPDATE = 0.50

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

local Fruits = {}
local Markers = {}

local Character
local RootPart

local MarkersEnabled = true
local Minimized = false

local ListDirty = true

--============================================================
-- CHARACTER
--============================================================

local function SetupCharacter(character)

	Character = character

	RootPart = character:WaitForChild(
		"HumanoidRootPart",
		10
	)
end

if Player.Character then
	task.spawn(function()
		SetupCharacter(Player.Character)
	end)
end

Player.CharacterAdded:Connect(SetupCharacter)

--============================================================
-- GUI
--============================================================

local old = PlayerGui:FindFirstChild(
	"FruitNotifierRework"
)

if old then
	old:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FruitNotifierRework"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = PlayerGui

--============================================================
-- GUI HELPERS
--============================================================

local function Corner(object, radius)

	local c = Instance.new("UICorner")

	c.CornerRadius =
		UDim.new(0, radius)

	c.Parent = object

	return c
end

local function Stroke(object)

	local s = Instance.new("UIStroke")

	s.Thickness = 1
	s.Transparency = 0.5

	s.Parent = object

	return s
end

--============================================================
-- MAIN
--============================================================

local Main = Instance.new("Frame")

Main.Size =
	UDim2.new(0, 320, 0, 420)

Main.Position =
	UDim2.new(0, 25, 0.5, -210)

Main.BackgroundColor3 =
	Color3.fromRGB(17, 17, 23)

Main.BackgroundTransparency = 0.08

Main.Parent = ScreenGui

Corner(Main, 12)
Stroke(Main)

--============================================================
-- HEADER
--============================================================

local Header = Instance.new("Frame")

Header.Size =
	UDim2.new(1, 0, 0, 65)

Header.BackgroundTransparency = 1

Header.Parent = Main

local Title = Instance.new("TextLabel")

Title.Size =
	UDim2.new(1, -60, 0, 32)

Title.Position =
	UDim2.new(0, 15, 0, 5)

Title.BackgroundTransparency = 1

Title.Text =
	"🍎  FRUIT NOTIFIER"

Title.TextSize = 19

Title.Font =
	Enum.Font.GothamBold

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent = Header

local Status = Instance.new("TextLabel")

Status.Size =
	UDim2.new(1, -60, 0, 20)

Status.Position =
	UDim2.new(0, 16, 0, 37)

Status.BackgroundTransparency = 1

Status.Text =
	"● SISTEMA ATIVO"

Status.TextSize = 12

Status.Font =
	Enum.Font.GothamMedium

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent = Header

local Minimize = Instance.new("TextButton")

Minimize.Size =
	UDim2.new(0, 38, 0, 38)

Minimize.Position =
	UDim2.new(1, -48, 0, 12)

Minimize.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

Minimize.Text = "—"

Minimize.TextSize = 21

Minimize.Font =
	Enum.Font.GothamBold

Minimize.Parent = Header

Corner(Minimize, 8)

--============================================================
-- COUNTER
--============================================================

local Counter = Instance.new("TextLabel")

Counter.Size =
	UDim2.new(1, -30, 0, 25)

Counter.Position =
	UDim2.new(0, 15, 0, 70)

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

List.Size =
	UDim2.new(1, -20, 0, 250)

List.Position =
	UDim2.new(0, 10, 0, 100)

List.BackgroundColor3 =
	Color3.fromRGB(10, 10, 15)

List.BackgroundTransparency = 0.1

List.BorderSizePixel = 0

List.ScrollBarThickness = 4

List.CanvasSize =
	UDim2.new(0, 0, 0, 0)

List.Parent = Main

Corner(List, 9)

local Layout = Instance.new("UIListLayout")

Layout.Padding =
	UDim.new(0, 5)

Layout.SortOrder =
	Enum.SortOrder.LayoutOrder

Layout.Parent = List

local Padding = Instance.new("UIPadding")

Padding.PaddingTop =
	UDim.new(0, 7)

Padding.PaddingBottom =
	UDim.new(0, 7)

Padding.PaddingLeft =
	UDim.new(0, 7)

Padding.PaddingRight =
	UDim.new(0, 7)

Padding.Parent = List

--============================================================
-- BOTÕES
--============================================================

local MarkerButton = Instance.new("TextButton")

MarkerButton.Size =
	UDim2.new(0.48, -5, 0, 42)

MarkerButton.Position =
	UDim2.new(0, 10, 1, -52)

MarkerButton.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

MarkerButton.Text =
	"👁 MARCADORES: ON"

MarkerButton.TextSize = 12

MarkerButton.Font =
	Enum.Font.GothamBold

MarkerButton.Parent = Main

Corner(MarkerButton, 8)

local ClearButton = Instance.new("TextButton")

ClearButton.Size =
	UDim2.new(0.48, -5, 0, 42)

ClearButton.Position =
	UDim2.new(0.52, -5, 1, -52)

ClearButton.BackgroundColor3 =
	Color3.fromRGB(35, 35, 45)

ClearButton.Text =
	"🗑 LIMPAR"

ClearButton.TextSize = 12

ClearButton.Font =
	Enum.Font.GothamBold

ClearButton.Parent = Main

Corner(ClearButton, 8)

--============================================================
-- NORMALIZAR
--============================================================

local function NormalizeName(name)

	if typeof(name) ~= "string" then
		return nil
	end

	name = name:gsub("%s+", " ")

	name = name:match("^%s*(.-)%s*$")

	local base =
		name:match("^(.-)%s+Fruit$")

	if not base then
		return nil
	end

	base =
		base:match("^%s*(.-)%s*$")

	if ValidFruits[base] then
		return base
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

	-- Nome
	local result =
		NormalizeName(object.Name)

	if result then
		return result
	end

	-- Atributos
	local attributeNames = {
		"FruitName",
		"Fruit",
	}

	for _, attributeName in ipairs(
		attributeNames
	) do

		local value =
			object:GetAttribute(
				attributeName
			)

		if typeof(value) == "string" then

			result =
				NormalizeName(value)

			if result then
				return result
			end
		end
	end

	-- Pais
	local parent = object.Parent

	for i = 1, 4 do

		if not parent then
			break
		end

		result =
			NormalizeName(
				parent.Name
			)

		if result then
			return result
		end

		parent = parent.Parent
	end

	return nil
end

--============================================================
-- PEÇA PRINCIPAL
--============================================================

local function GetPart(object)

	if not object then
		return nil
	end

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		local part =
			object:FindFirstChildWhichIsA(
				"BasePart",
				true
			)

		if part then
			return part
		end
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
-- DISTÂNCIA
--============================================================

local function GetDistance(object)

	if not RootPart then
		return nil
	end

	local part =
		GetPart(object)

	if not part then
		return nil
	end

	return (
		RootPart.Position -
		part.Position
	).Magnitude * STUD_TO_METER
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
		GetPart(object)

	if not part then
		return
	end

	local gui =
		Instance.new("BillboardGui")

	gui.Name =
		"FruitNotifierMarker"

	gui.Adornee =
		part

	gui.Size =
		UDim2.new(
			0,
			210,
			0,
			65
		)

	gui.StudsOffset =
		Vector3.new(0, 5, 0)

	gui.AlwaysOnTop = true

	gui.MaxDistance =
		MAX_DISTANCE

	gui.Parent = part

	local nameLabel =
		Instance.new("TextLabel")

	nameLabel.Size =
		UDim2.new(1, 0, 0, 32)

	nameLabel.BackgroundTransparency = 1

	nameLabel.Text =
		fruitName .. " Fruit"

	nameLabel.TextSize = 18

	nameLabel.Font =
		Enum.Font.GothamBold

	nameLabel.TextStrokeTransparency = 0

	nameLabel.Parent = gui

	local distanceLabel =
		Instance.new("TextLabel")

	distanceLabel.Size =
		UDim2.new(1, 0, 0, 25)

	distanceLabel.Position =
		UDim2.new(0, 0, 0, 31)

	distanceLabel.BackgroundTransparency = 1

	distanceLabel.Text =
		"0 m"

	distanceLabel.TextSize = 14

	distanceLabel.Font =
		Enum.Font.GothamMedium

	distanceLabel.TextStrokeTransparency = 0

	distanceLabel.Parent = gui

	Markers[object] = {
		Gui = gui,
		Distance = distanceLabel,
	}
end

--============================================================
-- REMOVE MARCADOR
--============================================================

local function RemoveMarker(object)

	local data =
		Markers[object]

	if not data then
		return
	end

	if data.Gui then
		data.Gui:Destroy()
	end

	Markers[object] = nil
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

	if distance > MAX_DISTANCE then
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
-- DETECTAR
--============================================================

local function DetectObject(object)

	if not object then
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
-- DETECÇÃO INICIAL
--============================================================

local function InitialScan()

	-- Apenas uma vez.
	-- Depois disso usamos DescendantAdded.

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		DetectObject(object)

	end
end

--============================================================
-- NOVOS OBJETOS
--============================================================

workspace.DescendantAdded:Connect(
	function(object)

		-- Não fazemos outro scan.
		-- Apenas analisamos o objeto que entrou.

		task.defer(function()

			if object and object.Parent then

				DetectObject(object)

				-- Algumas frutas são montadas
				-- em vários objetos. Espera um
				-- pouco e tenta novamente.

				task.delay(
					0.15,
					function()

						if object
							and object.Parent then

							DetectObject(object)

						end
					end
				)

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
-- ATUALIZAR DISTÂNCIAS
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

		data.Distance =
			distance

		local marker =
			Markers[object]

		if marker then

			marker.Distance.Text =
				string.format(
					"%d m",
					math.floor(distance)
				)
		end

		if distance > MAX_DISTANCE then

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
-- ATUALIZAR LISTA
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
		table.insert(array, data)
	end

	table.sort(
		array,
		function(a, b)
			return a.Distance <
				b.Distance
		end
	)

	for index, data in ipairs(array) do

		local item =
			Instance.new("Frame")

		item.Size =
			UDim2.new(1, 0, 0, 48)

		item.BackgroundColor3 =
			Color3.fromRGB(
				27,
				27,
				36
			)

		item.LayoutOrder =
			index

		item.Parent = List

		Corner(item, 7)

		local name =
			Instance.new("TextLabel")

		name.Size =
			UDim2.new(
				1,
				-100,
				1,
				0
			)

		name.Position =
			UDim2.new(
				0,
				10,
				0,
				0
			)

		name.BackgroundTransparency = 1

		name.Text =
			data.Name .. " Fruit"

		name.TextSize = 13

		name.Font =
			Enum.Font.GothamBold

		name.TextXAlignment =
			Enum.TextXAlignment.Left

		name.Parent = item

		local distance =
			Instance.new("TextLabel")

		distance.Size =
			UDim2.new(
				0,
				85,
				1,
				0
			)

		distance.Position =
			UDim2.new(
				1,
				-90,
				0,
				0
			)

		distance.BackgroundTransparency = 1

		distance.Text =
			string.format(
				"%d m",
				math.floor(
					data.Distance
				)
			)

		distance.TextSize = 13

		distance.Font =
			Enum.Font.GothamBold

		distance.TextXAlignment =
			Enum.TextXAlignment.Right

		distance.Parent = item
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

			for object, data in pairs(Fruits) do

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

Minimize.MouseButton1Click:Connect(
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

			Minimize.Text = "+"

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

			Minimize.Text = "—"
		end
	end
)

--============================================================
-- ARRASTAR
--============================================================

local dragging = false
local dragStart
local startPosition

Header.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			dragging = true

			dragStart =
				input.Position

			startPosition =
				Main.Position
		end
	end
)

Header.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			dragging = false
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if input.UserInputType ~=
			Enum.UserInputType.MouseMovement then

			return
		end

		local delta =
			input.Position -
			dragStart

		Main.Position =
			UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,

				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
	end
)

--============================================================
-- LOOP LEVE
--============================================================

task.spawn(function()

	while ScreenGui.Parent do

		UpdateDistances()

		task.wait(
			DISTANCE_UPDATE
		)
	end
end)

task.spawn(function()

	while ScreenGui.Parent do

		UpdateList()

		task.wait(
			LIST_UPDATE
		)
	end
end)

--============================================================
-- INICIALIZA
--============================================================

Status.Text =
	"● SISTEMA ATIVO"

task.spawn(function()

	InitialScan()

	ListDirty = true

	UpdateList()

	print(
		"[FruitNotifier v4] Inicializado"
	)

end)
