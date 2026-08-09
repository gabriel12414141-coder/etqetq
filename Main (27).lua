--========================================================--
--          FRUIT NOTIFIER - UPDATED VERSION              --
--             9000 STUDS + DISTANCE GUI                  --
--                    LocalScript                         --
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--========================================================--
-- CONFIGURAÇÃO
--========================================================--

local SEARCH_DISTANCE = 9000
local UPDATE_INTERVAL = 0.5

local FruitKeywords = {
    "fruit",
    "bomb",
    "spike",
    "chop",
    "spring",
    "smoke",
    "flame",
    "falcon",
    "ice",
    "sand",
    "dark",
    "light",
    "rubber",
    "barrier",
    "ghost",
    "magma",
    "quake",
    "buddha",
    "love",
    "spider",
    "sound",
    "phoenix",
    "portal",
    "rumble",
    "pain",
    "blizzard",
    "gravity",
    "mammoth",
    "trex",
    "t-rex",
    "dough",
    "shadow",
    "venom",
    "control",
    "spirit",
    "leopard",
    "kitsune",
    "yeti",
    "gas",
    "creation"
}

--========================================================--
-- REMOVER GUI ANTERIOR
--========================================================--

local old = playerGui:FindFirstChild("FruitNotifierUpdated")

if old then
    old:Destroy()
end

--========================================================--
-- GUI
--========================================================--

local gui = Instance.new("ScreenGui")
gui.Name = "FruitNotifierUpdated"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(420, 400)
main.Position = UDim2.new(0.5, -210, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 31)
main.BorderSizePixel = 0
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(70, 70, 85)
stroke.Thickness = 1
stroke.Parent = main

--========================================================--
-- TÍTULO
--========================================================--

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.fromOffset(10, 8)
title.BackgroundTransparency = 1
title.Text = "🍎 FRUIT NOTIFIER"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 23
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 25)
subtitle.Position = UDim2.fromOffset(10, 48)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Detecção: 9.000 studs"
subtitle.TextColor3 = Color3.fromRGB(150, 150, 165)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = main

--========================================================--
-- STATUS
--========================================================--

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 30)
status.Position = UDim2.fromOffset(10, 75)
status.BackgroundTransparency = 1
status.Text = "● PROCURANDO..."
status.TextColor3 = Color3.fromRGB(80, 255, 120)
status.TextSize = 13
status.Font = Enum.Font.GothamBold
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = main

--========================================================--
-- LISTA
--========================================================--

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 0, 200)
list.Position = UDim2.fromOffset(10, 108)
list.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 8)
listCorner.Parent = list

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 7)
padding.PaddingLeft = UDim.new(0, 7)
padding.PaddingRight = UDim.new(0, 7)
padding.PaddingBottom = UDim.new(0, 7)
padding.Parent = list

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = list

--========================================================--
-- BOTÃO DE TESTE
--========================================================--

local testButton = Instance.new("TextButton")
testButton.Size = UDim2.new(1, -20, 0, 42)
testButton.Position = UDim2.fromOffset(10, 320)
testButton.BackgroundColor3 = Color3.fromRGB(65, 95, 180)
testButton.BorderSizePixel = 0
testButton.Text = "🧪 TESTAR DISTÂNCIA"
testButton.TextColor3 = Color3.new(1, 1, 1)
testButton.TextSize = 14
testButton.Font = Enum.Font.GothamBold
testButton.Parent = main

local testCorner = Instance.new("UICorner")
testCorner.CornerRadius = UDim.new(0, 8)
testCorner.Parent = testButton

--========================================================--
-- CONTADOR
--========================================================--

local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, -20, 0, 25)
counter.Position = UDim2.fromOffset(10, 365)
counter.BackgroundTransparency = 1
counter.Text = "0 frutas encontradas"
counter.TextColor3 = Color3.fromRGB(150, 150, 165)
counter.TextSize = 12
counter.Font = Enum.Font.Gotham
counter.TextXAlignment = Enum.TextXAlignment.Left
counter.Parent = main

--========================================================--
-- POSIÇÃO DO OBJETO
--========================================================--

local function getPosition(object)

    if object:IsA("BasePart") then
        return object.Position
    end

    if object:IsA("Model") then

        if object.PrimaryPart then
            return object.PrimaryPart.Position
        end

        local part = object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

        if part then
            return part.Position
        end
    end

    return nil
end

--========================================================--
-- IDENTIFICAÇÃO
--========================================================--

local function isFruit(object)

    local name = string.lower(object.Name)

    for _, keyword in ipairs(FruitKeywords) do

        if string.find(name, keyword, 1, true) then
            return true
        end

    end

    return false
end

--========================================================--
-- ENCONTRAR FRUTAS
--========================================================--

local function findFruits(playerPosition)

    local results = {}

    for _, object in ipairs(workspace:GetDescendants()) do

        if isFruit(object) then

            local position = getPosition(object)

            if position then

                local distance =
                    (position - playerPosition).Magnitude

                if distance <= SEARCH_DISTANCE then

                    table.insert(results, {
                        Name = object.Name,
                        Position = position,
                        Distance = distance
                    })

                end
            end
        end
    end

    table.sort(results, function(a, b)
        return a.Distance < b.Distance
    end)

    return results
end

--========================================================--
-- LIMPAR LISTA
--========================================================--

local function clearList()

    for _, child in ipairs(list:GetChildren()) do

        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end

    end
end

--========================================================--
-- ADICIONAR FRUTA AO GUI
--========================================================--

local function addFruit(name, distance)

    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, 0, 0, 48)
    item.BackgroundColor3 = Color3.fromRGB(28, 28, 37)
    item.BorderSizePixel = 0
    item.Parent = list

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = item

    local fruitName = Instance.new("TextLabel")
    fruitName.Size = UDim2.new(0.65, 0, 1, 0)
    fruitName.Position = UDim2.fromOffset(10, 0)
    fruitName.BackgroundTransparency = 1
    fruitName.Text = "🍎 " .. name
    fruitName.TextColor3 = Color3.fromRGB(235, 235, 240)
    fruitName.TextSize = 13
    fruitName.Font = Enum.Font.GothamBold
    fruitName.TextXAlignment = Enum.TextXAlignment.Left
    fruitName.Parent = item

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Size = UDim2.new(0.35, -10, 1, 0)
    distanceLabel.Position = UDim2.new(0.65, 0, 0, 0)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.Text =
        string.format("%.0f studs", distance)
    distanceLabel.TextColor3 =
        Color3.fromRGB(100, 210, 255)
    distanceLabel.TextSize = 13
    distanceLabel.Font = Enum.Font.GothamBold
    distanceLabel.TextXAlignment = Enum.TextXAlignment.Right
    distanceLabel.Parent = item
end

--========================================================--
-- ATUALIZAÇÃO REAL
--========================================================--

local elapsed = 0

RunService.Heartbeat:Connect(function(delta)

    elapsed += delta

    if elapsed < UPDATE_INTERVAL then
        return
    end

    elapsed = 0

    local character = player.Character

    if not character then
        return
    end

    local root =
        character:FindFirstChild("HumanoidRootPart")

    if not root then
        return
    end

    local fruits = findFruits(root.Position)

    clearList()

    if #fruits == 0 then

        status.Text = "● NENHUMA FRUTA ENCONTRADA"
        status.TextColor3 =
            Color3.fromRGB(255, 190, 80)

        counter.Text = "0 frutas encontradas"

        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 40)
        empty.BackgroundTransparency = 1
        empty.Text = "Nenhuma fruta dentro de 9.000 studs."
        empty.TextColor3 =
            Color3.fromRGB(140, 140, 150)
        empty.TextSize = 13
        empty.Font = Enum.Font.Gotham
        empty.Parent = list

    else

        status.Text =
            "● " .. #fruits .. " FRUTA(S) ENCONTRADA(S)"

        status.TextColor3 =
            Color3.fromRGB(80, 255, 120)

        counter.Text =
            #fruits .. " fruta(s) dentro do raio"

        for _, fruit in ipairs(fruits) do

            addFruit(
                fruit.Name,
                fruit.Distance
            )

        end
    end

    list.CanvasSize = UDim2.new(
        0,
        0,
        0,
        layout.AbsoluteContentSize.Y + 15
    )
end)

--========================================================--
-- BOTÃO DE TESTE
--========================================================--

testButton.MouseButton1Click:Connect(function()

    clearList()

    addFruit(
        "Dragon Fruit [TESTE]",
        1250
    )

    addFruit(
        "Leopard Fruit [TESTE]",
        3870
    )

    addFruit(
        "Kitsune Fruit [TESTE]",
        7420
    )

    status.Text = "● TESTE EXECUTADO"
    status.TextColor3 =
        Color3.fromRGB(80, 210, 255)

    counter.Text = "3 frutas de teste"

    list.CanvasSize = UDim2.new(
        0,
        0,
        0,
        layout.AbsoluteContentSize.Y + 15
    )
end)

--========================================================--
-- ARRASTAR GUI
--========================================================--

local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        dragging = true
        dragStart = input.Position
        startPosition = main.Position

    end
end)

UserInputService.InputEnded:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        dragging = false

    end
end)

UserInputService.InputChanged:Connect(function(input)

    if dragging and
        input.UserInputType ==
        Enum.UserInputType.MouseMovement then

        local delta =
            input.Position - dragStart

        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )

    end
end)

print("[FruitNotifier] GUI atualizado carregado")
