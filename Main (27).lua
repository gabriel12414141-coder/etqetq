--============================================================
-- FRUIT NOTIFIER - TESTE CONTROLADO / MOBILE
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local RADIUS = 9000
local CHECK_INTERVAL = 0.5
local Enabled = true
local Minimized = false

-- Coloque aqui um SoundId permitido pelo seu jogo.
local SOUND_ID = "rbxassetid://0"

local FruitNames = {
	["Rocket"] = true,
	["Spin"] = true,
	["Blade"] = true,
	["Spring"] = true,
	["Bomb"] = true,
	["Smoke"] = true,
	["Spike"] = true,
	["Flame"] = true,
	["Ice"] = true,
	["Sand"] = true,
	["Dark"] = true,
	["Eagle"] = true,
	["Diamond"] = true,
	["Light"] = true,
	["Rubber"] = true,
	["Ghost"] = true,
	["Magma"] = true,
	["Quake"] = true,
	["Buddha"] = true,
	["Love"] = true,
	["Creation"] = true,
	["Spider"] = true,
	["Sound"] = true,
	["Phoenix"] = true,
	["Portal"] = true,
	["Lightning"] = true,
	["Pain"] = true,
	["Blizzard"] = true,
	["Gravity"] = true,
	["Mammoth"] = true,
	["T-Rex"] = true,
	["Dough"] = true,
	["Shadow"] = true,
	["Venom"] = true,
	["Gas"] = true,
	["Spirit"] = true,
	["Tiger"] = true,
	["Yeti"] = true,
	["Kitsune"] = true,
	["Control"] = true,
	["Dragon"] = true
}

--============================================================
-- DADOS
--============================================================

local KnownObjects = {}
local History = {}

--============================================================
-- GUI ANTIGO
--============================================================

local old = playerGui:FindFirstChild("FruitNotifierMobile")

if old then
	old:Destroy()
end

--============================================================
-- SCREEN GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "FruitNotifierMobile"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 100
gui.Parent = playerGui

--============================================================
-- MAIN
--============================================================

local main = Instance.new("Frame")
main.Name = "Main"

-- Responsivo
main.Size = UDim2.new(0.82, 0, 0.58, 0)
main.Position = UDim2.new(0.09, 0, 0.21, 0)

main.BackgroundColor3 = Color3.fromRGB(18,18,24)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,12)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65,65,80)
stroke.Thickness = 1
stroke.Parent = main

-- Limita o tamanho em telas muito grandes
local sizeConstraint = Instance.new("UISizeConstraint")
sizeConstraint.MinSize = Vector2.new(260,190)
sizeConstraint.MaxSize = Vector2.new(420,430)
sizeConstraint.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,52)
header.BackgroundColor3 = Color3.fromRGB(25,25,34)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-100,1,0)
title.Position = UDim2.fromOffset(12,0)
title.BackgroundTransparency = 1
title.Text = "🍎 Fruit Notifier"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(38,34)
minimize.Position = UDim2.new(1,-82,0,9)
minimize.BackgroundColor3 = Color3.fromRGB(45,45,58)
minimize.BorderSizePixel = 0
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,8)
minCorner.Parent = minimize

--============================================================
-- BOTÃO FECHAR GUI
--============================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(34,34)
close.Position = UDim2.new(1,-42,0,9)
close.BackgroundColor3 = Color3.fromRGB(120,45,50)
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 20
close.Font = Enum.Font.GothamBold
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,8)
closeCorner.Parent = close

--============================================================
-- CONTEÚDO
--============================================================

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1,0,1,-52)
content.Position = UDim2.fromOffset(0,52)
content.BackgroundTransparency = 1
content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("Frame")
status.Size = UDim2.new(1,-24,0,40)
status.Position = UDim2.fromOffset(12,10)
status.BackgroundColor3 = Color3.fromRGB(28,28,37)
status.BorderSizePixel = 0
status.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0,8)
statusCorner.Parent = status

local dot = Instance.new("TextLabel")
dot.Size = UDim2.fromOffset(25,40)
dot.Position = UDim2.fromOffset(7,0)
dot.BackgroundTransparency = 1
dot.Text = "●"
dot.TextColor3 = Color3.fromRGB(80,255,120)
dot.TextSize = 16
dot.Font = Enum.Font.GothamBold
dot.Parent = status

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1,-40,1,0)
statusText.Position = UDim2.fromOffset(35,0)
statusText.BackgroundTransparency = 1
statusText.Text = "ATIVO • 9000 studs"
statusText.TextColor3 = Color3.fromRGB(230,230,235)
statusText.TextSize = 12
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = status

--============================================================
-- TOGGLE
--============================================================

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-24,0,36)
toggle.Position = UDim2.fromOffset(12,58)
toggle.BackgroundColor3 = Color3.fromRGB(48,48,62)
toggle.BorderSizePixel = 0
toggle.Text = "DESATIVAR"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 12
toggle.Font = Enum.Font.GothamBold
toggle.Parent = content

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,8)
toggleCorner.Parent = toggle

--============================================================
-- TÍTULO HISTÓRICO
--============================================================

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1,-24,0,22)
historyTitle.Position = UDim2.fromOffset(12,103)
historyTitle.BackgroundTransparency = 1
historyTitle.Text = "HISTÓRICO"
historyTitle.TextColor3 = Color3.fromRGB(170,170,185)
historyTitle.TextSize = 11
historyTitle.Font = Enum.Font.GothamBold
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = content

--============================================================
-- HISTÓRICO
--============================================================

local history = Instance.new("ScrollingFrame")
history.Size = UDim2.new(1,-24,1,-135)
history.Position = UDim2.fromOffset(12,125)
history.BackgroundColor3 = Color3.fromRGB(12,12,17)
history.BorderSizePixel = 0
history.ScrollBarThickness = 3
history.CanvasSize = UDim2.new()
history.Parent = content

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0,8)
historyCorner.Parent = history

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,2)
layout.Parent = history

--============================================================
-- SOM
--============================================================

local sound = Instance.new("Sound")
sound.Name = "FruitDetectionSound"
sound.SoundId = SOUND_ID
sound.Volume = 1
sound.Parent = SoundService

local function playSound()

	if SOUND_ID == "rbxassetid://0" then
		return
	end

	pcall(function()
		sound:Play()
	end)
end

--============================================================
-- HISTÓRICO
--============================================================

local function updateCanvas()

	history.CanvasSize = UDim2.new(
		0,
		0,
		0,
		layout.AbsoluteContentSize.Y + 8
	)

	history.CanvasPosition = Vector2.new(
		0,
		math.max(0,layout.AbsoluteContentSize.Y)
	)
end

local function addHistory(text)

	local item = Instance.new("TextLabel")

	item.Size = UDim2.new(1,-8,0,28)
	item.BackgroundTransparency = 1
	item.Text = text
	item.TextColor3 = Color3.fromRGB(220,220,225)
	item.TextSize = 11
	item.Font = Enum.Font.Gotham
	item.TextXAlignment = Enum.TextXAlignment.Left

	item.Parent = history

	task.defer(updateCanvas)
end

--============================================================
-- POSIÇÃO
--============================================================

local function getPosition(object)

	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		return object:GetPivot().Position
	end

	return nil
end

--============================================================
-- NOTIFICAR
--============================================================

local function notifyFruit(name,distance)

	local time = os.date("%H:%M:%S")

	addHistory(
		"🍎 "..name..
		"  •  "..math.floor(distance)..
		" studs  •  "..time
	)

	playSound()

	pcall(function()

		StarterGui:SetCore("SendNotification",{
			Title = "🍎 FRUIT DETECTADA",
			Text = name.." • "..math.floor(distance).." studs",
			Duration = 5
		})

	end)
end

--============================================================
-- TOGGLE
--============================================================

toggle.MouseButton1Click:Connect(function()

	Enabled = not Enabled

	if Enabled then

		dot.TextColor3 = Color3.fromRGB(80,255,120)
		statusText.Text = "ATIVO • 9000 studs"
		toggle.Text = "DESATIVAR"

	else

		dot.TextColor3 = Color3.fromRGB(255,80,80)
		statusText.Text = "DESATIVADO"
		toggle.Text = "ATIVAR"

	end
end)

--============================================================
-- MINIMIZAR / RESTAURAR
--============================================================

local normalSize = main.Size
local normalPosition = main.Position

minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		normalSize = main.Size
		normalPosition = main.Position

		content.Visible = false

		main.Size = UDim2.new(
			0.82,0,
			0,52
		)

		main.Position = UDim2.new(
			normalPosition.X.Scale,
			normalPosition.X.Offset,
			normalPosition.Y.Scale,
			normalPosition.Y.Offset
		)

		minimize.Text = "+"

	else

		content.Visible = true
		main.Size = normalSize
		main.Position = normalPosition
		minimize.Text = "−"

	end
end)

--============================================================
-- FECHAR
--============================================================

close.Activated:Connect(function()
	gui:Destroy()
end)

--============================================================
-- ARRASTAR POR MOUSE OU TOQUE
--============================================================

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

	if input.UserInputType ~= Enum.UserInputType.MouseMovement
		and input.UserInputType ~= Enum.UserInputType.Touch then
		return
	end

	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)
end)

--============================================================
-- DETECTOR
--============================================================

local elapsed = 0

RunService.Heartbeat:Connect(function(delta)

	if not Enabled then
		return
	end

	elapsed += delta

	if elapsed < CHECK_INTERVAL then
		return
	end

	elapsed = 0

	local character = player.Character
	if not character then
		return
	end

	local root = character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end

	for _,object in ipairs(workspace:GetDescendants()) do

		if FruitNames[object.Name] then

			local position = getPosition(object)

			if position then

				local distance =
					(root.Position - position).Magnitude

				if distance <= RADIUS then

					if not KnownObjects[object] then

						KnownObjects[object] = {
							Name = object.Name,
							FirstSeen = os.time()
						}

						notifyFruit(
							object.Name,
							distance
						)
					end
				end
			end
		end
	end
end)

--============================================================
-- FRUTAS REMOVIDAS
--============================================================

task.spawn(function()

	while task.wait(2) do

		for object,data in pairs(KnownObjects) do

			if object.Parent == nil then

				addHistory(
					"🗑️ "..data.Name.." saiu do mapa"
				)

				KnownObjects[object] = nil
			end
		end
	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

addHistory("✓ Detector iniciado")
addHistory("✓ Raio: 9.000 studs")
addHistory("✓ 42 frutas configuradas")
addHistory("✓ Toque/mouse: arrastar")
