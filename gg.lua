--[[
MeuHub — GUI final com drag e comportamento de minimizar que esconde/mostra botões
Cole e execute no executor (Delta / Xenon / Synapse-like).
Características adicionadas nesta versão:
- Drag robusto (UserInputService) para mover o painel em qualquer ambiente
- Ao minimizar: os botões (content + StopAll) somem; ao maximizar: reaparecem
- Mantém todo o resto: proteção, ordenação 1..5, modo exclusivo, toggle, teclas 1..5, ESC para Stop All
- Move para PlayerGui se ele aparecer depois (respawn/executor ordering)

Uso rápido: cole inteiro no executor e execute. A UI aparecerá e terá drag + minimizar que oculta os botões.
]]

-- ===== CONFIG =====
local ANIM_IDS = {
    Lapada        = 10717116749,
    Mortal        = 15693621070,
    TomaToma      = 135546619046275,
    TomaTomaDance = 129991743366120,
    VemQue        = 130707926247972, -- "Vem que eu tô com a move"
}
local BUTTON_ORDER = { "Lapada", "Mortal", "TomaToma", "TomaTomaDance", "VemQue" }
local KEYBINDS = {
    Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three,
    Enum.KeyCode.Four, Enum.KeyCode.Five
}
local ACCENT = Color3.fromRGB(54,199,122)
local BG = Color3.fromRGB(20,20,20)
local PANEL_ALPHA = 0.06

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ===== HELPERS =====
local function try(fn, ...)
    if type(fn) ~= "function" then return false end
    local ok, res = pcall(fn, ...)
    return ok, res
end

local function resolveInitialParent()
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
        return LocalPlayer.PlayerGui
    end
    if type(gethui) == "function" then
        local ok, g = pcall(gethui)
        if ok and g then return g end
    end
    if type(get_hidden_gui) == "function" then
        local ok, g = pcall(get_hidden_gui)
        if ok and g then return g end
    end
    return game:GetService("CoreGui")
end

local function protectGui(gui)
    if not gui then return end
    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, gui)
        return
    end
    if type(protect_gui) == "function" then pcall(protect_gui, gui) return end
    if type(DELTA) == "table" and type(DELTA.ProtectGui) == "function" then pcall(DELTA.ProtectGui, DELTA, gui) return end
    if type(XENON) == "table" and type(XENON.ProtectGui) == "function" then pcall(XENON.ProtectGui, XENON, gui) return end
end

local function tween(obj, props, t)
    local info = TweenInfo.new(t or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end

-- ===== GUI ENSURE/CREATE =====n
local function finalizeGui(screenGui, main)
    if not screenGui then return end
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screenGui.DisplayOrder = 9999
    if main then
        main.AnchorPoint = Vector2.new(0.5, 0)
        main.Position = UDim2.new(0.5, 0, 0.12, 0)
    end
    protectGui(screenGui)
    screenGui.Enabled = true
end

local function createMeuHub(parent)
    parent = parent or resolveInitialParent()
    pcall(function()
        local old = parent:FindFirstChild("MeuHub")
        if old then old:Destroy() end
    end)

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MeuHub"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = parent

    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 340, 0, 360)
    main.Position = UDim2.new(0.5, -170, 0.12, 0)
    main.AnchorPoint = Vector2.new(0.5, 0)
    main.BackgroundColor3 = BG
    main.BackgroundTransparency = PANEL_ALPHA
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = screenGui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)
    local mainStroke = Instance.new("UIStroke", main); mainStroke.Thickness = 1; mainStroke.Transparency = 0.75; mainStroke.Color = Color3.fromRGB(8,8,8)

    -- header
    local header = Instance.new("Frame", main)
    header.Name = "Header"
    header.Size = UDim2.new(1, -16, 0, 40)
    header.Position = UDim2.new(0, 8, 0, 6)
    header.BackgroundTransparency = 1

    local title = Instance.new("TextLabel", header)
    title.Name = "Title"
    title.Size = UDim2.new(1, -90, 1, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.Text = "   MeuHub — Animations (GTA)"
    title.TextColor3 = Color3.fromRGB(230,230,230)
    title.TextXAlignment = Enum.TextXAlignment.Left

    local hint = Instance.new("TextLabel", header)
    hint.Name = "Hint"
    hint.Size = UDim2.new(1, -90, 0, 14)
    hint.Position = UDim2.new(0,0,0,22)
    hint.BackgroundTransparency = 1
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 11
    hint.TextColor3 = Color3.fromRGB(160,160,160)
    hint.Text = "Clique / teclas 1-5 — 1 animação por vez"

    local minBtn = Instance.new("TextButton", header)
    minBtn.Name = "Minimize"
    minBtn.Size = UDim2.new(0, 64, 0, 28)
    minBtn.Position = UDim2.new(1, -70, 0, 6)
    minBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    minBtn.Text = "—"
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 18
    minBtn.TextColor3 = Color3.fromRGB(220,220,220)
    minBtn.AutoButtonColor = true
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", minBtn).Thickness = 1; Instance.new("UIStroke", minBtn).Transparency = 0.8

    -- content
    local content = Instance.new("Frame", main)
    content.Name = "Content"
    content.Size = UDim2.new(1, -16, 1, -110)
    content.Position = UDim2.new(0, 8, 0, 48)
    content.BackgroundTransparency = 1
    local padding = Instance.new("UIPadding", content)
    padding.PaddingLeft = UDim.new(0,8); padding.PaddingRight = UDim.new(0,8); padding.PaddingTop = UDim.new(0,6); padding.PaddingBottom = UDim.new(0,6)
    local layout = Instance.new("UIListLayout", content)
    layout.SortOrder = Enum.SortOrder.LayoutOrder; layout.Padding = UDim.new(0,8)

    -- buttons container
    local buttons = {}
    for i, key in ipairs(BUTTON_ORDER) do
        local btn = Instance.new("TextButton")
        btn.Name = key .. "Button"
        btn.Size = UDim2.new(1, 0, 0, 42)
        btn.BackgroundColor3 = Color3.fromRGB(34,34,34)
        btn.BorderSizePixel = 0
        btn.AutoButtonColor = false
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(230,230,230)
        btn.Text = string.format("%d • %s", i, key)
        btn.LayoutOrder = i
        btn.Parent = content
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
        local stroke = Instance.new("UIStroke", btn); stroke.Thickness = 1; stroke.Transparency = 0.85

        local accent = Instance.new("Frame", btn)
        accent.Name = "Accent"
        accent.Size = UDim2.new(0,8,1,-12)
        accent.Position = UDim2.new(0,8,0,6)
        accent.BackgroundColor3 = Color3.fromRGB(18,18,18)
        Instance.new("UICorner", accent).CornerRadius = UDim.new(0,6)

        local onLabel = Instance.new("TextLabel", btn)
        onLabel.Name = "OnLabel"
        onLabel.Size = UDim2.new(0.32, -8, 1, 0)
        onLabel.Position = UDim2.new(0.68, -6, 0, 0)
        onLabel.BackgroundTransparency = 1
        onLabel.Font = Enum.Font.GothamBold
        onLabel.TextSize = 12
        onLabel.TextColor3 = ACCENT
        onLabel.TextXAlignment = Enum.TextXAlignment.Right
        onLabel.Text = ""

        buttons[key] = btn
    end

    -- stop all
    local stopBtn = Instance.new("TextButton", main)
    stopBtn.Name = "StopAll"
    stopBtn.Size = UDim2.new(1, -16, 0, 44)
    stopBtn.Position = UDim2.new(0, 8, 1, -56)
    stopBtn.BackgroundColor3 = Color3.fromRGB(190,45,45)
    stopBtn.Font = Enum.Font.GothamBold
    stopBtn.TextSize = 14
    stopBtn.TextColor3 = Color3.fromRGB(255,255,255)
    stopBtn.Text = " Stop All"
    Instance.new("UICorner", stopBtn).CornerRadius = UDim.new(0,8)
    Instance.new("UIStroke", stopBtn).Thickness = 1

    finalizeGui(screenGui, main)
    return screenGui, main, buttons, stopBtn, minBtn, content
end

local function ensureMeuHub()
    local candidates = {}
    if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then table.insert(candidates, LocalPlayer.PlayerGui) end
    if type(gethui) == "function" then local ok,g = pcall(gethui); if ok and g then table.insert(candidates,g) end end
    if type(get_hidden_gui) == "function" then local ok,g = pcall(get_hidden_gui); if ok and g then table.insert(candidates,g) end end
    table.insert(candidates, game:GetService("CoreGui"))

    for _, parent in ipairs(candidates) do
        local found = parent:FindFirstChild("MeuHub")
        if found and found:IsA("ScreenGui") then
            found.ResetOnSpawn = false
            found.DisplayOrder = 9999
            found.ZIndexBehavior = Enum.ZIndexBehavior.Global
            local f = found:FindFirstChildOfClass("Frame") or found:FindFirstChild("Main") or found:FindFirstChild("MainFrame")
            if f then f.AnchorPoint = Vector2.new(0.5,0); f.Position = UDim2.new(0.5,0,0.12,0) end
            protectGui(found)
            local mainFrame = f
            local buttonsMap = {}
            if mainFrame then
                local content = mainFrame:FindFirstChild("Content")
                if content then
                    for _, key in ipairs(BUTTON_ORDER) do
                        local b = content:FindFirstChild(key .. "Button")
                        if b then buttonsMap[key] = b end
                    end
                end
            end
            local stopBtn = mainFrame and mainFrame:FindFirstChild("StopAll")
            local minBtn = mainFrame and mainFrame:FindFirstChild("Minimize")
            local content = mainFrame and mainFrame:FindFirstChild("Content")
            return found, mainFrame, buttonsMap, stopBtn, minBtn, content
        end
    end

    local parent = resolveInitialParent()
    local ok, s, m, btbl, stop, minb, content = pcall(createMeuHub, parent)
    if ok then return s, m, btbl, stop, minb, content end

    -- fallback minimal
    local core = game:GetService("CoreGui")
    local fallback = Instance.new("ScreenGui", core); fallback.Name = "MeuHub"
    local fMain = Instance.new("Frame", fallback); fMain.Size = UDim2.new(0,300,0,140); fMain.Position = UDim2.new(0.5,-150,0.12,0); Instance.new("UICorner", fMain).CornerRadius = UDim.new(0,8)
    finalizeGui(fallback, fMain)
    return fallback, fMain, {}, nil, nil, nil
end

local screenGui, mainFrame, buttons, stopBtn, minBtn, contentFrame = ensureMeuHub()

-- move to PlayerGui if available (tries a while)
spawn(function()
    for i = 1, 60 do
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and screenGui and screenGui.Parent ~= LocalPlayer.PlayerGui then
            pcall(function() screenGui.Parent = LocalPlayer.PlayerGui end)
            finalizeGui(screenGui, mainFrame)
        end
        task.wait(0.08)
    end
end)

-- ensure buttons exist
if not buttons then buttons = {} end
if contentFrame then
    for i, key in ipairs(BUTTON_ORDER) do
        if not buttons[key] or not buttons[key].Parent then
            local btn = Instance.new("TextButton")
            btn.Name = key .. "Button"
            btn.Size = UDim2.new(1, 0, 0, 42)
            btn.BackgroundColor3 = Color3.fromRGB(34,34,34)
            btn.BorderSizePixel = 0
            btn.AutoButtonColor = false
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(230,230,230)
            btn.Text = string.format("%d • %s", i, key)
            btn.LayoutOrder = i
            btn.Parent = contentFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
            local accent = Instance.new("Frame", btn); accent.Name = "Accent"; accent.Size = UDim2.new(0,8,1,-12); accent.Position = UDim2.new(0,8,0,6); accent.BackgroundColor3 = Color3.fromRGB(18,18,18); Instance.new("UICorner", accent).CornerRadius = UDim.new(0,6)
            local onLabel = Instance.new("TextLabel", btn); onLabel.Name = "OnLabel"; onLabel.Size = UDim2.new(0.32, -8, 1, 0); onLabel.Position = UDim2.new(0.68, -6, 0, 0); onLabel.BackgroundTransparency = 1; onLabel.Font = Enum.Font.GothamBold; onLabel.TextSize = 12; onLabel.TextColor3 = ACCENT; onLabel.TextXAlignment = Enum.TextXAlignment.Right; onLabel.Text = ""
            buttons[key] = btn
        end
    end
end

-- ===== Animation Manager (same robust impl) =====
local AnimationManager = {}
AnimationManager.__index = AnimationManager

function AnimationManager.new()
    local self = setmetatable({}, AnimationManager)
    self.humanoid = nil
    self.animator = nil
    self.animations = {}
    for k,v in pairs(ANIM_IDS) do self.animations[k] = { id = v, Animation = nil, Track = nil, playing = false, debounce = false } end
    return self
end

function AnimationManager:bind(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    self:destroy()
    self.humanoid = humanoid
    self.animator = humanoid:FindFirstChildOfClass("Animator")
    if not self.animator then
        local ok,a = pcall(function() local new = Instance.new("Animator"); new.Parent = humanoid; return new end)
        if ok then self.animator = a end
    end
    for key,info in pairs(self.animations) do
        if not info.Animation or not info.Animation.Parent then
            local animObj = Instance.new("Animation")
            animObj.Name = key .. "_Animation"
            animObj.AnimationId = "rbxassetid://" .. tostring(info.id)
            animObj.Parent = self.animator
            info.Animation = animObj
        end
        info.Track = nil
        info.playing = false
        info.debounce = false
    end
end

function AnimationManager:_ensureTrack(key)
    local info = self.animations[key]
    if not info or not self.animator then return false end
    if not info.Track then
        local ok, track = pcall(function() return self.animator:LoadAnimation(info.Animation) end)
        if ok and track then track.Looped = true; info.Track = track; return true else warn("Falha ao carregar track:", key) return false end
    end
    return true
end

function AnimationManager:stopAllExcept(exceptKey)
    for k,info in pairs(self.animations) do
        if k ~= exceptKey and info.Track and info.playing then pcall(function() info.Track:Stop(0.1) end); info.playing = false end
    end
end

function AnimationManager:toggleExclusive(key)
    local info = self.animations[key]
    if not info then return end
    if info.debounce then return end
    info.debounce = true
    task.delay(0.18, function() info.debounce = false end)
    if not (self.humanoid and self.humanoid.Parent and self.animator and self.animator.Parent) then warn("Humanoid/Animator inválido ao tocar:", key); return end
    if not self:_ensureTrack(key) then return end
    if info.playing then pcall(function() info.Track:Stop(0.1) end); info.playing = false else self:stopAllExcept(key); local ok,err = pcall(function() info.Track:Play() end); if ok then info.playing = true else warn("Erro ao tocar:", key, err) end end
end

function AnimationManager:stopAllNow()
    for k,info in pairs(self.animations) do if info.Track and info.playing then pcall(function() info.Track:Stop(0.1) end); info.playing = false end end
end
function AnimationManager:destroy() for k,info in pairs(self.animations) do if info.Track and info.playing then pcall(function() info.Track:Stop(0.1) end) end info.Track = nil if info.Animation and info.Animation.Parent then info.Animation.Parent = nil end info.playing = false end self.humanoid = nil; self.animator = nil end

-- instantiate and bind
local manager = AnimationManager.new()
local function bindToCharacterSafe(char) if not char then return end local ok, res = pcall(function() manager:bind(char) end) if not ok then warn("Bind manager falhou:", res) end end
if LocalPlayer.Character then bindToCharacterSafe(LocalPlayer.Character) else LocalPlayer.CharacterAdded:Wait(); bindToCharacterSafe(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(function(c) task.delay(0.08, function() bindToCharacterSafe(c) end) end)

-- visuals helper
local function setButtonVisual(btn, on)
    if not btn then return end
    local acc = btn:FindFirstChild("Accent")
    local onL = btn:FindFirstChild("OnLabel")
    if on then
        pcall(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(28,40,30)}, 0.12) if acc then tween(acc, {BackgroundColor3 = ACCENT}, 0.12) end if onL then onL.Text = "ON" end end)
    else
        pcall(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(34,34,34)}, 0.12) if acc then tween(acc, {BackgroundColor3 = Color3.fromRGB(18,18,18)}, 0.12) end if onL then onL.Text = "" end end)
    end
end

-- hookup buttons
for _, key in ipairs(BUTTON_ORDER) do
    local btn = buttons and buttons[key]
    if not btn then continue end
    btn.MouseEnter:Connect(function() pcall(function() tween(btn, {BackgroundColor3 = Color3.fromRGB(44,44,44)}, 0.12) end) local acc = btn:FindFirstChild("Accent") if acc then pcall(function() tween(acc, {BackgroundColor3 = ACCENT}, 0.12) end) end end)
    btn.MouseLeave:Connect(function() local info = manager.animations[key] setButtonVisual(btn, info and info.playing) end)
    btn.MouseButton1Click:Connect(function() manager:toggleExclusive(key) for _, k2 in ipairs(BUTTON_ORDER) do setButtonVisual(buttons[k2], manager.animations[k2] and manager.animations[k2].playing) end end)
end

-- stop all hookup
if stopBtn then stopBtn.MouseButton1Click:Connect(function() manager:stopAllNow() for _, k in ipairs(BUTTON_ORDER) do setButtonVisual(buttons[k], false) end end) end

-- minimize behavior: hide/show content + stopBtn + maintain size
local isMin = false
if minBtn and contentFrame and stopBtn then
    minBtn.MouseButton1Click:Connect(function()
        isMin = not isMin
        if isMin then
            -- hide content and stopBtn
            pcall(function()
                contentFrame.Visible = false
                stopBtn.Visible = false
                -- shrink main
                tween(mainFrame or screenGui:FindFirstChildOfClass("Frame"), {Size = UDim2.new(0,340,0,60)}, 0.16)
            end)
        else
            pcall(function()
                contentFrame.Visible = true
                stopBtn.Visible = true
                tween(mainFrame or screenGui:FindFirstChildOfClass("Frame"), {Size = UDim2.new(0,340,0,360)}, 0.16)
            end)
        end
    end)
end

-- keybinds
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    for i, kc in ipairs(KEYBINDS) do if input.KeyCode == kc then local key = BUTTON_ORDER[i] if key and manager then manager:toggleExclusive(key) for _, k2 in ipairs(BUTTON_ORDER) do setButtonVisual(buttons[k2], manager.animations[k2] and manager.animations[k2].playing) end end end end
    if input.KeyCode == Enum.KeyCode.Escape then if manager then manager:stopAllNow() end for _, k in ipairs(BUTTON_ORDER) do setButtonVisual(buttons[k], false) end end
end)

-- drag implementation (robust)
local dragging = false
local dragInput, dragStart, startPos
local rootFrame = mainFrame or screenGui:FindFirstChildOfClass("Frame") or (screenGui and screenGui:FindFirstChild("Main"))
if rootFrame then
    rootFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = rootFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    rootFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging and dragStart and startPos then
            local delta = input.Position - dragStart
            rootFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- safety: attempt to move GUI to PlayerGui when available
spawn(function()
    for i = 1, 80 do
        if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") and screenGui and screenGui.Parent ~= LocalPlayer.PlayerGui then
            pcall(function() screenGui.Parent = LocalPlayer.PlayerGui end)
            finalizeGui(screenGui, mainFrame)
        end
        task.wait(0.08)
    end
end)

-- rebind if humanoid disappears
RunService.Heartbeat:Connect(function()
    if not manager then return end
    if not (manager.humanoid and manager.humanoid.Parent) then local char = LocalPlayer.Character if char then task.delay(0.08, function() bindToCharacterSafe(char) end) end end
end)

print("[MeuHub - drag+minimize] Pronto. Arrasta, minimiza (esconde botões) e maximiza (mostra botões). 1..5 para ativar, ESC para parar.")
