-- GTA SCRIPTS HUB - ULTIMATE EDITION V3.0
-- by: gta (gtasa244adm17)
-- 🔥 VERSÃO SUPREMA COM TODAS AS FEATURES 🔥

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")

local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local IsMobile = UserInputService.TouchEnabled

-- ==========================================
-- KEY SYSTEM
-- ==========================================
local KEY_ENABLED = true -- MUDE PARA false PARA DESABILITAR A KEY
local CORRECT_KEY = "gg_xiter_menu_seu_jogo_suas_regras" -- MUDE A KEY AQUI
local keyValidated = false

if KEY_ENABLED then
    local function CheckKey()
        local KeyGui = Instance.new("ScreenGui")
        KeyGui.Name = "KeySystem"
        KeyGui.Parent = game:GetService("CoreGui")
        KeyGui.ResetOnSpawn = false
        
        local KeyFrame = Instance.new("Frame", KeyGui)
        KeyFrame.Size = UDim2.new(0, 400, 0, 200)
        KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
        KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        KeyFrame.BorderSizePixel = 0
        
        local Corner = Instance.new("UICorner", KeyFrame)
        Corner.CornerRadius = UDim.new(0, 15)
        
        local Gradient = Instance.new("UIGradient", KeyFrame)
        Gradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        }
        
        local Stroke = Instance.new("UIStroke", KeyFrame)
        Stroke.Color = Color3.fromRGB(255, 40, 0)
        Stroke.Thickness = 3
        
        local Title = Instance.new("TextLabel", KeyFrame)
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.BackgroundTransparency = 1
        Title.Text = "🔥 GTA SCRIPTS HUB 🔥"
        Title.TextColor3 = Color3.new(1, 1, 1)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 20
        
        local Subtitle = Instance.new("TextLabel", KeyFrame)
        Subtitle.Size = UDim2.new(1, 0, 0, 30)
        Subtitle.Position = UDim2.new(0, 0, 0, 50)
        Subtitle.BackgroundTransparency = 1
        Subtitle.Text = "Digite a Key para continuar"
        Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.TextSize = 14
        
        local KeyBox = Instance.new("TextBox", KeyFrame)
        KeyBox.Size = UDim2.new(0.8, 0, 0, 40)
        KeyBox.Position = UDim2.new(0.1, 0, 0, 90)
        KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        KeyBox.PlaceholderText = "Insira a key aqui..."
        KeyBox.Text = ""
        KeyBox.TextColor3 = Color3.new(1, 1, 1)
        KeyBox.Font = Enum.Font.Gotham
        KeyBox.TextSize = 14
        
        local KeyBoxCorner = Instance.new("UICorner", KeyBox)
        KeyBoxCorner.CornerRadius = UDim.new(0, 8)
        
        local SubmitBtn = Instance.new("TextButton", KeyFrame)
        SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
        SubmitBtn.Position = UDim2.new(0.1, 0, 0, 145)
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
        SubmitBtn.Text = "ENTRAR"
        SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.TextSize = 16
        
        local BtnCorner = Instance.new("UICorner", SubmitBtn)
        BtnCorner.CornerRadius = UDim.new(0, 8)
        
        local function ValidateKey()
            if KeyBox.Text == CORRECT_KEY then
                keyValidated = true
                KeyGui:Destroy()
                return true
            else
                Subtitle.Text = "❌ Key incorreta! Tente novamente"
                Subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
                wait(2)
                Subtitle.Text = "Digite a Key para continuar"
                Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                return false
            end
        end
        
        SubmitBtn.MouseButton1Click:Connect(ValidateKey)
        KeyBox.FocusLost:Connect(function(enter)
            if enter then
                ValidateKey()
            end
        end)
        
        -- Esperar validação
        repeat wait() until keyValidated
    end
    
    CheckKey()
end

-- Se key system desativado, validar automaticamente
if not KEY_ENABLED then
    keyValidated = true
end

-- Só continua se key for válida
if not keyValidated then
    return
end

-- ==========================================
-- CONFIGURAÇÕES E PROTEÇÃO
-- ==========================================
local OWNER_USERNAME = "gtasa244adm17"
local PROTECTED_USERS = {
    ["gtasa244adm17"] = true,
    ["gtasa244adm21"] = true
}

-- ==========================================
-- SETTINGS
-- ==========================================
local Settings = {
    -- COMBAT
    AimbotEnabled = false,
    SilentAim = false,
    TriggerBot = false,
    WallCheck = false,
    TeamCheck = false,
    TargetMode = "Head",
    FOVRadius = 135,
    ShowFOV = false,
    Smoothness = 0.5,
    Spinbot = false,
    SpinSpeed = 20,
    IgnoreNonCollidable = true,
    
    -- ESP
    ESPEnabled = false,
    ESPBox = false,
    ESPSkeleton = false,
    ESPLine = false,
    ESPName = false,
    ESPDist = false,
    ESPTool = false,
    ESPView = false,
    ESPHealth = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    FriendColor = Color3.fromRGB(0, 255, 0),
    
    -- MISC
    InfJump = false,
    Noclip = false,
    TPWalk = false,
    TPSpeed = 1,
    TPBehind = false,
    AntiAFK = false,
    NoFog = false,
    Fullbright = false,
    
    -- ADVANCED
    FollowMode = false,
    FollowTarget = nil,
    ViewMode = false,
    ViewTarget = nil,
    SpectateMode = false,
    SpectateTarget = nil,
    MassTP = false,
    
    -- SYSTEM
    Friends = {},
    SavedPosition = nil
}

-- ==========================================
-- AUTO-SAVE SYSTEM
-- ==========================================
local saveFolder = "GTA_Hub_Saves"
local saveFile = saveFolder .. "/config.json"

local function SaveSettings()
    local saveData = {
        AimbotEnabled = Settings.AimbotEnabled,
        SilentAim = Settings.SilentAim,
        TriggerBot = Settings.TriggerBot,
        WallCheck = Settings.WallCheck,
        TeamCheck = Settings.TeamCheck,
        FOVRadius = Settings.FOVRadius,
        ShowFOV = Settings.ShowFOV,
        Smoothness = Settings.Smoothness,
        Spinbot = Settings.Spinbot,
        SpinSpeed = Settings.SpinSpeed,
        IgnoreNonCollidable = Settings.IgnoreNonCollidable,
        ESPEnabled = Settings.ESPEnabled,
        ESPBox = Settings.ESPBox,
        ESPSkeleton = Settings.ESPSkeleton,
        ESPLine = Settings.ESPLine,
        ESPName = Settings.ESPName,
        ESPDist = Settings.ESPDist,
        ESPTool = Settings.ESPTool,
        ESPView = Settings.ESPView,
        ESPHealth = Settings.ESPHealth,
        InfJump = Settings.InfJump,
        Noclip = Settings.Noclip,
        TPWalk = Settings.TPWalk,
        TPSpeed = Settings.TPSpeed,
        AntiAFK = Settings.AntiAFK,
        NoFog = Settings.NoFog,
        Fullbright = Settings.Fullbright,
        Friends = Settings.Friends
    }
    
    if writefile then
        if not isfolder or not isfolder(saveFolder) then
            if makefolder then
                makefolder(saveFolder)
            end
        end
        writefile(saveFile, game:GetService("HttpService"):JSONEncode(saveData))
    end
end

local function LoadSettings()
    if readfile and isfile and isfile(saveFile) then
        local success, data = pcall(function()
            return game:GetService("HttpService"):JSONDecode(readfile(saveFile))
        end)
        
        if success and data then
            for k, v in pairs(data) do
                if Settings[k] ~= nil then
                    Settings[k] = v
                end
            end
            return true
        end
    end
    return false
end

local function DeleteSave()
    if delfile and isfile and isfile(saveFile) then
        delfile(saveFile)
        return true
    end
    return false
end

-- Auto-save a cada 30 segundos
spawn(function()
    while wait(30) do
        SaveSettings()
    end
end)

-- ==========================================
-- CRIAR GUI
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GTAScriptsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)

if not success then
    ScreenGui.Parent = LPlayer:WaitForChild("PlayerGui")
end

-- BOTÃO DE ABRIR
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 60, 0, 60)
OpenBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
OpenBtn.Text = "+"
OpenBtn.TextSize = 35
OpenBtn.TextColor3 = Color3.new(1, 1, 1)
OpenBtn.Font = Enum.Font.SourceSansBold
OpenBtn.ZIndex = 10

local CornerBtn = Instance.new("UICorner", OpenBtn)
CornerBtn.CornerRadius = UDim.new(1, 0)

local StrokeBtn = Instance.new("UIStroke", OpenBtn)
StrokeBtn.Thickness = 3
StrokeBtn.Color = Color3.fromRGB(255, 100, 0)

-- Efeito pulsante
spawn(function()
    while wait(0.8) do
        TweenService:Create(OpenBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine), 
            {BackgroundColor3 = Color3.fromRGB(255, 70, 20)}):Play()
        wait(0.8)
        TweenService:Create(OpenBtn, TweenInfo.new(0.8, Enum.EasingStyle.Sine), 
            {BackgroundColor3 = Color3.fromRGB(255, 40, 0)}):Play()
    end
end)

-- Arrastar botão
local dragging, dragInput, dragStart, startPos

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = OpenBtn.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

OpenBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        OpenBtn.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- JANELA PRINCIPAL
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 1.5, 0)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 5

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 10)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 40, 0)
MainStroke.Thickness = 3

local Gradient = Instance.new("UIGradient", MainFrame)
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
Gradient.Rotation = 0

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
Header.BorderSizePixel = 0
Header.ZIndex = 6

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 10)

local HeaderGradient = Instance.new("UIGradient", Header)
HeaderGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 40, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 0, 0))
}
HeaderGradient.Rotation = 0

local TitleLabel = Instance.new("TextLabel", Header)
TitleLabel.Size = UDim2.new(0, 400, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🔥 GTA SCRIPTS HUB - ULTIMATE V3 🔥"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextSize = 14
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 7

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.ZIndex = 7

local CloseCorner = Instance.new("UICorner", CloseBtn)
CloseCorner.CornerRadius = UDim.new(0, 8)

-- TABS CONTAINER
local TabsContainer = Instance.new("Frame", MainFrame)
TabsContainer.Position = UDim2.new(0, 0, 0, 45)
TabsContainer.Size = UDim2.new(1, 0, 0, 35)
TabsContainer.BackgroundColor3 = Color3.fromRGB(20, 0, 0)
TabsContainer.BorderSizePixel = 0
TabsContainer.ZIndex = 6

-- CONTENT
local Content = Instance.new("Frame", MainFrame)
Content.Position = UDim2.new(0, 0, 0, 85)
Content.Size = UDim2.new(1, 0, 1, -85)
Content.BackgroundTransparency = 1
Content.ZIndex = 6

-- Criar Tabs
local function CreateTab(name)
    local TabFrame = Instance.new("ScrollingFrame", Content)
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.Visible = false
    TabFrame.CanvasSize = UDim2.new(0, 0, 4, 0)
    TabFrame.ScrollBarThickness = 5
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 0)
    TabFrame.BorderSizePixel = 0
    TabFrame.ZIndex = 6
    
    local Layout = Instance.new("UIListLayout", TabFrame)
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local Padding = Instance.new("UIPadding", TabFrame)
    Padding.PaddingTop = UDim.new(0, 10)
    Padding.PaddingBottom = UDim.new(0, 10)
    
    return TabFrame
end

local CombatTab = CreateTab("Combat")
local ESPTab = CreateTab("ESP")
local MiscTab = CreateTab("Misc")
local PlayersTab = CreateTab("Players")

CombatTab.Visible = true

-- Criar botões das tabs
local tabButtons = {}
local function CreateTabButton(text, tab, order)
    local width = 0.25
    local Btn = Instance.new("TextButton", TabsContainer)
    Btn.Size = UDim2.new(width, 0, 1, 0)
    Btn.Position = UDim2.new((order - 1) * width, 0, 0, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.ZIndex = 7
    
    local Indicator = Instance.new("Frame", Btn)
    Indicator.Size = UDim2.new(1, 0, 0.1, 0)
    Indicator.Position = UDim2.new(0, 0, 0.9, 0)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = (order == 1)
    Indicator.ZIndex = 7
    
    Btn.MouseButton1Click:Connect(function()
        CombatTab.Visible = false
        ESPTab.Visible = false
        MiscTab.Visible = false
        PlayersTab.Visible = false
        tab.Visible = true
        
        for _, btn in pairs(tabButtons) do
            btn.Indicator.Visible = false
        end
        Indicator.Visible = true
    end)
    
    table.insert(tabButtons, {Button = Btn, Indicator = Indicator})
end

CreateTabButton("COMBAT", CombatTab, 1)
CreateTabButton("ESP", ESPTab, 2)
CreateTabButton("MISC", MiscTab, 3)
CreateTabButton("PLAYERS", PlayersTab, 4)

-- ==========================================
-- FUNÇÕES DE UI
-- ==========================================
local function CreateSection(parent, text)
    local Section = Instance.new("TextLabel", parent)
    Section.Size = UDim2.new(0.95, 0, 0, 30)
    Section.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
    Section.Text = "━━━ " .. text .. " ━━━"
    Section.TextColor3 = Color3.fromRGB(255, 100, 0)
    Section.Font = Enum.Font.SourceSansBold
    Section.TextSize = 14
    Section.ZIndex = 7
    
    local Corner = Instance.new("UICorner", Section)
    Corner.CornerRadius = UDim.new(0, 6)
end

local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ToggleFrame.ZIndex = 7
    
    local Corner = Instance.new("UICorner", ToggleFrame)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 8
    
    local ToggleBtn = Instance.new("TextButton", ToggleFrame)
    ToggleBtn.Size = UDim2.new(0, 50, 0, 25)
    ToggleBtn.Position = UDim2.new(1, -60, 0.5, -12.5)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleBtn.Text = ""
    ToggleBtn.ZIndex = 8
    
    local ToggleCorner = Instance.new("UICorner", ToggleBtn)
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    
    local Indicator = Instance.new("Frame", ToggleBtn)
    Indicator.Size = UDim2.new(0, 21, 0, 21)
    Indicator.Position = UDim2.new(0, 2, 0.5, -10.5)
    Indicator.BackgroundColor3 = Color3.new(1, 1, 1)
    Indicator.ZIndex = 9
    
    local IndCorner = Instance.new("UICorner", Indicator)
    IndCorner.CornerRadius = UDim.new(1, 0)
    
    local toggled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        
        if toggled then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 40, 0)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10.5)}):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(100, 100, 100)}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10.5)}):Play()
        end
        
        if callback then
            pcall(callback, toggled)
        end
        
        spawn(function()
            wait(0.5)
            SaveSettings()
        end)
    end)
    
    return ToggleBtn
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(0.95, 0, 0, 50)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SliderFrame.ZIndex = 7
    
    local Corner = Instance.new("UICorner", SliderFrame)
    Corner.CornerRadius = UDim.new(0, 8)
    
    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(0.6, 0, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.new(1, 1, 1)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 8
    
    local ValueBox = Instance.new("TextBox", SliderFrame)
    ValueBox.Size = UDim2.new(0, 60, 0, 20)
    ValueBox.Position = UDim2.new(1, -70, 0, 5)
    ValueBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    ValueBox.Text = tostring(default)
    ValueBox.TextColor3 = Color3.new(1, 1, 1)
    ValueBox.Font = Enum.Font.Gotham
    ValueBox.TextSize = 11
    ValueBox.ZIndex = 8
    
    local BoxCorner = Instance.new("UICorner", ValueBox)
    BoxCorner.CornerRadius = UDim.new(0, 4)
    
    ValueBox.FocusLost:Connect(function()
        local n = tonumber(ValueBox.Text)
        if n then
            n = math.clamp(n, min, max)
            ValueBox.Text = tostring(n)
            if callback then
                pcall(callback, n)
            end
            
            spawn(function()
                wait(0.5)
                SaveSettings()
            end)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(0.95, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    Btn.Text = text
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.Font = Enum.Font.SourceSansBold
    Btn.TextSize = 13
    Btn.ZIndex = 7
    
    local Corner = Instance.new("UICorner", Btn)
    Corner.CornerRadius = UDim.new(0, 8)
    
    Btn.MouseEnter:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 70, 20)}):Play()
    end)
    
    Btn.MouseLeave:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 40, 0)}):Play()
    end)
    
    Btn.MouseButton1Click:Connect(function()
        if callback then
            pcall(callback)
        end
    end)
end

-- ==========================================
-- COMBAT TAB
-- ==========================================
CreateSection(CombatTab, "Aimbot Settings")
CreateToggle(CombatTab, "Ativar Aimbot", function(v) Settings.AimbotEnabled = v end)
CreateToggle(CombatTab, "Silent Aim (Mira Travada)", function(v) Settings.SilentAim = v end)
CreateToggle(CombatTab, "TriggerBot (Auto Fire)", function(v) Settings.TriggerBot = v end)
CreateToggle(CombatTab, "WallCheck (Não mira parede)", function(v) Settings.WallCheck = v end)
CreateToggle(CombatTab, "TeamCheck (Ignora Time)", function(v) Settings.TeamCheck = v end)
CreateToggle(CombatTab, "Ignorar Não-Colidível", function(v) Settings.IgnoreNonCollidable = v end)
CreateToggle(CombatTab, "Mostrar FOV", function(v) Settings.ShowFOV = v end)
CreateSlider(CombatTab, "Raio FOV", 20, 800, 135, function(v) Settings.FOVRadius = v end)
CreateSlider(CombatTab, "Suavidade (1=Rápido)", 1, 10, 5, function(v) Settings.Smoothness = v/10 end)

CreateSection(CombatTab, "Spinbot")
CreateToggle(CombatTab, "🔄 Ativar Spinbot", function(v) Settings.Spinbot = v end)
CreateSlider(CombatTab, "Velocidade Spin", 1, 100, 20, function(v) Settings.SpinSpeed = v end)

-- ==========================================
-- ESP TAB
-- ==========================================
CreateSection(ESPTab, "ESP Settings")
CreateToggle(ESPTab, "Ativar ESP (Master)", function(v) Settings.ESPEnabled = v end)
CreateToggle(ESPTab, "Box (Caixa 2D)", function(v) Settings.ESPBox = v end)
CreateToggle(ESPTab, "Skeleton (Esqueleto)", function(v) Settings.ESPSkeleton = v end)
CreateToggle(ESPTab, "Tracers (Linhas)", function(v) Settings.ESPLine = v end)
CreateToggle(ESPTab, "View Tracers (Olhar)", function(v) Settings.ESPView = v end)
CreateToggle(ESPTab, "Nomes", function(v) Settings.ESPName = v end)
CreateToggle(ESPTab, "Distância", function(v) Settings.ESPDist = v end)
CreateToggle(ESPTab, "Armas (Inventário)", function(v) Settings.ESPTool = v end)
CreateToggle(ESPTab, "🌈 Health Bar Rainbow", function(v) Settings.ESPHealth = v end)

-- ==========================================
-- MISC TAB
-- ==========================================
CreateSection(MiscTab, "Movement")
CreateToggle(MiscTab, "Pulo Infinito", function(v) Settings.InfJump = v end)
CreateToggle(MiscTab, "Noclip", function(v) Settings.Noclip = v end)
CreateToggle(MiscTab, "Speed Hack (TP Walk)", function(v) Settings.TPWalk = v end)
CreateSlider(MiscTab, "Velocidade TP", 1, 5, 1, function(v) Settings.TPSpeed = v end)

CreateSection(MiscTab, "Visual")
CreateToggle(MiscTab, "🔆 Fullbright", function(v) Settings.Fullbright = v end)
CreateToggle(MiscTab, "🌫️ No Fog", function(v) Settings.NoFog = v end)
CreateToggle(MiscTab, "⏰ Anti-AFK", function(v) Settings.AntiAFK = v end)

CreateSection(MiscTab, "Teleporte Avançado")
CreateToggle(MiscTab, "🎯 Follow Mode (Grudar)", function(v)
    Settings.FollowMode = v
    if not v then
        Settings.FollowTarget = nil
        if Settings.SavedPosition and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LPlayer.Character.HumanoidRootPart.CFrame = Settings.SavedPosition
            Settings.SavedPosition = nil
        end
    else
        if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Settings.SavedPosition = LPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

CreateToggle(MiscTab, "👁️ View Mode (Só Ver)", function(v)
    Settings.ViewMode = v
    if not v then
        Settings.ViewTarget = nil
        if Settings.SavedPosition and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LPlayer.Character.HumanoidRootPart.CFrame = Settings.SavedPosition
            Settings.SavedPosition = nil
        end
    else
        if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            Settings.SavedPosition = LPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

CreateButton(MiscTab, "TP Atrás do Inimigo Próximo", function()
    Settings.TPBehind = true
    wait(0.1)
    Settings.TPBehind = false
end)

CreateSection(MiscTab, "Saves")
CreateButton(MiscTab, "💾 Salvar Config", function()
    SaveSettings()
    local notif = Instance.new("TextLabel", ScreenGui)
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.9, 0)
    notif.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    notif.Text = "✅ Salvo!"
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 16
    notif.ZIndex = 200
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 10)
    wait(2)
    notif:Destroy()
end)

CreateButton(MiscTab, "📂 Carregar Config", function()
    local loaded = LoadSettings()
    local notif = Instance.new("TextLabel", ScreenGui)
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.9, 0)
    notif.BackgroundColor3 = loaded and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    notif.Text = loaded and "✅ Carregado!" or "❌ Sem Save"
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 16
    notif.ZIndex = 200
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 10)
    wait(2)
    notif:Destroy()
end)

CreateButton(MiscTab, "🗑️ Apagar Save", function()
    DeleteSave()
    local notif = Instance.new("TextLabel", ScreenGui)
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(0.5, -150, 0.9, 0)
    notif.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    notif.Text = "🗑️ Save Apagado!"
    notif.TextColor3 = Color3.new(1, 1, 1)
    notif.Font = Enum.Font.GothamBold
    notif.TextSize = 16
    notif.ZIndex = 200
    local corner = Instance.new("UICorner", notif)
    corner.CornerRadius = UDim.new(0, 10)
    wait(2)
    notif:Destroy()
end)

-- ==========================================
-- PLAYERS TAB
-- ==========================================
CreateSection(PlayersTab, "Player Management")

CreateButton(PlayersTab, "🔄 Atualizar Lista", function()
    -- Implementado abaixo
end)

CreateButton(PlayersTab, "📍 Mass TP (Todos para Você)", function()
    if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myPos = LPlayer.Character.HumanoidRootPart.CFrame
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LPlayer and not PROTECTED_USERS[p.Name] and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if not Settings.TeamCheck or p.Team ~= LPlayer.Team then
                    p.Character.HumanoidRootPart.CFrame = myPos * CFrame.new(math.random(-5, 5), 0, math.random(-5, 5))
                end
            end
        end
    end
end)

local PlayersList = Instance.new("Frame", PlayersTab)
PlayersList.Size = UDim2.new(0.95, 0, 1, -150)
PlayersList.BackgroundTransparency = 1
PlayersList.ZIndex = 7

local PlayersLayout = Instance.new("UIListLayout", PlayersList)
PlayersLayout.Padding = UDim.new(0, 5)
PlayersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function RefreshPlayers()
    for _, v in pairs(PlayersList:GetChildren()) do
        if v:IsA("Frame") then
            v:Destroy()
        end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LPlayer and not PROTECTED_USERS[p.Name] then
            local Frame = Instance.new("Frame", PlayersList)
            Frame.Size = UDim2.new(1, 0, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Frame.ZIndex = 8
            
            local Corner = Instance.new("UICorner", Frame)
            Corner.CornerRadius = UDim.new(0, 6)
            
            local Name = Instance.new("TextLabel", Frame)
            Name.Size = UDim2.new(0.4, 0, 1, 0)
            Name.Position = UDim2.new(0, 10, 0, 0)
            Name.BackgroundTransparency = 1
            Name.Text = p.Name
            Name.TextColor3 = Color3.new(1, 1, 1)
            Name.Font = Enum.Font.Gotham
            Name.TextSize = 10
            Name.TextXAlignment = Enum.TextXAlignment.Left
            Name.ZIndex = 9
            
            local FriendBtn = Instance.new("TextButton", Frame)
            FriendBtn.Size = UDim2.new(0, 60, 0, 25)
            FriendBtn.Position = UDim2.new(0.42, 0, 0.5, -12.5)
            FriendBtn.ZIndex = 9
            
            local FriendCorner = Instance.new("UICorner", FriendBtn)
            FriendCorner.CornerRadius = UDim.new(0, 6)
            
            local TPBtn = Instance.new("TextButton", Frame)
            TPBtn.Size = UDim2.new(0, 40, 0, 25)
            TPBtn.Position = UDim2.new(0.65, 0, 0.5, -12.5)
            TPBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
            TPBtn.Text = "TP"
            TPBtn.TextColor3 = Color3.new(1, 1, 1)
            TPBtn.Font = Enum.Font.GothamBold
            TPBtn.TextSize = 11
            TPBtn.ZIndex = 9
            
            local TPCorner = Instance.new("UICorner", TPBtn)
            TPCorner.CornerRadius = UDim.new(0, 6)
            
            local FollowBtn = Instance.new("TextButton", Frame)
            FollowBtn.Size = UDim2.new(0, 40, 0, 25)
            FollowBtn.Position = UDim2.new(0.85, 0, 0.5, -12.5)
            FollowBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            FollowBtn.Text = "👁️"
            FollowBtn.TextColor3 = Color3.new(1, 1, 1)
            FollowBtn.Font = Enum.Font.GothamBold
            FollowBtn.TextSize = 11
            FollowBtn.ZIndex = 9
            
            local FollowCorner = Instance.new("UICorner", FollowBtn)
            FollowCorner.CornerRadius = UDim.new(0, 6)
            
            local function UpdateFriend()
                if Settings.Friends[p.Name] then
                    FriendBtn.Text = "AMIGO"
                    FriendBtn.BackgroundColor3 = Color3.fromRGB(0, 220, 0)
                    FriendBtn.TextColor3 = Color3.new(1, 1, 1)
                else
                    FriendBtn.Text = "INIMIGO"
                    FriendBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                    FriendBtn.TextColor3 = Color3.new(1, 1, 1)
                end
            end
            
            UpdateFriend()
            
            FriendBtn.MouseButton1Click:Connect(function()
                Settings.Friends[p.Name] = not Settings.Friends[p.Name]
                UpdateFriend()
                SaveSettings()
            end)
            
            TPBtn.MouseButton1Click:Connect(function()
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                end
            end)
            
            FollowBtn.MouseButton1Click:Connect(function()
                if Settings.FollowMode then
                    Settings.FollowTarget = p
                    FollowBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
                elseif Settings.ViewMode then
                    Settings.ViewTarget = p
                    FollowBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
                end
            end)
        end
    end
end

RefreshPlayers()
Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(RefreshPlayers)

-- ==========================================
-- CONTROLE JANELA
-- ==========================================
local isOpen = false

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame:TweenPosition(UDim2.new(0.5, -275, 1.5, 0), "In", "Quad", 0.5)
    isOpen = false
    OpenBtn.Text = "+"
end)

OpenBtn.MouseButton1Click:Connect(function()
    if dragging then return end
    
    if not isOpen then
        MainFrame:TweenPosition(UDim2.new(0.5, -275, 0.2, 0), "Out", "Back", 0.6)
        OpenBtn.Text = "-"
        isOpen = true
    else
        MainFrame:TweenPosition(UDim2.new(0.5, -275, 1.5, 0), "In", "Quad", 0.5)
        OpenBtn.Text = "+"
        isOpen = false
    end
end)

-- ==========================================
-- ENGINE DE COMBAT
-- ==========================================
local Skeletons = {}
local Tracers = {}
local ViewTracers = {}
local Texts = {}

local function NewLine()
    if Drawing then
        local l = Drawing.new("Line")
        l.Visible = false
        l.Thickness = 1
        return l
    end
    return nil
end

local function NewText()
    if Drawing then
        local t = Drawing.new("Text")
        t.Visible = false
        t.Size = 14
        t.Center = true
        t.Outline = true
        return t
    end
    return nil
end

local function NewCircle()
    if Drawing then
        local c = Drawing.new("Circle")
        c.Visible = false
        c.Thickness = 1.5
        c.NumSides = 32
        c.Filled = false
        return c
    end
    return nil
end

local FOVCircle = nil
pcall(function() FOVCircle = NewCircle() end)

local function ClearESP(plr)
    if Skeletons[plr] then
        for _, l in pairs(Skeletons[plr]) do
            if l and l.Remove then l:Remove() end
        end
        Skeletons[plr] = nil
    end
    if Tracers[plr] and Tracers[plr].Remove then
        Tracers[plr]:Remove()
        Tracers[plr] = nil
    end
    if ViewTracers[plr] and ViewTracers[plr].Remove then
        ViewTracers[plr]:Remove()
        ViewTracers[plr] = nil
    end
    if Texts[plr] and Texts[plr].Remove then
        Texts[plr]:Remove()
        Texts[plr] = nil
    end
    if plr.Character and plr.Character:FindFirstChild("GG_Highlight") then
        plr.Character.GG_Highlight:Destroy()
    end
end

Players.PlayerRemoving:Connect(ClearESP)

local function IsVisible(target)
    if not Settings.WallCheck then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LPlayer.Character, Camera}
    local res = workspace:Raycast(Camera.CFrame.Position, target.Position - Camera.CFrame.Position, params)
    return (not res) or res.Instance:IsDescendantOf(target.Parent)
end

local function GetTarget()
    local best, minDist = nil, Settings.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if PROTECTED_USERS[v.Name] then continue end
            if Settings.TeamCheck and v.Team == LPlayer.Team then continue end
            if Settings.Friends[v.Name] then continue end
            
            -- Ignorar não-colidível
            if Settings.IgnoreNonCollidable then
                local hrp = v.Character.HumanoidRootPart
                if not hrp.CanCollide then continue end
            end
            
            local part = v.Character:FindFirstChild(Settings.TargetMode) or v.Character:FindFirstChild("Head")
            if part then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDist and IsVisible(part) then
                        minDist = dist
                        best = part
                    end
                end
            end
        end
    end
    
    return best
end

-- Rainbow color generator
local function GetRainbowColor()
    local hue = (tick() % 5) / 5
    return Color3.fromHSV(hue, 1, 1)
end

-- ==========================================
-- RENDER LOOP
-- ==========================================
RunService.RenderStepped:Connect(function()
    -- FOV Circle
    if FOVCircle then
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        FOVCircle.Color = Settings.ESPColor
    end
    
    -- Spinbot
    if Settings.Spinbot and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LPlayer.Character.HumanoidRootPart.CFrame = LPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(Settings.SpinSpeed), 0)
    end
    
    -- Aimbot
    local target = GetTarget()
    if target and Settings.AimbotEnabled then
        local pos = target.Position
        
        if Settings.SilentAim then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos)
        else
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), Settings.Smoothness)
        end
        
        if Settings.TriggerBot then
            local mouse = LPlayer:GetMouse()
            if mouse.Target and mouse.Target:IsDescendantOf(target.Parent) then
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end)
            end
        end
        
        if Settings.TPBehind and target.Parent then
            local root = target.Parent:FindFirstChild("HumanoidRootPart")
            if root and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 0, 3)
                Settings.TPBehind = false
            end
        end
    end
    
    -- TP Walk
    if Settings.TPWalk and LPlayer.Character then
        local hum = LPlayer.Character:FindFirstChild("Humanoid")
        local root = LPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * Settings.TPSpeed)
        end
    end
    
    -- Noclip
    if Settings.Noclip and LPlayer.Character then
        for _, part in pairs(LPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Follow Mode (Grudar atrás)
    if Settings.FollowMode and Settings.FollowTarget and Settings.FollowTarget.Character and Settings.FollowTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = Settings.FollowTarget.Character.HumanoidRootPart
            LPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 4)
        end
    end
    
    -- View Mode (Só ver, sem TP)
    if Settings.ViewMode and Settings.ViewTarget and Settings.ViewTarget.Character and Settings.ViewTarget.Character:FindFirstChild("HumanoidRootPart") then
        -- Apenas move a câmera
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Settings.ViewTarget.Character.HumanoidRootPart.Position)
    end
    
    -- Fullbright
    if Settings.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    
    -- No Fog
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    end
    
    -- ESP LOOP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LPlayer and not PROTECTED_USERS[v.Name] then
            local char = v.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and Settings.ESPEnabled then
                local root = char.HumanoidRootPart
                local head = char.Head
                local color = Settings.Friends[v.Name] and Settings.FriendColor or Settings.ESPColor
                local pos, vis = Camera:WorldToViewportPoint(root.Position)
                
                -- Box ESP
                local hl = char:FindFirstChild("GG_Highlight")
                if Settings.ESPBox then
                    if not hl then
                        hl = Instance.new("Highlight", char)
                        hl.Name = "GG_Highlight"
                        hl.FillTransparency = 1
                    end
                    hl.OutlineColor = color
                    hl.Enabled = true
                elseif hl then
                    hl.Enabled = false
                end
                
                if Drawing then
                    -- Tracer
                    if not Tracers[v] then Tracers[v] = NewLine() end
                    if Settings.ESPLine and vis and Tracers[v] then
                        Tracers[v].Visible = true
                        Tracers[v].Color = color
                        Tracers[v].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        Tracers[v].To = Vector2.new(pos.X, pos.Y)
                    elseif Tracers[v] then
                        Tracers[v].Visible = false
                    end
                    
                    -- Text ESP (Nome/Dist/Tool/Health)
                    if not Texts[v] then Texts[v] = NewText() end
                    if (Settings.ESPName or Settings.ESPDist or Settings.ESPTool or Settings.ESPHealth) and vis and Texts[v] then
                        local headP = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                        Texts[v].Visible = true
                        
                        -- Rainbow health bar
                        if Settings.ESPHealth then
                            Texts[v].Color = GetRainbowColor()
                        else
                            Texts[v].Color = color
                        end
                        
                        Texts[v].Position = Vector2.new(headP.X, headP.Y)
                        
                        local txt = ""
                        if Settings.ESPName then txt = v.Name end
                        
                        if Settings.ESPHealth then
                            local hum = char:FindFirstChildOfClass("Humanoid")
                            if hum then
                                local healthPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
                                txt = txt .. "\n💚 " .. healthPercent .. "% HP"
                            end
                        end
                        
                        if Settings.ESPDist then
                            txt = txt .. "\n[" .. math.floor((root.Position - Camera.CFrame.Position).Magnitude) .. "m]"
                        end
                        
                        if Settings.ESPTool then
                            local tools = {}
                            local equippedTool = char:FindFirstChildOfClass("Tool")
                            if equippedTool then
                                table.insert(tools, "✓ " .. equippedTool.Name)
                            end
                            
                            local backpack = v:FindFirstChild("Backpack")
                            if backpack then
                                for _, tool in pairs(backpack:GetChildren()) do
                                    if tool:IsA("Tool") then
                                        table.insert(tools, tool.Name)
                                    end
                                end
                            end
                            
                            if #tools > 0 then
                                txt = txt .. "\n[" .. table.concat(tools, ", ") .. "]"
                            else
                                txt = txt .. "\n[Sem Armas]"
                            end
                        end
                        
                        Texts[v].Text = txt
                    elseif Texts[v] then
                        Texts[v].Visible = false
                    end
                    
                    -- View Tracer
                    if not ViewTracers[v] then ViewTracers[v] = NewLine() end
                    if Settings.ESPView and vis and ViewTracers[v] then
                        local look = head.CFrame.LookVector * 10
                        local endPos = Camera:WorldToViewportPoint(head.Position + look)
                        local startPos = Camera:WorldToViewportPoint(head.Position)
                        ViewTracers[v].Visible = true
                        ViewTracers[v].Color = Color3.new(1, 1, 1)
                        ViewTracers[v].From = Vector2.new(startPos.X, startPos.Y)
                        ViewTracers[v].To = Vector2.new(endPos.X, endPos.Y)
                    elseif ViewTracers[v] then
                        ViewTracers[v].Visible = false
                    end
                    
                    -- Skeleton
                    if not Skeletons[v] then Skeletons[v] = {} end
                    if Settings.ESPSkeleton and vis then
                        local function Line(p1, p2)
                            local key = p1.Name .. p2.Name
                            if not Skeletons[v][key] then
                                Skeletons[v][key] = NewLine()
                            end
                            local l = Skeletons[v][key]
                            if l then
                                local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                                local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                                if vis1 and vis2 then
                                    l.Visible = true
                                    l.Color = color
                                    l.From = Vector2.new(v1.X, v1.Y)
                                    l.To = Vector2.new(v2.X, v2.Y)
                                else
                                    l.Visible = false
                                end
                            end
                        end
                        
                        if char:FindFirstChild("UpperTorso") then
                            if char:FindFirstChild("Head") and char:FindFirstChild("UpperTorso") then
                                Line(char.Head, char.UpperTorso)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("LowerTorso") then
                                Line(char.UpperTorso, char.LowerTorso)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("LeftUpperArm") then
                                Line(char.UpperTorso, char.LeftUpperArm)
                            end
                            if char:FindFirstChild("UpperTorso") and char:FindFirstChild("RightUpperArm") then
                                Line(char.UpperTorso, char.RightUpperArm)
                            end
                        elseif char:FindFirstChild("Torso") then
                            if char:FindFirstChild("Head") and char:FindFirstChild("Torso") then
                                Line(char.Head, char.Torso)
                            end
                            if char:FindFirstChild("Torso") and char:FindFirstChild("Left Arm") then
                                Line(char.Torso, char["Left Arm"])
                            end
                            if char:FindFirstChild("Torso") and char:FindFirstChild("Right Arm") then
                                Line(char.Torso, char["Right Arm"])
                            end
                            if char:FindFirstChild("Torso") and char:FindFirstChild("Left Leg") then
                                Line(char.Torso, char["Left Leg"])
                            end
                            if char:FindFirstChild("Torso") and char:FindFirstChild("Right Leg") then
                                Line(char.Torso, char["Right Leg"])
                            end
                        end
                    else
                        for _, l in pairs(Skeletons[v]) do
                            if l then l.Visible = false end
                        end
                    end
                end
            else
                ClearESP(v)
            end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LPlayer.Character then
        local hum = LPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState("Jumping")
        end
    end
end)

-- Anti-AFK
if Settings.AntiAFK then
    spawn(function()
        while wait(300) do
            if Settings.AntiAFK then
                VirtualInputManager:SendKeyEvent(true, "W", false, game)
                wait(0.1)
                VirtualInputManager:SendKeyEvent(false, "W", false, game)
            end
        end
    end)
end

-- ==========================================
-- MENSAGEM DE BOAS-VINDAS
-- ==========================================
wait(0.5)
local WelcomeFrame = Instance.new("Frame", ScreenGui)
WelcomeFrame.Size = UDim2.new(0, 400, 0, 150)
WelcomeFrame.Position = UDim2.new(0.5, -200, 0.5, -75)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WelcomeFrame.BorderSizePixel = 0
WelcomeFrame.ZIndex = 100

local WelcomeCorner = Instance.new("UICorner", WelcomeFrame)
WelcomeCorner.CornerRadius = UDim.new(0, 15)

local WelcomeGradient = Instance.new("UIGradient", WelcomeFrame)
WelcomeGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
}
WelcomeGradient.Rotation = 0

local WelcomeStroke = Instance.new("UIStroke", WelcomeFrame)
WelcomeStroke.Color = Color3.fromRGB(255, 40, 0)
WelcomeStroke.Thickness = 3

local WelcomeText = Instance.new("TextLabel", WelcomeFrame)
WelcomeText.Size = UDim2.new(1, -20, 1, -20)
WelcomeText.Position = UDim2.new(0, 10, 0, 10)
WelcomeText.BackgroundTransparency = 1
WelcomeText.TextColor3 = Color3.new(1, 1, 1)
WelcomeText.Font = Enum.Font.SourceSansBold
WelcomeText.TextSize = 24
WelcomeText.TextWrapped = true
WelcomeText.ZIndex = 101

if PROTECTED_USERS[LPlayer.Name] then
    WelcomeText.Text = "🔥 Seja Bem-Vindo\nGTA SCRIPTS DE BOA! 🔥\n\n👑 DONO: " .. LPlayer.Name .. " 👑"
else
    WelcomeText.Text = "🔥 Seja Bem-Vindo 🔥\n\n" .. LPlayer.Name .. "\n\nAo GTA Scripts Hub V3 ULTIMATE!"
end

WelcomeFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(WelcomeFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Size = UDim2.new(0, 400, 0, 150)}):Play()

wait(4)
TweenService:Create(WelcomeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
    {Size = UDim2.new(0, 0, 0, 0)}):Play()
wait(0.3)
WelcomeFrame:Destroy()

-- Carregar config automaticamente
spawn(function()
    wait(1)
    LoadSettings()
end)

print("✅ GTA Scripts Hub V3 ULTIMATE carregado!")
print("🔥 By: gta (gtasa244adm17)")
print("📁 Saves: " .. saveFolder)
