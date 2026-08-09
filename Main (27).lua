--========================================================
-- FRUIT FINDER - VERSÃO SIMPLES
-- Procura somente objetos chamados "Fruit"
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local FRUIT_NAME = "Fruit"
local MAX_DISTANCE = 1500

--========================================================
-- GUI
--========================================================

local OldGui = PlayerGui:FindFirstChild("FruitFinder")

if OldGui then
	OldGui:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitFinder"
Gui.ResetOnSpawn = false
Gui.Parent = PlayerGui

--========================================================
-- PAINEL
--========================================================

local Main = Instance.new("Frame")

Main.Name = "Main"
Main.Size = UDim2.fromOffset(350, 400)
Main.Position = UDim2.fromOffset(30, 100)

Main.BackgroundColor3 =
	Color3.fromRGB(25, 25, 25)

Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = Main

--========================================================
-- CABEÇALHO
--========================================================

local Header = Instance.new("Frame")

Header.Size = UDim2.new(1, 0, 0, 55)

Header.BackgroundColor3 =
	Color3.fromRGB(38, 38, 38)

Header.BorderSizePixel = 0
Header.Active = true
Header.Parent = Main

local Title = Instance.new("TextLabel")

Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.fromOffset(12, 0)

Title.BackgroundTransparency = 1

Title.Text = "🍎 FRUITS"

Title.TextColor3 =
	Color3.fromRGB(255, 255, 255)

Title.TextSize = 18
Title.Font = Enum.Font.GothamBold

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent = Header

--========================================================
-- CONTADOR
--========================================================

local Counter = Instance.new("TextLabel")

Counter.Size = UDim2.fromOffset(40, 55)

Counter.Position =
	UDim2.new(1, -85, 0, 0)

Counter.BackgroundTransparency = 1

Counter.Text = "0"

Counter.TextColor3 =
	Color3.fromRGB(180, 180, 180)

Counter.TextSize = 14
Counter.Font = Enum.Font.GothamBold

Counter.Parent = Header

--========================================================
-- BOTÃO MINIMIZAR
--========================================================

local Minimize = Instance.new("TextButton")

Minimize.Size =
	UDim2.fromOffset(40, 40)

Minimize.Position =
	UDim2.new(1, -45, 0, 7)

Minimize.BackgroundTransparency = 1

Minimize.Text = "−"

Minimize.TextColor3 =
	Color3.fromRGB(255, 255, 255)

Minimize.TextSize = 25
Minimize.Font = Enum.Font.GothamBold

Minimize.Parent = Header

--========================================================
-- LISTA
--========================================================

local List = Instance.new("ScrollingFrame")

List.Name = "FruitList"

List.Position =
	UDim2.fromOffset(10, 65)

List.Size =
	UDim2.new(1, -20, 1, -75)

List.BackgroundTransparency = 1

List.BorderSizePixel = 0

List.ScrollBarThickness = 5

List.Parent = Main

local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(0, 6)
Layout.SortOrder = Enum.SortOrder.Name

Layout.Parent = List

--========================================================
-- ARRASTAR MENU
--========================================================

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		Dragging = true

		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

Header.InputEnded:Connect(function(Input)

	if Input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)

	if not Dragging then
		return
	end

	if Input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or Input.UserInputType ==
		Enum.UserInputType.Touch then

		local Delta =
			Input.Position - DragStart

		Main.Position =
			UDim2.new(
				StartPosition.X.Scale,
				StartPosition.X.Offset + Delta.X,

				StartPosition.Y.Scale,
				StartPosition.Y.Offset + Delta.Y
			)
	end
end)

--========================================================
-- MINIMIZAR
--========================================================

local Minimized = false

Minimize.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	if Minimized then

		List.Visible = false

		Main.Size =
			UDim2.fromOffset(350, 55)

		Minimize.Text = "+"

	else

		List.Visible = true

		Main.Size =
			UDim2.fromOffset(350, 400)

		Minimize.Text = "−"
	end
end)

--========================================================
-- FRUTAS DETECTADAS
--========================================================

local FruitsFound = {}

--========================================================
-- PEGAR PARTE DA FRUTA
--========================================================

local function GetFruitPart(Fruit)

	if Fruit:IsA("BasePart") then
		return Fruit
	end

	if Fruit:IsA("Model") then

		if Fruit.PrimaryPart then
			return Fruit.PrimaryPart
		end

		local Handle =
			Fruit:FindFirstChild(
				"Handle",
				true
			)

		if Handle and Handle:IsA("BasePart") then
			return Handle
		end

		return Fruit:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	return nil
end

--========================================================
-- TEXTO SOBRE A FRUTA
--========================================================

local function CreateFruitLabel(Fruit)

	local Part = GetFruitPart(Fruit)

	if not Part then
		return
	end

	local Existing =
		Fruit:FindFirstChild(
			"FruitFinderLabel"
		)

	if Existing then
		Existing:Destroy()
	end

	local Billboard =
		Instance.new("BillboardGui")

	Billboard.Name =
		"FruitFinderLabel"

	Billboard.Adornee =
		Part

	Billboard.Size =
		UDim2.fromOffset(150, 40)

	Billboard.StudsOffset =
		Vector3.new(0, 3, 0)

	Billboard.AlwaysOnTop =
		true

	Billboard.MaxDistance =
		MAX_DISTANCE

	Billboard.Parent =
		Fruit

	local Text =
		Instance.new("TextLabel")

	Text.Size =
		UDim2.fromScale(1, 1)

	Text.BackgroundTransparency = 1

	Text.Text = "🍎 Fruit"

	Text.TextColor3 =
		Color3.fromRGB(255, 255, 255)

	Text.TextStrokeColor3 =
		Color3.fromRGB(0, 0, 0)

	Text.TextStrokeTransparency = 0

	Text.TextScaled = true

	Text.Font =
		Enum.Font.GothamBold

	Text.Parent = Billboard
end

--========================================================
-- REGISTRAR FRUTA
--========================================================

local function RegisterFruit(Object)

	if Object.Name ~= FRUIT_NAME then
		return
	end

	if FruitsFound[Object] then
		return
	end

	FruitsFound[Object] = true

	CreateFruitLabel(Object)
end

--========================================================
-- REMOVER FRUTA
--========================================================

local function RemoveFruit(Object)

	FruitsFound[Object] = nil
end

--========================================================
-- PROCURAR WORKSPACE INTEIRO
--========================================================

task.spawn(function()

	for _, Object in ipairs(
		workspace:GetDescendants()
	) do

		RegisterFruit(Object)

		task.wait()
	end
end)

--========================================================
-- DETECTAR FRUTA NOVA
--========================================================

workspace.DescendantAdded:Connect(function(Object)

	if Object.Name ~= FRUIT_NAME then
		return
	end

	task.defer(function()

		if Object.Parent then
			RegisterFruit(Object)
		end
	end)
end)

--========================================================
-- DETECTAR FRUTA REMOVIDA
--========================================================

workspace.DescendantRemoving:Connect(function(Object)

	if Object.Name == FRUIT_NAME then
		RemoveFruit(Object)
	end
end)

--========================================================
-- ATUALIZAR LISTA
--========================================================

local function UpdateList()

	for _, Child in ipairs(
		List:GetChildren()
	) do

		if Child:IsA("Frame") then
			Child:Destroy()
		end
	end

	local Count = 0

	for Fruit in pairs(FruitsFound) do

		if Fruit
			and Fruit.Parent
			and Fruit:IsDescendantOf(workspace) then

			Count += 1

			local Item =
				Instance.new("Frame")

			Item.Size =
				UDim2.new(1, -5, 0, 50)

			Item.BackgroundColor3 =
				Color3.fromRGB(45, 45, 45)

			Item.BorderSizePixel = 0

			Item.Parent = List

			local Corner =
				Instance.new("UICorner")

			Corner.CornerRadius =
				UDim.new(0, 8)

			Corner.Parent = Item

			local Label =
				Instance.new("TextLabel")

			Label.Size =
				UDim2.new(1, -20, 1, 0)

			Label.Position =
				UDim2.fromOffset(10, 0)

			Label.BackgroundTransparency = 1

			Label.Text = "🍎 Fruit"

			Label.TextColor3 =
				Color3.fromRGB(255, 255, 255)

			Label.TextSize = 14

			Label.Font =
				Enum.Font.GothamBold

			Label.TextXAlignment =
				Enum.TextXAlignment.Left

			Label.Parent = Item

		else

			FruitsFound[Fruit] = nil
		end
	end

	Counter.Text =
		tostring(Count)

	List.CanvasSize =
		UDim2.fromOffset(
			0,
			Layout.AbsoluteContentSize.Y + 10
		)
end

--========================================================
-- LOOP DA INTERFACE
--========================================================

task.spawn(function()

	while Gui.Parent do

		if not Minimized then
			UpdateList()
		end

		task.wait(0.5)
	end
end)
