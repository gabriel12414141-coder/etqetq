```lua
--========================================================--
--              FRUIT NOTIFIER - GUI TEST                --
--                    LocalScript                         --
--========================================================--

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove GUI anterior
local old = playerGui:FindFirstChild("FruitNotifierGUI")
if old then
    old:Destroy()
end

--========================================================--
-- CONFIG
--========================================================--

local Enabled = true

--========================================================--
-- SCREEN GUI
--========================================================--

local gui = Instance.new("ScreenGui")
gui.Name = "FruitNotifierGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--========================================================--
-- MAIN
--========================================================--

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 360, 0, 430)
main.Position = UDim2.new(0.5, -180, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(60, 60, 75)
stroke.Thickness = 1
stroke.Parent = main

--========================================================--
-- HEADER
--========================================================--

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 70)
header.BackgroundColor3 = Color3.fromRGB(25, 25, 34)
header.BorderSizePixel = 0
header.Parent = main

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 14)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 35)
title.Position = UDim2.new(0, 15, 0, 8)
title.BackgroundTransparency = 1
title.Text = "🍎  FRUIT NOTIFIER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -30, 0, 20)
subtitle.Position = UDim2.new(0, 15, 0, 43)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Sistema de detecção"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 165)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = header

--========================================================--
-- STATUS
--========================================================--

local statusFrame = Instance.new("Frame")
statusFrame.Size = UDim2.new(1, -30, 0, 55)
statusFrame.Position = UDim2.new(0, 15, 0, 85)
statusFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 37)
statusFrame.BorderSizePixel = 0
statusFrame.Parent = main

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 10)
statusCorner.Parent = statusFrame

local statusDot = Instance.new("TextLabel")
statusDot.Size = UDim2.new(0, 30, 1, 0)
statusDot.Position = UDim2.new(0, 10, 0, 0)
statusDot.BackgroundTransparency = 1
statusDot.Text = "●"
statusDot.TextColor3 = Color3.fromRGB(80, 255, 120)
statusDot.TextSize = 20
statusDot.Font = Enum.Font.GothamBold
statusDot.Parent = statusFrame

local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(1, -50, 1, 0)
statusText.Position = UDim2.new(0, 42, 0, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "NOTIFICADOR ATIVO"
statusText.TextColor3 = Color3.fromRGB(230, 230, 235)
statusText.TextSize = 14
statusText.Font = Enum.Font.GothamBold
statusText.TextXAlignment = Enum.TextXAlignment.Left
statusText.Parent = statusFrame

--========================================================--
-- BOTÃO ATIVAR
--========================================================--

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -30, 0, 42)
toggle.Position = UDim2.new(0, 15, 0, 155)
toggle.BackgroundColor3 = Color3.fromRGB(45, 45, 58)
toggle.BorderSizePixel = 0
toggle.Text = "DESATIVAR"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.TextSize = 14
toggle.Font = Enum.Font.GothamBold
toggle.Parent = main

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 9)
toggleCorner.Parent = toggle

--========================================================--
-- BOTÃO TESTE
--========================================================--

local test = Instance.new("TextButton")
test.Size = UDim2.new(1, -30, 0, 42)
test.Position = UDim2.new(0, 15, 0, 205)
test.BackgroundColor3 = Color3.fromRGB(65, 85, 150)
test.BorderSizePixel = 0
test.Text = "🧪  TESTAR FRUTA"
test.TextColor3 = Color3.fromRGB(255, 255, 255)
test.TextSize = 14
test.Font = Enum.Font.GothamBold
test.Parent = main

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 9)
testCorner.Parent = test

--========================================================--
-- HISTÓRICO
--========================================================--

local historyTitle = Instance.new("TextLabel")
historyTitle.Size = UDim2.new(1, -30, 0, 25)
historyTitle.Position = UDim2.new(0, 15, 0, 260)
historyTitle.BackgroundTransparency = 1
historyTitle.Text = "HISTÓRICO"
historyTitle.TextColor3 = Color3.fromRGB(170, 170, 185)
historyTitle.TextSize = 12
historyTitle.Font = Enum.Font.GothamBold
historyTitle.TextXAlignment = Enum.TextXAlignment.Left
historyTitle.Parent = main

local history = Instance.new("ScrollingFrame")
history.Size = UDim2.new(1, -30, 0, 115)
history.Position = UDim2.new(0, 15, 0, 290)
history.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
history.BorderSizePixel = 0
history.ScrollBarThickness = 3
history.CanvasSize = UDim2.new(0, 0, 0, 0)
history.Parent = main

local historyCorner = Instance.new("UICorner")
historyCorner.CornerRadius = UDim.new(0, 9)
historyCorner.Parent = history

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = history

--========================================================--
-- FUNÇÃO HISTÓRICO
--========================================================--

local function addHistory(text)

    local item = Instance.new("TextLabel")
    item.Size = UDim2.new(1, -10, 0, 27)
    item.BackgroundTransparency = 1
    item.Text = text
    item.TextColor3 = Color3.fromRGB(220, 220, 225)
    item.TextSize = 12
    item.Font = Enum.Font.Gotham
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.Parent = history

    task.wait()

    history.CanvasSize = UDim2.new(
        0,
        0,
        0,
        layout.AbsoluteContentSize.Y + 8
    )

    history.CanvasPosition = Vector2.new(
        0,
        layout.AbsoluteContentSize.Y
    )
end

--========================================================--
-- NOTIFICAÇÃO
--========================================================--

local function notifyFruit(name)

    addHistory(
        "🍎 " .. name .. "  •  " .. os.date("%H:%M:%S")
    )

    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "🍎 FRUIT DETECTADA",
            Text = name,
            Duration = 5
        })
    end)
end

--========================================================--
-- TOGGLE
--========================================================--

toggle.MouseButton1Click:Connect(function()

    Enabled = not Enabled

    if Enabled then

        statusDot.TextColor3 = Color3.fromRGB(80, 255, 120)
        statusText.Text = "NOTIFICADOR ATIVO"
        toggle.Text = "DESATIVAR"

        addHistory("✓ Notificador ativado")

    else

        statusDot.TextColor3 = Color3.fromRGB(255, 80, 80)
        statusText.Text = "NOTIFICADOR DESATIVADO"
        toggle.Text = "ATIVAR"

        addHistory("✕ Notificador desativado")

    end
end)

--========================================================--
-- TESTE
--========================================================--

test.MouseButton1Click:Connect(function()

    if not Enabled then
        addHistory("⚠ Notificador está desativado")
        return
    end

    notifyFruit("Dragon Fruit")

end)

--========================================================--
-- ARRASTAR JANELA
--========================================================--

local UserInputService = game:GetService("UserInputService")

local dragging = false
local dragStart
local startPos

header.InputBegan:Connect(function(input)

    if input.UserInputType == Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPos = main.Position

        input.Changed:Connect(function()

            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end

        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)

    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then

        local delta = input.Position - dragStart

        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )

    end
end)

--========================================================--
-- INICIALIZAÇÃO
--========================================================--

addHistory("✓ Fruit Notifier iniciado")
addHistory("✓ GUI carregada")
```
