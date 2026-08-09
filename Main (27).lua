--============================================================
-- FRUIT NOTIFIER REWORK
-- SINGLE LOCAL SCRIPT
--============================================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local CONFIG = {
	TAG = "Fruit",

	MAX_NOTIFICATIONS = 5,

	NOTIFICATION_TIME = 8,

	WIDTH = 360,

	HEIGHT = 80,

	RIGHT = 20,

	TOP = 70,

	DISTANCE_UPDATE = 0.5,
}

--============================================================
-- FRUTAS
--============================================================

local Fruits = {
	["Rocket Fruit"] = {
		Rarity = "Common",
		Emoji = "🚀",
	},

	["Spin Fruit"] = {
		Rarity = "Common",
		Emoji = "🌀",
	},

	["Chop Fruit"] = {
		Rarity = "Common",
		Emoji = "✂️",
	},

	["Spring Fruit"] = {
		Rarity = "Common",
		Emoji = "🟢",
	},

	["Bomb Fruit"] = {
		Rarity = "Common",
		Emoji = "💣",
	},

	["Smoke Fruit"] = {
		Rarity = "Common",
		Emoji = "💨",
	},

	["Flame Fruit"] = {
		Rarity = "Uncommon",
		Emoji = "🔥",
	},

	["Ice Fruit"] = {
		Rarity = "Uncommon",
		Emoji = "❄️",
	},

	["Sand Fruit"] = {
		Rarity = "Uncommon",
		Emoji = "🏜️",
	},

	["Dark Fruit"] = {
		Rarity = "Rare",
		Emoji = "🌑",
	},

	["Light Fruit"] = {
		Rarity = "Rare",
		Emoji = "💡",
	},

	["Magma Fruit"] = {
		Rarity = "Rare",
		Emoji = "🌋",
	},

	["Quake Fruit"] = {
		Rarity = "Legendary",
		Emoji = "💥",
	},

	["Buddha Fruit"] = {
		Rarity = "Legendary",
		Emoji = "🧘",
	},

	["Love Fruit"] = {
		Rarity = "Legendary",
		Emoji = "💗",
	},

	["Spider Fruit"] = {
		Rarity = "Legendary",
		Emoji = "🕷️",
	},

	["Phoenix Fruit"] = {
		Rarity = "Legendary",
		Emoji = "🔥",
	},

	["Portal Fruit"] = {
		Rarity = "Legendary",
		Emoji = "🌀",
	},

	["Rumble Fruit"] = {
		Rarity = "Legendary",
		Emoji = "⚡",
	},

	["Blizzard Fruit"] = {
		Rarity = "Legendary",
		Emoji = "🌨️",
	},

	["Mammoth Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🐘",
	},

	["T-Rex Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🦖",
	},

	["Dough Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🍩",
	},

	["Shadow Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🌑",
	},

	["Venom Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🐍",
	},

	["Control Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🧲",
	},

	["Spirit Fruit"] = {
		Rarity = "Mythical",
		Emoji = "👻",
	},

	["Leopard Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🐆",
	},

	["Kitsune Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🦊",
	},

	["Dragon Fruit"] = {
		Rarity = "Mythical",
		Emoji = "🐉",
	},
}

--============================================================
-- REMOVE GUI ANTIGA
--============================================================

local OldGui = PlayerGui:FindFirstChild("FruitNotifier")

if OldGui then
	OldGui:Destroy()
end

--============================================================
-- GUI
--============================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "FruitNotifier"

Gui.ResetOnSpawn = false

Gui.IgnoreGuiInset = true

Gui.DisplayOrder = 999

Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Gui.Parent = PlayerGui

--============================================================
-- CONTAINER
--============================================================

local Container = Instance.new("Frame")

Container.Name = "Notifications"

Container.AnchorPoint = Vector2.new(1, 0)

Container.Position = UDim2.new(
	1,
	-CONFIG.RIGHT,
	0,
	CONFIG.TOP
)

Container.Size = UDim2.new(
	0,
	CONFIG.WIDTH,
	0,
	500
)

Container.BackgroundTransparency = 1

Container.Parent = Gui

--============================================================
-- LIST
--============================================================

local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(0, 8)

Layout.HorizontalAlignment =
	Enum.HorizontalAlignment.Right

Layout.VerticalAlignment =
	Enum.VerticalAlignment.Top

Layout.SortOrder =
	Enum.SortOrder.LayoutOrder

Layout.Parent = Container

--============================================================
-- CONTROLE
--============================================================

local ActiveCards = {}

local Detected = {}

local Order = 0

--============================================================
-- COR DA RARIDADE
--============================================================

local function RarityColor(Rarity)

	if Rarity == "Common" then
		return Color3.fromRGB(180, 180, 180)

	elseif Rarity == "Uncommon" then
		return Color3.fromRGB(70, 220, 110)

	elseif Rarity == "Rare" then
		return Color3.fromRGB(70, 150, 255)

	elseif Rarity == "Legendary" then
		return Color3.fromRGB(190, 90, 255)

	elseif Rarity == "Mythical" then
		return Color3.fromRGB(255, 80, 90)
	end

	return Color3.fromRGB(255, 255, 255)
end

--============================================================
-- POSIÇÃO
--============================================================

local function GetPosition(Object)

	if Object:IsA("BasePart") then
		return Object.Position
	end

	if Object:IsA("Model") then

		if Object.PrimaryPart then
			return Object.PrimaryPart.Position
		end

		local Part =
			Object:FindFirstChildWhichIsA(
				"BasePart",
				true
			)

		if Part then
			return Part.Position
		end
	end

	return nil
end

--============================================================
-- NOME
--============================================================

local function GetFruitName(Object)

	local Attribute =
		Object:GetAttribute("FruitName")

	if typeof(Attribute) == "string" then

		if Fruits[Attribute] then
			return Attribute
		end
	end

	if Fruits[Object.Name] then
		return Object.Name
	end

	return nil
end

--============================================================
-- DISTÂNCIA
--============================================================

local function GetDistance(Position)

	local Character =
		Player.Character

	if not Character then
		return nil
	end

	local Root =
		Character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not Root then
		return nil
	end

	return (
		Root.Position - Position
	).Magnitude
end

--============================================================
-- FORMATAR DISTÂNCIA
--============================================================

local function FormatDistance(Distance)

	if not Distance then
		return "???"
	end

	if Distance < 1000 then

		return string.format(
			"%d studs",
			math.floor(Distance)
		)

	end

	return string.format(
		"%.1fK studs",
		Distance / 1000
	)
end

--============================================================
-- REMOVER CARD
--============================================================

local function RemoveCard(Card)

	if not Card or not Card.Parent then
		return
	end

	local Tween = TweenService:Create(

		Card,

		TweenInfo.new(
			0.25,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.In
		),

		{
			Size = UDim2.new(
				0,
				0,
				0,
				CONFIG.HEIGHT
			),

			BackgroundTransparency = 1
		}
	)

	Tween:Play()

	Tween.Completed:Wait()

	if Card then
		Card:Destroy()
	end

	for Index, Object in ipairs(ActiveCards) do

		if Object == Card then

			table.remove(
				ActiveCards,
				Index
			)

			break
		end
	end
end

--============================================================
-- CRIAR NOTIFICAÇÃO
--============================================================

local function Notify(
	FruitName,
	Position
)

	local Data =
		Fruits[FruitName]

	if not Data then
		return
	end

	--========================================================
	-- LIMITE
	--========================================================

	while #ActiveCards >=
		CONFIG.MAX_NOTIFICATIONS do

		local Oldest =
			table.remove(
				ActiveCards,
				1
			)

		if Oldest and Oldest.Parent then
			Oldest:Destroy()
		end
	end

	Order += 1

	--========================================================
	-- CARD
	--========================================================

	local Card = Instance.new("Frame")

	Card.Name =
		"Fruit_" .. FruitName

	Card.LayoutOrder =
		Order

	Card.Size =
		UDim2.new(
			0,
			0,
			0,
			CONFIG.HEIGHT
		)

	Card.BackgroundColor3 =
		Color3.fromRGB(
			20,
			20,
			27
		)

	Card.BackgroundTransparency =
		0.04

	Card.BorderSizePixel = 0

	Card.Parent = Container

	--========================================================
	-- CORNER
	--========================================================

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(
			0,
			13
		)

	Corner.Parent = Card

	--========================================================
	-- STROKE
	--========================================================

	local Stroke =
		Instance.new("UIStroke")

	Stroke.Color =
		RarityColor(
			Data.Rarity
		)

	Stroke.Thickness =
		1.5

	Stroke.Transparency =
		0.15

	Stroke.Parent = Card

	--========================================================
	-- ÍCONE
	--========================================================

	local Icon =
		Instance.new("TextLabel")

	Icon.Size =
		UDim2.new(
			0,
			55,
			1,
			0
		)

	Icon.Position =
		UDim2.new(
			0,
			8,
			0,
			0
		)

	Icon.BackgroundTransparency = 1

	Icon.Text =
		Data.Emoji

	Icon.TextSize =
		29

	Icon.Font =
		Enum.Font.GothamBold

	Icon.Parent =
		Card

	--========================================================
	-- NOME
	--========================================================

	local Name =
		Instance.new("TextLabel")

	Name.Position =
		UDim2.new(
			0,
			70,
			0,
			8
		)

	Name.Size =
		UDim2.new(
			1,
			-80,
			0,
			25
		)

	Name.BackgroundTransparency = 1

	Name.Text =
		FruitName

	Name.TextColor3 =
		Color3.fromRGB(
			255,
			255,
			255
		)

	Name.TextSize =
		17

	Name.Font =
		Enum.Font.GothamBold

	Name.TextXAlignment =
		Enum.TextXAlignment.Left

	Name.Parent =
		Card

	--========================================================
	-- RARIDADE
	--========================================================

	local Rarity =
		Instance.new("TextLabel")

	Rarity.Position =
		UDim2.new(
			0,
			70,
			0,
			38
		)

	Rarity.Size =
		UDim2.new(
			0,
			110,
			0,
			18
		)

	Rarity.BackgroundTransparency = 1

	Rarity.Text =
		Data.Rarity

	Rarity.TextColor3 =
		RarityColor(
			Data.Rarity
		)

	Rarity.TextSize =
		12

	Rarity.Font =
		Enum.Font.GothamBold

	Rarity.TextXAlignment =
		Enum.TextXAlignment.Left

	Rarity.Parent =
		Card

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel =
		Instance.new("TextLabel")

	DistanceLabel.Position =
		UDim2.new(
			0,
			180,
			0,
			38
		)

	DistanceLabel.Size =
		UDim2.new(
			1,
			-190,
			0,
			18
		)

	DistanceLabel.BackgroundTransparency = 1

	DistanceLabel.TextColor3 =
		Color3.fromRGB(
			175,
			175,
			185
		)

	DistanceLabel.TextSize =
		12

	DistanceLabel.Font =
		Enum.Font.Gotham

	DistanceLabel.TextXAlignment =
		Enum.TextXAlignment.Right

	DistanceLabel.Parent =
		Card

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local function UpdateDistance()

		if not Card.Parent then
			return
		end

		local Distance =
			GetDistance(
				Position
			)

		DistanceLabel.Text =
			"📍 " ..
			FormatDistance(
				Distance
			)
	end

	UpdateDistance()

	--========================================================
	-- ADICIONAR
	--========================================================

	table.insert(
		ActiveCards,
		Card
	)

	--========================================================
	-- ANIMAÇÃO
	--========================================================

	local Open =
		TweenService:Create(

			Card,

			TweenInfo.new(
				0.4,
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			),

			{
				Size =
					UDim2.new(
						1,
						0,
						0,
						CONFIG.HEIGHT
					)
			}
		)

	Open:Play()

	--========================================================
	-- ATUALIZAR DISTÂNCIA
	--========================================================

	task.spawn(function()

		while Card.Parent do

			UpdateDistance()

			task.wait(
				CONFIG.DISTANCE_UPDATE
			)

		end

	end)

	--========================================================
	-- EXPIRAR
	--========================================================

	task.delay(
		CONFIG.NOTIFICATION_TIME,
		function()

			RemoveCard(
				Card
			)

		end
	)
end

--============================================================
-- DETECTAR FRUTA
--============================================================

local function ProcessFruit(Object)

	if not Object then
		return
	end

	if Detected[Object] then
		return
	end

	local FruitName =
		GetFruitName(Object)

	if not FruitName then
		return
	end

	local Position =
		GetPosition(Object)

	if not Position then
		return
	end

	Detected[Object] = true

	print(
		"[FruitNotifier] Encontrada:",
		FruitName
	)

	Notify(
		FruitName,
		Position
	)

	Object.AncestryChanged:Connect(
		function(_, Parent)

			if not Parent then
				Detected[Object] = nil
			end

		end
	)
end

--============================================================
-- FRUTAS QUE JÁ EXISTEM
--============================================================

for _, Object in ipairs(
	CollectionService:GetTagged(
		CONFIG.TAG
	)
) do

	task.defer(
		ProcessFruit,
		Object
	)

end

--============================================================
-- NOVAS FRUTAS
--============================================================

CollectionService:GetInstanceAddedSignal(
	CONFIG.TAG
):Connect(
	function(Object)

		task.defer(
			ProcessFruit,
			Object
		)

	end
)

--============================================================
-- GUI DE TESTE
--============================================================

local TestButton =
	Instance.new("TextButton")

TestButton.Name =
	"TestButton"

TestButton.Size =
	UDim2.fromOffset(
		130,
		40
	)

TestButton.Position =
	UDim2.new(
		0,
		20,
		1,
		-60
	)

TestButton.BackgroundColor3 =
	Color3.fromRGB(
		30,
		30,
		35
	)

TestButton.Text =
	"TESTAR FRUTA"

TestButton.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

TestButton.TextSize =
	14

TestButton.Font =
	Enum.Font.GothamBold

TestButton.Parent =
	Gui

local TestCorner =
	Instance.new("UICorner")

TestCorner.CornerRadius =
	UDim.new(
		0,
		8
	)

TestCorner.Parent =
	TestButton

TestButton.MouseButton1Click:Connect(
	function()

		local Character =
			Player.Character

		if not Character then
			return
		end

		local Root =
			Character:FindFirstChild(
				"HumanoidRootPart"
			)

		if not Root then
			return
		end

		Notify(
			"Dragon Fruit",
			Root.Position +
				Vector3.new(
					0,
					0,
					-100
				)
		)

	end
)

--============================================================
-- FINAL
--============================================================

print(
	"=========================================="
)

print(
	"[FruitNotifier] REWORK carregado!"
)

print(
	"[FruitNotifier] LocalScript funcionando!"
)

print(
	"=========================================="
)
