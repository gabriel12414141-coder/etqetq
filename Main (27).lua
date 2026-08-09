```lua
--==================================================
-- FRUIT FINDER
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- REMOVE PAINEL ANTERIOR
--==================================================

local old = playerGui:FindFirstChild("FruitFinder")

if old then
	old:Destroy()
end

--==================================================
-- CONFIG
--==================================================

local SCAN_INTERVAL = 2
local TAG_SIZE = 14

local Enabled = true
local Minimized = false

local FruitTags = {}

--==================================================
-- LISTA DE FRUTAS
--==================================================

local FruitList = {

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

local FruitNames = {}

for _, name in ipairs(FruitList) do
	FruitNames[name] = true
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitFinder"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true

gui.Parent = playerGui

--==================================================
-- FRAME
--==================================================

local frame = Instance.new("Frame")

frame.Size =
	UDim2.fromOffset(340, 380)

frame.Position =
	UDim2.fromOffset(30, 100)

frame.BackgroundColor3 =
	Color3.fromRGB(25, 25, 25)

frame.BorderSizePixel = 0
frame.Active = true

frame.Parent = gui

local corner = Instance.new("UICorner")

corner.CornerRadius =
	UDim.new(0, 12)

corner.Parent = frame

--==================================================
-- BARRA
--==================================================

local topBar = Instance.new("Frame")

topBar.Size =
	UDim2.new(1, 0, 0, 50)

topBar.BackgroundColor3 =
	Color3.fromRGB(35, 35, 35)

topBar.BorderSizePixel = 0
topBar.Active = true

topBar.Parent = frame

local topCorner = Instance.new("UICorner")

topCorner.CornerRadius =
	UDim.new(0, 12)

topCorner.Parent = topBar

--==================================================
-- TÍTULO
--==================================================

local title = Instance.new("TextLabel")

title.Size =
	UDim2.new(1, -125, 1, 0)

title.Position =
	UDim2.fromOffset(10, 0)

title.BackgroundTransparency = 1

title.Text =
	"🍎 FRUTAS SPAWNADAS"

title.TextColor3 =
	Color3.new(1, 1, 1)

title.TextSize = 17

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent = topBar

--==================================================
-- ON/OFF
--==================================================

local toggle = Instance.new("TextButton")

toggle.Size =
	UDim2.fromOffset(45, 25)

toggle.Position =
	UDim2.new(1, -105, 0, 12)

toggle.BorderSizePixel = 0

toggle.Font =
	Enum.Font.GothamBold

toggle.TextSize = 11

toggle.TextColor3 =
	Color3.new(1, 1, 1)

toggle.Parent = topBar

local toggleCorner = Instance.new("UICorner")

toggleCorner.CornerRadius =
	UDim.new(0, 6)

toggleCorner.Parent = toggle

--==================================================
-- MINIMIZAR
--==================================================

local minimize = Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(30, 25)

minimize.Position =
	UDim2.new(1, -52, 0, 12)

minimize.BackgroundTransparency = 1

minimize.Text =
	"—"

minimize.TextColor3 =
	Color3.new(1, 1, 1)

minimize.TextSize = 18

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = topBar

--==================================================
-- STATUS
--==================================================

local status = Instance.new("TextLabel")

status.Position =
	UDim2.fromOffset(10, 55)

status.Size =
	UDim2.new(1, -20, 0, 25)

status.BackgroundTransparency = 1

status.Text =
	"Procurando frutas..."

status.TextColor3 =
	Color3.fromRGB(180, 180, 180)

status.TextSize = 11

status.Font =
	Enum.Font.Gotham

status.TextXAlignment =
	Enum.TextXAlignment.Left

status.Parent = frame

--==================================================
-- LISTA
--==================================================

local list = Instance.new("ScrollingFrame")

list.Position =
	UDim2.fromOffset(10, 85)

list.Size =
	UDim2.new(1, -20, 1, -95)

list.BackgroundTransparency = 1

list.BorderSizePixel = 0

list.ScrollBarThickness = 5

list.CanvasSize =
	UDim2.fromOffset(0, 0)

list.Parent = frame

local layout = Instance.new("UIListLayout")

layout.Padding =
	UDim.new(0, 6)

layout.SortOrder =
	Enum.SortOrder.LayoutOrder

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

--==================================================
-- PEGAR NOME ESPECÍFICO DA FRUTA
--==================================================

local function getFruitName(obj)

	-- O próprio nome é um nome de fruta
	if FruitNames[obj.Name] then
		return obj.Name
	end

	-- DragonFruit, DoughFruit etc.
	for _, fruitName in ipairs(FruitList) do

		if obj.Name:lower() ==
			(fruitName .. "fruit"):lower() then

			return fruitName

		end

	end

	-- Atributos
	local attributeNames = {
		"FruitName",
		"DisplayName",
		"Fruit",
		"ItemName"
	}

	for _, attributeName in ipairs(attributeNames) do

		local value =
			obj:GetAttribute(attributeName)

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

--==================================================
-- DETECTAR OBJETO DE FRUTA
--
-- IMPORTANTE:
-- NÃO basta o objeto se chamar "Sand".
-- O sistema procura a estrutura usada
-- pelo seu script antigo.
--==================================================

local function isFruit(obj)

	if not (
		obj:IsA("Model")
		or obj:IsA("BasePart")
	) then

		return false

	end

	local name =
		obj.Name:lower()

	-- Estrutura original
	if name == "fruit" then
		return true
	end

	-- DragonFruit / DoughFruit etc.
	if name:sub(-5) == "fruit" then
		return true
	end

	-- Se o objeto tiver explicitamente
	-- o atributo FruitName, podemos aceitar.
	local fruitName =
		obj:GetAttribute("FruitName")

	if typeof(fruitName) == "string"
		and FruitNames[fruitName] then

		return true

	end

	return false

end

--==================================================
-- PARTE PARA O BILLBOARD
--==================================================

local function getAdornee(obj)

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

--==================================================
-- DISTÂNCIA
--==================================================

local function getDistance(obj)

	local character =
		player.Character

	if not character then
		return nil
	end

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not root then
		return nil
	end

	local adornee =
		getAdornee(obj)

	if not adornee then
		return nil
	end

	return (
		root.Position -
		adornee.Position
	).Magnitude

end

--==================================================
-- CRIAR TEXTO ACIMA DA FRUTA
--==================================================

local function createNameTag(fruit)

	local adornee =
		getAdornee(fruit)

	if not adornee then
		return
	end

	local oldTag =
		adornee:FindFirstChild(
			"FruitNameDisplay"
		)

	if oldTag then
		oldTag:Destroy()
	end

	local billboard =
		Instance.new("BillboardGui")

	billboard.Name =
		"FruitNameDisplay"

	billboard.Adornee =
		adornee

	billboard.Size =
		UDim2.fromOffset(180, 40)

	billboard.StudsOffsetWorldSpace =
		Vector3.new(0, 4, 0)

	billboard.MaxDistance =
		math.huge

	billboard.AlwaysOnTop =
		true

	billboard.Enabled =
		Enabled

	billboard.Parent =
		adornee

	local text =
		Instance.new("TextLabel")

	text.Name =
		"FruitName"

	text.Size =
		UDim2.fromScale(1, 1)

	text.BackgroundTransparency =
		1

	text.TextColor3 =
		Color3.new(1, 1, 1)

	text.TextStrokeColor3 =
		Color3.new(0, 0, 0)

	text.TextStrokeTransparency =
		0

	text.Font =
		Enum.Font.GothamBold

	text.TextSize =
		TAG_SIZE

	text.Text =
		getFruitName(fruit)

	text.Parent =
		billboard

	FruitTags[fruit] =
		billboard

end

--==================================================
-- ATUALIZAR TEXTO
--==================================================

local function updateTag(fruit)

	local billboard =
		FruitTags[fruit]

	if not billboard then
		return
	end

	local text =
		billboard:FindFirstChild(
			"FruitName"
		)

	if not text then
		return
	end

	local distance =
		getDistance(fruit)

	local name =
		getFruitName(fruit)

	if distance then

		text.Text =
			name
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
			name

	end

	billboard.Enabled =
		Enabled

end

--==================================================
-- ATUALIZAR PAINEL
--==================================================

local function update()

	for _, child in ipairs(
		list:GetChildren()
	) do

		if child:IsA("TextLabel") then
			child:Destroy()
		end

	end

	local fruits = {}

	-- MESMA BASE DO SEU SCRIPT ANTIGO
	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		if isFruit(obj) then

			table.insert(
				fruits,
				obj
			)

		end

	end

	if #fruits == 0 then

		status.Text =
			"Nenhuma fruta spawnada."

		local empty =
			Instance.new("TextLabel")

		empty.Size =
			UDim2.new(1, -5, 0, 45)

		empty.BackgroundTransparency =
			1

		empty.Text =
			"Nenhuma fruta spawnada."

		empty.TextColor3 =
			Color3.fromRGB(
				180,
				180,
				180
			)

		empty.TextSize = 14

		empty.Font =
			Enum.Font.Gotham

		empty.Parent =
			list

		return

	end

	status.Text =
		#fruits ..
		" fruta(s) encontrada(s)"

	for index, fruit in ipairs(fruits) do

		local fruitName =
			getFruitName(fruit)

		local distance =
			getDistance(fruit)

		-- TEXTO ACIMA
		createNameTag(fruit)

		-- ITEM DA LISTA
		local item =
			Instance.new("TextLabel")

		item.Size =
			UDim2.new(
				1,
				-5,
				0,
				44
			)

		item.BackgroundColor3 =
			Color3.fromRGB(
				45,
				45,
				45
			)

		item.BorderSizePixel =
			0

		if distance then

			item.Text =
				"🍎  "
				..
				fruitName
				..
				"    •    "
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
				fruitName

		end

		item.TextColor3 =
			Color3.new(1,1,1)

		item.TextSize = 14

		item.Font =
			Enum.Font.GothamBold

		item.TextXAlignment =
			Enum.TextXAlignment.Left

		item.LayoutOrder =
			index

		item.Parent =
			list

		local itemCorner =
			Instance.new("UICorner")

		itemCorner.CornerRadius =
			UDim.new(0,8)

		itemCorner.Parent =
			item

	end

end

--==================================================
-- ON / OFF
--==================================================

local function updateToggle()

	if Enabled then

		toggle.Text =
			"ON"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				45,
				170,
				80
			)

	else

		toggle.Text =
			"OFF"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				170,
				45,
				45
			)

	end

end

toggle.MouseButton1Click:Connect(function()

	Enabled =
		not Enabled

	updateToggle()

	for fruit, tag in pairs(
		FruitTags
	) do

		if tag then

			tag.Enabled =
				Enabled

		end

	end

	status.Text =
		Enabled
		and "Notificador ativado."
		or "Notificador desativado."

end)

--==================================================
-- MINIMIZAR / RESTAURAR
--==================================================

local normalSize =
	UDim2.fromOffset(
		340,
		380
	)

local miniSize =
	UDim2.fromOffset(
		60,
		50
	)

minimize.MouseButton1Click:Connect(function()

	if Minimized then

		Minimized =
			false

		frame.Size =
			normalSize

		status.Visible =
			true

		list.Visible =
			true

		toggle.Visible =
			true

		title.Text =
			"🍎 FRUTAS SPAWNADAS"

		minimize.Text =
			"—"

	else

		Minimized =
			true

		frame.Size =
			miniSize

		status.Visible =
			false

		list.Visible =
			false

		toggle.Visible =
			false

		title.Text =
			"🍎"

		minimize.Text =
			"+"

	end

end)

--==================================================
-- ARRASTAR
--==================================================

local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or
		input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging =
			true

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
		or
		input.UserInputType ==
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
		or
		input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging =
			false

	end

end)

--==================================================
-- NOVA FRUTA
--==================================================

workspace.DescendantAdded:Connect(function(obj)

	task.wait(0.15)

	if isFruit(obj) then

		if Enabled then
			createNameTag(obj)
		end

		task.defer(update)

	end

end)

--==================================================
-- FRUTA REMOVIDA
--==================================================

workspace.DescendantRemoving:Connect(function(obj)

	if isFruit(obj) then

		if FruitTags[obj] then

			FruitTags[obj]:Destroy()

			FruitTags[obj] =
				nil

		end

		task.defer(update)

	end

end)

--==================================================
-- ATUALIZAÇÃO DA DISTÂNCIA
--==================================================

task.spawn(function()

	while gui.Parent do

		if Enabled then

			for fruit, tag in pairs(
				FruitTags
			) do

				if fruit
					and fruit.Parent
					and tag then

					updateTag(fruit)

				else

					FruitTags[fruit] =
						nil

				end

			end

		end

		task.wait(0.15)

	end

end)

--==================================================
-- SCAN A CADA 2 SEGUNDOS
--==================================================

task.spawn(function()

	while gui.Parent do

		if Enabled then
			update()
		end

		task.wait(
			SCAN_INTERVAL
		)

	end

end)

--==================================================
-- INICIAR
--==================================================

updateToggle()
update()

print(
	"[FruitFinder] iniciado"
)
```
