```lua
--============================================================
-- DRAGON FRUIT NOTIFIER
-- TESTE CONTROLADO
-- LocalScript
--============================================================

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local FRUIT_NAME = "Dragon Fruit"

local RADIUS = 9000
local CHECK_INTERVAL = 0.5

local Enabled = true
local Minimized = false

-- Coloque aqui um áudio autorizado pelo seu próprio jogo.
local SOUND_ID = "rbxassetid://0"

--============================================================
-- LIMPAR GUI ANTERIOR
--============================================================

local old = playerGui:FindFirstChild("DragonFruitNotifier")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")
gui.Name = "DragonFruitNotifier"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 999
gui.Parent = playerGui

--============================================================
-- JANELA
--============================================================

local main = Instance.new("Frame")

main.Name = "Main"
main.Size = UDim2.fromOffset(270,210)
main.Position = UDim2.new(0.5,-135,0.65,0)

main.BackgroundColor3 = Color3.fromRGB(18,18,24)
main.BorderSizePixel = 0

main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,10)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(65,65,80)
stroke.Thickness = 1
stroke.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")

header.Name = "Header"
header.Size = UDim2.new(1,0,0,38)

header.BackgroundColor3 = Color3.fromRGB(25,25,34)
header.BorderSizePixel = 0

header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,10)
headerCorner.Parent = header

--============================================================
-- ÁREA DE ARRASTE
--============================================================

local dragArea = Instance.new("TextButton")

dragArea.Name = "DragArea"

dragArea.Size = UDim2.new(1,-72,1,0)
dragArea.Position = UDim2.fromOffset(0,0)

dragArea.BackgroundTransparency = 1
dragArea.BorderSizePixel = 0

dragArea.Text = "🐉  Dragon Fruit"
dragArea.TextColor3 = Color3.new(1,1,1)
dragArea.TextSize = 14
dragArea.Font = Enum.Font.GothamBold
dragArea.TextXAlignment = Enum.TextXAlignment.Left

dragArea.Parent = header

--============================================================
-- MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")

minimize.Name = "Minimize"

minimize.Size = UDim2.fromOffset(30,28)
minimize.Position = UDim2.new(1,-67,0,5)

minimize.BackgroundColor3 = Color3.fromRGB(50,50,63)
minimize.BorderSizePixel = 0

minimize.Text = "−"
minimize.TextColor3 = Color3.new(1,1,1)
minimize.TextSize = 18
minimize.Font = Enum.Font.GothamBold

minimize.Parent = header

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0,6)
minimizeCorner.Parent = minimize

--============================================================
-- FECHAR
--============================================================

local close = Instance.new("TextButton")

close.Name = "Close"

close.Size = UDim2.fromOffset(30,28)
close.Position = UDim2.new(1,-34,0,5)

close.BackgroundColor3 = Color3.fromRGB(120,45,50)
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

content.Name = "Content"

content.Size = UDim2.new(1,0,1,-38)
content.Position = UDim2.fromOffset(0,38)

content.BackgroundTransparency = 1

content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextButton")

status.Name = "Status"

status.Size = UDim2.new(1,-20,0,30)
status.Position = UDim2.fromOffset(10,8)

status.BackgroundColor3 = Color3.fromRGB(30,30,40)
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

history.Name = "History"

history.Size = UDim2.new(1,-20,1,-50)
history.Position = UDim2.fromOffset(10,45)

history.BackgroundColor3 = Color3.fromRGB(10,10,15)
history.BorderSizePixel = 0

history.ScrollBarThickness = 2
history.CanvasSize = UDim2.new(0,0,0,0)

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

sound.Name = "DragonFruitSound"
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

	label.Size = UDim2.new(1,-6,0,22)

	label.BackgroundTransparency = 1

	label.Text = text
	label.TextColor3 = Color3.fromRGB(220,220,225)

	label.TextSize = 10
	label.Font = Enum.Font.Gotham

	label.TextXAlignment = Enum.TextXAlignment.Left

	label.Parent = history

	task.defer(function()

		history.CanvasSize = UDim2.new(
			0,
			0,
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
-- POSIÇÃO DO OBJETO
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
-- DETECTOR EXATO
--============================================================

local function isDragonFruit(object)

	-- Somente Model ou BasePart
	if not object:IsA("Model")
		and not object:IsA("BasePart") then

		return false
	end

	-- Nome EXATAMENTE igual
	if object.Name ~= FRUIT_NAME then
		return false
	end

	-- Evita detectar objeto interno de outro Dragon Fruit
	local parent = object.Parent

	while parent and parent ~= workspace do

		if parent.Name == FRUIT_NAME then
			return false
		end

		parent = parent.Parent
	end

	return true
end

--============================================================
-- REGISTRO
--============================================================

local Known = {}

local firstScan = true
local timer = 0

--============================================================
-- NOTIFICAÇÃO
--============================================================

local function notify(distance,existing)

	local prefix

	if existing then
		prefix = "📦 EXISTENTE"
	else
		prefix = "🆕 NOVO SPAWN"
		playSound()
	end

	addHistory(
		prefix
		.."  Dragon Fruit"
		.."  •  "
		..math.floor(distance)
		.." studs"
	)

	pcall(function()

		StarterGui:SetCore(
			"SendNotification",
			{
				Title = "🐉 "..prefix,
				Text = "Dragon Fruit • "
					..math.floor(distance)
					.." studs",
				Duration = 4
			}
		)

	end)
end

--============================================================
-- DETECÇÃO
--============================================================

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

	local root =
		character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for _,object in ipairs(workspace:GetDescendants()) do

		if isDragonFruit(object) then

			local position = getPosition(object)

			if position then

				local distance =
					(root.Position-position).Magnitude

				if distance <= RADIUS then

					if not Known[object] then

						Known[object] = {
							FirstSeen = os.time()
						}

						notify(
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

		for object in pairs(Known) do

			if object.Parent == nil then

				addHistory(
					"🗑️ Dragon Fruit • DESPAWN"
				)

				Known[object] = nil
			end
		end
	end
end)

--============================================================
-- ATIVAR / DESATIVAR
--============================================================

status.Activated:Connect(function()

	Enabled = not Enabled

	if Enabled then

		status.Text = "● ATIVO  •  9000 studs"
		status.TextColor3 =
			Color3.fromRGB(80,255,120)

	else

		status.Text = "● DESATIVADO"
		status.TextColor3 =
			Color3.fromRGB(255,80,80)

	end
end)

--============================================================
-- MINIMIZAR
--============================================================

local expandedSize = main.Size

minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		content.Visible = false

		main.Size =
			UDim2.fromOffset(270,38)

		minimize.Text = "+"

	else

		content.Visible = true

		main.Size = expandedSize

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
-- ARRASTAR
-- TOUCH + MOUSE
--============================================================

local dragging = false
local dragStart
local startPosition

dragArea.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart = input.Position
		startPosition = main.Position

	end
end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ~=
		Enum.UserInputType.MouseMovement
		and input.UserInputType ~=
		Enum.UserInputType.Touch then

		return
	end

	local delta =
		input.Position - dragStart

	main.Position = UDim2.new(
		startPosition.X.Scale,
		startPosition.X.Offset + delta.X,

		startPosition.Y.Scale,
		startPosition.Y.Offset + delta.Y
	)

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

addHistory("✓ Dragon Fruit detector iniciado")
addHistory("✓ Procurando nome exato: Dragon Fruit")
addHistory("✓ Raio: 9000 studs")
```

### O detector agora é estrito

Ele **não** considera:

* `Dragon`
* `DragonFruit`
* `Dragon Fruit Model`
* `Dragon Fruit Handle`
* `Dragon Fruit Tool`

Ele só considera um `Model` ou `BasePart` cujo nome seja exatamente:

```text
Dragon Fruit
```

E o GUI continua podendo ser **arrastado pelo título** e **minimizado pelo `−`**.
