```lua
--==============================================================
--             FRUIT NOTIFIER - GUI FIRST
--==============================================================

--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer

if not Player then
    warn("[FruitNotifier] LocalPlayer não encontrado.")
    return
end

local PlayerGui = Player:WaitForChild("PlayerGui")


--==============================================================
-- REMOVER VERSÃO ANTERIOR
--==============================================================

local OldGui = PlayerGui:FindFirstChild("FruitNotifier")

if OldGui then
    OldGui:Destroy()
end


--==============================================================
-- BANCO DE FRUTAS
--==============================================================

local ValidFruits = {

    ["Rocket"] = true,
    ["Spin"] = true,
    ["Blade"] = true,
    ["Spring"] = true,
    ["Bomb"] = true,
    ["Smoke"] = true,
    ["Spike"] = true,
    ["Flame"] = true,
    ["Ice"] = true,
    ["Sand"] = true,
    ["Dark"] = true,
    ["Eagle"] = true,
    ["Diamond"] = true,
    ["Light"] = true,
    ["Rubber"] = true,
    ["Ghost"] = true,
    ["Magma"] = true,
    ["Quake"] = true,
    ["Buddha"] = true,
    ["Love"] = true,
    ["Creation"] = true,
    ["Spider"] = true,
    ["Sound"] = true,
    ["Phoenix"] = true,
    ["Portal"] = true,
    ["Lightning"] = true,
    ["Pain"] = true,
    ["Blizzard"] = true,
    ["Gravity"] = true,
    ["Mammoth"] = true,
    ["T-Rex"] = true,
    ["Dough"] = true,
    ["Shadow"] = true,
    ["Venom"] = true,
    ["Gas"] = true,
    ["Spirit"] = true,
    ["Tiger"] = true,
    ["Yeti"] = true,
    ["Kitsune"] = true,
    ["Control"] = true,
    ["Dragon"] = true,

}


--==============================================================
-- GUI
--==============================================================

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "FruitNotifier"

ScreenGui.ResetOnSpawn = false

ScreenGui.IgnoreGuiInset = true

ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ScreenGui.DisplayOrder = 999999

ScreenGui.Parent = PlayerGui


--==============================================================
-- MAIN
--==============================================================

local Main = Instance.new("Frame")

Main.Name = "Main"

Main.Size = UDim2.new(0, 500, 0, 450)

Main.Position = UDim2.new(0.5, -250, 0.5, -225)

Main.AnchorPoint = Vector2.new(0, 0)

Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)

Main.BorderSizePixel = 0

Main.Visible = true

Main.Active = true

Main.Parent = ScreenGui


--==============================================================
-- CORNER
--==============================================================

local MainCorner = Instance.new("UICorner")

MainCorner.CornerRadius = UDim.new(0, 12)

MainCorner.Parent = Main


--==============================================================
-- TOPBAR
--==============================================================

local TopBar = Instance.new("Frame")

TopBar.Name = "TopBar"

TopBar.Size = UDim2.new(1, 0, 0, 50)

TopBar.Position = UDim2.new(0, 0, 0, 0)

TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)

TopBar.BorderSizePixel = 0

TopBar.Parent = Main


local TopCorner = Instance.new("UICorner")

TopCorner.CornerRadius = UDim.new(0, 12)

TopCorner.Parent = TopBar


--==============================================================
-- TITULO
--==============================================================

local Title = Instance.new("TextLabel")

Title.Name = "Title"

Title.Size = UDim2.new(1, -110, 1, 0)

Title.Position = UDim2.new(0, 15, 0, 0)

Title.BackgroundTransparency = 1

Title.Text = "🍎  FRUIT NOTIFIER"

Title.TextColor3 = Color3.fromRGB(255, 255, 255)

Title.TextSize = 18

Title.Font = Enum.Font.GothamBold

Title.TextXAlignment = Enum.TextXAlignment.Left

Title.Parent = TopBar


--==============================================================
-- MINIMIZAR
--==============================================================

local MinimizeButton = Instance.new("TextButton")

MinimizeButton.Name = "Minimize"

MinimizeButton.Size = UDim2.new(0, 38, 0, 32)

MinimizeButton.Position = UDim2.new(1, -85, 0, 9)

MinimizeButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)

MinimizeButton.BorderSizePixel = 0

MinimizeButton.Text = "—"

MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

MinimizeButton.TextSize = 18

MinimizeButton.Font = Enum.Font.GothamBold

MinimizeButton.Parent = TopBar


--==============================================================
-- FECHAR
--==============================================================

local CloseButton = Instance.new("TextButton")

CloseButton.Name = "Close"

CloseButton.Size = UDim2.new(0, 38, 0, 32)

CloseButton.Position = UDim2.new(1, -43, 0, 9)

CloseButton.BackgroundColor3 = Color3.fromRGB(130, 45, 45)

CloseButton.BorderSizePixel = 0

CloseButton.Text = "X"

CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)

CloseButton.TextSize = 14

CloseButton.Font = Enum.Font.GothamBold

CloseButton.Parent = TopBar


--==============================================================
-- STATUS
--==============================================================

local Status = Instance.new("TextLabel")

Status.Name = "Status"

Status.Size = UDim2.new(1, -20, 0, 38)

Status.Position = UDim2.new(0, 10, 0, 62)

Status.BackgroundColor3 = Color3.fromRGB(30, 65, 42)

Status.BorderSizePixel = 0

Status.Text = "●  DETECTOR ATIVO"

Status.TextColor3 = Color3.fromRGB(90, 230, 130)

Status.TextSize = 14

Status.Font = Enum.Font.GothamBold

Status.Parent = Main


local StatusCorner = Instance.new("UICorner")

StatusCorner.CornerRadius = UDim.new(0, 8)

StatusCorner.Parent = Status


--==============================================================
-- PESQUISA
--==============================================================

local SearchBox = Instance.new("TextBox")

SearchBox.Name = "Search"

SearchBox.Size = UDim2.new(1, -20, 0, 40)

SearchBox.Position = UDim2.new(0, 10, 0, 112)

SearchBox.BackgroundColor3 = Color3.fromRGB(32, 32, 40)

SearchBox.BorderSizePixel = 0

SearchBox.PlaceholderText = "🔎  Pesquisar fruta..."

SearchBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 150)

SearchBox.Text = ""

SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)

SearchBox.TextSize = 14

SearchBox.Font = Enum.Font.Gotham

SearchBox.ClearTextOnFocus = false

SearchBox.Parent = Main


local SearchCorner = Instance.new("UICorner")

SearchCorner.CornerRadius = UDim.new(0, 8)

SearchCorner.Parent = SearchBox


--==============================================================
-- LISTA
--==============================================================

local List = Instance.new("ScrollingFrame")

List.Name = "FruitList"

List.Size = UDim2.new(1, -20, 0, 250)

List.Position = UDim2.new(0, 10, 0, 165)

List.BackgroundColor3 = Color3.fromRGB(25, 25, 32)

List.BorderSizePixel = 0

List.ScrollBarThickness = 5

List.CanvasSize = UDim2.new(0, 0, 0, 0)

List.Parent = Main


local ListCorner = Instance.new("UICorner")

ListCorner.CornerRadius = UDim.new(0, 8)

ListCorner.Parent = List


local Layout = Instance.new("UIListLayout")

Layout.Padding = UDim.new(0, 5)

Layout.SortOrder = Enum.SortOrder.LayoutOrder

Layout.Parent = List


--==============================================================
-- CONTADOR
--==============================================================

local Counter = Instance.new("TextLabel")

Counter.Name = "Counter"

Counter.Size = UDim2.new(1, -20, 0, 25)

Counter.Position = UDim2.new(0, 10, 1, -30)

Counter.BackgroundTransparency = 1

Counter.Text = "40 frutas cadastradas • 0 encontradas"

Counter.TextColor3 = Color3.fromRGB(150, 150, 160)

Counter.TextSize = 12

Counter.Font = Enum.Font.Gotham

Counter.TextXAlignment = Enum.TextXAlignment.Left

Counter.Parent = Main


--==============================================================
-- DRAG
--==============================================================

local Dragging = false
local DragStart = nil
local StartPosition = nil


TopBar.InputBegan:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = true

        DragStart = Input.Position

        StartPosition = Main.Position

    end

end)


TopBar.InputEnded:Connect(function(Input)

    if Input.UserInputType == Enum.UserInputType.MouseButton1
        or Input.UserInputType == Enum.UserInputType.Touch then

        Dragging = false

    end

end)


UserInputService.InputChanged:Connect(function(Input)

    if not Dragging then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.MouseMovement
        and Input.UserInputType ~= Enum.UserInputType.Touch then

        return

    end


    local Delta = Input.Position - DragStart


    Main.Position = UDim2.new(
        StartPosition.X.Scale,
        StartPosition.X.Offset + Delta.X,
        StartPosition.Y.Scale,
        StartPosition.Y.Offset + Delta.Y
    )

end)


--==============================================================
-- MINIMIZAR
--==============================================================

local Minimized = false


MinimizeButton.MouseButton1Click:Connect(function()

    Minimized = not Minimized


    if Minimized then

        Main.Size = UDim2.new(0, 500, 0, 50)

        MinimizeButton.Text = "+"

        Status.Visible = false
        SearchBox.Visible = false
        List.Visible = false
        Counter.Visible = false

    else

        Main.Size = UDim2.new(0, 500, 0, 450)

        MinimizeButton.Text = "—"

        Status.Visible = true
        SearchBox.Visible = true
        List.Visible = true
        Counter.Visible = true

    end

end)


--==============================================================
-- FECHAR
--==============================================================

CloseButton.MouseButton1Click:Connect(function()

    ScreenGui:Destroy()

end)


--==============================================================
-- TESTE VISUAL
--==============================================================
-- Se chegou aqui, o GUI foi criado corretamente.

print("[FruitNotifier] GUI criado com sucesso.")
print("[FruitNotifier] 40 frutas carregadas.")


--==============================================================
-- DETECTOR
--==============================================================

local Detected = {}


--==============================================================
-- NORMALIZAÇÃO
--==============================================================

local function Normalize(Name)

    if typeof(Name) ~= "string" then
        return ""
    end

    Name = Name:gsub("%s+", " ")

    Name = Name:gsub("^%s+", "")

    Name = Name:gsub("%s+$", "")

    return Name

end


--==============================================================
-- ENCONTRAR FRUTA
--==============================================================

local function GetFruit(Name)

    Name = Normalize(Name)

    if Name == "" then
        return nil
    end


    -- Nome exato
    if ValidFruits[Name] then
        return Name
    end


    -- "Dragon Fruit", "Tiger Fruit", etc.
    if string.sub(Name, -6) == " Fruit" then

        local ShortName =
            string.sub(Name, 1, #Name - 6)

        if ValidFruits[ShortName] then
            return ShortName
        end

    end


    -- Case insensitive
    local Lower = string.lower(Name)


    for FruitName in pairs(ValidFruits) do

        if string.lower(FruitName) == Lower then
            return FruitName
        end

        local FullName =
            string.lower(FruitName .. " Fruit")

        if Lower == FullName then
            return FruitName
        end

    end


    return nil

end


--==============================================================
-- POSIÇÃO
--==============================================================

local function GetPosition(Object)

    if Object:IsA("BasePart") then
        return Object.Position
    end


    if Object:IsA("Model") then

        if Object.PrimaryPart then
            return Object.PrimaryPart.Position
        end


        local Part =
            Object:FindFirstChildWhichIsA(
                "BasePart",
                true
            )

        if Part then
            return Part.Position
        end

    end


    return nil

end


--==============================================================
-- DISTÂNCIA
--==============================================================

local function GetDistance(Object)

    local Character =
        Player.Character

    if not Character then
        return math.huge
    end


    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        return math.huge
    end


    local Position =
        GetPosition(Object)

    if not Position then
        return math.huge
    end


    return (
        Root.Position - Position
    ).Magnitude

end


--==============================================================
-- NOTIFICAÇÃO SIMPLES
--==============================================================

local function Notify(FruitName, Object)

    local Notification =
        Instance.new("TextLabel")

    Notification.Size =
        UDim2.new(0, 330, 0, 65)

    Notification.Position =
        UDim2.new(
            1,
            -350,
            0,
            20
        )

    Notification.BackgroundColor3 =
        Color3.fromRGB(30, 30, 38)

    Notification.BorderSizePixel = 0

    Notification.Text =
        "🍎 FRUTA ENCONTRADA!\n" ..
        FruitName ..
        " Fruit\n" ..
        math.floor(
            GetDistance(Object)
        ) ..
        " studs"

    Notification.TextColor3 =
        Color3.fromRGB(255, 255, 255)

    Notification.TextSize = 14

    Notification.Font =
        Enum.Font.GothamBold

    Notification.Parent =
        ScreenGui


    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0, 10)

    Corner.Parent =
        Notification


    task.delay(5, function()

        if Notification.Parent then
            Notification:Destroy()
        end

    end)

end


--==============================================================
-- REGISTRAR
--==============================================================

local function Register(Object, FruitName)

    if Detected[Object] then
        return
    end


    Detected[Object] = FruitName


    Notify(
        FruitName,
        Object
    )


    local Count = 0

    for _ in pairs(Detected) do
        Count += 1
    end


    Counter.Text =
        "40 frutas cadastradas • " ..
        Count ..
        " encontradas"

end


--==============================================================
-- VERIFICAR
--==============================================================

local function Check(Object)

    if not Object then
        return
    end


    local FruitName =
        GetFruit(Object.Name)


    if not FruitName then
        return
    end


    if not GetPosition(Object) then
        return
    end


    Register(
        Object,
        FruitName
    )

end


--==============================================================
-- SCAN INICIAL
--==============================================================

task.spawn(function()

    task.wait(1)


    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        Check(Object)

    end


    print(
        "[FruitNotifier] Scan inicial concluído."
    )

end)


--==============================================================
-- NOVOS OBJETOS
--==============================================================

workspace.DescendantAdded:Connect(function(Object)

    task.defer(function()

        Check(Object)

    end)

end)


--==============================================================
-- REMOÇÃO
--==============================================================

workspace.DescendantRemoving:Connect(function(Object)

    if Detected[Object] then

        Detected[Object] = nil

    end

end)


--==============================================================
-- PESQUISA VISUAL
--==============================================================

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()

    local Text =
        string.lower(
            SearchBox.Text
        )


    for _, Child in ipairs(
        List:GetChildren()
    ) do

        if Child:IsA("TextLabel") then

            local Name =
                string.lower(
                    Child.Text
                )

            Child.Visible =
                Text == ""
                or string.find(
                    Name,
                    Text,
                    1,
                    true
                ) ~= nil

        end

    end

end)


--==============================================================
-- FINAL
--==============================================================

print("========================================")
print(" FRUIT NOTIFIER")
print(" GUI: OK")
print(" FRUTAS VÁLIDAS: 40")
print(" DETECTOR: ATIVO")
print("========================================")
```
