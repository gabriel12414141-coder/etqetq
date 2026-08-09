```lua
--#####################################################################
--#                                                                   #
--#                  🍎 FRUIT FINDER - COMPLETE                      #
--#                                                                   #
--#  Sistema de reconhecimento e identificação de frutas             #
--#                                                                   #
--#  • GUI arrastável                                                 #
--#  • GUI minimizável                                                #
--#  • Reconhecimento de Model / BasePart                            #
--#  • Nome exato da fruta                                           #
--#  • Aceita "Dragon" e "Dragon Fruit"                              #
--#  • Aceita maiúsculas/minúsculas                                  #
--#  • Verificação de atributos                                     #
--#  • Nome pequeno acima da fruta                                   #
--#  • Distância até a fruta                                         #
--#  • Detecção automática de novas frutas                           #
--#  • Remoção automática de frutas desaparecidas                    #
--#  • Sistema de diagnóstico                                         #
--#                                                                   #
#####################################################################

--=====================================================================
-- SERVIÇOS
--=====================================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

--=====================================================================
-- JOGADOR
--=====================================================================

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	warn("[FruitFinder] LocalPlayer não encontrado.")
	return
end

local PlayerGui =
	LocalPlayer:WaitForChild(
		"PlayerGui",
		15
	)

if not PlayerGui then
	warn("[FruitFinder] PlayerGui não encontrado.")
	return
end

--=====================================================================
-- CONFIGURAÇÕES
--=====================================================================

local CONFIG = {

	SCAN_INTERVAL = 0.75,

	DISTANCE_INTERVAL = 0.10,

	MAX_TAG_DISTANCE = 1500,

	TAG_HEIGHT = 3,

	TAG_WIDTH = 125,

	TAG_HEIGHT_PIXELS = 28,

	TAG_TEXT_SIZE = 13,

	SHOW_TAGS = true,

	SHOW_DISTANCE = true,

	CHECK_ATTRIBUTES = true,

	MAX_GUI_ENTRIES = 100,

	GUI_WIDTH = 370,

	GUI_HEIGHT = 470,

	GUI_X = 25,

	GUI_Y = 0.5,

}

--=====================================================================
-- LISTA DE FRUTAS
--=====================================================================

local VALID_FRUITS = {

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

	-- CORRETO:
	"Tiger",

	"Kitsune",
	"Dragon",

}

--=====================================================================
-- NORMALIZAÇÃO
--=====================================================================

local function normalizeName(name)

	if name == nil then
		return ""
	end

	name = tostring(name)

	-- Remove espaços das extremidades.
	name =
		name:match("^%s*(.-)%s*$")
		or ""

	-- Remove espaços duplicados.
	name =
		name:gsub("%s+", " ")

	-- Ignora maiúsculas/minúsculas.
	name =
		string.lower(name)

	return name
end

--=====================================================================
-- CRIAR LOOKUP
--=====================================================================

local FruitLookup = {}

for _, fruitName in ipairs(
	VALID_FRUITS
) do

	local normalized =
		normalizeName(
			fruitName
		)

	-- Exemplo:
	-- "dragon" -> "Dragon"
	FruitLookup[normalized] =
		fruitName

	-- Exemplo:
	-- "dragon fruit" -> "Dragon Fruit"
	FruitLookup[
		normalized .. " fruit"
	] =
		fruitName .. " Fruit"

end

--=====================================================================
-- ENCONTRAR NOME VÁLIDO
--=====================================================================

local function getValidFruitName(
	name
)

	local normalized =
		normalizeName(
			name
		)

	if normalized == "" then
		return nil
	end

	return FruitLookup[
		normalized
	]
end

--=====================================================================
-- NOMES IGNORADOS
--=====================================================================

local IGNORED_NAMES = {

	["nametag"] = true,

	["fruitnamedisplay"] = true,

	["fruitfinder"] = true,

	["fruitfindercomplete"] = true,

}

--=====================================================================
-- VERIFICAR NOME IGNORADO
--=====================================================================

local function isIgnored(
	object
)

	if not object then
		return true
	end

	local normalized =
		normalizeName(
			object.Name
		)

	return IGNORED_NAMES[
		normalized
	] == true

end

--=====================================================================
-- PROCURAR FRUTA EM ATRIBUTOS
--=====================================================================

local function findFruitInAttributes(
	object
)

	if not CONFIG.CHECK_ATTRIBUTES then
		return nil
	end

	local attributes =
		object:GetAttributes()

	for _, value in pairs(
		attributes
	) do

		if typeof(value) ==
			"string" then

			local result =
				getValidFruitName(
					value
				)

			if result then
				return result
			end

		end

	end

	return nil
end

--=====================================================================
-- IDENTIFICAR FRUTA
--=====================================================================

local function identifyFruit(
	object
)

	if not object then
		return nil
	end

	if isIgnored(object) then
		return nil
	end

	--=============================================================
	-- NOME DO PRÓPRIO OBJETO
	--=============================================================

	local directName =
		getValidFruitName(
			object.Name
		)

	if directName then
		return directName
	end

	--=============================================================
	-- ATRIBUTOS
	--=============================================================

	local attributeName =
		findFruitInAttributes(
			object
		)

	if attributeName then
		return attributeName
	end

	return nil
end

--=====================================================================
-- REMOVER GUI ANTIGO
--=====================================================================

local OldGui =
	PlayerGui:FindFirstChild(
		"FruitFinderComplete"
	)

if OldGui then
	OldGui:Destroy()
end

--=====================================================================
-- SCREEN GUI
--=====================================================================

local ScreenGui =
	Instance.new(
		"ScreenGui"
	)

ScreenGui.Name =
	"FruitFinderComplete"

ScreenGui.ResetOnSpawn =
	false

ScreenGui.IgnoreGuiInset =
	false

ScreenGui.DisplayOrder =
	9999

ScreenGui.ZIndexBehavior =
	Enum.ZIndexBehavior.Sibling

ScreenGui.Parent =
	PlayerGui

--=====================================================================
-- JANELA
--=====================================================================

local Main =
	Instance.new(
		"Frame"
	)

Main.Name =
	"Main"

Main.Size =
	UDim2.fromOffset(
		CONFIG.GUI_WIDTH,
		CONFIG.GUI_HEIGHT
	)

Main.Position =
	UDim2.new(
		0,
		CONFIG.GUI_X,
		CONFIG.GUI_Y,
		-(CONFIG.GUI_HEIGHT / 2)
	)

Main.BackgroundColor3 =
	Color3.fromRGB(
		24,
		24,
		24
	)

Main.BorderSizePixel =
	0

Main.Parent =
	ScreenGui

local MainCorner =
	Instance.new(
		"UICorner"
	)

MainCorner.CornerRadius =
	UDim.new(
		0,
		12
	)

MainCorner.Parent =
	Main

--=====================================================================
-- BORDA
--=====================================================================

local MainStroke =
	Instance.new(
		"UIStroke"
	)

MainStroke.Color =
	Color3.fromRGB(
		65,
		65,
		65
	)

MainStroke.Thickness =
	1

MainStroke.Parent =
	Main

--=====================================================================
-- HEADER
--=====================================================================

local Header =
	Instance.new(
		"Frame"
	)

Header.Name =
	"Header"

Header.Size =
	UDim2.new(
		1,
		0,
		0,
		48
	)

Header.BackgroundColor3 =
	Color3.fromRGB(
		36,
		36,
		36
	)

Header.BorderSizePixel =
	0

Header.Parent =
	Main

local HeaderCorner =
	Instance.new(
		"UICorner"
	)

HeaderCorner.CornerRadius =
	UDim.new(
		0,
		12
	)

HeaderCorner.Parent =
	Header

--=====================================================================
-- TÍTULO
--=====================================================================

local Title =
	Instance.new(
		"TextLabel"
	)

Title.Name =
	"Title"

Title.Size =
	UDim2.new(
		1,
		-110,
		1,
		0
	)

Title.Position =
	UDim2.fromOffset(
		14,
		0
	)

Title.BackgroundTransparency =
	1

Title.Text =
	"🍎  Fruit Finder"

Title.TextColor3 =
	Color3.fromRGB(
		255,
		255,
		255
	)

Title.TextSize =
	19

Title.Font =
	Enum.Font.GothamBold

Title.TextXAlignment =
	Enum.TextXAlignment.Left

Title.Parent =
	Header

--=====================================================================
-- CONTADOR
--=====================================================================

local Counter =
	Instance.new(
		"TextLabel"
	)

Counter.Size =
	UDim2.fromOffset(
		80,
		20
	)

Counter.Position =
	UDim2.new(
		1,
		-120,
		0,
		14
	)

Counter.BackgroundTransparency =
	1

Counter.Text =
	"0 frutas"

Counter.TextColor3 =
	Color3.fromRGB(
		170,
		170,
		170
	)

Counter.TextSize =
	11

Counter.Font =
	Enum.Font.Gotham

Counter.TextXAlignment =
	Enum.TextXAlignment.Right

Counter.Parent =
	Header

--=====================================================================
-- BOTÃO MINIMIZAR
--=====================================================================

local Minimize =
	Instance.new(
		"TextButton"
	)

Minimize.Name =
	"Minimize"

Minimize.Size =
	UDim2.fromOffset(
		34,
		34
	)

Minimize.Position =
	UDim2.new(
		1,
		-40,
		0,
		7
	)

Minimize.BackgroundColor3 =
	Color3.fromRGB(
		58,
		58,
		58
	)

Minimize.BorderSizePixel =
	0

Minimize.Text =
	"—"

Minimize.TextColor3 =
	Color3.new(
		1,
		1,
		1
	)

Minimize.TextSize =
	20

Minimize.Font =
	Enum.Font.GothamBold

Minimize.Parent =
	Header

local MinCorner =
	Instance.new(
		"UICorner"
	)

MinCorner.CornerRadius =
	UDim.new(
		0,
		7
	)

MinCorner.Parent =
	Minimize

--=====================================================================
-- CONTENT
--=====================================================================

local Content =
	Instance.new(
		"Frame"
	)

Content.Name =
	"Content"

Content.Size =
	UDim2.new(
		1,
		0,
		1,
		-48
	)

Content.Position =
	UDim2.fromOffset(
		0,
		48
	)

Content.BackgroundTransparency =
	1

Content.Parent =
	Main

--=====================================================================
-- STATUS
--=====================================================================

local Status =
	Instance.new(
		"TextLabel"
	)

Status.Name =
	"Status"

Status.Size =
	UDim2.new(
		1,
		-24,
		0,
		38
	)

Status.Position =
	UDim2.fromOffset(
		12,
		4
	)

Status.BackgroundTransparency =
	1

Status.Text =
	"🟢 Sistema carregado"

Status.TextColor3 =
	Color3.fromRGB(
		100,
		255,
		130
	)

Status.TextSize =
	13

Status.Font =
	Enum.Font.Gotham

Status.TextXAlignment =
	Enum.TextXAlignment.Left

Status.Parent =
	Content

--=====================================================================
-- LINHA
--=====================================================================

local Divider =
	Instance.new(
		"Frame"
	)

Divider.Size =
	UDim2.new(
		1,
		-24,
		0,
		1
	)

Divider.Position =
	UDim2.fromOffset(
		12,
		42
	)

Divider.BackgroundColor3 =
	Color3.fromRGB(
		60,
		60,
		60
	)

Divider.BorderSizePixel =
	0

Divider.Parent =
	Content

--=====================================================================
-- LISTA
--=====================================================================

local FruitList =
	Instance.new(
		"ScrollingFrame"
	)

FruitList.Name =
	"FruitList"

FruitList.Size =
	UDim2.new(
		1,
		-24,
		1,
		-55
	)

FruitList.Position =
	UDim2.fromOffset(
		12,
		50
	)

FruitList.BackgroundColor3 =
	Color3.fromRGB(
		13,
		13,
		13
	)

FruitList.BorderSizePixel =
	0

FruitList.ScrollBarThickness =
	5

FruitList.CanvasSize =
	UDim2.new(
		0,
		0,
		0,
		0
	)

FruitList.Parent =
	Content

local ListCorner =
	Instance.new(
		"UICorner"
	)

ListCorner.CornerRadius =
	UDim.new(
		0,
		8
	)

ListCorner.Parent =
	FruitList

local ListLayout =
	Instance.new(
		"UIListLayout"
	)

ListLayout.Padding =
	UDim.new(
		0,
		6
	)

ListLayout.SortOrder =
	Enum.SortOrder.LayoutOrder

ListLayout.Parent =
	FruitList

--=====================================================================
-- ARRASTAR
--=====================================================================

local dragging =
	false

local dragStart =
	nil

local startPosition =
	nil

Header.InputBegan:Connect(
	function(input)

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
				Main.Position

			input.Changed:Connect(
				function()

					if input.UserInputState ==
						Enum.UserInputState.End then

						dragging =
							false

					end

				end
			)

		end

	end
)

UserInputService.InputChanged:Connect(
	function(input)

		if not dragging then
			return
		end

		if input.UserInputType ~=
			Enum.UserInputType.MouseMovement
			and
			input.UserInputType ~=
			Enum.UserInputType.Touch then

			return
		end

		local delta =
			input.Position -
			dragStart

		Main.Position =
			UDim2.new(

				startPosition.X.Scale,

				startPosition.X.Offset +
					delta.X,

				startPosition.Y.Scale,

				startPosition.Y.Offset +
					delta.Y

			)

	end
)

--=====================================================================
-- MINIMIZAR
--=====================================================================

local minimized =
	false

Minimize.MouseButton1Click:Connect(
	function()

		minimized =
			not minimized

		if minimized then

			Content.Visible =
				false

			Main.Size =
				UDim2.fromOffset(
					CONFIG.GUI_WIDTH,
					48
				)

			Minimize.Text =
				"+"

		else

			Content.Visible =
				true

			Main.Size =
				UDim2.fromOffset(
					CONFIG.GUI_WIDTH,
					CONFIG.GUI_HEIGHT
				)

			Minimize.Text =
				"—"

		end

	end
)

--=====================================================================
-- ENCONTRAR ADORNEE
--=====================================================================

local function getAdornee(
	object
)

	if object:IsA(
		"BasePart"
	) then

		return object

	end

	if object:IsA(
		"Model"
	) then

		if object.PrimaryPart then
			return object.PrimaryPart
		end

		return object:FindFirstChildWhichIsA(
			"BasePart",
			true
		)

	end

	return nil
end

--=====================================================================
-- POSIÇÃO
--=====================================================================

local function getPosition(
	object
)

	if object:IsA(
		"BasePart"
	) then

		return object.Position

	end

	if object:IsA(
		"Model"
	) then

		return object:GetPivot().Position

	end

	return nil
end

--=====================================================================
-- CRIAR TAG 3D
--=====================================================================

local function createNameTag(
	object,
	fruitName
)

	if not CONFIG.SHOW_TAGS then
		return nil
	end

	local adornee =
		getAdornee(
			object
		)

	if not adornee then
		return nil
	end

	local oldTag =
		adornee:FindFirstChild(
			"FruitNameDisplay"
		)

	if oldTag then
		oldTag:Destroy()
	end

	local Billboard =
		Instance.new(
			"BillboardGui"
		)

	Billboard.Name =
		"FruitNameDisplay"

	Billboard.Adornee =
		adornee

	Billboard.Size =
		UDim2.fromOffset(
			CONFIG.TAG_WIDTH,
			CONFIG.TAG_HEIGHT_PIXELS
		)

	Billboard.StudsOffset =
		Vector3.new(
			0,
			CONFIG.TAG_HEIGHT,
			0
		)

	Billboard.AlwaysOnTop =
		true

	Billboard.MaxDistance =
		CONFIG.MAX_TAG_DISTANCE

	Billboard.Parent =
		adornee

	local Label =
		Instance.new(
			"TextLabel"
		)

	Label.Size =
		UDim2.fromScale(
			1,
			1
		)

	Label.BackgroundTransparency =
		1

	Label.Text =
		fruitName

	Label.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	Label.TextStrokeTransparency =
		0

	Label.TextSize =
		CONFIG.TAG_TEXT_SIZE

	Label.Font =
		Enum.Font.GothamBold

	Label.Parent =
		Billboard

	return Billboard
end

--=====================================================================
-- CRIAR ITEM
--=====================================================================

local function createEntry(
	fruitName
)

	local Entry =
		Instance.new(
			"Frame"
		)

	Entry.Size =
		UDim2.new(
			1,
			-10,
			0,
			60
		)

	Entry.BackgroundColor3 =
		Color3.fromRGB(
			32,
			32,
			32
		)

	Entry.BorderSizePixel =
		0

	Entry.Parent =
		FruitList

	local Corner =
		Instance.new(
			"UICorner"
		)

	Corner.CornerRadius =
		UDim.new(
			0,
			8
		)

	Corner.Parent =
		Entry

	local NameLabel =
		Instance.new(
			"TextLabel"
		)

	NameLabel.Size =
		UDim2.new(
			1,
			-20,
			0,
			27
		)

	NameLabel.Position =
		UDim2.fromOffset(
			10,
			3
		)

	NameLabel.BackgroundTransparency =
		1

	NameLabel.Text =
		"🍏  " ..
		fruitName

	NameLabel.TextColor3 =
		Color3.new(
			1,
			1,
			1
		)

	NameLabel.TextSize =
		15

	NameLabel.Font =
		Enum.Font.GothamBold

	NameLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	NameLabel.Parent =
		Entry

	local DistanceLabel =
		Instance.new(
			"TextLabel"
		)

	DistanceLabel.Size =
		UDim2.new(
			1,
			-20,
			0,
			20
		)

	DistanceLabel.Position =
		UDim2.fromOffset(
			10,
			32
		)

	DistanceLabel.BackgroundTransparency =
		1

	DistanceLabel.Text =
		"📍 procurando..."

	DistanceLabel.TextColor3 =
		Color3.fromRGB(
			100,
			220,
			130
		)

	DistanceLabel.TextSize =
		11

	DistanceLabel.Font =
		Enum.Font.Gotham

	DistanceLabel.TextXAlignment =
		Enum.TextXAlignment.Left

	DistanceLabel.Parent =
		Entry

	return Entry, DistanceLabel
end

--=====================================================================
-- DADOS
--=====================================================================

local DetectedFruits = {}

--=====================================================================
-- ATUALIZAR CANVAS
--=====================================================================

local function updateCanvas()

	task.defer(
		function()

			FruitList.CanvasSize =
				UDim2.new(
					0,
					0,
					0,
					ListLayout.AbsoluteContentSize.Y
						+ 12
				)

		end
	)

end

--=====================================================================
-- REMOVER DADOS
--=====================================================================

local function removeFruitData(
	object
)

	local data =
		DetectedFruits[
			object
		]

	if not data then
		return
	end

	if data.Entry then

		pcall(
			function()
				data.Entry:Destroy()
			end
		)

	end

	if data.WorldTag then

		pcall(
			function()
				data.WorldTag:Destroy()
			end
		)

	end

	DetectedFruits[
		object
	] = nil

end

--=====================================================================
-- SCAN
--=====================================================================

local function scanWorkspace()

	if not ScreenGui.Parent then
		return
	end

	local current =
		{}

	local found =
		0

	--=============================================================
	-- PERCORRER WORKSPACE
	--=============================================================

	for _, object in ipairs(
		Workspace:GetDescendants()
	) do

		local fruitName =
			identifyFruit(
				object
			)

		if fruitName then

			current[
				object
			] = true

			found += 1

			--=====================================================
			-- NOVA FRUTA
			--=====================================================

			if not DetectedFruits[
				object
			] then

				if found <=
					CONFIG.MAX_GUI_ENTRIES then

					local Entry,
						DistanceLabel =
						createEntry(
							fruitName
						)

					local WorldTag =
						createNameTag(
							object,
							fruitName
						)

					DetectedFruits[
						object
					] = {

						Name =
							fruitName,

						Entry =
							Entry,

						DistanceLabel =
							DistanceLabel,

						WorldTag =
							WorldTag,

					}

				end

			end

		end

	end

	--=============================================================
	-- REMOVER FRUTAS ANTIGAS
	--=============================================================

	for object in pairs(
		DetectedFruits
	) do

		if not current[
			object
		] then

			removeFruitData(
				object
			)

		end

	end

	--=============================================================
	-- STATUS
	--=============================================================

	if found > 0 then

		Status.Text =
			"✅ " ..
			found ..
			" fruta(s) encontrada(s)"

		Status.TextColor3 =
			Color3.fromRGB(
				100,
				255,
				130
			)

	else

		Status.Text =
			"🔎 Nenhuma fruta encontrada"

		Status.TextColor3 =
			Color3.fromRGB(
				190,
				190,
				190
			)

	end

	Counter.Text =
		tostring(found) ..
		" frutas"

	updateCanvas()

end

--=====================================================================
-- DISTÂNCIAS
--=====================================================================

local function updateDistances()

	if not CONFIG.SHOW_DISTANCE then
		return
	end

	local character =
		LocalPlayer.Character

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

	for object, data in pairs(
		DetectedFruits
	) do

		if object
			and object.Parent
			and data
			and data.DistanceLabel then

			local position =
				getPosition(
					object
				)

			if position then

				local distance =
					(
						root.Position -
						position
					).Magnitude

				data.DistanceLabel.Text =
					"📍 " ..
					math.floor(
						distance
					) ..
					" studs"

			else

				data.DistanceLabel.Text =
					"📍 posição indisponível"

			end

		end

	end

end

--=====================================================================
-- NOVOS OBJETOS
--=====================================================================

Workspace.DescendantAdded:Connect(
	function(object)

		task.delay(
			0.15,
			function()

				if not ScreenGui.Parent then
					return
				end

				local fruit =
					identifyFruit(
						object
					)

				if fruit then

					scanWorkspace()

				end

			end
		)

	end
)

--=====================================================================
-- OBJETOS REMOVIDOS
--=====================================================================

Workspace.DescendantRemoving:Connect(
	function(object)

		if DetectedFruits[
			object
		] then

			removeFruitData(
				object
			)

			updateCanvas()

		end

	end
)

--=====================================================================
-- RESPAWN
--=====================================================================

LocalPlayer.CharacterAdded:Connect(
	function()

		task.wait(
			1
		)

		updateDistances()

	end
)

--=====================================================================
-- INICIALIZAÇÃO
--=====================================================================

Status.Text =
	"🟢 Inicializando detector..."

task.wait(
	0.5
)

scanWorkspace()

--=====================================================================
-- LOOP DE SCAN
--=====================================================================

task.spawn(
	function()

		while ScreenGui.Parent do

			task.wait(
				CONFIG.SCAN_INTERVAL
			)

			scanWorkspace()

		end

	end
)

--=====================================================================
-- LOOP DE DISTÂNCIA
--=====================================================================

task.spawn(
	function()

		while ScreenGui.Parent do

			task.wait(
				CONFIG.DISTANCE_INTERVAL
			)

			updateDistances()

		end

	end
)

--=====================================================================
-- DIAGNÓSTICO
--=====================================================================

print(
	"=============================================="
)

print(
	"[FruitFinder] SISTEMA INICIADO"
)

print(
	"[FruitFinder] Frutas cadastradas: "
		.. #VALID_FRUITS
)

print(
	"[FruitFinder] Tiger: ATIVADO"
)

print(
	"[FruitFinder] Leopard: DESATIVADO"
)

print(
	"[FruitFinder] GUI: OK"
)

print(
	"[FruitFinder] Detector: OK"
)

print(
	"=============================================="
)
```
