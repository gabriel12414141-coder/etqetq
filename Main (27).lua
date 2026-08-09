--========================================================
-- FRUIT FINDER PRO
-- Sistema para o seu próprio jogo Roblox
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local LOCAL_PLAYER = Players.LocalPlayer
local PLAYER_GUI = LOCAL_PLAYER:WaitForChild("PlayerGui")

local UPDATE_INTERVAL = 0.5
local BILLBOARD_DISTANCE = 1500

--========================================================
-- BANCO DE FRUTAS
--========================================================

local FRUITS = {
	["Rocket Fruit"] = {"RocketFruit", "Rocket"},
	["Spin Fruit"] = {"SpinFruit", "Spin"},
	["Blade Fruit"] = {"BladeFruit", "Blade"},
	["Spring Fruit"] = {"SpringFruit", "Spring"},
	["Bomb Fruit"] = {"BombFruit", "Bomb"},
	["Smoke Fruit"] = {"SmokeFruit", "Smoke"},
	["Spike Fruit"] = {"SpikeFruit", "Spike"},

	["Flame Fruit"] = {"FlameFruit", "Flame"},
	["Ice Fruit"] = {"IceFruit", "Ice"},
	["Sand Fruit"] = {"SandFruit", "Sand"},
	["Dark Fruit"] = {"DarkFruit", "Dark"},
	["Light Fruit"] = {"LightFruit", "Light"},
	["Magma Fruit"] = {"MagmaFruit", "Magma"},

	["Falcon Fruit"] = {"FalconFruit", "Falcon"},
	["Diamond Fruit"] = {"DiamondFruit", "Diamond"},
	["Rubber Fruit"] = {"RubberFruit", "Rubber"},
	["Barrier Fruit"] = {"BarrierFruit", "Barrier"},
	["Ghost Fruit"] = {"GhostFruit", "Ghost"},

	["Quake Fruit"] = {"QuakeFruit", "Quake"},
	["Buddha Fruit"] = {"BuddhaFruit", "Buddha"},
	["Love Fruit"] = {"LoveFruit", "Love"},
	["Spider Fruit"] = {"SpiderFruit", "Spider"},
	["Sound Fruit"] = {"SoundFruit", "Sound"},
	["Phoenix Fruit"] = {"PhoenixFruit", "Phoenix"},
	["Portal Fruit"] = {"PortalFruit", "Portal"},

	["Rumble Fruit"] = {"RumbleFruit", "Rumble"},
	["Pain Fruit"] = {"PainFruit", "Pain"},
	["Blizzard Fruit"] = {"BlizzardFruit", "Blizzard"},
	["Gravity Fruit"] = {"GravityFruit", "Gravity"},
	["Mammoth Fruit"] = {"MammothFruit", "Mammoth"},

	["T-Rex Fruit"] = {
		"TRexFruit",
		"TrexFruit",
		"TRex",
		"TRexModel"
	},

	["Dough Fruit"] = {"DoughFruit", "Dough"},
	["Shadow Fruit"] = {"ShadowFruit", "Shadow"},
	["Venom Fruit"] = {"VenomFruit", "Venom"},
	["Control Fruit"] = {"ControlFruit", "Control"},
	["Spirit Fruit"] = {"SpiritFruit", "Spirit"},
	["Gas Fruit"] = {"GasFruit", "Gas"},
	["Yeti Fruit"] = {"YetiFruit", "Yeti"},
	["Leopard Fruit"] = {"LeopardFruit", "Leopard"},
	["Kitsune Fruit"] = {"KitsuneFruit", "Kitsune"},
	["Dragon Fruit"] = {"DragonFruit", "Dragon"},
}

--========================================================
-- NORMALIZAÇÃO
--========================================================

local function normalize(value)
	value = tostring(value or ""):lower()

	return value:gsub(
		"[%s_%-%[%]%(%){}%.]",
		""
	)
end

--========================================================
-- ALIASES PRÉ-PROCESSADOS
--========================================================

local ALIAS_TO_FRUIT = {}

for fruitName, aliases in pairs(FRUITS) do
	for _, alias in ipairs(aliases) do
		ALIAS_TO_FRUIT[normalize(alias)] = fruitName
	end
end

--========================================================
-- IDENTIFICAÇÃO POR ATRIBUTO
--========================================================

local ATTRIBUTE_NAMES = {
	fruitname = true,
	fruit = true,
	fruittype = true,
	fruitnameid = true,
}

local function identifyFromAttributes(object)

	for key, value in pairs(object:GetAttributes()) do
		local normalizedKey = normalize(key)

		if ATTRIBUTE_NAMES[normalizedKey] then

			local normalizedValue =
				normalize(value)

			local result =
				ALIAS_TO_FRUIT[normalizedValue]

			if result then
				return result
			end
		end
	end

	return nil
end

--========================================================
-- IDENTIFICAÇÃO PELO NOME
--========================================================

local function identifyFromName(object)

	local direct =
		ALIAS_TO_FRUIT[
			normalize(object.Name)
		]

	if direct then
		return direct
	end

	return nil
end

--========================================================
-- IDENTIFICAÇÃO COMPLETA
--========================================================

local function identifyFruit(object)

	-- 1. Atributo no próprio modelo
	local result =
		identifyFromAttributes(object)

	if result then
		return result
	end

	-- 2. Nome do próprio modelo
	result =
		identifyFromName(object)

	if result then
		return result
	end

	-- 3. Procurar filhos
	for _, child in ipairs(
		object:GetChildren()
	) do

		result =
			identifyFromAttributes(child)

		if result then
			return result
		end

		result =
			identifyFromName(child)

		if result then
			return result
		end
	end

	return nil
end

--========================================================
-- PEGAR PARTE PRINCIPAL
--========================================================

local function getMainPart(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		local handle =
			object:FindFirstChild(
				"Handle",
				true
			)

		if handle and handle:IsA("BasePart") then
			return handle
		end
	end

	return object:FindFirstChildWhichIsA(
		"BasePart",
		true
	)
end

--========================================================
-- FRUTAS DETECTADAS
--========================================================

local detectedFruits = {}

--========================================================
-- CRIAR DISPLAY
--========================================================

local function createFruitDisplay(
	object,
	fruitName
)

	local part =
		getMainPart(object)

	if not part then
		return
	end

	local existing =
		object:FindFirstChild(
			"FruitNameDisplay"
		)

	if existing then
		existing:Destroy()
	end

	local billboard =
		Instance.new(
			"BillboardGui"
		)

	billboard.Name =
		"FruitNameDisplay"

	billboard.Adornee =
		part

	billboard.Size =
		UDim2.fromOffset(
			190,
			42
		)

	billboard.StudsOffset =
		Vector3.new(
			0,
			3,
			0
		)

	billboard.AlwaysOnTop =
		true

	billboard.MaxDistance =
		BILLBOARD_DISTANCE

	billboard.LightInfluence =
		0

	billboard.Parent =
		object

	local label =
		Instance.new(
			"TextLabel"
		)

	label.Name =
		"FruitName"

	label.Size =
		UDim2.fromScale(
			1,
			1
		)

	label.BackgroundTransparency =
		1

	label.Text =
		"🍎 " .. fruitName

	label.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	label.TextStrokeColor3 =
		Color3.new(
			0,
			0,
			0
		)

	label.TextStrokeTransparency =
		0.15

	label.TextScaled =
		true

	label.Font =
		Enum.Font.GothamBold

	label.Parent =
		billboard
end

--========================================================
-- REGISTRAR
--========================================================

local function registerFruit(object)

	if detectedFruits[object] then
		return
	end

	if not object:IsA("Model") then
		return
	end

	local fruitName =
		identifyFruit(object)

	if not fruitName then
		return
	end

	detectedFruits[object] =
		fruitName

	createFruitDisplay(
		object,
		fruitName
	)
end

--========================================================
-- REMOVER
--========================================================

local function unregisterFruit(object)

	detectedFruits[object] =
		nil
end

--========================================================
-- BUSCA INICIAL
--========================================================

task.spawn(function()

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		registerFruit(object)

		task.wait()
	end
end)

--========================================================
-- NOVOS OBJETOS
--========================================================

workspace.DescendantAdded:Connect(
	function(object)

		task.defer(function()

			if object.Parent then
				registerFruit(object)
			end
		end)
	end
)

--========================================================
-- OBJETOS REMOVIDOS
--========================================================

workspace.DescendantRemoving:Connect(
	function(object)

		unregisterFruit(object)
	end
)

--========================================================
-- GUI
--========================================================

local oldGui =
	PLAYER_GUI:FindFirstChild(
		"FruitFinder"
	)

if oldGui then
	oldGui:Destroy()
end

local gui =
	Instance.new(
		"ScreenGui"
	)

gui.Name =
	"FruitFinder"

gui.ResetOnSpawn =
	false

gui.Parent =
	PLAYER_GUI

--========================================================
-- PAINEL
--========================================================

local main =
	Instance.new(
		"Frame"
	)

main.Name =
	"Main"

main.Size =
	UDim2.fromOffset(
		360,
		410
	)

main.Position =
	UDim2.fromOffset(
		30,
		100
	)

main.BackgroundColor3 =
	Color3.fromRGB(
		24,
		24,
		24
	)

main.BorderSizePixel =
	0

main.Active =
	true

main.Parent =
	gui

local mainCorner =
	Instance.new(
		"UICorner"
	)

mainCorner.CornerRadius =
	UDim.new(
		0,
		10
	)

mainCorner.Parent =
	main

--========================================================
-- HEADER
--========================================================

local header =
	Instance.new(
		"Frame"
	)

header.Name =
	"Header"

header.Size =
	UDim2.new(
		1,
		0,
		0,
		55
	)

header.BackgroundColor3 =
	Color3.fromRGB(
		38,
		38,
		38
	)

header.BorderSizePixel =
	0

header.Active =
	true

header.Parent =
	main

--========================================================
-- TÍTULO
--========================================================

local title =
	Instance.new(
		"TextLabel"
	)

title.Size =
	UDim2.new(
		1,
		-100,
		1,
		0
	)

title.Position =
	UDim2.fromOffset(
		12,
		0
	)

title.BackgroundTransparency =
	1

title.Text =
	"🍎 FRUIT FINDER"

title.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

title.TextSize =
	18

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent =
	header

--========================================================
-- CONTADOR
--========================================================

local counter =
	Instance.new(
		"TextLabel"
	)

counter.Size =
	UDim2.fromOffset(
		35,
		55
	)

counter.Position =
	UDim2.new(
		1,
		-80,
		0,
		0
	)

counter.BackgroundTransparency =
	1

counter.Text =
	"0"

counter.TextColor3 =
	Color3.fromRGB(
		180,
		180,
		180
	)

counter.TextSize =
	14

counter.Font =
	Enum.Font.GothamBold

counter.Parent =
	header

--========================================================
-- BOTÃO MINIMIZAR
--========================================================

local minimize =
	Instance.new(
		"TextButton"
	)

minimize.Size =
	UDim2.fromOffset(
		40,
		40
	)

minimize.Position =
	UDim2.new(
		1,
		-45,
		0,
		7
	)

minimize.BackgroundTransparency =
	1

minimize.Text =
	"−"

minimize.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

minimize.TextSize =
	25

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent =
	header

--========================================================
-- LISTA
--========================================================

local list =
	Instance.new(
		"ScrollingFrame"
	)

list.Name =
	"FruitList"

list.Position =
	UDim2.fromOffset(
		10,
		65
	)

list.Size =
	UDim2.new(
		1,
		-20,
		1,
		-75
	)

list.BackgroundTransparency =
	1

list.BorderSizePixel =
	0

list.ScrollBarThickness =
	5

list.Parent =
	main

local layout =
	Instance.new(
		"UIListLayout"
	)

layout.Padding =
	UDim.new(
		0,
		6
	)

layout.SortOrder =
	Enum.SortOrder.Name

layout.Parent =
	list

--========================================================
-- ARRASTAR
--========================================================

local dragging = false
local dragStart
local startPosition
local dragInput

local function updateDrag(input)

	local delta =
		input.Position -
		dragStart

	main.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
end

header.InputBegan:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = true

			dragStart =
				input.Position

			startPosition =
				main.Position
		end
	end
)

header.InputChanged:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseMovement
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragInput =
				input
		end
	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if input == dragInput
			or input.UserInputType ==
			Enum.UserInputType.MouseMovement then

			updateDrag(input)
		end
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = false
			dragInput = nil
		end
	end
)

--========================================================
-- MINIMIZAR
--========================================================

local minimized = false

minimize.MouseButton1Click:Connect(
	function()

		minimized =
			not minimized

		if minimized then

			list.Visible =
				false

			main.Size =
				UDim2.fromOffset(
					360,
					55
				)

			minimize.Text =
				"+"

		else

			list.Visible =
				true

			main.Size =
				UDim2.fromOffset(
					360,
					410
				)

			minimize.Text =
				"−"
		end
	end
)

--========================================================
-- ATUALIZAR LISTA
--========================================================

local function updateList()

	for _, child in ipairs(
		list:GetChildren()
	) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local count = 0

	for object, fruitName in pairs(
		detectedFruits
	) do

		if object
			and object.Parent
			and object:IsDescendantOf(workspace) then

			count += 1

			local item =
				Instance.new(
					"Frame"
				)

			item.Name =
				fruitName

			item.Size =
				UDim2.new(
					1,
					-5,
					0,
					50
				)

			item.BackgroundColor3 =
				Color3.fromRGB(
					45,
					45,
					45
				)

			item.BorderSizePixel =
				0

			item.Parent =
				list

			local corner =
				Instance.new(
					"UICorner"
				)

			corner.CornerRadius =
				UDim.new(
					0,
					8
				)

			corner.Parent =
				item

			local label =
				Instance.new(
					"TextLabel"
				)

			label.Size =
				UDim2.new(
					1,
					-20,
					1,
					0
				)

			label.Position =
				UDim2.fromOffset(
					10,
					0
				)

			label.BackgroundTransparency =
				1

			label.Text =
				"🍎 " ..
				fruitName

			label.TextColor3 =
				Color3.new(
					1,
					1,
					1
				)

			label.TextSize =
				14

			label.Font =
				Enum.Font.GothamBold

			label.TextXAlignment =
				Enum.TextXAlignment.Left

			label.Parent =
				item

		else

			detectedFruits[object] =
				nil
		end
	end

	counter.Text =
		tostring(count)

	list.CanvasSize =
		UDim2.fromOffset(
			0,
			layout.AbsoluteContentSize.Y + 10
		)
end

--========================================================
-- LOOP DO PAINEL
--========================================================

task.spawn(function()

	while gui.Parent do

		if not minimized then
			updateList()
		end

		task.wait(
			UPDATE_INTERVAL
		)
	end
end)
