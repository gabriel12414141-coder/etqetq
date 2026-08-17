local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local detected = {}

local FRUITS = {
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

local function isFruitName(name)
	-- Aceita "Fruit" sozinho
	if name == "Fruit" then
		return true
	end

	for _, fruit in ipairs(FRUITS) do
		-- Aceita:
		-- Dragon Fruit
		-- DragonFruit
		if name == fruit .. " Fruit" or name == fruit .. "Fruit" then
			return true
		end
	end

	return false
end

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

local function createESP(object)
	if not isFruitName(object.Name) then
		return
	end

	if detected[object] then
		return
	end

	local part = getPart(object)

	if not part then
		return
	end

	detected[object] = true

	local gui = Instance.new("BillboardGui")
	gui.Name = "FruitNotifier"
	gui.Adornee = part
	gui.Size = UDim2.fromOffset(110, 38)
	gui.StudsOffset = Vector3.new(0, 3, 0)
	gui.AlwaysOnTop = true
	gui.MaxDistance = 0
	gui.Parent = part

	local label = Instance.new("TextLabel")
	label.BackgroundTransparency = 1
	label.Size = UDim2.fromScale(1, 1)
	label.Font = Enum.Font.Gotham
	label.TextSize = 12
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.4
	label.Text = object.Name .. "\n0 m"
	label.Parent = gui

	local connection

	connection = RunService.RenderStepped:Connect(function()
		if not object.Parent or not part.Parent then
			connection:Disconnect()
			detected[object] = nil
			gui:Destroy()
			return
		end

		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if root then
			local studs = (root.Position - part.Position).Magnitude
			local meters = studs * 0.28

			label.Text = object.Name .. string.format("\n%.0f m", meters)
		end
	end)
end

-- Detecta as frutas que já existem
for _, object in ipairs(Workspace:GetDescendants()) do
	createESP(object)
end

-- Detecta frutas que surgirem
Workspace.DescendantAdded:Connect(function(object)
	task.defer(function()
		createESP(object)
	end)
end)
