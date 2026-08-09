--============================================================
-- FRUIT ADMIN NOTIFIER
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÕES
--============================================================

local CONFIG = {
	ScanInterval = 2,
	MaxDistance = 5000,

	ShowTags = true,
	ShowDistance = true,
	ShowRarity = true,

	PlaySound = true,

	MaxHistory = 15,
	NotificationDuration = 5,

	TagSize = 11,
	TagHeight = 3
}

--============================================================
-- FRUTAS
--============================================================

local FruitData = {

	-- COMMON

	["Rocket"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(190, 190, 190)
	},

	["Spin"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(190, 190, 190)
	},

	["Blade"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(210, 210, 210)
	},

	["Spring"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(210, 210, 210)
	},

	["Bomb"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(210, 210, 210)
	},

	["Smoke"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(180, 180, 180)
	},

	["Spike"] = {
		Rarity = "Common",
		Color = Color3.fromRGB(200, 200, 200)
	},

	-- UNCOMMON

	["Flame"] = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(255, 90, 30)
	},

	["Ice"] = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(80, 210, 255)
	},

	["Sand"] = {
		Rarity = "Uncommon",
		Color = Color3.fromRGB(230, 200, 100)
	},

	-- RARE

	["Dark"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(150, 80, 220)
	},

	["Eagle"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(180, 140, 80)
	},

	["Diamond"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(120, 220, 255)
	},

	["Light"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(255, 235, 80)
	},

	["Rubber"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(255, 100, 100)
	},

	["Ghost"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(190, 150, 255)
	},

	["Magma"] = {
		Rarity = "Rare",
		Color = Color3.fromRGB(255, 70, 20)
	},

	-- LEGENDARY

	["Quake"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(180, 180, 255)
	},

	["Buddha"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 200, 70)
	},

	["Love"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 100, 180)
	},

	["Creation"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 130, 100)
	},

	["Spider"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 120, 170)
	},

	["Sound"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(120, 220, 255)
	},

	["Phoenix"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 130, 40)
	},

	["Portal"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(130, 80, 255)
	},

	["Lightning"] = {
		Rarity = "Legendary",
		Color = Color3.fromRGB(255, 230, 80)
	},

	-- MYTHICAL

	["Pain"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 80, 100)
	},

	["Blizzard"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(150, 220, 255)
	},

	["Gravity"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(170, 100, 255)
	},

	["Mammoth"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(150, 120, 90)
	},

	["T-Rex"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(100, 210, 100)
	},

	["Dough"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 130, 180)
	},

	["Shadow"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(100, 70, 140)
	},

	["Venom"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(130, 255, 100)
	},

	["Gas"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(180, 255, 180)
	},

	["Spirit"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 230, 100)
	},

	["Tiger"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 170, 50)
	},

	["Yeti"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(180, 230, 255)
	},

	["Kitsune"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 120, 200)
	},

	["Control"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 100, 150)
	},

	["Dragon"] = {
		Rarity = "Mythical",
		Color = Color3.fromRGB(255, 70, 70)
	}
}

--============================================================
-- ESTADO
--============================================================

local Enabled = true
local Minimized = false

local DetectedFruits = {}
local FruitTags = {}

local NotificationId = 0
local HistoryCount = 0

--============================================================
-- GUI
--============================================================

local OldGui = PlayerGui:FindFirstChild("FruitAdminNotifier")

if OldGui then
	OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitAdminNotifier"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--============================================================
-- JANELA
--============================================================

local Window = Instance.new("Frame")

Window.Name = "MainWindow"
Window.Size = UDim2.fromOffset(340, 400)
Window.Position = UDim2.new(0, 30, 0.5, -200)

Window.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Window.BorderSizePixel = 0
Window.Active = true

Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 10)
WindowCorner.Parent = Window

--============================================================
-- HEADER
--============================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1, 0, 0, 42)

Header.BackgroundColor3 =
	Color3.fromRGB(34, 34, 42)

Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Window

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")

Title.BackgroundTransparency = 1

Title.Position =
	UDim2.fromOffset(12, 0)

Title.Size =
	UDim2.new(1, -125, 1, 0)

Title.Font =
	Enum.Font.GothamBold

Title.Text =
	"Fruit Admin Notifier"

Title.TextColor3 =
	Color3.new(1, 1, 1)

Title.TextSize = 14

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent = Header

--============================================================
-- BOTÃO ON/OFF
--============================================================

local Toggle = Instance.new("TextButton")

Toggle.Size =
	UDim2.fromOffset(48, 25)

Toggle.Position =
	UDim2.new(1, -105, 0, 8)

Toggle.BorderSizePixel = 0

Toggle.Font =
	Enum.Font.GothamBold

Toggle.TextSize = 11

Toggle.TextColor3 =
	Color3.new(1, 1, 1)

Toggle.Parent = Header

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = Toggle

--============================================================
-- MINIMIZAR
--============================================================

local Minimize = Instance.new("TextButton")

Minimize.Size =
	UDim2.fromOffset(32, 25)

Minimize.Position =
	UDim2.new(1, -48, 0, 8)

Minimize.BackgroundTransparency = 1

Minimize.Font =
	Enum.Font.GothamBold

Minimize.Text =
	"—"

Minimize.TextColor3 =
	Color3.new(1, 1, 1)

Minimize.TextSize = 18

Minimize.Parent = Header

--============================================================
-- CONTEÚDO
--============================================================

local Content = Instance.new("Frame")

Content.Position =
	UDim2.fromOffset(10, 52)

Content.Size =
	UDim2.new(1, -20, 1, -62)

Content.BackgroundTransparency = 1

Content.Parent = Window

--============================================================
-- STATUS
--============================================================

local Status = Instance.new("TextLabel")

Status.Size =
	UDim2.new(1, 0, 0, 25)

Status.BackgroundTransparency = 1

Status.Font =
	Enum.Font.Gotham

Status.Text =
	"Inicializando..."

Status.TextColor3 =
	Color3.fromRGB(170, 170, 170)

Status.TextSize = 11

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent = Content

--============================================================
-- BOTÃO DE TESTE
--============================================================

local TestButton = Instance.new("TextButton")

TestButton.Position =
	UDim2.fromOffset(0, 30)

TestButton.Size =
	UDim2.new(1, 0, 0, 32)

TestButton.BackgroundColor3 =
	Color3.fromRGB(55, 75, 120)

TestButton.BorderSizePixel = 0

TestButton.Font =
	Enum.Font.GothamBold

TestButton.Text =
	"TESTAR NOTIFICAÇÃO"

TestButton.TextColor3 =
	Color3.new(1, 1, 1)

TestButton.TextSize = 11

TestButton.Parent = Content

local TestCorner = Instance.new("UICorner")
TestCorner.CornerRadius = UDim.new(0, 6)
TestCorner.Parent = TestButton

--============================================================
-- HISTÓRICO
--============================================================

local HistoryTitle = Instance.new("TextLabel")

HistoryTitle.Position =
	UDim2.fromOffset(0, 72)

HistoryTitle.Size =
	UDim2.new(1, 0, 0, 22)

HistoryTitle.BackgroundTransparency = 1

HistoryTitle.Font =
	Enum.Font.GothamBold

HistoryTitle.Text =
	"Histórico de frutas"

HistoryTitle.TextColor3 =
	Color3.fromRGB(220, 220, 220)

HistoryTitle.TextSize = 12

HistoryTitle.TextXAlignment =
	Enum.TextXAlignment.Left

HistoryTitle.Parent = Content

local History = Instance.new("ScrollingFrame")

History.Position =
	UDim2.fromOffset(0, 98)

History.Size =
	UDim2.new(1, 0, 1, -98)

History.BackgroundColor3 =
	Color3.fromRGB(28, 28, 35)

History.BorderSizePixel = 0

History.ScrollBarThickness = 4

History.CanvasSize =
	UDim2.new(0, 0, 0, 0)

History.Parent = Content

local HistoryCorner = Instance.new("UICorner")
HistoryCorner.CornerRadius = UDim.new(0, 7)
HistoryCorner.Parent = History

local HistoryLayout = Instance.new("UIListLayout")

HistoryLayout.Padding =
	UDim.new(0, 4)

HistoryLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

HistoryLayout.Parent = History

HistoryLayout:GetPropertyChangedSignal(
	"AbsoluteContentSize"
):Connect(function()

	History.CanvasSize =
		UDim2.fromOffset(
			0,
			HistoryLayout.AbsoluteContentSize.Y + 8
		)

end)

--============================================================
-- TOGGLE
--============================================================

local function UpdateToggle()

	if Enabled then

		Toggle.Text = "ON"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(45, 165, 80)

	else

		Toggle.Text = "OFF"

		Toggle.BackgroundColor3 =
			Color3.fromRGB(165, 50, 50)

	end

end

UpdateToggle()

Toggle.MouseButton1Click:Connect(function()

	Enabled = not Enabled

	UpdateToggle()

	for _, Billboard in pairs(FruitTags) do
		Billboard.Enabled =
			Enabled and CONFIG.ShowTags
	end

	if Enabled then

		Status.Text =
			"Notificador ativado"

	else

		Status.Text =
			"Notificador desativado"

	end

end)

--============================================================
-- MINIMIZAR
--============================================================

local NormalSize =
	UDim2.fromOffset(340, 400)

local MiniSize =
	UDim2.fromOffset(58, 58)

Minimize.MouseButton1Click:Connect(function()

	Minimized = true

	Content.Visible = false
	Toggle.Visible = false
	Minimize.Visible = false

	Window.Size = MiniSize

	Title.Text = "🍎"

end)

Window.InputBegan:Connect(function(Input)

	if not Minimized then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		Minimized = false

		Window.Size = NormalSize

		Content.Visible = true
		Toggle.Visible = true
		Minimize.Visible = true

		Title.Text =
			"Fruit Admin Notifier"

	end

end)

--============================================================
-- ARRASTAR MENU
--============================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)

	if Minimized then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		Dragging = true

		DragStart =
			Input.Position

		StartPosition =
			Window.Position

	end

end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseMovement then

		local Delta =
			Input.Position - DragStart

		Window.Position =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,

				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)

	end

end)

UserInputService.InputEnded:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		Dragging = false

	end

end)

--============================================================
-- SOM
--============================================================

local Sound = Instance.new("Sound")

Sound.Name =
	"FruitNotificationSound"

Sound.SoundId =
	"rbxasset://sounds/electronicpingshort.wav"

Sound.Volume = 0.5

Sound.Parent =
	SoundService

--============================================================
-- PEGAR PART DA FRUTA
--============================================================

local function GetFruitPart(Fruit)

	if Fruit:IsA("BasePart") then
		return Fruit
	end

	if Fruit:IsA("Model") then

		return Fruit:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

	end

	return nil

end

--============================================================
-- CRIAR TEXTO ACIMA DA FRUTA
--============================================================

local function CreateFruitTag(Fruit)

	if FruitTags[Fruit] then
		return
	end

	local Part =
		GetFruitPart(Fruit)

	if not Part then
		return
	end

	local Billboard =
		Instance.new("BillboardGui")

	Billboard.Name =
		"FruitFinderTag"

	Billboard.Adornee =
		Part

	Billboard.Size =
		UDim2.fromOffset(160, 40)

	Billboard.StudsOffset =
		Vector3.new(
			0,
			CONFIG.TagHeight,
			0
		)

	Billboard.AlwaysOnTop = true

	Billboard.MaxDistance =
		CONFIG.MaxDistance

	Billboard.Enabled =
		Enabled and
		CONFIG.ShowTags

	Billboard.Parent =
		PlayerGui

	local Label =
		Instance.new("TextLabel")

	Label.Size =
		UDim2.fromScale(1, 1)

	Label.BackgroundTransparency = 1

	Label.Font =
		Enum.Font.GothamBold

	Label.TextSize =
		CONFIG.TagSize

	Label.TextStrokeTransparency =
		0.25

	local Data =
		FruitData[Fruit.Name]

	Label.TextColor3 =
		Data and
		Data.Color
		or
		Color3.new(1, 1, 1)

	Label.Parent =
		Billboard

	FruitTags[Fruit] =
		Billboard

	Fruit.AncestryChanged:Connect(
		function(_, Parent)

			if not Parent then

				if FruitTags[Fruit] then

					FruitTags[Fruit]:Destroy()

					FruitTags[Fruit] =
						nil

				end

			end

		end
	)

end

--============================================================
-- ADICIONAR AO HISTÓRICO
--============================================================

local function AddHistory(
	FruitName,
	Distance
)

	HistoryCount += 1

	local Data =
		FruitData[FruitName]

	local Rarity =
		Data and
		Data.Rarity
		or
		"Unknown"

	local Item =
		Instance.new("TextLabel")

	Item.Name =
		"FruitHistory_" ..
		HistoryCount

	Item.LayoutOrder =
		-HistoryCount

	Item.Size =
		UDim2.new(
			1,
			-8,
			0,
			48
		)

	Item.BackgroundColor3 =
		Color3.fromRGB(
			38,
			38,
			47
		)

	Item.BorderSizePixel = 0

	Item.Font =
		Enum.Font.GothamBold

	Item.TextSize = 12

	Item.TextXAlignment =
		Enum.TextXAlignment.Left

	Item.TextYAlignment =
		Enum.TextYAlignment.Center

	Item.Text =
		string.format(
			"  %s\n  %s • %dm",
			FruitName,
			Rarity,
			math.floor(Distance)
		)

	Item.TextColor3 =
		Data and
		Data.Color
		or
		Color3.new(1, 1, 1)

	Item.Parent =
		History

	local Corner =
		Instance.new("UICorner")

	Corner.CornerRadius =
		UDim.new(0, 6)

	Corner.Parent =
		Item

	-- Limitar histórico

	local Items = {}

	for _, Child in ipairs(
		History:GetChildren()
	) do

		if Child:IsA("TextLabel") then

			table.insert(
				Items,
				Child
			)

		end

	end

	if #Items >
		CONFIG.MaxHistory then

		table.sort(
			Items,
			function(A, B)

				return A.LayoutOrder >
					B.LayoutOrder

			end
		)

		for Index =
			CONFIG.MaxHistory + 1,
			#Items do

			Items[Index]:Destroy()

		end

	end

end

--============================================================
-- NOTIFICAÇÃO
--============================================================

local function Notify(
	FruitName,
	Distance
)

	if not Enabled then
		return
	end

	NotificationId += 1

	local CurrentId =
		NotificationId

	local Data =
		FruitData[FruitName]

	local Rarity =
		Data and
		Data.Rarity
		or
		"Unknown"

	if CONFIG.ShowRarity then

		Status.Text =
			string.format(
				"%s • %s • %dm",
				FruitName,
				Rarity,
				math.floor(Distance)
			)

	else

		Status.Text =
			string.format(
				"%s • %dm",
				FruitName,
				math.floor(Distance)
			)

	end

	if CONFIG.PlaySound then
		Sound:Play()
	end

	AddHistory(
		FruitName,
		Distance
	)

	task.delay(
		CONFIG.NotificationDuration,
		function()

			if NotificationId ==
				CurrentId then

				Status.Text =
					"Monitorando frutas..."

			end

		end
	)

end

--============================================================
-- SCANNER
--============================================================

local function ScanFruits()

	local FruitsFolder =
		workspace:FindFirstChild(
			"Fruits"
		)

	if not FruitsFolder then

		Status.Text =
			"ERRO: Workspace.Fruits não encontrada"

		return

	end

	local Character =
		Player.Character

	local Root =
		Character and
		Character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not Root then
		return
	end

	local CurrentFruits = {}

	for _, Fruit in ipairs(
		FruitsFolder:GetChildren()
	) do

		if not (
			Fruit:IsA("Model")
			or
			Fruit:IsA("BasePart")
		) then

			continue

		end

		local Part =
			GetFruitPart(Fruit)

		if not Part then
			continue
		end

		local Distance =
			(
				Root.Position -
				Part.Position
			).Magnitude

		if Distance <=
			CONFIG.MaxDistance then

			CurrentFruits[Fruit] =
				Distance

			CreateFruitTag(Fruit)

			-- Fruta nova

			if not DetectedFruits[Fruit] then

				DetectedFruits[Fruit] =
					true

				Notify(
					Fruit.Name,
					Distance
				)

			end

		end

	end

	--========================================================
	-- REMOVER FRUTAS QUE SUMIRAM
	--========================================================

	for Fruit in pairs(
		DetectedFruits
	) do

		if not CurrentFruits[Fruit]
			or not Fruit.Parent then

			DetectedFruits[Fruit] =
				nil

			if FruitTags[Fruit] then

				FruitTags[Fruit]:Destroy()

				FruitTags[Fruit] =
					nil

			end

		end

	end

	Status.Text =
		"Monitorando frutas..."

end

--============================================================
-- SCAN A CADA 2 SEGUNDOS
--============================================================

task.spawn(function()

	while Gui.Parent do

		ScanFruits()

		task.wait(
			CONFIG.ScanInterval
		)

	end

end)

--============================================================
-- ATUALIZAÇÃO DO TEXTO SOBRE AS FRUTAS
--============================================================

task.spawn(function()

	while Gui.Parent do

		local Character =
			Player.Character

		local Root =
			Character and
			Character:FindFirstChild(
				"HumanoidRootPart"
			)

		if Root then

			for Fruit, Billboard in pairs(
				FruitTags
			) do

				if not Fruit.Parent then
					continue
				end

				local Part =
					GetFruitPart(Fruit)

				if not Part then
					continue
				end

				local Distance =
					(
						Root.Position -
						Part.Position
					).Magnitude

				local Label =
					Billboard:FindFirstChildWhichIsA(
						"TextLabel"
					)

				if Label then

					local Data =
						FruitData[Fruit.Name]

					local Rarity =
						Data and
						Data.Rarity
						or
						"Unknown"

					if CONFIG.ShowRarity
						and CONFIG.ShowDistance then

						Label.Text =
							string.format(
								"%s\n%s • %dm",
								Fruit.Name,
								Rarity,
								math.floor(Distance)
							)

					elseif CONFIG.ShowDistance then

						Label.Text =
							string.format(
								"%s • %dm",
								Fruit.Name,
								math.floor(Distance)
							)

					else

						Label.Text =
							Fruit.Name

					end

				end

				Billboard.Enabled =
					Enabled
					and CONFIG.ShowTags
					and Distance <=
						CONFIG.MaxDistance

			end

		end

		task.wait(0.15)

	end

end)

--============================================================
-- BOTÃO DE TESTE
--============================================================

TestButton.MouseButton1Click:Connect(function()

	Notify(
		"Dragon",
		327
	)

end)

--============================================================
-- FINALIZAÇÃO
--============================================================

Status.Text =
	"Monitorando frutas..."

print(
	"[Fruit Admin Notifier] Sistema iniciado."
)
