```lua
--========================================================
-- FRUIT FINDER
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--========================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================
-- CONFIG
--========================================================

local SCAN_TIME = 2
local TAG_SIZE = 13

--========================================================
-- FRUTAS
--========================================================

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

--========================================================
-- REMOVER GUI ANTIGA
--========================================================

local old = playerGui:FindFirstChild("FruitFinder")

if old then
	old:Destroy()
end

--========================================================
-- GUI
--========================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitFinder"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

gui.Parent = playerGui

--========================================================
-- FRAME
--========================================================

local frame = Instance.new("Frame")

frame.Size = UDim2.fromOffset(330, 390)
frame.Position = UDim2.fromOffset(30, 100)

frame.BackgroundColor3 =
	Color3.fromRGB(25,25,25)

frame.BorderSizePixel = 0
frame.Active = true

frame.Parent = gui

local frameCorner =
	Instance.new("UICorner")

frameCorner.CornerRadius =
	UDim.new(0,10)

frameCorner.Parent = frame

--========================================================
-- TOP
--========================================================

local top = Instance.new("Frame")

top.Size =
	UDim2.new(1,0,0,45)

top.BackgroundColor3 =
	Color3.fromRGB(38,38,38)

top.BorderSizePixel = 0
top.Active = true

top.Parent = frame

local topCorner =
	Instance.new("UICorner")

topCorner.CornerRadius =
	UDim.new(0,10)

topCorner.Parent = top

--========================================================
-- TITULO
--========================================================

local title =
	Instance.new("TextLabel")

title.Size =
	UDim2.new(1,-110,1,0)

title.Position =
	UDim2.fromOffset(10,0)

title.BackgroundTransparency = 1

title.Text =
	"🍎 FRUIT FINDER"

title.TextColor3 =
	Color3.new(1,1,1)

title.Font =
	Enum.Font.GothamBold

title.TextSize = 16

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent = top

--========================================================
-- BOTÃO
--========================================================

local toggle =
	Instance.new("TextButton")

toggle.Size =
	UDim2.fromOffset(45,24)

toggle.Position =
	UDim2.new(1,-100,0,10)

toggle.BorderSizePixel = 0

toggle.Font =
	Enum.Font.GothamBold

toggle.TextSize = 11

toggle.TextColor3 =
	Color3.new(1,1,1)

toggle.Parent = top

local toggleCorner =
	Instance.new("UICorner")

toggleCorner.CornerRadius =
	UDim.new(0,5)

toggleCorner.Parent = toggle

--========================================================
-- MINIMIZAR
--========================================================

local minimize =
	Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(30,24)

minimize.Position =
	UDim2.new(1,-48,0,10)

minimize.BackgroundTransparency = 1

minimize.Text = "—"

minimize.TextColor3 =
	Color3.new(1,1,1)

minimize.TextSize = 18

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = top

--========================================================
-- STATUS
--========================================================

local status =
	Instance.new("TextLabel")

status.Position =
	UDim2.fromOffset(10,52)

status.Size =
	UDim2.new(1,-20,0,25)

status.BackgroundTransparency = 1

status.Text =
	"Procurando..."

status.TextColor3 =
	Color3.fromRGB(180,180,180)

status.TextSize = 11

status.Font =
	Enum.Font.Gotham

status.TextXAlignment =
	Enum.TextXAlignment.Left

status.Parent = frame

--========================================================
-- LISTA
--========================================================

local list =
	Instance.new("ScrollingFrame")

list.Position =
	UDim2.fromOffset(10,82)

list.Size =
	UDim2.new(1,-20,1,-92)

list.BackgroundTransparency = 1

list.BorderSizePixel = 0

list.ScrollBarThickness = 4

list.CanvasSize =
	UDim2.fromOffset(0,0)

list.Parent = frame

local layout =
	Instance.new("UIListLayout")

layout.Padding =
	UDim.new(0,5)

layout.Parent = list

layout:GetPropertyChangedSignal(
	"AbsoluteContentSize"
):Connect(function()

	list.CanvasSize =
		UDim2.fromOffset(
			0,
			layout.AbsoluteContentSize.Y + 10
		)

end)

--========================================================
-- ESTADO
--========================================================

local enabled = true
local minimized = false

--========================================================
-- FUNÇÃO: PEGAR ROOT
--========================================================

local function getRoot()

	local character =
		player.Character

	if not character then
		return nil
	end

	return character:FindFirstChild(
		"HumanoidRootPart"
	)

end

--========================================================
-- FUNÇÃO: PARTE
--========================================================

local function getPart(obj)

	if obj:IsA("BasePart") then
		return obj
	end

	if obj:IsA("Model") then

		if obj.PrimaryPart then
			return obj.PrimaryPart
		end

		return obj:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

	end

	return nil

end

--========================================================
-- DETECTOR
--
-- IMPORTANTE:
-- Primeiro procuramos a estrutura "Fruit"
-- usada pelo seu código antigo.
--========================================================

local function isFruit(obj)

	if not (
		obj:IsA("Model")
		or obj:IsA("BasePart")
	) then
		return false
	end

	local name =
		obj.Name:lower()

	-- Estrutura antiga
	if name == "fruit" then
		return true
	end

	if name:sub(-5) == "fruit" then
		return true
	end

	return false

end

--========================================================
-- NOME DA FRUTA
--========================================================

local function getFruitName(obj)

	-- Nome DragonFruit
	if obj.Name ~= "Fruit" then

		for fruitName in pairs(FruitNames) do

			if obj.Name:lower() ==
				(fruitName .. "fruit"):lower() then

				return fruitName

			end

		end

	end

	-- Atributos
	local attributes = {
		"FruitName",
		"DisplayName",
		"Fruit",
		"ItemName"
	}

	for _, attribute in ipairs(attributes) do

		local value =
			obj:GetAttribute(attribute)

		if typeof(value) == "string"
			and FruitNames[value] then

			return value

		end

	end

	-- StringValues
	for _, child in ipairs(
		obj:GetDescendants()
	) do

		if child:IsA("StringValue") then

			if FruitNames[child.Value] then
				return child.Value
			end

		end

	end

	return "Fruit"

end

--========================================================
-- DISTÂNCIA
--========================================================

local function getDistance(obj)

	local root =
		getRoot()

	if not root then
		return nil
	end

	local part =
		getPart(obj)

	if not part then
		return nil
	end

	return (
		root.Position -
		part.Position
	).Magnitude

end

--========================================================
-- TAG
--========================================================

local function makeTag(obj)

	local part =
		getPart(obj)

	if not part then
		return
	end

	local oldTag =
		part:FindFirstChild(
			"FruitFinderTag"
		)

	if oldTag then
		oldTag:Destroy()
	end

	local billboard =
		Instance.new("BillboardGui")

	billboard.Name =
		"FruitFinderTag"

	billboard.Adornee =
		part

	billboard.Size =
		UDim2.fromOffset(170,35)

	billboard.StudsOffsetWorldSpace =
		Vector3.new(0,4,0)

	billboard.AlwaysOnTop =
		true

	billboard.MaxDistance =
		math.huge

	billboard.Enabled =
		enabled

	billboard.Parent =
		part

	local text =
		Instance.new("TextLabel")

	text.Size =
		UDim2.fromScale(1,1)

	text.BackgroundTransparency =
		1

	text.TextColor3 =
		Color3.new(1,1,1)

	text.TextStrokeColor3 =
		Color3.new(0,0,0)

	text.TextStrokeTransparency =
		0

	text.Font =
		Enum.Font.GothamBold

	text.TextSize =
		TAG_SIZE

	text.Text =
		getFruitName(obj)

	text.Parent =
		billboard

end

--========================================================
-- ATUALIZAR TAGS
--========================================================

local function updateTags()

	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		if isFruit(obj) then

			local part =
				getPart(obj)

			if part then

				local tag =
					part:FindFirstChild(
						"FruitFinderTag"
					)

				if not tag then
					makeTag(obj)
				end

				tag =
					part:FindFirstChild(
						"FruitFinderTag"
					)

				if tag then

					local text =
						tag:FindFirstChildWhichIsA(
							"TextLabel"
						)

					local distance =
						getDistance(obj)

					if text then

						if distance then

							text.Text =
								getFruitName(obj)
								..
								" • "
								..
								math.floor(
									distance + 0.5
								)
								..
								"m"

						else

							text.Text =
								getFruitName(obj)

						end

					end

					tag.Enabled =
						enabled

				end

			end

		end

	end

end

--========================================================
-- ATUALIZAR PAINEL
--========================================================

local function updatePanel()

	for _, child in ipairs(
		list:GetChildren()
	) do

		if child:IsA("TextLabel") then
			child:Destroy()
		end

	end

	local found = 0

	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		if isFruit(obj) then

			found += 1

			local name =
				getFruitName(obj)

			local distance =
				getDistance(obj)

			local item =
				Instance.new("TextLabel")

			item.Size =
				UDim2.new(1,-5,0,42)

			item.BackgroundColor3 =
				Color3.fromRGB(45,45,45)

			item.BorderSizePixel = 0

			if distance then

				item.Text =
					"🍎  "
					..
					name
					..
					"    "
					..
					math.floor(
						distance + 0.5
					)
					..
					"m"

			else

				item.Text =
					"🍎  "
					..
					name

			end

			item.TextColor3 =
				Color3.new(1,1,1)

			item.TextSize = 14

			item.Font =
				Enum.Font.GothamBold

			item.TextXAlignment =
				Enum.TextXAlignment.Left

			item.Parent = list

			local c =
				Instance.new("UICorner")

			c.CornerRadius =
				UDim.new(0,7)

			c.Parent = item

			makeTag(obj)

		end

	end

	if found == 0 then

		status.Text =
			"Nenhuma fruta encontrada."

	else

		status.Text =
			found ..
			" fruta(s) encontrada(s)"

	end

end

--========================================================
-- ON / OFF
--========================================================

local function updateToggle()

	if enabled then

		toggle.Text = "ON"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				40,170,80
			)

	else

		toggle.Text = "OFF"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				170,45,45
			)

	end

end

toggle.MouseButton1Click:Connect(function()

	enabled =
		not enabled

	updateToggle()

	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		if isFruit(obj) then

			local part =
				getPart(obj)

			if part then

				local tag =
					part:FindFirstChild(
						"FruitFinderTag"
					)

				if tag then
					tag.Enabled =
						enabled
				end

			end

		end

	end

	status.Text =
		enabled
		and "Notificador ativado."
		or "Notificador desativado."

end)

--========================================================
-- MINIMIZAR
--========================================================

minimize.MouseButton1Click:Connect(function()

	if minimized then

		minimized = false

		frame.Size =
			UDim2.fromOffset(
				330,
				390
			)

		status.Visible = true
		list.Visible = true

		toggle.Visible = true

		title.Text =
			"🍎 FRUIT FINDER"

		minimize.Text =
			"—"

	else

		minimized = true

		frame.Size =
			UDim2.fromOffset(
				60,
				48
			)

		status.Visible = false
		list.Visible = false

		toggle.Visible = false

		title.Text =
			"🍎"

		minimize.Text =
			"+"

	end

end)

--========================================================
-- ARRASTAR
--========================================================

local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart =
			input.Position

		startPosition =
			frame.Position

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if not dragging then
		return
	end

	if input.UserInputType ==
		Enum.UserInputType.MouseMovement
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		local delta =
			input.Position -
			dragStart

		frame.Position =
			UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset +
					delta.X,

				startPosition.Y.Scale,
				startPosition.Y.Offset +
					delta.Y
			)

	end

end)

UserInputService.InputEnded:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = false

	end

end)

--========================================================
-- DETECTAR NOVAS FRUTAS
--========================================================

workspace.DescendantAdded:Connect(function(obj)

	task.wait(0.2)

	if isFruit(obj) then

		if enabled then
			makeTag(obj)
		end

		task.defer(updatePanel)

	end

end)

--========================================================
-- REMOÇÃO
--========================================================

workspace.DescendantRemoving:Connect(function(obj)

	if isFruit(obj) then

		task.defer(updatePanel)

	end

end)

--========================================================
-- LOOP PRINCIPAL
--========================================================

task.spawn(function()

	while gui.Parent do

		if enabled then

			updatePanel()

		end

		task.wait(
			SCAN_TIME
		)

	end

end)

--========================================================
-- INICIALIZAR
--========================================================

updateToggle()
updatePanel()

print(
	"[FruitFinder] Iniciado com sucesso."
)
```
