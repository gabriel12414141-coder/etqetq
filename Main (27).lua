local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

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
-- REMOVER GUI ANTIGA
--==================================================

local OldGui = PlayerGui:FindFirstChild("FruitFinder")

if OldGui then
	OldGui:Destroy()
end

--==================================================
-- GUI
--==================================================

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitFinder"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
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
-- BARRA SUPERIOR
--==================================================

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(35, 35, 44)
TopBar.BorderSizePixel = 0
TopBar.Active = true
TopBar.Parent = Window

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Position = UDim2.fromOffset(12, 0)
Title.Size = UDim2.new(1, -55, 1, 0)
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
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.fromOffset(36, 36)
MinimizeButton.Position = UDim2.new(1, -38, 0, 2)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Parent = TopBar

--==================================================
-- CONTEÚDO
--==================================================

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.fromOffset(10, 50)
Content.Size = UDim2.new(1, -20, 1, -60)
Content.BackgroundTransparency = 1
Content.Parent = Window

--==================================================
-- PESQUISA
--==================================================

local SearchBox = Instance.new("TextBox")
SearchBox.Name = "SearchBox"
SearchBox.Size = UDim2.new(1, 0, 0, 34)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
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
-- BOTÃO ON/OFF
--==================================================

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Position = UDim2.fromOffset(0, 43)
ToggleButton.Size = UDim2.new(1, 0, 0, 34)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 125, 70)
ToggleButton.BorderSizePixel = 0
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "Fruit Finder: ON"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 12
ToggleButton.Parent = Content

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

--==================================================
-- STATUS
--==================================================

local Status = Instance.new("TextLabel")
Status.Name = "Status"
Status.Position = UDim2.fromOffset(0, 82)
Status.Size = UDim2.new(1, 0, 0, 25)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Gotham
Status.Text = "Procurando frutas..."
Status.TextColor3 = Color3.fromRGB(170, 170, 170)
Status.TextSize = 11
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Content

--==================================================
-- LISTA
--==================================================

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Position = UDim2.fromOffset(0, 112)
List.Size = UDim2.new(1, 0, 1, -112)
List.BackgroundColor3 = Color3.fromRGB(29, 29, 36)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Content

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = List

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.SortOrder = Enum.SortOrder.Name
ListLayout.Parent = List

--==================================================
-- MINIMIZAR
--==================================================

local Minimized = false
local NormalSize = UDim2.fromOffset(280, 330)

MinimizeButton.MouseButton1Click:Connect(function()

	Minimized = true

	Content.Visible = false
	MinimizeButton.Visible = false

	Window.Size = UDim2.fromOffset(52, 52)

	Title.Text = "🍎"

end)

Window.InputBegan:Connect(function(Input)

	if not Minimized then
		return
	end

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then

		Minimized = false

		Window.Size = NormalSize

		Content.Visible = true
		MinimizeButton.Visible = true

		Title.Text = "Fruit Finder"

	end

end)

--==================================================
-- ARRASTAR
--==================================================

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(Input)

	if Minimized then
		return
	end

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

	if Input.UserInputType == Enum.UserInputType.MouseMovement then

		local Delta = Input.Position - DragStart

		Window.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)

	end

end)

UserInputService.InputEnded:Connect(function(Input)

	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end

end)

--==================================================
-- FRUTAS
--==================================================

local FruitTags = {}

local FruitColors = {
	Rocket = Color3.fromRGB(180, 180, 180),
	Spin = Color3.fromRGB(170, 170, 170),
	Blade = Color3.fromRGB(220, 220, 220),

	Smoke = Color3.fromRGB(190, 190, 190),
	Flame = Color3.fromRGB(255, 90, 30),
	Ice = Color3.fromRGB(80, 210, 255),

	Sand = Color3.fromRGB(230, 200, 100),
	Dark = Color3.fromRGB(150, 80, 220),
	Light = Color3.fromRGB(255, 235, 80),

	Magma = Color3.fromRGB(255, 70, 20),
	Ghost = Color3.fromRGB(190, 150, 255),

	Dragon = Color3.fromRGB(255, 70, 70),
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
	Label.TextSize = Settings.TextSize
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
-- ATUALIZAR LISTA
--==================================================

local function UpdateList()

	for _, Object in ipairs(List:GetChildren()) do

		if Object:IsA("TextButton") then
			Object:Destroy()
		end

	end

	local Search = string.lower(SearchBox.Text)
	local Count = 0

	for Fruit, _ in pairs(FruitTags) do

		if Fruit.Parent then

			local Name = Fruit.Name

			if Search == ""
				or string.find(string.lower(Name), Search, 1, true) then

				Count += 1

				local Button = Instance.new("TextButton")

				Button.Name = Name
				Button.Size = UDim2.new(1, -8, 0, 30)
				Button.BackgroundColor3 = Color3.fromRGB(40, 40, 49)
				Button.BorderSizePixel = 0
				Button.Font = Enum.Font.GothamBold
				Button.Text = "  " .. Name
				Button.TextColor3 =
					FruitColors[Name]
					or Color3.fromRGB(255, 255, 255)

				Button.TextSize = 12
				Button.TextXAlignment = Enum.TextXAlignment.Left
				Button.Parent = List

				local Corner = Instance.new("UICorner")
				Corner.CornerRadius = UDim.new(0, 5)
				Corner.Parent = Button

			end

		end

	end

	Status.Text = Count .. " fruta(s) encontrada(s)"

end

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()

	List.CanvasSize = UDim2.fromOffset(
		0,
		ListLayout.AbsoluteContentSize.Y + 8
	)

end)

SearchBox:GetPropertyChangedSignal("Text"):Connect(UpdateList)

--==================================================
-- TOGGLE
--==================================================

ToggleButton.MouseButton1Click:Connect(function()

	Settings.Enabled = not Settings.Enabled

	if Settings.Enabled then

		ToggleButton.Text = "Fruit Finder: ON"

		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(45, 125, 70)

	else

		ToggleButton.Text = "Fruit Finder: OFF"

		ToggleButton.BackgroundColor3 =
			Color3.fromRGB(125, 45, 45)

	end

	for _, Billboard in pairs(FruitTags) do
		Billboard.Enabled = Settings.Enabled
	end

end)

--==================================================
-- ENCONTRAR PASTA FRUITS
--==================================================

local FruitsFolder = workspace:FindFirstChild("Fruits")

local function ScanFruits()

	if not FruitsFolder then

		Status.Text = "Pasta Fruits não encontrada"

		UpdateList()

		return

	end

	for _, Fruit in ipairs(FruitsFolder:GetChildren()) do

		if Fruit:IsA("Model")
			or Fruit:IsA("BasePart") then

			CreateFruitTag(Fruit)

		end

	end

	UpdateList()

end

--==================================================
-- SE A PASTA FRUITS EXISTIR
--==================================================

if FruitsFolder then

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

	ScanFruits()

else

	Status.Text = "Aguardando Workspace.Fruits..."

	-- Detecta a pasta caso ela seja criada depois
	workspace.ChildAdded:Connect(function(Object)

		if Object.Name == "Fruits" then

			FruitsFolder = Object

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

			ScanFruits()

		end

	end)

end

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
-- FINAL
--==================================================

print("[FruitFinder] Sistema iniciado com sucesso.")
