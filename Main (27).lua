local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "FruitFinderTest"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(350, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.fromOffset(10, 10)
title.BackgroundTransparency = 1
title.Text = "🍎 FRUIT FINDER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 60)
status.Position = UDim2.fromOffset(10, 75)
status.BackgroundTransparency = 1
status.Text = "MENU FUNCIONANDO"
status.TextColor3 = Color3.fromRGB(80, 255, 120)
status.TextSize = 18
status.Font = Enum.Font.GothamBold
status.Parent = frame

print("[FruitFinder] TESTE EXECUTADO COM SUCESSO")
