
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local enabled = false
local activationKey = Enum.KeyCode.Q
local listening = false
local radius = 90

-- Interface principal
local gui = Instance.new("ScreenGui")
gui.Name = "MavaiesScript"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(230, 165)
panel.Position = UDim2.new(0, 20, 0.4, 0)
panel.BackgroundColor3 = Color3.fromRGB(25, 26, 36)
panel.BorderSizePixel = 0
panel.Parent = gui

Instance.new("UICorner", panel).CornerRadius =
    UDim.new(0, 10)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 36)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "MAVAI'S SCRIPT"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Active = true
title.Parent = panel

-- Botão de minimizar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(27, 25)
minimize.Position = UDim2.new(1, -34, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(55, 57, 72)
minimize.Text = "−"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 20
minimize.Font = Enum.Font.GothamBold
minimize.Parent = panel

Instance.new("UICorner", minimize).CornerRadius =
    UDim.new(0, 5)

-- Botão de restaurar
local restore = Instance.new("TextButton")
restore.Name = "RestoreButton"
restore.Size = UDim2.fromOffset(150, 36)
restore.Position = panel.Position
restore.BackgroundColor3 = Color3.fromRGB(35, 37, 52)
restore.Text = "mavae's_script"
restore.TextColor3 = Color3.fromRGB(255, 255, 255)
restore.TextSize = 13
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.Parent = gui

Instance.new("UICorner", restore).CornerRadius =
    UDim.new(0, 8)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(130, 100, 220)
stroke.Thickness = 1
stroke.Parent = restore

-- Alternar ativação
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -20, 0, 34)
toggle.Position = UDim2.fromOffset(10, 44)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.TextSize = 13
toggle.Font = Enum.Font.GothamBold
toggle.Parent = panel

Instance.new("UICorner", toggle).CornerRadius =
    UDim.new(0, 6)

local function updateToggle()
    toggle.Text = enabled and "ATIVADO" or "DESATIVADO"

    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(45, 150, 95)
        or Color3.fromRGB(165, 65, 75)
end

toggle.Activated:Connect(function()
    enabled = not enabled
    updateToggle()
end)

-- Seleção da tecla
local keyButton = Instance.new("TextButton")
keyButton.Size = UDim2.new(1, -20, 0, 30)
keyButton.Position = UDim2.fromOffset(10, 85)
keyButton.BackgroundColor3 = Color3.fromRGB(48, 50, 65)
keyButton.TextColor3 = Color3.new(1, 1, 1)
keyButton.Text = "Tecla: Q"
keyButton.TextSize = 12
keyButton.Font = Enum.Font.Gotham
keyButton.Parent = panel

Instance.new("UICorner", keyButton).CornerRadius =
    UDim.new(0, 6)

keyButton.Activated:Connect(function()
    listening = true
    keyButton.Text = "Pressione uma tecla..."
end)

-- Informação do raio
local radiusLabel = Instance.new("TextLabel")
radiusLabel.Size = UDim2.new(1, -20, 0, 25)
radiusLabel.Position = UDim2.fromOffset(10, 126)
radiusLabel.BackgroundTransparency = 1
radiusLabel.Text = "Raio visual: " .. radius .. " px"
radiusLabel.TextColor3 = Color3.fromRGB(195, 195, 215)
radiusLabel.TextSize = 11
radiusLabel.Font = Enum.Font.Gotham
radiusLabel.Parent = panel

-- Tecla de ativação
UserInputService.InputBegan:Connect(function(input, processed)

    if listening then
        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode ~= Enum.KeyCode.Unknown then

            activationKey = input.KeyCode
            keyButton.Text = "Tecla: " .. activationKey.Name
            listening = false
        end
        return
    end

    if processed then
        return
    end

    if input.KeyCode == activationKey then
        enabled = not enabled
        updateToggle()
    end
end)

-- Arrastar painel
local function makeDraggable(handle)

    local dragging = false
    local dragStart
    local startPosition

    handle.InputBegan:Connect(function(input)

        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = panel.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)

        if dragging then
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then

                local delta = input.Position - dragStart

                panel.Position = UDim2.new(
                    startPosition.X.Scale,
                    startPosition.X.Offset + delta.X,
                    startPosition.Y.Scale,
                    startPosition.Y.Offset + delta.Y
                )

                restore.Position = panel.Position
            end
        end
    end)
end

makeDraggable(title)
makeDraggable(restore)

-- Minimizar
minimize.Activated:Connect(function()
    restore.Position = panel.Position
    panel.Visible = false
    restore.Visible = true
end)

-- Restaurar
restore.Activated:Connect(function()
    panel.Visible = true
    restore.Visible = false
end)

updateToggle()

