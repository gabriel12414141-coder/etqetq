--============================================================
-- FRUIT FINDER - VERSÃO DE DIAGNÓSTICO
-- GUI é criado PRIMEIRO
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

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

local FruitDictionary = {}

for _, fruit in ipairs(FruitNames) do
	FruitDictionary[string.lower(fruit)] = fruit
end

--============================================================
-- REMOVER GUI ANTERIOR
--============================================================

local old = playerGui:FindFirstChild("FruitFinderFinal")

if old then
	old:Destroy()
end

--============================================================
-- GUI PRINCIPAL
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "FruitFinderFinal"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Parentear IMEDIATAMENTE
gui.Parent = playerGui

--============================================================
-- JANELA
--============================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 350, 0, 430)
main.Position = UDim2.new(0, 25, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = true
main.ZIndex = 10
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

--============================================================
-- CABEÇALHO
--============================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.BorderSizePixel = 0
header.ZIndex = 11
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

--============================================================
-- TÍTULO
--============================================================

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🍎 Fruit Finder"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 19
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 12
title.Parent = header

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 34, 0, 34)
minimize.Position = UDim2.new(1, -40, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimize.BorderSizePixel = 0
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamBold
minimize.ZIndex = 13
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 7)
minCorner.Parent = minimize

--============================================================
-- CONTEÚDO
--============================================================

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -45)
content.Position = UDim2.new(0, 0, 0, 45)
content.BackgroundTransparency = 1
content.ZIndex = 10
content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 45)
status.Position = UDim2.new(0, 10, 0, 5)
status.BackgroundTransparency = 1
status.Text = "🟢 GUI funcionando..."
status.TextColor3 = Color3.fromRGB(100, 255, 120)
status.TextSize = 14
status.Font = Enum.Font.Gotham
status.TextXAlignment = Enum.TextXAlignment.Left
status.ZIndex = 11
status.Parent = content

--============================================================
-- LISTA
--============================================================

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 1, -60)
list.Position = UDim2.new(0, 10, 0, 50)
list.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.ZIndex = 11
list.Parent = content

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.Name
layout.Parent = list

--============================================================
-- GUI ARRASTÁVEL
--============================================================

local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()

			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end

		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)

end)

--============================================================
-- MINIMIZAR
--============================================================

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized = not minimized

	if minimized then

		content.Visible = false
		main.Size = UDim2.new(0, 350, 0, 45)
		minimize.Text = "+"

	else

		content.Visible = true
		main.Size = UDim2.new(0, 350, 0, 430)
		minimize.Text = "—"

	end

end)

--============================================================
-- NORMALIZAR NOME
--============================================================

local function NormalizeName(name)

	name = tostring(name)

	name = name:gsub("^%s+", "")
	name = name:gsub("%s+$", "")

	-- Dragon Fruit -> Dragon
	local base = name:match("^(.-)%s+[Ff]ruit$")

	if base then
		name = base
	end

	return name
end

--============================================================
-- RECONHECER FRUTA
--============================================================

local function Recognize(object)

	if not object then
		return nil
	end

	local name = NormalizeName(object.Name)

	return FruitDictionary[string.lower(name)]
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

	return nil
end

--============================================================
-- PARTE DA FRUTA
--============================================================

local function GetPart(object)

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

local function CreateBillboard(object, fruitName)

	local part = GetPart(object)

	if not part then
		return nil
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "FruitName"
	billboard.Adornee = part
	billboard.Size = UDim2.new(0, 110, 0, 25)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 1000
	billboard.Parent = gui

	local text = Instance.new("TextLabel")
	text.Size = UDim2.fromScale(1, 1)
	text.BackgroundTransparency = 1
	text.Text = fruitName
	text.TextColor3 = Color3.new(1, 1, 1)
	text.TextStrokeTransparency = 0
	text.TextSize = 14
	text.Font = Enum.Font.GothamBold
	text.Parent = billboard

	return billboard
end

--============================================================
-- ITEM DA LISTA
--============================================================

local function CreateEntry(fruitName)

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1, -10, 0, 55)
	frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	frame.BorderSizePixel = 0
	frame.ZIndex = 12
	frame.Parent = list

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 8)
	c.Parent = frame

	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(1, -20, 0, 25)
	name.Position = UDim2.new(0, 10, 0, 3)
	name.BackgroundTransparency = 1
	name.Text = "🍏 " .. fruitName .. " Fruit"
	name.TextColor3 = Color3.new(1, 1, 1)
	name.TextSize = 15
	name.Font = Enum.Font.GothamBold
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.ZIndex = 13
	name.Parent = frame

	local distance = Instance.new("TextLabel")
	distance.Size = UDim2.new(1, -20, 0, 20)
	distance.Position = UDim2.new(0, 10, 0, 28)
	distance.BackgroundTransparency = 1
	distance.Text = "📍 Calculando..."
	distance.TextColor3 = Color3.fromRGB(100, 255, 120)
	distance.TextSize = 11
	distance.Font = Enum.Font.Gotham
	distance.TextXAlignment = Enum.TextXAlignment.Left
	distance.ZIndex = 13
	distance.Parent = frame

	return frame, distance
end

--============================================================
-- DADOS
--============================================================

local detected = {}

--============================================================
-- SCAN
--============================================================

local function Scan()

	local current = {}
	local amount = 0

	for _, object in ipairs(workspace:GetDescendants()) do

		local fruitName = Recognize(object)

		if fruitName then

			current[object] = true
			amount += 1

			if not detected[object] then

				local frame, distance =
					CreateEntry(fruitName)

				local billboard =
					CreateBillboard(
						object,
						fruitName
					)

				detected[object] = {
					Frame = frame,
					Distance = distance,
					Billboard = billboard,
					Name = fruitName
				}

			end
		end
	end

	-- Remover frutas antigas
	for object, data in pairs(detected) do

		if not current[object] then

			if data.Frame then
				data.Frame:Destroy()
			end

			if data.Billboard then
				data.Billboard:Destroy()
			end

			detected[object] = nil
		end
	end

	-- Status
	if amount > 0 then

		status.Text =
			"✅ " .. amount .. " fruta(s) encontrada(s)"

		status.TextColor3 =
			Color3.fromRGB(100, 255, 120)

	else

		status.Text =
			"🔎 Nenhuma das 42 frutas encontrada"

		status.TextColor3 =
			Color3.fromRGB(200, 200, 200)

	end

	task.defer(function()

		list.CanvasSize = UDim2.new(
			0,
			0,
			0,
			layout.AbsoluteContentSize.Y + 10
		)

	end)
end

--============================================================
-- DISTÂNCIAS
--============================================================

local function UpdateDistances()

	local character = player.Character

	if not character then
		return
	end

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(detected) do

		if object.Parent and data.Distance then

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
-- INICIALIZAÇÃO
--============================================================

-- O GUI já foi criado antes desta parte.
status.Text = "🟢 GUI carregado! Procurando frutas..."

task.wait(0.5)

Scan()

--============================================================
-- MONITORAMENTO
--============================================================

workspace.DescendantAdded:Connect(function()

	task.delay(0.15, function()

		if gui.Parent then
			Scan()
		end

	end)

end)

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
-- DISTÂNCIA
--============================================================

RunService.RenderStepped:Connect(function()

	if gui.Parent then
		UpdateDistances()
	end

end)
