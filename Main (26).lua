--========================================================
-- FRUIT TRACKER - VERSÃO FINAL
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local UPDATE_TIME = 0.5
local TEXT_SIZE = 14

-- Coloque aqui os nomes das frutas existentes no seu jogo.
local FRUIT_NAMES = {
	"Rocket Fruit",
	"Spin Fruit",
	"Blade Fruit",
	"Spring Fruit",
	"Bomb Fruit",
	"Smoke Fruit",
	"Spike Fruit",
	"Flame Fruit",
	"Falcon Fruit",
	"Ice Fruit",
	"Sand Fruit",
	"Dark Fruit",
	"Diamond Fruit",
	"Light Fruit",
	"Rubber Fruit",
	"Barrier Fruit",
	"Ghost Fruit",
	"Magma Fruit",
	"Door Fruit",
	"Quake Fruit",
	"Buddha Fruit",
	"Love Fruit",
	"Spider Fruit",
	"Sound Fruit",
	"Phoenix Fruit",
	"Portal Fruit",
	"Rumble Fruit",
	"Pain Fruit",
	"Blizzard Fruit",
	"Gravity Fruit",
	"Mammoth Fruit",
	"T-Rex Fruit",
	"Dough Fruit",
	"Shadow Fruit",
	"Venom Fruit",
	"Control Fruit",
	"Spirit Fruit",
	"Dragon Fruit",
	"Leopard Fruit",
	"Yeti Fruit",
	"Kitsune Fruit"
}

--========================================================
-- TRANSFORMAR LISTA EM TABELA
--========================================================

local KnownFruits = {}

for _, name in ipairs(FRUIT_NAMES) do
	KnownFruits[name:lower()] = name
end

--========================================================
-- GUI
--========================================================

local old = playerGui:FindFirstChild("FruitTracker")

if old then
	old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FruitTracker"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(360,420)
main.Position = UDim2.fromOffset(30,100)
main.BackgroundColor3 = Color3.fromRGB(24,24,24)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = main

--========================================================
-- HEADER
--========================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,55)
header.BackgroundColor3 = Color3.fromRGB(38,38,38)
header.BorderSizePixel = 0
header.Active = true
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "🍎  FRUTAS SPAWNADAS"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local counter = Instance.new("TextLabel")
counter.Size = UDim2.fromOffset(35,55)
counter.Position = UDim2.new(1,-82,0,0)
counter.BackgroundTransparency = 1
counter.Text = "0"
counter.TextColor3 = Color3.fromRGB(190,190,190)
counter.TextSize = 15
counter.Font = Enum.Font.GothamBold
counter.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(40,40)
minimize.Position = UDim2.new(1,-45,0,7)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 25
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

--========================================================
-- LISTA
--========================================================

local list = Instance.new("ScrollingFrame")
list.Position = UDim2.fromOffset(10,65)
list.Size = UDim2.new(1,-20,1,-75)
list.BackgroundTransparency = 1
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0,0,0,0)
list.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.Parent = list

--========================================================
-- PROCURAR NOME DA FRUTA
--========================================================

local function findFruitName(fruitModel)

	-- Procura o nome exato entre os descendentes.
	for _, object in ipairs(
		fruitModel:GetDescendants()
	) do

		local objectName =
			object.Name:lower()

		-- InitialPoses, Handle etc. são ignorados
		if objectName ~= "initialposes"
			and objectName ~= "handle" then

			if KnownFruits[objectName] then
				return KnownFruits[objectName]
			end

			-- Também verifica nomes contendo o nome da fruta
			for lowerName, realName in pairs(KnownFruits) do

				if objectName:find(
					lowerName,
					1,
					true
				) then
					return realName
				end
			end
		end
	end

	-- Verifica o próprio Model
	local modelName =
		fruitModel.Name:lower()

	if KnownFruits[modelName] then
		return KnownFruits[modelName]
	end

	return nil
end

--========================================================
-- ENCONTRAR HANDLE
--========================================================

local function getHandle(fruit)

	local handle =
		fruit:FindFirstChild(
			"Handle",
			true
		)

	if handle and handle:IsA("BasePart") then
		return handle
	end

	if fruit.PrimaryPart then
		return fruit.PrimaryPart
	end

	return fruit:FindFirstChildWhichIsA(
		"BasePart",
		true
	)
end

--========================================================
-- NOME ACIMA DA FRUTA
--========================================================

local function createDisplay(fruit, name)

	local handle =
		getHandle(fruit)

	if not handle then
		return
	end

	local old =
		handle:FindFirstChild(
			"FruitNameDisplay"
		)

	if old then
		old:Destroy()
	end

	local billboard =
		Instance.new("BillboardGui")

	billboard.Name =
		"FruitNameDisplay"

	billboard.Adornee =
		handle

	billboard.Size =
		UDim2.fromOffset(190,30)

	billboard.StudsOffset =
		Vector3.new(0,4,0)

	billboard.AlwaysOnTop = true
	billboard.MaxDistance = math.huge
	billboard.Parent = handle

	local text =
		Instance.new("TextLabel")

	text.Size =
		UDim2.fromScale(1,1)

	text.BackgroundTransparency = 1

	text.Text =
		name

	text.TextColor3 =
		Color3.new(1,1,1)

	text.TextStrokeColor3 =
		Color3.new(0,0,0)

	text.TextStrokeTransparency = 0

	text.TextSize =
		TEXT_SIZE

	text.Font =
		Enum.Font.GothamBold

	text.Parent = billboard
end

--========================================================
-- ITEM DO PAINEL
--========================================================

local function createItem(name)

	local item =
		Instance.new("TextLabel")

	item.Size =
		UDim2.new(1,-5,0,42)

	item.BackgroundColor3 =
		Color3.fromRGB(45,45,45)

	item.BorderSizePixel = 0

	item.Text =
		"🍎  " .. name

	item.TextColor3 =
		Color3.new(1,1,1)

	item.TextSize = 15

	item.Font =
		Enum.Font.GothamBold

	item.TextXAlignment =
		Enum.TextXAlignment.Left

	item.Parent = list

	local padding =
		Instance.new("UIPadding")

	padding.PaddingLeft =
		UDim.new(0,10)

	padding.Parent = item

	local itemCorner =
		Instance.new("UICorner")

	itemCorner.CornerRadius =
		UDim.new(0,8)

	itemCorner.Parent = item
end

--========================================================
-- PROCURAR FRUTAS
--========================================================

local function findFruits()

	local fruits = {}

	for _, object in ipairs(
		workspace:GetDescendants()
	) do

		-- Detecta somente Models chamados Fruit
		if object:IsA("Model")
			and object.Name == "Fruit" then

			local name =
				findFruitName(object)

			-- Só adiciona se realmente
			-- encontrou o nome de uma fruta.
			if name then

				table.insert(
					fruits,
					{
						Model = object,
						Name = name
					}
				)
			end
		end
	end

	return fruits
end

--========================================================
-- ATUALIZAR PAINEL
--========================================================

local function update()

	for _, child in ipairs(
		list:GetChildren()
	) do

		if child:IsA("TextLabel") then
			child:Destroy()
		end
	end

	local fruits =
		findFruits()

	counter.Text =
		tostring(#fruits)

	if #fruits == 0 then

		local empty =
			Instance.new("TextLabel")

		empty.Size =
			UDim2.new(1,-5,0,50)

		empty.BackgroundTransparency = 1

		empty.Text =
			"Nenhuma fruta encontrada."

		empty.TextColor3 =
			Color3.fromRGB(170,170,170)

		empty.TextSize = 15

		empty.Font =
			Enum.Font.Gotham

		empty.Parent = list

	else

		for _, fruit in ipairs(fruits) do

			createDisplay(
				fruit.Model,
				fruit.Name
			)

			createItem(
				fruit.Name
			)
		end
	end

	list.CanvasSize =
		UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 10
		)
end

--========================================================
-- ARRASTAR PAINEL
--========================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		dragging = true
		dragStart = input.Position
		startPosition = main.Position
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement then

		local delta =
			input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1 then

		dragging = false
	end
end)

--========================================================
-- MINIMIZAR
--========================================================

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		list.Visible = false
		main.Size = UDim2.fromOffset(360,55)
		minimize.Text = "+"

	else

		list.Visible = true
		main.Size = UDim2.fromOffset(360,420)
		minimize.Text = "−"

	end
end)

--========================================================
-- ATUALIZAÇÃO
--========================================================

task.spawn(function()

	while gui.Parent do

		if not minimized then
			update()
		end

		task.wait(UPDATE_TIME)
	end
end)

update()