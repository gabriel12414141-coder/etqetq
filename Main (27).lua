```lua
--============================================================
-- FRUIT NOTIFIER - GUI FIRST
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIG
--============================================================

local RADIUS = 9000
local CHECK_INTERVAL = 0.5

local Enabled = true
local Minimized = false

--============================================================
-- FRUTAS
-- O nome procurado é EXATAMENTE "Nome Fruit"
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

local FruitLookup = {}

for _, name in ipairs(FruitNames) do
	FruitLookup[name .. " Fruit"] = true
end

--============================================================
-- LIMPAR GUI ANTERIOR
--============================================================

local old = playerGui:FindFirstChild("FruitNotifier")

if old then
	old:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitNotifier"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 9999

gui.Parent = playerGui

--============================================================
-- MAIN
--============================================================

local main = Instance.new("Frame")

main.Name = "Main"

main.Size = UDim2.fromOffset(260,195)

main.Position =
	UDim2.new(0.5,-130,0.55,-97)

main.BackgroundColor3 =
	Color3.fromRGB(18,18,24)

main.BorderSizePixel = 0

main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,10)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70,70,85)
stroke.Thickness = 1
stroke.Parent = main

--============================================================
-- HEADER
--============================================================

local header = Instance.new("Frame")

header.Size =
	UDim2.new(1,0,0,38)

header.BackgroundColor3 =
	Color3.fromRGB(27,27,36)

header.BorderSizePixel = 0

header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0,10)
headerCorner.Parent = header

--============================================================
-- ÁREA DE ARRASTE
--============================================================

local dragArea = Instance.new("TextButton")

dragArea.Size =
	UDim2.new(1,-70,1,0)

dragArea.BackgroundTransparency = 1
dragArea.BorderSizePixel = 0

dragArea.Text = "🍎 Fruit Notifier"

dragArea.TextColor3 =
	Color3.fromRGB(255,255,255)

dragArea.TextSize = 14

dragArea.Font =
	Enum.Font.GothamBold

dragArea.TextXAlignment =
	Enum.TextXAlignment.Left

dragArea.Parent = header

--============================================================
-- MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(28,28)

minimize.Position =
	UDim2.new(1,-63,0,5)

minimize.BackgroundColor3 =
	Color3.fromRGB(55,55,68)

minimize.BorderSizePixel = 0

minimize.Text = "−"

minimize.TextColor3 =
	Color3.fromRGB(255,255,255)

minimize.TextSize = 18

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0,6)
minCorner.Parent = minimize

--============================================================
-- FECHAR
--============================================================

local close = Instance.new("TextButton")

close.Size =
	UDim2.fromOffset(28,28)

close.Position =
	UDim2.new(1,-33,0,5)

close.BackgroundColor3 =
	Color3.fromRGB(125,45,50)

close.BorderSizePixel = 0

close.Text = "×"

close.TextColor3 =
	Color3.fromRGB(255,255,255)

close.TextSize = 18

close.Font =
	Enum.Font.GothamBold

close.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0,6)
closeCorner.Parent = close

--============================================================
-- CONTENT
--============================================================

local content = Instance.new("Frame")

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

status.Size =
	UDim2.new(1,-20,0,30)

status.Position =
	UDim2.fromOffset(10,8)

status.BackgroundColor3 =
	Color3.fromRGB(32,32,42)

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
statusCorner.CornerRadius = UDim.new(0,6)
statusCorner.Parent = status

--============================================================
-- HISTÓRICO
--============================================================

local history = Instance.new("ScrollingFrame")

history.Size =
	UDim2.new(1,-20,1,-50)

history.Position =
	UDim2.fromOffset(10,45)

history.BackgroundColor3 =
	Color3.fromRGB(10,10,15)

history.BorderSizePixel = 0

history.ScrollBarThickness = 2

history.CanvasSize =
	UDim2.new(0,0,0,0)

history.Parent = content

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0,7)
historyCorner.Parent = history

local layout = Instance.new("UIListLayout")

layout.Padding =
	UDim.new(0,1)

layout.Parent = history

--============================================================
-- HISTÓRICO
--============================================================

local function addHistory(text)

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

	label.Parent = history

	task.defer(function()

		history.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y + 5
			)

	end)

end

--============================================================
-- PRIMEIRA MENSAGEM
--============================================================

addHistory("✓ GUI carregada")
addHistory("✓ Sistema pronto")

--============================================================
-- DRAG
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

		startPosition =
			main.Position

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

	main.Position =
		UDim2.new(
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
-- MINIMIZAR
--============================================================

local expandedSize = main.Size

minimize.Activated:Connect(function()

	Minimized = not Minimized

	if Minimized then

		content.Visible = false

		main.Size =
			UDim2.fromOffset(260,38)

		minimize.Text = "+"

	else

		content.Visible = true

		main.Size =
			expandedSize

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
-- ATIVAR / DESATIVAR
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
-- FUNÇÃO DE POSIÇÃO
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
-- IDENTIFICAR FRUTA
--============================================================

local function getFruitName(object)

	if not object:IsA("Model")
		and not object:IsA("BasePart") then

		return nil
	end

	if FruitLookup[object.Name] then
		return object.Name
	end

	return nil

end

--============================================================
-- DETECTOR
--============================================================

local Known = {}

local firstScan = true
local elapsed = 0

local function notify(fruitName,distance,existing)

	local prefix

	if existing then
		prefix = "📦 EXISTENTE"
	else
		prefix = "🆕 NOVO SPAWN"
	end

	local text =
		prefix
		.." • "
		..fruitName
		.." • "
		..math.floor(distance)
		.." studs"

	addHistory(text)

	pcall(function()

		StarterGui:SetCore(
			"SendNotification",
			{
				Title = "🍎 Fruit Notifier",
				Text =
					fruitName
					.." • "
					..math.floor(distance)
					.." studs",
				Duration = 4
			}
		)

	end)

end

--============================================================
-- INICIAR DETECTOR
--============================================================

task.spawn(function()

	-- Dá prioridade para o GUI
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

		-- Procura somente nomes exatos:
		-- "Rocket Fruit"
		-- "Dragon Fruit"
		-- "Kitsune Fruit"
		-- etc.

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
						(root.Position-position).Magnitude

					if distance <= RADIUS then

						if not Known[object] then

							Known[object] = true

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

		firstScan = false

	end

end)

--============================================================
-- DESPAWN
--============================================================

task.spawn(function()

	while gui.Parent do

		task.wait(1)

		for object in pairs(Known) do

			if object.Parent == nil then

				Known[object] = nil

			end

		end

	end

end)

--============================================================
-- FIM
--============================================================

addHistory("✓ 42 nomes configurados")
addHistory("✓ Formato: Nome Fruit")
```
