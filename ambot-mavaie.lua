
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local enabled = false
local listening = false
local activationKey = Enum.KeyCode.Q

local fovRadius = 90
local trainingRadius = 30

local purple = Color3.fromRGB(144, 92, 220)
local cyan = Color3.fromRGB(92, 205, 235)
local white = Color3.fromRGB(255, 255, 255)

local gui = Instance.new("ScreenGui")
gui.Name = "MavaiesScript"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local function round(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = object
end

local function gradient(object)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, purple),
        ColorSequenceKeypoint.new(1, cyan)
    })
    g.Rotation = 25
    g.Parent = object
end

local panel = Instance.new("Frame")
panel.Size = UDim2.fromOffset(300, 255)
panel.Position = UDim2.new(0, 25, 0.35, 0)
panel.BackgroundColor3 = Color3.fromRGB(35, 25, 65)
panel.BorderSizePixel = 0
panel.Parent = gui
panel.Active = true
round(panel, 12)
gradient(panel)

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 38)
header.BackgroundColor3 = Color3.fromRGB(40, 25, 70)
header.BackgroundTransparency = 0.15
header.Parent = panel
header.Active = true
round(header, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.fromOffset(12, 0)
title.BackgroundTransparency = 1
title.Text = "MAVAE'S SCRIPT"
title.TextColor3 = white
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(28, 26)
minimize.Position = UDim2.new(1, -34, 0, 6)
minimize.Text = "−"
minimize.TextSize = 20
minimize.TextColor3 = white
minimize.BackgroundColor3 = Color3.fromRGB(65, 55, 100)
minimize.Font = Enum.Font.GothamBold
minimize.Parent = header
round(minimize, 6)

local restore = Instance.new("TextButton")
restore.Size = UDim2.fromOffset(155, 38)
restore.Position = panel.Position
restore.Text = "mavae's_script"
restore.TextColor3 = white
restore.TextSize = 13
restore.Font = Enum.Font.GothamBold
restore.Visible = false
restore.BackgroundColor3 = purple
restore.Parent = gui
round(restore, 9)
gradient(restore)

local function makeButton(parent, text, position, size)
    local b = Instance.new("TextButton")
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = Color3.fromRGB(45, 40, 75)
    b.Text = text
    b.TextColor3 = white
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.Parent = parent
    round(b, 6)
    return b
end

local toggle = makeButton(
    panel,
    "DESATIVADO",
    UDim2.fromOffset(10, 47),
    UDim2.new(1, -20, 0, 31)
)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 19)
status.Position = UDim2.fromOffset(10, 81)
status.BackgroundTransparency = 1
status.Text = "TREINO VISUAL DESLIGADO"
status.TextColor3 = white
status.Font = Enum.Font.Gotham
status.TextSize = 10
status.Parent = panel

local function createAdjustRow(name, y, initial, minimum, maximum, step)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -20, 0, 34)
    row.Position = UDim2.fromOffset(10, y)
    row.BackgroundColor3 = Color3.fromRGB(40, 32, 75)
    row.Parent = panel
    round(row, 6)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 115, 1, 0)
    label.Position = UDim2.fromOffset(8, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = white
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local value = Instance.new("TextLabel")
    value.Size = UDim2.fromOffset(38, 34)
    value.Position = UDim2.fromOffset(172, 0)
    value.BackgroundTransparency = 1
    value.Text = tostring(initial)
    value.TextColor3 = cyan
    value.TextSize = 12
    value.Font = Enum.Font.GothamBold
    value.Parent = row

    local minus = makeButton(
        row, "-", UDim2.fromOffset(137, 4),
        UDim2.fromOffset(30, 26)
    )

    local plus = makeButton(
        row, "+", UDim2.fromOffset(230, 4),
        UDim2.fromOffset(30, 26)
    )

    minus.Activated:Connect(function()
        initial = math.max(minimum, initial - step)
        value.Text = tostring(initial)
    end)

    plus.Activated:Connect(function()
        initial = math.min(maximum, initial + step)
        value.Text = tostring(initial)
    end)

    return function()
        return initial
    end
end

local getFOV = createAdjustRow(
    "FOV (raio)", 105, 90, 30, 250, 10
)

local getTraining = createAdjustRow(
    "Zona treino*", 145, 30, 10, 100, 5
)

local keyButton = makeButton(
    panel,
    "TECLA: Q",
    UDim2.fromOffset(10, 187),
    UDim2.new(1, -20, 0, 29)
)

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -20, 0, 20)
note.Position = UDim2.fromOffset(10, 221)
note.BackgroundTransparency = 1
note.Text = "* Zona visual, não hitbox real"
note.TextColor3 = white
note.TextTransparency = 0.2
note.TextSize = 9
note.Font = Enum.Font.Gotham
note.Parent = panel

-- Círculos visuais
local function createCircle(color)
    local circle = Instance.new("Frame")
    circle.AnchorPoint = Vector2.new(0.5, 0.5)
    circle.BackgroundTransparency = 1
    circle.BorderSizePixel = 0
    circle.Visible = false
    circle.ZIndex = 2
    circle.Parent = gui

    round(circle, 999)

    local outline = Instance.new("UIStroke")
    outline.Color = color
    outline.Thickness = 2
    outline.Parent = circle

    return circle
end

local fovCircle = createCircle(purple)
local trainingCircle = createCircle(cyan)

local function updateState()
    toggle.Text = enabled and "ATIVADO" or "DESATIVADO"

    toggle.BackgroundColor3 = enabled
        and Color3.fromRGB(55, 150, 110)
        or Color3.fromRGB(150, 65, 90)

    status.Text = enabled
        and "TREINO VISUAL ATIVO"
        or "TREINO VISUAL DESLIGADO"

    fovCircle.Visible = enabled
    trainingCircle.Visible = enabled
end

toggle.Activated:Connect(function()
    enabled = not enabled
    updateState()
end)

keyButton.Activated:Connect(function()
    listening = true
    keyButton.Text = "PRESSIONE UMA TECLA..."
end)

UIS.InputBegan:Connect(function(input, processed)
    if listening then
        if input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode ~= Enum.KeyCode.Unknown then

            activationKey = input.KeyCode
            keyButton.Text = "TECLA: " .. activationKey.Name
            listening = false
        end
        return
    end

    if processed then return end

    if input.KeyCode == activationKey then
        enabled = not enabled
        updateState()
    end
end)

-- Atualiza os círculos ao redor do cursor
RunService.RenderStepped:Connect(function()
    if not enabled then return end

    fovRadius = getFOV()
    trainingRadius = getTraining()

    local mouse = UIS:GetMouseLocation()

    fovCircle.Size = UDim2.fromOffset(
        fovRadius * 2,
        fovRadius * 2
    )

    trainingCircle.Size = UDim2.fromOffset(
        trainingRadius * 2,
        trainingRadius * 2
    )

    fovCircle.Position = UDim2.fromOffset(mouse.X, mouse.Y)
    trainingCircle.Position = UDim2.fromOffset(mouse.X, mouse.Y)
end)

-- Arrastar painel
local function makeDraggable(object, handle)
    local dragging = false
    local dragStart
    local startPosition
    local dragInput

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then

            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(panel, header)
makeDraggable(restore, restore)

minimize.Activated:Connect(function()
    restore.Position = panel.Position
    panel.Visible = false
    restore.Visible = true
end)

restore.Activated:Connect(function()
    panel.Visible = true
    restore.Visible = false
end)

updateState()
