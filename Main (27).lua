--============================================================
-- 🍈 FRUIT NOTIFIER
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

-- Se as frutas estiverem em uma pasta específica:
-- local WATCH_FOLDER_NAME = "Fruits"
--
-- Para procurar no Workspace inteiro:
local WATCH_FOLDER_NAME = nil

-- Mostrar texto em cima das frutas?
local SHOW_FRUIT_LABELS = true

-- Distância máxima dos textos
local LABEL_MAX_DISTANCE = 1000

-- Tempo da notificação
local NOTIFICATION_TIME = 3.2

--============================================================
-- RARIDADES
--============================================================

local RarityColors = {
	Common = Color3.fromRGB(180, 180, 180),
	Uncommon = Color3.fromRGB(85, 200, 120),
	Rare = Color3.fromRGB(70, 140, 230),
	Legendary = Color3.fromRGB(190, 90, 230),
	Mythical = Color3.fromRGB(240, 190, 60),
}

local HIGH_RARITIES = {
	Legendary = true,
	Mythical = true,
}

--============================================================
-- FRUTAS
--============================================================

local Fruits = {

	-- COMMON
	Spin = {
		Rarity = "Common"
	},

	Spring = {
		Rarity = "Common"
	},

	Smoke = {
		Rarity = "Common"
	},

	Sand = {
		Rarity = "Common",
		Color = Color3.fromRGB(210, 190, 140)
	},

	Spike = {
		Rarity = "Common"
	},

	Blade = {
		Rarity = "Common"
	},

	Gas = {
		Rarity = "Common"
	},

	-- UNCOMMON
	Rocket = {
		Rarity = "Uncommon"
	},

	Bomb = {
		Rarity = "Uncommon"
	},

	Ice = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(140, 220, 240)
	},

	Eagle = {
		Rarity = "Uncommon"
	},

	Spider = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(150, 60, 60)
	},

	Sound = {
		Rarity = "Uncommon"
	},

	Venom = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(120, 60, 160)
	},

	Tiger = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(240, 150, 40)
	},

	-- RARE
	Flame = {
		Rarity = "Rare",
		Color = Color3.fromRGB(255, 100, 40)
	},

	Dark = {
		Rarity = "Rare",
		Color = Color3.fromRGB(60, 40, 80)
	},

	Light = {
		Rarity = "Rare",
		Color = Color3.fromRGB(255, 250, 200)
	},

	Diamond = {
		Rarity = "Rare",
		Color = Color3.fromRGB(180, 230, 250)
	},

	Ghost = {
		Rarity = "Rare",
		Color = Color3.fromRGB(200, 220, 220)
	},

	Yeti = {
		Rarity = "Rare",
		Color = Color3.fromRGB(210, 230, 240)
	},

	Blizzard = {
		Rarity = "Rare",
		Color = Color3.fromRGB(190, 225, 250)
	},

	Gravity = {
		Rarity = "Rare",
		Color = Color3.fromRGB(90, 90, 130)
	},

	-- LEGENDARY
	Magma = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(230, 80, 30)
	},

	Quake = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(150, 110, 60)
	},

	Buddha = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(240, 210, 120)
	},

	Love = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(250, 120, 170)
	},

	Creation = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(120, 220, 180)
	},

	Portal = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(140, 80, 220)
	},

	Lightning = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(250, 240, 90)
	},

	Pain = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(120, 30, 30)
	},

	Rubber = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(220, 60, 60)
	},

	Mammoth = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(160, 140, 110)
	},

	["T-Rex"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(90, 140, 70)
	},

	Dough = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(240, 220, 190)
	},

	Shadow = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(50, 50, 60)
	},

	Kitsune = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(240, 140, 60)
	},

	Control = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(80, 160, 200)
	},

	-- MYTHICAL
	Phoenix = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 140, 30)
	},

	Spirit = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(180, 240, 230)
	},

	Dragon = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(80, 200, 120)
	},
}

--============================================================
-- FUNÇÕES AUXILIARES
--============================================================

local function getColor(name, data)
	return data.Color
		or RarityColors[data.Rarity]
		or Color3.new(1, 1, 1)
end

local function isFruitInstance(instance)
	if not instance then
		return false
	end

	return instance:IsA("Tool")
		or instance:IsA("Model")
		or instance:IsA("BasePart")
end

--============================================================
-- GUI PRINCIPAL
--============================================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitNotificationGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

--============================================================
-- PAINEL
--============================================================

local container = Instance.new("Frame")
container.Name = "NotificationContainer"
container.AnchorPoint = Vector2.new(0.5, 0)
container.Position = UDim2.new(0.5, 0, 0, -130)
container.Size = UDim2.new(0, 440, 0, 105)
container.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
container.BackgroundTransparency = 0.05
container.BorderSizePixel = 0
container.Parent = screenGui

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 16)
containerCorner.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Thickness = 2
containerStroke.Transparency = 0.35
containerStroke.Color = Color3.fromRGB(255, 255, 255)
containerStroke.Parent = container

--============================================================
-- BARRA COLORIDA
--============================================================

local accentBar = Instance.new("Frame")
accentBar.Name = "AccentBar"
accentBar.Size = UDim2.new(0, 7, 1, 0)
accentBar.Position = UDim2.new(0, 0, 0, 0)
accentBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
accentBar.BorderSizePixel = 0
accentBar.Parent = container

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 16)
accentCorner.Parent = accentBar

--============================================================
-- ÍCONE
--============================================================

local fruitIcon = Instance.new("TextLabel")
fruitIcon.Name = "FruitIcon"
fruitIcon.BackgroundTransparency = 1
fruitIcon.Position = UDim2.new(0, 20, 0, 18)
fruitIcon.Size = UDim2.new(0, 50, 0, 50)
fruitIcon.Font = Enum.Font.GothamBold
fruitIcon.Text = "🍈"
fruitIcon.TextSize = 35
fruitIcon.Parent = container

--============================================================
-- TÍTULO
--============================================================

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 78, 0, 12)
titleLabel.Size = UDim2.new(1, -90, 0, 22)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
titleLabel.Text = "UMA FRUTA APARECEU!"
titleLabel.Parent = container

--============================================================
-- NOME DA FRUTA
--============================================================

local fruitNameLabel = Instance.new("TextLabel")
fruitNameLabel.Name = "FruitNameLabel"
fruitNameLabel.BackgroundTransparency = 1
fruitNameLabel.Position = UDim2.new(0, 78, 0, 34)
fruitNameLabel.Size = UDim2.new(1, -90, 0, 28)
fruitNameLabel.Font = Enum.Font.GothamBlack
fruitNameLabel.TextSize = 23
fruitNameLabel.TextXAlignment = Enum.TextXAlignment.Left
fruitNameLabel.Text = "Fruta"
fruitNameLabel.Parent = container

--============================================================
-- RARIDADE
--============================================================

local rarityLabel = Instance.new("TextLabel")
rarityLabel.Name = "RarityLabel"
rarityLabel.BackgroundTransparency = 1
rarityLabel.Position = UDim2.new(0, 78, 0, 65)
rarityLabel.Size = UDim2.new(1, -90, 0, 20)
rarityLabel.Font = Enum.Font.GothamMedium
rarityLabel.TextSize = 14
rarityLabel.TextXAlignment = Enum.TextXAlignment.Left
rarityLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
rarityLabel.Text = "Raridade"
rarityLabel.Parent = container

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.AnchorPoint = Vector2.new(1, 0)
minimizeButton.Position = UDim2.new(1, -10, 0, 8)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
minimizeButton.BackgroundTransparency = 0.1
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Text = "−"
minimizeButton.TextSize = 20
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = container

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeButton

--============================================================
-- BOTÃO LABELS
--============================================================

local labelToggle = Instance.new("TextButton")
labelToggle.Name = "LabelToggle"
labelToggle.AnchorPoint = Vector2.new(1, 0)
labelToggle.Position = UDim2.new(1, -48, 0, 8)
labelToggle.Size = UDim2.new(0, 30, 0, 30)
labelToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
labelToggle.BorderSizePixel = 0
labelToggle.Font = Enum.Font.GothamBold
labelToggle.Text = "👁"
labelToggle.TextSize = 16
labelToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
labelToggle.Parent = container

local labelCorner = Instance.new("UICorner")
labelCorner.CornerRadius = UDim.new(0, 8)
labelCorner.Parent = labelToggle

--============================================================
-- SONS
--============================================================

local notifySound = Instance.new("Sound")
notifySound.Name = "NormalSound"
notifySound.SoundId = "rbxassetid://9125715582"
notifySound.Volume = 0.6
notifySound.Parent = container

local rareSound = Instance.new("Sound")
rareSound.Name = "RareSound"
rareSound.SoundId = "rbxassetid://9046192778"
rareSound.Volume = 0.8
rareSound.Parent = container

--============================================================
-- MINIMIZAR / RESTAURAR
--============================================================

local minimized = false

local normalSize = UDim2.new(0, 440, 0, 105)
local minimizedSize = UDim2.new(0, 160, 0, 42)

minimizeButton.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		minimizeButton.Text = "+"

		TweenService:Create(
			container,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size = minimizedSize
			}
		):Play()

		for _, object in ipairs(container:GetChildren()) do

			if object ~= minimizeButton
				and object ~= containerCorner
				and object ~= containerStroke
				and object ~= accentBar
				and object ~= accentCorner then

				if object:IsA("TextLabel") then
					TweenService:Create(
						object,
						TweenInfo.new(0.15),
						{
							TextTransparency = 1
						}
					):Play()
				end
			end
		end

	else

		minimizeButton.Text = "−"

		TweenService:Create(
			container,
			TweenInfo.new(
				0.25,
				Enum.EasingStyle.Quad,
				Enum.EasingDirection.Out
			),
			{
				Size = normalSize
			}
		):Play()

		task.delay(0.15, function()

			for _, object in ipairs(container:GetChildren()) do

				if object:IsA("TextLabel") then

					TweenService:Create(
						object,
						TweenInfo.new(0.15),
						{
							TextTransparency = 0
						}
					):Play()

				end
			end
		end)
	end
end)

--============================================================
-- DRAG
--============================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)

	local delta = input.Position - dragStart

	container.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

container.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = container.Position

	end
end)

container.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if dragging then

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then

			updateDrag(input)

		end
	end
end)

--============================================================
-- BILLBOARD DOS FRUTOS
--============================================================

local activeLabels = {}

local function getFruitPart(instance)

	if instance:IsA("BasePart") then
		return instance
	end

	if instance:IsA("Tool") then

		local handle = instance:FindFirstChild("Handle")

		if handle and handle:IsA("BasePart") then
			return handle
		end

		for _, obj in ipairs(instance:GetDescendants()) do

			if obj:IsA("BasePart") then
				return obj
			end

		end
	end

	if instance:IsA("Model") then

		if instance.PrimaryPart then
			return instance.PrimaryPart
		end

		local part = instance:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		return part
	end

	return nil
end

local function createFruitLabel(instance, fruitName, data)

	if not SHOW_FRUIT_LABELS then
		return
	end

	if activeLabels[instance] then
		return
	end

	local part = getFruitPart(instance)

	if not part then
		-- Caso a fruta seja um Model que ainda está carregando
		task.delay(0.2, function()

			if instance.Parent then
				createFruitLabel(instance, fruitName, data)
			end

		end)

		return
	end

	local color = getColor(fruitName, data)

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "FruitWorldLabel"
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 180, 0, 55)
	billboard.StudsOffset = Vector3.new(0, 4, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = LABEL_MAX_DISTANCE
	billboard.LightInfluence = 0
	billboard.ResetOnSpawn = false
	billboard.Parent = playerGui

	local background = Instance.new("Frame")

	background.Size = UDim2.new(1, 0, 1, 0)
	background.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
	background.BackgroundTransparency = 0.15
	background.BorderSizePixel = 0
	background.Parent = billboard

	local backgroundCorner = Instance.new("UICorner")
	backgroundCorner.CornerRadius = UDim.new(0, 10)
	backgroundCorner.Parent = background

	local backgroundStroke = Instance.new("UIStroke")
	backgroundStroke.Color = color
	backgroundStroke.Thickness = 2
	backgroundStroke.Transparency = 0.1
	backgroundStroke.Parent = background

	local nameLabel = Instance.new("TextLabel")

	nameLabel.BackgroundTransparency = 1
	nameLabel.Position = UDim2.new(0, 5, 0, 3)
	nameLabel.Size = UDim2.new(1, -10, 0, 25)
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.Text = fruitName
	nameLabel.TextSize = 18
	nameLabel.TextColor3 = color
	nameLabel.TextStrokeTransparency = 0.3
	nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	nameLabel.Parent = background

	local rarity = Instance.new("TextLabel")

	rarity.BackgroundTransparency = 1
	rarity.Position = UDim2.new(0, 5, 0, 28)
	rarity.Size = UDim2.new(1, -10, 0, 20)
	rarity.Font = Enum.Font.GothamBold
	rarity.Text = data.Rarity
	rarity.TextSize = 13
	rarity.TextColor3 = Color3.fromRGB(220, 220, 220)
	rarity.TextStrokeTransparency = 0.4
	rarity.Parent = background

	activeLabels[instance] = billboard

	-- Pequena animação de entrada
	billboard.Size = UDim2.new(0, 0, 0, 0)

	TweenService:Create(
		billboard,
		TweenInfo.new(
			0.3,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{
			Size = UDim2.new(0, 180, 0, 55)
		}
	):Play()
end

local function removeFruitLabel(instance)

	local billboard = activeLabels[instance]

	if billboard then

		activeLabels[instance] = nil

		if billboard.Parent then

			local tween = TweenService:Create(
				billboard,
				TweenInfo.new(
					0.2,
					Enum.EasingStyle.Quad,
					Enum.EasingDirection.In
				),
				{
					Size = UDim2.new(0, 0, 0, 0)
				}
			)

			tween:Play()

			task.delay(0.2, function()

				if billboard then
					billboard:Destroy()
				end

			end)
		end
	end
end

--============================================================
-- BOTÃO DE ATIVAR/DESATIVAR LABELS
--============================================================

labelToggle.MouseButton1Click:Connect(function()

	SHOW_FRUIT_LABELS = not SHOW_FRUIT_LABELS

	if SHOW_FRUIT_LABELS then

		labelToggle.Text = "👁"

		for instance, billboard in pairs(activeLabels) do

			if not billboard
				or not billboard.Parent
				or not instance.Parent then

				activeLabels[instance] = nil

			end
		end

	else

		labelToggle.Text = "🚫"

		for instance, billboard in pairs(activeLabels) do

			if billboard then
				billboard:Destroy()
			end

			activeLabels[instance] = nil
		end
	end
end)

--============================================================
-- FILA DE NOTIFICAÇÕES
--============================================================

local queue = {}
local isShowing = false

local function playNotification(name, data)

	local color = getColor(name, data)

	fruitNameLabel.Text = name
	fruitNameLabel.TextColor3 = color
	rarityLabel.Text = "RARIDADE: " .. string.upper(data.Rarity)

	accentBar.BackgroundColor3 = color
	containerStroke.Color = color

	if HIGH_RARITIES[data.Rarity] then

		rareSound:Play()

	else

		notifySound:Play()

	end

	-- Entrada
	container.Position = UDim2.new(
		0.5,
		0,
		0,
		-130
	)

	local slideIn = TweenService:Create(
		container,
		TweenInfo.new(
			0.55,
			Enum.EasingStyle.Back,
			Enum.EasingDirection.Out
		),
		{
			Position = UDim2.new(
				0.5,
				0,
				0,
				24
			)
		}
	)

	slideIn:Play()
	slideIn.Completed:Wait()

	task.wait(NOTIFICATION_TIME)

	-- Saída
	local slideOut = TweenService:Create(
		container,
		TweenInfo.new(
			0.4,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		{
			Position = UDim2.new(
				0.5,
				0,
				0,
				-130
			)
		}
	)

	slideOut:Play()
	slideOut.Completed:Wait()
end

local function processQueue()

	if isShowing then
		return
	end

	isShowing = true

	while #queue > 0 do

		local item = table.remove(queue, 1)

		playNotification(
			item.Name,
			item.Data
		)

	end

	isShowing = false
end

--============================================================
-- DETECÇÃO
--============================================================

local seen = setmetatable({}, {
	__mode = "k"
})

local function tryNotify(instance)

	if not instance then
		return
	end

	if seen[instance] then
		return
	end

	local data = Fruits[instance.Name]

	if not data then
		return
	end

	if not isFruitInstance(instance) then
		return
	end

	seen[instance] = true

	-- Criar texto em cima da fruta
	createFruitLabel(
		instance,
		instance.Name,
		data
	)

	-- Adicionar à fila
	table.insert(
		queue,
		{
			Name = instance.Name,
			Data = data,
			Instance = instance
		}
	)

	processQueue()

	-- Quando a fruta desaparecer
	instance.AncestryChanged:Connect(function(_, parent)

		if not parent then
			removeFruitLabel(instance)
		end

	end)
end

--============================================================
-- LOCAL DE OBSERVAÇÃO
--============================================================

local watchTarget = Workspace

if WATCH_FOLDER_NAME then

	watchTarget = Workspace:WaitForChild(
		WATCH_FOLDER_NAME
	)

end

--============================================================
-- FRUTAS QUE JÁ EXISTEM
--============================================================

for _, instance in ipairs(
	watchTarget:GetDescendants()
) do

	tryNotify(instance)

end

--============================================================
-- NOVAS FRUTAS
--============================================================

watchTarget.DescendantAdded:Connect(
	tryNotify
)

--============================================================
-- LIMPEZA DE LABELS
--============================================================

task.spawn(function()

	while task.wait(1) do

		for instance, billboard in pairs(activeLabels) do

			if not instance
				or not instance.Parent
				or not billboard
				or not billboard.Parent then

				if billboard then
					billboard:Destroy()
				end

				activeLabels[instance] = nil
			end
		end
	end
end)

print("🍈 Fruit Notifier iniciado!")
