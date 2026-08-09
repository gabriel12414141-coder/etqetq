--========================================================
-- FRUIT FINDER - WORKSPACE INTEIRO
-- Para o seu próprio jogo Roblox
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local UPDATE_TIME = 0.5

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
-- IDENTIFICAR POR NOME
--========================================================

local function identifyByName(object)

	local names = {}

	table.insert(
		names,
		object.Name
	)

	for _, descendant in ipairs(
		object:GetDescendants()
	) do

		table.insert(
			names,
			descendant.Name
		)
	end

	for displayName, aliases in pairs(FRUITS) do

		for _, objectName in ipairs(names) do

			local normalizedObject =
				normalize(objectName)

			for _, alias in ipairs(aliases) do

				if normalizedObject ==
					normalize(alias) then

					return displayName
				end
			end
		end
	end

	return nil
end

--========================================================
-- IDENTIFICAR POR ATRIBUTOS
--========================================================

local function identifyByAttributes(object)

	local objects = {
		object
	}

	for _, descendant in ipairs(
		object:GetDescendants()
	) do

		table.insert(
			objects,
			descendant
		)
	end

	for _, current in ipairs(objects) do

		for key, value in pairs(
			current:GetAttributes()
		) do

			local keyText =
				normalize(key)

			local valueText =
				normalize(value)

			-- Atributos comuns do sistema
			if keyText == "fruitname"
				or keyText == "fruit"
				or keyText == "name" then

				for displayName, aliases in pairs(FRUITS) do

					for _, alias in ipairs(aliases) do

						if valueText ==
							normalize(alias) then

							return displayName
						end
					end
				end
			end

			for displayName, aliases in pairs(FRUITS) do

				for _, alias in ipairs(aliases) do

					local aliasText =
						normalize(alias)

					if valueText ==
						aliasText then

						return displayName
					end
				end
			end
		end
	end

	return nil
end

--========================================================
-- IDENTIFICAR FRUTA
--========================================================

local function identifyFruit(object)

	-- Primeiro procura atributos
	local result =
		identifyByAttributes(object)

	if result then
		return result
	end

	-- Depois procura nomes
	result =
		identifyByName(object)

	if result then
		return result
	end

	return nil
end

--========================================================
-- ENCONTRAR PARTE PRINCIPAL
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
-- DISPLAY SOBRE A FRUTA
--========================================================

local function createFruitDisplay(
	fruit,
	fruitName
)

	local part =
		getFruitPart(fruit)

	if not part then
		return
	end

	local old =
		fruit:FindFirstChild(
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
		1000

	billboard.LightInfluence =
		0

	billboard.Parent =
		fruit

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
-- PROCURAR WORKSPACE INTEIRO
--========================================================

local function getDroppedFruits()

	local fruits = {}
	local alreadyFound = {}

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		if object:IsA("Model") then

			local fruitName =
				identifyFruit(object)

			if fruitName then

				-- Evita pegar o mesmo modelo
				-- várias vezes
				if not alreadyFound[object] then

					alreadyFound[object] = true

					table.insert(
						fruits,
						{
							Object = object,
							Name = fruitName
						}
					)
				end
			end
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
	-- ATUALIZAR
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
			getDroppedFruits()

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

			empty.BackgroundTransparency =
				1

			empty.Text =
				"Nenhuma fruta encontrada"

			empty.TextColor3 =
				Color3.fromRGB(
					160,
					160,
					160
				)

			empty.TextSize =
				14

			empty.Font =
				Enum.Font.Gotham

			empty.Parent =
				list

		else

			for _, data in ipairs(fruits) do

				local fruit =
					data.Object

				local fruitName =
					data.Name

				createFruitDisplay(
					fruit,
					fruitName
				)

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
			end
		end

		list.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y + 10
			)
	end

	--====================================================
	-- LOOP
	--====================================================

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
-- JOGADORES
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
