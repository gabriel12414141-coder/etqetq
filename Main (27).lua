```lua
--==============================================================
--                 FRUIT NOTIFIER v2
--==============================================================
-- LocalScript
--
-- LISTA FECHADA:
-- Rocket, Spin, Blade, Spring, Bomb, Smoke, Spike, Flame,
-- Ice, Sand, Dark, Eagle, Diamond, Light, Rubber, Ghost,
-- Magma, Quake, Buddha, Love, Creation, Spider, Sound,
-- Phoenix, Portal, Lightning, Pain, Blizzard, Gravity,
-- Mammoth, T-Rex, Dough, Shadow, Venom, Gas, Spirit,
-- Tiger, Yeti, Kitsune, Control, Dragon
--
-- PRINCIPAIS RECURSOS:
-- • 40 frutas válidas
-- • Detecção exata
-- • Aceita "Nome" e "Nome Fruit"
-- • Não usa string.find("fruit")
-- • Anti-falso-positivo
-- • Detecção de frutas já existentes
-- • Detecção de frutas novas
-- • Histórico
-- • Pesquisa
-- • Filtros
-- • Favoritos
-- • Distância
-- • Notificação
-- • Som
-- • GUI arrastável
-- • Minimizar
-- • Fechar
-- • Ativar/desativar detector
--==============================================================


--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")


--==============================================================
-- REMOVER VERSÃO ANTERIOR
--==============================================================

local Existing = PlayerGui:FindFirstChild("FruitNotifier")

if Existing then
    Existing:Destroy()
end


--==============================================================
-- CONFIGURAÇÃO
--==============================================================

local Config = {

    Enabled = true,

    Notifications = true,

    Sounds = true,

    ShowDistance = true,

    MaxDistance = math.huge,

    ScanInterval = 1,

    NotificationTime = 5,

}


--==============================================================
-- BANCO DE FRUTAS
--==============================================================

local Fruits = {

    ["Rocket"] = {
        Name = "Rocket Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Spin"] = {
        Name = "Spin Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Blade"] = {
        Name = "Blade Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Spring"] = {
        Name = "Spring Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Bomb"] = {
        Name = "Bomb Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Smoke"] = {
        Name = "Smoke Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Spike"] = {
        Name = "Spike Fruit",
        Rarity = "Common",
        Priority = 1,
    },

    ["Flame"] = {
        Name = "Flame Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Ice"] = {
        Name = "Ice Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Sand"] = {
        Name = "Sand Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Dark"] = {
        Name = "Dark Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Eagle"] = {
        Name = "Eagle Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Diamond"] = {
        Name = "Diamond Fruit",
        Rarity = "Uncommon",
        Priority = 2,
    },

    ["Light"] = {
        Name = "Light Fruit",
        Rarity = "Rare",
        Priority = 3,
    },

    ["Rubber"] = {
        Name = "Rubber Fruit",
        Rarity = "Rare",
        Priority = 3,
    },

    ["Ghost"] = {
        Name = "Ghost Fruit",
        Rarity = "Rare",
        Priority = 3,
    },

    ["Magma"] = {
        Name = "Magma Fruit",
        Rarity = "Rare",
        Priority = 3,
    },

    ["Quake"] = {
        Name = "Quake Fruit",
        Rarity = "Rare",
        Priority = 3,
    },

    ["Buddha"] = {
        Name = "Buddha Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Love"] = {
        Name = "Love Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Creation"] = {
        Name = "Creation Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Spider"] = {
        Name = "Spider Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Sound"] = {
        Name = "Sound Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Phoenix"] = {
        Name = "Phoenix Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Portal"] = {
        Name = "Portal Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Lightning"] = {
        Name = "Lightning Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Pain"] = {
        Name = "Pain Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Blizzard"] = {
        Name = "Blizzard Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Gravity"] = {
        Name = "Gravity Fruit",
        Rarity = "Legendary",
        Priority = 4,
    },

    ["Mammoth"] = {
        Name = "Mammoth Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["T-Rex"] = {
        Name = "T-Rex Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Dough"] = {
        Name = "Dough Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Shadow"] = {
        Name = "Shadow Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Venom"] = {
        Name = "Venom Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Gas"] = {
        Name = "Gas Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Spirit"] = {
        Name = "Spirit Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Tiger"] = {
        Name = "Tiger Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Yeti"] = {
        Name = "Yeti Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Kitsune"] = {
        Name = "Kitsune Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Control"] = {
        Name = "Control Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

    ["Dragon"] = {
        Name = "Dragon Fruit",
        Rarity = "Mythical",
        Priority = 5,
    },

}


--==============================================================
-- CONJUNTO DE NOMES PERMITIDOS
--==============================================================

local ValidNames = {}

for Key, Data in pairs(Fruits) do

    -- Nome curto
    ValidNames[Key] = Key

    -- Nome completo
    ValidNames[Data.Name] = Key

end


--==============================================================
-- DETECTADOS
--==============================================================

local Detected = {}

local History = {}

local Favorites = {

    ["Dragon"] = true,
    ["Tiger"] = true,
    ["Kitsune"] = true,
    ["Yeti"] = true,
    ["Gas"] = true,
    ["Control"] = true,
    ["Dough"] = true,

}


--==============================================================
-- ESTADO DO GUI
--==============================================================

local CurrentFilter = "Todas"
local Search = ""
local Minimized = false


--==============================================================
-- NORMALIZAR NOME
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
-- CASE-INSENSITIVE EXATO
--==============================================================

local function FindValidFruit(Name)

    Name = Normalize(Name)

    if Name == "" then
        return nil
    end

    -- PRIMEIRA TENTATIVA:
    -- correspondência direta
    if ValidNames[Name] then
        return ValidNames[Name]
    end

    -- SEGUNDA TENTATIVA:
    -- mesma string ignorando maiúsculas/minúsculas
    local LowerName = string.lower(Name)

    for ValidName, FruitKey in pairs(ValidNames) do

        if string.lower(ValidName) == LowerName then
            return FruitKey
        end

    end

    return nil

end


--==============================================================
-- POSIÇÃO DO OBJETO
--==============================================================

local function GetPosition(Object)

    if not Object then
        return nil
    end

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
-- POSIÇÃO DO JOGADOR
--==============================================================

local function GetPlayerPosition()

    local Character =
        Player.Character

    if not Character then
        return nil
    end

    local Root =
        Character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not Root then
        return nil
    end

    return Root.Position

end


--==============================================================
-- DISTÂNCIA
--==============================================================

local function GetDistance(Object)

    local PlayerPosition =
        GetPlayerPosition()

    local ObjectPosition =
        GetPosition(Object)

    if not PlayerPosition
        or not ObjectPosition then

        return math.huge

    end

    return (
        PlayerPosition -
        ObjectPosition
    ).Magnitude

end


--==============================================================
-- FORMATAR DISTÂNCIA
--==============================================================

local function FormatDistance(Distance)

    if Distance == math.huge then
        return "???"
    end

    return math.floor(Distance) .. " studs"

end


--==============================================================
-- VALIDAR OBJETO
--==============================================================
-- IMPORTANTE:
-- NÃO usamos:
--
-- string.find(Object.Name, "fruit")
--
-- Isso causaria muitos falsos positivos.
--==============================================================

local function ValidateObject(Object)

    if not Object then
        return nil
    end

    local FruitKey =
        FindValidFruit(Object.Name)

    if not FruitKey then
        return nil
    end

    local Position =
        GetPosition(Object)

    if not Position then
        return nil
    end

    return FruitKey

end


--==============================================================
-- GUI
--==============================================================

local ScreenGui =
    Instance.new("ScreenGui")

ScreenGui.Name =
    "FruitNotifier"

ScreenGui.ResetOnSpawn =
    false

ScreenGui.IgnoreGuiInset =
    true

ScreenGui.Parent =
    PlayerGui


--==============================================================
-- MAIN
--==============================================================

local Main =
    Instance.new("Frame")

Main.Name =
    "Main"

Main.Size =
    UDim2.new(0,500,0,530)

Main.Position =
    UDim2.new(
        0.5,
        -250,
        0.5,
        -265
    )

Main.BackgroundColor3 =
    Color3.fromRGB(18,18,23)

Main.BorderSizePixel =
    0

Main.Parent =
    ScreenGui


local MainCorner =
    Instance.new("UICorner")

MainCorner.CornerRadius =
    UDim.new(0,12)

MainCorner.Parent =
    Main


--==============================================================
-- TOP BAR
--==============================================================

local Top =
    Instance.new("Frame")

Top.Size =
    UDim2.new(1,0,0,48)

Top.BackgroundColor3 =
    Color3.fromRGB(27,27,34)

Top.BorderSizePixel =
    0

Top.Parent =
    Main


local Title =
    Instance.new("TextLabel")

Title.Size =
    UDim2.new(1,-100,1,0)

Title.Position =
    UDim2.new(0,15,0,0)

Title.BackgroundTransparency =
    1

Title.Text =
    "🍎  FRUIT NOTIFIER"

Title.TextColor3 =
    Color3.fromRGB(255,255,255)

Title.TextSize =
    18

Title.Font =
    Enum.Font.GothamBold

Title.TextXAlignment =
    Enum.TextXAlignment.Left

Title.Parent =
    Top


--==============================================================
-- MINIMIZAR
--==============================================================

local Minimize =
    Instance.new("TextButton")

Minimize.Size =
    UDim2.new(0,36,0,32)

Minimize.Position =
    UDim2.new(1,-82,0,8)

Minimize.BackgroundColor3 =
    Color3.fromRGB(50,50,60)

Minimize.Text =
    "—"

Minimize.TextColor3 =
    Color3.fromRGB(255,255,255)

Minimize.TextSize =
    18

Minimize.Font =
    Enum.Font.GothamBold

Minimize.Parent =
    Top


--==============================================================
-- FECHAR
--==============================================================

local Close =
    Instance.new("TextButton")

Close.Size =
    UDim2.new(0,36,0,32)

Close.Position =
    UDim2.new(1,-42,0,8)

Close.BackgroundColor3 =
    Color3.fromRGB(130,45,45)

Close.Text =
    "X"

Close.TextColor3 =
    Color3.fromRGB(255,255,255)

Close.TextSize =
    14

Close.Font =
    Enum.Font.GothamBold

Close.Parent =
    Top


--==============================================================
-- STATUS
--==============================================================

local Status =
    Instance.new("TextButton")

Status.Size =
    UDim2.new(1,-20,0,35)

Status.Position =
    UDim2.new(0,10,0,58)

Status.BackgroundColor3 =
    Color3.fromRGB(30,60,40)

Status.Text =
    "● DETECTOR ATIVO"

Status.TextColor3 =
    Color3.fromRGB(90,230,130)

Status.TextSize =
    13

Status.Font =
    Enum.Font.GothamBold

Status.Parent =
    Main


--==============================================================
-- PESQUISA
--==============================================================

local SearchBox =
    Instance.new("TextBox")

SearchBox.Size =
    UDim2.new(1,-20,0,38)

SearchBox.Position =
    UDim2.new(0,10,0,103)

SearchBox.BackgroundColor3 =
    Color3.fromRGB(30,30,38)

SearchBox.BorderSizePixel =
    0

SearchBox.PlaceholderText =
    "🔎  Pesquisar fruta..."

SearchBox.PlaceholderColor3 =
    Color3.fromRGB(130,130,140)

SearchBox.Text =
    ""

SearchBox.TextColor3 =
    Color3.fromRGB(255,255,255)

SearchBox.TextSize =
    14

SearchBox.Font =
    Enum.Font.Gotham

SearchBox.ClearTextOnFocus =
    false

SearchBox.Parent =
    Main


local SearchCorner =
    Instance.new("UICorner")

SearchCorner.CornerRadius =
    UDim.new(0,8)

SearchCorner.Parent =
    SearchBox


--==============================================================
-- FILTROS
--==============================================================

local FilterBar =
    Instance.new("Frame")

FilterBar.Size =
    UDim2.new(1,-20,0,35)

FilterBar.Position =
    UDim2.new(0,10,0,150)

FilterBar.BackgroundTransparency =
    1

FilterBar.Parent =
    Main


local FilterNames = {

    "Todas",
    "Rare",
    "Legendary",
    "Mythical",
    "Favoritas",

}


local FilterButtons = {}


for Index, FilterName in ipairs(FilterNames) do

    local Button =
        Instance.new("TextButton")

    Button.Size =
        UDim2.new(0,90,1,0)

    Button.Position =
        UDim2.new(
            0,
            (Index-1)*96,
            0,
            0
        )

    Button.BackgroundColor3 =
        Color3.fromRGB(35,35,45)

    Button.Text =
        FilterName

    Button.TextColor3 =
        Color3.fromRGB(230,230,235)

    Button.TextSize =
        11

    Button.Font =
        Enum.Font.GothamBold

    Button.Parent =
        FilterBar

    FilterButtons[FilterName] =
        Button


    Button.MouseButton1Click:Connect(
        function()

            CurrentFilter =
                FilterName

            for Name, Btn in pairs(
                FilterButtons
            ) do

                if Name ==
                    CurrentFilter then

                    Btn.BackgroundColor3 =
                        Color3.fromRGB(
                            65,
                            100,
                            175
                        )

                else

                    Btn.BackgroundColor3 =
                        Color3.fromRGB(
                            35,
                            35,
                            45
                        )

                end

            end

            RefreshList()

        end
    )

end


FilterButtons["Todas"].BackgroundColor3 =
    Color3.fromRGB(65,100,175)


--==============================================================
-- LISTA
--==============================================================

local List =
    Instance.new("ScrollingFrame")

List.Size =
    UDim2.new(1,-20,0,285)

List.Position =
    UDim2.new(0,10,0,195)

List.BackgroundColor3 =
    Color3.fromRGB(23,23,30)

List.BorderSizePixel =
    0

List.ScrollBarThickness =
    5

List.CanvasSize =
    UDim2.new(0,0,0,0)

List.Parent =
    Main


local ListCorner =
    Instance.new("UICorner")

ListCorner.CornerRadius =
    UDim.new(0,8)

ListCorner.Parent =
    List


local ListLayout =
    Instance.new("UIListLayout")

ListLayout.Padding =
    UDim.new(0,6)

ListLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

ListLayout.Parent =
    List


--==============================================================
-- CONTADOR
--==============================================================

local Counter =
    Instance.new("TextLabel")

Counter.Size =
    UDim2.new(1,-20,0,30)

Counter.Position =
    UDim2.new(0,10,1,-35)

Counter.BackgroundTransparency =
    1

Counter.Text =
    "0 frutas detectadas"

Counter.TextColor3 =
    Color3.fromRGB(150,150,160)

Counter.TextSize =
    12

Counter.Font =
    Enum.Font.Gotham

Counter.TextXAlignment =
    Enum.TextXAlignment.Left

Counter.Parent =
    Main


--==============================================================
-- NOTIFICAÇÕES
--==============================================================

local NotificationContainer =
    Instance.new("Frame")

NotificationContainer.Size =
    UDim2.new(0,360,1,-20)

NotificationContainer.Position =
    UDim2.new(1,-370,0,10)

NotificationContainer.BackgroundTransparency =
    1

NotificationContainer.Parent =
    ScreenGui


local NotificationLayout =
    Instance.new("UIListLayout")

NotificationLayout.Padding =
    UDim.new(0,8)

NotificationLayout.SortOrder =
    Enum.SortOrder.LayoutOrder

NotificationLayout.Parent =
    NotificationContainer


--==============================================================
-- SOM
--==============================================================

local function PlaySound()

    if not Config.Sounds then
        return
    end

    local Sound =
        Instance.new("Sound")

    Sound.SoundId =
        "rbxassetid://6026984224"

    Sound.Volume =
        1

    Sound.Parent =
        SoundService

    Sound:Play()

    Sound.Ended:Connect(
        function()

            Sound:Destroy()

        end
    )

end


--==============================================================
-- NOTIFICAÇÃO
--==============================================================

local function Notify(
    FruitKey,
    Object
)

    if not Config.Notifications then
        return
    end

    local Data =
        Fruits[FruitKey]

    if not Data then
        return
    end

    local Distance =
        GetDistance(Object)


    local Frame =
        Instance.new("Frame")

    Frame.Size =
        UDim2.new(1,0,0,100)

    Frame.BackgroundColor3 =
        Color3.fromRGB(28,28,36)

    Frame.BorderSizePixel =
        0

    Frame.BackgroundTransparency =
        1

    Frame.Parent =
        NotificationContainer


    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,10)

    Corner.Parent =
        Frame


    local Text =
        Instance.new("TextLabel")

    Text.Size =
        UDim2.new(1,-20,1,-10)

    Text.Position =
        UDim2.new(0,10,0,5)

    Text.BackgroundTransparency =
        1

    Text.TextColor3 =
        Color3.fromRGB(255,255,255)

    Text.TextSize =
        14

    Text.Font =
        Enum.Font.GothamBold

    Text.TextXAlignment =
        Enum.TextXAlignment.Left

    Text.TextYAlignment =
        Enum.TextYAlignment.Center

    Text.TextWrapped =
        true

    Text.Text =
        "🍎  FRUTA DETECTADA\n\n" ..
        Data.Name ..
        "\n⭐ " ..
        Data.Rarity ..
        "\n📏 " ..
        FormatDistance(Distance)

    Text.Parent =
        Frame


    TweenService:Create(
        Frame,
        TweenInfo.new(0.25),
        {
            BackgroundTransparency = 0
        }
    ):Play()


    task.delay(
        Config.NotificationTime,
        function()

            if not Frame.Parent then
                return
            end

            local Tween =
                TweenService:Create(
                    Frame,
                    TweenInfo.new(0.25),
                    {
                        BackgroundTransparency = 1
                    }
                )

            Tween:Play()

            Tween.Completed:Wait()

            if Frame then
                Frame:Destroy()
            end

        end
    )


    PlaySound()

end


--==============================================================
-- HISTÓRICO
--==============================================================

local function AddHistory(
    FruitKey,
    Object
)

    local Data =
        Fruits[FruitKey]

    if not Data then
        return
    end

    table.insert(
        History,
        1,
        {
            Fruit = FruitKey,
            Object = Object,
            Time = os.date("%H:%M:%S"),
        }
    )


    if #History > 100 then
        table.remove(
            History,
            #History
        )
    end

end


--==============================================================
-- CRIAR ITEM
--==============================================================

local function CreateEntry(
    FruitKey,
    Object
)

    local Data =
        Fruits[FruitKey]

    if not Data then
        return
    end


    local Entry =
        Instance.new("Frame")

    Entry.Size =
        UDim2.new(1,-10,0,68)

    Entry.BackgroundColor3 =
        Color3.fromRGB(31,31,40)

    Entry.BorderSizePixel =
        0

    Entry.Parent =
        List


    local Corner =
        Instance.new("UICorner")

    Corner.CornerRadius =
        UDim.new(0,8)

    Corner.Parent =
        Entry


    local Name =
        Instance.new("TextLabel")

    Name.Size =
        UDim2.new(1,-120,0,25)

    Name.Position =
        UDim2.new(0,10,0,5)

    Name.BackgroundTransparency =
        1

    Name.Text =
        "🍎  " .. Data.Name

    Name.TextColor3 =
        Color3.fromRGB(255,255,255)

    Name.TextSize =
        14

    Name.Font =
        Enum.Font.GothamBold

    Name.TextXAlignment =
        Enum.TextXAlignment.Left

    Name.Parent =
        Entry


    local Rarity =
        Instance.new("TextLabel")

    Rarity.Size =
        UDim2.new(1,-120,0,20)

    Rarity.Position =
        UDim2.new(0,10,0,34)

    Rarity.BackgroundTransparency =
        1

    Rarity.Text =
        "⭐ " ..
        Data.Rarity

    Rarity.TextColor3 =
        Color3.fromRGB(160,160,170)

    Rarity.TextSize =
        11

    Rarity.Font =
        Enum.Font.Gotham

    Rarity.TextXAlignment =
        Enum.TextXAlignment.Left

    Rarity.Parent =
        Entry


    local Distance =
        Instance.new("TextLabel")

    Distance.Size =
        UDim2.new(0,105,1,0)

    Distance.Position =
        UDim2.new(1,-110,0,0)

    Distance.BackgroundTransparency =
        1

    Distance.TextColor3 =
        Color3.fromRGB(90,220,140)

    Distance.TextSize =
        11

    Distance.Font =
        Enum.Font.GothamBold

    Distance.Text =
        FormatDistance(
            GetDistance(Object)
        )

    Distance.Parent =
        Entry


    task.spawn(
        function()

            while Entry.Parent do

                if not Object.Parent then
                    break
                end

                Distance.Text =
                    FormatDistance(
                        GetDistance(Object)
                    )

                task.wait(0.25)

            end

        end
    )

end


--==============================================================
-- REFRESH LIST
--==============================================================

function RefreshList()

    for _, Child in ipairs(
        List:GetChildren()
    ) do

        if Child:IsA("Frame") then
            Child:Destroy()
        end

    end


    local Items = {}


    for Object, FruitKey in pairs(
        Detected
    ) do

        if Object.Parent then

            local Data =
                Fruits[FruitKey]

            if Data then

                local PassSearch =
                    true

                local PassFilter =
                    true


                if Search ~= "" then

                    PassSearch =
                        string.find(
                            string.lower(
                                Data.Name
                            ),
                            string.lower(
                                Search
                            ),
                            1,
                            true
                        ) ~= nil

                end


                if CurrentFilter ==
                    "Favoritas" then

                    PassFilter =
                        Favorites[FruitKey] == true

                elseif CurrentFilter ~=
                    "Todas" then

                    PassFilter =
                        Data.Rarity ==
                        CurrentFilter

                end


                if PassSearch
                    and PassFilter then

                    table.insert(
                        Items,
                        {
                            Object = Object,
                            Fruit = FruitKey,
                            Priority = Data.Priority,
                        }
                    )

                end

            end

        end

    end


    table.sort(
        Items,
        function(A,B)

            return A.Priority >
                B.Priority

        end
    )


    for _, Item in ipairs(Items) do

        CreateEntry(
            Item.Fruit,
            Item.Object
        )

    end


    List.CanvasSize =
        UDim2.new(
            0,
            0,
            0,
            #Items * 74
        )


    Counter.Text =
        tostring(
            #Items
        ) ..
        " fruta(s) detectada(s)"

end


--==============================================================
-- REGISTRAR
--==============================================================

local function RegisterFruit(
    Object,
    FruitKey
)

    if not Config.Enabled then
        return
    end

    if Detected[Object] then
        return
    end


    local Distance =
        GetDistance(Object)

    if Distance >
        Config.MaxDistance then

        return

    end


    Detected[Object] =
        FruitKey


    AddHistory(
        FruitKey,
        Object
    )


    Notify(
        FruitKey,
        Object
    )


    RefreshList()

end


--==============================================================
-- ANALISAR OBJETO
--==============================================================

local function CheckObject(Object)

    if not Config.Enabled then
        return
    end

    local FruitKey =
        ValidateObject(Object)

    if not FruitKey then
        return
    end

    RegisterFruit(
        Object,
        FruitKey
    )

end


--==============================================================
-- SCAN
--==============================================================

local function ScanWorkspace()

    if not Config.Enabled then
        return
    end


    for _, Object in ipairs(
        workspace:GetDescendants()
    ) do

        CheckObject(Object)

    end

end


--==============================================================
-- NOVOS OBJETOS
--==============================================================

workspace.DescendantAdded:Connect(
    function(Object)

        task.defer(
            function()

                CheckObject(Object)

            end
        )

    end
)


--==============================================================
-- OBJETOS REMOVIDOS
--==============================================================

workspace.DescendantRemoving:Connect(
    function(Object)

        if Detected[Object] then

            Detected[Object] =
                nil

            RefreshList()

        end

    end
)


--==============================================================
-- PESQUISA
--==============================================================

SearchBox:GetPropertyChangedSignal(
    "Text"
):Connect(
    function()

        Search =
            SearchBox.Text

        RefreshList()

    end
)


--==============================================================
-- ATIVAR / DESATIVAR
--==============================================================

Status.MouseButton1Click:Connect(
    function()

        Config.Enabled =
            not Config.Enabled


        if Config.Enabled then

            Status.Text =
                "● DETECTOR ATIVO"

            Status.BackgroundColor3 =
                Color3.fromRGB(
                    30,
                    60,
                    40
                )

            Status.TextColor3 =
                Color3.fromRGB(
                    90,
                    230,
                    130
                )

            ScanWorkspace()

        else

            Status.Text =
                "● DETECTOR DESATIVADO"

            Status.BackgroundColor3 =
                Color3.fromRGB(
                    65,
                    35,
                    35
                )

            Status.TextColor3 =
                Color3.fromRGB(
                    240,
                    100,
                    100
                )

        end

    end
)


--==============================================================
-- MINIMIZAR
--==============================================================

Minimize.MouseButton1Click:Connect(
    function()

        Minimized =
            not Minimized


        if Minimized then

            Main.Size =
                UDim2.new(
                    0,
                    500,
                    0,
                    48
                )

            Minimize.Text =
                "+"

            for _, Child in ipairs(
                Main:GetChildren()
            ) do

                if Child ~= Top then
                    Child.Visible = false
                end

            end

        else

            Main.Size =
                UDim2.new(
                    0,
                    500,
                    0,
                    530
                )

            Minimize.Text =
                "—"

            for _, Child in ipairs(
                Main:GetChildren()
            ) do

                if Child ~= Top then
                    Child.Visible = true
                end

            end

        end

    end
)


--==============================================================
-- FECHAR
--==============================================================

Close.MouseButton1Click:Connect(
    function()

        ScreenGui:Destroy()

    end
)


--==============================================================
-- DRAG
--==============================================================

local Dragging = false
local DragStart
local StartPosition


Top.InputBegan:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            Dragging = true

            DragStart =
                Input.Position

            StartPosition =
                Main.Position

        end

    end
)


Top.InputEnded:Connect(
    function(Input)

        if Input.UserInputType ==
            Enum.UserInputType.MouseButton1 then

            Dragging = false

        end

    end
)


UserInputService.InputChanged:Connect(
    function(Input)

        if not Dragging then
            return
        end

        if Input.UserInputType ~=
            Enum.UserInputType.MouseMovement then

            return

        end


        local Delta =
            Input.Position -
            DragStart


        Main.Position =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset +
                    Delta.X,

                StartPosition.Y.Scale,
                StartPosition.Y.Offset +
                    Delta.Y
            )

    end
)


--==============================================================
-- LIMPEZA
--==============================================================

task.spawn(
    function()

        while ScreenGui.Parent do

            task.wait(
                Config.ScanInterval
            )


            for Object in pairs(
                Detected
            ) do

                if not Object.Parent then

                    Detected[Object] =
                        nil

                end

            end


            RefreshList()

        end

    end
)


--==============================================================
-- PRIMEIRO SCAN
--==============================================================

task.spawn(
    function()

        task.wait(1)

        ScanWorkspace()

        print(
            "[FruitNotifier] iniciado."
        )

        print(
            "[FruitNotifier] Frutas válidas: 40"
        )

    end
)
```
