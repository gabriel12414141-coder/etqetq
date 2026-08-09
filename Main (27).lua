```lua
-- GUI TESTE - LocalScript

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove versões anteriores
local old = playerGui:FindFirstChild("FruitNotifierTest")

if old then
    old:Destroy()
end

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "FruitNotifierTest"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

-- Janela
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.fromOffset(400, 300)
window.Position = UDim2.new(0.5, -200, 0.5, -150)
window.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
window.BorderSizePixel = 0
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = window

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 50)
title.Position = UDim2.fromOffset(10, 10)
title.BackgroundTransparency = 1
title.Text = "🍎 FRUIT NOTIFIER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 24
title.Font = Enum.Font.GothamBold
title.Parent = window

-- Status
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -40, 0, 35)
status.Position = UDim2.fromOffset(20, 65)
status.BackgroundTransparency = 1
status.Text = "● SISTEMA ATIVO"
status.TextColor3 = Color3.fromRGB(80, 255, 120)
status.TextSize = 16
status.Font = Enum.Font.GothamBold
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = window

-- Botão ativar/desativar
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -40, 0, 45)
toggle.Position = UDim2.fromOffset(20, 110)
toggle.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
toggle.Text = "DESATIVAR"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 15
toggle.Font = Enum.Font.GothamBold
toggle.BorderSizePixel = 0
toggle.Parent = window

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

-- Botão teste
local test = Instance.new("TextButton")
test.Size = UDim2.new(1, -40, 0, 45)
test.Position = UDim2.fromOffset(20, 165)
test.BackgroundColor3 = Color3.fromRGB(70, 100, 180)
test.Text = "🧪 TESTAR FRUTA"
test.TextColor3 = Color3.new(1, 1, 1)
test.TextSize = 15
test.Font = Enum.Font.GothamBold
test.BorderSizePixel = 0
test.Parent = window

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 8)
testCorner.Parent = test

-- Resultado
local result = Instance.new("TextLabel")
result.Size = UDim2.new(1, -40, 0, 35)
result.Position = UDim2.fromOffset(20, 220)
result.BackgroundTransparency = 1
result.Text = "Aguardando teste..."
result.TextColor3 = Color3.fromRGB(180, 180, 190)
result.TextSize = 14
result.Font = Enum.Font.Gotham
result.Parent = window

-- Estado
local enabled = true

-- Toggle
toggle.MouseButton1Click:Connect(function()

    enabled = not enabled

    if enabled then
        status.Text = "● SISTEMA ATIVO"
        status.TextColor3 = Color3.fromRGB(80, 255, 120)
        toggle.Text = "DESATIVAR"
        result.Text = "Notificador ativado."
    else
        status.Text = "● SISTEMA DESATIVADO"
        status.TextColor3 = Color3.fromRGB(255, 80, 80)
        toggle.Text = "ATIVAR"
        result.Text = "Notificador desativado."
    end
end)

-- Teste
test.MouseButton1Click:Connect(function()

    if not enabled then
        result.Text = "Ative o notificador primeiro."
        return
    end

    result.Text = "🍎 Fruta detectada: Dragon Fruit"

end)

-- Mensagem inicial
print("[FruitNotifier] GUI criada com sucesso")
```
