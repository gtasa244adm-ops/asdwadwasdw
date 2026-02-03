--[[
    SCRIPT: Uriel xiter Universal
    VERSÃƒO: Final (Otimizada)
    KEY: URIEL-XITER-OFICIAL
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local IsMobile = UserInputService.TouchEnabled

-- ConfiguraÃ§Ãµes Globais
local Settings = {
    AimbotEnabled = false,
    WallCheck = false,
    TeamCheck = false,
    TargetMode = "Head",
    ShowFOV = false,
    FOVRadius = 100,
    Smoothness = 0.5,
    ESPEnabled = false,
    ESPBox = false,
    ESPLine = false,
    ESPName = false,
    ESPDist = false,
    ESPColor = Color3.fromRGB(255, 0, 0),
    MenuOpen = true
}


local RealKey = "GG_Elite"

-- Cores
local Colors = {
    Black = Color3.fromRGB(10, 10, 10),
    Dark = Color3.fromRGB(18, 18, 18),
    Red = Color3.fromRGB(220, 0, 0),
    White = Color3.fromRGB(255, 255, 255),
    Grey = Color3.fromRGB(50, 50, 50)
}

-- ==========================================
-- 1. FUNÃ‡Ã•ES AUXILIARES
-- ==========================================

local function IsVisible(targetPart)
    if not Settings.WallCheck then return true end
    local Origin = Camera.CFrame.Position
    local Direction = targetPart.Position - Origin
    local RayParams = RaycastParams.new()
    RayParams.FilterType = Enum.RaycastFilterType.Exclude
    RayParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    RayParams.IgnoreWater = true
    local Result = workspace:Raycast(Origin, Direction, RayParams)
    if Result and Result.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false 
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke", parent)
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return stroke
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner", parent)
    corner.CornerRadius = UDim.new(0, radius)
    return corner
end

-- ==========================================
-- 2. KEY SYSTEM
-- ==========================================
local KeyGui = Instance.new("ScreenGui")
KeyGui.Name = "elit script ggKeySystem"
KeyGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
KeyGui.ResetOnSpawn = false
KeyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function LoadKeySystem()
    local Blur = Instance.new("BlurEffect", Camera); Blur.Size = 20
    local MainBox = Instance.new("Frame", KeyGui)
    MainBox.Size = UDim2.new(0, 320, 0, 220)
    MainBox.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainBox.AnchorPoint = Vector2.new(0.5, 0.5)
    MainBox.BackgroundColor3 = Colors.Black
    CreateCorner(MainBox, 10); CreateStroke(MainBox, Colors.Red, 2)

    local Title = Instance.new("TextLabel", MainBox)
    Title.Size = UDim2.new(1, 0, 0.25, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "elit script gg XITER | KEY"
    Title.Font = Enum.Font.GothamBlack
    Title.TextColor3 = Colors.Red
    Title.TextSize = 20

    local KeyInput = Instance.new("TextBox", MainBox)
    KeyInput.Size = UDim2.new(0.8, 0, 0.2, 0)
    KeyInput.Position = UDim2.new(0.1, 0, 0.35, 0)
    KeyInput.BackgroundColor3 = Colors.Dark
    KeyInput.TextColor3 = Colors.White
    KeyInput.PlaceholderText = "Cole a Key aqui..."
    KeyInput.Text = ""
    CreateCorner(KeyInput, 6)

    local VerifyBtn = Instance.new("TextButton", MainBox)
    VerifyBtn.Size = UDim2.new(0.35, 0, 0.15, 0)
    VerifyBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
    VerifyBtn.BackgroundColor3 = Colors.Red
    VerifyBtn.Text = "ENTRAR"
    VerifyBtn.TextColor3 = Colors.White
    VerifyBtn.Font = Enum.Font.GothamBold
    CreateCorner(VerifyBtn, 6)

    local DiscordBtn = Instance.new("TextButton", MainBox)
    DiscordBtn.Size = UDim2.new(0.35, 0, 0.15, 0)
    DiscordBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.Text = "Discord"
    DiscordBtn.TextColor3 = Colors.White
    DiscordBtn.Font = Enum.Font.GothamBold
    CreateCorner(DiscordBtn, 6)

    local Status = Instance.new("TextLabel", MainBox)
    Status.Size = UDim2.new(1, 0, 0.15, 0)
    Status.Position = UDim2.new(0, 0, 0.85, 0)
    Status.BackgroundTransparency = 1
    Status.Text = ""
    Status.Font = Enum.Font.Gotham
    Status.TextColor3 = Colors.White
    Status.TextSize = 12

    DiscordBtn.MouseButton1Click:Connect(function() setclipboard(DiscordLink); Status.Text = "Link copiado!" end)
    VerifyBtn.MouseButton1Click:Connect(function()
        if KeyInput.Text:gsub(" ", "") == RealKey then
            Status.TextColor3 = Color3.new(0,1,0); Status.Text = "Sucesso!"; task.wait(1)
            KeyGui:Destroy(); Blur:Destroy(); LoadMainScript()
        else
            Status.TextColor3 = Colors.Red; Status.Text = "Key Incorreta!"
        end
    end)
end

-- ==========================================
-- 3. MAIN SCRIPT
-- ==========================================
function LoadMainScript()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "elit script gg"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false

    local ToggleBtn = Instance.new("TextButton", ScreenGui)
    ToggleBtn.BackgroundColor3 = Colors.Black; ToggleBtn.Position = UDim2.new(0.02, 0, 0.4, 0); ToggleBtn.Size = UDim2.new(0, 110, 0, 45); ToggleBtn.Text = ""
    CreateCorner(ToggleBtn, 50); CreateStroke(ToggleBtn, Colors.Red, 2)
    local L1 = Instance.new("TextLabel", ToggleBtn); L1.BackgroundTransparency=1; L1.Position=UDim2.new(0.1,0,0,0); L1.Size=UDim2.new(0.4,0,1,0); L1.Text="URIEL"; L1.TextColor3=Colors.White; L1.Font=Enum.Font.GothamBlack; L1.TextSize=13
    local L2 = Instance.new("TextLabel", ToggleBtn); L2.BackgroundTransparency=1; L2.Position=UDim2.new(0.5,0,0,0); L2.Size=UDim2.new(0.4,0,1,0); L2.Text="XITER"; L2.TextColor3=Colors.Red; L2.Font=Enum.Font.GothamBlack; L2.TextSize=13

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.BackgroundColor3 = Colors.Black
    MainFrame.Size = IsMobile and UDim2.new(0, 320, 0, 360) or UDim2.new(0, 360, 0, 420)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    CreateStroke(MainFrame, Colors.Red, 2)

    local Header = Instance.new("Frame", MainFrame); Header.BackgroundColor3 = Colors.Red; Header.Size = UDim2.new(1,0,0,40)
    local HTxt = Instance.new("TextLabel", Header); HTxt.BackgroundTransparency=1; HTxt.Size=UDim2.new(1,-40,1,0); HTxt.Position=UDim2.new(0,10,0,0); HTxt.Text="URIEL XITER"; HTxt.TextColor3=Colors.White; HTxt.Font=Enum.Font.GothamBlack; HTxt.TextSize=16; HTxt.TextXAlignment=Enum.TextXAlignment.Left
    local Close = Instance.new("TextButton", Header); Close.BackgroundTransparency=1; Close.Position=UDim2.new(1,-40,0,0); Close.Size=UDim2.new(0,40,0,40); Close.Text="X"; Close.TextColor3=Colors.White; Close.Font=Enum.Font.GothamBold; Close.TextSize=18

    local dragging, dragInput, dragStart, startPos
    Header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
    Header.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then local delta = input.Position - dragStart; MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
    Header.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
    Close.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

    local TabCont = Instance.new("Frame", MainFrame); TabCont.BackgroundColor3 = Colors.Dark; TabCont.Position=UDim2.new(0,0,0,40); TabCont.Size=UDim2.new(1,0,0,35)
    local function NewTab(text, order)
        local B = Instance.new("TextButton", TabCont); B.BackgroundTransparency=1; B.Size=UDim2.new(0.33,0,1,0); B.Position=UDim2.new((order-1)*0.33,0,0,0); B.Text=text; B.TextColor3=Colors.White; B.Font=Enum.Font.GothamBold; B.TextSize=12
        local L = Instance.new("Frame", B); L.BackgroundColor3=Colors.Red; L.Size=UDim2.new(1,0,0.1,0); L.Position=UDim2.new(0,0,0.9,0); L.Visible=false
        return B, L
    end
    local Tab1, Line1 = NewTab("AIMBOT", 1); local Tab2, Line2 = NewTab("ESP", 2); local Tab3, Line3 = NewTab("INFO", 3); Line1.Visible = true

    local PageHold = Instance.new("Frame", MainFrame); PageHold.BackgroundTransparency=1; PageHold.Position=UDim2.new(0,0,0,75); PageHold.Size=UDim2.new(1,0,1,-75)
    local P1 = Instance.new("ScrollingFrame", PageHold); P1.BackgroundTransparency=1; P1.Size=UDim2.new(1,0,1,0); P1.ScrollBarThickness=2
    local P2 = Instance.new("ScrollingFrame", PageHold); P2.BackgroundTransparency=1; P2.Size=UDim2.new(1,0,1,0); P2.ScrollBarThickness=2; P2.Visible=false
    local P3 = Instance.new("Frame", PageHold); P3.BackgroundTransparency=1; P3.Size=UDim2.new(1,0,1,0); P3.Visible=false

    Tab1.MouseButton1Click:Connect(function() P1.Visible=true; P2.Visible=false; P3.Visible=false; Line1.Visible=true; Line2.Visible=false; Line3.Visible=false end)
    Tab2.MouseButton1Click:Connect(function() P1.Visible=false; P2.Visible=true; P3.Visible=false; Line1.Visible=false; Line2.Visible=true; Line3.Visible=false end)
    Tab3.MouseButton1Click:Connect(function() P1.Visible=false; P2.Visible=false; P3.Visible=true; Line1.Visible=false; Line2.Visible=false; Line3.Visible=true end)
    local function AddUI(p) local l=Instance.new("UIListLayout", p); l.Padding=UDim.new(0,8); l.HorizontalAlignment=Enum.HorizontalAlignment.Center; l.SortOrder=Enum.SortOrder.LayoutOrder; local pd=Instance.new("UIPadding", p); pd.PaddingTop=UDim.new(0,10) end
    AddUI(P1); AddUI(P2)

    local function Toggle(p, t, def, cb)
        local f=Instance.new("Frame",p); f.BackgroundColor3=Colors.Dark; f.Size=UDim2.new(0.9,0,0,40); CreateCorner(f,6)
        local l=Instance.new("TextLabel",f); l.BackgroundTransparency=1; l.Position=UDim2.new(0,10,0,0); l.Size=UDim2.new(0.7,0,1,0); l.Text=t; l.TextColor3=Colors.White; l.Font=Enum.Font.GothamSemibold; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
        local b=Instance.new("TextButton",f); b.BackgroundColor3=def and Colors.Red or Colors.Grey; b.Position=UDim2.new(0.85,-5,0.5,-10); b.Size=UDim2.new(0,20,0,20); b.Text=""; CreateCorner(b,4)
        b.MouseButton1Click:Connect(function() def=not def; b.BackgroundColor3=def and Colors.Red or Colors.Grey; cb(def) end)
    end

    local function Slider(p, t, min, max, def, cb)
        local f=Instance.new("Frame",p); f.BackgroundColor3=Colors.Dark; f.Size=UDim2.new(0.9,0,0,50); CreateCorner(f,6)
        local l=Instance.new("TextLabel",f); l.BackgroundTransparency=1; l.Position=UDim2.new(0,10,0,5); l.Size=UDim2.new(1,0,0,15); l.Text=t..": "..def; l.TextColor3=Colors.White; l.Font=Enum.Font.GothamSemibold; l.TextSize=12; l.TextXAlignment=Enum.TextXAlignment.Left
        local bg=Instance.new("Frame",f); bg.BackgroundColor3=Colors.Black; bg.Position=UDim2.new(0,10,0,30); bg.Size=UDim2.new(0.9,0,0,6); CreateCorner(bg,3)
        local fil=Instance.new("Frame",bg); fil.BackgroundColor3=Colors.Red; fil.Size=UDim2.new((def-min)/(max-min),0,1,0); CreateCorner(fil,3)
        
        local btn=Instance.new("TextButton",f)
        btn.BackgroundTransparency=1
        btn.Position=UDim2.new(0,0,0,25)
        btn.Size=UDim2.new(1,0,0.5,0)
        btn.Text=""

        local dragging = false
        local function UpdateSlide(input)
            local pos = input.Position.X
            local rel = math.clamp((pos - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            fil.Size = UDim2.new(rel, 0, 1, 0)
            local val = math.floor(min + (max-min)*rel)
            l.Text = t .. ": " .. val
            cb(val)
        end

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                UpdateSlide(input)
            end
        end)
        
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateSlide(input)
            end
        end)
    end

    -- AIMBOT UI
    Toggle(P1, "Ativar Aimbot", false, function(v) Settings.AimbotEnabled = v end)
    Toggle(P1, "Wall Check (Parede)", false, function(v) Settings.WallCheck = v end)
    Toggle(P1, "Team Check", false, function(v) Settings.TeamCheck = v end)
    Toggle(P1, "Mostrar FOV", false, function(v) Settings.ShowFOV = v end)
    Slider(P1, "Raio FOV", 20, 500, 100, function(v) Settings.FOVRadius = v end)
    Slider(P1, "Velocidade Mira", 1, 10, 5, function(v) Settings.Smoothness = v/10 end)
    local MBtn = Instance.new("TextButton",P1); MBtn.BackgroundColor3=Colors.Dark; MBtn.Size=UDim2.new(0.9,0,0,35); MBtn.Text="Alvo: CABEÃ‡A"; MBtn.TextColor3=Colors.Red; MBtn.Font=Enum.Font.GothamBold; MBtn.TextSize=12; CreateCorner(MBtn,6)
    MBtn.MouseButton1Click:Connect(function() if Settings.TargetMode=="Head" then Settings.TargetMode="Torso"; MBtn.Text="Alvo: TRONCO" else Settings.TargetMode="Head"; MBtn.Text="Alvo: CABEÃ‡A" end end)

    -- ESP UI
    Toggle(P2, "Ativar ESP (Master)", false, function(v) Settings.ESPEnabled = v end)
    Toggle(P2, "ESP Box (Caixa)", false, function(v) Settings.ESPBox = v end)
    Toggle(P2, "ESP Nome", false, function(v) Settings.ESPName = v end)
    Toggle(P2, "ESP DistÃ¢ncia", false, function(v) Settings.ESPDist = v end)
    Toggle(P2, "ESP Linha (Tracer)", false, function(v) Settings.ESPLine = v end)

    local InfoL = Instance.new("TextLabel",P3); InfoL.BackgroundTransparency=1; InfoL.Size=UDim2.new(1,0,1,0); InfoL.Text="Uriel xiter\n\nSliders Fixados\nESP Name/Dist Adicionado\nOtimizado"; InfoL.TextColor3=Colors.White; InfoL.Font=Enum.Font.Gotham; InfoL.TextSize=14

    -- ==========================================
    -- 4. LOGICA CORE
    -- ==========================================
    local FOVCircle = nil
    local DrawingLibAvailable = false
    local Success, _ = pcall(function()
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Visible = false; FOVCircle.Thickness = 1.5; FOVCircle.Transparency = 1; FOVCircle.Color = Settings.ESPColor; FOVCircle.NumSides = 32; FOVCircle.Filled = false
        DrawingLibAvailable = true
    end)

    local Tracers = {}
    local ESPText = {}

    local function UpdateBox(char, state)
        local h = char:FindFirstChild("U_Highlight")
        if not state then if h then h:Destroy() end return end
        if not h then h=Instance.new("Highlight",char); h.Name="U_Highlight"; h.FillTransparency=0.6; h.OutlineTransparency=0 end
        h.FillColor=Settings.ESPColor; h.OutlineColor=Settings.ESPColor
    end

    RunService.RenderStepped:Connect(function()
        if FOVCircle then
            FOVCircle.Visible = Settings.ShowFOV
            FOVCircle.Radius = Settings.FOVRadius
            FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
            FOVCircle.Color = Settings.ESPColor
        end

        local BestTarget = nil
        local MinDist = Settings.FOVRadius
        local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        local MyPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0,0,0)

        for _, v in pairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character then
                local char = v.Character
                local hum = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")

                if hum and hum.Health > 0 and root and head then
                    
                    if Settings.TeamCheck and v.Team == LocalPlayer.Team then
                        UpdateBox(char, false)
                        if Tracers[v.Name] then Tracers[v.Name].Visible = false end
                        if ESPText[v.Name] then ESPText[v.Name].Visible = false end
                        continue
                    end

                    if Settings.ESPEnabled then
                        UpdateBox(char, Settings.ESPBox)
                        
                        local sPos, vis = Camera:WorldToViewportPoint(root.Position)
                        local headPos, headVis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.5, 0))
                        
                        if Settings.ESPLine and vis and DrawingLibAvailable then
                            if not Tracers[v.Name] then Tracers[v.Name] = Drawing.new("Line"); Tracers[v.Name].Thickness=1 end
                            local l = Tracers[v.Name]
                            l.Visible = true; l.From = Vector2.new(Center.X, Camera.ViewportSize.Y); l.To = Vector2.new(sPos.X, sPos.Y); l.Color = Settings.ESPColor
                        elseif Tracers[v.Name] then Tracers[v.Name].Visible = false end

                        if (Settings.ESPName or Settings.ESPDist) and headVis and DrawingLibAvailable then
                            if not ESPText[v.Name] then 
                                ESPText[v.Name] = Drawing.new("Text")
                                ESPText[v.Name].Size = 16
                                ESPText[v.Name].Center = true
                                ESPText[v.Name].Outline = true
                                ESPText[v.Name].Color = Color3.new(1,1,1)
                            end
                            local txt = ESPText[v.Name]
                            txt.Visible = true
                            txt.Position = Vector2.new(headPos.X, headPos.Y)
                            
                            local dist = (root.Position - MyPos).Magnitude
                            local str = ""
                            if Settings.ESPName then str = v.Name end
                            if Settings.ESPDist then str = str .. "\n[" .. math.floor(dist) .. "m]" end
                            txt.Text = str
                        elseif ESPText[v.Name] then
                            ESPText[v.Name].Visible = false
                        end

                    else
                        UpdateBox(char, false)
                        if Tracers[v.Name] then Tracers[v.Name].Visible = false end
                        if ESPText[v.Name] then ESPText[v.Name].Visible = false end
                    end

                    local aimPart = char:FindFirstChild(Settings.TargetMode == "Torso" and "UpperTorso" or "Head") or root
                    if aimPart then
                        local sPos, vis = Camera:WorldToViewportPoint(aimPart.Position)
                        if vis then
                            local dist = (Vector2.new(sPos.X, sPos.Y) - Center).Magnitude
                            if dist < MinDist then
                                if IsVisible(aimPart) then
                                    MinDist = dist
                                    BestTarget = aimPart
                                end
                            end
                        end
                    end
                else
                    UpdateBox(char, false)
                    if Tracers[v.Name] then Tracers[v.Name].Visible = false end
                    if ESPText[v.Name] then ESPText[v.Name].Visible = false end
                end
            else
                if Tracers[v.Name] then Tracers[v.Name]:Remove(); Tracers[v.Name] = nil end
                if ESPText[v.Name] then ESPText[v.Name]:Remove(); ESPText[v.Name] = nil end
            end
        end

        if Settings.AimbotEnabled and BestTarget then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, BestTarget.Position), Settings.Smoothness)
        end
    end)
end

LoadKeySystem()
