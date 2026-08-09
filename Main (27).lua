```lua
--==================================================
-- 🍎 FRUIT FINDER
-- RECONHECIMENTO EXATO DE FRUTAS
-- GUI ARRASTÁVEL + MINIMIZÁVEL
-- NOME ACIMA DA FRUTA + DISTÂNCIA
--==================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--==================================================
-- LISTA DE FRUTAS VÁLIDAS
--==================================================

local validFruits = {
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
	"Control",
	"Spirit",
	"Gas",
	"Yeti",
	"Leopard",
	"Kitsune",
	"Dragon"
}

--==================================================
-- NORMALIZAR NOME
--==================================================

local function normalizeName(name)

	name = tostring(name or "")

	name = name:match("^%s*(.-)%s*$")

	return name:lower()
end

--==================================================
-- LOOKUP
--==================================================

local fruitLookup = {}

for _, fruitName in ipairs(validFruits) do

	local normal =
		normalizeName(fruitName)

	-- Exemplo:
	-- Sound
	fruitLookup[normal] = fruitName

	-- Exemplo:
	-- Sound Fruit
	fruitLookup[normal .. " fruit"] =
		fruitName .. " Fruit"

end

--==================================================
-- NOME VÁLIDO
--==================================================

local function getValidFruitName(name)

	local normalized =
		normalizeName(name)

	return fruitLookup[normalized]
end

--==================================================
-- DETECTOR
--==================================================

local function isFruit(obj)

	if not (
		obj:IsA("Model")
		or obj:IsA("BasePart")
	) then

		return false
	end

	-- Ignorar objetos criados pelo sistema
	if obj.Name == "NameTag"
		or obj.Name == "FruitNameDisplay" then

		return false
	end

	-- SOMENTE o nome do próprio objeto
	local validName =
		getValidFruitName(obj.Name)

	if validName then
		return true
	end

	return false
end

--==================================================
-- PEGAR NOME
--==================================================

local function getFruitName(obj)

	-- Primeiro o próprio nome
	local validName =
		getValidFruitName(obj.Name)

	if validName then
		return validName
	end

	-- Depois atributos
	for attributeName, value in pairs(
		obj:GetAttributes()
	) do

		if typeof(value) == "string" then

			local validAttribute =
				getValidFruitName(value)

			if validAttribute then
				return validAttribute
			end

		end
	end

	return nil
end

--==================================================
-- REMOVER GUI ANTIGO
--==================================================

local old =
	playerGui:FindFirstChild(
		"FruitFinder"
	)

if old then
	old:Destroy()
end

--==================================================
-- GUI
--==================================================

local gui = Instance.new("ScreenGui")

gui.Name = "FruitFinder"

gui.ResetOnSpawn = false

gui.IgnoreGuiInset = true

gui.DisplayOrder = 999

gui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

gui.Parent = playerGui

--==================================================
-- JANELA
--==================================================

local main = Instance.new("Frame")

main.Name = "Main"

main.Size =
	UDim2.fromOffset(350, 440)

main.Position =
	UDim2.new(
		0,
		25,
		0.5,
		-220
	)

main.BackgroundColor3 =
	Color3.fromRGB(
		25,
		25,
		25
	)

main.BorderSizePixel = 0

main.Parent = gui

local mainCorner =
	Instance.new("UICorner")

mainCorner.CornerRadius =
	UDim.new(0, 12)

mainCorner.Parent = main

--==================================================
-- CABEÇALHO
--==================================================

local header =
	Instance.new("Frame")

header.Size =
	UDim2.new(1, 0, 0, 45)

header.BackgroundColor3 =
	Color3.fromRGB(
		38,
		38,
		38
	)

header.BorderSizePixel = 0

header.Parent = main

--==================================================
-- TÍTULO
--==================================================

local title =
	Instance.new("TextLabel")

title.Size =
	UDim2.new(
		1,
		-55,
		1,
		0
	)

title.Position =
	UDim2.fromOffset(12, 0)

title.BackgroundTransparency = 1

title.Text =
	"🍎 Fruit Finder"

title.TextColor3 =
	Color3.new(1, 1, 1)

title.TextSize = 19

title.Font =
	Enum.Font.GothamBold

title.TextXAlignment =
	Enum.TextXAlignment.Left

title.Parent = header

--==================================================
-- BOTÃO MINIMIZAR
--==================================================

local minimize =
	Instance.new("TextButton")

minimize.Size =
	UDim2.fromOffset(35, 35)

minimize.Position =
	UDim2.new(
		1,
		-40,
		0,
		5
	)

minimize.BackgroundColor3 =
	Color3.fromRGB(
		60,
		60,
		60
	)

minimize.BorderSizePixel = 0

minimize.Text = "—"

minimize.TextColor3 =
	Color3.new(1, 1, 1)

minimize.TextSize = 20

minimize.Font =
	Enum.Font.GothamBold

minimize.Parent = header

local minCorner =
	Instance.new("UICorner")

minCorner.CornerRadius =
	UDim.new(0, 7)

minCorner.Parent = minimize

--==================================================
-- CONTEÚDO
--==================================================

local content =
	Instance.new("Frame")

content.Size =
	UDim2.new(
		1,
		0,
		1,
		-45
	)

content.Position =
	UDim2.fromOffset(0, 45)

content.BackgroundTransparency = 1

content.Parent = main

--==================================================
-- STATUS
--==================================================

local status =
	Instance.new("TextLabel")

status.Size =
	UDim2.new(
		1,
		-20,
		0,
		40
	)

status.Position =
	UDim2.fromOffset(10, 5)

status.BackgroundTransparency = 1

status.Text =
	"🔎 Procurando frutas..."

status.TextColor3 =
	Color3.fromRGB(
		190,
		190,
		190
	)

status.TextSize = 13

status.Font =
	Enum.Font.Gotham

status.TextXAlignment =
	Enum.TextXAlignment.Left

status.Parent = content

--==================================================
-- LISTA
--==================================================

local list =
	Instance.new("ScrollingFrame")

list.Name = "FruitList"

list.Size =
	UDim2.new(
		1,
		-20,
		1,
		-55
	)

list.Position =
	UDim2.fromOffset(10, 45)

list.BackgroundColor3 =
	Color3.fromRGB(
		12,
		12,
		12
	)

list.BorderSizePixel = 0

list.ScrollBarThickness = 5

list.CanvasSize =
	UDim2.new(0, 0, 0, 0)

list.Parent = content

local listCorner =
	Instance.new("UICorner")

listCorner.CornerRadius =
	UDim.new(0, 8)

listCorner.Parent = list

local layout =
	Instance.new("UIListLayout")

layout.Padding =
	UDim.new(0, 5)

layout.SortOrder =
	Enum.SortOrder.Name

layout.Parent = list

--==================================================
-- ARRASTAR GUI
--==================================================

local dragging = false

local dragStart

local startPosition

header.InputBegan:Connect(function(input)

	if input.UserInputType ==
		Enum.UserInputType.MouseButton1
		or input.UserInputType ==
		Enum.UserInputType.Touch then

		dragging = true

		dragStart =
			input.Position

		startPosition =
			main.Position

		input.Changed:Connect(function()

			if input.UserInputState ==
				Enum.UserInputState.End then

				dragging = false

			end

		end)
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

		main.Position =
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

--==================================================
-- MINIMIZAR
--==================================================

local minimized = false

minimize.MouseButton1Click:Connect(function()

	minimized =
		not minimized

	if minimized then

		content.Visible = false

		main.Size =
			UDim2.fromOffset(
				350,
				45
			)

		minimize.Text = "+"

	else

		content.Visible = true

		main.Size =
			UDim2.fromOffset(
				350,
				440
			)

		minimize.Text = "—"

	end

end)

--==================================================
-- PEGAR PARTE PRINCIPAL
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
-- CRIAR NOME ACIMA DA FRUTA
--==================================================

local function createNameTag(
	obj,
	fruitName
)

	local adornee =
		getAdornee(obj)

	if not adornee then
		return nil
	end

	local billboard =
		Instance.new(
			"BillboardGui"
		)

	billboard.Name =
		"FruitNameDisplay"

	billboard.Adornee =
		adornee

	billboard.Size =
		UDim2.fromOffset(
			110,
			25
		)

	billboard.StudsOffset =
		Vector3.new(
			0,
			3,
			0
		)

	billboard.AlwaysOnTop =
		true

	billboard.MaxDistance =
		1000

	billboard.Parent =
		adornee

	local label =
		Instance.new("TextLabel")

	label.Size =
		UDim2.fromScale(
			1,
			1
		)

	label.BackgroundTransparency = 1

	label.Text =
		fruitName

	label.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	label.TextStrokeTransparency =
		0

	label.TextSize = 13

	label.Font =
		Enum.Font.GothamBold

	label.Parent =
		billboard

	return billboard
end

--==================================================
-- CRIAR ITEM DA LISTA
--==================================================

local function createEntry(
	fruitName
)

	local frame =
		Instance.new("Frame")

	frame.Size =
		UDim2.new(
			1,
			-10,
			0,
			58
		)

	frame.BackgroundColor3 =
		Color3.fromRGB(
			35,
			35,
			35
		)

	frame.BorderSizePixel = 0

	frame.Parent = list

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(
			0,
			8
		)

	corner.Parent =
		frame

	local name =
		Instance.new("TextLabel")

	name.Size =
		UDim2.new(
			1,
			-20,
			0,
			26
		)

	name.Position =
		UDim2.fromOffset(
			10,
			3
		)

	name.BackgroundTransparency =
		1

	name.Text =
		"🍏 " ..
		fruitName

	name.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	name.TextSize = 15

	name.Font =
		Enum.Font.GothamBold

	name.TextXAlignment =
		Enum.TextXAlignment.Left

	name.Parent =
		frame

	local distance =
		Instance.new(
			"TextLabel"
		)

	distance.Size =
		UDim2.new(
			1,
			-20,
			0,
			20
		)

	distance.Position =
		UDim2.fromOffset(
			10,
			30
		)

	distance.BackgroundTransparency =
		1

	distance.Text =
		"📍 Calculando..."

	distance.TextColor3 =
		Color3.fromRGB(
			100,
			220,
			120
		)

	distance.TextSize = 11

	distance.Font =
		Enum.Font.Gotham

	distance.TextXAlignment =
		Enum.TextXAlignment.Left

	distance.Parent =
		frame

	return frame, distance
end

--==================================================
-- DADOS
--==================================================

local detected = {}

--==================================================
-- ATUALIZAR TAMANHO DA LISTA
--==================================================

local function updateCanvas()

	task.defer(function()

		list.CanvasSize =
			UDim2.new(
				0,
				0,
				0,
				layout.AbsoluteContentSize.Y +
					10
			)

	end)
end

--==================================================
-- SCAN
--==================================================

local function scan()

	local current = {}

	local total = 0

	for _, obj in ipairs(
		workspace:GetDescendants()
	) do

		if isFruit(obj) then

			local fruitName =
				getFruitName(obj)

			if fruitName then

				current[obj] =
					true

				total += 1

				if not detected[obj] then

					local frame,
						distance =
						createEntry(
							fruitName
						)

					local tag =
						createNameTag(
							obj,
							fruitName
						)

					detected[obj] = {

						Name =
							fruitName,

						Frame =
							frame,

						Distance =
							distance,

						Tag =
							tag
					}

				end
			end
		end
	end

	--================================================
	-- REMOVER FRUTAS QUE SUMIRAM
	--================================================

	for obj, data in pairs(
		detected
	) do

		if not current[obj] then

			if data.Frame then
				data.Frame:Destroy()
			end

			if data.Tag then
				data.Tag:Destroy()
			end

			detected[obj] = nil

		end
	end

	--================================================
	-- STATUS
	--================================================

	if total > 0 then

		status.Text =
			"✅ " ..
			total ..
			" fruta(s) encontrada(s)"

		status.TextColor3 =
			Color3.fromRGB(
				100,
				255,
				120
			)

	else

		status.Text =
			"🔎 Nenhuma fruta encontrada"

		status.TextColor3 =
			Color3.fromRGB(
				190,
				190,
				190
			)

	end

	updateCanvas()
end

--==================================================
-- DISTÂNCIA
--==================================================

local function updateDistances()

	local character =
		player.Character

	if not character then
		return
	end

	local root =
		character:FindFirstChild(
			"HumanoidRootPart"
		)

	if not root then
		return
	end

	for obj, data in pairs(
		detected
	) do

		if obj.Parent then

			local position

			if obj:IsA("BasePart") then

				position =
					obj.Position

			elseif obj:IsA("Model") then

				position =
					obj:GetPivot().Position

			end

			if position then

				local distance =
					(
						root.Position -
						position
					).Magnitude

				data.Distance.Text =
					"📍 " ..
					math.floor(
						distance
					) ..
					" studs"

			end
		end
	end
end

--==================================================
-- MONITORAR NOVOS OBJETOS
--==================================================

workspace.DescendantAdded:Connect(
	function()

		task.delay(
			0.1,
			function()

				if gui.Parent then
					scan()
				end

			end
		)

	end
)

--==================================================
-- MONITORAR REMOÇÕES
--==================================================

workspace.DescendantRemoving:Connect(
	function()

		task.delay(
			0.05,
			function()

				if gui.Parent then
					scan()
				end

			end
		)

	end
)

--==================================================
-- INICIALIZAÇÃO
--==================================================

status.Text =
	"🟢 Sistema carregado"

status.TextColor3 =
	Color3.fromRGB(
		100,
		255,
		120
	)

task.wait(0.5)

scan()

--==================================================
-- LOOP
--==================================================

task.spawn(function()

	while gui.Parent do

		scan()

		task.wait(0.5)

	end

end)

--==================================================
-- ATUALIZAR DISTÂNCIAS
--==================================================

RunService.RenderStepped:Connect(
	function()

		if gui.Parent then
			updateDistances()
		end

	end
)
```
