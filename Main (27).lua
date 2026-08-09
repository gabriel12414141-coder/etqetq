local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- GUI
--==================================================

local old = playerGui:FindFirstChild("FruitFinder")

if old then
	old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FruitFinder"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(360, 410)
main.Position = UDim2.fromOffset(30, 100)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = main

--==================================================
-- HEADER
--==================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(38,38,38)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "🍎 FRUIT FINDER"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local counter = Instance.new("TextLabel")
counter.Size = UDim2.fromOffset(40,55)
counter.Position = UDim2.new(1,-85,0,0)
counter.BackgroundTransparency = 1
counter.Text = "0"
counter.TextColor3 = Color3.fromRGB(180,180,180)
counter.TextSize = 14
counter.Font = Enum.Font.GothamBold
counter.Parent = header

--==================================================
-- MINIMIZAR
--==================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(40,40)
minimize.Position = UDim2.new(1,-45,0,7)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 25
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

--==================================================
-- LISTA
--==================================================

local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(10,65)
list.Size = UDim2.new(1,-20,1,-75)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = list

--==================================================
-- ARRASTAR
--==================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position
	end
end)

header.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

--==================================================
-- MINIMIZAR
--==================================================

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		list.Visible = false

		main.Size = UDim2.fromOffset(360,55)

		minimize.Text = "+"

	else

		list.Visible = true

		main.Size = UDim2.fromOffset(360,410)

		minimize.Text = "−"
	end
end)

--==================================================
-- OBJETOS DETECTADOS
--==================================================

local detected = {}

--==================================================
-- PEGAR PARTE
--==================================================

local function getPart(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		local part = object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

		return part
	end

	return nil
end

--==================================================
-- DISPLAY
--==================================================

local function createDisplay(object)

	local part = getPart(object)

	if not part then
		return
	end

	local oldDisplay = object:FindFirstChild(
		"FruitFinderDisplay"
	)

	if oldDisplay then
		oldDisplay:Destroy()
	end

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "FruitFinderDisplay"
	billboard.Adornee = part
	billboard.Size = UDim2.fromOffset(220,45)
	billboard.StudsOffset = Vector3.new(0,3,0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 1500
	billboard.Parent = object

	local text = Instance.new("TextLabel")

	text.Size = UDim2.fromScale(1,1)
	text.BackgroundTransparency = 1

	-- Mostra o nome REAL do modelo
	text.Text = "🍎 " .. object.Name

	text.TextColor3 = Color3.new(1,1,1)
	text.TextStrokeColor3 = Color3.new(0,0,0)
	text.TextStrokeTransparency = 0
	text.TextScaled = true
	text.Font = Enum.Font.GothamBold

	text.Parent = billboard
end

--==================================================
-- ADICIONAR MODELO
--==================================================

local function addObject(object)

	if not object:IsA("Model") then
		return
	end

	if detected[object] then
		return
	end

	-- Ignora modelos criados pelo próprio detector
	if object.Name == "FruitFinderDisplay" then
		return
	end

	detected[object] = object.Name

	createDisplay(object)
end

--==================================================
-- REMOVER
--==================================================

local function removeObject(object)

	detected[object] = nil
end

--==================================================
-- BUSCA INICIAL
--==================================================

task.spawn(function()

	for _, object in ipairs(workspace:GetDescendants()) do

		addObject(object)

		task.wait()
	end
end)

--==================================================
-- NOVOS MODELOS
--==================================================

workspace.DescendantAdded:Connect(function(object)

	task.defer(function()

		if object.Parent then
			addObject(object)
		end
	end)
end)

--==================================================
-- MODELOS REMOVIDOS
--==================================================

workspace.DescendantRemoving:Connect(function(object)

	removeObject(object)
end)

--==================================================
-- ATUALIZAR LISTA
--==================================================

local function updateList()

	for _, child in ipairs(list:GetChildren()) do

		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	local count = 0

	for object, name in pairs(detected) do

		if object
			and object.Parent
			and object:IsDescendantOf(workspace) then

			count += 1

			local item = Instance.new("Frame")

			item.Size = UDim2.new(1,-5,0,50)
			item.BackgroundColor3 = Color3.fromRGB(45,45,45)
			item.BorderSizePixel = 0
			item.Parent = list

			local itemCorner = Instance.new("UICorner")
			itemCorner.CornerRadius = UDim.new(0,8)
			itemCorner.Parent = item

			local label = Instance.new("TextLabel")

			label.Size = UDim2.new(1,-20,1,0)
			label.Position = UDim2.fromOffset(10,0)
			label.BackgroundTransparency = 1

			label.Text = "🍎 " .. name

			label.TextColor3 = Color3.new(1,1,1)
			label.TextSize = 14
			label.Font = Enum.Font.GothamBold
			label.TextXAlignment = Enum.TextXAlignment.Left

			label.Parent = item

		else

			detected[object] = nil
		end
	end

	counter.Text = tostring(count)

	list.CanvasSize = UDim2.fromOffset(
		0,
		layout.AbsoluteContentSize.Y + 10
	)
end

--==================================================
-- LOOP DA INTERFACE
--==================================================

task.spawn(function()

	while gui.Parent do

		if not minimized then
			updateList()
		end

		task.wait(0.5)
	end
end)
