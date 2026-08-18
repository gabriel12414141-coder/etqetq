local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local fruits = {}
local retrying = {}

local VALID_FRUITS = {
	["Fruit"] = true,

	["Rocket Fruit"] = true,
	["RocketFruit"] = true,
	["Spin Fruit"] = true,
	["SpinFruit"] = true,
	["Blade Fruit"] = true,
	["BladeFruit"] = true,
	["Spring Fruit"] = true,
	["SpringFruit"] = true,
	["Bomb Fruit"] = true,
	["BombFruit"] = true,
	["Smoke Fruit"] = true,
	["SmokeFruit"] = true,
	["Spike Fruit"] = true,
	["SpikeFruit"] = true,
	["Flame Fruit"] = true,
	["FlameFruit"] = true,
	["Ice Fruit"] = true,
	["IceFruit"] = true,
	["Sand Fruit"] = true,
	["SandFruit"] = true,
	["Dark Fruit"] = true,
	["DarkFruit"] = true,
	["Eagle Fruit"] = true,
	["EagleFruit"] = true,
	["Diamond Fruit"] = true,
	["DiamondFruit"] = true,
	["Light Fruit"] = true,
	["LightFruit"] = true,
	["Rubber Fruit"] = true,
	["RubberFruit"] = true,
	["Ghost Fruit"] = true,
	["GhostFruit"] = true,
	["Magma Fruit"] = true,
	["MagmaFruit"] = true,
	["Quake Fruit"] = true,
	["QuakeFruit"] = true,
	["Buddha Fruit"] = true,
	["BuddhaFruit"] = true,
	["Love Fruit"] = true,
	["LoveFruit"] = true,
	["Creation Fruit"] = true,
	["CreationFruit"] = true,
	["Spider Fruit"] = true,
	["SpiderFruit"] = true,
	["Sound Fruit"] = true,
	["SoundFruit"] = true,
	["Phoenix Fruit"] = true,
	["PhoenixFruit"] = true,
	["Portal Fruit"] = true,
	["PortalFruit"] = true,
	["Lightning Fruit"] = true,
	["LightningFruit"] = true,
	["Pain Fruit"] = true,
	["PainFruit"] = true,
	["Blizzard Fruit"] = true,
	["BlizzardFruit"] = true,
	["Gravity Fruit"] = true,
	["GravityFruit"] = true,
	["Mammoth Fruit"] = true,
	["MammothFruit"] = true,
	["T-Rex Fruit"] = true,
	["T-RexFruit"] = true,
	["Dough Fruit"] = true,
	["DoughFruit"] = true,
	["Shadow Fruit"] = true,
	["ShadowFruit"] = true,
	["Venom Fruit"] = true,
	["VenomFruit"] = true,
	["Gas Fruit"] = true,
	["GasFruit"] = true,
	["Spirit Fruit"] = true,
	["SpiritFruit"] = true,
	["Tiger Fruit"] = true,
	["TigerFruit"] = true,
	["Yeti Fruit"] = true,
	["YetiFruit"] = true,
	["Kitsune Fruit"] = true,
	["KitsuneFruit"] = true,
	["Control Fruit"] = true,
	["ControlFruit"] = true,
	["Dragon Fruit"] = true,
	["DragonFruit"] = true,
}

local function getPart(object)
	if object:IsA("BasePart") then
		return object
	end

	if object:IsA("Model") then
		return object.PrimaryPart
			or object:FindFirstChildWhichIsA("BasePart", true)
	end

	return nil
end

local function detect(object)

	-- MUITO IMPORTANTE:
	-- só aceita fruta que seja filha DIRETA do Workspace
	if object.Parent ~= Workspace then
		return
	end

	if not VALID_FRUITS[object.Name] then
		return
	end

	if fruits[object] or retrying[object] then
		return
	end

	local part = getPart(object)

	if not part then
		retrying[object] = true

		task.spawn(function()
			for _ = 1, 10 do
				if not object.Parent then
					break
				end

				task.wait(0.1)

				if object.Parent ~= Workspace then
					break
				end

				local newPart = getPart(object)

				if newPart then
					detect(object)
					break
				end
			end

			retrying[object] = nil
		end)

		return
	end

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitNotifier"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(130, 45)
	gui.StudsOffset = Vector3.new(0, 4, 0)
	gui.MaxDistance = 0
	gui.AlwaysOnTop = true
	gui.LightInfluence = 0
	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.GothamBold
	label.TextSize = 13
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.15
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.Text = object.Name .. "\n0 m"
	label.Parent = gui

	fruits[object] = {
		part = part,
		gui = gui,
		label = label
	}
end

-- Objetos que já estão no Workspace
for _, object in ipairs(Workspace:GetChildren()) do
	detect(object)
end

-- Novos objetos diretamente no Workspace
Workspace.ChildAdded:Connect(function(object)
	task.defer(function()
		detect(object)
	end)
end)

-- Atualização leve da distância
local timer = 0

RunService.Heartbeat:Connect(function(dt)
	timer += dt

	if timer < 0.1 then
		return
	end

	timer = 0

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	for object, data in pairs(fruits) do
		if object.Parent ~= Workspace or not data.part.Parent then
			if data.gui then
				data.gui:Destroy()
			end

			fruits[object] = nil
		else
			local distance = (root.Position - data.part.Position).Magnitude
			local meters = distance * 0.28

			data.label.Text = object.Name .. string.format("\n%.0f m", meters)
		end
	end
end)
