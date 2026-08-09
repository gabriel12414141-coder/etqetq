```lua
--========================================================--
--           FRUIT NOTIFIER - 9000 STUDS                --
--              GUI + DISTÂNCIA + LISTA                  --
--                  LocalScript                          --
--========================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--========================================================--
-- CONFIGURAÇÃO
--========================================================--

local SEARCH_DISTANCE = 9000
local UPDATE_INTERVAL = 0.5

-- Palavras usadas para identificar frutas
local FruitKeywords = {
    "fruit",
    "bomb",
    "spike",
    "chop",
    "spring",
    "kilo",
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
    "creation",
}

--========================================================--
-- REMOVER GUI ANTIGA
--========================================================--

local OldGui = PlayerGui:FindFirstChild("FruitNotifier9000")

if OldGui then
    OldGui:Destroy()
end

--========================================================--
-- SCREEN GUI
--========================================================--

local Gui = Instance.new("ScreenGui")
Gui.Name = "FruitNotifier9000"
Gui.ResetOnSpawn = false
Gui.IgnoreGuiInset = true
Gui.Parent = PlayerGui

--========================================================--
-- JANELA PRINCIPAL
--========================================================--

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.fromOffset(440, 470)
Main.Position = UDim2.new(0.5, -220, 0.5, -235)
Main.BackgroundColor3 = Color3.fromRGB(19, 19, 26)
Main.BorderSizePixel = 0
Main.Parent = Gui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(65, 65, 80)
MainStroke.Thickness = 1
MainStroke.Parent = Main

--========================================================--
-- HEADER
--========================================================--

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 75)
Header.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 38)
Title.Position = UDim2.fromOffset(15, 8)
Title.BackgroundTransparency = 1
Title.Text = "🍎  FRUIT NOTIFIER"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 23
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -30, 0, 22)
Subtitle.Position = UDim2.fromOffset(15, 45)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Raio de detecção: 9.000 studs"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 165)
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Header

--========================================================--
-- STATUS
--========================================================--

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -30, 0, 35)
Status.Position = UDim2.fromOffset(15, 85)
Status.BackgroundTransparency = 1
Status.Text = "● PROCURANDO FRUTAS..."
Status.TextColor3 = Color3.fromRGB(80, 255, 120)
Status.TextSize = 13
Status.Font = Enum.Font.GothamBold
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--========================================================--
-- LISTA
--========================================================--

local List = Instance.new("ScrollingFrame")
List.Name = "FruitList"
List.Size = UDim2.new(1, -30, 0, 300)
List.Position = UDim2.fromOffset(15, 120)
List.BackgroundColor3 = Color3.fromRGB(11, 11, 16)
List.BorderSizePixel = 0
List.ScrollBarThickness = 5
List.CanvasSize = UDim2.new(0, 0, 0, 0)
List.Parent = Main

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 10)
ListCorner.Parent = List

local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 8)
Padding.PaddingBottom = UDim.new(0, 8)
Padding.PaddingLeft = UDim.new(0, 8)
Padding.PaddingRight = UDim.new(0, 8)
Padding.Parent = List

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = List

--========================================================--
-- CONTADOR
--========================================================--

local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(1, -30, 0, 30)
Counter.Position = UDim2.fromOffset(15, 425)
Counter.BackgroundTransparency = 1
Counter.Text = "0 frutas encontradas"
Counter.TextColor3 = Color3.fromRGB(145, 145, 160)
Counter.TextSize = 12
Counter.Font = Enum.Font.Gotham
Counter.TextXAlignment = Enum.TextXAlignment.Left
Counter.Parent = Main

--========================================================--
-- FUNÇÃO DE POSIÇÃO
--========================================================--

local function GetObjectPosition(Object)

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
-- VERIFICAR SE É FRUTA
--========================================================--

local function IsFruit(Object)

    local Name = string.lower(Object.Name)

    for _, Keyword in ipairs(FruitKeywords) do

        if string.find(Name, Keyword, 1, true) then
            return true
        end

    end

    return false
end

--========================================================--
-- OBTER FRUTAS
--========================================================--

local function FindFruits(RootPosition)

    local Results = {}

    for _, Object in ipairs(workspace:GetDescendants()) do

        if IsFruit(Object) then

            local Position = GetObjectPosition(Object)

            if Position then

                local Distance =
                    (Position - RootPosition).Magnitude

                if Distance <= SEARCH_DISTANCE then

                    table.insert(Results, {
                        Object = Object,
                        Name = Object.Name,
                        Position = Position,
                        Distance = Distance
                    })

                end
            end
        end
    end

    table.sort(Results, function(A, B)
        return A.Distance < B.Distance
    end)

    return Results
end

--========================================================--
-- LIMPAR LISTA
--========================================================--

local function ClearList()

    for _, Child in ipairs(List:GetChildren()) do

        if Child:IsA("Frame") or Child:IsA("TextLabel") then
            Child:Destroy()
        end

    end
end

--========================================================--
-- ITEM DA FRUTA
--========================================================--

local function CreateFruitItem(Fruit)

    local Item = Instance.new("Frame")
    Item.Size = UDim2.new(1, 0, 0, 58)
    Item.BackgroundColor3 = Color3.fromRGB(27, 27, 36)
    Item.BorderSizePixel = 0
    Item.Parent = List

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Item

    local Name = Instance.new("TextLabel")
    Name.Size = UDim2.new(0.62, 0, 1, 0)
    Name.Position = UDim2.fromOffset(12, 0)
    Name.BackgroundTransparency = 1
    Name.Text = "🍎  " .. Fruit.Name
    Name.TextColor3 = Color3.fromRGB(235, 235, 240)
    Name.TextSize = 13
    Name.Font = Enum.Font.GothamBold
    Name.TextXAlignment = Enum.TextXAlignment.Left
    Name.Parent = Item

    local Distance = Instance.new("TextLabel")
    Distance.Size = UDim2.new(0.38, -12, 1, 0)
    Distance.Position = UDim2.new(0.62, 0, 0, 0)
    Distance.BackgroundTransparency = 1
    Distance.Text =
        string.format("%.0f studs", Fruit.Distance)
    Distance.TextColor3 = Color3.fromRGB(100, 210, 255)
    Distance.TextSize = 13
    Distance.Font = Enum.Font.GothamBold
    Distance.TextXAlignment = Enum.TextXAlignment.Right
    Distance.Parent = Item
end

--========================================================--
-- MENSAGEM VAZIA
--========================================================--

local function ShowEmpty()

    local Empty = Instance.new("TextLabel")

    Empty.Size = UDim2.new(1, -10, 0, 40)
    Empty.BackgroundTransparency = 1
    Empty.Text = "Nenhuma fruta encontrada em 9.000 studs."
    Empty.TextColor3 = Color3.fromRGB(130, 130, 145)
    Empty.TextSize = 13
    Empty.Font = Enum.Font.Gotham
    Empty.Parent = List
end

--========================================================--
-- ATUALIZAR
--========================================================--

local TimeSinceUpdate = 0

RunService.Heartbeat:Connect(function(DeltaTime)

    TimeSinceUpdate += DeltaTime

    if TimeSinceUpdate < UPDATE_INTERVAL then
        return
    end

    TimeSinceUpdate = 0

    local Character = Player.Character

    if not Character then
        return
    end

    local Root =
        Character:FindFirstChild("HumanoidRootPart")

    if not Root then
        return
    end

    local Fruits = FindFruits(Root.Position)

    ClearList()

    if #Fruits == 0 then

        Status.Text = "● NENHUMA FRUTA ENCONTRADA"
        Status.TextColor3 =
            Color3.fromRGB(255, 190, 80)

        Counter.Text = "0 frutas encontradas"

        ShowEmpty()

    else

        Status.Text =
            "● " .. #Fruits .. " FRUTA(S) ENCONTRADA(S)"

        Status.TextColor3 =
            Color3.fromRGB(80, 255, 120)

        Counter.Text =
            #Fruits .. " fruta(s) dentro de 9.000 studs"

        for _, Fruit in ipairs(Fruits) do
            CreateFruitItem(Fruit)
        end
    end

    List.CanvasSize = UDim2.new(
        0,
        0,
        0,
        Layout.AbsoluteContentSize.Y + 20
    )
end)

--========================================================--
-- ARRASTAR GUI
--========================================================--

local Dragging = false
local DragStart
local StartPosition

Header.InputBegan:Connect(function(Input)

    if Input.UserInputType ==
        Enum.UserInputType.MouseButton1 then

        Dragging = true
        DragStart = Input.Position
        StartPosition = Main.Position

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

        Main.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end
end)

print("[FruitNotifier] Sistema iniciado - raio 9000 studs")
```
