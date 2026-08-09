--============================================================
-- FRUIT NOTIFIER - COMPACT MOBILE
-- TESTE CONTROLADO - ROBLOX STUDIO
-- LocalScript
--============================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local RADIUS = 9000
local CHECK_INTERVAL = 0.5
local Enabled = true
local Minimized = false

-- Coloque um SoundId autorizado pelo seu jogo.
local SOUND_ID = "rbxassetid://0"

local Fruits = {
	Rocket=true, Spin=true, Blade=true, Spring=true,
	Bomb=true, Smoke=true, Spike=true, Flame=true,
	Ice=true, Sand=true, Dark=true, Eagle=true,
	Diamond=true, Light=true, Rubber=true, Ghost=true,
	Magma=true, Quake=true, Buddha=true, Love=true,
	Creation=true, Spider=true, Sound=true, Phoenix=true,
	Portal=true, Lightning=true, Pain=true, Blizzard=true,
	Gravity=true, Mammoth=true, ["T-Rex"]=true,
	Dough=true, Shadow=true, Venom=true, Gas=true,
	Spirit=true, Tiger=true, Yeti=true, Kitsune=true,
	Control=true, Dragon=true
}

--============================================================
-- REMOVE GUI ANTERIOR
--============================================================

local old = playerGui:FindFirstChild("CompactFruitNotifier")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "CompactFruitNotifier"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

-- Janela pequena
local main = Instance.new("Frame")
main.Size = UDim2.new(0.72, 0, 0, 245)
main.Position = UDim2.new(0.14, 0, 0.68, 0)
main.BackgroundColor3 = Color3.fromRGB(18,18,24)
main.BorderSizePixel = 0
main.Parent = gui

local constraint = Instance.new("UISizeConstraint")
constraint.MinSize = Vector2.new(250,80)
constraint.MaxSize = Vector2.new(360,280)
constraint.Parent = main

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,10)
corner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60,60,75)
stroke.Thickness = 1
stroke.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(25,25,34)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-80,1,0)
title.Position = UDim2.fromOffset(10,0)
title.BackgroundTransparency = 1
title.Text = "🍎 Fruit Notifier"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 15
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

--============================================================
-- MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(30,28)
minimize.Position = UDim2.new(1,-65,0,6)
minimize.BackgroundColor3 = Color3.fromRGB(45,45,58)
minimize.BorderSizePixel = 0
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,6)
minCorner.Parent = minimize

--============================================================
-- FECHAR
--============================================================

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(28,28)
close.Position = UDim2.new(1,-33,0,6)
close.BackgroundColor3 = Color3.fromRGB(110,45,50)
close.BorderSizePixel = 0
close.Text = "×"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 18
close.Font = Enum.Font.GothamBold
close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,6)
closeCorner.Parent = close

--============================================================
-- CONTEÚDO
--============================================================

local content = Instance.new("Frame")
content.Size = UDim2.new(1,0,1,-40)
content.Position = UDim2.fromOffset(0,40)
content.BackgroundTransparency = 1
content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1,-20,0,28)
status.Position = UDim2.fromOffset(10,7)
status.BackgroundColor3 = Color3.fromRGB(28,28,37)
status.BorderSizePixel = 0
status.Text = "● ATIVO  •  9000 studs"
status.TextColor3 = Color3.fromRGB(80,255,120)
status.TextSize = 11
status.Font = Enum.Font.GothamBold
status.Parent = content

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0,6)
statusCorner.Parent = status

--============================================================
-- HISTÓRICO
--============================================================

local history = Instance.new("ScrollingFrame")
history.Size = UDim2.new(1,-20,1,-75)
history.Position = UDim2.fromOffset(10,42)
history.BackgroundColor3 = Color3.fromRGB(11,11,16)
history.BorderSizePixel = 0
history.ScrollBarThickness = 2
history.CanvasSize = UDim2.new()
history.Parent = content

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0,7)
historyCorner.Parent = history

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,1)
layout.Parent = history

--============================================================
-- SOM
--============================================================

local sound = Instance.new("Sound")
sound.Name = "FruitNotifySound"
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

local function addHistory(text)

	local label = Instance.new("TextLabel")

	label.Size = UDim2.new(1,-6,0,23)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = Color3.fromRGB(220,220,225)
	label.TextSize = 10
	label.Font = Enum.Font.Gotham
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = history

	task.defer(function()

		history.CanvasSize = UDim2.new(
			0,0,
			0,
			layout.AbsoluteContentSize.Y + 5
		)

		history.CanvasPosition = Vector2.new(
			0,
			math.max(0,layout.AbsoluteContentSize.Y)
		)

	end)
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
-- ESTADO
--============================================================

local Known = {}

--============================================================
-- NOTIFICAÇÃO
--============================================================

local function notify(name,distance,existing)

	local prefix

	if existing then
		prefix = "📦 EXISTENTE"
	else
		prefix = "🆕 NOVO SPAWN"
		playSound()
	end

	addHistory(
		prefix ..
		"  " ..
		name ..
		"  •  " ..
		math.floor(distance) ..
		"m"
	)

	pcall(function()

		StarterGui:SetCore("SendNotification",{
			Title = "🍎 "..prefix,
			Text = name.." • "..math.floor(distance).." studs",
			Duration = 4
		})

	end)
end

--============================================================
-- DETECTOR
--============================================================

local firstScan = true
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

		if Fruits[object.Name] then

			local position = getPosition(object)

			if position then

				local distance =
					(root.Position-position).Magnitude

				if distance <= RADIUS then

					if not Known[object] then

						Known[object] = {
							Name = object.Name,
							SpawnTime = os.time()
						}

						notify(
							object.Name,
							distance,
							firstScan
						)
					end
				end
			end
		end
	end

	firstScan = false
end)

--============================================================
-- DESPAWN
--============================================================

task.spawn(function()

	while task.wait(1) do

		for object,data in pairs(Known) do

			if object.Parent == nil then

				addHistory(
					"🗑️ "..data.Name.." • DESPAWN"
				)

				Known[object] = nil
			end
		end
	end
end)

--============================================================
-- TOGGLE PELO STATUS
--============================================================

status.Activated:Connect(function()

	Enabled = not Enabled

	if Enabled then

		status.Text = "● ATIVO  •  9000 studs"
		status.TextColor3 = Color3.fromRGB(80,255,120)

	else

		status.Text = "● DESATIVADO"
		status.TextColor3 = Color3.fromRGB(255,80,80)

	end
end)

--============================================================
-- MINIMIZAR
--============================================================

local normalSize = main.Size

minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		content.Visible = false
		main.Size = UDim2.new(
			0.72,0,
			0,40
		)

		minimize.Text = "+"

	else

		content.Visible = true
		main.Size = normalSize

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
-- ARRASTAR: TOUCH + MOUSE
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

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false
	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

addHistory("✓ Detector iniciado")
addHistory("✓ Raio: 9000 studs")
addHistory("✓ Frutas existentes serão registradas")
