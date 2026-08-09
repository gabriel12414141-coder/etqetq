--========================================================
-- FRUIT FINDER OTIMIZADO (v2)
-- Detecta frutas no Workspace sem varrer tudo a cada 0.5s
-- Para o seu próprio jogo Roblox
--
-- O que mudou em relação à v1:
--  - Varredura inicial em LOTES (a v1 dava task.wait(0.05) por
--    objeto, o que em mapas grandes podia levar minutos)
--  - Lista mostra distância e ordena do mais perto pro mais longe
--  - Painel atualiza de forma incremental (não destrói e recria
--    tudo a cada 0.5s, evita engasgos)
--  - Limite de itens exibidos (as mais próximas), pra não virar
--    bagunça visual com muitas frutas espalhadas
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local MAX_DISTANCE = 1000       -- distância máxima de renderização do billboard 3D
local SCAN_BATCH_SIZE = 500     -- quantos objetos processar antes de liberar um frame
local UPDATE_INTERVAL = 0.5     -- intervalo de atualização do painel
local MAX_ITEMS_LISTA = 40      -- limite de itens mostrados na lista (as mais próximas)

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
	return text:gsub("[%s_%-%[%]%(%){}]", "")
end

--========================================================
-- TABELA DE ALIASES PRÉ-NORMALIZADA
--========================================================

local ALIASES = {}

for fruitName, aliases in pairs(FRUITS) do
	for _, alias in ipairs(aliases) do
		ALIASES[normalize(alias)] = fruitName
	end
end

--========================================================
-- CHAVES DE ATRIBUTO ACEITAS (pré-normalizadas)
--========================================================

local ATTRIBUTE_KEYS = {
	fruitname = true,
	fruit = true,
	fruittype = true,
}

local function findFruitInAttributes(instance)
	for key, value in pairs(instance:GetAttributes()) do
		if ATTRIBUTE_KEYS[normalize(key)] then
			local resultado = ALIASES[normalize(value)]
			if resultado then
				return resultado
			end
		end
	end
	return nil
end

--========================================================
-- IDENTIFICAÇÃO RÁPIDA
--========================================================

local function identifyFruit(object)

	-- Nome do próprio objeto
	local direto = ALIASES[normalize(object.Name)]
	if direto then
		return direto
	end

	-- Atributos do próprio objeto
	local porAtributo = findFruitInAttributes(object)
	if porAtributo then
		return porAtributo
	end

	-- Procurar descendentes (nome ou atributo)
	for _, child in ipairs(object:GetDescendants()) do
		local porNomeFilho = ALIASES[normalize(child.Name)]
		if porNomeFilho then
			return porNomeFilho
		end

		local porAtributoFilho = findFruitInAttributes(child)
		if porAtributoFilho then
			return porAtributoFilho
		end
	end

	return nil
end

--========================================================
-- FRUTAS DETECTADAS
--========================================================

local detectedFruits = {} -- [object] = fruitName

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

		local handle = object:FindFirstChild("Handle", true)
		if handle and handle:IsA("BasePart") then
			return handle
		end
	end

	return object:FindFirstChildWhichIsA("BasePart", true)
end

--========================================================
-- DISTÂNCIA ATÉ UM PERSONAGEM
--========================================================

local function getDistance(object, hrp)
	if not hrp then
		return nil
	end

	local part = getFruitPart(object)
	if not part then
		return nil
	end

	return (part.Position - hrp.Position).Magnitude
end

--========================================================
-- CRIAR TEXTO SOBRE A FRUTA
--========================================================

local function createDisplay(object, fruitName)
	local part = getFruitPart(object)
	if not part then
		return
	end

	local old = object:FindFirstChild("FruitNameDisplay")
	if old then
		old:Destroy()
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "FruitNameDisplay"
	billboard.Adornee = part
	billboard.Size = UDim2.fromOffset(180, 40)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = MAX_DISTANCE
	billboard.LightInfluence = 0
	billboard.Parent = object

	local label = Instance.new("TextLabel")
	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = "🍎 " .. fruitName
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextStrokeTransparency = 0.2
	label.TextScaled = true
	label.Font = Enum.Font.GothamBold
	label.Parent = billboard
end

--========================================================
-- REGISTRAR / REMOVER FRUTA
--========================================================

local function registerFruit(object)
	if detectedFruits[object] then
		return
	end

	if not object:IsA("Model") then
		return
	end

	local fruitName = identifyFruit(object)
	if not fruitName then
		return
	end

	detectedFruits[object] = fruitName
	createDisplay(object, fruitName)
end

local function unregisterFruit(object)
	detectedFruits[object] = nil
end

--========================================================
-- VARREDURA INICIAL (em lotes, não trava o servidor)
--========================================================

task.spawn(function()
	local descendants = workspace:GetDescendants()
	local processados = 0

	for _, object in ipairs(descendants) do
		registerFruit(object)

		processados += 1
		if processados >= SCAN_BATCH_SIZE then
			processados = 0
			task.wait() -- libera um frame a cada lote, não a cada objeto
		end
	end
end)

--========================================================
-- DETECTAR FRUTA NOVA / REMOVIDA
--========================================================

workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		registerFruit(object)
	end)
end)

workspace.DescendantRemoving:Connect(function(object)
	unregisterFruit(object)
end)

--========================================================
-- GUI
--========================================================

local function createGui(player)
	local playerGui = player:WaitForChild("PlayerGui")

	local old = playerGui:FindFirstChild("FruitFinder")
	if old then
		old:Destroy()
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = "FruitFinder"
	gui.ResetOnSpawn = false
	gui.Parent = playerGui

	--====================================================
	-- PAINEL
	--====================================================

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(360, 410)
	main.Position = UDim2.fromOffset(30, 100)
	main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	main.BorderSizePixel = 0
	main.Active = true
	main.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = main

	--====================================================
	-- CABEÇALHO
	--====================================================

	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 55)
	header.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
	header.BorderSizePixel = 0
	header.Active = true
	header.Parent = main

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -100, 1, 0)
	title.Position = UDim2.fromOffset(12, 0)
	title.BackgroundTransparency = 1
	title.Text = "🍎 FRUIT FINDER"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 18
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	--====================================================
	-- CONTADOR
	--====================================================

	local counter = Instance.new("TextLabel")
	counter.Size = UDim2.fromOffset(35, 55)
	counter.Position = UDim2.new(1, -80, 0, 0)
	counter.BackgroundTransparency = 1
	counter.Text = "0"
	counter.TextColor3 = Color3.fromRGB(180, 180, 180)
	counter.TextSize = 14
	counter.Font = Enum.Font.GothamBold
	counter.Parent = header

	--====================================================
	-- MINIMIZAR
	--====================================================

	local minimize = Instance.new("TextButton")
	minimize.Size = UDim2.fromOffset(40, 40)
	minimize.Position = UDim2.new(1, -45, 0, 7)
	minimize.BackgroundTransparency = 1
	minimize.Text = "−"
	minimize.TextColor3 = Color3.new(1, 1, 1)
	minimize.TextSize = 25
	minimize.Font = Enum.Font.GothamBold
	minimize.Parent = header

	--====================================================
	-- LISTA
	--====================================================

	local list = Instance.new("ScrollingFrame")
	list.Position = UDim2.fromOffset(10, 65)
	list.Size = UDim2.new(1, -20, 1, -75)
	list.BackgroundTransparency = 1
	list.BorderSizePixel = 0
	list.ScrollBarThickness = 4
	list.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 6)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = list

	--====================================================
	-- ARRASTAR
	--====================================================

	local dragging = false
	local dragStart
	local startPosition
	local dragInput

	local function updateDrag(input)
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPosition.X.Scale, startPosition.X.Offset + delta.X,
			startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
		)
	end

	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = main.Position
		end
	end)

	header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.MouseMovement) then
			updateDrag(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			dragInput = nil
		end
	end)

	--====================================================
	-- MINIMIZAR
	--====================================================

	local minimized = false

	minimize.MouseButton1Click:Connect(function()
		minimized = not minimized

		if minimized then
			list.Visible = false
			main.Size = UDim2.fromOffset(360, 55)
			minimize.Text = "+"
		else
			list.Visible = true
			main.Size = UDim2.fromOffset(360, 410)
			minimize.Text = "−"
		end
	end)

	--====================================================
	-- ATUALIZAR PAINEL (incremental, com distância e ordenação)
	--====================================================

	local itemFrames = {} -- [object] = {frame = Frame, label = TextLabel}

	local function updatePanel()
		local personagem = player.Character
		local hrp = personagem and personagem:FindFirstChild("HumanoidRootPart")

		-- Monta lista válida com distância, removendo entradas mortas
		local ordenado = {}
		for object, fruitName in pairs(detectedFruits) do
			if object and object.Parent and object:IsDescendantOf(workspace) then
				table.insert(ordenado, {
					object = object,
					fruitName = fruitName,
					distancia = getDistance(object, hrp),
				})
			else
				detectedFruits[object] = nil
			end
		end

		table.sort(ordenado, function(a, b)
			if a.distancia and b.distancia then
				return a.distancia < b.distancia
			end
			return a.distancia ~= nil -- entradas sem distância vão pro final
		end)

		local visiveis = {}

		for indice, entrada in ipairs(ordenado) do
			if indice > MAX_ITEMS_LISTA then
				break
			end

			visiveis[entrada.object] = true
			local dados = itemFrames[entrada.object]

			if not dados then
				local item = Instance.new("Frame")
				item.Size = UDim2.new(1, -5, 0, 50)
				item.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
				item.BorderSizePixel = 0
				item.Parent = list

				local itemCorner = Instance.new("UICorner")
				itemCorner.CornerRadius = UDim.new(0, 8)
				itemCorner.Parent = item

				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, -20, 1, 0)
				label.Position = UDim2.fromOffset(10, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Color3.new(1, 1, 1)
				label.TextSize = 14
				label.Font = Enum.Font.GothamBold
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = item

				dados = {frame = item, label = label}
				itemFrames[entrada.object] = dados
			end

			dados.frame.LayoutOrder = indice

			if entrada.distancia then
				dados.label.Text = string.format("🍎 %s (%dm)", entrada.fruitName, math.floor(entrada.distancia))
			else
				dados.label.Text = "🍎 " .. entrada.fruitName
			end
		end

		-- Remove da UI quem saiu do top N ou deixou de existir
		for object, dados in pairs(itemFrames) do
			if not visiveis[object] then
				dados.frame:Destroy()
				itemFrames[object] = nil
			end
		end

		local total = 0
		for _ in pairs(detectedFruits) do
			total += 1
		end
		counter.Text = tostring(total)

		list.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end

	task.spawn(function()
		while gui.Parent do
			if not minimized then
				updatePanel()
			end
			task.wait(UPDATE_INTERVAL)
		end
	end)
end

--========================================================
-- PLAYERS
--========================================================

Players.PlayerAdded:Connect(function(player)
	task.spawn(function()
		createGui(player)
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	task.spawn(function()
		createGui(player)
	end)
end
