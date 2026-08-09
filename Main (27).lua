--============================================================
-- FRUIT NOTIFIER CLIENT v5
-- ONE LOCAL SCRIPT
--============================================================
-- Coloque em:
-- StarterPlayer
--   > StarterPlayerScripts
--      > FruitNotifierClient
--
-- Recursos:
-- • GUI imediato
-- • Detecção client-side
-- • Lista de frutas
-- • Nome acima da fruta
-- • Distância em metros
-- • Marcador 3D
-- • Notificação de spawn
-- • Ordenação por distância
-- • Minimizar
-- • Arrastar
-- • Limpar
-- • Ativar/desativar marcadores
-- • Cache
-- • Sem GetDescendants() em loop
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Workspace = workspace

--============================================================
-- CONFIGURAÇÃO
--============================================================

local MAX_DISTANCE = 2500

-- Roblox normalmente usa studs.
-- Se no seu jogo 1 stud = 1 metro, mantenha 1.
local STUDS_TO_METERS = 1

-- Atualização da distância
local DISTANCE_UPDATE = 0.20

-- Atualização visual da lista
local LIST_UPDATE = 0.40

-- Tempo para tentar identificar novamente um objeto
-- depois que ele foi criado.
local RETRY_DELAY = 0.15

-- Quantidade máxima de tentativas
local RETRIES = 3

--============================================================
-- FRUTAS
--============================================================

local VALID_FRUITS = {

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

local Character = nil
local RootPart = nil

local MarkersEnabled = true
local Minimized = false

local ListDirty = true

local Destroyed = false

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

		SetupCharacter(
			Player.Character
		)

	end)
end

Player.CharacterAdded:Connect(
	SetupCharacter
)

--============================================================
-- GUI
--============================================================

local OldGui =
	PlayerGui:FindFirstChild(
		"FruitNotifierClient"
	)

if OldGui then
	OldGui:Destroy()
end

local ScreenGui =
	Instance.new("ScreenGui")

ScreenGui.Name =
	"FruitNotifierClient"

ScreenGui.ResetOnSpawn = false

ScreenGui.IgnoreGuiInset = true

ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

ScreenGui.DisplayOrder = 100

ScreenGui.Parent =
	PlayerGui

--============================================================
-- GUI HELPERS
--============================================================

local function AddCorner(object, radius)

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(0, radius)

	corner.Parent =
		object

	return corner
end

local function AddStroke(object)

	local stroke =
		Instance.new("UIStroke")

	stroke.Thickness = 1

	stroke.Transparency = 0.45

	stroke.Parent =
		object

	return stroke
end

--============================================================
-- MAIN
--============================================================

local Main =
	Instance.new("Frame")

Main.Name =
	"Main"

Main.Size =
	UDim2.new(
		0,
		350,
		0,
		460
	)

Main.Position =
	UDim2.new(
		0,
		25,
		0.5,
		-230
	)

Main.BackgroundColor3 =
	Color3.fromRGB(
		15,
		15,
		21
	)

Main.BackgroundTransparency =
	0.04

Main.Parent =
	ScreenGui

AddCorner(
	Main,
	12
)

AddStroke(
	Main
)

--============================================================
-- HEADER
--============================================================

local Header =
	Instance.new("Frame")

Header.Name =
	"Header"

Header.Size =
	UDim2.new(
		1,
		0,
		0,
		70
	)

Header.BackgroundTransparency =
	1

Header.Parent =
	Main

local Title =
	Instance.new("TextLabel")

Title.Size =
	UDim2.new(
		1,
		-65,
		0,
		32
	)

Title.Position =
	UDim2.new(
		0,
		16,
		0,
		6
	)

Title.BackgroundTransparency =
	1

Title.Text =
	"🍎  FRUIT NOTIFIER"

Title.TextSize =
	20

Title.Font =
	Enum.Font.GothamBold

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent =
	Header

local Status =
	Instance.new("TextLabel")

Status.Size =
	UDim2.new(
		1,
		-65,
		0,
		20
	)

Status.Position =
	UDim2.new(
		0,
		17,
		0,
		40
	)

Status.BackgroundTransparency =
	1

Status.Text =
	"● SISTEMA ATIVO"

Status.TextSize =
	11

Status.Font =
	Enum.Font.GothamMedium

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent =
	Header

local MinimizeButton =
	Instance.new("TextButton")

MinimizeButton.Name =
	"Minimize"

MinimizeButton.Size =
	UDim2.new(
		0,
		40,
		0,
		40
	)

MinimizeButton.Position =
	UDim2.new(
		1,
		-50,
		0,
		14
	)

MinimizeButton.BackgroundColor3 =
	Color3.fromRGB(
		34,
		34,
		44
	)

MinimizeButton.Text =
	"—"

MinimizeButton.TextSize =
	20

MinimizeButton.Font =
	Enum.Font.GothamBold

MinimizeButton.Parent =
	Header

AddCorner(
	MinimizeButton,
	8
)

--============================================================
-- COUNTER
--============================================================

local Counter =
	Instance.new("TextLabel")

Counter.Size =
	UDim2.new(
		1,
		-30,
		0,
		25
	)

Counter.Position =
	UDim2.new(
		0,
		15,
		0,
		75
	)

Counter.BackgroundTransparency =
	1

Counter.Text =
	"Frutas encontradas: 0"

Counter.TextSize =
	14

Counter.Font =
	Enum.Font.GothamMedium

Counter.TextXAlignment =
	Enum.TextXAlignment.Left

Counter.Parent =
	Main

--============================================================
-- LISTA
--============================================================

local List =
	Instance.new("ScrollingFrame")

List.Name =
	"FruitList"

List.Size =
	UDim2.new(
		1,
		-20,
		0,
		275
	)

List.Position =
	UDim2.new(
		0,
		10,
		0,
		105
	)

List.BackgroundColor3 =
	Color3.fromRGB(
		8,
		8,
		12
	)

List.BackgroundTransparency =
	0.08

List.BorderSizePixel =
	0

List.ScrollBarThickness =
	5

List.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)

List.Parent =
	Main

AddCorner(
	List,
	9
)

local Layout =
	Instance.new("UIListLayout")

Layout.Padding =
	UDim.new(
		0,
		5
	)

Layout.SortOrder =
	Enum.SortOrder.LayoutOrder

Layout.Parent =
	List

local ListPadding =
	Instance.new("UIPadding")

ListPadding.PaddingTop =
	UDim.new(
		0,
		7
	)

ListPadding.PaddingBottom =
	UDim.new(
		0,
		7
	)

ListPadding.PaddingLeft =
	UDim.new(
		0,
		7
	)

ListPadding.PaddingRight =
	UDim.new(
		0,
		7
	)

ListPadding.Parent =
	List

--============================================================
-- BOTÃO MARCADORES
--============================================================

local MarkerButton =
	Instance.new("TextButton")

MarkerButton.Name =
	"MarkerButton"

MarkerButton.Size =
	UDim2.new(
		0.48,
		-5,
		0,
		42
	)

MarkerButton.Position =
	UDim2.new(
		0,
		10,
		1,
		-52
	)

MarkerButton.BackgroundColor3 =
	Color3.fromRGB(
		35,
		35,
		45
	)

MarkerButton.Text =
	"👁 MARCADORES: ON"

MarkerButton.TextSize =
	12

MarkerButton.Font =
	Enum.Font.GothamBold

MarkerButton.Parent =
	Main

AddCorner(
	MarkerButton,
	8
)

--============================================================
-- BOTÃO LIMPAR
--============================================================

local ClearButton =
	Instance.new("TextButton")

ClearButton.Name =
	"ClearButton"

ClearButton.Size =
	UDim2.new(
		0.48,
		-5,
		0,
		42
	)

ClearButton.Position =
	UDim2.new(
		0.52,
		-5,
		1,
		-52
	)

ClearButton.BackgroundColor3 =
	Color3.fromRGB(
		35,
		35,
		45
	)

ClearButton.Text =
	"🗑 LIMPAR"

ClearButton.TextSize =
	12

ClearButton.Font =
	Enum.Font.GothamBold

ClearButton.Parent =
	Main

AddCorner(
	ClearButton,
	8
)

--============================================================
-- NORMALIZAÇÃO
--============================================================

local function CleanString(value)

	if typeof(value) ~= "string" then
		return nil
	end

	value =
		value:gsub("%s+", " ")

	value =
		value:match(
			"^%s*(.-)%s*$"
		)

	return value
end

local function IdentifyExactFruitName(name)

	name =
		CleanString(name)

	if not name then
		return nil
	end

	-- Ex:
	-- Dragon
	-- Dragon Fruit

	if VALID_FRUITS[name] then
		return name
	end

	local base =
		name:match(
			"^(.-)%s+Fruit$"
		)

	if base then

		base =
			CleanString(base)

		if VALID_FRUITS[base] then
			return base
		end
	end

	return nil
end

--============================================================
-- ATRIBUTOS
--============================================================

local function IdentifyFromAttributes(object)

	local attributeNames = {

		"FruitName",

		"Fruit",

		"FruitType",

		"Fruit_Name",

		"ItemName",

	}

	for _, attributeName in ipairs(
		attributeNames
	) do

		local value =
			object:GetAttribute(
				attributeName
			)

		if typeof(value) == "string" then

			local fruit =
				IdentifyExactFruitName(
					value
				)

			if fruit then
				return fruit
			end
		end
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

	--========================================================
	-- 1. Nome do próprio objeto
	--========================================================

	local fruit =
		IdentifyExactFruitName(
			object.Name
		)

	if fruit then
		return fruit
	end

	--========================================================
	-- 2. Atributos
	--========================================================

	fruit =
		IdentifyFromAttributes(
			object
		)

	if fruit then
		return fruit
	end

	--========================================================
	-- 3. Pais próximos
	--========================================================

	local parent =
		object.Parent

	for _ = 1, 5 do

		if not parent then
			break
		end

		fruit =
			IdentifyExactFruitName(
				parent.Name
			)

		if fruit then
			return fruit
		end

		fruit =
			IdentifyFromAttributes(
				parent
			)

		if fruit then
			return fruit
		end

		parent =
			parent.Parent
	end

	return nil
end

--============================================================
-- PEÇA DA FRUTA
--============================================================

local function GetFruitPart(object)

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

		local handle =
			object:FindFirstChild(
				"Handle"
			)

		if handle
			and handle:IsA("BasePart") then

			return handle
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
			object:FindFirstChild(
				"Handle"
			)

		if handle
			and handle:IsA("BasePart") then

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
		return math.huge
	end

	local part =
		GetFruitPart(object)

	if not part then
		return math.huge
	end

	local distance =
		(
			RootPart.Position -
			part.Position
		).Magnitude

	return distance *
		STUDS_TO_METERS
end

--============================================================
-- MARCADOR
--============================================================

local function CreateMarker(
	object,
	fruitName
)

	if not MarkersEnabled then
		return
	end

	if Markers[object] then
		return
	end

	local part =
		GetFruitPart(object)

	if not part then
		return
	end

	local Billboard =
		Instance.new(
			"BillboardGui"
		)

	Billboard.Name =
		"FruitNotifierMarker"

	Billboard.Adornee =
		part

	Billboard.Size =
		UDim2.new(
			0,
			230,
			0,
			68
		)

	Billboard.StudsOffset =
		Vector3.new(
			0,
			5,
			0
		)

	Billboard.AlwaysOnTop =
		true

	Billboard.MaxDistance =
		MAX_DISTANCE

	Billboard.Parent =
		part

	--========================================================
	-- NOME
	--========================================================

	local NameLabel =
		Instance.new(
			"TextLabel"
		)

	NameLabel.Size =
		UDim2.new(
			1,
			0,
			0,
			34
		)

	NameLabel.BackgroundTransparency =
		1

	NameLabel.Text =
		fruitName .. " Fruit"

	NameLabel.TextSize =
		18

	NameLabel.Font =
		Enum.Font.GothamBold

	NameLabel.TextStrokeTransparency =
		0

	NameLabel.Parent =
		Billboard

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel =
		Instance.new(
			"TextLabel"
		)

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
			34
		)

	DistanceLabel.BackgroundTransparency =
		1

	DistanceLabel.Text =
		"0 m"

	DistanceLabel.TextSize =
		14

	DistanceLabel.Font =
		Enum.Font.GothamMedium

	DistanceLabel.TextStrokeTransparency =
		0

	DistanceLabel.Parent =
		Billboard

	Markers[object] = {

		Gui = Billboard,

		Distance = DistanceLabel,

	}

	return Billboard
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

		pcall(
			function()
				marker.Gui:Destroy()
			end
		)

	end

	Markers[object] =
		nil
end

--============================================================
-- NOTIFICAÇÃO NATIVA
--============================================================

local function Notify(
	fruitName,
	distance
)

	pcall(
		function()

			StarterGui:SetCore(
				"SendNotification",
				{

					Title =
						"🍎 FRUTA SPAWNADA",

					Text =
						fruitName ..
						" Fruit • " ..
						math.floor(
							distance
						) ..
						" m",

					Duration = 5,

				}
			)

		end
	)
end

--============================================================
-- REGISTRAR
--============================================================

local function RegisterFruit(
	object,
	fruitName,
	showNotification
)

	if not object then
		return
	end

	if Fruits[object] then
		return
	end

	local part =
		GetFruitPart(object)

	if not part then
		return
	end

	local distance =
		GetDistance(object)

	if distance >
		MAX_DISTANCE then

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

	if showNotification then

		Notify(
			fruitName,
			distance
		)

	end

	ListDirty =
		true
end

--============================================================
-- REMOVER
--============================================================

local function RemoveFruit(object)

	if not Fruits[object] then
		return
	end

	Fruits[object] =
		nil

	RemoveMarker(
		object
	)

	ListDirty =
		true
end

--============================================================
-- ANALISAR OBJETO
--============================================================

local function CheckObject(
	object,
	showNotification
)

	if not object then
		return
	end

	if not object.Parent then
		return
	end

	if Fruits[object] then
		return
	end

	local fruit =
		IdentifyFruit(
			object
		)

	if not fruit then
		return
	end

	RegisterFruit(
		object,
		fruit,
		showNotification
	)
end

--============================================================
-- NOVO OBJETO
--============================================================

local function ProcessNewObject(
	object
)

	if not object then
		return
	end

	-- Primeira tentativa
	CheckObject(
		object,
		true
	)

	-- Algumas estruturas são montadas
	-- depois que o objeto entra.
	for attempt = 1, RETRIES do

		task.delay(
			RETRY_DELAY * attempt,
			function()

				if Destroyed then
					return
				end

				if not object then
					return
				end

				if not object.Parent then
					return
				end

				CheckObject(
					object,
					true
				)

			end
		)
	end
end

--============================================================
-- SCAN INICIAL
--============================================================

task.spawn(
	function()

		-- Apenas uma vez.
		-- Não existe loop de GetDescendants.

		for _, object in ipairs(
			Workspace:GetDescendants()
		) do

			if Destroyed then
				break
			end

			CheckObject(
				object,
				false
			)

		end

		ListDirty =
			true

		Status.Text =
			"● MONITORAMENTO ATIVO"

	end
)

--============================================================
-- OBJETOS NOVOS
--============================================================

Workspace.DescendantAdded:Connect(
	function(object)

		if Destroyed then
			return
		end

		ProcessNewObject(
			object
		)

	end
)

--============================================================
-- OBJETOS REMOVIDOS
--============================================================

Workspace.DescendantRemoving:Connect(
	function(object)

		if Fruits[object] then

			RemoveFruit(
				object
			)

		end

		if Markers[object] then

			RemoveMarker(
				object
			)

		end

	end
)

--============================================================
-- ATUALIZA DISTÂNCIAS
--============================================================

task.spawn(
	function()

		while not Destroyed do

			for object, data in pairs(
				Fruits
			) do

				if not object
					or not object.Parent then

					RemoveFruit(
						object
					)

					continue
				end

				local distance =
					GetDistance(
						object
					)

				data.Distance =
					distance

				local marker =
					Markers[object]

				if marker
					and marker.Distance then

					marker.Distance.Text =
						string.format(
							"%d m",
							math.floor(
								distance
							)
						)

				end

				if distance >
					MAX_DISTANCE then

					RemoveFruit(
						object
					)

				end

			end

			task.wait(
				DISTANCE_UPDATE
			)

		end

	end
)

--============================================================
-- ATUALIZA LISTA
--============================================================

local function UpdateList()

	if not ListDirty then
		return
	end

	ListDirty =
		false

	-- Remove somente os itens antigos.
	for _, child in ipairs(
		List:GetChildren()
	) do

		if child:IsA("Frame") then
			child:Destroy()
		end

	end

	local array = {}

	for _, data in pairs(
		Fruits
	) do

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

	for index, data in ipairs(
		array
	) do

		local Item =
			Instance.new(
				"Frame"
			)

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

		Item.Parent =
			List

		AddCorner(
			Item,
			7
		)

		--====================================================
		-- NOME
		--====================================================

		local Name =
			Instance.new(
				"TextLabel"
			)

		Name.Size =
			UDim2.new(
				1,
				-105,
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

		Name.BackgroundTransparency =
			1

		Name.Text =
			"🍎  " ..
			data.Name ..
			" Fruit"

		Name.TextSize =
			13

		Name.Font =
			Enum.Font.GothamBold

		Name.TextXAlignment =
			Enum.TextXAlignment.Left

		Name.Parent =
			Item

		--====================================================
		-- DISTÂNCIA
		--====================================================

		local Distance =
			Instance.new(
				"TextLabel"
			)

		Distance.Size =
			UDim2.new(
				0,
				90,
				1,
				0
			)

		Distance.Position =
			UDim2.new(
				1,
				-95,
				0,
				0
			)

		Distance.BackgroundTransparency =
			1

		Distance.Text =
			string.format(
				"%d m",
				math.floor(
					data.Distance
				)
			)

		Distance.TextSize =
			13

		Distance.Font =
			Enum.Font.GothamBold

		Distance.TextXAlignment =
			Enum.TextXAlignment.Right

		Distance.Parent =
			Item

	end

	Counter.Text =
		"Frutas encontradas: "
		.. tostring(
			#array
		)

	task.defer(
		function()

			List.CanvasSize =
				UDim2.new(
					0,
					0,
					0,
					Layout.AbsoluteContentSize.Y
					+ 15
				)

		end
	)

end

task.spawn(
	function()

		while not Destroyed do

			UpdateList()

			task.wait(
				LIST_UPDATE
			)

		end

	end
)

--============================================================
-- MARCADORES ON/OFF
--============================================================

MarkerButton.MouseButton1Click:Connect(
	function()

		MarkersEnabled =
			not MarkersEnabled

		if MarkersEnabled then

			MarkerButton.Text =
				"👁 MARCADORES: ON"

			for object, data in pairs(
				Fruits
			) do

				CreateMarker(
					object,
					data.Name
				)

			end

		else

			MarkerButton.Text =
				"👁 MARCADORES: OFF"

			for object in pairs(
				Markers
			) do

				RemoveMarker(
					object
				)

			end

		end

	end
)

--============================================================
-- LIMPAR
--============================================================

ClearButton.MouseButton1Click:Connect(
	function()

		for object in pairs(
			Fruits
		) do

			RemoveMarker(
				object
			)

		end

		table.clear(
			Fruits
		)

		ListDirty =
			true

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
					350,
					0,
					70
				)

			Counter.Visible =
				false

			List.Visible =
				false

			MarkerButton.Visible =
				false

			ClearButton.Visible =
				false

			MinimizeButton.Text =
				"+"

		else

			Main.Size =
				UDim2.new(
					0,
					350,
					0,
					460
				)

			Counter.Visible =
				true

			List.Visible =
				true

			MarkerButton.Visible =
				true

			ClearButton.Visible =
				true

			MinimizeButton.Text =
				"—"

		end

	end
)

--============================================================
-- ARRASTAR GUI
--============================================================

local Dragging = false

local DragStart = nil

local StartPosition = nil

Header.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1 then

			Dragging =
				true

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

			Dragging =
				false

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

		local Delta =
			input.Position -
			DragStart

		Main.Position =
			UDim2.new(

				StartPosition.X.Scale,

				StartPosition.X.Offset
					+ Delta.X,

				StartPosition.Y.Scale,

				StartPosition.Y.Offset
					+ Delta.Y

			)

	end
)

--============================================================
-- FINALIZAÇÃO
--============================================================

ScreenGui.Destroying:Connect(
	function()

		Destroyed =
			true

	end
)

print(
	"[FruitNotifier] Client v5 iniciado."
)
