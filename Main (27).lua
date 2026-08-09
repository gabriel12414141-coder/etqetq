--============================================================
-- FRUIT NOTIFIER REWORK
-- LOCAL SCRIPT - VERSÃO CORRIGIDA
--============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local CONFIG = {
	GUI_NAME = "FruitNotifier",

	FOLDER_NAME = "Fruits",

	MAX_NOTIFICATIONS = 5,

	NOTIFICATION_TIME = 7,

	WIDTH = 350,

	HEIGHT = 82,

	RIGHT = 20,

	TOP = 80,

	-- Procura frutas no Workspace inteiro.
	SEARCH_WORKSPACE = true,
}

--============================================================
-- FRUTAS
--============================================================

local FruitNames = {
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

local OldGui = PlayerGui:FindFirstChild(CONFIG.GUI_NAME)

if OldGui then
	OldGui:Destroy()
end

--============================================================
-- GUI PRINCIPAL
--============================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = CONFIG.GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = false
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.Parent = PlayerGui

--============================================================
-- CONTAINER
--============================================================

local Container = Instance.new("Frame")

Container.Name = "Container"

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

Container.Parent = ScreenGui

local List = Instance.new("UIListLayout")

List.Padding = UDim.new(0, 8)

List.HorizontalAlignment = Enum.HorizontalAlignment.Right

List.VerticalAlignment = Enum.VerticalAlignment.Top

List.SortOrder = Enum.SortOrder.LayoutOrder

List.Parent = Container

--============================================================
-- CONTROLE
--============================================================

local Notifications = {}

local Detected = {}

local Order = 0

--============================================================
-- NOME DA FRUTA
--============================================================

local function GetFruitName(Object)

	if not Object then
		return nil
	end

	-- Attribute
	local Attribute = Object:GetAttribute("FruitName")

	if typeof(Attribute) == "string" then

		if FruitNames[Attribute] then
			return Attribute
		end

	end

	-- StringValue
	local Value = Object:FindFirstChild("FruitName")

	if Value and Value:IsA("StringValue") then

		if FruitNames[Value.Value] then
			return Value.Value
		end

	end

	-- Nome direto
	if FruitNames[Object.Name] then
		return Object.Name
	end

	return nil
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

		local Part = Object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		if Part then
			return Part.Position
		end

	end

	if Object:IsA("Tool") then

		local Handle = Object:FindFirstChild("Handle")

		if Handle and Handle:IsA("BasePart") then
			return Handle.Position
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
-- REMOVER CARD
--============================================================

local function RemoveCard(Card)

	if not Card then
		return
	end

	if not Card.Parent then
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

	for i, v in ipairs(Notifications) do

		if v == Card then

			table.remove(
				Notifications,
				i
			)

			break
		end

	end
end

--============================================================
-- CRIAR NOTIFICAÇÃO
--============================================================

local function Notify(FruitName, Position)

	-- Limite
	while #Notifications >= CONFIG.MAX_NOTIFICATIONS do

		local Oldest =
			table.remove(
				Notifications,
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

	Card.Name = "Fruit_" .. FruitName

	Card.LayoutOrder = Order

	Card.Size = UDim2.new(
		0,
		0,
		0,
		CONFIG.HEIGHT
	)

	Card.BackgroundColor3 =
		Color3.fromRGB(22, 22, 28)

	Card.BackgroundTransparency = 0.05

	Card.BorderSizePixel = 0

	Card.Parent = Container

	--========================================================
	-- CORNER
	--========================================================

	local Corner = Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 14)

	Corner.Parent = Card

	--========================================================
	-- BORDA
	--========================================================

	local Stroke = Instance.new("UIStroke")

	Stroke.Thickness = 1.5

	Stroke.Transparency = 0.25

	Stroke.Parent = Card

	--========================================================
	-- ÍCONE
	--========================================================

	local Icon = Instance.new("TextLabel")

	Icon.Name = "Icon"

	Icon.Position =
		UDim2.new(0, 10, 0, 0)

	Icon.Size =
		UDim2.new(0, 55, 1, 0)

	Icon.BackgroundTransparency = 1

	Icon.Text = "🍎"

	Icon.TextSize = 30

	Icon.Font =
		Enum.Font.GothamBold

	Icon.Parent = Card

	--========================================================
	-- NOME
	--========================================================

	local Name = Instance.new("TextLabel")

	Name.Name = "FruitName"

	Name.Position =
		UDim2.new(0, 70, 0, 11)

	Name.Size =
		UDim2.new(1, -80, 0, 26)

	Name.BackgroundTransparency = 1

	Name.Text = FruitName

	Name.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	Name.TextSize = 18

	Name.Font =
		Enum.Font.GothamBold

	Name.TextXAlignment =
		Enum.TextXAlignment.Left

	Name.TextTruncate =
		Enum.TextTruncate.AtEnd

	Name.Parent = Card

	--========================================================
	-- DISTÂNCIA
	--========================================================

	local DistanceLabel = Instance.new("TextLabel")

	DistanceLabel.Name = "Distance"

	DistanceLabel.Position =
		UDim2.new(0, 70, 0, 40)

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
	-- ATUALIZA DISTÂNCIA
	--========================================================

	local function UpdateDistance()

		if not Card.Parent then
			return
		end

		local Distance =
			GetDistance(Position)

		DistanceLabel.Text =
			"📍 " .. FormatDistance(Distance)
	end

	UpdateDistance()

	--========================================================
	-- GUARDA
	--========================================================

	table.insert(
		Notifications,
		Card
	)

	--========================================================
	-- ANIMAÇÃO
	--========================================================

	local Open = TweenService:Create(

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
				CONFIG.HEIGHT
			)
		}
	)

	Open:Play()

	--========================================================
	-- ATUALIZA DISTÂNCIA
	--========================================================

	task.spawn(function()

		local Start = os.clock()

		while Card.Parent and
			os.clock() - Start <
			CONFIG.NOTIFICATION_TIME do

			UpdateDistance()

			task.wait(0.5)

		end

	end)

	--========================================================
	-- REMOÇÃO
	--========================================================

	task.delay(
		CONFIG.NOTIFICATION_TIME,
		function()

			RemoveCard(Card)

		end
	)
end

--============================================================
-- PROCESSAR FRUTA
--============================================================

local function ProcessObject(Object)

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
		"[FruitNotifier] Fruta encontrada:",
		FruitName
	)

	Notify(
		FruitName,
		Position
	)

	-- Permitir detectar novamente depois
	Object.AncestryChanged:Connect(
		function(_, Parent)

			if not Parent then
				Detected[Object] = nil
			end

		end
	)
end

--============================================================
-- MONITORAR OBJETOS
--============================================================

local function MonitorFolder(Folder)

	print(
		"[FruitNotifier] Monitorando:",
		Folder:GetFullName()
	)

	for _, Object in ipairs(
		Folder:GetChildren()
	) do

		task.defer(
			ProcessObject,
			Object
		)

	end

	Folder.ChildAdded:Connect(
		function(Object)

			task.defer(
				ProcessObject,
				Object
			)

		end
	)
end

--============================================================
-- MONITORAR WORKSPACE
--============================================================

if CONFIG.SEARCH_WORKSPACE then

	for _, Object in ipairs(
		workspace:GetDescendants()
	) do

		task.defer(
			ProcessObject,
			Object
		)

	end

	workspace.DescendantAdded:Connect(
		function(Object)

			task.defer(
				ProcessObject,
				Object
			)

		end
	)

end

--============================================================
-- MONITORAR PASTA FRUITS
--============================================================

local FruitsFolder =
	workspace:FindFirstChild(
		CONFIG.FOLDER_NAME
	)

if FruitsFolder then

	MonitorFolder(
		FruitsFolder
	)

end

workspace.ChildAdded:Connect(
	function(Object)

		if Object.Name ==
			CONFIG.FOLDER_NAME then

			MonitorFolder(
				Object
			)

		end

	end
)

--============================================================
-- TESTE VISUAL
--============================================================

print(
	"========================================"
)

print(
	"[FruitNotifier] GUI carregada!"
)

print(
	"[FruitNotifier] LocalScript funcionando!"
)

print(
	"========================================"
)
