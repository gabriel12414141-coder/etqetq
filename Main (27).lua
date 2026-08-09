```lua
--============================================================
-- FRUIT NOTIFIER - TEST PLACE
-- GUI PRIMEIRO / DETECTOR DEPOIS
--
-- USO:
-- LocalScript em:
-- StarterPlayer
--   └─ StarterPlayerScripts
--
-- Detecta EXATAMENTE:
-- "Rocket Fruit"
-- "Spin Fruit"
-- ...
-- "Dragon Fruit"
--============================================================

--============================================================
-- SERVICES
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

--============================================================
-- PLAYER
--============================================================

local player = Players.LocalPlayer

if not player then
	warn("[FruitNotifier] LocalPlayer não encontrado.")
	return
end

local playerGui = player:WaitForChild("PlayerGui",10)

if not playerGui then
	warn("[FruitNotifier] PlayerGui não encontrado.")
	return
end

--============================================================
-- CONFIG
--============================================================

local GUI_NAME = "FruitNotifier_Test"

local RADIUS = 9000

local CHECK_INTERVAL = 0.5

local Enabled = true

local Minimized = false

--============================================================
-- FRUTAS
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
-- LOOKUP
--============================================================

local FruitLookup = {}

for _,name in ipairs(FruitNames) do

	local fullName = name .. " Fruit"

	FruitLookup[fullName] = fullName

end

--============================================================
-- LIMPAR GUI ANTERIOR
--============================================================

local oldGui = playerGui:FindFirstChild(GUI_NAME)

if oldGui then
	oldGui:Destroy()
end

--============================================================
-- SCREEN GUI
--============================================================

local gui = Instance.new("ScreenGui")

gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--============================================================
-- MAIN
--============================================================

local main = Instance.new("Frame")

main.Name = "Main"

main.Size = UDim2.fromOffset(260,195)

main.Position =
	UDim2.new(
		0.5,
		-130,
		0.5,
		-97
	)

main.BackgroundColor3 =
	Color3.fromRGB(18,18,24)

main.BorderSizePixel = 0

main.Active = true

main.Parent = gui

--============================================================
-- MAIN CORNER
--============================================================

local mainCorner = Instance.new("UICorner")

mainCorner.CornerRadius =
	UDim.new(0,10)

mainCorner.Parent = main

--============================================================
-- MAIN STROKE
--============================================================

local mainStroke = Instance.new("UIStroke")

mainStroke.Color =
	Color3.fromRGB(65,65,80)

mainStroke.Thickness = 1

mainStroke.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")

header.Name = "Header"

header.Size =
	UDim2.new(1,0,0,38)

header.BackgroundColor3 =
	Color3.fromRGB(27,27,36)

header.BorderSizePixel = 0

header.Active = true

header.Parent = main

--============================================================
-- HEADER CORNER
--============================================================

local headerCorner = Instance.new("UICorner")

headerCorner.CornerRadius =
	UDim.new(0,10)

headerCorner.Parent = header

--============================================================
-- TITLE / DRAG BUTTON
--============================================================

local dragButton = Instance.new("TextButton")

dragButton.Name = "DragButton"

dragButton.Size =
	UDim2.new(1,-68,1,0)

dragButton.Position =
	UDim2.fromOffset(0,0)

dragButton.BackgroundTransparency = 1

dragButton.BorderSizePixel = 0

dragButton.Text =
	"🍎  Fruit Notifier"

dragButton.TextColor3 =
	Color3.fromRGB(255,255,255)

dragButton.TextSize = 14

dragButton.Font =
	Enum.Font.GothamBold

dragButton.TextXAlignment =
	Enum.TextXAlignment.Left

dragButton.AutoButtonColor = false

dragButton.Active = true

dragButton.Parent = header

--============================================================
-- MINIMIZE
--============================================================

local minimize = Instance.new("TextButton")

minimize.Name = "Minimize"

minimize.Size =
	UDim2.fromOffset(28,28)

minimize.Position =
	UDim2.new(1,-62,0,5)

minimize.BackgroundColor3 =
	Color3.fromRGB(52,52,65)

minimize.BorderSizePixel = 0

minimize.Text = "−"

minimize.TextColor3 =
	Color3.fromRGB(255,255,255)

minimize.TextSize = 18

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = header

local minCorner = Instance.new("UICorner")

minCorner.CornerRadius =
	UDim.new(0,6)

minCorner.Parent = minimize

--============================================================
-- CLOSE
--============================================================

local close = Instance.new("TextButton")

close.Name = "Close"

close.Size =
	UDim2.fromOffset(28,28)

close.Position =
	UDim2.new(1,-32,0,5)

close.BackgroundColor3 =
	Color3.fromRGB(120,45,50)

close.BorderSizePixel = 0

close.Text = "×"

close.TextColor3 =
	Color3.fromRGB(255,255,255)

close.TextSize = 18

close.Font =
	Enum.Font.GothamBold

close.Parent = header

local closeCorner = Instance.new("UICorner")

closeCorner.CornerRadius =
	UDim.new(0,6)

closeCorner.Parent = close

--============================================================
-- CONTENT
--============================================================

local content = Instance.new("Frame")

content.Name = "Content"

content.Size =
	UDim2.new(1,0,1,-38)

content.Position =
	UDim2.fromOffset(0,38)

content.BackgroundTransparency = 1

content.Parent = main

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextButton")

status.Name = "Status"

status.Size =
	UDim2.new(1,-20,0,30)

status.Position =
	UDim2.fromOffset(10,7)

status.BackgroundColor3 =
	Color3.fromRGB(31,31,41)

status.BorderSizePixel = 0

status.Text =
	"● ATIVO • 9000 studs"

status.TextColor3 =
	Color3.fromRGB(80,255,120)

status.TextSize = 11

status.Font =
	Enum.Font.GothamBold

status.Parent = content

local statusCorner = Instance.new("UICorner")

statusCorner.CornerRadius =
	UDim.new(0,6)

statusCorner.Parent = status

--============================================================
-- HISTORY
--============================================================

local history = Instance.new("ScrollingFrame")

history.Name = "History"

history.Size =
	UDim2.new(1,-20,1,-46)

history.Position =
	UDim2.fromOffset(10,43)

history.BackgroundColor3 =
	Color3.fromRGB(10,10,15)

history.BorderSizePixel = 0

history.ScrollBarThickness = 2

history.ScrollBarImageTransparency = 0.25

history.CanvasSize =
	UDim2.new(0,0,0,0)

history.AutomaticCanvasSize =
	Enum.AutomaticSize.Y

history.Parent = content

local historyCorner = Instance.new("UICorner")

historyCorner.CornerRadius =
	UDim.new(0,7)

historyCorner.Parent = history

local layout = Instance.new("UIListLayout")

layout.Padding =
	UDim.new(0,1)

layout.SortOrder =
	Enum.SortOrder.LayoutOrder

layout.Parent = history

--============================================================
-- HISTORY FUNCTION
--============================================================

local function addHistory(text)

	if not history or not history.Parent then
		return
	end

	local label = Instance.new("TextLabel")

	label.Size =
		UDim2.new(1,-6,0,21)

	label.BackgroundTransparency = 1

	label.Text = text

	label.TextColor3 =
		Color3.fromRGB(220,220,225)

	label.TextSize = 10

	label.Font =
		Enum.Font.Gotham

	label.TextXAlignment =
		Enum.TextXAlignment.Left

	label.TextTruncate =
		Enum.TextTruncate.AtEnd

	label.Parent = history

	task.defer(function()

		if history.Parent then

			history.CanvasPosition =
				Vector2.new(
					0,
					math.max(
						0,
						history.AbsoluteCanvasSize.Y
					)
				)

		end

	end)

end

--============================================================
-- GUI TESTE IMEDIATO
--============================================================

addHistory("✓ GUI carregada")
addHistory("✓ 42 frutas configuradas")
addHistory("✓ Formato: Nome Fruit")

--============================================================
-- DRAG SYSTEM
--============================================================

local dragging = false

local dragInput = nil

local dragStart = nil

local startPosition = nil

local function updateDrag(input)

	if not dragging then
		return
	end

	if not dragStart or not startPosition then
		return
	end

	local delta =
		input.Position - dragStart

	main.Position =
		UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,

			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)

end

dragButton.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart =
			input.Position

		startPosition =
			main.Position

		dragInput = input

	end

end)

dragButton.InputChanged:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragInput = input

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if dragging
		and input == dragInput then

		updateDrag(input)

	elseif dragging
		and input.UserInputType ==
			Enum.UserInputType.MouseMovement then

		updateDrag(input)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false
		dragInput = nil

	end

end)

--============================================================
-- MINIMIZE
--============================================================

local normalSize =
	UDim2.fromOffset(260,195)

local minimizedSize =
	UDim2.fromOffset(260,38)

minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		content.Visible = false

		main.Size =
			minimizedSize

		minimize.Text = "+"

	else

		content.Visible = true

		main.Size =
			normalSize

		minimize.Text = "−"

	end

end)

--============================================================
-- CLOSE
--============================================================

close.Activated:Connect(function()

	gui:Destroy()

end)

--============================================================
-- ENABLE/DISABLE
--============================================================

status.Activated:Connect(function()

	Enabled = not Enabled

	if Enabled then

		status.Text =
			"● ATIVO • 9000 studs"

		status.TextColor3 =
			Color3.fromRGB(80,255,120)

		addHistory("✓ Detector ativado")

	else

		status.Text =
			"● DESATIVADO"

		status.TextColor3 =
			Color3.fromRGB(255,80,80)

		addHistory("✕ Detector desativado")

	end

end)

--============================================================
-- SAFE POSITION
--============================================================

local function getPosition(object)

	if not object then
		return nil
	end

	if object:IsA("BasePart") then

		return object.Position

	end

	if object:IsA("Model") then

		local success,result =
			pcall(function()
				return object:GetPivot().Position
			end)

		if success then
			return result
		end

	end

	return nil

end

--============================================================
-- EXACT FRUIT CHECK
--============================================================

local function getFruitName(object)

	if not object then
		return nil
	end

	if not object:IsA("Model")
		and not object:IsA("BasePart") then

		return nil
	end

	-- O nome precisa ser EXATAMENTE:
	--
	-- Rocket Fruit
	-- Dragon Fruit
	-- Dough Fruit
	-- etc.

	return FruitLookup[object.Name]

end

--============================================================
-- NOTIFICATION
--============================================================

local function notify(fruitName,distance,existing)

	local prefix

	if existing then
		prefix = "📦 EXISTENTE"
	else
		prefix = "🆕 NOVO SPAWN"
	end

	local distanceText =
		math.floor(distance)

	local historyText =
		prefix
		.." • "
		..fruitName
		.." • "
		..distanceText
		.." studs"

	addHistory(historyText)

	pcall(function()

		StarterGui:SetCore(
			"SendNotification",
			{
				Title = "🍎 Fruit Notifier",

				Text =
					fruitName
					.." • "
					..distanceText
					.." studs",

				Duration = 5
			}
		)

	end)

end

--============================================================
-- DETECTOR
--============================================================

local Known = {}

local firstScan = true

--============================================================
-- DETECTOR LOOP
--============================================================

task.spawn(function()

	-- GUI ganha prioridade
	task.wait(1)

	addHistory("✓ Detector iniciado")

	while gui.Parent do

		task.wait(CHECK_INTERVAL)

		if not Enabled then
			continue
		end

		local character =
			player.Character

		if not character then
			continue
		end

		local root =
			character:FindFirstChild(
				"HumanoidRootPart"
			)

		if not root then
			continue
		end

		-- Protege o loop contra erros
		pcall(function()

			for _,object in ipairs(
				workspace:GetDescendants()
			) do

				local fruitName =
					getFruitName(object)

				if fruitName then

					local position =
						getPosition(object)

					if position then

						local distance =
							(
								root.Position
								- position
							).Magnitude

						if distance <= RADIUS then

							if not Known[object] then

								Known[object] = {
									Name = fruitName
								}

								notify(
									fruitName,
									distance,
									firstScan
								)

							end

						end

					end

				end

			end

		end)

		firstScan = false

	end

end)

--============================================================
-- DESPAWN CLEANUP
--============================================================

task.spawn(function()

	while gui.Parent do

		task.wait(2)

		for object,data in pairs(Known) do

			if object.Parent == nil then

				Known[object] = nil

			end

		end

	end

end)

--============================================================
-- FINAL
--============================================================

addHistory("✓ Sistema pronto")
```
