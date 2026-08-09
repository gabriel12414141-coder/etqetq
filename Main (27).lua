--========================================================
-- FRUIT FINDER - VERSÃO REFEITA
-- Para o seu próprio jogo Roblox
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
-- FRUTAS
--========================================================

local Fruits = {
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
		"TRex"
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

local function normalize(text)

	text = tostring(text or ""):lower()

	text = text:gsub(
		"[^%w]",
		""
	)

	return text
end

--========================================================
-- BANCO NORMALIZADO
--========================================================

local FruitLookup = {}

for fruitName, names in pairs(Fruits) do

	FruitLookup[
		normalize(fruitName)
	] = fruitName

	for _, name in ipairs(names) do

		FruitLookup[
			normalize(name)
		] = fruitName
	end
end

--========================================================
-- IDENTIFICAR PELO TEXTO
--========================================================

local function identifyText(text)

	local normalized =
		normalize(text)

	if normalized == "" then
		return nil
	end

	-- Correspondência exata
	local exact =
		FruitLookup[normalized]

	if exact then
		return exact
	end

	-- Correspondência parcial
	for key, fruitName in pairs(FruitLookup) do

		if normalized:find(
			key,
			1,
			true
		) then

			return fruitName
		end
	end

	return nil
end

--========================================================
-- IDENTIFICAR ATRIBUTO
--========================================================

local function checkAttributes(object)

	for attributeName, value in pairs(
		object:GetAttributes()
	) do

		local key =
			normalize(attributeName)

		local valueResult =
			identifyText(value)

		if valueResult then

			if key == "fruit"
				or key == "fruitname"
				or key == "fruittype"
				or key == "fruitid"
				or key == "fruitnameid"
				or key == "name" then

				return valueResult
			end

		end
	end

	return nil
end

--========================================================
-- IDENTIFICAR MODELO
--========================================================

local function identifyFruit(model)

	-- Primeiro: atributos do próprio modelo
	local result =
		checkAttributes(model)

	if result then
		return result
	end

	-- Segundo: nome do próprio modelo
	result =
		identifyText(model.Name)

	if result then
		return result
	end

	-- Terceiro: filhos diretos
	for _, child in ipairs(
		model:GetChildren()
	) do

		result =
			checkAttributes(child)

		if result then
			return result
		end

		result =
			identifyText(child.Name)

		if result then
			return result
		end
	end

	-- Quarto: descendentes
	for _, descendant in ipairs(
		model:GetDescendants()
	) do

		result =
			checkAttributes(descendant)

		if result then
			return result
		end

		result =
			identifyText(descendant.Name)

		if result then
			return result
		end
	end

	return nil
end

--========================================================
-- FRUTAS ENCONTRADAS
--========================================================

local detected = {}

--========================================================
-- PARTE PRINCIPAL
--========================================================

local function getPart(model)

	if model:IsA("BasePart") then
		return model
	end

	if model:IsA("Model") then

		if model.PrimaryPart then
			return model.PrimaryPart
		end

		local handle =
			model:FindFirstChild(
				"Handle",
				true
			)

		if handle and handle:IsA("BasePart") then
			return handle
		end
	end

	return model:FindFirstChildWhichIsA(
		"BasePart",
		true
	)
end

--========================================================
-- TEXTO SOBRE A FRUTA
--========================================================

local function addDisplay(
	model,
	fruitName
)

	local part =
		getPart(model)

	if not part then
		return
	end

	local old =
		model:FindFirstChild(
			"FruitFinderDisplay"
		)

	if old then
		old:Destroy()
	end

	local billboard =
		Instance.new(
			"BillboardGui"
		)

	billboard.Name =
		"FruitFinderDisplay"

	billboard.Adornee =
		part

	billboard.Size =
		UDim2.fromOffset(
			200,
			45
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
		1500

	billboard.Parent =
		model

	local text =
		Instance.new(
			"TextLabel"
		)

	text.Size =
		UDim2.fromScale(
			1,
			1
		)

	text.BackgroundTransparency =
		1

	text.Text =
		"🍎 " .. fruitName

	text.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	text.TextStrokeColor3 =
		Color3.new(
			0,
			0,
			0
		)

	text.TextStrokeTransparency =
		0

	text.TextScaled =
		true

	text.Font =
		Enum.Font.GothamBold

	text.Parent =
		billboard
end

--========================================================
-- REGISTRAR
--========================================================

local function register(model)

	if not model:IsA("Model") then
		return
	end

	if detected[model] then
		return
	end

	local fruitName =
		identifyFruit(model)

	if not fruitName then
		return
	end

	detected[model] =
		fruitName

	addDisplay(
		model,
		fruitName
	)
end

--========================================================
-- REMOVER
--========================================================

local function remove(model)

	detected[model] =
		nil
end

--========================================================
-- PROCURAR WORKSPACE
--========================================================

task.spawn(function()

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		register(object)

		-- Evita travar durante a primeira busca
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
				register(object)
			end
		end)
	end
)

--========================================================
-- OBJETOS REMOVIDOS
--========================================================

workspace.DescendantRemoving:Connect(
	function(object)

		remove(object)
	end
)

--========================================================
-- GUI
--========================================================

local old =
	playerGui:FindFirstChild(
		"FruitFinder"
	)

if old then
	old:Destroy()
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
	playerGui

--========================================================
-- MAIN
--========================================================

local main =
	Instance.new(
		"Frame"
	)

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

local corner =
	Instance.new(
		"UICorner"
	)

corner.CornerRadius =
	UDim.new(
		0,
		10
	)

corner.Parent =
	main

--========================================================
-- HEADER
--========================================================

local header =
	Instance.new(
		"Frame"
	)

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
-- MINIMIZAR
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

layout.Parent =
	list

--========================================================
-- ARRASTAR
--========================================================

local dragging = false
local dragStart
local startPosition
local dragInput

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

		if input == dragInput then

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
	end
)

UserInputService.InputEnded:Connect(
	function(input)

		if input.UserInputType ==
			Enum.UserInputType.MouseButton1
			or input.UserInputType ==
			Enum.UserInputType.Touch then

			dragging = false
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

	for model, fruitName in pairs(
		detected
	) do

		if model
			and model.Parent
			and model:IsDescendantOf(workspace) then

			count += 1

			local item =
				Instance.new(
					"Frame"
				)

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

			local itemCorner =
				Instance.new(
					"UICorner"
				)

			itemCorner.CornerRadius =
				UDim.new(
					0,
					8
				)

			itemCorner.Parent =
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
				"🍎 " .. fruitName

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

			detected[model] =
				nil
		end
	end

	counter.Text =
		tostring(count)

	list.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 10
		)
end

--========================================================
-- LOOP DA INTERFACE
--========================================================

task.spawn(function()

	while gui.Parent do

		if not minimized then
			updateList()
		end

		task.wait(0.5)
	end
end)
