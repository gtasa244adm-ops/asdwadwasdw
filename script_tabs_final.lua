-- GTA SCRIPTS HUB V6 - SUPREME EDITION
-- by: gta (gtasa244adm17)
-- 🔥 VERSÃO COMPLETA COM TODAS AS FEATURES 🔥

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LPlayer:GetMouse()

-- ==========================================
-- ADMINS
-- ==========================================
local ADMINS = {
    ["gtasa244adm17"] = true,
    ["gtasa244adm21"] = true
}

local IS_ADMIN = ADMINS[LPlayer.Name] == true

-- ==========================================
-- KEY SYSTEM
-- ==========================================
local KEYS = {"gg_scripts-for_all-games", "quem ta vendo a tela e gay", }
local keyValidated = false

local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "KeySystem"
KeyGui.ResetOnSpawn = false
pcall(function() KeyGui.Parent = game:GetService("CoreGui") end)
if not KeyGui.Parent then KeyGui.Parent = LPlayer.PlayerGui end

local KeyFrame = Instance.new("Frame", KeyGui)
KeyFrame.Size = UDim2.new(0, 400, 0, 200)
KeyFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
KeyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
KeyFrame.BorderSizePixel = 0

Instance.new("UICorner", KeyFrame).CornerRadius = UDim.new(0, 15)

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
Instance.new("UICorner", KeyBox).CornerRadius = UDim.new(0, 8)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0, 145)
SubmitBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
SubmitBtn.Text = "ENTRAR"
SubmitBtn.TextColor3 = Color3.new(1, 1, 1)
SubmitBtn.Font = Enum.Font.GothamBold
SubmitBtn.TextSize = 16
Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 8)

local function ValidateKey()
    local inputKey = KeyBox.Text:lower()
    for _, k in ipairs(KEYS) do
        if inputKey == k:lower() then
            keyValidated = true
            Subtitle.Text = "✅ KEY VÁLIDA!"
            Subtitle.TextColor3 = Color3.fromRGB(0, 255, 0)
            wait(0.5)
            KeyGui:Destroy()
            return true
        end
    end
    Subtitle.Text = "❌ Key incorreta!"
    Subtitle.TextColor3 = Color3.fromRGB(255, 0, 0)
    wait(2)
    Subtitle.Text = "Digite a Key para continuar"
    Subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
    return false
end

SubmitBtn.MouseButton1Click:Connect(ValidateKey)
KeyBox.FocusLost:Connect(function(e) if e then ValidateKey() end end)

repeat wait(0.1) until keyValidated

-- ==========================================
-- SCRIPT COMMUNICATION
-- ==========================================
local SCRIPT_ID = "GTA_HUB_V6_" .. HttpService:GenerateGUID(false)
local SCRIPT_USERS = {}
local ScriptComm = nil

local function CreateCommunication()
    local success, result = pcall(function()
        local folder = ReplicatedStorage:FindFirstChild("GTA_Hub_Communication")
        if not folder then
            folder = Instance.new("Folder")
            folder.Name = "GTA_Hub_Communication"
            folder.Parent = ReplicatedStorage
        end
        local value = folder:FindFirstChild("UserData")
        if not value then
            value = Instance.new("StringValue")
            value.Name = "UserData"
            value.Parent = folder
        end
        return value
    end)
    if success then return result end
    return nil
end

ScriptComm = CreateCommunication()

local function BroadcastUser()
    if ScriptComm then
        pcall(function()
            local data = HttpService:JSONDecode(ScriptComm.Value or "{}")
            data[LPlayer.Name] = {ScriptID = SCRIPT_ID, Timestamp = tick()}
            ScriptComm.Value = HttpService:JSONEncode(data)
        end)
    end
end

local function UpdateScriptUsers()
    if ScriptComm then
        pcall(function()
            local data = HttpService:JSONDecode(ScriptComm.Value or "{}")
            SCRIPT_USERS = {}
            local currentTime = tick()
            for playerName, info in pairs(data) do
                if currentTime - info.Timestamp < 10 then
                    SCRIPT_USERS[playerName] = true
                end
            end
        end)
    end
end

spawn(function()
    while wait(2) do
        BroadcastUser()
        UpdateScriptUsers()
    end
end)

-- ==========================================
-- SETTINGS
-- ==========================================
local Settings = {
    ScriptDisabled = false,
    
    -- AIMBOT
    RageAimbot = false,
    MultiPoint = false,
    SmartAimbot = true,
    HitPredictor = false,
    PredictionAmount = 0.1,
    SilentAim = false,
    TriggerBot = false,
    TeamCheck = false,
    WallCheck = false,
    FOVRadius = 200,
    ShowFOV = false,
    Smoothness = 0.3,
    NoRecoil = false,
    HitboxExpander = false,
    HitboxSize = 5,
    
    -- ESP
    ESPEnabled = false,
    ESPBox = false,
    ESPCornerBox = false,
    ESPChams = false,
    ESPTracers = false,
    ESPNames = false,
    ESPDistance = false,
    ESPHealth = false,
    ESPWeapon = false,
    ESPTeamName = false,
    ESPTeamCheck = false,
    
    -- VIEW & TP
    ViewMode = false,
    ViewTarget = nil,
    TPMode = false,
    TPTarget = nil,
    SavedTPPosition = nil,
    
    -- MISC
    InfJump = false,
    Noclip = false,
    FlyEnabled = false,
    FlySpeed = 50,
    WalkSpeed = false,
    WalkSpeedValue = 16,
    NoFog = false,
    Fullbright = false,
    
    -- ADMIN
    SelectedPlayer = nil,
    BanType = "Permanent",
    BanDuration = 60,
    
    -- SYSTEM
    PanicMode = false
}

-- ==========================================
-- GUI (UI ORIGINAL)
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GTAHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LPlayer.PlayerGui end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 500)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.ZIndex = 100
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(255, 40, 0)
MainStroke.Thickness = 2

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Header.BorderSizePixel = 0
Header.ZIndex = 101
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local HeaderFix = Instance.new("Frame", Header)
HeaderFix.Size = UDim2.new(1, 0, 0.5, 0)
HeaderFix.Position = UDim2.new(0, 0, 0.5, 0)
HeaderFix.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HeaderFix.BorderSizePixel = 0
HeaderFix.ZIndex = 101

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔥 GTA SCRIPTS HUB V6 SUPREME 🔥"
Title.TextColor3 = Color3.fromRGB(255, 40, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 102

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -40, 0, 2.5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.ZIndex = 102
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

-- TABS
local TabsFrame = Instance.new("Frame", MainFrame)
TabsFrame.Size = UDim2.new(1, 0, 0, 35)
TabsFrame.Position = UDim2.new(0, 0, 0, 45)
TabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TabsFrame.BorderSizePixel = 0
TabsFrame.ZIndex = 100

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -85)
ContentFrame.Position = UDim2.new(0, 0, 0, 85)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 100

-- ==========================================
-- TAB SYSTEM
-- ==========================================
local Tabs = {}

local function CreateTab(name, order)
    local TabButton = Instance.new("TextButton", TabsFrame)
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabButton.BorderSizePixel = 0
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 12
    TabButton.ZIndex = 101
    
    local TabContent = Instance.new("ScrollingFrame", ContentFrame)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 0)
    TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContent.Visible = false
    TabContent.ZIndex = 100
    
    local Layout = Instance.new("UIListLayout", TabContent)
    Layout.Padding = UDim.new(0, 8)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    Instance.new("UIPadding", TabContent).PaddingTop = UDim.new(0, 10)
    
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContent.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 20)
    end)
    
    local Indicator = Instance.new("Frame", TabButton)
    Indicator.Size = UDim2.new(1, 0, 0, 3)
    Indicator.Position = UDim2.new(0, 0, 1, -3)
    Indicator.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = false
    Indicator.ZIndex = 102
    
    Tabs[order] = {Button = TabButton, Content = TabContent, Indicator = Indicator}
    return TabContent
end

local AimbotTab = CreateTab("AIMBOT", 1)
local ESPTab = CreateTab("ESP", 2)
local MiscTab = CreateTab("MISC", 3)
local AdminTab
if IS_ADMIN then
    AdminTab = CreateTab("ADMIN", 4)
end

local tabCount = IS_ADMIN and 4 or 3
local tabWidth = 1 / tabCount

for i, tab in ipairs(Tabs) do
    tab.Button.Size = UDim2.new(tabWidth, 0, 1, 0)
    tab.Button.Position = UDim2.new((i-1) * tabWidth, 0, 0, 0)
    
    tab.Button.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Content.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            t.Indicator.Visible = false
        end
        tab.Content.Visible = true
        tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tab.Button.TextColor3 = Color3.new(1, 1, 1)
        tab.Indicator.Visible = true
    end)
end

Tabs[1].Content.Visible = true
Tabs[1].Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Tabs[1].Button.TextColor3 = Color3.new(1, 1, 1)
Tabs[1].Indicator.Visible = true

-- ==========================================
-- UI COMPONENTS
-- ==========================================
local function Section(parent, text)
    local s = Instance.new("TextLabel", parent)
    s.Size = UDim2.new(0.95, 0, 0, 28)
    s.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    s.Text = "  " .. text
    s.TextColor3 = Color3.fromRGB(255, 40, 0)
    s.Font = Enum.Font.GothamBold
    s.TextSize = 12
    s.TextXAlignment = Enum.TextXAlignment.Left
    s.ZIndex = 101
    Instance.new("UICorner", s).CornerRadius = UDim.new(0, 6)
end

local function Toggle(parent, text, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.95, 0, 0, 38)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    f.ZIndex = 101
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.7, 0, 1, 0)
    l.Position = UDim2.new(0, 10, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 102
    
    local b = Instance.new("TextButton", f)
    b.Size = UDim2.new(0, 48, 0, 22)
    b.Position = UDim2.new(1, -58, 0.5, -11)
    b.BackgroundColor3 = default and Color3.fromRGB(255, 40, 0) or Color3.fromRGB(50, 50, 50)
    b.Text = ""
    b.ZIndex = 102
    Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
    
    local i = Instance.new("Frame", b)
    i.Size = UDim2.new(0, 18, 0, 18)
    i.Position = default and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    i.BackgroundColor3 = Color3.new(1, 1, 1)
    i.ZIndex = 103
    Instance.new("UICorner", i).CornerRadius = UDim.new(1, 0)
    
    local on = default or false
    b.MouseButton1Click:Connect(function()
        on = not on
        TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = on and Color3.fromRGB(255, 40, 0) or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(i, TweenInfo.new(0.2), {Position = on and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
        if callback then pcall(callback, on) end
    end)
end

local function Slider(parent, text, min, max, default, callback)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(0.95, 0, 0, 48)
    f.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    f.ZIndex = 101
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(0.6, 0, 0, 18)
    l.Position = UDim2.new(0, 10, 0, 6)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.new(1, 1, 1)
    l.Font = Enum.Font.Gotham
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 102
    
    local box = Instance.new("TextBox", f)
    box.Size = UDim2.new(0, 65, 0, 22)
    box.Position = UDim2.new(1, -75, 0, 13)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = tostring(default)
    box.TextColor3 = Color3.new(1, 1, 1)
    box.Font = Enum.Font.Gotham
    box.TextSize = 10
    box.ZIndex = 102
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then
            n = math.clamp(n, min, max)
            box.Text = tostring(n)
            if callback then pcall(callback, n) end
        else
            box.Text = tostring(default)
        end
    end)
end

local function Button(parent, text, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.ZIndex = 101
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseButton1Click:Connect(function()
        if callback then pcall(callback) end
    end)
end

-- ==========================================
-- POPULATE TABS
-- ==========================================

-- AIMBOT TAB
Section(AimbotTab, "Aimbot Configuration")
Toggle(AimbotTab, "🔥 Rage Aimbot (Instant Lock)", false, function(v) Settings.RageAimbot = v end)
Toggle(AimbotTab, "🎯 Multi-Point (All Body Parts)", false, function(v) Settings.MultiPoint = v end)
Toggle(AimbotTab, "⚡ Smart Lock (1 Frame)", true, function(v) Settings.SmartAimbot = v end)
Toggle(AimbotTab, "🔮 Hit Predictor", false, function(v) Settings.HitPredictor = v end)
Slider(AimbotTab, "Prediction (0.01-0.5)", 1, 50, 10, function(v) Settings.PredictionAmount = v/100 end)
Toggle(AimbotTab, "Silent Aim", false, function(v) Settings.SilentAimbot = v end)
Toggle(AimbotTab, "TriggerBot", false, function(v) Settings.TriggerBot = v end)
Toggle(AimbotTab, "Team Check", false, function(v) Settings.TeamCheck = v end)
Toggle(AimbotTab, "Wall Check", false, function(v) Settings.WallCheck = v end)
Toggle(AimbotTab, "Show FOV Circle", false, function(v) Settings.ShowFOV = v end)
Slider(AimbotTab, "FOV Radius", 20, 500, 200, function(v) Settings.FOVRadius = v end)
Slider(AimbotTab, "Smoothness", 1, 10, 3, function(v) Settings.Smoothness = v/10 end)

Section(AimbotTab, "Advanced")
Toggle(AimbotTab, "🎯 No Recoil", false, function(v) Settings.NoRecoil = v end)
Toggle(AimbotTab, "📦 Hitbox Expander", false, function(v) Settings.HitboxExpander = v end)
Slider(AimbotTab, "Hitbox Size", 1, 50, 5, function(v) Settings.HitboxSize = v end)

-- ESP TAB
Section(ESPTab, "ESP Configuration")
Toggle(ESPTab, "Enable ESP", false, function(v) Settings.ESPEnabled = v end)
Toggle(ESPTab, "📦 Box ESP", false, function(v) Settings.ESPBox = v end)
Toggle(ESPTab, "📐 Corner Box (Clean)", false, function(v) Settings.ESPCornerBox = v end)
Toggle(ESPTab, "✨ Chams ESP", false, function(v) Settings.ESPChams = v end)
Toggle(ESPTab, "📍 Tracers", false, function(v) Settings.ESPTracers = v end)
Toggle(ESPTab, "📝 Names", false, function(v) Settings.ESPNames = v end)
Toggle(ESPTab, "📏 Distance", false, function(v) Settings.ESPDistance = v end)
Toggle(ESPTab, "💚 Health", false, function(v) Settings.ESPHealth = v end)
Toggle(ESPTab, "🔫 Weapon", false, function(v) Settings.ESPWeapon = v end)
Toggle(ESPTab, "👥 Team Name", false, function(v) Settings.ESPTeamName = v end)
Toggle(ESPTab, "Team Check", false, function(v) Settings.ESPTeamCheck = v end)

-- MISC TAB
Section(MiscTab, "View & Teleport")
Toggle(MiscTab, "👁️ View Mode", false, function(v)
    Settings.ViewMode = v
    if not v and LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LPlayer.Character.Humanoid
        Settings.ViewTarget = nil
    end
end)
Toggle(MiscTab, "📍 TP Behind Mode", false, function(v) Settings.TPMode = v end)

Section(MiscTab, "Movement")
Toggle(MiscTab, "✈️ Fly Mode", false, function(v) Settings.FlyEnabled = v end)
Slider(MiscTab, "Fly Speed", 10, 200, 50, function(v) Settings.FlySpeed = v end)
Toggle(MiscTab, "Infinite Jump", false, function(v) Settings.InfJump = v end)
Toggle(MiscTab, "Noclip", false, function(v) Settings.Noclip = v end)
Toggle(MiscTab, "Walk Speed", false, function(v) Settings.WalkSpeed = v end)
Slider(MiscTab, "WS Value", 16, 200, 16, function(v) Settings.WalkSpeedValue = v end)

Section(MiscTab, "Visual")
Toggle(MiscTab, "💡 Fullbright", false, function(v) Settings.Fullbright = v end)
Toggle(MiscTab, "🌫️ No Fog", false, function(v) Settings.NoFog = v end)

-- ADMIN TAB
if IS_ADMIN then
    Section(AdminTab, "Player Selection (✅ = Has Script)")
    
    local PlayerList = Instance.new("ScrollingFrame", AdminTab)
    PlayerList.Size = UDim2.new(0.95, 0, 0, 170)
    PlayerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 4
    PlayerList.ScrollBarImageColor3 = Color3.fromRGB(255, 40, 0)
    PlayerList.CanvasSize = UDim2.new(0, 0, 0, 0)
    PlayerList.ZIndex = 101
    Instance.new("UICorner", PlayerList).CornerRadius = UDim.new(0, 6)
    
    local PlayerListLayout = Instance.new("UIListLayout", PlayerList)
    PlayerListLayout.Padding = UDim.new(0, 3)
    PlayerListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    PlayerListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y + 6)
    end)
    
    local function UpdatePlayerList()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LPlayer then
                local hasScript = SCRIPT_USERS[player.Name] or false
                
                local PlayerButton = Instance.new("TextButton", PlayerList)
                PlayerButton.Size = UDim2.new(0.98, 0, 0, 26)
                PlayerButton.BackgroundColor3 = hasScript and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(20, 20, 20)
                PlayerButton.Text = (hasScript and "✅ " or "❌ ") .. player.Name
                PlayerButton.TextColor3 = hasScript and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(100, 100, 100)
                PlayerButton.Font = Enum.Font.GothamSemibold
                PlayerButton.TextSize = 11
                PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
                PlayerButton.ZIndex = 102
                Instance.new("UICorner", PlayerButton).CornerRadius = UDim.new(0, 4)
                Instance.new("UIPadding", PlayerButton).PaddingLeft = UDim.new(0, 6)
                
                if hasScript then
                    PlayerButton.MouseButton1Click:Connect(function()
                        Settings.SelectedPlayer = player
                        for _, btn in ipairs(PlayerList:GetChildren()) do
                            if btn:IsA("TextButton") and btn.Text:find("✅") then
                                btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
                            end
                        end
                        PlayerButton.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
                    end)
                end
            end
        end
    end
    
    UpdatePlayerList()
    spawn(function()
        while wait(3) do
            if not Settings.ScriptDisabled then UpdatePlayerList() end
        end
    end)
    
    Section(AdminTab, "Ban Configuration")
    
    local BanTypeFrame = Instance.new("Frame", AdminTab)
    BanTypeFrame.Size = UDim2.new(0.95, 0, 0, 38)
    BanTypeFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    BanTypeFrame.ZIndex = 101
    Instance.new("UICorner", BanTypeFrame).CornerRadius = UDim.new(0, 6)
    
    local BanTypeLabel = Instance.new("TextLabel", BanTypeFrame)
    BanTypeLabel.Size = UDim2.new(0.5, 0, 1, 0)
    BanTypeLabel.Position = UDim2.new(0, 10, 0, 0)
    BanTypeLabel.BackgroundTransparency = 1
    BanTypeLabel.Text = "Ban Type:"
    BanTypeLabel.TextColor3 = Color3.new(1, 1, 1)
    BanTypeLabel.Font = Enum.Font.GothamSemibold
    BanTypeLabel.TextSize = 11
    BanTypeLabel.TextXAlignment = Enum.TextXAlignment.Left
    BanTypeLabel.ZIndex = 102
    
    local PermBtn = Instance.new("TextButton", BanTypeFrame)
    PermBtn.Size = UDim2.new(0, 60, 0, 22)
    PermBtn.Position = UDim2.new(0.5, -65, 0.5, -11)
    PermBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    PermBtn.Text = "PERM"
    PermBtn.TextColor3 = Color3.new(1, 1, 1)
    PermBtn.Font = Enum.Font.GothamBold
    PermBtn.TextSize = 10
    PermBtn.ZIndex = 102
    Instance.new("UICorner", PermBtn).CornerRadius = UDim.new(0, 4)
    
    local TempBtn = Instance.new("TextButton", BanTypeFrame)
    TempBtn.Size = UDim2.new(0, 60, 0, 22)
    TempBtn.Position = UDim2.new(1, -65, 0.5, -11)
    TempBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TempBtn.Text = "TEMP"
    TempBtn.TextColor3 = Color3.new(1, 1, 1)
    TempBtn.Font = Enum.Font.GothamBold
    TempBtn.TextSize = 10
    TempBtn.ZIndex = 102
    Instance.new("UICorner", TempBtn).CornerRadius = UDim.new(0, 4)
    
    PermBtn.MouseButton1Click:Connect(function()
        Settings.BanType = "Permanent"
        PermBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
        TempBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end)
    
    TempBtn.MouseButton1Click:Connect(function()
        Settings.BanType = "Temporary"
        PermBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        TempBtn.BackgroundColor3 = Color3.fromRGB(255, 40, 0)
    end)
    
    Slider(AdminTab, "Duration (min)", 1, 1440, 60, function(v) Settings.BanDuration = v end)
    
    Section(AdminTab, "Admin Commands")
    Button(AdminTab, "👁️ View Player", function()
        if Settings.SelectedPlayer and Settings.SelectedPlayer.Character and Settings.SelectedPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = Settings.SelectedPlayer.Character.Humanoid
        end
    end)
    
    Button(AdminTab, "🔙 Stop Viewing", function()
        if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LPlayer.Character.Humanoid
        end
    end)
    
    Button(AdminTab, "📍 TP to Player", function()
        if Settings.SelectedPlayer and Settings.SelectedPlayer.Character and Settings.SelectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LPlayer.Character.HumanoidRootPart.CFrame = Settings.SelectedPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 5)
            end
        end
    end)
    
    Button(AdminTab, "💀 Kill Player", function()
        if Settings.SelectedPlayer and SCRIPT_USERS[Settings.SelectedPlayer.Name] then
            if Settings.SelectedPlayer.Character then
                local humanoid = Settings.SelectedPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.Health = 0 end
            end
        end
    end)
    
    Button(AdminTab, "🚫 Kick Player", function()
        if Settings.SelectedPlayer and SCRIPT_USERS[Settings.SelectedPlayer.Name] then
            local msg = Settings.BanType == "Permanent" and "Banido permanentemente" or ("Banido por " .. Settings.BanDuration .. " minutos")
            Settings.SelectedPlayer:Kick(msg)
        end
    end)
end

-- ==========================================
-- CONTROLS
-- ==========================================
CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

local menuOpen = true
local shiftPressed = false

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if Settings.ScriptDisabled then return end
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        shiftPressed = true
    elseif input.KeyCode == Enum.KeyCode.Comma and shiftPressed then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
    elseif input.KeyCode == Enum.KeyCode.Period and shiftPressed then
        Settings.PanicMode = not Settings.PanicMode
        if Settings.PanicMode then
            Settings.RageAimbot = false
            Settings.ESPEnabled = false
            Settings.FlyEnabled = false
            MainFrame.Visible = false
        else
            MainFrame.Visible = true
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        shiftPressed = false
    end
end)

-- Mobile Controls
local touches = {}
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if Settings.ScriptDisabled then return end
    if gameProcessed then return end
    
    touches[touch] = true
    local count = 0
    for _ in pairs(touches) do count = count + 1 end
    
    if count == 3 then
        menuOpen = not menuOpen
        MainFrame.Visible = menuOpen
        touches = {}
    elseif count == 4 then
        Settings.PanicMode = not Settings.PanicMode
        if Settings.PanicMode then
            Settings.RageAimbot = false
            Settings.ESPEnabled = false
            MainFrame.Visible = false
        else
            MainFrame.Visible = true
        end
        touches = {}
    end
end)

UserInputService.TouchEnded:Connect(function(touch)
    touches[touch] = nil
end)

-- ==========================================
-- AIMBOT ENGINE
-- ==========================================
local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 500
    
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {LPlayer.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local result = workspace:Raycast(origin, direction, rayParams)
    if not result then return true end
    
    return result.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetAllVisibleParts(character)
    local visibleParts = {}
    local bodyParts = {
        "Head", "UpperTorso", "Torso", "HumanoidRootPart",
        "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
        "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
        "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot"
    }
    
    for _, partName in ipairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
            if onScreen and IsVisible(part) then
                table.insert(visibleParts, {
                    Part = part,
                    Name = partName,
                    ScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                })
            end
        end
    end
    
    return visibleParts
end

local function GetBestTarget()
    local bestTarget = nil
    local bestDistance = Settings.FOVRadius
    local bestPriority = 999
    
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local partPriority = {
        Head = 1,
        UpperTorso = 2,
        Torso = 2,
        LeftUpperArm = 3,
        RightUpperArm = 3,
        HumanoidRootPart = 4
    }
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == LPlayer then continue end
        if not targetPlayer.Character then continue end
        
        local humanoid = targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        if Settings.TeamCheck and targetPlayer.Team == LPlayer.Team then continue end
        
        if Settings.RageAimbot or Settings.MultiPoint or Settings.SmartAimbot then
            local visibleParts = GetAllVisibleParts(targetPlayer.Character)
            
            for _, partInfo in ipairs(visibleParts) do
                local distance = (partInfo.ScreenPos - screenCenter).Magnitude
                local priority = partPriority[partInfo.Name] or 5
                
                if distance < bestDistance then
                    if priority < bestPriority or (priority == bestPriority and distance < bestDistance) then
                        bestDistance = distance
                        bestPriority = priority
                        bestTarget = partInfo.Part
                        
                        if Settings.RageAimbot and partInfo.Name == "Head" then
                            break
                        end
                    end
                end
            end
        end
    end
    
    return bestTarget
end

-- ==========================================
-- HITBOX EXPANDER
-- ==========================================
local expandedHitboxes = {}

local function ExpandHitboxes()
    if not Settings.HitboxExpander then
        for player, parts in pairs(expandedHitboxes) do
            for _, part in ipairs(parts) do
                if part and part.Parent then
                    local originalSize = part:GetAttribute("OriginalSize")
                    if originalSize then
                        part.Size = originalSize
                        part.Transparency = part:GetAttribute("OriginalTransparency") or 0
                        part.CanCollide = part:GetAttribute("OriginalCanCollide") ~= false
                    end
                end
            end
        end
        expandedHitboxes = {}
        return
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LPlayer and player.Character then
            if Settings.TeamCheck and player.Team == LPlayer.Team then continue end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not expandedHitboxes[player] then
                hrp:SetAttribute("OriginalSize", hrp.Size)
                hrp:SetAttribute("OriginalTransparency", hrp.Transparency)
                hrp:SetAttribute("OriginalCanCollide", hrp.CanCollide)
                
                hrp.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
                
                expandedHitboxes[player] = {hrp}
            end
        end
    end
end

-- ==========================================
-- ESP ENGINE
-- ==========================================
local ESPStorage = {}

local function ClearESP(player)
    if ESPStorage[player] then
        for _, object in pairs(ESPStorage[player]) do
            pcall(function()
                if object and object.Destroy then
                    object:Destroy()
                elseif object and object.Remove then
                    object:Remove()
                end
            end)
        end
        ESPStorage[player] = nil
    end
end

Players.PlayerRemoving:Connect(ClearESP)

local function UpdateESP()
    if not Settings.ESPEnabled then
        for player, _ in pairs(ESPStorage) do
            ClearESP(player)
        end
        return
    end
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == LPlayer then continue end
        
        local character = targetPlayer.Character
        if not character then 
            ClearESP(targetPlayer)
            continue 
        end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        
        if not rootPart or not head or not humanoid or humanoid.Health <= 0 then
            ClearESP(targetPlayer)
            continue
        end
        
        if Settings.ESPTeamCheck and targetPlayer.Team == LPlayer.Team then
            ClearESP(targetPlayer)
            continue
        end
        
        if not ESPStorage[targetPlayer] then
            ESPStorage[targetPlayer] = {}
        end
        
        -- ESP DINÂMICO: Branco se visível, Vermelho se escondido
        local canShoot = false
        
        if head then
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen and IsVisible(head) then
                canShoot = true
            end
        end
        
        if not canShoot then
            local parts = {"UpperTorso", "Torso", "HumanoidRootPart"}
            for _, partName in ipairs(parts) do
                local part = character:FindFirstChild(partName)
                if part then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen and IsVisible(part) then
                        canShoot = true
                        break
                    end
                end
            end
        end
        
        local espColor = canShoot and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(255, 0, 0)
        
        -- BOX ESP
        if Settings.ESPBox then
            if not character:FindFirstChild("ESP_BoxHandle") then
                local box = Instance.new("BoxHandleAdornment")
                box.Name = "ESP_BoxHandle"
                box.Size = character:GetExtentsSize()
                box.Adornee = rootPart
                box.Color3 = espColor
                box.Transparency = 0.7
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = character
                table.insert(ESPStorage[targetPlayer], box)
            else
                character.ESP_BoxHandle.Color3 = espColor
            end
        else
            local box = character:FindFirstChild("ESP_BoxHandle")
            if box then box:Destroy() end
        end
        
        -- CORNER BOX ESP
        if Settings.ESPCornerBox and Drawing then
            if not ESPStorage[targetPlayer].CornerLines then
                ESPStorage[targetPlayer].CornerLines = {}
                for i = 1, 16 do
                    ESPStorage[targetPlayer].CornerLines[i] = Drawing.new("Line")
                end
            end
            
            local size = character:GetExtentsSize()
            local corners = {
                rootPart.CFrame * CFrame.new(-size.X/2, size.Y/2, -size.Z/2),
                rootPart.CFrame * CFrame.new(size.X/2, size.Y/2, -size.Z/2),
                rootPart.CFrame * CFrame.new(size.X/2, size.Y/2, size.Z/2),
                rootPart.CFrame * CFrame.new(-size.X/2, size.Y/2, size.Z/2),
                rootPart.CFrame * CFrame.new(-size.X/2, -size.Y/2, -size.Z/2),
                rootPart.CFrame * CFrame.new(size.X/2, -size.Y/2, -size.Z/2),
                rootPart.CFrame * CFrame.new(size.X/2, -size.Y/2, size.Z/2),
                rootPart.CFrame * CFrame.new(-size.X/2, -size.Y/2, size.Z/2)
            }
            
            local screenCorners = {}
            local allVisible = true
            for i, corner in ipairs(corners) do
                local pos, vis = Camera:WorldToViewportPoint(corner.Position)
                screenCorners[i] = Vector2.new(pos.X, pos.Y)
                if not vis then allVisible = false end
            end
            
            if allVisible then
                local lineIndex = 1
                local cornerSize = 15
                
                for i = 1, 4 do
                    local next = (i % 4) + 1
                    local diff = (screenCorners[next] - screenCorners[i]).Unit * cornerSize
                    
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Visible = true
                    ESPStorage[targetPlayer].CornerLines[lineIndex].From = screenCorners[i]
                    ESPStorage[targetPlayer].CornerLines[lineIndex].To = screenCorners[i] + diff
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Color = espColor
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Thickness = 2
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Transparency = 1
                    lineIndex = lineIndex + 1
                end
                
                for i = 5, 8 do
                    local next = ((i - 5) % 4) + 5
                    local diff = (screenCorners[next] - screenCorners[i]).Unit * cornerSize
                    
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Visible = true
                    ESPStorage[targetPlayer].CornerLines[lineIndex].From = screenCorners[i]
                    ESPStorage[targetPlayer].CornerLines[lineIndex].To = screenCorners[i] + diff
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Color = espColor
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Thickness = 2
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Transparency = 1
                    lineIndex = lineIndex + 1
                end
                
                for i = 1, 4 do
                    local bottom = i + 4
                    local diff = (screenCorners[bottom] - screenCorners[i]).Unit * cornerSize
                    
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Visible = true
                    ESPStorage[targetPlayer].CornerLines[lineIndex].From = screenCorners[i]
                    ESPStorage[targetPlayer].CornerLines[lineIndex].To = screenCorners[i] + diff
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Color = espColor
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Thickness = 2
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Transparency = 1
                    lineIndex = lineIndex + 1
                    
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Visible = true
                    ESPStorage[targetPlayer].CornerLines[lineIndex].From = screenCorners[bottom]
                    ESPStorage[targetPlayer].CornerLines[lineIndex].To = screenCorners[bottom] - diff
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Color = espColor
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Thickness = 2
                    ESPStorage[targetPlayer].CornerLines[lineIndex].Transparency = 1
                    lineIndex = lineIndex + 1
                end
            else
                for _, line in ipairs(ESPStorage[targetPlayer].CornerLines) do
                    if line then line.Visible = false end
                end
            end
        elseif ESPStorage[targetPlayer].CornerLines then
            for _, line in ipairs(ESPStorage[targetPlayer].CornerLines) do
                if line then line.Visible = false end
            end
        end
        
        -- CHAMS ESP
        if Settings.ESPChams then
            if not character:FindFirstChild("ESP_Highlight") then
                local cham = Instance.new("Highlight")
                cham.Name = "ESP_Highlight"
                cham.Adornee = character
                cham.FillColor = espColor
                cham.OutlineColor = espColor
                cham.FillTransparency = 0.5
                cham.OutlineTransparency = 0
                cham.Parent = character
                table.insert(ESPStorage[targetPlayer], cham)
            else
                character.ESP_Highlight.FillColor = espColor
                character.ESP_Highlight.OutlineColor = espColor
            end
        else
            local cham = character:FindFirstChild("ESP_Highlight")
            if cham then cham:Destroy() end
        end
        
        -- DRAWING ESP
        if Drawing then
            local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            -- TRACERS
            if Settings.ESPTracers then
                if not ESPStorage[targetPlayer].Tracer then
                    ESPStorage[targetPlayer].Tracer = Drawing.new("Line")
                end
                
                ESPStorage[targetPlayer].Tracer.Visible = onScreen
                ESPStorage[targetPlayer].Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                ESPStorage[targetPlayer].Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
                ESPStorage[targetPlayer].Tracer.Color = espColor
                ESPStorage[targetPlayer].Tracer.Thickness = 1
                ESPStorage[targetPlayer].Tracer.Transparency = 1
            elseif ESPStorage[targetPlayer].Tracer then
                ESPStorage[targetPlayer].Tracer.Visible = false
            end
            
            -- TEXT ESP
            if Settings.ESPNames or Settings.ESPDistance or Settings.ESPHealth or Settings.ESPWeapon or Settings.ESPTeamName then
                if not ESPStorage[targetPlayer].Text then
                    ESPStorage[targetPlayer].Text = Drawing.new("Text")
                    ESPStorage[targetPlayer].Text.Size = 13
                    ESPStorage[targetPlayer].Text.Center = true
                    ESPStorage[targetPlayer].Text.Outline = true
                    ESPStorage[targetPlayer].Text.Font = 2
                end
                
                local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                
                ESPStorage[targetPlayer].Text.Visible = onScreen
                ESPStorage[targetPlayer].Text.Position = Vector2.new(headPos.X, headPos.Y)
                ESPStorage[targetPlayer].Text.Color = espColor
                
                local textContent = ""
                
                if Settings.ESPNames then
                    textContent = textContent .. targetPlayer.Name .. "\n"
                end
                
                if Settings.ESPTeamName and targetPlayer.Team then
                    textContent = textContent .. "👥 " .. targetPlayer.Team.Name .. "\n"
                end
                
                if Settings.ESPHealth then
                    local healthPercent = math.floor((humanoid.Health / humanoid.MaxHealth) * 100)
                    textContent = textContent .. "💚 " .. healthPercent .. "%\n"
                end
                
                if Settings.ESPDistance then
                    local distance = math.floor((rootPart.Position - Camera.CFrame.Position).Magnitude)
                    textContent = textContent .. "[" .. distance .. "m]\n"
                end
                
                if Settings.ESPWeapon then
                    local tool = character:FindFirstChildOfClass("Tool")
                    if tool then
                        textContent = textContent .. "🔫 " .. tool.Name
                    end
                end
                
                ESPStorage[targetPlayer].Text.Text = textContent
            elseif ESPStorage[targetPlayer].Text then
                ESPStorage[targetPlayer].Text.Visible = false
            end
        end
    end
end

-- ==========================================
-- FLY ENGINE
-- ==========================================
local flying = false
local flyBodyVelocity = nil
local flyBodyGyro = nil

local function StartFly()
    if not LPlayer.Character or not LPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    
    flying = true
    local rootPart = LPlayer.Character.HumanoidRootPart
    
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
    flyBodyVelocity.Parent = rootPart
    
    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    flyBodyGyro.P = 9e4
    flyBodyGyro.Parent = rootPart
end

local function StopFly()
    flying = false
    
    if flyBodyVelocity then
        flyBodyVelocity:Destroy()
        flyBodyVelocity = nil
    end
    
    if flyBodyGyro then
        flyBodyGyro:Destroy()
        flyBodyGyro = nil
    end
end

-- ==========================================
-- GET CLOSEST PLAYER
-- ==========================================
local function GetClosestPlayer()
    local closestPlayer = nil
    local closestDistance = math.huge
    
    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer == LPlayer then continue end
        if not targetPlayer.Character then continue end
        if not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then continue end
        
        if Settings.TeamCheck and targetPlayer.Team == LPlayer.Team then continue end
        
        if LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (targetPlayer.Character.HumanoidRootPart.Position - LPlayer.Character.HumanoidRootPart.Position).Magnitude
            
            if distance < closestDistance then
                closestDistance = distance
                closestPlayer = targetPlayer
            end
        end
    end
    
    return closestPlayer
end

-- ==========================================
-- FOV CIRCLE
-- ==========================================
local FOVCircle = nil

if Drawing then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 2
    FOVCircle.NumSides = 64
    FOVCircle.Filled = false
    FOVCircle.Color = Color3.fromRGB(255, 40, 0)
    FOVCircle.Visible = false
    FOVCircle.Transparency = 1
end

-- ==========================================
-- MAIN LOOP
-- ==========================================
RunService.RenderStepped:Connect(function()
    if Settings.ScriptDisabled then return end
    if Settings.PanicMode then return end
    
    -- FOV CIRCLE
    if FOVCircle then
        FOVCircle.Visible = Settings.ShowFOV
        FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
    
    -- HITBOX EXPANDER
    pcall(ExpandHitboxes)
    
    -- AIMBOT
    if Settings.RageAimbot or Settings.MultiPoint or Settings.SmartAimbot then
        local targetPart = GetBestTarget()
        
        if targetPart then
            local targetPosition = targetPart.Position
            
            -- HIT PREDICTOR
            if Settings.HitPredictor and targetPart.Parent and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
                local velocity = targetPart.Parent.HumanoidRootPart.AssemblyLinearVelocity
                targetPosition = targetPosition + (velocity * Settings.PredictionAmount)
            end
            
            local cameraPosition = Camera.CFrame.Position
            local newCFrame = CFrame.new(cameraPosition, targetPosition)
            
            if Settings.RageAimbot then
                Camera.CFrame = newCFrame
            else
                Camera.CFrame = Camera.CFrame:Lerp(newCFrame, Settings.Smoothness)
            end
            
            -- TRIGGERBOT
            if Settings.TriggerBot and Mouse.Target and Mouse.Target:IsDescendantOf(targetPart.Parent) then
                pcall(function()
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    wait(0.05)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                    wait(0.1)
                end)
            end
        end
    end
    
    -- NO RECOIL
    if Settings.NoRecoil and LPlayer.Character then
        local humanoid = LPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Name:lower():find("recoil") or track.Name:lower():find("shoot") then
                    track:AdjustSpeed(0)
                end
            end
        end
    end
    
    -- ESP
    pcall(UpdateESP)
    
    -- VIEW MODE
    if Settings.ViewMode then
        if not Settings.ViewTarget or not Settings.ViewTarget.Character or not Settings.ViewTarget.Character:FindFirstChild("Humanoid") then
            Settings.ViewTarget = GetClosestPlayer()
        end
        
        if Settings.ViewTarget and Settings.ViewTarget.Character and Settings.ViewTarget.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = Settings.ViewTarget.Character.Humanoid
        else
            Settings.ViewTarget = GetClosestPlayer()
        end
    else
        Settings.ViewTarget = nil
        if LPlayer.Character and LPlayer.Character:FindFirstChild("Humanoid") then
            Camera.CameraSubject = LPlayer.Character.Humanoid
        end
    end
    
    -- TP MODE
    if Settings.TPMode then
        if not LPlayer.Character or not LPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
        
        if not Settings.SavedTPPosition then
            Settings.SavedTPPosition = LPlayer.Character.HumanoidRootPart.CFrame
        end
        
        if not Settings.TPTarget or not Settings.TPTarget.Character or not Settings.TPTarget.Character:FindFirstChild("HumanoidRootPart") then
            Settings.TPTarget = GetClosestPlayer()
        end
        
        if Settings.TPTarget and Settings.TPTarget.Character and Settings.TPTarget.Character:FindFirstChild("HumanoidRootPart") then
            local targetRoot = Settings.TPTarget.Character.HumanoidRootPart
            LPlayer.Character.HumanoidRootPart.CFrame = targetRoot.CFrame * CFrame.new(0, 2, 5)
        else
            Settings.TPTarget = GetClosestPlayer()
        end
    else
        if Settings.SavedTPPosition and LPlayer.Character and LPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LPlayer.Character.HumanoidRootPart.CFrame = Settings.SavedTPPosition
            Settings.SavedTPPosition = nil
        end
        Settings.TPTarget = nil
    end
    
    -- FLY
    if Settings.FlyEnabled then
        if not flying then
            StartFly()
        end
        
        if flying and flyBodyVelocity and flyBodyGyro then
            local direction = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - Camera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + Camera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0, 1, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
                direction = direction - Vector3.new(0, 1, 0)
            end
            
            if direction.Magnitude > 0 then
                direction = direction.Unit
            end
            
            flyBodyVelocity.Velocity = direction * Settings.FlySpeed
            flyBodyGyro.CFrame = Camera.CFrame
        end
    else
        if flying then
            StopFly()
        end
    end
    
    -- NOCLIP
    if Settings.Noclip and LPlayer.Character then
        for _, part in ipairs(LPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- WALK SPEED
    if Settings.WalkSpeed and LPlayer.Character then
        local humanoid = LPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Settings.WalkSpeedValue
        end
    end
    
    -- FULLBRIGHT
    if Settings.Fullbright then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
    
    -- NO FOG
    if Settings.NoFog then
        Lighting.FogEnd = 100000
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if Settings.ScriptDisabled then return end
    if Settings.InfJump and LPlayer.Character then
        local humanoid = LPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ==========================================
-- WELCOME MESSAGE
-- ==========================================
wait(1)

local WelcomeFrame = Instance.new("Frame", ScreenGui)
WelcomeFrame.Size = UDim2.new(0, 350, 0, 130)
WelcomeFrame.Position = UDim2.new(0.5, -175, 0.5, -65)
WelcomeFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
WelcomeFrame.BorderSizePixel = 0
WelcomeFrame.ZIndex = 500
Instance.new("UICorner", WelcomeFrame).CornerRadius = UDim.new(0, 12)

local WelcomeStroke = Instance.new("UIStroke", WelcomeFrame)
WelcomeStroke.Color = Color3.fromRGB(255, 40, 0)
WelcomeStroke.Thickness = 2

local WelcomeText = Instance.new("TextLabel", WelcomeFrame)
WelcomeText.Size = UDim2.new(1, -20, 1, -20)
WelcomeText.Position = UDim2.new(0, 10, 0, 10)
WelcomeText.BackgroundTransparency = 1
WelcomeText.TextColor3 = Color3.new(1, 1, 1)
WelcomeText.Font = Enum.Font.GothamBold
WelcomeText.TextSize = 20
WelcomeText.TextWrapped = true
WelcomeText.ZIndex = 501

if IS_ADMIN then
    WelcomeText.Text = "👑 ADMIN: " .. LPlayer.Name .. " 👑\n\n🔥 GTA HUB V6 SUPREME 🔥\n\nLOADED!"
else
    WelcomeText.Text = "🔥 Welcome 🔥\n\n" .. LPlayer.Name .. "\n\nGTA Hub V6 Supreme\nLoaded!"
end

WelcomeFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(WelcomeFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
    {Size = UDim2.new(0, 350, 0, 130)}):Play()

wait(3)

TweenService:Create(WelcomeFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
    {Size = UDim2.new(0, 0, 0, 0)}):Play()

wait(0.3)
WelcomeFrame:Destroy()

print("╔═══════════════════════════════════════════════════════════╗")
print("║     ✅ GTA HUB V6 SUPREME CARREGADO! ✅                 ║")
print("╠═══════════════════════════════════════════════════════════╣")
