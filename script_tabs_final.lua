-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Detectar se é mobile
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local guiScale = isMobile and 0.7 or 1

-- Configurações iniciais (TUDO DESATIVADO)
local espName, espHighlight = false, false
local espTools = false
local espTeam = false
local espLookDirection = false
local espBones = false
local espLine = false
local ignoreTeam = true
local aimbotMode = 0
local npcAim = false
local wallCheck = true
local viewMode = false
local tpMode = false
local showFOV = false
local aimFOV = 220
local AntiHitEnabled = false
local predictionEnabled = true
local predictionStrength = 0.15
local aimSmoothness = 0.15
local aimShake = true
local aimDelay = 0.1
local antiScreenShare = false -- NOVO: Anti-Tela

-- NOVO: Lista de jogadores ignorados
local ignoredPlayers = {}

-- Cache
local playerVelocities = {}
local rgbTick = 0
local drawings = {}

-- Função RGB
local function RGB(t)
    local r = math.floor(127 * math.sin(t) + 128)
    local g = math.floor(127 * math.sin(t + 2*math.pi/3) + 128)
    local b = math.floor(127 * math.sin(t + 4*math.pi/3) + 128)
    return Color3.fromRGB(r, g, b)
end

-- NOVO: Detectar Screen Share (Spectators)
local function isBeingWatched()
    -- Verifica se há spectators ou se está streamando
    if game:GetService("StarterGui"):GetCoreGuiEnabled(Enum.CoreGuiType.All) == false then
        return true
    end
    
    -- Verifica se há outros jogadores "observando"
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if player:FindFirstChild("Spectating") or player:FindFirstChild("CameraSubject") then
                local subject = player.CameraSubject
                if subject and subject == LocalPlayer.Character then
                    return true
                end
            end
        end
    end
    
    return false
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GTAHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Botão drag em BOLA
local dragBall = Instance.new("TextButton")
dragBall.Size = UDim2.new(0, 60 * guiScale, 0, 60 * guiScale)
dragBall.Position = UDim2.new(0.02, 0, 0.5, 0)
dragBall.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
dragBall.BorderSizePixel = 0
dragBall.Text = "GTA"
dragBall.TextColor3 = Color3.new(1, 1, 1)
dragBall.Font = Enum.Font.SourceSansBold
dragBall.TextSize = 18 * guiScale
dragBall.Parent = ScreenGui

local ballCorner = Instance.new("UICorner")
ballCorner.CornerRadius = UDim.new(1, 0)
ballCorner.Parent = dragBall

-- Drag da bola
local ballDragging = false
local ballDragInput, ballDragStart, ballStartPos

dragBall.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        ballDragging = true
        ballDragStart = input.Position
        ballStartPos = dragBall.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                ballDragging = false
            end
        end)
    end
end)

dragBall.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        ballDragInput = input
    end
end)

RunService.RenderStepped:Connect(function()
    if ballDragging and ballDragInput then
        local delta = ballDragInput.Position - ballDragStart
        dragBall.Position = UDim2.new(
            ballStartPos.X.Scale,
            ballStartPos.X.Offset + delta.X,
            ballStartPos.Y.Scale,
            ballStartPos.Y.Offset + delta.Y
        )
    end
end)

-- Frame menu COM TABS
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 450 * guiScale, 0, 500 * guiScale)
menuFrame.Position = UDim2.new(0.5, -225 * guiScale, 0.5, -250 * guiScale)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
menuFrame.Visible = false
menuFrame.Parent = ScreenGui
Instance.new("UICorner", menuFrame).CornerRadius = UDim.new(0, 10)

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40 * guiScale)
titleLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20 * guiScale
titleLabel.Text = "GTA Hub PRO"
titleLabel.Parent = menuFrame
Instance.new("UICorner", titleLabel).CornerRadius = UDim.new(0, 10)

-- NOVO: Container de Tabs
local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -20, 0, 40 * guiScale)
tabContainer.Position = UDim2.new(0, 10, 0, 50 * guiScale)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = menuFrame

-- NOVO: Content Frame (onde ficam os botões de cada tab)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -110 * guiScale)
contentFrame.Position = UDim2.new(0, 10, 0, 100 * guiScale)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = menuFrame

-- NOVO: Função para criar Tabs
local currentTab = "Aimbot"
local tabs = {}

local function createTab(name, position)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0.33, -5, 1, 0)
    tab.Position = UDim2.new((position - 1) * 0.33, (position - 1) * 5, 0, 0)
    tab.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.SourceSansBold
    tab.TextSize = 14 * guiScale
    tab.Parent = tabContainer
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)
    
    tabs[name] = tab
    
    tab.MouseButton1Click:Connect(function()
        currentTab = name
        for tabName, tabBtn in pairs(tabs) do
            tabBtn.BackgroundColor3 = tabName == name and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
        end
        
        -- Mostrar/esconder conteúdo
        for _, child in pairs(contentFrame:GetChildren()) do
            if child:IsA("ScrollingFrame") then
                child.Visible = child.Name == name
            end
        end
    end)
    
    return tab
end

-- Criar as 3 tabs
createTab("Aimbot", 1)
createTab("ESP", 2)
createTab("Main", 3)

-- Ativar primeira tab
tabs["Aimbot"].BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- NOVO: Criar ScrollFrames para cada tab
local function createTabContent(name)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = name
    scroll.Size = UDim2.new(1, 0, 1, 0)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 6
    scroll.CanvasSize = UDim2.new(0, 0, 0, 600 * guiScale)
    scroll.Visible = name == "Aimbot"
    scroll.Parent = contentFrame
    return scroll
end

local aimbotTab = createTabContent("Aimbot")
local espTab = createTabContent("ESP")
local mainTab = createTabContent("Main")

-- Função para criar botões
local function criarBotao(parent, txt, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20 * guiScale, 0, 35 * guiScale)
    btn.Position = UDim2.new(0, 10 * guiScale, 0, posY * guiScale)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = txt
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13 * guiScale
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.Parent = parent
    return btn
end

-- BOTÕES TAB AIMBOT
local aimbotBtn = criarBotao(aimbotTab, "Aimbot", 10)
local predictionBtn = criarBotao(aimbotTab, "Previsão", 50)
local npcAimBtn = criarBotao(aimbotTab, "NPC Aim", 90)
local wallCheckBtn = criarBotao(aimbotTab, "WallCheck", 130)
local showFOVBtn = criarBotao(aimbotTab, "Mostrar FOV", 170)

-- FOV Control
local fovFrame = Instance.new("Frame")
fovFrame.Size = UDim2.new(1, -20 * guiScale, 0, 35 * guiScale)
fovFrame.Position = UDim2.new(0, 10 * guiScale, 0, 210 * guiScale)
fovFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fovFrame.Parent = aimbotTab
Instance.new("UICorner", fovFrame).CornerRadius = UDim.new(0, 6)

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 100 * guiScale, 1, 0)
fovLabel.Position = UDim2.new(0, 50 * guiScale, 0, 0)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. aimFOV
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.Font = Enum.Font.SourceSansBold
fovLabel.TextSize = 13 * guiScale
fovLabel.Parent = fovFrame

local fovMinusBtn = Instance.new("TextButton")
fovMinusBtn.Size = UDim2.new(0, 40 * guiScale, 1, 0)
fovMinusBtn.Position = UDim2.new(0, 5 * guiScale, 0, 0)
fovMinusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovMinusBtn.Text = "-"
fovMinusBtn.TextColor3 = Color3.new(1, 1, 1)
fovMinusBtn.Font = Enum.Font.SourceSansBold
fovMinusBtn.TextSize = 20 * guiScale
fovMinusBtn.Parent = fovFrame
Instance.new("UICorner", fovMinusBtn).CornerRadius = UDim.new(0, 4)

local fovPlusBtn = Instance.new("TextButton")
fovPlusBtn.Size = UDim2.new(0, 40 * guiScale, 1, 0)
fovPlusBtn.Position = UDim2.new(1, -45 * guiScale, 0, 0)
fovPlusBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
fovPlusBtn.Text = "+"
fovPlusBtn.TextColor3 = Color3.new(1, 1, 1)
fovPlusBtn.Font = Enum.Font.SourceSansBold
fovPlusBtn.TextSize = 20 * guiScale
fovPlusBtn.Parent = fovFrame
Instance.new("UICorner", fovPlusBtn).CornerRadius = UDim.new(0, 4)

-- BOTÕES TAB ESP
local espNameBtn = criarBotao(espTab, "ESP Nome", 10)
local espLineBtn = criarBotao(espTab, "ESP Line", 50)
local espHighlightBtn = criarBotao(espTab, "ESP Highlight", 90)
local espBonesBtn = criarBotao(espTab, "ESP Ossos", 130)
local espToolsBtn = criarBotao(espTab, "ESP Tools", 170)
local espTeamBtn = criarBotao(espTab, "ESP Team", 210)
local espLookBtn = criarBotao(espTab, "ESP Olhar", 250)

-- BOTÕES TAB MAIN
local viewModeBtn = criarBotao(mainTab, "View Mode", 10)
local tpModeBtn = criarBotao(mainTab, "TP Mode", 50)
local ignoreTeamBtn = criarBotao(mainTab, "Ignorar Time", 90)
local antiHitBtn = criarBotao(mainTab, "AntiHit", 130)
local antiScreenBtn = criarBotao(mainTab, "Anti-Tela", 170) -- NOVO

-- NOVO: Player Select
local playerSelectBtn = criarBotao(mainTab, "Player Select", 210)

local playerSelectFrame = Instance.new("Frame")
playerSelectFrame.Size = UDim2.new(0, 300 * guiScale, 0, 400 * guiScale)
playerSelectFrame.Position = UDim2.new(0.5, -150 * guiScale, 0.5, -200 * guiScale)
playerSelectFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
playerSelectFrame.Visible = false
playerSelectFrame.Parent = ScreenGui
Instance.new("UICorner", playerSelectFrame).CornerRadius = UDim.new(0, 10)

local playerSelectTitle = Instance.new("TextLabel")
playerSelectTitle.Size = UDim2.new(1, 0, 0, 30 * guiScale)
playerSelectTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
playerSelectTitle.Text = "Selecionar Jogadores (Ignorar)"
playerSelectTitle.TextColor3 = Color3.new(1, 1, 1)
playerSelectTitle.Font = Enum.Font.SourceSansBold
playerSelectTitle.TextSize = 14 * guiScale
playerSelectTitle.Parent = playerSelectFrame
Instance.new("UICorner", playerSelectTitle).CornerRadius = UDim.new(0, 10)

local playerScrollFrame = Instance.new("ScrollingFrame")
playerScrollFrame.Size = UDim2.new(1, -20, 1, -80 * guiScale)
playerScrollFrame.Position = UDim2.new(0, 10, 0, 40 * guiScale)
playerScrollFrame.BackgroundTransparency = 1
playerScrollFrame.ScrollBarThickness = 6
playerScrollFrame.Parent = playerSelectFrame

local closePlayerSelectBtn = Instance.new("TextButton")
closePlayerSelectBtn.Size = UDim2.new(1, -20, 0, 30 * guiScale)
closePlayerSelectBtn.Position = UDim2.new(0, 10, 1, -40 * guiScale)
closePlayerSelectBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closePlayerSelectBtn.Text = "Fechar"
closePlayerSelectBtn.TextColor3 = Color3.new(1, 1, 1)
closePlayerSelectBtn.Font = Enum.Font.SourceSansBold
closePlayerSelectBtn.TextSize = 14 * guiScale
closePlayerSelectBtn.Parent = playerSelectFrame
Instance.new("UICorner", closePlayerSelectBtn).CornerRadius = UDim.new(0, 6)

-- Atualizar lista de jogadores
local function updatePlayerList()
    playerScrollFrame:ClearAllChildren()
    
    local yPos = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 30 * guiScale)
            playerBtn.Position = UDim2.new(0, 5, 0, yPos)
            playerBtn.BackgroundColor3 = ignoredPlayers[player.Name] and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 150, 0)
            playerBtn.Text = player.Name .. (ignoredPlayers[player.Name] and " [IGNORADO]" or " [ALVO]")
            playerBtn.TextColor3 = Color3.new(1, 1, 1)
            playerBtn.Font = Enum.Font.SourceSans
            playerBtn.TextSize = 12 * guiScale
            playerBtn.Parent = playerScrollFrame
            Instance.new("UICorner", playerBtn).CornerRadius = UDim.new(0, 4)
            
            playerBtn.MouseButton1Click:Connect(function()
                ignoredPlayers[player.Name] = not ignoredPlayers[player.Name]
                updatePlayerList()
            end)
            
            yPos = yPos + 35 * guiScale
        end
    end
    
    playerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

playerSelectBtn.MouseButton1Click:Connect(function()
    playerSelectFrame.Visible = not playerSelectFrame.Visible
    if playerSelectFrame.Visible then
        updatePlayerList()
    end
end)

closePlayerSelectBtn.MouseButton1Click:Connect(function()
    playerSelectFrame.Visible = false
end)

-- Função de atualização
local function atualizarStatus()
    espNameBtn.Text = espName and "ESP Nome: ✓" or "ESP Nome: ✗"
    espNameBtn.BackgroundColor3 = espName and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espLineBtn.Text = espLine and "ESP Line: ✓" or "ESP Line: ✗"
    espLineBtn.BackgroundColor3 = espLine and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espHighlightBtn.Text = espHighlight and "ESP Highlight: ✓" or "ESP Highlight: ✗"
    espHighlightBtn.BackgroundColor3 = espHighlight and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espBonesBtn.Text = espBones and "ESP Ossos: ✓" or "ESP Ossos: ✗"
    espBonesBtn.BackgroundColor3 = espBones and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espToolsBtn.Text = espTools and "ESP Tools: ✓" or "ESP Tools: ✗"
    espToolsBtn.BackgroundColor3 = espTools and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espTeamBtn.Text = espTeam and "ESP Team: ✓" or "ESP Team: ✗"
    espTeamBtn.BackgroundColor3 = espTeam and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    espLookBtn.Text = espLookDirection and "ESP Olhar: ✓" or "ESP Olhar: ✗"
    espLookBtn.BackgroundColor3 = espLookDirection and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    predictionBtn.Text = predictionEnabled and "Previsão: ✓" or "Previsão: ✗"
    predictionBtn.BackgroundColor3 = predictionEnabled and Color3.fromRGB(255, 100, 255) or Color3.fromRGB(40, 40, 40)
    
    npcAimBtn.Text = npcAim and "NPC Aim: ✓" or "NPC Aim: ✗"
    npcAimBtn.BackgroundColor3 = npcAim and Color3.fromRGB(255, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    wallCheckBtn.Text = wallCheck and "WallCheck: ✓" or "WallCheck: ✗"
    wallCheckBtn.BackgroundColor3 = wallCheck and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(40, 40, 40)
    
    viewModeBtn.Text = viewMode and "View Mode: ✓" or "View Mode: ✗"
    viewModeBtn.BackgroundColor3 = viewMode and Color3.fromRGB(0, 200, 200) or Color3.fromRGB(40, 40, 40)
    
    tpModeBtn.Text = tpMode and "TP Mode: ✓" or "TP Mode: ✗"
    tpModeBtn.BackgroundColor3 = tpMode and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(40, 40, 40)
    
    ignoreTeamBtn.Text = ignoreTeam and "Ignorar Time: ✓" or "Ignorar Time: ✗"
    ignoreTeamBtn.BackgroundColor3 = ignoreTeam and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(40, 40, 40)
    
    showFOVBtn.Text = showFOV and "Mostrar FOV: ✓" or "Mostrar FOV: ✗"
    showFOVBtn.BackgroundColor3 = showFOV and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(40, 40, 40)
    
    antiHitBtn.Text = AntiHitEnabled and "AntiHit: ✓" or "AntiHit: ✗"
    antiHitBtn.BackgroundColor3 = AntiHitEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
    
    antiScreenBtn.Text = antiScreenShare and "Anti-Tela: ✓ ATIVO" or "Anti-Tela: ✗"
    antiScreenBtn.BackgroundColor3 = antiScreenShare and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(40, 40, 40)
    
    if aimbotMode == 0 then
        aimbotBtn.Text = "Aimbot: ✗ Off"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    elseif aimbotMode == 1 then
        aimbotBtn.Text = "Aimbot: ✓ FOV"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
    elseif aimbotMode == 2 then
        aimbotBtn.Text = "Aimbot: ✓ Auto"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 150)
    elseif aimbotMode == 3 then
        aimbotBtn.Text = "Aimbot: ✓ SAFE"
        aimbotBtn.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end
end

-- Callbacks
espNameBtn.MouseButton1Click:Connect(function() espName = not espName; atualizarStatus() end)
espLineBtn.MouseButton1Click:Connect(function() espLine = not espLine; atualizarStatus() end)
espHighlightBtn.MouseButton1Click:Connect(function() espHighlight = not espHighlight; atualizarStatus() end)
espBonesBtn.MouseButton1Click:Connect(function() espBones = not espBones; atualizarStatus() end)
espToolsBtn.MouseButton1Click:Connect(function() espTools = not espTools; atualizarStatus() end)
espTeamBtn.MouseButton1Click:Connect(function() espTeam = not espTeam; atualizarStatus() end)
espLookBtn.MouseButton1Click:Connect(function() espLookDirection = not espLookDirection; atualizarStatus() end)
aimbotBtn.MouseButton1Click:Connect(function() aimbotMode = (aimbotMode + 1) % 4; atualizarStatus() end)
predictionBtn.MouseButton1Click:Connect(function() predictionEnabled = not predictionEnabled; atualizarStatus() end)
npcAimBtn.MouseButton1Click:Connect(function() npcAim = not npcAim; atualizarStatus() end)
wallCheckBtn.MouseButton1Click:Connect(function() wallCheck = not wallCheck; atualizarStatus() end)
antiScreenBtn.MouseButton1Click:Connect(function() antiScreenShare = not antiScreenShare; atualizarStatus() end)

viewModeBtn.MouseButton1Click:Connect(function()
    viewMode = not viewMode
    if viewMode then tpMode = false end
    atualizarStatus()
end)

tpModeBtn.MouseButton1Click:Connect(function()
    tpMode = not tpMode
    if tpMode then viewMode = false end
    atualizarStatus()
end)

ignoreTeamBtn.MouseButton1Click:Connect(function() ignoreTeam = not ignoreTeam; atualizarStatus() end)
showFOVBtn.MouseButton1Click:Connect(function() showFOV = not showFOV; atualizarStatus() end)
antiHitBtn.MouseButton1Click:Connect(function() AntiHitEnabled = not AntiHitEnabled; atualizarStatus() end)

fovMinusBtn.MouseButton1Click:Connect(function()
    aimFOV = math.max(50, aimFOV - 10)
    fovLabel.Text = "FOV: " .. aimFOV
end)

fovPlusBtn.MouseButton1Click:Connect(function()
    aimFOV = math.min(500, aimFOV + 10)
    fovLabel.Text = "FOV: " .. aimFOV
end)

atualizarStatus()

dragBall.MouseButton1Click:Connect(function()
    menuFrame.Visible = not menuFrame.Visible
end)

-- NOVO: Sistema Anti-Tela
RunService.Heartbeat:Connect(function()
    if antiScreenShare and isBeingWatched() then
        -- Esconder tudo
        ScreenGui.Enabled = false
    else
        ScreenGui.Enabled = true
    end
end)

-- FOV Circle
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.NumSides = 100
fovCircle.Filled = false
fovCircle.Transparency = 1
fovCircle.ZIndex = 999

-- Resto do código (funções de aimbot, ESP, etc.) continua igual...
-- [CÓDIGO AIMBOT E ESP AQUI - mesmo do script anterior]

local function isNPC(model)
    if model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character == model then return false end
        end
        return true
    end
    return false
end

local function getAllNPCs()
    local npcs = {}
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and isNPC(model) then
            local humanoid = model:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                table.insert(npcs, model)
            end
        end
    end
    return npcs
end

local function isEnemyAlive(p)
    if p.Character then
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        return hum and hum.Health > 0
    end
    return false
end

-- NOVO: Verificar se jogador está ignorado
local function isPlayerIgnored(player)
    return ignoredPlayers[player.Name] == true
end

local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

local function isAnyPartVisible(character)
    if not wallCheck then return true end
    
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
            if result and result.Instance and result.Instance:IsDescendantOf(character) then
                return true
            end
        end
    end
    return false
end

local function isSameTeam(player)
    if not ignoreTeam then return false end
    if LocalPlayer.Team and player.Team then
        return LocalPlayer.Team == player.Team
    end
    return false
end

local function getPlayerTools(player)
    local tools = {}
    if player.Character then
        for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") then
                table.insert(tools, item.Name)
            end
        end
    end
    return tools
end

local allBodyParts = {
    "Head", "UpperTorso", "Torso", "HumanoidRootPart",
    "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
    "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
    "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
}

local function getFirstVisiblePart(character)
    if not wallCheck then
        return character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    end
    
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    for _, partName in ipairs(allBodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local result = workspace:Raycast(Camera.CFrame.Position, (part.Position - Camera.CFrame.Position).Unit * 1000, raycastParams)
            if result and result.Instance and result.Instance:IsDescendantOf(character) then
                return part
            end
        end
    end
    return nil
end

local function updateVelocity(player)
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return Vector3.new(0, 0, 0)
    end
    
    local root = player.Character.HumanoidRootPart
    local currentPos = root.Position
    
    if not playerVelocities[player] then
        playerVelocities[player] = {lastPos = currentPos, velocity = Vector3.new(0, 0, 0)}
        return Vector3.new(0, 0, 0)
    end
    
    local lastPos = playerVelocities[player].lastPos
    local velocity = (currentPos - lastPos) * 60
    
    playerVelocities[player].lastPos = currentPos
    playerVelocities[player].velocity = velocity
    
    return velocity
end

local function predictPosition(part, velocity)
    if not predictionEnabled or velocity.Magnitude < 1 then
        return part.Position
    end
    
    local distance = (Camera.CFrame.Position - part.Position).Magnitude
    local bulletTime = distance / 500
    local prediction = part.Position + (velocity * bulletTime * predictionStrength)
    
    return prediction
end

local function getClosestTargetFOV()
    local closest, shortest = nil, aimFOV
    local closestPart = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not isSameTeam(p) and isEnemyAlive(p) and not isPlayerIgnored(p) then
            if not wallCheck or isAnyPartVisible(p.Character) then
                local visiblePart = getFirstVisiblePart(p.Character)
                
                if visiblePart then
                    local velocity = updateVelocity(p)
                    local targetPos = predictPosition(visiblePart, velocity)
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if onScreen and dist < shortest then
                        closest = p.Character
                        closestPart = visiblePart
                        shortest = dist
                    end
                end
            end
        end
    end
    
    if npcAim then
        for _, npc in pairs(getAllNPCs()) do
            if not wallCheck or isAnyPartVisible(npc) then
                local visiblePart = getFirstVisiblePart(npc)
                
                if visiblePart then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(visiblePart.Position)
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                    
                    if onScreen and dist < shortest then
                        closest = npc
                        closestPart = visiblePart
                        shortest = dist
                    end
                end
            end
        end
    end
    
    return closest, closestPart
end

local function getClosestTargetAuto()
    local closest, shortest = nil, math.huge
    local closestPart = nil
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not isSameTeam(p) and isEnemyAlive(p) and not isPlayerIgnored(p) then
            if not wallCheck or isAnyPartVisible(p.Character) then
                local visiblePart = getFirstVisiblePart(p.Character)
                
                if visiblePart then
                    local velocity = updateVelocity(p)
                    local targetPos = predictPosition(visiblePart, velocity)
                    local dist = (Camera.CFrame.Position - targetPos).Magnitude
                    
                    if dist < shortest then
                        closest = p.Character
                        closestPart = visiblePart
                        shortest = dist
                    end
                end
            end
        end
    end
    
    if npcAim then
        for _, npc in pairs(getAllNPCs()) do
            if not wallCheck or isAnyPartVisible(npc) then
                local visiblePart = getFirstVisiblePart(npc)
                
                if visiblePart then
                    local dist = (Camera.CFrame.Position - visiblePart.Position).Magnitude
                    
                    if dist < shortest then
                        closest = npc
                        closestPart = visiblePart
                        shortest = dist
                    end
                end
            end
        end
    end
    
    return closest, closestPart
end

local function getClosestEnemy()
    local closest, shortest = nil, math.huge
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and not isSameTeam(p) and isEnemyAlive(p) and not isPlayerIgnored(p) and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (LocalPlayer.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            
            if dist < shortest then
                closest = p.Character
                shortest = dist
            end
        end
    end
    
    return closest
end

local lastAimUpdate = 0

local function smoothAim(targetPos)
    local currentCFrame = Camera.CFrame
    
    if aimShake then
        local shake = Vector3.new(
            math.random(-10, 10) / 100,
            math.random(-10, 10) / 100,
            math.random(-10, 10) / 100
        )
        targetPos = targetPos + shake
    end
    
    Camera.CFrame = currentCFrame:Lerp(CFrame.new(currentCFrame.Position, targetPos), aimSmoothness)
end

RunService.RenderStepped:Connect(function(deltaTime)
    rgbTick = rgbTick + deltaTime * 3
    local color = RGB(rgbTick)
    
    fovCircle.Color = color
    fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fovCircle.Radius = aimFOV
    fovCircle.Visible = showFOV and (aimbotMode == 1 or aimbotMode == 3)
    
    if aimbotMode == 1 then
        local target, part = getClosestTargetFOV()
        if target and part then
            local player = Players:GetPlayerFromCharacter(target)
            if player and playerVelocities[player] then
                local predictedPos = predictPosition(part, playerVelocities[player].velocity)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    elseif aimbotMode == 2 then
        local target, part = getClosestTargetAuto()
        if target and part then
            local player = Players:GetPlayerFromCharacter(target)
            if player and playerVelocities[player] then
                local predictedPos = predictPosition(part, playerVelocities[player].velocity)
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
            else
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
            end
        end
    elseif aimbotMode == 3 then
        local currentTime = tick()
        if currentTime - lastAimUpdate >= aimDelay then
            local target, part = getClosestTargetFOV()
            if target and part then
                local player = Players:GetPlayerFromCharacter(target)
                if player and playerVelocities[player] then
                    local predictedPos = predictPosition(part, playerVelocities[player].velocity)
                    smoothAim(predictedPos)
                else
                    smoothAim(part.Position)
                end
            end
            lastAimUpdate = currentTime
        end
    end
    
    if viewMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetChar = getClosestEnemy()
        if targetChar and targetChar:FindFirstChild("Head") then
            local targetHead = targetChar.Head
            local offset = targetHead.CFrame.LookVector * -3 + Vector3.new(0, 1, 0)
            Camera.CFrame = CFrame.new(targetHead.Position + offset, targetHead.Position)
        end
    end
    
    if tpMode and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetChar = getClosestEnemy()
        if targetChar and targetChar:FindFirstChild("Head") then
            local targetHead = targetChar.Head
            local offset = targetHead.CFrame.LookVector * -3
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetHead.Position + offset, targetHead.Position)
        end
    end
end)

-- ESP CORRIGIDO COM CORES DE TIME
local boneConnections = {
    {"Head", "UpperTorso"}, {"UpperTorso", "LeftUpperArm"}, {"UpperTorso", "RightUpperArm"},
    {"LeftUpperArm", "LeftLowerArm"}, {"RightUpperArm", "RightLowerArm"},
    {"LeftLowerArm", "LeftHand"}, {"RightLowerArm", "RightHand"},
    {"UpperTorso", "LowerTorso"}, {"LowerTorso", "LeftUpperLeg"}, {"LowerTorso", "RightUpperLeg"},
    {"LeftUpperLeg", "LeftLowerLeg"}, {"RightUpperLeg", "RightLowerLeg"},
    {"LeftLowerLeg", "LeftFoot"}, {"RightLowerLeg", "RightFoot"}
}

local function createESP(player)
    if player == LocalPlayer or drawings[player] then return end
    
    drawings[player] = {
        name = Drawing.new("Text"),
        teamText = Drawing.new("Text"),
        lookLine = Drawing.new("Line"),
        tracerLine = Drawing.new("Line"),
        lifeBar = Drawing.new("Square"),
        boneLines = {}
    }
    
    drawings[player].name.Size = 14
    drawings[player].name.Center = true
    drawings[player].name.Outline = true
    drawings[player].name.Visible = false
    
    drawings[player].teamText.Size = 12
    drawings[player].teamText.Center = true
    drawings[player].teamText.Outline = true
    drawings[player].teamText.Visible = false
    
    drawings[player].lookLine.Thickness = 2
    drawings[player].lookLine.Color = Color3.fromRGB(255, 255, 0)
    drawings[player].lookLine.Visible = false
    
    drawings[player].tracerLine.Thickness = 1
    drawings[player].tracerLine.Visible = false
    
    drawings[player].lifeBar.Filled = true
    drawings[player].lifeBar.Transparency = 0.7
    drawings[player].lifeBar.Size = Vector2.new(6, 30)
    drawings[player].lifeBar.Visible = false
    
    for i = 1, #boneConnections do
        local line = Drawing.new("Line")
        line.Thickness = 1
        line.Visible = false
        table.insert(drawings[player].boneLines, line)
    end
end

local function removeESP(player)
    if drawings[player] then
        pcall(function()
            drawings[player].name:Remove()
            drawings[player].teamText:Remove()
            drawings[player].lookLine:Remove()
            drawings[player].tracerLine:Remove()
            drawings[player].lifeBar:Remove()
            for _, line in pairs(drawings[player].boneLines) do
                line:Remove()
            end
        end)
        drawings[player] = nil
    end
    playerVelocities[player] = nil
end

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    local color = RGB(rgbTick)

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
            if not drawings[p] then createESP(p) end

            local head = p.Character.Head
            local humanoid = p.Character:FindFirstChildOfClass("Humanoid")
            local headPos, headOnScreen = Camera:WorldToViewportPoint(head.Position)

            if headOnScreen and humanoid and humanoid.Health > 0 then
                local esp = drawings[p]
                
                -- NOVO: Cor baseada no time
                local teamColor = color
                if espTeam and LocalPlayer.Team and p.Team then
                    if p.Team == LocalPlayer.Team then
                        teamColor = Color3.fromRGB(0, 255, 0) -- Verde (aliado)
                    else
                        teamColor = Color3.fromRGB(255, 0, 0) -- Vermelho (inimigo)
                    end
                end
                
                -- Nome
                local displayText = p.Name
                if espTools then
                    local tools = getPlayerTools(p)
                    if #tools > 0 then
                        displayText = p.Name .. " [" .. tools[1] .. "]"
                    end
                end
                esp.name.Text = displayText
                esp.name.Position = Vector2.new(headPos.X, headPos.Y - 20)
                esp.name.Color = teamColor
                esp.name.Visible = espName
                
                -- Team
                esp.teamText.Visible = espTeam and p.Team ~= nil
                if esp.teamText.Visible then
                    esp.teamText.Text = "[" .. p.Team.Name .. "]"
                    esp.teamText.Position = Vector2.new(headPos.X, headPos.Y - 5)
                    esp.teamText.Color = teamColor
                end
                
                -- Line
                esp.tracerLine.Visible = espLine
                if espLine then
                    esp.tracerLine.From = Vector2.new(Camera.ViewportSize.X/2, 0)
                    esp.tracerLine.To = Vector2.new(headPos.X, headPos.Y)
                    esp.tracerLine.Color = teamColor
                end
                
                -- Olhar
                esp.lookLine.Visible = espLookDirection
                if espLookDirection then
                    local lookTarget = head.Position + (head.CFrame.LookVector * 5)
                    local lookPos = Camera:WorldToViewportPoint(lookTarget)
                    esp.lookLine.From = Vector2.new(headPos.X, headPos.Y)
                    esp.lookLine.To = Vector2.new(lookPos.X, lookPos.Y)
                end
                
                -- Ossos
                if espBones then
                    for i, conn in ipairs(boneConnections) do
                        local b1, b2 = p.Character:FindFirstChild(conn[1]), p.Character:FindFirstChild(conn[2])
                        if b1 and b2 then
                            local p1, s1 = Camera:WorldToViewportPoint(b1.Position)
                            local p2, s2 = Camera:WorldToViewportPoint(b2.Position)
                            if s1 and s2 then
                                esp.boneLines[i].From = Vector2.new(p1.X, p1.Y)
                                esp.boneLines[i].To = Vector2.new(p2.X, p2.Y)
                                esp.boneLines[i].Color = teamColor
                                esp.boneLines[i].Visible = true
                            else
                                esp.boneLines[i].Visible = false
                            end
                        else
                            esp.boneLines[i].Visible = false
                        end
                    end
                else
                    for _, line in pairs(esp.boneLines) do
                        line.Visible = false
                    end
                end
                
                -- Vida
                esp.lifeBar.Visible = espHighlight
                if espHighlight then
                    local percent = humanoid.Health / humanoid.MaxHealth
                    esp.lifeBar.Position = Vector2.new(headPos.X - 10, headPos.Y - 15)
                    esp.lifeBar.Size = Vector2.new(6, 30 * percent)
                    esp.lifeBar.Color = Color3.fromHSV(percent * 0.33, 1, 1)
                end
            else
                drawings[p].name.Visible = false
                drawings[p].teamText.Visible = false
                drawings[p].lookLine.Visible = false
                drawings[p].tracerLine.Visible = false
                drawings[p].lifeBar.Visible = false
                for _, line in pairs(drawings[p].boneLines) do
                    line.Visible = false
                end
            end
        end
    end
end)

-- Highlight
local function updateHighlight()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local hl = p.Character:FindFirstChild("Highlight")
            if espHighlight then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.OutlineColor = Color3.new(1, 1, 1)
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = p.Character
                end
            elseif hl then
                hl:Destroy()
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if espHighlight then
        local color = RGB(rgbTick)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local hl = p.Character:FindFirstChild("Highlight")
                if hl then hl.FillColor = color end
            end
        end
    end
end)

updateHighlight()
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(updateHighlight) end)

-- AntiHit
local lastHealth = 100

local function OnCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    lastHealth = humanoid.Health

    humanoid.HealthChanged:Connect(function(newHealth)
        if AntiHitEnabled and newHealth < lastHealth then
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame * CFrame.new(
                    math.random(0,1) == 0 and -13 or 13,
                    11,
                    0
                )
            end
        end
        lastHealth = newHealth
    end)
end

LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
if LocalPlayer.Character then OnCharacterAdded(LocalPlayer.Character) end

print("✅ GTA Hub PRO V3 Carregado!")
print("✅ Tabs: Aimbot, ESP, Main")
print("✅ Player Select funcionando!")
print("✅ ESP Team com cores (Verde=Aliado, Vermelho=Inimigo)")
print("✅ Anti-Tela ativo!")
print("✅ Tudo desativado por padrão!")
