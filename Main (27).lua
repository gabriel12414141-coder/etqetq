-- ============================================
-- LocalScript: colocar em StarterPlayerScripts
-- ESP de Frutas para mapas GRANDES (estilo mundo aberto com ilhas)
--
-- Recursos:
--  - Menu arrastável com lista de frutas (ordenada por distância)
--  - Toggle ON/OFF (botão ou tecla F)
--  - Billboard + Highlight 3D só quando a fruta está perto (evita clutter)
--  - Setas de radar 2D na borda da tela apontando pra frutas longe
--  - Detecção do nome da ilha onde a fruta está
--  - Atualizações pesadas throttled (não roda tudo todo frame)
-- ============================================

local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local jogadorLocal = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================
-- CONFIGURAÇÕES
-- ============================================

local TAG_FRUTA = "fruit"          -- tag usada nos objetos de fruta
local TAG_ILHA = "Ilha"            -- tag opcional usada nos models das ilhas
local DISTANCIA_VISUAL_3D = 150    -- só mostra billboard/highlight dentro desse raio
local DISTANCIA_MAXIMA_RADAR = 100000 -- radar funciona no mapa inteiro
local MAX_ITENS_MENU = 25          -- limite de itens mostrados na lista/radar (evita clutter e lag)
local INTERVALO_ATUALIZACAO = 0.3  -- segundos entre recálculos pesados (distância, ordenação)
local COR_ESP = Color3.fromRGB(255, 200, 0)
local TECLA_TOGGLE = Enum.KeyCode.F
local MARGEM_TELA = 40             -- margem da seta em relação à borda da tela

local espAtivo = false
local espAtivos = {} -- [fruta] = { billboard, highlight, texto, itemFrame, arrowLabel, ilha }
local acumuladorTempo = 0

-- ============================================
-- FUNÇÃO: descobrir em qual ilha a fruta está
-- ============================================

local function acharIlha(fruta)
    -- 1) Atributo manual (mais confiável, defina no Studio: fruta:SetAttribute("Ilha", "Ilha do Fogo"))
    local atributo = fruta:GetAttribute("Ilha")
    if atributo then
        return atributo
    end

    -- 2) Sobe na hierarquia procurando um ancestral com a tag "Ilha"
    local atual = fruta.Parent
    while atual and atual ~= workspace do
        if CollectionService:HasTag(atual, TAG_ILHA) then
            return atual.Name
        end
        atual = atual.Parent
    end

    return "Desconhecida"
end

-- ============================================
-- INTERFACE: MENU PRINCIPAL (arrastável)
-- ============================================

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuESPFrutas"
screenGui.ResetOnSpawn = false
screenGui.Parent = jogadorLocal:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Name = "Frame"
frame.Size = UDim2.new(0, 240, 0, 320)
frame.Position = UDim2.new(0, 20, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local titulo = Instance.new("TextLabel")
titulo.Name = "Titulo"
titulo.Size = UDim2.new(1, 0, 0, 36)
titulo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titulo.Text = "🍎 ESP de Frutas"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.Font = Enum.Font.GothamBold
titulo.TextSize = 16
titulo.Active = true
titulo.Parent = frame

local tituloCorner = Instance.new("UICorner")
tituloCorner.CornerRadius = UDim.new(0, 8)
tituloCorner.Parent = titulo

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
listLayout.SortOrder = Enum.SortOrder.LayoutOrder -- usaremos LayoutOrder = distância p/ ordenar
listLayout.Padding = UDim.new(0, 4)
listLayout.Parent = scrollFrame

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingLeft = UDim.new(0, 4)
listPadding.PaddingRight = UDim.new(0, 4)
listPadding.Parent = scrollFrame

-- ============================================
-- INTERFACE: CAMADA DE RADAR (setas na tela)
-- ============================================

local radarGui = Instance.new("ScreenGui")
radarGui.Name = "RadarFrutas"
radarGui.ResetOnSpawn = false
radarGui.DisplayOrder = 5
radarGui.Parent = jogadorLocal:WaitForChild("PlayerGui")

-- ============================================
-- ARRASTAR O MENU (versão robusta com AbsolutePosition)
-- ============================================

frame.Active = true
titulo.Active = true

local arrastando = false
local deslocamento = Vector2.new(0, 0)

local function iniciarArrasto(input)
    arrastando = true
    deslocamento = Vector2.new(
        frame.AbsolutePosition.X - input.Position.X,
        frame.AbsolutePosition.Y - input.Position.Y
    )
end

local function pararArrasto()
    arrastando = false
end

titulo.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        iniciarArrasto(input)
    end
end)

-- Conexões globais (fora do titulo) evitam duplicar listeners a cada clique
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
       or input.UserInputType == Enum.UserInputType.Touch then
        pararArrasto()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if arrastando and (input.UserInputType == Enum.UserInputType.MouseMovement
                        or input.UserInputType == Enum.UserInputType.Touch) then
        local novaPosX = input.Position.X + deslocamento.X
        local novaPosY = input.Position.Y + deslocamento.Y
        frame.Position = UDim2.new(0, novaPosX, 0, novaPosY)
    end
end)

-- ============================================
-- CRIAÇÃO / REMOÇÃO DE ENTRADAS DE FRUTA
-- ============================================

local function atualizarContador()
    local total = 0
    for _ in pairs(espAtivos) do total += 1 end
    contador.Text = "Frutas no mapa: " .. total
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
end

local function criarEntradaFruta(fruta)
    if espAtivos[fruta] then return end

    -- Billboard 3D (só aparece quando perto)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP_Fruta"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = fruta
    billboard.Enabled = false
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
    highlight.Enabled = false
    highlight.Parent = fruta

    -- Item na lista do menu
    local itemFrame = Instance.new("TextLabel")
    itemFrame.Size = UDim2.new(1, 0, 0, 32)
    itemFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    itemFrame.Text = "  🍊 " .. fruta.Name
    itemFrame.TextColor3 = Color3.new(1, 1, 1)
    itemFrame.Font = Enum.Font.Gotham
    itemFrame.TextSize = 12
    itemFrame.TextXAlignment = Enum.TextXAlignment.Left
    itemFrame.TextYAlignment = Enum.TextYAlignment.Center
    itemFrame.LayoutOrder = 0
    itemFrame.Parent = scrollFrame

    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 4)
    itemCorner.Parent = itemFrame

    -- Seta de radar (2D, borda da tela)
    local arrowLabel = Instance.new("TextLabel")
    arrowLabel.Name = "Seta_" .. fruta.Name
    arrowLabel.Size = UDim2.new(0, 50, 0, 26)
    arrowLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    arrowLabel.BackgroundTransparency = 1
    arrowLabel.Text = "▲"
    arrowLabel.TextColor3 = COR_ESP
    arrowLabel.TextStrokeTransparency = 0
    arrowLabel.Font = Enum.Font.GothamBold
    arrowLabel.TextSize = 22
    arrowLabel.Visible = false
    arrowLabel.Parent = radarGui

    local arrowDistText = Instance.new("TextLabel")
    arrowDistText.Size = UDim2.new(1, 0, 0, 14)
    arrowDistText.Position = UDim2.new(0, 0, 1, 0)
    arrowDistText.BackgroundTransparency = 1
    arrowDistText.Text = ""
    arrowDistText.TextColor3 = Color3.new(1, 1, 1)
    arrowDistText.TextStrokeTransparency = 0.3
    arrowDistText.Font = Enum.Font.Gotham
    arrowDistText.TextSize = 11
    arrowDistText.Parent = arrowLabel

    espAtivos[fruta] = {
        billboard = billboard,
        highlight = highlight,
        texto = texto,
        itemFrame = itemFrame,
        arrowLabel = arrowLabel,
        arrowDistText = arrowDistText,
        ilha = acharIlha(fruta),
    }

    atualizarContador()
end

local function removerEntradaFruta(fruta)
    local dados = espAtivos[fruta]
    if dados then
        dados.billboard:Destroy()
        dados.highlight:Destroy()
        dados.itemFrame:Destroy()
        dados.arrowLabel:Destroy()
        espAtivos[fruta] = nil
        atualizarContador()
    end
end

-- ============================================
-- ATUALIZAÇÃO PESADA (throttled): distância, ordenação, ilha
-- ============================================

local function atualizarListaEDistancias()
    local personagem = jogadorLocal.Character
    if not personagem then return end
    local hrp = personagem:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- Monta array pra ordenar por distância
    local ordenados = {}
    for fruta, dados in pairs(espAtivos) do
        if fruta and fruta.Parent then
            local distancia = (fruta:GetPivot().Position - hrp.Position).Magnitude
            table.insert(ordenados, {fruta = fruta, dados = dados, distancia = distancia})
        else
            removerEntradaFruta(fruta)
        end
    end

    table.sort(ordenados, function(a, b) return a.distancia < b.distancia end)

    for indice, entrada in ipairs(ordenados) do
        local fruta, dados, distancia = entrada.fruta, entrada.dados, entrada.distancia
        local distanciaTexto = math.floor(distancia)

        -- Atualiza texto da lista (LayoutOrder = distância -> ordena automaticamente)
        dados.itemFrame.LayoutOrder = distanciaTexto
        dados.itemFrame.Text = string.format("  🍊 %s\n     %s - %dm", fruta.Name, dados.ilha, distanciaTexto)

        -- Só mostra na lista/radar os N mais próximos (evita clutter em mapa gigante)
        local dentroDoLimite = indice <= MAX_ITENS_MENU
        dados.itemFrame.Visible = dentroDoLimite

        -- Billboard/Highlight 3D só quando MUITO perto
        local perto = distancia <= DISTANCIA_VISUAL_3D
        dados.billboard.Enabled = espAtivo and perto
        dados.highlight.Enabled = espAtivo and perto
        if perto then
            dados.texto.Text = fruta.Name .. " [" .. distanciaTexto .. "m]"
        end

        -- Radar só pros N mais próximos e se ESP ligado
        dados.arrowLabel.Visible = espAtivo and dentroDoLimite
        dados.arrowDistText.Text = distanciaTexto .. "m"
    end
end

-- ============================================
-- ATUALIZAÇÃO LEVE (todo frame): posição das setas de radar
-- ============================================

local function atualizarRadar()
    if not espAtivo then return end

    local viewportSize = camera.ViewportSize
    local centro = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    local raioX = viewportSize.X / 2 - MARGEM_TELA
    local raioY = viewportSize.Y / 2 - MARGEM_TELA

    for fruta, dados in pairs(espAtivos) do
        if dados.arrowLabel.Visible then
            local posMundo = fruta:GetPivot().Position
            local screenPos, dentroDaTela = camera:WorldToViewportPoint(posMundo)

            if dentroDaTela and screenPos.Z > 0 then
                -- Fruta visível na tela: mostra marcador direto na posição dela, sem seta
                local x = math.clamp(screenPos.X, MARGEM_TELA, viewportSize.X - MARGEM_TELA)
                local y = math.clamp(screenPos.Y, MARGEM_TELA, viewportSize.Y - MARGEM_TELA)
                dados.arrowLabel.Position = UDim2.new(0, x, 0, y)
                dados.arrowLabel.Rotation = 0
            else
                -- Fruta fora da tela: calcula ângulo e posiciona a seta na borda
                local posRelativa = camera.CFrame:PointToObjectSpace(posMundo)

                -- Se estiver atrás da câmera, inverte X pra seta não apontar pro lado errado
                if posRelativa.Z > 0 then
                    posRelativa = Vector3.new(-posRelativa.X, posRelativa.Y, -posRelativa.Z)
                end

                local angulo = math.atan2(posRelativa.X, -posRelativa.Z)
                local x = centro.X + math.sin(angulo) * raioX
                local y = centro.Y - math.cos(angulo) * raioY

                dados.arrowLabel.Position = UDim2.new(0, x, 0, y)
                dados.arrowLabel.Rotation = math.deg(angulo)
            end
        end
    end
end

-- ============================================
-- TOGGLE ON/OFF
-- ============================================

local function definirEstadoESP(ligado)
    espAtivo = ligado

    if ligado then
        botaoToggle.Text = "ESP: LIGADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(40, 160, 60)
    else
        botaoToggle.Text = "ESP: DESLIGADO"
        botaoToggle.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        -- Desliga tudo imediatamente
        for _, dados in pairs(espAtivos) do
            dados.billboard.Enabled = false
            dados.highlight.Enabled = false
            dados.arrowLabel.Visible = false
        end
    end
end

botaoToggle.MouseButton1Click:Connect(function()
    definirEstadoESP(not espAtivo)
end)

UserInputService.InputBegan:Connect(function(input, processado)
    if processado then return end
    if input.KeyCode == TECLA_TOGGLE then
        definirEstadoESP(not espAtivo)
    end
end)

-- ============================================
-- INICIALIZAÇÃO
-- ============================================

CollectionService:GetInstanceAddedSignal(TAG_FRUTA):Connect(criarEntradaFruta)
CollectionService:GetInstanceRemovedSignal(TAG_FRUTA):Connect(removerEntradaFruta)

for _, fruta in ipairs(CollectionService:GetTagged(TAG_FRUTA)) do
    criarEntradaFruta(fruta)
end

-- Loop pesado (throttled): roda a cada INTERVALO_ATUALIZACAO segundos
RunService.Heartbeat:Connect(function(dt)
    acumuladorTempo += dt
    if acumuladorTempo >= INTERVALO_ATUALIZACAO then
        acumuladorTempo = 0
        atualizarListaEDistancias()
    end
end)

-- Loop leve (todo frame): move as setas de radar suavemente
RunService.RenderStepped:Connect(atualizarRadar)
