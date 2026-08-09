--========================================================--
--             FRUIT NOTIFIER - TEST BUILD               --
--       GUI + 9000 STUDS + DISTÂNCIA                    --
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

if not Player then
    warn("[FruitNotifier] LocalPlayer não encontrado.")
    return
end

local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================--
-- CONFIGURAÇÃO
--========================================================--

local MAX_DISTANCE = 9000
local UPDATE_TIME = 1

local Keywords = {
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
-- GUI
--========================================================--

local old = PlayerGui:FindFirstChild("FruitNotifier")

if old then
    old:Destroy()
end

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitNotifier"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.DisplayOrder = 999999
Gui.Parent = PlayerGui

--========================================================--
-- JANELA
--========================================================--

local Window = Instance.new("Frame")
Window.Size = UDim2.fromOffset(430, 430)
Window.Position = UDim2.new(0.5, -215, 0.5, -215)
Window.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Window.BorderSizePixel = 0
Window.Parent = Gui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = Window

--========================================================--
-- TÍTULO
--========================================================--

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 45)
Title.Position = UDim2.fromOffset(10, 5)
Title.BackgroundTransparency = 1
Title.Text = "🍎 FRUIT NOTIFIER"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Window

local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(1, -20, 0, 25)
Info.Position = UDim2.fromOffset(10, 45)
Info.BackgroundTransparency = 1
Info.Text = "Raio: 9.000 studs"
Info.TextColor3 = Color3.fromRGB(150, 150, 165)
Info.TextSize = 13
Info.Font = Enum.Font.Gotham
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.Parent = Window

--========================================================--
-- STATUS
--========================================================--

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 30)
Status.Position = UDim2.fromOffset(10, 72)
Status.BackgroundTransparency = 1
Status.Text = "● SISTEMA ATIVO"
Status.TextColor3 = Color3.fromRGB(80, 255, 120)
Status.TextSize = 13
Status.Font = Enum.Font.GothamBold
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Window

--========================================================--
-- BOTÃO TESTE
--========================================================--

local TestButton = Instance.new("TextButton")
TestButton.Size = UDim2.new(1, -20, 0, 40)
TestButton.Position = UDim2.fromOffset(10, 105)
TestButton.BackgroundColor3 = Color3.fromRGB(65, 95, 180)
TestButton.BorderSizePixel = 0
TestButton.Text = "🧪 TESTAR DISTÂNCIA"
TestButton.TextColor3 = Color3.new(1, 1, 1)
TestButton.TextSize = 14
TestButton.Font = Enum.Font.GothamBold
TestButton.Parent = Window

local TestCorner = Instance.new("UICorner")
TestCorner.CornerRadius = UDim.new(0, 8)
TestCorner.Parent = TestButton

--========================================================--
-- LISTA
--========================================================--

local List = Instance.new("ScrollingFrame")
List.Size = UDim2.new(1, -20, 0, 235)
List.Position = UDim2.fromOffset(10, 155)
List.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
List.BorderSizePixel = 0
List.ScrollBarThickness = 4
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Window

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 8)
ListCorner.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = List

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 7)
Padding.PaddingBottom = UDim.new(0, 7)
Padding.PaddingLeft = UDim.new(0, 7)
Padding.PaddingRight = UDim.new(0, 7)
Padding.Parent = List

--========================================================--
-- CONTADOR
--========================================================--

local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(1, -20, 0, 25)
Counter.Position = UDim2.fromOffset(10, 395)
Counter.BackgroundTransparency = 1
Counter.Text = "0 frutas encontradas"
Counter.TextColor3 = Color3.fromRGB(150, 150, 165)
Counter.TextSize = 12
Counter.Font = Enum.Font.Gotham
Counter.TextXAlignment = Enum.TextXAlignment.Left
Counter.Parent = Window

--========================================================--
-- POSIÇÃO
--========================================================--

local function GetPosition(Object)

    if Object:IsA("BasePart") then
        return Object.Position
    end

    if Object:IsA("Model") then

        if Object.PrimaryPart then
            return Object.PrimaryPart.Position
        end

        local Part = Object:FindFirstChildWhichIsA(
            "BasePart",
            true
        )

        if Part then
            return Part.Position
        end
    end

    return nil
end

--========================================================--
-- DETECTOR
--========================================================--

local function IsFruit(Object)

    local Name = string.lower(Object.Name)

    for _, Keyword in ipairs(Keywords) do

        if string.find(Name, Keyword, 1, true) then
            return true
        end

    end

    return false
end

--========================================================--
-- LIMPAR LISTA
--========================================================--

local function ClearList()

    for _, Object in ipairs(List:GetChildren()) do

        if Object:IsA("Frame") or
           Object:IsA("TextLabel") then

            Object:Destroy()

        end

    end
end

--========================================================--
-- ADICIONAR FRUTA
--========================================================--

local function AddFruit(Name, Distance)

    local Item = Instance.new("Frame")
    Item.Size = UDim2.new(1, 0, 0, 48)
    Item.BackgroundColor3 = Color3.fromRGB(28, 28, 37)
    Item.BorderSizePixel = 0
    Item.Parent = List

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 7)
    Corner.Parent = Item

    local FruitName = Instance.new("TextLabel")
    FruitName.Size = UDim2.new(0.62, 0, 1, 0)
    FruitName.Position = UDim2.fromOffset(10, 0)
    FruitName.BackgroundTransparency = 1
    FruitName.Text = "🍎 " .. Name
    FruitName.TextColor3 = Color3.new(1, 1, 1)
    FruitName.TextSize = 13
    FruitName.Font = Enum.Font.GothamBold
    FruitName.TextXAlignment = Enum.TextXAlignment.Left
    FruitName.Parent = Item

    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Size = UDim2.new(0.38, -10, 1, 0)
    DistanceLabel.Position = UDim2.new(0.62, 0, 0, 0)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Text = string.format("%.0f studs", Distance)
    DistanceLabel.TextColor3 = Color3.fromRGB(100, 210, 255)
    DistanceLabel.TextSize = 13
    DistanceLabel.Font = Enum.Font.GothamBold
    DistanceLabel.TextXAlignment = Enum.TextXAlignment.Right
    DistanceLabel.Parent = Item
end

--========================================================--
-- TESTE
--========================================================--

TestButton.MouseButton1Click:Connect(function()

    ClearList()

    AddFruit("Dragon Fruit [TESTE]", 1250)
    AddFruit("Leopard Fruit [TESTE]", 3870)
    AddFruit("Kitsune Fruit [TESTE]", 7420)

    Status.Text = "● TESTE EXECUTADO"
    Status.TextColor3 = Color3.fromRGB(80, 210, 255)

    Counter.Text = "3 frutas de teste"

    task.defer(function()
        List.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)
end)

--========================================================--
-- DETECÇÃO REAL
--========================================================--

local function Scan()

    local Character = Player.Character

    if not Character then
        return
    end

    local Root = Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Found = {}

    for _, Object in ipairs(workspace:GetDescendants()) do

        if IsFruit(Object) then

            local Position = GetPosition(Object)

            if Position then

                local Distance =
                    (Position - Root.Position).Magnitude

                if Distance <= MAX_DISTANCE then

                    table.insert(Found, {
                        Name = Object.Name,
                        Distance = Distance
                    })

                end
            end
        end
    end

    table.sort(Found, function(A, B)
        return A.Distance < B.Distance
    end)

    ClearList()

    for _, Fruit in ipairs(Found) do
        AddFruit(
            Fruit.Name,
            Fruit.Distance
        )
    end

    if #Found == 0 then

        Status.Text = "● NENHUMA FRUTA ENCONTRADA"
        Status.TextColor3 =
            Color3.fromRGB(255, 190, 80)

        Counter.Text = "0 frutas encontradas"

    else

        Status.Text =
            "● " .. #Found .. " FRUTA(S) ENCONTRADA(S)"

        Status.TextColor3 =
            Color3.fromRGB(80, 255, 120)

        Counter.Text =
            #Found .. " fruta(s) dentro de 9.000 studs"

    end

    task.defer(function()
        List.CanvasSize = UDim2.new(
            0,
            0,
            0,
            Layout.AbsoluteContentSize.Y + 15
        )
    end)
end

--========================================================--
-- LOOP
--========================================================--

task.spawn(function()

    while Gui.Parent do

        pcall(Scan)

        task.wait(UPDATE_TIME)

    end

end)

--========================================================--
-- ARRASTAR
--========================================================--

local Dragging = false
local DragStart
local StartPosition

Title.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Window.Position

    end
end)

UserInputService.InputEnded:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        Dragging = false

    end
end)

UserInputService.InputChanged:Connect(function(Input)

    if Dragging and
        Input.UserInputType ==
        Enum.UserInputType.MouseMovement then

        local Delta =
            Input.Position - DragStart

        Window.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )

    end
end)

print("[FruitNotifier] carregado")
