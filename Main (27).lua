local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local FruitsFolder = workspace:WaitForChild("Fruits")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local Settings = {
	Enabled = true,
	ShowDistance = true,
	MaxDistance = 5000,
	TextSize = 11,
	StudsOffset = Vector3.new(0, 3, 0)
}

--==================================================
-- REMOVER VERSÃO ANTERIOR
--==================================================

local OldGui = PlayerGui:FindFirstChild("FruitFinder")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- GUI PRINCIPAL
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitFinder"
Gui.ResetOnSpawn = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.Parent = PlayerGui

--==================================================
-- JANELA
--==================================================

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(280, 330)
Window.Position = UDim2.new(0, 30, 0.5, -165)
Window.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
Window.BorderSizePixel = 0
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 8)
WindowCorner.Parent = Window

--==================================================
-- BARRA DE TÍTULO
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = Window

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(12, 0)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Fruit Finder"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 15
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

--==================================================
-- BOTÃO MINIMIZAR
--==================================================

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Size = UDim2.fromOffset(34, 34)
MinimizeButton.Position = UDim2.new(1, -36, 0, 2)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "—"
MinimizeButton.TextColor3 = Color3.fromRGB(220, 220, 220)
MinimizeButton.TextSize = 18
MinimizeButton.Parent = TopBar

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.fromOffset(10, 48)
Content.Size = UDim2.new(1, -20, 1, -58)
Content.BackgroundTransparency = 1
Content.Parent = Window

--==================================================
-- PESQUISA
--==================================================

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "Search"
SearchBox.Size = UDim2.new(1, 0, 0, 34)
SearchBox.BackgroundColor3 = Color3.fromRGB(38, 38, 48)
SearchBox.BorderSizePixel = 0
SearchBox.ClearTextOnFocus = false
SearchBox.Font = Enum.Font.Gotham
SearchBox.PlaceholderText = "Pesquisar fruta..."
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.TextSize = 12
SearchBox.Parent = Content

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchBox

--==================================================
-- BOTÃO ENABLE
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "Toggle"
ToggleButton.Position = UDim2.fromOffset(0, 43)
ToggleButton.Size = UDim2.new(1, 0, 0, 34)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 120, 70)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Text = "Fruit Finder: ON"
ToggleButton.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

--==================================================
-- LISTA
--==================================================

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Position = UDim2.fromOffset(0, 86)
List.Size = UDim2.new(1, 0, 1, -86)
List.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new()
List.Parent = Content

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = List

--==================================================
-- MINIMIZAR
--==================================================

local Minimized = false

local function Minimize()
	Minimized = true

	Content.Visible = false
	MinimizeButton.Visible = false

	Window.Size = UDim2.fromOffset(50, 50)

	Title.Text = "🍎"

	Window.Position = UDim2.new(
		0,
		30,
		0.5,
		-25
	)
end

local function Restore()
	Minimized = false

	Window.Size = UDim2.fromOffset(280, 330)

	Content.Visible = true
	MinimizeButton.Visible = true

	Title.Text = "Fruit Finder"
end

MinimizeButton.MouseButton1Click:Connect(Minimize)

Window.InputBegan:Connect(function(Input)

	if Minimized and Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Restore()
	end

end)

--==================================================
-- ARRASTAR MENU
--==================================================

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Dragging = true
		DragStart = Input.Position
		StartPosition = Window.Position

	end

end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	local Delta = Input.Position - DragStart

	Window.Position = UDim2.new(
		StartPosition.X.Scale,
		StartPosition.X.Offset + Delta.X,

		StartPosition.Y.Scale,
		StartPosition.Y.Offset + Delta.Y
	)

end)

UserInputService.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end

end)

--==================================================
-- FRUIT TAGS
--==================================================

local FruitTags = {}

local FruitColors = {
	Rocket = Color3.fromRGB(180, 180, 180),
	Spin = Color3.fromRGB(170, 170, 170),
	Blade = Color3.fromRGB(210, 210, 210),

	Smoke = Color3.fromRGB(190, 190, 190),
	Flame = Color3.fromRGB(255, 90, 30),
	Ice = Color3.fromRGB(80, 210, 255),

	Sand = Color3.fromRGB(220, 190, 100),
	Dark = Color3.fromRGB(150, 80, 220),
	Light = Color3.fromRGB(255, 235, 80),

	Magma = Color3.fromRGB(255, 70, 20),
	Ghost = Color3.fromRGB(190, 150, 255),

	Dragon = Color3.fromRGB(255, 80, 80),
	Buddha = Color3.fromRGB(255, 200, 70),
	Leopard = Color3.fromRGB(255, 170, 50),
	Dough = Color3.fromRGB(255, 130, 180)
}

local function GetAdornee(Fruit)

	if Fruit:IsA("BasePart") then
		return Fruit
	end

	if Fruit:IsA("Model") then
		return Fruit:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function CreateFruitTag(Fruit)

	if FruitTags[Fruit] then
		return
	end

	local Adornee = GetAdornee(Fruit)

	if not Adornee then
		return
	end

	local Billboard = Instance.new("BillboardGui")

	Billboard.Name = "FruitTag"
	Billboard.Adornee = Adornee
	Billboard.Size = UDim2.fromOffset(130, 25)
	Billboard.StudsOffset = Settings.StudsOffset
	Billboard.AlwaysOnTop = true
	Billboard.MaxDistance = Settings.MaxDistance
	Billboard.Enabled = Settings.Enabled
	Billboard.Parent = PlayerGui

	local Label = Instance.new("TextLabel")

	Label.Name = "Fruit"
	Label.Size = UDim2.fromScale(1, 1)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 11
	Label.TextStrokeTransparency = 0.35
	Label.TextColor3 =
		FruitColors[Fruit.Name]
		or Color3.fromRGB(255, 255, 255)

	Label.Text = Fruit.Name
	Label.Parent = Billboard

	FruitTags[Fruit] = Billboard

	Fruit.AncestryChanged:Connect(function(_, Parent)

		if not Parent then

			if FruitTags[Fruit] then
				FruitTags[Fruit]:Destroy()
				FruitTags[Fruit] = nil
			end

		end

	end)

end

local function RemoveFruitTag(Fruit)

	if FruitTags[Fruit] then

		FruitTags[Fruit]:Destroy()
		FruitTags[Fruit] = nil

	end

end

--==================================================
-- LISTA DE FRUTAS
--==================================================

local function UpdateList()

	for _, Object in ipairs(List:GetChildren()) do

		if Object:IsA("TextButton") then
			Object:Destroy()
		end

	end

	local Search = string.lower(SearchBox.Text)

	for Fruit, _ in pairs(FruitTags) do

		if Fruit.Parent then

			local Name = Fruit.Name

			if Search == ""
				or string.find(string.lower(Name), Search, 1, true) then

				local Button = Instance.new("TextButton")

				Button.Size = UDim2.new(1, -8, 0, 30)
				Button.BackgroundColor3 = Color3.fromRGB(39, 39, 48)
				Button.BorderSizePixel = 0
				Button.Font = Enum.Font.Gotham
				Button.TextColor3 =
					FruitColors[Name]
					or Color3.fromRGB(255, 255, 255)

				Button.TextSize = 12
				Button.Text = "  " .. Name
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = List

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0, 5)
				Corner.Parent = Button
			end

		end

	end

end

--==================================================
-- TOGGLE
--==================================================

ToggleButton.MouseButton1Click:Connect(function()

	Settings.Enabled = not Settings.Enabled

	if Settings.Enabled then

		ToggleButton.Text = "Fruit Finder: ON"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(45, 120, 70)

	else

		ToggleButton.Text = "Fruit Finder: OFF"
		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(120, 45, 45)

	end

	for _, Billboard in pairs(FruitTags) do
		Billboard.Enabled = Settings.Enabled
	end

end)

--==================================================
-- PESQUISA
--==================================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(UpdateList)

--==================================================
-- DETECTAR FRUTAS
--==================================================

local function ScanFruits()

	for _, Fruit in ipairs(FruitsFolder:GetChildren()) do

		if Fruit:IsA("Model")
			or Fruit:IsA("BasePart") then

			CreateFruitTag(Fruit)

		end

	end

	UpdateList()
end

FruitsFolder.ChildAdded:Connect(function(Fruit)

	task.wait()

	if Fruit:IsA("Model")
		or Fruit:IsA("BasePart") then

		CreateFruitTag(Fruit)

	end

	UpdateList()

end)

FruitsFolder.ChildRemoved:Connect(function(Fruit)

	RemoveFruitTag(Fruit)
	UpdateList()

end)

--==================================================
-- DISTÂNCIA
--==================================================

RunService.RenderStepped:Connect(function()

	if not Settings.Enabled then
		return
	end

	local Character = Player.Character

	if not Character then
		return
	end

	local Root =
		Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	for Fruit, Billboard in pairs(FruitTags) do

		if Fruit.Parent and Billboard.Parent then

			local Adornee = GetAdornee(Fruit)

			if Adornee then

				local Distance =
					(Root.Position - Adornee.Position).Magnitude

				local Label =
					Billboard:FindFirstChild("Fruit")

				if Label then

					if Settings.ShowDistance then

						Label.Text = string.format(
							"%s • %dm",
							Fruit.Name,
							math.floor(Distance)
						)

					else

						Label.Text = Fruit.Name

					end

				end

			end

		end

	end

end)

--==================================================
-- INICIAR
--==================================================

ScanFruits()
