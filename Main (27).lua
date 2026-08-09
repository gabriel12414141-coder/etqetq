local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("FruitTest")
if old then
    old:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "FruitTest"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(400, 250)
frame.Position = UDim2.new(0.5, -200, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🍎 FRUIT NOTIFIER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = frame

local distance = Instance.new("TextLabel")
distance.Size = UDim2.new(1, -30, 0, 50)
distance.Position = UDim2.fromOffset(15, 65)
distance.BackgroundTransparency = 1
distance.Text = "Distância: aguardando..."
distance.TextColor3 = Color3.fromRGB(100, 210, 255)
distance.TextSize = 18
distance.Font = Enum.Font.GothamBold
distance.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -30, 0, 50)
button.Position = UDim2.fromOffset(15, 130)
button.BackgroundColor3 = Color3.fromRGB(65, 95, 180)
button.BorderSizePixel = 0
button.Text = "TESTAR FRUTA"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16
button.Font = Enum.Font.GothamBold
button.Parent = frame

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = button

button.MouseButton1Click:Connect(function()
    distance.Text = "🍎 Dragon Fruit • 1250 studs"
end)

print("FruitTest GUI carregada")
