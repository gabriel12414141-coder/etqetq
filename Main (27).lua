```lua
--============================================================
-- 🍎 FRUIT RECOGNITION SYSTEM
-- GUI ARRASTÁVEL + MINIMIZÁVEL
-- NOME ACIMA DA FRUTA
--
-- Roblox Studio / LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local SCAN_INTERVAL = 0.5

--============================================================
-- 42 FRUTAS
--============================================================

local FruitNames = {
	"Rocket",
	"Spin",
	"Blade",
	"Spring",
	"Bomb",
	"Smoke",
	"Spike",
	"Flame",
	"Ice",
	"Sand",
	"Dark",
	"Eagle",
	"Diamond",
	"Light",
	"Rubber",
	"Ghost",
	"Magma",
	"Quake",
	"Buddha",
	"Love",
	"Creation",
	"Spider",
	"Sound",
	"Phoenix",
	"Portal",
	"Lightning",
	"Pain",
	"Blizzard",
	"Gravity",
	"Mammoth",
	"T-Rex",
	"Dough",
	"Shadow",
	"Venom",
	"Gas",
	"Spirit",
	"Tiger",
	"Yeti",
	"Kitsune",
	"Control",
	"Dragon"
}

--============================================================
-- DICIONÁRIO
--============================================================

local FruitDictionary = {}

for _, name in ipairs(FruitNames) do
	FruitDictionary[name:lower()] = name
end

--============================================================
-- REMOVER GUI ANTIGO
--============================================================

local old = playerGui:FindFirstChild("FruitRecognitionSystem")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "FruitRecognitionSystem"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--============================================================
-- JANELA
--============================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(350, 450)
main.Position = UDim2.new(0, 20, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

--============================================================
-- BARRA SUPERIOR
--============================================================

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 45)
topBar.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 12)
topCorner.Parent = topBar

--============================================================
-- TÍTULO
--============================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "🍎 Fruit Recognition"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "Minimize"
minimizeButton.Size = UDim2.fromOffset(35, 35)
minimizeButton.Position = UDim2.new(1, -40, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "—"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = topBar

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 8)
minimizeCorner.Parent = minimizeButton

--============================================================
-- CONTEÚDO
--============================================================

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.fromOffset(0, 45)
content.BackgroundTransparency = 1
content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.fromOffset(10, 5)
status.BackgroundTransparency = 1
status.Text = "🔎 Procurando frutas..."
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.TextSize = 13
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = content

--============================================================
-- LISTA
--============================================================

local list = Instance.new("ScrollingFrame")
list.Name = "FruitList"
list.Size = UDim2.new(1, -20, 1, -55)
list.Position = UDim2.fromOffset(10, 45)
list.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = content

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = list

--============================================================
-- GUI ARRASTÁVEL
--============================================================

local dragging = false
local dragStart
local startPosition

local function updateDrag(input)

	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end

topBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end

		end)
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
-- MINIMIZAR
--============================================================

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		content.Visible = false

		main.Size = UDim2.fromOffset(350, 45)

		minimizeButton.Text = "+"

	else

		content.Visible = true

		main.Size = UDim2.fromOffset(350, 450)

		minimizeButton.Text = "—"

	end

end)

--============================================================
-- NORMALIZAR NOME
--============================================================

local function NormalizeName(name)

	name = tostring(name)

	name = name:gsub("^%s+", "")
	name = name:gsub("%s+$", "")

	local withoutFruit =
		name:match("^(.-)%s+[Ff]ruit$")

	if withoutFruit then
		name = withoutFruit
	end

	return name
end

--============================================================
-- RECONHECER FRUTA
--============================================================

local function RecognizeFruit(object)

	if not object then
		return nil
	end

	local name = NormalizeName(object.Name)

	return FruitDictionary[name:lower()]
end

--============================================================
-- POSIÇÃO
--============================================================

local function GetPosition(object)

	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		return object:GetPivot().Position
	end

	if object:IsA("Attachment") then
		return object.WorldPosition
	end

	return nil
end

--============================================================
-- PARTE PRINCIPAL DA FRUTA
--============================================================

local function GetAdornee(object)

	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)
	end

	return nil
end

--============================================================
-- NOME ACIMA DA FRUTA
--============================================================

local function CreateFruitName(object, fruitName)

	local adornee = GetAdornee(object)

	if not adornee then
		return nil
	end

	local billboard = Instance.new("BillboardGui")

	billboard.Name = "FruitNameDisplay"
	billboard.Adornee = adornee
	billboard.Size = UDim2.fromOffset(120, 25)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 1000
	billboard.Parent = gui

	local label = Instance.new("TextLabel")

	label.Size = UDim2.fromScale(1, 1)
	label.BackgroundTransparency = 1
	label.Text = fruitName
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.25
	label.TextSize = 14
	label.Font = Enum.Font.GothamBold
	label.Parent = billboard

	return billboard
end

--============================================================
-- DADOS
--============================================================

local Detected = {}

--============================================================
-- ITEM DA LISTA
--============================================================

local function CreateFruitEntry(name)

	local frame = Instance.new("Frame")

	frame.Size =
		UDim2.new(1, -10, 0, 62)

	frame.BackgroundColor3 =
		Color3.fromRGB(34, 34, 34)

	frame.BorderSizePixel = 0

	frame.Parent = list

	local corner = Instance.new("UICorner")
	corner.CornerRadius =
		UDim.new(0, 8)

	corner.Parent = frame

	local nameLabel =
		Instance.new("TextLabel")

	nameLabel.Size =
		UDim2.new(1, -20, 0, 28)

	nameLabel.Position =
		UDim2.fromOffset(10, 4)

	nameLabel.BackgroundTransparency = 1

	nameLabel.Text =
		"🍏 " .. name .. " Fruit"

	nameLabel.TextColor3 =
		Color3.new(1, 1, 1)

	nameLabel.TextSize = 16

	nameLabel.Font =
		Enum.Font.GothamBold

	nameLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	nameLabel.Parent = frame

	local distance =
		Instance.new("TextLabel")

	distance.Size =
		UDim2.new(1, -20, 0, 20)

	distance.Position =
		UDim2.fromOffset(10, 34)

	distance.BackgroundTransparency = 1

	distance.Text =
		"📍 Calculando..."

	distance.TextColor3 =
		Color3.fromRGB(110, 220, 120)

	distance.TextSize = 12

	distance.Font =
		Enum.Font.Gotham

	distance.TextXAlignment =
		Enum.TextXAlignment.Left

	distance.Parent = frame

	return frame, distance
end

--============================================================
-- ATUALIZAR CANVAS
--============================================================

local function UpdateCanvas()

	task.defer(function()

		list.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y + 10
			)

	end)
end

--============================================================
-- SCAN
--============================================================

local function Scan()

	local current = {}
	local total = 0

	for _, object in ipairs(workspace:GetDescendants()) do

		local fruitName =
			RecognizeFruit(object)

		if fruitName then

			current[object] = true
			total += 1

			if not Detected[object] then

				local frame, distance =
					CreateFruitEntry(fruitName)

				local billboard =
					CreateFruitName(
						object,
						fruitName
					)

				Detected[object] = {
					Name = fruitName,
					Frame = frame,
					Distance = distance,
					Billboard = billboard
				}
			end
		end
	end

	--========================================================
	-- REMOVER FRUTAS
	--========================================================

	for object, data in pairs(Detected) do

		if not current[object] then

			if data.Frame then
				data.Frame:Destroy()
			end

			if data.Billboard then
				data.Billboard:Destroy()
			end

			Detected[object] = nil

		end
	end

	--========================================================
	-- STATUS
	--========================================================

	if total == 0 then

		status.Text =
			"🔎 Nenhuma das 42 frutas foi encontrada"

		status.TextColor3 =
			Color3.fromRGB(200, 200, 200)

	else

		status.Text =
			"✅ " ..
			total ..
			" fruta(s) encontrada(s)"

		status.TextColor3 =
			Color3.fromRGB(100, 255, 120)

	end

	UpdateCanvas()
end

--============================================================
-- DISTÂNCIA
--============================================================

local function UpdateDistances()

	local character =
		player.Character

	if not character then
		return
	end

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not root then
		return
	end

	for object, data in pairs(Detected) do

		if object
			and object.Parent
			and data.Distance then

			local position =
				GetPosition(object)

			if position then

				local distance =
					(root.Position - position).Magnitude

				data.Distance.Text =
					"📍 " ..
					math.floor(distance) ..
					" studs"

			end
		end
	end
end

--============================================================
-- NOVOS OBJETOS
--============================================================

workspace.DescendantAdded:Connect(function()

	task.delay(0.1, function()

		if gui.Parent then
			Scan()
		end

	end)

end)

--============================================================
-- OBJETOS REMOVIDOS
--============================================================

workspace.DescendantRemoving:Connect(function()

	task.delay(0.05, function()

		if gui.Parent then
			Scan()
		end

	end)

end)

--============================================================
-- LOOP
--============================================================

task.spawn(function()

	while gui.Parent do

		Scan()

		task.wait(SCAN_INTERVAL)

	end

end)

--============================================================
-- DISTÂNCIA EM TEMPO REAL
--============================================================

RunService.RenderStepped:Connect(function()

	if gui.Parent then
		UpdateDistances()
	end

end)

--============================================================
-- INICIAR
--============================================================

task.wait(1)

Scan()

status.Text =
	"🟢 Sistema ativo • 42 frutas"

status.TextColor3 =
	Color3.fromRGB(100, 255, 120)
```
