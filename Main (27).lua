-- Fruit Notifier
-- LocalScript -> StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer

-- Coloque aqui os nomes EXATOS das frutas do seu jogo
local FRUITS = {
	["Rocket"] = true,
	["Spin"] = true,
	["Blade"] = true,
	["Spring"] = true,
	["Bomb"] = true,
	["Smoke"] = true,
	["Flame"] = true,
	["Ice"] = true,
	["Sand"] = true,
	["Dark"] = true,
	["Light"] = true,
	["Magma"] = true,
	["Quake"] = true,
	["Buddha"] = true,
	["Love"] = true,
	["Spider"] = true,
	["Phoenix"] = true,
	["Portal"] = true,
	["Rumble"] = true,
	["Pain"] = true,
	["Blizzard"] = true,
	["Gravity"] = true,
	["Mammoth"] = true,
	["T-Rex"] = true,
	["Dough"] = true,
	["Shadow"] = true,
	["Venom"] = true,
	["Control"] = true,
	["Spirit"] = true,
	["Leopard"] = true,
	["Kitsune"] = true,
	["Dragon"] = true,
}

-- Evita notificações duplicadas
local detected = {}

local function getRoot()
	local character = player.Character
	if not character then
		return nil
	end

	return character:FindFirstChild("HumanoidRootPart")
end

local function getFruitPosition(object)
	if object:IsA("BasePart") then
		return object.Position
	end

	if object:IsA("Model") then
		if object.PrimaryPart then
			return object.PrimaryPart.Position
		end

		local part = object:FindFirstChildWhichIsA("BasePart", true)

		if part then
			return part.Position
		end
	end

	return nil
end

local function notifyFruit(fruit)
	if detected[fruit] then
		return
	end

	detected[fruit] = true

	local root = getRoot()
	local position = getFruitPosition(fruit)

	local distanceText = "distância desconhecida"

	if root and position then
		local distance = (root.Position - position).Magnitude
		distanceText = string.format("%.0f studs", distance)
	end

	local fruitName = fruit.Name

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "🍎 FRUTA ENCONTRADA!",
			Text = fruitName .. " • " .. distanceText,
			Duration = 8
		})
	end)

	-- Se a fruta for destruída, permite detectar outra fruta com o mesmo nome
	fruit.AncestryChanged:Connect(function(_, parent)
		if not parent then
			detected[fruit] = nil
		end
	end)
end

local function checkObject(object)
	if not object then
		return
	end

	-- Primeiro tenta pelo nome exato
	if FRUITS[object.Name] then
		notifyFruit(object)
		return
	end

	-- Também aceita nomes terminando em "Fruit"
	-- Exemplo: "DragonFruit", "KitsuneFruit"
	if object.Name:sub(-5) == "Fruit" then
		notifyFruit(object)
	end
end

-- Frutas que já existem no Workspace
for _, object in ipairs(Workspace:GetDescendants()) do
	checkObject(object)
end

-- Detecta frutas novas imediatamente
Workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		checkObject(object)
	end)
end)

print("[Fruit Notifier] Ativado.")
