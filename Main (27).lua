--========================================================
-- FRUIT FINDER - TODAS AS FRUTAS
-- Para o seu próprio jogo Roblox
-- Coloque em ServerScriptService
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UPDATE_TIME = 0.5

--========================================================
-- BANCO DE FRUTAS
--========================================================

local FRUITS = {

	-- Comuns
	["Rocket Fruit"] = {"RocketFruit", "Rocket"},
	["Spin Fruit"] = {"SpinFruit", "Spin"},
	["Blade Fruit"] = {"BladeFruit", "Blade"},
	["Spring Fruit"] = {"SpringFruit", "Spring"},
	["Bomb Fruit"] = {"BombFruit", "Bomb"},
	["Smoke Fruit"] = {"SmokeFruit", "Smoke"},
	["Spike Fruit"] = {"SpikeFruit", "Spike"},

	-- Elementais
	["Flame Fruit"] = {"FlameFruit", "Flame"},
	["Ice Fruit"] = {"IceFruit", "Ice"},
	["Sand Fruit"] = {"SandFruit", "Sand"},
	["Dark Fruit"] = {"DarkFruit", "Dark"},
	["Light Fruit"] = {"LightFruit", "Light"},
	["Magma Fruit"] = {"MagmaFruit", "Magma"},

	-- Feras / outras
	["Falcon Fruit"] = {"FalconFruit", "Falcon"},
	["Diamond Fruit"] = {"DiamondFruit", "Diamond"},
	["Rubber Fruit"] = {"RubberFruit", "Rubber"},
	["Barrier Fruit"] = {"BarrierFruit", "Barrier"},
	["Ghost Fruit"] = {"GhostFruit", "Ghost"},

	-- Raras
	["Quake Fruit"] = {"QuakeFruit", "Quake"},
	["Buddha Fruit"] = {"BuddhaFruit", "Buddha"},
	["Love Fruit"] = {"LoveFruit", "Love"},
	["Spider Fruit"] = {"SpiderFruit", "Spider"},
	["Sound Fruit"] = {"SoundFruit", "Sound"},
	["Phoenix Fruit"] = {"PhoenixFruit", "Phoenix"},
	["Portal Fruit"] = {"PortalFruit", "Portal"},

	-- Lendárias
	["Rumble Fruit"] = {"RumbleFruit", "Rumble"},
	["Pain Fruit"] = {"PainFruit", "Pain"},
	["Blizzard Fruit"] = {"BlizzardFruit", "Blizzard"},
	["Gravity Fruit"] = {"GravityFruit", "Gravity"},
	["Mammoth Fruit"] = {"MammothFruit", "Mammoth"},
	["T-Rex Fruit"] = {
		"TRexFruit",
		"TrexFruit",
		"TRex",
		"T-Rex"
	},

	-- Míticas
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
-- NORMALIZAR TEXTO
--========================================================

local function normalize(text)

	text = tostring(text or "")
	text = text:lower()

	text = text:gsub(
		"[%s_%-%[%]%(%){}]",
		""
	)

	return text
end

--========================================================
-- IDENTIFICAR PELO NOME DO MODELO
--========================================================

local function identifyByName(fruit)

	local names = {}

	table.insert(
		names,
		fruit.Name
	)

	for _, object in ipairs(
		fruit:GetDescendants()
	) do

		table.insert(
			names,
			object.Name
		)
	end

	for displayName, aliases in pairs(
		FRUITS
	) do

		for _, objectName in ipairs(names) do

			local normalizedObject =
				normalize(objectName)

			for _, alias in ipairs(aliases) do

				local normalizedAlias =
					normalize(alias)

				if normalizedObject ==
					normalizedAlias then

					return displayName
				end
			end
		end
	end

	return nil
end

--========================================================
-- ATRIBUTOS
--========================================================

local function identifyByAttributes(fruit)

	local objects = {
		fruit
	}

	for _, object in ipairs(
		fruit:GetDescendants()
	) do

		table.insert(
			objects,
			object
		)
	end

	for _, object in ipairs(objects) do

		for key, value in pairs(
			object:GetAttributes()
		) do

			local keyText =
				normalize(key)

			local valueText =
				normalize(value)

			for displayName, aliases in pairs(
				FRUITS
			) do

				for _, alias in ipairs(aliases) do

					local normalizedAlias =
						normalize(alias)

					if keyText ==
						normalizedAlias
						or valueText ==
						normalizedAlias then

						return displayName
					end
				end
			end
		end
	end

	return nil
end

--========================================================
-- IDENTIFICAÇÃO FINAL
--========================================================

local function identifyFruit(fruit)

	-- 1. Nome do modelo/objetos
	local result =
		identifyByName(fruit)

	if result then
		return result
	end

	-- 2. Attributes
	result =
		identifyByAttributes(fruit)

	if result then
		return result
	end

	-- 3. Não inventar nome
	return "Fruit"
end

--========================================================
-- ENCONTRAR FRUTAS
--========================================================

local function getFruits()

	local fruits = {}

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		if object:IsA("Model")
			and object.Name == "Fruit" then

			table.insert(
				fruits,
				object
			)
		end
	end

	return fruits
end

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
		Instance.new("ScreenGui")

	gui.Name =
		"FruitFinder"

	gui.ResetOnSpawn = false

	gui.Parent =
		playerGui

	--====================================================
	-- PAINEL
	--====================================================

	local main =
		Instance.new("Frame")

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

	main.BorderSizePixel = 0

	main.Active = true

	main.Parent = gui

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(0,10)

	corner.Parent = main

	--====================================================
	-- HEADER
	--====================================================

	local header =
		Instance.new("Frame")

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

	header.BorderSizePixel = 0

	header.Active = true

	header.Parent = main

	local title =
		Instance.new("TextLabel")

	title.Size =
		UDim2.new(
			1,
			-90,
			1,
			0
		)

	title.Position =
		UDim2.fromOffset(
			12,
			0
		)

	title.BackgroundTransparency = 1

	title.Text =
		"🍎 FRUIT FINDER"

	title.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	title.TextSize = 18

	title.Font =
		Enum.Font.GothamBold

	title.TextXAlignment =
		Enum.TextXAlignment.Left

	title.Parent = header

	--====================================================
	-- CONTADOR
	--====================================================

	local counter =
		Instance.new("TextLabel")

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

	counter.BackgroundTransparency = 1

	counter.Text =
		"0"

	counter.TextColor3 =
		Color3.fromRGB(
			180,
			180,
			180
		)

	counter.TextSize = 14

	counter.Font =
		Enum.Font.GothamBold

	counter.Parent = header

	--====================================================
	-- MINIMIZAR
	--====================================================

	local minimize =
		Instance.new("TextButton")

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

	minimize.BackgroundTransparency = 1

	minimize.Text =
		"−"

	minimize.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	minimize.TextSize = 25

	minimize.Font =
		Enum.Font.GothamBold

	minimize.Parent = header

	--====================================================
	-- LISTA
	--====================================================

	local list =
		Instance.new("ScrollingFrame")

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

	list.BackgroundTransparency = 1

	list.BorderSizePixel = 0

	list.ScrollBarThickness = 4

	list.Parent = main

	local layout =
		Instance.new("UIListLayout")

	layout.Padding =
		UDim.new(
			0,
			6
		)

	layout.Parent = list

	--====================================================
	-- ARRASTAR
	--====================================================

	local dragging = false
	local dragStart
	local startPosition

	header.InputBegan:Connect(
		function(input)

			if input.UserInputType ==
				Enum.UserInputType.MouseButton1 then

				dragging = true

				dragStart =
					input.Position

				startPosition =
					main.Position
			end
		end
	)

	header.InputEnded:Connect(
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

			if input.UserInputType ==
				Enum.UserInputType.MouseMovement then

				local delta =
					input.Position
					- dragStart

				main.Position =
					UDim2.new(
						startPosition.X.Scale,
						startPosition.X.Offset
							+ delta.X,

						startPosition.Y.Scale,
						startPosition.Y.Offset
							+ delta.Y
					)
			end
		end
	)

	--====================================================
	-- MINIMIZAÇÃO
	--====================================================

	local minimized = false

	minimize.MouseButton1Click:Connect(
		function()

			minimized =
				not minimized

			if minimized then

				list.Visible = false

				main.Size =
					UDim2.fromOffset(
						360,
						55
					)

				minimize.Text =
					"+"

			else

				list.Visible = true

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
	-- ATUALIZAÇÃO
	--====================================================

	local function update()

		for _, child in ipairs(
			list:GetChildren()
		) do

			if child:IsA("Frame")
				or child:IsA("TextLabel") then

				child:Destroy()
			end
		end

		local fruits =
			getFruits()

		counter.Text =
			tostring(
				#fruits
			)

		if #fruits == 0 then

			local empty =
				Instance.new(
					"TextLabel"
				)

			empty.Size =
				UDim2.new(
					1,
					-10,
					0,
					40
				)

			empty.BackgroundTransparency = 1

			empty.Text =
				"Nenhuma fruta encontrada"

			empty.TextColor3 =
				Color3.fromRGB(
					160,
					160,
					160
				)

			empty.TextSize = 14

			empty.Font =
				Enum.Font.Gotham

			empty.Parent = list

		else

			for _, fruit in ipairs(
				fruits
			) do

				local item =
					Instance.new("Frame")

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

				item.BorderSizePixel = 0

				item.Parent = list

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

				local name =
					identifyFruit(
						fruit
					)

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

				label.BackgroundTransparency = 1

				label.Text =
					"🍎 " .. name

				label.TextColor3 =
					Color3.new(
						1,
						1,
						1
					)

				label.TextSize = 14

				label.Font =
					Enum.Font.GothamBold

				label.TextXAlignment =
					Enum.TextXAlignment.Left

				label.Parent =
					item
			end
		end

		list.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y
					+ 10
			)
	end

	task.spawn(
		function()

			while gui.Parent do

				if not minimized then
					update()
				end

				task.wait(
					UPDATE_TIME
				)
			end
		end
	)
end

--========================================================
-- PLAYERS
--========================================================

Players.PlayerAdded:Connect(
	function(player)

		task.spawn(
			function()
				createGui(player)
			end
		)
	end
)

for _, player in ipairs(
	Players:GetPlayers()
) do

	task.spawn(
		function()
			createGui(player)
		end
	)
end
