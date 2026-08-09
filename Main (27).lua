--========================================================
-- FRUIT FINDER - SISTEMA COMPLETO
-- Coloque em ServerScriptService
--========================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

--========================================================
-- CONFIGURAÇÃO
--========================================================

local API_URL = "https://SEU-SERVIDOR.com/api/identify"

local UPDATE_TIME = 1

--========================================================
-- FUNÇÕES
--========================================================

local function getFruitPart(fruit)

	if fruit:IsA("BasePart") then
		return fruit
	end

	if fruit.PrimaryPart then
		return fruit.PrimaryPart
	end

	local handle =
		fruit:FindFirstChild(
			"Handle",
			true
		)

	if handle and handle:IsA("BasePart") then
		return handle
	end

	return fruit:FindFirstChildWhichIsA(
		"BasePart",
		true
	)
end

--========================================================
-- DADOS PARA A API
--========================================================

local function collectFruitData(fruit)

	local data = {
		name = fruit.Name,
		attributes = fruit:GetAttributes(),
		parts = {}
	}

	for _, object in ipairs(
		fruit:GetDescendants()
	) do

		if object:IsA("MeshPart") then

			table.insert(
				data.parts,
				{
					class = "MeshPart",
					name = object.Name,
					meshId = object.MeshId,
					textureId = object.TextureID,

					size = {
						x = object.Size.X,
						y = object.Size.Y,
						z = object.Size.Z
					}
				}
			)

		elseif object:IsA("Part") then

			table.insert(
				data.parts,
				{
					class = "Part",
					name = object.Name,

					size = {
						x = object.Size.X,
						y = object.Size.Y,
						z = object.Size.Z
					}
				}
			)
		end
	end

	return data
end

--========================================================
-- CONSULTAR API
--========================================================

local function identifyFruit(fruit)

	local data =
		collectFruitData(fruit)

	local success, response =
		pcall(function()

			return HttpService:PostAsync(
				API_URL,
				HttpService:JSONEncode(data),
				Enum.HttpContentType.ApplicationJson
			)

		end)

	if not success then

		warn(
			"[FruitFinder] API:",
			response
		)

		return "Fruit", 0
	end

	local decodeSuccess, result =
		pcall(function()

			return HttpService:JSONDecode(
				response
			)

		end)

	if not decodeSuccess
		or type(result) ~= "table" then

		return "Fruit", 0
	end

	return (
		result.name or "Fruit"
	),
	(
		result.confidence or 0
	)
end

--========================================================
-- CRIAR GUI
--========================================================

local function createGUI(player)

	local playerGui =
		player:WaitForChild(
			"PlayerGui"
		)

	local old =
		playerGui:FindFirstChild(
			"FruitFinder"
		)

	if old then
		old:Destroy()
	end

	local gui =
		Instance.new("ScreenGui")

	gui.Name =
		"FruitFinder"

	gui.ResetOnSpawn = false

	gui.Parent =
		playerGui

	--====================================================
	-- PAINEL
	--====================================================

	local main =
		Instance.new("Frame")

	main.Size =
		UDim2.fromOffset(380,430)

	main.Position =
		UDim2.fromOffset(30,100)

	main.BackgroundColor3 =
		Color3.fromRGB(24,24,24)

	main.BorderSizePixel = 0

	main.Active = true

	main.Parent = gui

	local corner =
		Instance.new("UICorner")

	corner.CornerRadius =
		UDim.new(0,12)

	corner.Parent = main

	--====================================================
	-- HEADER
	--====================================================

	local header =
		Instance.new("TextButton")

	header.Size =
		UDim2.new(1,0,0,55)

	header.BackgroundColor3 =
		Color3.fromRGB(38,38,38)

	header.BorderSizePixel = 0

	header.Text =
		"🍎  FRUIT FINDER"

	header.TextColor3 =
		Color3.new(1,1,1)

	header.TextSize = 18

	header.Font =
		Enum.Font.GothamBold

	header.TextXAlignment =
		Enum.TextXAlignment.Left

	header.AutoButtonColor = false

	header.Parent = main

	local headerPadding =
		Instance.new("UIPadding")

	headerPadding.PaddingLeft =
		UDim.new(0,12)

	headerPadding.Parent =
		header

	--====================================================
	-- MINIMIZAR
	--====================================================

	local minimize =
		Instance.new("TextButton")

	minimize.Size =
		UDim2.fromOffset(40,40)

	minimize.Position =
		UDim2.new(1,-45,0,7)

	minimize.BackgroundTransparency = 1

	minimize.Text =
		"−"

	minimize.TextColor3 =
		Color3.new(1,1,1)

	minimize.TextSize = 25

	minimize.Font =
		Enum.Font.GothamBold

	minimize.Parent =
		main

	--====================================================
	-- LISTA
	--====================================================

	local list =
		Instance.new("ScrollingFrame")

	list.Position =
		UDim2.fromOffset(10,65)

	list.Size =
		UDim2.new(1,-20,1,-75)

	list.BackgroundTransparency = 1

	list.BorderSizePixel = 0

	list.ScrollBarThickness = 5

	list.Parent =
		main

	local layout =
		Instance.new("UIListLayout")

	layout.Padding =
		UDim.new(0,6)

	layout.Parent =
		list

	--====================================================
	-- ARRASTAR
	--====================================================

	local dragging = false
	local dragStart
	local startPosition

	header.MouseButton1Down:Connect(
		function(x,y)

			dragging = true

			dragStart =
				Vector2.new(x,y)

			startPosition =
				main.Position

		end
	)

	header.MouseButton1Up:Connect(
		function()

			dragging = false

		end
	)

	header.MouseMoved:Connect(
		function(x,y)

			if not dragging then
				return
			end

			local delta =
				Vector2.new(x,y)
				- dragStart

			main.Position =
				UDim2.new(
					startPosition.X.Scale,
					startPosition.X.Offset
						+ delta.X,

					startPosition.Y.Scale,
					startPosition.Y.Offset
						+ delta.Y
				)
		end
	)

	--====================================================
	-- MINIMIZAR
	--====================================================

	local minimized = false

	minimize.MouseButton1Click:Connect(
		function()

			minimized =
				not minimized

			if minimized then

				list.Visible = false

				main.Size =
					UDim2.fromOffset(
						380,
						55
					)

				minimize.Text =
					"+"

			else

				list.Visible = true

				main.Size =
					UDim2.fromOffset(
						380,
						430
					)

				minimize.Text =
					"−"

			end
		end
	)

	--====================================================
	-- ATUALIZAÇÃO
	--====================================================

	task.spawn(
		function()

			while gui.Parent do

				if not minimized then

					for _, child in ipairs(
						list:GetChildren()
					) do

						if child:IsA("Frame")
							or child:IsA("TextLabel") then

							child:Destroy()

						end
					end

					local fruits = {}

					for _, object in ipairs(
						workspace:GetDescendants()
					) do

						if object:IsA("Model")
							and object.Name == "Fruit" then

							table.insert(
								fruits,
								object
							)

						end
					end

					if #fruits == 0 then

						local empty =
							Instance.new(
								"TextLabel"
							)

						empty.Size =
							UDim2.new(
								1,
								-10,
								0,
								45
							)

						empty.BackgroundTransparency = 1

						empty.Text =
							"Nenhuma fruta encontrada"

						empty.TextColor3 =
							Color3.fromRGB(
								170,
								170,
								170
							)

						empty.TextSize = 14

						empty.Font =
							Enum.Font.Gotham

						empty.Parent =
							list

					else

						for _, fruit in ipairs(
							fruits
						) do

							local name =
								"Pesquisando..."

							local confidence =
								0

							-- Consulta a API
							task.spawn(
								function()

									name,
									confidence =
										identifyFruit(
											fruit
										)

								end
							)

							local item =
								Instance.new(
									"Frame"
								)

							item.Size =
								UDim2.new(
									1,
									-10,
									0,
									65
								)

							item.BackgroundColor3 =
								Color3.fromRGB(
									45,
									45,
									45
								)

							item.BorderSizePixel = 0

							item.Parent =
								list

							local text =
								Instance.new(
									"TextLabel"
								)

							text.Size =
								UDim2.new(
									1,
									-100,
									1,
									0
								)

							text.Position =
								UDim2.fromOffset(
									10,
									0
								)

							text.BackgroundTransparency =
								1

							text.Text =
								"🍎 " .. name

							text.TextColor3 =
								Color3.new(
									1,
									1,
									1
								)

							text.TextSize = 14

							text.Font =
								Enum.Font.GothamBold

							text.TextXAlignment =
								Enum.TextXAlignment.Left

							text.Parent =
								item

							--================================================
							-- BOTÃO IR ATÉ
							--================================================

							local go =
								Instance.new(
									"TextButton"
								)

							go.Size =
								UDim2.fromOffset(
									85,
									34
								)

							go.Position =
								UDim2.new(
									1,
									-95,
									0,
									15
								)

							go.BackgroundColor3 =
								Color3.fromRGB(
									55,
									120,
									70
								)

							go.BorderSizePixel = 0

							go.Text =
								"IR ATÉ"

							go.TextColor3 =
								Color3.new(
									1,
									1,
									1
								)

							go.TextSize = 12

							go.Font =
								Enum.Font.GothamBold

							go.Parent =
								item

							go.MouseButton1Click:Connect(
								function()

									local character =
										player.Character

									if not character then
										return
									end

									local humanoid =
										character:
										FindFirstChildOfClass(
											"Humanoid"
										)

									local part =
										getFruitPart(
											fruit
										)

									if humanoid
										and part then

										humanoid:MoveTo(
											part.Position
										)

									end
								end
							)
						end
					end

					list.CanvasSize =
						UDim2.new(
							0,
							0,
							0,
							layout.AbsoluteContentSize.Y
							+ 10
						)
				end

				task.wait(
					UPDATE_TIME
				)
			end
		end
	)
end

--========================================================
-- JOGADORES
--========================================================

Players.PlayerAdded:Connect(
	function(player)

		task.spawn(
			function()

				createGUI(player)

			end
		)
	end
)

for _, player in ipairs(
	Players:GetPlayers()
) do

	task.spawn(
		function()

			createGUI(player)

		end
	)
end