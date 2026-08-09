```lua
--============================================================
-- FRUIT FINDER / NOTIFIER
-- Baseado na lógica do seu script antigo
-- LocalScript
--============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--============================================================
-- CONFIGURAÇÃO
--============================================================

local CONFIG = {
	ScanInterval = 2,

	ShowDistance = true,
	ShowTags = true,

	MaxDistance = math.huge,

	TagTextSize = 13,
	TagHeight = 4,

	WindowWidth = 340,
	WindowHeight = 420
}

--============================================================
-- LISTA DE FRUTAS
--============================================================

local Fruits = {
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
-- REMOVE GUI ANTIGA
--============================================================

local old = playerGui:FindFirstChild("FruitFinder")

if old then
	old:Destroy()
end

--============================================================
-- ESTADO
--============================================================

local NotifierEnabled = true
local Minimized = false

local KnownFruits = {}
local FruitTags = {}

--============================================================
-- GUI PRINCIPAL
--============================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitFinder"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--============================================================
-- FRAME
--============================================================

local frame = Instance.new("Frame")

frame.Name = "Main"
frame.Size = UDim2.fromOffset(
	CONFIG.WindowWidth,
	CONFIG.WindowHeight
)

frame.Position = UDim2.fromOffset(30, 100)

frame.BackgroundColor3 =
	Color3.fromRGB(25, 25, 25)

frame.BorderSizePixel = 0
frame.Active = true

frame.Parent = gui

local corner = Instance.new("UICorner")

corner.CornerRadius =
	UDim.new(0, 12)

corner.Parent = frame

--============================================================
-- TOP BAR
--============================================================

local topBar = Instance.new("Frame")

topBar.Size =
	UDim2.new(1, 0, 0, 48)

topBar.BackgroundColor3 =
	Color3.fromRGB(35, 35, 35)

topBar.BorderSizePixel = 0
topBar.Active = true

topBar.Parent = frame

local topCorner = Instance.new("UICorner")

topCorner.CornerRadius =
	UDim.new(0, 12)

topCorner.Parent = topBar

--============================================================
-- TÍTULO
--============================================================

local title = Instance.new("TextLabel")

title.Size =
	UDim2.new(1, -125, 1, 0)

title.Position =
	UDim2.fromOffset(10, 0)

title.BackgroundTransparency = 1

title.Text =
	"🍎 FRUIT FINDER"

title.TextColor3 =
	Color3.new(1, 1, 1)

title.TextSize = 17

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent = topBar

--============================================================
-- BOTÃO ON/OFF
--============================================================

local toggle = Instance.new("TextButton")

toggle.Size =
	UDim2.fromOffset(48, 26)

toggle.Position =
	UDim2.new(1, -108, 0, 11)

toggle.BorderSizePixel = 0

toggle.TextColor3 =
	Color3.new(1, 1, 1)

toggle.TextSize = 11

toggle.Font =
	Enum.Font.GothamBold

toggle.Parent = topBar

local toggleCorner = Instance.new("UICorner")

toggleCorner.CornerRadius =
	UDim.new(0, 6)

toggleCorner.Parent = toggle

--============================================================
-- BOTÃO MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(32, 26)

minimize.Position =
	UDim2.new(1, -52, 0, 11)

minimize.BackgroundTransparency = 1

minimize.Text = "—"

minimize.TextColor3 =
	Color3.new(1, 1, 1)

minimize.TextSize = 18

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = topBar

--============================================================
-- STATUS
--============================================================

local status = Instance.new("TextLabel")

status.Position =
	UDim2.fromOffset(10, 58)

status.Size =
	UDim2.new(1, -20, 0, 25)

status.BackgroundTransparency = 1

status.Text =
	"Procurando frutas..."

status.TextColor3 =
	Color3.fromRGB(170, 170, 170)

status.TextSize = 11

status.Font =
	Enum.Font.Gotham

status.TextXAlignment =
	Enum.TextXAlignment.Left

status.Parent = frame

--============================================================
-- LISTA
--============================================================

local list = Instance.new("ScrollingFrame")

list.Name = "FruitList"

list.Position =
	UDim2.fromOffset(10, 88)

list.Size =
	UDim2.new(1, -20, 1, -98)

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

--============================================================
-- ATUALIZAR BOTÃO
--============================================================

local function updateToggle()

	if NotifierEnabled then

		toggle.Text = "ON"

		toggle.BackgroundColor3 =
			Color3.fromRGB(40, 170, 80)

	else

		toggle.Text = "OFF"

		toggle.BackgroundColor3 =
			Color3.fromRGB(170, 45, 45)

	end

end

updateToggle()

--============================================================
-- PEGAR NOME DA FRUTA
--============================================================

local function getFruitName(obj)

	--========================================================
	-- 1. OBJETO COM NOME ESPECÍFICO
	--========================================================

	if obj.Name ~= "Fruit" then

		if Fruits[obj.Name] then
			return obj.Name
		end

		-- Caso o nome seja algo como DragonFruit
		for fruitName in pairs(Fruits) do

			if obj.Name:lower() ==
				(fruitName .. "fruit"):lower() then

				return fruitName

			end

		end

	end

	--========================================================
	-- 2. ATRIBUTOS
	--========================================================

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
			and value ~= "" then

			if Fruits[value] then
				return value
			end

		end

	end

	--========================================================
	-- 3. STRINGVALUES
	--========================================================

	for _, child in ipairs(
		obj:GetDescendants()
	) do

		if child:IsA("StringValue") then

			local value = child.Value

			if Fruits[value] then
				return value
			end

		end

	end

	--========================================================
	-- 4. PROCURAR NOME DENTRO DO MODELO
	--========================================================

	for _, fruitName in pairs(Fruits) do
		-- Mantido vazio propositalmente.
	end

	--========================================================
	-- 5. CASO NÃO TENHA NOME
	--========================================================

	return "Fruit"

end

--============================================================
-- DETECTAR FRUTA
--
-- ESTA É A PARTE MAIS IMPORTANTE.
--
-- NÃO procuramos "Sand", "Ice", "Smoke" etc.
-- O objeto precisa ter a estrutura usada pelo seu
-- sistema antigo:
--
-- Fruit
-- OU
-- NomeFruit
--============================================================

local function isFruit(obj)

	if not (
		obj:IsA("Model")
		or obj:IsA("BasePart")
	) then

		return false

	end

	local name = obj.Name
	local lowerName = name:lower()

	--========================================================
	-- CASO 1: OBJETO CHAMADO EXATAMENTE "Fruit"
	--========================================================

	if lowerName == "fruit" then
		return true
	end

	--========================================================
	-- CASO 2: NOME TERMINANDO EM "Fruit"
	--========================================================

	if #lowerName >= 5 then

		if lowerName:sub(-5) == "fruit" then
			return true
		end

	end

	return false

end

--============================================================
-- PEGAR PARTE DA FRUTA
--============================================================

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

--============================================================
-- DISTÂNCIA
--============================================================

local function getDistance(fruit)

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
		getAdornee(fruit)

	if not adornee then
		return nil
	end

	return (
		root.Position -
		adornee.Position
	).Magnitude

end

--============================================================
-- FORMATAR DISTÂNCIA
--============================================================

local function formatDistance(distance)

	if not distance then
		return "???"
	end

	return tostring(
		math.floor(distance + 0.5)
	) .. "m"

end

--============================================================
-- CRIAR TEXTO ACIMA DA FRUTA
--============================================================

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
		UDim2.fromOffset(180, 38)

	billboard.StudsOffsetWorldSpace =
		Vector3.new(
			0,
			CONFIG.TagHeight,
			0
		)

	billboard.MaxDistance =
		CONFIG.MaxDistance

	billboard.AlwaysOnTop =
		true

	billboard.Enabled =
		NotifierEnabled
		and CONFIG.ShowTags

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

	text.TextSize =
		CONFIG.TagTextSize

	text.Font =
		Enum.Font.GothamBold

	text.Text =
		getFruitName(fruit)

	text.Parent =
		billboard

	FruitTags[fruit] =
		billboard

end

--============================================================
-- ATUALIZAR TEXTO DA TAG
--============================================================

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

	local fruitName =
		getFruitName(fruit)

	local distance =
		getDistance(fruit)

	if CONFIG.ShowDistance
		and distance then

		text.Text =
			fruitName ..
			" • " ..
			formatDistance(distance)

	else

		text.Text =
			fruitName

	end

	billboard.Enabled =
		NotifierEnabled
		and CONFIG.ShowTags

end

--============================================================
-- LIMPAR LISTA
--============================================================

local function clearList()

	for _, child in ipairs(
		list:GetChildren()
	) do

		if child:IsA("TextLabel") then
			child:Destroy()
		end

	end

end

--============================================================
-- ATUALIZAR PAINEL
--============================================================

local function update()

	clearList()

	local fruits = {}

	--========================================================
	-- IMPORTANTE:
	-- AQUI USAMOS A MESMA IDENTIFICAÇÃO DO SEU SCRIPT ANTIGO.
	--========================================================

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

	--========================================================
	-- NENHUMA FRUTA
	--========================================================

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

	--========================================================
	-- FRUTAS ENCONTRADAS
	--========================================================

	status.Text =
		#fruits ..
		" fruta(s) encontrada(s)"

	for index, fruit in ipairs(fruits) do

		local fruitName =
			getFruitName(fruit)

		local distance =
			getDistance(fruit)

		--====================================================
		-- TAG
		--====================================================

		createNameTag(fruit)

		--====================================================
		-- LISTA
		--====================================================

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
				"🍎  " ..
				fruitName ..
				"    •    " ..
				formatDistance(distance)

		else

			item.Text =
				"🍎  " ..
				fruitName

		end

		item.TextColor3 =
			Color3.new(
				1,
				1,
				1
			)

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
			UDim.new(0, 8)

		itemCorner.Parent =
			item

	end

end

--============================================================
-- TOGGLE
--============================================================

toggle.MouseButton1Click:Connect(function()

	NotifierEnabled =
		not NotifierEnabled

	updateToggle()

	if NotifierEnabled then

		status.Text =
			"Notificador ativado."

	else

		status.Text =
			"Notificador desativado."

	end

	for fruit, billboard in pairs(
		FruitTags
	) do

		if billboard then

			billboard.Enabled =
				NotifierEnabled
				and CONFIG.ShowTags

		end

	end

end)

--============================================================
-- MINIMIZAR
--============================================================

local normalSize =
	UDim2.fromOffset(
		CONFIG.WindowWidth,
		CONFIG.WindowHeight
	)

local minimizedSize =
	UDim2.fromOffset(
		58,
		48
	)

minimize.MouseButton1Click:Connect(function()

	if not Minimized then

		Minimized = true

		frame.Size =
			minimizedSize

		status.Visible =
			false

		list.Visible =
			false

		title.Text =
			"🍎"

		toggle.Visible =
			false

		minimize.Text =
			"+"

	else

		Minimized = false

		frame.Size =
			normalSize

		status.Visible =
			true

		list.Visible =
			true

		title.Text =
			"🍎 FRUIT FINDER"

		toggle.Visible =
			true

		minimize.Text =
			"—"

	end

end)

--============================================================
-- ARRASTAR PAINEL
--============================================================

local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or
		input.UserInputType ==
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

		dragging = false

	end

end)

--============================================================
-- FRUTA SPAWNANDO
--============================================================

workspace.DescendantAdded:Connect(function(obj)

	task.wait(0.15)

	if isFruit(obj) then

		if NotifierEnabled then

			createNameTag(obj)

		end

		task.defer(update)

	end

end)

--============================================================
-- FRUTA REMOVIDA
--============================================================

workspace.DescendantRemoving:Connect(function(obj)

	if isFruit(obj) then

		if FruitTags[obj] then

			FruitTags[obj]:Destroy()
			FruitTags[obj] = nil

		end

		KnownFruits[obj] = nil

		task.defer(update)

	end

end)

--============================================================
-- ATUALIZAR DISTÂNCIAS
--============================================================

task.spawn(function()

	while gui.Parent do

		if NotifierEnabled then

			for fruit, billboard in pairs(
				FruitTags
			) do

				if fruit
					and fruit.Parent
					and billboard
					and billboard.Parent then

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

--============================================================
-- SCANNER PRINCIPAL
--============================================================

task.spawn(function()

	while gui.Parent do

		if NotifierEnabled then

			update()

		end

		task.wait(
			CONFIG.ScanInterval
		)

	end

end)

--============================================================
-- INICIAR
--============================================================

update()

updateToggle()

print(
	"[FruitFinder] Sistema iniciado."
)
```
