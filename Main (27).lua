local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local FruitsFolder = workspace:WaitForChild("Fruits")

--==================================================
-- CONFIGURAÇÃO
--==================================================

local Settings = {
	Enabled = true,

	ShowDistance = true,

	MaxDistance = 5000,

	TextSize = 11,

	Height = 3,

	StudsOffset = Vector3.new(0, 3, 0)
}

--==================================================
-- CORES DAS FRUTAS
--==================================================

local FruitColors = {
	Rocket = Color3.fromRGB(180, 180, 180),
	Spin = Color3.fromRGB(170, 170, 170),
	Blade = Color3.fromRGB(210, 210, 210),

	Smoke = Color3.fromRGB(190, 190, 190),
	Flame = Color3.fromRGB(255, 90, 30),
	Ice = Color3.fromRGB(80, 210, 255),

	Sand = Color3.fromRGB(220, 190, 100),
	Dark = Color3.fromRGB(130, 70, 180),
	Light = Color3.fromRGB(255, 235, 80),

	Magma = Color3.fromRGB(255, 70, 20),
	Ghost = Color3.fromRGB(180, 140, 255),

	Dragon = Color3.fromRGB(255, 80, 80),
	Buddha = Color3.fromRGB(255, 200, 70),
	Leopard = Color3.fromRGB(255, 170, 50),
	Dough = Color3.fromRGB(255, 130, 180)
}

--==================================================
-- FUNÇÕES
--==================================================

local FruitTags = {}

local function GetFruitPosition(Fruit)
	if Fruit:IsA("BasePart") then
		return Fruit.Position
	end

	if Fruit:IsA("Model") then
		return Fruit:GetPivot().Position
	end

	return nil
end

local function GetFruitColor(FruitName)
	return FruitColors[FruitName] or Color3.fromRGB(255, 255, 255)
end

local function CreateFruitTag(Fruit)
	if FruitTags[Fruit] then
		return
	end

	local Position = GetFruitPosition(Fruit)

	if not Position then
		return
	end

	local Adornee

	if Fruit:IsA("BasePart") then
		Adornee = Fruit
	elseif Fruit:IsA("Model") then
		Adornee = Fruit:FindFirstChildWhichIsA("BasePart", true)
	end

	if not Adornee then
		return
	end

	--==================================================
	-- BILLBOARD GUI
	--==================================================

	local Billboard = Instance.new("BillboardGui")

	Billboard.Name = "FruitFinder"
	Billboard.Adornee = Adornee

	Billboard.Size = UDim2.fromOffset(120, 25)

	Billboard.StudsOffset = Settings.StudsOffset

	Billboard.AlwaysOnTop = true

	Billboard.MaxDistance = Settings.MaxDistance

	Billboard.Parent = PlayerGui

	--==================================================
	-- TEXTO
	--==================================================

	local Label = Instance.new("TextLabel")

	Label.Name = "Fruit"

	Label.BackgroundTransparency = 1

	Label.Size = UDim2.fromScale(1, 1)

	Label.Font = Enum.Font.GothamBold

	Label.TextSize = Settings.TextSize

	Label.TextColor3 = GetFruitColor(Fruit.Name)

	Label.TextStrokeTransparency = 0.35

	Label.Text = Fruit.Name

	Label.Parent = Billboard

	FruitTags[Fruit] = Billboard

	--==================================================
	-- LIMPEZA
	--==================================================

	Fruit.AncestryChanged:Connect(function(_, Parent)
		if not Parent then

			if FruitTags[Fruit] then
				FruitTags[Fruit]:Destroy()
				FruitTags[Fruit] = nil
			end

		end
	end)
end

local function RemoveFruitTag(Fruit)
	local Tag = FruitTags[Fruit]

	if Tag then
		Tag:Destroy()
		FruitTags[Fruit] = nil
	end
end

--==================================================
-- DETECTAR FRUTAS
--==================================================

local function ScanFruits()

	for _, Fruit in ipairs(FruitsFolder:GetChildren()) do

		if Fruit:IsA("Model") or Fruit:IsA("BasePart") then
			CreateFruitTag(Fruit)
		end

	end

end

FruitsFolder.ChildAdded:Connect(function(Fruit)

	task.wait()

	if Fruit:IsA("Model") or Fruit:IsA("BasePart") then
		CreateFruitTag(Fruit)
	end

end)

FruitsFolder.ChildRemoved:Connect(function(Fruit)
	RemoveFruitTag(Fruit)
end)

--==================================================
-- DISTÂNCIA
--==================================================

RunService.RenderStepped:Connect(function()

	if not Settings.Enabled then
		return
	end

	local Character = Player.Character

	if not Character then
		return
	end

	local Root = Character:FindFirstChild("HumanoidRootPart")

	if not Root then
		return
	end

	for Fruit, Billboard in pairs(FruitTags) do

		if Fruit.Parent and Billboard.Parent then

			local Position = GetFruitPosition(Fruit)

			if Position then

				local Distance = (Root.Position - Position).Magnitude

				local Label = Billboard:FindFirstChild("Fruit")

				if Label then

					if Settings.ShowDistance then

						Label.Text = string.format(
							"%s • %dm",
							Fruit.Name,
							math.floor(Distance)
						)

					else

						Label.Text = Fruit.Name

					end

				end

			end

		end

	end

end)

--==================================================
-- INICIALIZAÇÃO
--==================================================

ScanFruits()
