```lua
--============================================================
-- FRUIT FINDER / NOTIFIER V2
-- LocalScript
-- StarterPlayer > StarterPlayerScripts
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
	DistanceUpdate = 0.15,

	ShowDistance = true,
	ShowTags = true,

	TagTextSize = 13,
	TagHeight = 4,

	WindowWidth = 350,
	WindowHeight = 420,

	-- distância máxima para mostrar
	MaxDistance = math.huge,
}

--============================================================
-- FRUTAS
--============================================================

local FRUITS = {
	Rocket = true,
	Spin = true,
	Blade = true,
	Spring = true,
	Bomb = true,
	Smoke = true,
	Spike = true,
	Flame = true,
	Ice = true,
	Sand = true,
	Dark = true,
	Eagle = true,
	Diamond = true,
	Light = true,
	Rubber = true,
	Ghost = true,
	Magma = true,
	Quake = true,
	Buddha = true,
	Love = true,
	Creation = true,
	Spider = true,
	Sound = true,
	Phoenix = true,
	Portal = true,
	Lightning = true,
	Pain = true,
	Blizzard = true,
	Gravity = true,
	Mammoth = true,
	["T-Rex"] = true,
	Dough = true,
	Shadow = true,
	Venom = true,
	Gas = true,
	Spirit = true,
	Tiger = true,
	Yeti = true,
	Kitsune = true,
	Control = true,
	Dragon = true,
}

--============================================================
-- LOOKUP CASE-INSENSITIVE
--============================================================

local FruitLookup = {}

for fruitName in pairs(FRUITS) do
	FruitLookup[fruitName:lower()] = fruitName
end

--============================================================
-- ESTADO
--============================================================

local Enabled = true
local Minimized = false

local Detected = {}
local Tags = {}

--============================================================
-- REMOVE GUI ANTIGA
--============================================================

local oldGui = playerGui:FindFirstChild("FruitFinder")

if oldGui then
	oldGui:Destroy()
end

--============================================================
-- GUI
--============================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitFinder"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--============================================================
-- JANELA
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

local frameCorner = Instance.new("UICorner")

frameCorner.CornerRadius =
	UDim.new(0, 12)

frameCorner.Parent = frame

--============================================================
-- TOP BAR
--============================================================

local topBar = Instance.new("Frame")

topBar.Name = "TopBar"

topBar.Size =
	UDim2.new(1, 0, 0, 50)

topBar.BackgroundColor3 =
	Color3.fromRGB(35, 35, 35)

topBar.BorderSizePixel = 0
topBar.Active = true

topBar.Parent = frame

--============================================================
-- TÍTULO
--============================================================

local title = Instance.new("TextLabel")

title.Size =
	UDim2.new(1, -125, 1, 0)

title.Position =
	UDim2.fromOffset(10, 0)

title.BackgroundTransparency = 1

title.Text = "🍎 FRUIT FINDER"

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
	UDim2.new(1, -108, 0, 12)

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
-- MINIMIZAR
--============================================================

local minimize = Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(32, 26)

minimize.Position =
	UDim2.new(1, -55, 0, 12)

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
	UDim2.fromOffset(10, 57)

status.Size =
	UDim2.new(1, -20, 0, 24)

status.BackgroundTransparency = 1

status.Text = "Inicializando..."

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

--============================================================
-- FUNÇÕES DE NOME
--============================================================

local function normalizeFruitName(value)

	if typeof(value) ~= "string" then
		return nil
	end

	value = value:gsub("^%s+", "")
	value = value:gsub("%s+$", "")

	local lower = value:lower()

	-- nome exato
	if FruitLookup[lower] then
		return FruitLookup[lower]
	end

	-- RocketFruit
	if lower:sub(-5) == "fruit" then

		local base =
			lower:sub(1, -6)

		if FruitLookup[base] then
			return FruitLookup[base]
		end

	end

	-- "Rocket Fruit"
	local withoutSpace =
		lower:gsub("%s+", "")

	if withoutSpace:sub(-5) == "fruit" then

		local base =
			withoutSpace:sub(1, -6)

		if FruitLookup[base] then
			return FruitLookup[base]
		end

	end

	return nil
end

--============================================================
-- PROCURAR NOME EM ATRIBUTOS
--============================================================

local function getAttributeFruit(obj)

	local attributes = {
		"FruitName",
		"DisplayName",
		"ItemName",
		"Fruit",
	}

	for _, attributeName in ipairs(attributes) do

		local value =
			obj:GetAttribute(attributeName)

		local result =
			normalizeFruitName(value)

		if result then
			return result
		end

	end

	return nil
end

--============================================================
-- PROCURAR STRINGVALUE
--============================================================

local function getStringValueFruit(obj)

	for _, child in ipairs(
		obj:GetDescendants()
	) do

		if child:IsA("StringValue") then

			local result =
				normalizeFruitName(
					child.Value
				)

			if result then
				return result
			end

		end

	end

	return nil
end

--============================================================
-- NOME DO OBJETO
--============================================================

local function getNameFruit(obj)

	return normalizeFruitName(obj.Name)

end

--============================================================
-- NOME DA FRUTA
--============================================================

local function getFruitName(obj)

	-- 1. nome do próprio objeto
	local result =
		getNameFruit(obj)

	if result then
		return result
	end

	-- 2. atributos
	result =
		getAttributeFruit(obj)

	if result then
		return result
	end

	-- 3. StringValues
	result =
		getStringValueFruit(obj)

	if result then
		return result
	end

	-- 4. procura nos filhos diretos
	for _, child in ipairs(
		obj:GetChildren()
	) do

		result =
			getNameFruit(child)

		if result then
			return result
		end

	end

	return nil
end

--============================================================
-- VERIFICAR SE ESTÁ DENTRO DE UM CONTAINER DE FRUTAS
--============================================================

local function hasFruitContainer(obj)

	local current = obj.Parent

	for _ = 1, 5 do

		if not current then
			break
		end

		local name =
			current.Name:lower()

		if name == "fruit"
			or name == "fruits"
			or name == "spawnedfruits"
			or name == "spawned_fruits" then

			return true
		end

		current =
			current.Parent

	end

	return false
end

--============================================================
-- DETECTOR ROBUSTO
--============================================================

local function detectFruit(obj)

	--========================================================
	-- Só aceitamos objetos físicos.
	--========================================================

	if not (
		obj:IsA("Model")
		or obj:IsA("BasePart")
		or obj:IsA("Tool")
	) then

		return nil
	end

	--========================================================
	-- CASO 1
	-- O próprio objeto possui nome de fruta.
	--========================================================

	local nameFruit =
		getNameFruit(obj)

	if nameFruit then

		return nameFruit
	end

	--========================================================
	-- CASO 2
	-- Possui atributo explícito de fruta.
	--========================================================

	local attributeFruit =
		getAttributeFruit(obj)

	if attributeFruit then

		return attributeFruit
	end

	--========================================================
	-- CASO 3
	-- Objeto chamado Fruit.
	--
	-- Aqui procuramos o nome real dentro dele.
	--========================================================

	if obj.Name:lower() == "fruit" then

		local internalName =
			getStringValueFruit(obj)

		if internalName then
			return internalName
		end

		-- Procura nome de fruta nos filhos
		for _, child in ipairs(
			obj:GetDescendants()
		) do

			local childFruit =
				getNameFruit(child)

			if childFruit then
				return childFruit
			end

		end

		-- Só aceitamos Fruit genérico se ele estiver
		-- dentro de uma estrutura de frutas.
		if hasFruitContainer(obj) then
			return "Fruit"
		end

		return nil
	end

	--========================================================
	-- CASO 4
	-- Nome genérico, mas está dentro de um container
	-- explicitamente relacionado a frutas.
	--========================================================

	if hasFruitContainer(obj) then

		local containerFruit =
			getNameFruit(obj)

		if containerFruit then
			return containerFruit
		end

	end

	return nil
end

--============================================================
-- PEGAR PARTE PRINCIPAL
--============================================================

local function getAdornee(obj)

	if obj:IsA("BasePart") then
		return obj
	end

	if obj:IsA("Model")
		or obj:IsA("Tool") then

		if obj.PrimaryPart then
			return obj.PrimaryPart
		end

		local handle =
			obj:FindFirstChild(
				"Handle",
				true
			)

		if handle
			and handle:IsA("BasePart") then

			return handle
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

	local distance =
		(
			root.Position -
			adornee.Position
		).Magnitude

	if distance >
		CONFIG.MaxDistance then

		return nil
	end

	return distance
end

--============================================================
-- DISTÂNCIA FORMATADA
--============================================================

local function formatDistance(distance)

	if not distance then
		return "???"
	end

	return string.format(
		"%dm",
		math.floor(distance + 0.5)
	)
end

--============================================================
-- CRIAR TAG
--============================================================

local function createTag(obj, fruitName)

	local adornee =
		getAdornee(obj)

	if not adornee then
		return
	end

	-- remove tag antiga
	local old =
		adornee:FindFirstChild(
			"FruitFinderTag"
		)

	if old then
		old:Destroy()
	end

	local billboard =
		Instance.new("BillboardGui")

	billboard.Name =
		"FruitFinderTag"

	billboard.Adornee =
		adornee

	billboard.Size =
		UDim2.fromOffset(
			200,
			40
		)

	billboard.StudsOffsetWorldSpace =
		Vector3.new(
			0,
			CONFIG.TagHeight,
			0
		)

	billboard.AlwaysOnTop =
		true

	billboard.MaxDistance =
		CONFIG.MaxDistance

	billboard.Enabled =
		Enabled
		and CONFIG.ShowTags

	billboard.Parent =
		adornee

	local text =
		Instance.new("TextLabel")

	text.Name =
		"Text"

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
		fruitName

	text.Parent =
		billboard

	Tags[obj] =
		billboard
end

--============================================================
-- ATUALIZAR TAG
--============================================================

local function updateTag(obj)

	local tag =
		Tags[obj]

	if not tag then
		return
	end

	if not obj.Parent then

		Tags[obj] = nil
		return
	end

	local text =
		tag:FindFirstChild("Text")

	if not text then
		return
	end

	local fruitName =
		Detected[obj]

	if not fruitName then
		return
	end

	local distance =
		getDistance(obj)

	if CONFIG.ShowDistance
		and distance then

		text.Text =
			fruitName
			..
			" • "
			..
			formatDistance(distance)

	else

		text.Text =
			fruitName

	end

	tag.Enabled =
		Enabled
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
-- ATUALIZAR LISTA
--============================================================

local function updateList()

	clearList()

	local entries = {}

	for obj, fruitName in pairs(
		Detected
	) do

		if obj
			and obj.Parent then

			local distance =
				getDistance(obj)

			table.insert(
				entries,
				{
					Object = obj,
					Name = fruitName,
					Distance = distance
				}
			)

		end
	end

	--========================================================
	-- MAIS PRÓXIMAS PRIMEIRO
	--========================================================

	table.sort(
		entries,
		function(a, b)

			if not a.Distance then
				return false
			end

			if not b.Distance then
				return true
			end

			return a.Distance <
				b.Distance
		end
	)

	--========================================================
	-- NENHUMA
	--========================================================

	if #entries == 0 then

		status.Text =
			"Nenhuma fruta detectada."

		local empty =
			Instance.new("TextLabel")

		empty.Size =
			UDim2.new(
				1,
				-5,
				0,
				45
			)

		empty.BackgroundTransparency =
			1

		empty.Text =
			"Nenhuma fruta detectada."

		empty.TextColor3 =
			Color3.fromRGB(
				170,
				170,
				170
			)

		empty.TextSize =
			14

		empty.Font =
			Enum.Font.Gotham

		empty.Parent =
			list

		return
	end

	--========================================================
	-- STATUS
	--========================================================

	status.Text =
		string.format(
			"%d fruta(s) detectada(s)",
			#entries
		)

	--========================================================
	-- ITENS
	--========================================================

	for index, entry in ipairs(entries) do

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

		if entry.Distance then

			item.Text =
				"🍎  "
				..
				entry.Name
				..
				"   •   "
				..
				formatDistance(
					entry.Distance
				)

		else

			item.Text =
				"🍎  "
				..
				entry.Name

		end

		item.TextColor3 =
			Color3.new(1, 1, 1)

		item.TextSize =
			14

		item.Font =
			Enum.Font.GothamBold

		item.TextXAlignment =
			Enum.TextXAlignment.Left

		item.LayoutOrder =
			index

		item.Parent =
			list

		local corner =
			Instance.new("UICorner")

		corner.CornerRadius =
			UDim.new(0, 8)

		corner.Parent =
			item
	end
end

--============================================================
-- SCAN COMPLETO
--============================================================

local function scan()

	local found = {}

	--========================================================
	-- VARRE O WORKSPACE
	--========================================================

	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		local fruitName =
			detectFruit(obj)

		if fruitName then

			found[obj] =
				fruitName

		end
	end

	--========================================================
	-- REMOVE O QUE NÃO EXISTE MAIS
	--========================================================

	for obj in pairs(Detected) do

		if not found[obj] then

			Detected[obj] =
				nil

			local tag =
				Tags[obj]

			if tag then

				tag:Destroy()

				Tags[obj] =
					nil
			end
		end
	end

	--========================================================
	-- ADICIONA NOVAS
	--========================================================

	for obj, fruitName in pairs(found) do

		if not Detected[obj] then

			Detected[obj] =
				fruitName

			if CONFIG.ShowTags then

				createTag(
					obj,
					fruitName
				)

			end
		end
	end

	updateList()
end

--============================================================
-- BOTÃO ON/OFF
--============================================================

local function updateToggle()

	if Enabled then

		toggle.Text =
			"ON"

		toggle.BackgroundColor3 =
			Color3.fromRGB(
				40,
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

	for obj, tag in pairs(Tags) do

		if tag then

			tag.Enabled =
				Enabled
				and CONFIG.ShowTags
		end
	end

	if Enabled then

		status.Text =
			"Notificador ativado."

	else

		status.Text =
			"Notificador desativado."
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
		60,
		50
	)

minimize.MouseButton1Click:Connect(function()

	Minimized =
		not Minimized

	if Minimized then

		frame.Size =
			minimizedSize

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

	else

		frame.Size =
			normalSize

		status.Visible =
			true

		list.Visible =
			true

		toggle.Visible =
			true

		title.Text =
			"🍎 FRUIT FINDER"

		minimize.Text =
			"—"
	end
end)

--============================================================
-- ARRASTAR
--============================================================

local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
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

		dragging =
			false
	end
end)

--============================================================
-- FRUTA NOVA
--============================================================

workspace.DescendantAdded:Connect(function(obj)

	task.wait(0.1)

	if not Enabled then
		return
	end

	local fruitName =
		detectFruit(obj)

	if fruitName then

		Detected[obj] =
			fruitName

		if CONFIG.ShowTags then

			createTag(
				obj,
				fruitName
			)
		end

		task.defer(
			updateList
		)
	end
end)

--============================================================
-- FRUTA REMOVIDA
--============================================================

workspace.DescendantRemoving:Connect(function(obj)

	if Detected[obj] then

		Detected[obj] =
			nil

	end

	if Tags[obj] then

		Tags[obj]:Destroy()

		Tags[obj] =
			nil
	end

	task.defer(
		updateList
	)
end)

--============================================================
-- ATUALIZA DISTÂNCIAS
--============================================================

task.spawn(function()

	while gui.Parent do

		if Enabled then

			for obj in pairs(
				Detected
			) do

				updateTag(obj)

			end
		end

		task.wait(
			CONFIG.DistanceUpdate
		)
	end
end)

--============================================================
-- SCAN A CADA 2 SEGUNDOS
--============================================================

task.spawn(function()

	while gui.Parent do

		if Enabled then

			scan()

		end

		task.wait(
			CONFIG.ScanInterval
		)
	end
end)

--============================================================
-- INICIALIZAÇÃO
--============================================================

updateToggle()

status.Text =
	"Procurando frutas..."

-- O menu aparece ANTES do primeiro scan.
-- Portanto, se o detector tiver problema,
-- a GUI ainda deverá aparecer.

task.defer(function()
	scan()
end)

print(
	"[FruitFinder] V2 iniciado."
)
```
