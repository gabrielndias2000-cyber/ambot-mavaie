
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local enabled = false
local activationKey = Enum.KeyCode.Q
local radius = 90

local gui = Instance.new("ScreenGui")
gui.Name = "AimControl"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(220, 170)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 29, 40)
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius =
    UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "AIM CONTROL"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.Parent = frame

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 35)
toggle.Position = UDim2.fromOffset(10, 42)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.Parent = frame

local function updateToggle()
    toggle.Text = enabled and "ATIVADO" or "DESATIVADO"
    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(60, 160, 100)
        or Color3.fromRGB(170, 65, 75)
end

toggle.MouseButton1Click:Connect(function()
    enabled = not enabled
    updateToggle()
end)

Instance.new("UICorner", toggle).CornerRadius =
    UDim.new(0, 6)

local keyButton = Instance.new("TextButton")
keyButton.Size = UDim2.new(1, -20, 0, 30)
keyButton.Position = UDim2.fromOffset(10, 84)
keyButton.BackgroundColor3 = Color3.fromRGB(48, 50, 65)
keyButton.TextColor3 = Color3.new(1, 1, 1)
keyButton.Text = "Tecla: Q"
keyButton.TextSize = 13
keyButton.Font = Enum.Font.Gotham
keyButton.Parent = frame

Instance.new("UICorner", keyButton).CornerRadius =
    UDim.new(0, 6)

local listening = false

keyButton.MouseButton1Click:Connect(function()
    listening = true
    keyButton.Text = "Pressione uma tecla..."
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
        return
    end

    if listening and input.KeyCode ~= Enum.KeyCode.Unknown then
        activationKey = input.KeyCode
        keyButton.Text = "Tecla: " .. activationKey.Name
        listening = false
        return
    end

    if input.KeyCode == activationKey then
        enabled = not enabled
        updateToggle()
    end
end)

local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, -20, 0, 25)
radiusLabel.Position = UDim2.fromOffset(10, 125)
radiusLabel.BackgroundTransparency = 1
radiusLabel.TextColor3 = Color3.fromRGB(210, 210, 225)
radiusLabel.Text = "Raio visual: " .. radius .. " px"
radiusLabel.TextSize = 12
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.Parent = frame

updateToggle()
