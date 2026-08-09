-- ============================================
-- LocalScript: colocar em StarterPlayerScripts
-- Menu de ESP com lista de frutas + toggle ON/OFF
-- ============================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local jogadorLocal = Players.LocalPlayer

-- Configurações
local DISTANCIA_MAXIMA = 500
local COR_ESP = Color3.fromRGB(255, 200, 0)
local TECLA_TOGGLE = Enum.KeyCode.F -- tecla de atalho pra ligar/desligar

local espAtivo = false
local espAtivos = {}

-- ============================================
-- INTERFACE (ScreenGui)
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuESPFrutas"
screenGui.ResetOnSpawn = false
screenGui.Parent = jogadorLocal:WaitForChild("PlayerGui")

-- Frame principal do menu
local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 36)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titulo.Text = "🍎 ESP de Frutas"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.Parent = frame

local tituloCorner = Instance.new("UICorner")
tituloCorner.CornerRadius = UDim.new(0, 8)
tituloCorner.Parent = titulo

-- Botão de Toggle ON/OFF
local botaoToggle = Instance.new("TextButton")
botaoToggle.Size = UDim2.new(1, -20, 0, 36)
botaoToggle.Position = UDim2.new(0, 10, 0, 44)
botaoToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
botaoToggle.Text = "ESP: DESLIGADO"
botaoToggle.TextColor3 = Color3.new(1, 1, 1)
botaoToggle.Font = Enum.Font.GothamBold
botaoToggle.TextSize = 14
botaoToggle.Parent = frame

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = botaoToggle

-- Label contador de frutas
local contador = Instance.new("TextLabel")
contador.Size = UDim2.new(1, -20, 0, 20)
contador.Position = UDim2.new(0, 10, 0, 86)
contador.BackgroundTransparency = 1
contador.Text = "Frutas no mapa: 0"
contador.TextColor3 = Color3.fromRGB(200, 200, 200)
contador.Font = Enum.Font.Gotham
contador.TextSize = 13
contador.TextXAlignment = Enum.TextXAlignment.Left
contador.Parent = frame

-- ScrollingFrame com a lista de frutas
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -120)
scrollFrame.Position = UDim2.new(0, 10, 0, 112)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = frame

local scrollCorner = Instance.new("UICorner")
scrollCorner.CornerRadius = UDim.new(0, 6)
scrollCorner.Parent = scrollFrame

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingLeft = UDim.new(0, 4)
listPadding.PaddingRight = UDim.new(0, 4)
listPadding.Parent = scrollFrame

-- ============================================
-- LÓGICA DO ESP
-- ============================================

local function criarESP(fruta)
    if espAtivos[fruta] then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Fruta"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = fruta
    billboard.Enabled = espAtivo
    billboard.Parent = fruta

    local texto = Instance.new("TextLabel")
    texto.Size = UDim2.new(1, 0, 1, 0)
    texto.BackgroundTransparency = 1
    texto.TextColor3 = COR_ESP
    texto.TextStrokeTransparency = 0
    texto.Font = Enum.Font.GothamBold
    texto.TextSize = 16
    texto.Text = fruta.Name
    texto.Parent = billboard

    local highlight = Instance.new("Highlight")
    highlight.FillColor = COR_ESP
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = COR_ESP
    highlight.Enabled = espAtivo
    highlight.Parent = fruta

    -- Item na lista do menu
    local itemFrame = Instance.new("TextLabel")
    itemFrame.Size = UDim2.new(1, 0, 0, 24)
    itemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    itemFrame.Text = "  🍊 " .. fruta.Name
    itemFrame.TextColor3 = Color3.new(1, 1, 1)
    itemFrame.Font = Enum.Font.Gotham
    itemFrame.TextSize = 12
    itemFrame.TextXAlignment = Enum.TextXAlignment.Left
    itemFrame.Parent = scrollFrame

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 4)
    itemCorner.Parent = itemFrame

    espAtivos[fruta] = {
        billboard = billboard,
        highlight = highlight,
        texto = texto,
        itemFrame = itemFrame
    }

    atualizarContador()
end

function atualizarContador()
    local total = 0
    for _ in pairs(espAtivos) do total += 1 end
    contador.Text = "Frutas no mapa: " .. total
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

local function removerESP(fruta)
    local dados = espAtivos[fruta]
    if dados then
        dados.billboard:Destroy()
        dados.highlight:Destroy()
        dados.itemFrame:Destroy()
        espAtivos[fruta] = nil
        atualizarContador()
    end
end

local function atualizarDistancias()
    local personagem = jogadorLocal.Character
    if not personagem then return end
    local hrp = personagem:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for fruta, dados in pairs(espAtivos) do
        if fruta and fruta.Parent then
            local distancia = (fruta:GetPivot().Position - hrp.Position).Magnitude
            dados.texto.Text = fruta.Name .. " [" .. math.floor(distancia) .. "m]"
            dados.itemFrame.Text = "  🍊 " .. fruta.Name .. " - " .. math.floor(distancia) .. "m"
        else
            removerESP(fruta)
        end
    end
end

-- ============================================
-- TOGGLE ON/OFF
-- ============================================

local function definirEstadoESP(ligado)
    espAtivo = ligado
    for _, dados in pairs(espAtivos) do
        dados.billboard.Enabled = ligado
        dados.highlight.Enabled = ligado
    end

    if ligado then
        botaoToggle.Text = "ESP: LIGADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
    else
        botaoToggle.Text = "ESP: DESLIGADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end

botaoToggle.MouseButton1Click:Connect(function()
    definirEstadoESP(not espAtivo)
end)

-- Atalho de teclado (opcional)
UserInputService.InputBegan:Connect(function(input, processado)
    if processado then return end
    if input.KeyCode == TECLA_TOGGLE then
        definirEstadoESP(not espAtivo)
    end
end)

-- ============================================
-- INICIALIZAÇÃO
-- ============================================

CollectionService:GetInstanceAddedSignal("Fruta"):Connect(criarESP)
CollectionService:GetInstanceRemovedSignal("Fruta"):Connect(removerESP)

for _, fruta in ipairs(CollectionService:GetTagged("Fruta")) do
    criarESP(fruta)
end

RunService.Heartbeat:Connect(atualizarDistancias)
