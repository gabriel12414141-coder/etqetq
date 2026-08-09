--============================================================
-- FRUIT NOTIFIER - TESTE CONTROLADO
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

-- Som de teste.
-- Substitua pelo ID de um áudio permitido no seu próprio jogo.
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
-- HISTÓRICO
--============================================================

local FruitHistory = {}
local KnownObjects = {}

--============================================================
-- REMOVE GUI ANTIGO
--============================================================

local old = playerGui:FindFirstChild("FruitNotifierGUI")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "FruitNotifierGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(430, 520)
main.Position = UDim2.new(0.5, -215, 0.5, -260)
main.BackgroundColor3 = Color3.fromRGB(18,18,24)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,14)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65,65,80)
stroke.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,75)
header.BackgroundColor3 = Color3.fromRGB(25,25,34)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-30,0,35)
title.Position = UDim2.fromOffset(15,8)
title.BackgroundTransparency = 1
title.Text = "🍎  FRUIT NOTIFIER"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1,-30,0,20)
subtitle.Position = UDim2.fromOffset(15,45)
subtitle.BackgroundTransparency = 1
subtitle.Text = "TESTE • Raio: 9.000 studs"
subtitle.TextColor3 = Color3.fromRGB(150,150,165)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

--============================================================
-- STATUS
--============================================================

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1,-30,0,55)
statusFrame.Position = UDim2.fromOffset(15,90)
statusFrame.BackgroundColor3 = Color3.fromRGB(28,28,37)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = main

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0,10)
statusCorner.Parent = statusFrame

local statusDot = Instance.new("TextLabel")
statusDot.Size = UDim2.fromOffset(30,55)
statusDot.Position = UDim2.fromOffset(10,0)
statusDot.BackgroundTransparency = 1
statusDot.Text = "●"
statusDot.TextColor3 = Color3.fromRGB(80,255,120)
statusDot.TextSize = 20
statusDot.Font = Enum.Font.GothamBold
statusDot.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1,-55,1,0)
statusText.Position = UDim2.fromOffset(45,0)
statusText.BackgroundTransparency = 1
statusText.Text = "NOTIFICADOR ATIVO"
statusText.TextColor3 = Color3.fromRGB(230,230,235)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusFrame

--============================================================
-- BOTÃO
--============================================================

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-30,0,42)
toggle.Position = UDim2.fromOffset(15,160)
toggle.BackgroundColor3 = Color3.fromRGB(45,45,58)
toggle.BorderSizePixel = 0
toggle.Text = "DESATIVAR"
toggle.TextColor3 = Color3.new(1,1,1)
toggle.TextSize = 14
toggle.Font = Enum.Font.GothamBold
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0,9)
toggleCorner.Parent = toggle

--============================================================
-- TÍTULO DO HISTÓRICO
--============================================================

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1,-30,0,25)
historyTitle.Position = UDim2.fromOffset(15,215)
historyTitle.BackgroundTransparency = 1
historyTitle.Text = "FRUTAS OBSERVADAS"
historyTitle.TextColor3 = Color3.fromRGB(170,170,185)
historyTitle.TextSize = 12
historyTitle.Font = Enum.Font.GothamBold
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = main

--============================================================
-- HISTÓRICO
--============================================================

local history = Instance.new("ScrollingFrame")
history.Size = UDim2.new(1,-30,0,240)
history.Position = UDim2.fromOffset(15,245)
history.BackgroundColor3 = Color3.fromRGB(12,12,17)
history.BorderSizePixel = 0
history.ScrollBarThickness = 4
history.CanvasSize = UDim2.new()
history.Parent = main

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0,9)
historyCorner.Parent = history

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,3)
layout.Parent = history

--============================================================
-- SOM
--============================================================

local sound = Instance.new("Sound")
sound.Name = "FruitDetectionSound"
sound.SoundId = SOUND_ID
sound.Volume = 1
sound.Parent = SoundService

local function playDetectionSound()

	if SOUND_ID == "rbxassetid://0" then
		return
	end

	pcall(function()
		sound:Play()
	end)
end

--============================================================
-- HISTÓRICO GUI
--============================================================

local function refreshCanvas()

	history.CanvasSize = UDim2.new(
		0,
		0,
		0,
		layout.AbsoluteContentSize.Y + 10
	)

	history.CanvasPosition = Vector2.new(
		0,
		math.max(0,layout.AbsoluteContentSize.Y)
	)
end

local function addHistory(text)

	local item = Instance.new("TextLabel")

	item.Size = UDim2.new(1,-10,0,32)
	item.BackgroundTransparency = 1

	item.Text = text
	item.TextColor3 = Color3.fromRGB(220,220,225)
	item.TextSize = 12
	item.Font = Enum.Font.Gotham
	item.TextXAlignment = Enum.TextXAlignment.Left

	item.Parent = history

	task.defer(refreshCanvas)
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
-- NOTIFICAÇÃO
--============================================================

local function notifyFruit(name,distance)

	local time = os.date("%H:%M:%S")

	addHistory(
		"🍎  "..name..
		"   |   "..math.floor(distance)..
		" studs   |   "..time
	)

	playDetectionSound()

	pcall(function()

		StarterGui:SetCore("SendNotification",{
			Title = "🍎 FRUIT DETECTADA",
			Text = name.." • "..math.floor(distance).." studs",
			Duration = 5
		})

	end)
end

--============================================================
-- REGISTRAR FRUTA
--============================================================

local function registerFruit(object,distance)

	if KnownObjects[object] then
		return
	end

	KnownObjects[object] = {
		Name = object.Name,
		FirstSeen = os.time(),
		LastDistance = distance
	}

	table.insert(FruitHistory,KnownObjects[object])

	notifyFruit(object.Name,distance)
end

--============================================================
-- TOGGLE
--============================================================

toggle.MouseButton1Click:Connect(function()

	Enabled = not Enabled

	if Enabled then

		statusDot.TextColor3 = Color3.fromRGB(80,255,120)
		statusText.Text = "NOTIFICADOR ATIVO"
		toggle.Text = "DESATIVAR"

		addHistory("✓ Detector ativado")

	else

		statusDot.TextColor3 = Color3.fromRGB(255,80,80)
		statusText.Text = "NOTIFICADOR DESATIVADO"
		toggle.Text = "ATIVAR"

		addHistory("✕ Detector desativado")
	end
end)

--============================================================
-- DETECTOR
--============================================================

local timer = 0

RunService.Heartbeat:Connect(function(delta)

	if not Enabled then
		return
	end

	timer += delta

	if timer < CHECK_INTERVAL then
		return
	end

	timer = 0

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
					(root.Position-position).Magnitude

				if distance <= RADIUS then

					if not KnownObjects[object] then
						registerFruit(object,distance)
					else
						KnownObjects[object].LastDistance = distance
					end
				end
			end
		end
	end
end)

--============================================================
-- LIMPEZA DE OBJETOS REMOVIDOS
--============================================================

task.spawn(function()

	while task.wait(2) do

		for object,data in pairs(KnownObjects) do

			if object.Parent == nil then

				addHistory(
					"🗑️  "..data.Name..
					" desapareceu do mapa"
				)

				KnownObjects[object] = nil
			end
		end
	end
end)

--============================================================
-- ARRASTAR GUI
--============================================================

local dragging = false
local dragStart
local startPosition

header.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1 then

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

	if not dragging then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.MouseMovement then
		return
	end

	local delta = input.Position-dragStart

	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset+delta.X,
		startPosition.Y.Scale,
		startPosition.Y.Offset+delta.Y
	)
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

addHistory("✓ Fruit Notifier iniciado")
addHistory("✓ Raio: 9.000 studs")
addHistory("✓ 42 frutas na whitelist")
addHistory("✓ Histórico iniciado")
