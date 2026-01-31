local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "AvisoGUI"

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Texto
local text = Instance.new("TextLabel")
text.Parent = frame
text.Size = UDim2.new(1, -20, 1, -60)
text.Position = UDim2.new(0, 10, 0, 10)
text.BackgroundTransparency = 1
text.TextWrapped = true
text.TextScaled = true
text.TextColor3 = Color3.new(1,1,1)
text.Text = "Desculpa, mas não funciona.\nO script foi vazado, então ele foi excluído.\nObrigado por usar."

-- Botão fechar
local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0, 100, 0, 35)
close.Position = UDim2.new(0.5, -50, 1, -45)
close.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
close.TextColor3 = Color3.new(1,1,1)
close.Text = "Fechar"

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
