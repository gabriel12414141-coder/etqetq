--============================================================
-- FRUIT NOTIFIER REWORK
-- LOCAL SCRIPT
-- Para uso no seu próprio jogo Roblox
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local CONFIG = {
	FolderName = "Fruits",

	NotificationDuration = 6,

	MaxNotifications = 5,

	NotificationWidth = 340,

	NotificationHeight = 78,

	TopOffset = 80,

	RightOffset = 20,

	-- Deixe false se não quiser som
	EnableSound = false,

	-- Coloque o ID do seu som aqui
	SoundId = "",

	-- Detectar frutas que já estavam no mapa
	CheckExistingFruits = true,
}

--============================================================
-- FRUTAS VÁLIDAS
--============================================================

local ValidFruits = {
	["Rocket Fruit"] = true,
	["Spin Fruit"] = true,
	["Chop Fruit"] = true,
	["Spring Fruit"] = true,
	["Bomb Fruit"] = true,
	["Smoke Fruit"] = true,
	["Flame Fruit"] = true,
	["Ice Fruit"] = true,
	["Sand Fruit"] = true,
	["Dark Fruit"] = true,
	["Light Fruit"] = true,
	["Magma Fruit"] = true,
	["Quake Fruit"] = true,
	["Buddha Fruit"] = true,
	["Love Fruit"] = true,
	["Spider Fruit"] = true,
	["Phoenix Fruit"] = true,
	["Portal Fruit"] = true,
	["Rumble Fruit"] = true,
	["Blizzard Fruit"] = true,
	["Mammoth Fruit"] = true,
	["T-Rex Fruit"] = true,
	["Dough Fruit"] = true,
	["Shadow Fruit"] = true,
	["Venom Fruit"] = true,
	["Control Fruit"] = true,
	["Spirit Fruit"] = true,
	["Leopard Fruit"] = true,
	["Kitsune Fruit"] = true,
	["Dragon Fruit"] = true,
}

--============================================================
-- REMOVE GUI ANTIGA
--============================================================

local OldGui = PlayerGui:FindFirstChild("FruitNotifier")

if OldGui then
	OldGui:Destroy()
end

--============================================================
-- SCREEN GUI
--============================================================

local Gui = Instance.new("ScreenGui")

Gui.Name = "FruitNotifier"

Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = false

Gui.DisplayOrder = 999

Gui.Parent = PlayerGui

--============================================================
-- CONTAINER
--============================================================

local Container = Instance.new("Frame")

Container.Name = "Container"

Container.AnchorPoint = Vector2.new(1, 0)

Container.Position = UDim2.new(
	1,
	-CONFIG.RightOffset,
	0,
	CONFIG.TopOffset
)

Container.Size = UDim2.new(
	0,
	CONFIG.NotificationWidth,
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

Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right

Layout.VerticalAlignment = Enum.VerticalAlignment.Top

Layout.SortOrder = Enum.SortOrder.LayoutOrder

Layout.Parent = Container

--============================================================
-- NOTIFICAÇÕES ATIVAS
--============================================================

local ActiveNotifications = {}

local NotificationIndex = 0

--============================================================
-- SOM
--============================================================

local NotificationSound

if CONFIG.EnableSound and CONFIG.SoundId ~= "" then

	NotificationSound = Instance.new("Sound")

	NotificationSound.Name = "FruitNotificationSound"

	NotificationSound.SoundId = CONFIG.SoundId

	NotificationSound.Volume = 0.5

	NotificationSound.Parent = SoundService

end

--============================================================
-- OBTÉM NOME DA FRUTA
--============================================================

local function GetFruitName(Object)

	if not Object then
		return nil
	end

	-- Attribute
	local Attribute = Object:GetAttribute("FruitName")

	if typeof(Attribute) == "string" and Attribute ~= "" then
		return Attribute
	end

	-- StringValue
	local Value = Object:FindFirstChild("FruitName")

	if Value and Value:IsA("StringValue") then

		if Value.Value ~= "" then
			return Value.Value
		end

	end

	-- Nome do objeto
	if ValidFruits[Object.Name] then
		return Object.Name
	end

	return nil
end

--============================================================
-- OBTÉM POSIÇÃO
--============================================================

local function GetPosition(Object)

	if Object:IsA("BasePart") then
		return Object.Position
	end

	if Object:IsA("Model") then

		if Object.PrimaryPart then
			return Object.PrimaryPart.Position
		end

		local Part = Object:FindFirstChildWhichIsA(
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
-- DISTÂNCIA
--============================================================

local function GetDistance(Position)

	local Character = Player.Character

	if not Character then
		return nil
	end

	local Root = Character:FindFirstChild(
		"HumanoidRootPart"
	)

	if not Root then
		return nil
	end

	return (Root.Position - Position).Magnitude
end

--============================================================
-- FORMATA DISTÂNCIA
--============================================================

local function FormatDistance(Distance)

	if not Distance then
		return "Distância desconhecida"
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
-- ATUALIZA DISTÂNCIA
--============================================================

local function UpdateDistance(Card, Position)

	if not Card or not Card.Parent then
		return
	end

	local DistanceLabel = Card:FindFirstChild(
		"Distance"
	)

	if not DistanceLabel then
		return
	end

	local Distance = GetDistance(Position)

	DistanceLabel.Text =
		"📍 " .. FormatDistance(Distance)
end

--============================================================
-- REMOVER NOTIFICAÇÃO
--============================================================

local function RemoveNotification(Card)

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
				CONFIG.NotificationHeight
			),

			BackgroundTransparency = 1
		}
	)

	Tween:Play()

	Tween.Completed:Wait()

	if Card then
		Card:Destroy()
	end

	for Index, Object in ipairs(
		ActiveNotifications
	) do

		if Object == Card then

			table.remove(
				ActiveNotifications,
				Index
			)

			break
		end

	end
end

--============================================================
-- CRIAR NOTIFICAÇÃO
--============================================================

local function CreateNotification(
	FruitName,
	Position
)

	-- Limite
	while #ActiveNotifications >=
		CONFIG.MaxNotifications do

		local Oldest =
			table.remove(
				ActiveNotifications,
				1
			)

		if Oldest and Oldest.Parent then
			Oldest:Destroy()
		end

	end

	NotificationIndex += 1

	--========================================================
	-- CARD
	--========================================================

	local Card = Instance.new("Frame")

	Card.Name = "FruitNotification"

	Card.LayoutOrder = NotificationIndex

	Card.Size = UDim2.new(
		0,
		0,
		0,
		CONFIG.NotificationHeight
	)

	Card.BackgroundColor3 =
		Color3.fromRGB(18, 18, 23)

	Card.BackgroundTransparency = 0.05

	Card.BorderSizePixel = 0

	Card.Parent = Container

	--========================================================
	-- CORNER
	--========================================================

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 12)

	Corner.Parent = Card

	--========================================================
	-- STROKE
	--========================================================

	local Stroke = Instance.new("UIStroke")

	Stroke.Thickness = 1

	Stroke.Transparency = 0.3

	Stroke.Parent = Card

	--========================================================
	-- ÍCONE
	--========================================================

	local Icon = Instance.new("TextLabel")

	Icon.Name = "Icon"

	Icon.Position =
		UDim2.new(0, 12, 0, 0)

	Icon.Size =
		UDim2.new(0, 50, 1, 0)

	Icon.BackgroundTransparency = 1

	Icon.Text = "🍎"

	Icon.TextSize = 28

	Icon.Font =
		Enum.Font.GothamBold

	Icon.Parent = Card

	--========================================================
	-- NOME
	--========================================================

	local NameLabel = Instance.new("TextLabel")

	NameLabel.Name = "FruitName"

	NameLabel.Position =
		UDim2.new(0, 68, 0, 10)

	NameLabel.Size =
		UDim2.new(1, -80, 0, 25)

	NameLabel.BackgroundTransparency = 1

	NameLabel.Text = FruitName

	NameLabel.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	NameLabel.TextSize = 17

	NameLabel.Font =
		Enum.Font.GothamBold

	NameLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	NameLabel.TextTruncate =
		Enum.TextTruncate.AtEnd

	NameLabel.Parent = Card

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel = Instance.new("TextLabel")

	DistanceLabel.Name = "Distance"

	DistanceLabel.Position =
		UDim2.new(0, 68, 0, 39)

	DistanceLabel.Size =
		UDim2.new(1, -80, 0, 22)

	DistanceLabel.BackgroundTransparency = 1

	DistanceLabel.TextColor3 =
		Color3.fromRGB(180, 180, 190)

	DistanceLabel.TextSize = 13

	DistanceLabel.Font =
		Enum.Font.Gotham

	DistanceLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	DistanceLabel.Parent = Card

	--========================================================
	-- DISTÂNCIA INICIAL
	--========================================================

	UpdateDistance(
		Card,
		Position
	)

	--========================================================
	-- GUARDA
	--========================================================

	table.insert(
		ActiveNotifications,
		Card
	)

	--========================================================
	-- SOM
	--========================================================

	if NotificationSound then

		NotificationSound:Play()

	end

	--========================================================
	-- ANIMAÇÃO ENTRADA
	--========================================================

	local OpenTween = TweenService:Create(

		Card,

		TweenInfo.new(
			0.35,
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		),

		{
			Size = UDim2.new(
				1,
				0,
				0,
				CONFIG.NotificationHeight
			)
		}
	)

	OpenTween:Play()

	--========================================================
	-- ATUALIZA DISTÂNCIA
	--========================================================

	task.spawn(function()

		local Start = os.clock()

		while Card.Parent and
			os.clock() - Start <
			CONFIG.NotificationDuration do

			UpdateDistance(
				Card,
				Position
			)

			task.wait(0.5)

		end

	end)

	--========================================================
	-- REMOÇÃO
	--========================================================

	task.delay(
		CONFIG.NotificationDuration,
		function()

			RemoveNotification(Card)

		end
	)

end

--============================================================
-- CONTROLE DE FRUTAS JÁ NOTIFICADAS
--============================================================

local AlreadyNotified = {}

--============================================================
-- PROCESSAR OBJETO
--============================================================

local function ProcessFruit(Object)

	if not Object then
		return
	end

	if AlreadyNotified[Object] then
		return
	end

	local FruitName =
		GetFruitName(Object)

	if not FruitName then
		return
	end

	if not ValidFruits[FruitName] then
		return
	end

	local Position =
		GetPosition(Object)

	if not Position then
		return
	end

	AlreadyNotified[Object] = true

	CreateNotification(
		FruitName,
		Position
	)

	-- Limpa quando desaparecer
	Object.AncestryChanged:Connect(
		function(_, Parent)

			if not Parent then
				AlreadyNotified[Object] = nil
			end

		end
	)

end

--============================================================
-- MONITORAR PASTA
--============================================================

local function MonitorFolder(Folder)

	-- Frutas existentes
	if CONFIG.CheckExistingFruits then

		for _, Object in ipairs(
			Folder:GetChildren()
		) do

			task.defer(
				ProcessFruit,
				Object
			)

		end

	end

	-- Novas frutas
	Folder.ChildAdded:Connect(
		function(Object)

			task.defer(
				ProcessFruit,
				Object
			)

		end
	)

end

--============================================================
-- ENCONTRAR PASTA
--============================================================

local FruitsFolder =
	workspace:FindFirstChild(
		CONFIG.FolderName
	)

if FruitsFolder then

	MonitorFolder(
		FruitsFolder
	)

else

	workspace.ChildAdded:Connect(
		function(Object)

			if Object.Name ==
				CONFIG.FolderName then

				MonitorFolder(
					Object
				)

			end

		end
	)

end

--============================================================
-- DEBUG
--============================================================

print(
	"[FruitNotifier] Rework carregado."
)
