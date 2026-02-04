local Players = game:GetService("Players") 
local RunService = game:GetService("RunService") 
local UserInputService = game:GetService("UserInputService") 
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer 
local Camera = workspace.CurrentCamera 
local IsMobile = UserInputService.TouchEnabled 

-- ========================================== 
-- CONFIGURAÇÕES (GLOBAL SETTINGS)
-- ========================================== 
local Settings = { 
    -- COMBAT
    AimbotEnabled = false, 
    SilentAim = false, -- Mira trava instantaneamente
    TriggerBot = false, -- Atira sozinho quando a mira passa
    WallCheck = false, 
    TeamCheck = false, 
    TargetMode = "Head", 
    FOVRadius = 135, 
    ShowFOV = false,
    Smoothness = 0.5, 

    -- ESP
    ESPEnabled = false, 
    ESPBox = false, 
    ESPSkeleton = false, -- Esqueleto do corpo
    ESPLine = false, 
    ESPName = false, 
    ESPDist = false, 
    ESPTool = false, -- Mostra a arma na mão
    ESPView = false, -- Mostra linha para onde o inimigo olha
    ESPColor = Color3.fromRGB(255, 0, 0), 
    FriendColor = Color3.fromRGB(0, 255, 0), 

    -- MISC
    InfJump = false,
    TPWalk = false,
    TPSpeed = 1, -- Multiplicador de velocidade
    TPBehind = false, -- Tecla T para teleportar (PC) ou Botão (Mobile)

    -- SYSTEM
    MenuOpen = true,
    Friends = {gtasa244adm17} 
} 

local Colors = { 
    Black = Color3.fromRGB(10, 10, 10), 
    Dark = Color3.fromRGB(18, 18, 18), 
    Red = Color3.fromRGB(220, 0, 0), 
    Green = Color3.fromRGB(0, 220, 0),
    White = Color3.fromRGB(255, 255, 255), 
    Grey = Color3.fromRGB(50, 50, 50),
    DarkGrey = Color3.fromRGB(35, 35, 35)
} 

-- ========================================== 
-- UTILITÁRIOS GRÁFICOS
-- ========================================== 
local function CreateStroke(parent, color, thickness) 
    local stroke = Instance.new("UIStroke", parent) 
    stroke.Color = color; stroke.Thickness = thickness; stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 
    return stroke 
end 

local function CreateCorner(parent, radius) 
    local corner = Instance.new("UICorner", parent); corner.CornerRadius = UDim.new(0, radius) 
    return corner 
end 

-- ========================================== 
-- INTERFACE (UI)
-- ========================================== 
function LoadMainScript() 
    if LocalPlayer.PlayerGui:FindFirstChild("GGMenu_Ultimate") then LocalPlayer.PlayerGui.GGMenu_Ultimate:Destroy() end

    local ScreenGui = Instance.new("ScreenGui") 
    ScreenGui.Name = "GGMenu_Ultimate" 
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    ScreenGui.ResetOnSpawn = false 

    -- Botão Flutuante
    local ToggleBtn = Instance.new("TextButton", ScreenGui) 
    ToggleBtn.BackgroundColor3 = Colors.Black 
    ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0) 
    ToggleBtn.Size = UDim2.new(0, 50, 0, 50) 
    ToggleBtn.Text = "GG" 
    ToggleBtn.TextColor3 = Colors.Red
    ToggleBtn.Font = Enum.Font.GothamBlack
    ToggleBtn.TextSize = 18
    CreateCorner(ToggleBtn, 16); CreateStroke(ToggleBtn, Colors.Red, 2) 

    -- Janela Principal
    local MainFrame = Instance.new("Frame", ScreenGui) 
    MainFrame.BackgroundColor3 = Colors.Black 
    MainFrame.Size = IsMobile and UDim2.new(0, 360, 0, 320) or UDim2.new(0, 420, 0, 350) 
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5) 
    MainFrame.Visible = true
    CreateStroke(MainFrame, Colors.Red, 2); CreateCorner(MainFrame, 8)

    -- Cabeçalho
    local Header = Instance.new("Frame", MainFrame); Header.BackgroundColor3 = Colors.Red; Header.Size = UDim2.new(1,0,0,35); CreateCorner(Header, 8)
    local HFix = Instance.new("Frame", Header); HFix.BackgroundColor3 = Colors.Red; HFix.BorderSizePixel=0; HFix.Size=UDim2.new(1,0,0.2,0); HFix.Position=UDim2.new(0,0,0.8,0)
    
    local HTxt = Instance.new("TextLabel", Header); HTxt.BackgroundTransparency=1; HTxt.Size=UDim2.new(1,-40,1,0); HTxt.Position=UDim2.new(0,10,0,0); 
    HTxt.Text="GG XITER - ULTIMATE"; HTxt.TextColor3=Colors.White; HTxt.Font=Enum.Font.GothamBlack; HTxt.TextSize=16; HTxt.TextXAlignment=Enum.TextXAlignment.Left 
    
    local Close = Instance.new("TextButton", Header); Close.BackgroundTransparency=1; Close.Position=UDim2.new(1,-40,0,0); Close.Size=UDim2.new(0,40,0,35); 
    Close.Text="X"; Close.TextColor3=Colors.White; Close.Font=Enum.Font.GothamBold; Close.TextSize=18 

    -- Arrastar Janela
    local dragging, dragInput, dragStart, startPos 
    Header.InputBegan:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end 
    end) 
    Header.InputChanged:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end 
    end) 
    UserInputService.InputChanged:Connect(function(input) 
        if input == dragInput and dragging then 
            local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end) 
    Header.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end) 
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    Close.MouseButton1Click:Connect(function() MainFrame.Visible = false end) 

    -- Abas
    local TabCont = Instance.new("Frame", MainFrame); TabCont.BackgroundColor3 = Colors.Dark; TabCont.Position=UDim2.new(0,0,0,35); TabCont.Size=UDim2.new(1,0,0,30) 
    local function NewTab(text, order) 
        local w = 0.25
        local B = Instance.new("TextButton", TabCont); B.BackgroundTransparency=1; B.Size=UDim2.new(w,0,1,0); B.Position=UDim2.new((order-1)*w,0,0,0); 
        B.Text=text; B.TextColor3=Colors.White; B.Font=Enum.Font.GothamBold; B.TextSize=10 
        local L = Instance.new("Frame", B); L.BackgroundColor3=Colors.Red; L.Size=UDim2.new(1,0,0.1,0); L.Position=UDim2.new(0,0,0.9,0); L.Visible=false 
        return B, L 
    end 
    local T1, L1 = NewTab("COMBAT", 1); local T2, L2 = NewTab("ESP", 2); local T3, L3 = NewTab("MISC", 3); local T4, L4 = NewTab("PLAYERS", 4)
    L1.Visible = true 

    -- Páginas
    local PageHold = Instance.new("Frame", MainFrame); PageHold.BackgroundTransparency=1; PageHold.Position=UDim2.new(0,0,0,70); PageHold.Size=UDim2.new(1,0,1,-70) 
    local P1, P2, P3, P4 = Instance.new("ScrollingFrame", PageHold), Instance.new("ScrollingFrame", PageHold), Instance.new("ScrollingFrame", PageHold), Instance.new("ScrollingFrame", PageHold)
    local Pages = {P1, P2, P3, P4}
    for i, p in pairs(Pages) do 
        p.BackgroundTransparency=1; p.Size=UDim2.new(1,0,1,0); p.ScrollBarThickness=2; p.Visible=(i==1) 
        local l=Instance.new("UIListLayout", p); l.Padding=UDim.new(0,6); l.HorizontalAlignment=Enum.HorizontalAlignment.Center; l.SortOrder=Enum.SortOrder.LayoutOrder 
        local pd=Instance.new("UIPadding", p); pd.PaddingTop=UDim.new(0,5)
    end 

    local function Switch(idx) 
        for i,v in pairs(Pages) do v.Visible=(i==idx) end; L1.Visible=(idx==1); L2.Visible=(idx==2); L3.Visible=(idx==3); L4.Visible=(idx==4) 
    end 
    T1.MouseButton1Click:Connect(function() Switch(1) end); T2.MouseButton1Click:Connect(function() Switch(2) end)
    T3.MouseButton1Click:Connect(function() Switch(3) end); T4.MouseButton1Click:Connect(function() Switch(4) end)

    -- Componentes
    local function Toggle(p, t, cb) 
        local f=Instance.new("Frame",p); f.BackgroundColor3=Colors.Dark; f.Size=UDim2.new(0.9,0,0,35); CreateCorner(f,6) 
        local l=Instance.new("TextLabel",f); l.BackgroundTransparency=1; l.Position=UDim2.new(0,10,0,0); l.Size=UDim2.new(0.7,0,1,0); 
        l.Text=t; l.TextColor3=Colors.White; l.Font=Enum.Font.GothamSemibold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left 
        local b=Instance.new("TextButton",f); b.BackgroundColor3=Colors.Grey; b.Position=UDim2.new(0.85,-5,0.5,-10); b.Size=UDim2.new(0,20,0,20); 
        b.Text=""; CreateCorner(b,4) 
        local on = false
        b.MouseButton1Click:Connect(function() on=not on; b.BackgroundColor3=on and Colors.Red or Colors.Grey; cb(on) end) 
    end 

    local function Slider(p, t, min, max, def, cb)
        local f=Instance.new("Frame",p); f.BackgroundColor3=Colors.Dark; f.Size=UDim2.new(0.9,0,0,45); CreateCorner(f,6)
        local l=Instance.new("TextLabel",f); l.BackgroundTransparency=1; l.Position=UDim2.new(0,10,0,5); l.Size=UDim2.new(1,0,0,15); 
        l.Text=t; l.TextColor3=Colors.White; l.Font=Enum.Font.GothamSemibold; l.TextSize=11; l.TextXAlignment=Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", f); box.BackgroundColor3 = Colors.DarkGrey; box.Position = UDim2.new(0.75, 0, 0.1, 0); box.Size = UDim2.new(0.2, 0, 0.4, 0)
        box.Text = tostring(def); box.TextColor3 = Colors.White; CreateCorner(box,4)
        box.FocusLost:Connect(function() 
            local n = tonumber(box.Text); if n then cb(math.clamp(n, min, max)) end 
        end)
    end

    -- === ABA 1: COMBAT ===
    Toggle(P1, "Ativar Aimbot", function(v) Settings.AimbotEnabled = v end)
    Toggle(P1, "Silent Aim (Mira Travada)", function(v) Settings.SilentAim = v end)
    Toggle(P1, "TriggerBot (Auto Fire)", function(v) Settings.TriggerBot = v end)
    Toggle(P1, "WallCheck (Não mira parede)", function(v) Settings.WallCheck = v end)
    Toggle(P1, "TeamCheck (Ignora Time)", function(v) Settings.TeamCheck = v end)
    Toggle(P1, "Mostrar FOV", function(v) Settings.ShowFOV = v end)
    Slider(P1, "Raio FOV", 20, 800, 100, function(v) Settings.FOVRadius = v end)
    Slider(P1, "Suavidade (1=Rápido)", 1, 10, 5, function(v) Settings.Smoothness = v/10 end)

    -- === ABA 2: ESP ===
    Toggle(P2, "Ativar ESP (Master)", function(v) Settings.ESPEnabled = v end)
    Toggle(P2, "Box (Caixa 2D)", function(v) Settings.ESPBox = v end)
    Toggle(P2, "Skeleton (Esqueleto)", function(v) Settings.ESPSkeleton = v end)
    Toggle(P2, "Tracers (Linhas)", function(v) Settings.ESPLine = v end)
    Toggle(P2, "View Tracers (Olhar)", function(v) Settings.ESPView = v end)
    Toggle(P2, "Nomes", function(v) Settings.ESPName = v end)
    Toggle(P2, "Arma na Mão", function(v) Settings.ESPTool = v end)

    -- === ABA 3: MISC ===
    Toggle(P3, "Pulo Infinito (InfJump)", function(v) Settings.InfJump = v end)
    Toggle(P3, "Speed Hack (TP Walk)", function(v) Settings.TPWalk = v end)
    Slider(P3, "Velocidade TP", 1, 5, 1, function(v) Settings.TPSpeed = v end)
    
    local TPBtn = Instance.new("TextButton", P3); TPBtn.BackgroundColor3 = Colors.Dark; TPBtn.Size=UDim2.new(0.9,0,0,35); 
    TPBtn.Text = "TP Atrás do Inimigo (Perto)"; TPBtn.TextColor3 = Colors.Red; CreateCorner(TPBtn,6)
    TPBtn.MouseButton1Click:Connect(function() Settings.TPBehind = true; wait(0.1); Settings.TPBehind = false end)

    -- === ABA 4: PLAYERS ===
    local RefBtn = Instance.new("TextButton", P4); RefBtn.BackgroundColor3 = Colors.Red; RefBtn.Size=UDim2.new(0.9,0,0,30); RefBtn.Text="Atualizar Lista"; RefBtn.TextColor3=Colors.White; CreateCorner(RefBtn,6)
    local PlrList = Instance.new("Frame", P4); PlrList.BackgroundTransparency=1; PlrList.Size=UDim2.new(1,0,1,-40); 
    local PlrLayout = Instance.new("UIListLayout", PlrList); PlrLayout.Padding = UDim.new(0,5); PlrLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function RefreshPlayers()
        for _,v in pairs(PlrList:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local f = Instance.new("Frame", PlrList); f.BackgroundColor3=Colors.Dark; f.Size=UDim2.new(0.9,0,0,35); CreateCorner(f,6)
                local t = Instance.new("TextLabel", f); t.BackgroundTransparency=1; t.Text=p.Name; t.TextColor3=Colors.White; t.Size=UDim2.new(0.6,0,1,0); t.Position=UDim2.new(0,10,0,0); t.TextXAlignment=Enum.TextXAlignment.Left
                local b = Instance.new("TextButton", f); b.Size=UDim2.new(0.3,0,0.8,0); b.Position=UDim2.new(0.65,0,0.1,0); CreateCorner(b,4)
                local function Upd() b.Text = Settings.Friends[p.Name] and "AMIGO" or "INIMIGO"; b.BackgroundColor3 = Settings.Friends[p.Name] and Colors.Green or Colors.Grey end
                Upd(); b.MouseButton1Click:Connect(function() Settings.Friends[p.Name] = not Settings.Friends[p.Name]; Upd() end)
            end
        end
    end
    RefBtn.MouseButton1Click:Connect(RefreshPlayers)
    RefreshPlayers()
end

-- ========================================== 
-- LÓGICA DO SCRIPT (ENGINE)
-- ========================================== 
local DrawingLib = {} -- Simples wrapper se Drawing existir
local Skeletons = {}
local Tracers = {}
local ViewTracers = {}
local Texts = {}

-- Setup Drawing API safe check
local function NewLine() local l=Drawing.new("Line"); l.Visible=false; l.Thickness=1; return l end
local function NewText() local t=Drawing.new("Text"); t.Visible=false; t.Size=14; t.Center=true; t.Outline=true; return t end
local function NewCircle() local c=Drawing.new("Circle"); c.Visible=false; c.Thickness=1.5; c.NumSides=32; c.Filled=false; return c end

local FOVCircle = nil
pcall(function() FOVCircle = NewCircle() end)

-- Limpeza
local function ClearESP(plr)
    if Skeletons[plr] then for _,l in pairs(Skeletons[plr]) do l:Remove() end; Skeletons[plr]=nil end
    if Tracers[plr] then Tracers[plr]:Remove(); Tracers[plr]=nil end
    if ViewTracers[plr] then ViewTracers[plr]:Remove(); ViewTracers[plr]=nil end
    if Texts[plr] then Texts[plr]:Remove(); Texts[plr]=nil end
    if plr.Character and plr.Character:FindFirstChild("GG_Highlight") then plr.Character.GG_Highlight:Destroy() end
end
Players.PlayerRemoving:Connect(ClearESP)

-- Funções Auxiliares
local function IsVisible(target)
    if not Settings.WallCheck then return true end
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    local res = workspace:Raycast(Camera.CFrame.Position, target.Position - Camera.CFrame.Position, params)
    return (not res) or res.Instance:IsDescendantOf(target.Parent)
end

local function GetTarget()
    local best, minDist = nil, Settings.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
            if Settings.Friends[v.Name] then continue end -- Ignora amigos
            
            local part = v.Character:FindFirstChild(Settings.TargetMode) or v.Character:FindFirstChild("Head")
            if part then
                local pos, vis = Camera:WorldToViewportPoint(part.Position)
                if vis then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist < minDist and IsVisible(part) then
                        minDist = dist; best = part
                    end
                end
            end
        end
    end
    return best
end

-- Render Loop
RunService.RenderStepped:Connect(function()
    -- FOV
    if FOVCircle then 
        FOVCircle.Visible = Settings.ShowFOV; FOVCircle.Radius = Settings.FOVRadius
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2); FOVCircle.Color = Settings.ESPColor 
    end

    -- AIMBOT & TRIGGER
    local target = GetTarget()
    if target and Settings.AimbotEnabled then
        local pos = target.Position
        if Settings.SilentAim then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, pos) -- Trava bruta
        else
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, pos), Settings.Smoothness) -- Suave
        end
        
        -- TriggerBot
        if Settings.TriggerBot then
            local mouse = LocalPlayer:GetMouse()
            if mouse.Target and mouse.Target:IsDescendantOf(target.Parent) then
                VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,1)
                VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,1)
            end
        end

        -- TP Behind (Instantâneo se solicitado)
        if Settings.TPBehind and target.Parent then
             local root = target.Parent:FindFirstChild("HumanoidRootPart")
             if root and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                 LocalPlayer.Character.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0,0,3)
                 Settings.TPBehind = false -- Reseta o switch
             end
        end
    end

    -- TP Walk (Velocidade)
    if Settings.TPWalk and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.MoveDirection.Magnitude > 0 then
            root.CFrame = root.CFrame + (hum.MoveDirection * Settings.TPSpeed)
        end
    end

    -- ESP LOOP
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer then
            local char = v.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Head") and Settings.ESPEnabled then
                local root = char.HumanoidRootPart; local head = char.Head
                local color = Settings.Friends[v.Name] and Settings.FriendColor or Settings.ESPColor
                local pos, vis = Camera:WorldToViewportPoint(root.Position)
                
                -- Highlight/Box
                local hl = char:FindFirstChild("GG_Highlight")
                if Settings.ESPBox then
                    if not hl then hl = Instance.new("Highlight", char); hl.Name="GG_Highlight"; hl.FillTransparency=1 end
                    hl.OutlineColor = color; hl.Enabled = true
                elseif hl then hl.Enabled = false end

                if Drawing then -- Funções que exigem Drawing API
                    -- Linha (Tracer)
                    if not Tracers[v] then Tracers[v] = NewLine() end
                    if Settings.ESPLine and vis then
                        Tracers[v].Visible = true; Tracers[v].Color = color
                        Tracers[v].From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        Tracers[v].To = Vector2.new(pos.X, pos.Y)
                    else Tracers[v].Visible = false end

                    -- Texto (Nome/Dist/Arma)
                    if not Texts[v] then Texts[v] = NewText() end
                    if (Settings.ESPName or Settings.ESPDist or Settings.ESPTool) and vis then
                        local headP = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,1,0))
                        Texts[v].Visible = true; Texts[v].Color = color; Texts[v].Position = Vector2.new(headP.X, headP.Y)
                        local txt = ""
                        if Settings.ESPName then txt = v.Name end
                        if Settings.ESPDist then txt = txt.."\n["..math.floor((root.Position - Camera.CFrame.Position).Magnitude).."m]" end
                        if Settings.ESPTool then
                            local tool = char:FindFirstChildOfClass("Tool")
                            if tool then txt = txt.."\n["..tool.Name.."]" end
                        end
                        Texts[v].Text = txt
                    else Texts[v].Visible = false end

                    -- View Tracer (Olhar)
                    if not ViewTracers[v] then ViewTracers[v] = NewLine() end
                    if Settings.ESPView and vis then
                        local look = head.CFrame.LookVector * 10
                        local endPos = Camera:WorldToViewportPoint(head.Position + look)
                        local startPos = Camera:WorldToViewportPoint(head.Position)
                        ViewTracers[v].Visible = true; ViewTracers[v].Color = Color3.new(1,1,1)
                        ViewTracers[v].From = Vector2.new(startPos.X, startPos.Y)
                        ViewTracers[v].To = Vector2.new(endPos.X, endPos.Y)
                    else ViewTracers[v].Visible = false end

                    -- Skeleton (Simplificado para R15/R6)
                    if not Skeletons[v] then Skeletons[v] = {} end
                    if Settings.ESPSkeleton and vis then
                        local function Line(p1, p2)
                            local key = p1.Name..p2.Name
                            if not Skeletons[v][key] then Skeletons[v][key] = NewLine() end
                            local l = Skeletons[v][key]
                            local v1, vis1 = Camera:WorldToViewportPoint(p1.Position)
                            local v2, vis2 = Camera:WorldToViewportPoint(p2.Position)
                            if vis1 and vis2 then
                                l.Visible = true; l.Color = color; l.From = Vector2.new(v1.X, v1.Y); l.To = Vector2.new(v2.X, v2.Y)
                            else l.Visible = false end
                        end
                        -- Tenta desenhar conexões comuns
                        if char:FindFirstChild("UpperTorso") then -- R15
                            Line(char.Head, char.UpperTorso)
                            Line(char.UpperTorso, char.LowerTorso)
                            if char:FindFirstChild("LeftUpperArm") then Line(char.UpperTorso, char.LeftUpperArm) end
                            if char:FindFirstChild("RightUpperArm") then Line(char.UpperTorso, char.RightUpperArm) end
                        elseif char:FindFirstChild("Torso") then -- R6
                            Line(char.Head, char.Torso)
                            if char:FindFirstChild("Left Arm") then Line(char.Torso, char["Left Arm"]) end
                            if char:FindFirstChild("Right Arm") then Line(char.Torso, char["Right Arm"]) end
                            if char:FindFirstChild("Left Leg") then Line(char.Torso, char["Left Leg"]) end
                            if char:FindFirstChild("Right Leg") then Line(char.Torso, char["Right Leg"]) end
                        end
                    else
                        for _,l in pairs(Skeletons[v]) do l.Visible=false end
                    end
                end
            else
                ClearESP(v)
            end
        end
    end
end)

-- Inf Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.InfJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

LoadMainScript()
