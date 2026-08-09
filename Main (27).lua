--========================================================
-- FRUIT FINDER OTIMIZADO
-- Detecta frutas no Workspace sem varrer tudo a cada 0.5s
-- Para o seu próprio jogo Roblox
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local MAX_DISTANCE = 1000
local SCAN_DELAY = 0.05

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

local function normalize(text)

	text = tostring(text or ""):lower()

	return text:gsub(
		"[%s_%-%[%]%(%){}]",
		""
	)
end

--========================================================
-- TABELA DE ALIASES PRÉ-NORMALIZADA
-- Evita ficar normalizando toda hora
--========================================================

local ALIASES = {}

for fruitName, aliases in pairs(FRUITS) do

	for _, alias in ipairs(aliases) do

		ALIASES[normalize(alias)] =
			fruitName
	end
end

--========================================================
-- IDENTIFICAÇÃO RÁPIDA
--========================================================

local function identifyFruit(object)

	----------------------------------------------
	-- Nome do próprio objeto
	----------------------------------------------

	local direct =
		ALIASES[
			normalize(object.Name)
		]

	if direct then
		return direct
	end

	----------------------------------------------
	-- Atributos do objeto
	----------------------------------------------

	for key, value in pairs(
		object:GetAttributes()
	) do

		local keyNormalized =
			normalize(key)

		local valueNormalized =
			normalize(value)

		if keyNormalized == "fruitname"
			or keyNormalized == "fruit"
			or keyNormalized == "fruittype" then

			local result =
				ALIASES[valueNormalized]

			if result then
				return result
			end
		end
	end

	----------------------------------------------
	-- Procurar descendentes
	----------------------------------------------

	for _, child in ipairs(
		object:GetDescendants()
	) do

		local result =
			ALIASES[
				normalize(child.Name)
			]

		if result then
			return result
		end

		for key, value in pairs(
			child:GetAttributes()
		) do

			local keyNormalized =
				normalize(key)

			local valueNormalized =
				normalize(value)

			if keyNormalized == "fruitname"
				or keyNormalized == "fruit"
				or keyNormalized == "fruittype" then

				local attributeResult =
					ALIASES[valueNormalized]

				if attributeResult then
					return attributeResult
				end
			end
		end
	end

	return nil
end

--========================================================
-- FRUTAS DETECTADAS
--========================================================

local detectedFruits = {}

--========================================================
-- ENCONTRAR PARTE DA FRUTA
--========================================================

local function getFruitPart(object)

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
-- CRIAR TEXTO SOBRE A FRUTA
--========================================================

local function createDisplay(object, fruitName)

	local part =
		getFruitPart(object)

	if not part then
		return
	end

	local old =
		object:FindFirstChild(
			"FruitNameDisplay"
		)

	if old then
		old:Destroy()
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
			180,
			40
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
		MAX_DISTANCE

	billboard.LightInfluence =
		0

	billboard.Parent =
		object

	local label =
		Instance.new(
			"TextLabel"
		)

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
		0.2

	label.TextScaled =
		true

	label.Font =
		Enum.Font.GothamBold

	label.Parent =
		billboard
end

--========================================================
-- REGISTRAR FRUTA
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

	detectedFruits[object] = fruitName

	createDisplay(
		object,
		fruitName
	)

end

--========================================================
-- REMOVER FRUTA
--========================================================

local function unregisterFruit(object)

	if detectedFruits[object] then
		detectedFruits[object] = nil
	end
end

--========================================================
-- VARREDURA INICIAL
-- Executada somente uma vez
--========================================================

task.spawn(function()

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		registerFruit(object)

		-- Pequena pausa para não congelar
		-- durante um mapa extremamente grande

		task.wait(SCAN_DELAY)
	end

end)

--========================================================
-- DETECTAR FRUTA NOVA
--========================================================

workspace.DescendantAdded:Connect(
	function(object)

		-- Espera a estrutura da fruta terminar
		task.defer(function()

			registerFruit(object)

		end)
	end
)

--========================================================
-- DETECTAR FRUTA REMOVIDA
--========================================================

workspace.DescendantRemoving:Connect(
	function(object)

		unregisterFruit(object)

	end
)

--========================================================
-- GUI
--========================================================

local function createGui(player)

	local playerGui =
		player:WaitForChild(
			"PlayerGui"
		)

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

	--====================================================
	-- PAINEL
	--====================================================

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

	--====================================================
	-- CABEÇALHO
	--====================================================

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

	--====================================================
	-- CONTADOR
	--====================================================

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

	--====================================================
	-- MINIMIZAR
	--====================================================

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

	--====================================================
	-- LISTA
	--====================================================

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
		4

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
		Enum.SortOrder.LayoutOrder

	layout.Parent =
		list

	--====================================================
	-- ARRASTAR
	--====================================================

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

			if dragging and
				(
					input == dragInput
					or input.UserInputType ==
					Enum.UserInputType.MouseMovement
				) then

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

	--====================================================
	-- MINIMIZAR
	--====================================================

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

	--====================================================
	-- ATUALIZAR PAINEL
	-- Não varre o Workspace aqui
	--====================================================

	local function updatePanel()

		for _, child in ipairs(
			list:GetChildren()
		) do

			if child:IsA("Frame")
				or child:IsA("TextLabel") then

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
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y + 10
			)
	end

	--====================================================
	-- ATUALIZAÇÃO DO PAINEL
	--====================================================

	task.spawn(function()

		while gui.Parent do

			if not minimized then
				updatePanel()
			end

			task.wait(0.5)
		end
	end)
end

--========================================================
-- PLAYERS
--========================================================

Players.PlayerAdded:Connect(
	function(player)

		task.spawn(function()
			createGui(player)
		end)
	end
)

for _, player in ipairs(
	Players:GetPlayers()
) do

	task.spawn(function()
		createGui(player)
	end)
end
