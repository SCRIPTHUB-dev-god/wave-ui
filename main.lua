local IcarusLibrary = {}
IcarusLibrary.__index = IcarusLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IcarusLibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = CoreGui

local IcarusCore = {
    Flags = {},
    ConfigPath = "IcarusConfig.json",
    Themes = {
        DeepBlue = {
            Background = Color3.fromRGB(10, 15, 25),
            Secondary = Color3.fromRGB(15, 22, 35),
            Tertiary = Color3.fromRGB(20, 28, 42),
            Border = Color3.fromRGB(35, 50, 75),
            Text = Color3.fromRGB(240, 245, 255),
            TextDim = Color3.fromRGB(150, 165, 190),
            Accent = Color3.fromRGB(59, 130, 246),
            AccentHover = Color3.fromRGB(79, 150, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(96, 165, 250)
        },
        Purple = {
            Background = Color3.fromRGB(15, 10, 25),
            Secondary = Color3.fromRGB(22, 15, 35),
            Tertiary = Color3.fromRGB(28, 20, 42),
            Border = Color3.fromRGB(50, 35, 75),
            Text = Color3.fromRGB(245, 240, 255),
            TextDim = Color3.fromRGB(180, 160, 200),
            Accent = Color3.fromRGB(168, 85, 247),
            AccentHover = Color3.fromRGB(192, 109, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(192, 132, 252)
        },
        Dark = {
            Background = Color3.fromRGB(12, 12, 16),
            Secondary = Color3.fromRGB(18, 18, 24),
            Tertiary = Color3.fromRGB(24, 24, 32),
            Border = Color3.fromRGB(40, 40, 52),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(160, 160, 180),
            Accent = Color3.fromRGB(100, 100, 255),
            AccentHover = Color3.fromRGB(120, 120, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(140, 140, 255)
        },
        Midnight = {
            Background = Color3.fromRGB(8, 12, 20),
            Secondary = Color3.fromRGB(12, 18, 28),
            Tertiary = Color3.fromRGB(16, 24, 36),
            Border = Color3.fromRGB(30, 42, 60),
            Text = Color3.fromRGB(230, 240, 255),
            TextDim = Color3.fromRGB(140, 160, 190),
            Accent = Color3.fromRGB(56, 189, 248),
            AccentHover = Color3.fromRGB(76, 209, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(125, 211, 252)
        },
        Ocean = {
            Background = Color3.fromRGB(8, 20, 28),
            Secondary = Color3.fromRGB(12, 28, 38),
            Tertiary = Color3.fromRGB(16, 36, 48),
            Border = Color3.fromRGB(28, 52, 68),
            Text = Color3.fromRGB(224, 242, 254),
            TextDim = Color3.fromRGB(148, 180, 200),
            Accent = Color3.fromRGB(6, 182, 212),
            AccentHover = Color3.fromRGB(34, 211, 238),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(103, 232, 249)
        },
        Rose = {
            Background = Color3.fromRGB(25, 10, 15),
            Secondary = Color3.fromRGB(35, 15, 22),
            Tertiary = Color3.fromRGB(42, 20, 28),
            Border = Color3.fromRGB(68, 35, 50),
            Text = Color3.fromRGB(255, 240, 245),
            TextDim = Color3.fromRGB(200, 160, 180),
            Accent = Color3.fromRGB(244, 63, 94),
            AccentHover = Color3.fromRGB(251, 113, 133),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(251, 113, 133)
        }
    },
    CurrentTheme = "DeepBlue",
    Keybinds = {},
    Notifications = {},
    MainWindow = nil,
    ToggleButton = nil,
    WindowVisible = true
}

local function HexToRgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber("0x" .. hex:sub(1, 2))
    local g = tonumber("0x" .. hex:sub(3, 4))
    local b = tonumber("0x" .. hex:sub(5, 6))
    return Color3.fromRGB(r, g, b)
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function TweenObject(object, properties, duration, style)
    if not object or not object.Parent then return end
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    handle = handle or frame
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - mousePos
            TweenObject(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.08)
        end
    end)
end

local function CreateShadow(parent, size, intensity)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = intensity or 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function CreateGlow(parent, color, intensity, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, size or 70, 1, size or 70)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5554236805"
    glow.ImageColor3 = color or Color3.fromRGB(59, 130, 246)
    glow.ImageTransparency = intensity or 0.65
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

local function CreateLightReflection(parent, size)
    local reflection = Instance.new("Frame")
    reflection.Name = "LightReflection"
    reflection.Size = size or UDim2.new(0.7, 0, 0.35, 0)
    reflection.Position = UDim2.new(0, 0, 0, 0)
    reflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    reflection.BackgroundTransparency = 0.9
    reflection.BorderSizePixel = 0
    reflection.ZIndex = parent.ZIndex + 1
    reflection.Parent = parent
    
    CreateGradient(reflection, {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(200, 220, 255)
    }, 135)
    
    CreateCorner(reflection, 10)
    
    return reflection
end

local function CreateTriangleToggle()
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = "IcarusToggle"
    toggleFrame.Size = UDim2.new(0, 50, 0, 35)
    toggleFrame.Position = UDim2.new(0.5, -25, 0, 5)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggleFrame.BackgroundTransparency = 0.65
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Active = true
    toggleFrame.Parent = ScreenGui
    CreateCorner(toggleFrame, 10)
    CreateShadow(toggleFrame, 25, 0.3)
    CreateGlow(toggleFrame, Color3.fromRGB(120, 120, 140), 0.75, 50)
    
    CreateGradient(toggleFrame, {
        Color3.fromRGB(90, 90, 100),
        Color3.fromRGB(70, 70, 80)
    }, 90)
    
    CreateLightReflection(toggleFrame, UDim2.new(0.8, 0, 0.4, 0))
    
    MakeDraggable(toggleFrame)
    
    local triangle = Instance.new("ImageLabel")
    triangle.Name = "Triangle"
    triangle.Size = UDim2.new(0, 20, 0, 18)
    triangle.Position = UDim2.new(0.5, -10, 0.5, -9)
    triangle.BackgroundTransparency = 1
    triangle.Image = "rbxassetid://7733992358"
    triangle.ImageColor3 = Color3.fromRGB(255, 255, 255)
    triangle.Rotation = 0
    triangle.Parent = toggleFrame
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleFrame
    
    clickDetector.MouseButton1Click:Connect(function()
        if IcarusCore.MainWindow then
            IcarusCore.WindowVisible = not IcarusCore.WindowVisible
            IcarusCore.MainWindow.Visible = IcarusCore.WindowVisible
            
            TweenObject(triangle, {
                Rotation = IcarusCore.WindowVisible and 0 or 180
            }, 0.25, Enum.EasingStyle.Back)
            
            if IcarusCore.WindowVisible then
                TweenObject(toggleFrame, {BackgroundTransparency = 0.65}, 0.2)
                TweenObject(triangle, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
            else
                TweenObject(toggleFrame, {BackgroundTransparency = 0.4}, 0.2)
                TweenObject(triangle, {ImageColor3 = Color3.fromRGB(180, 200, 255)}, 0.2)
            end
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleFrame, {Size = UDim2.new(0, 55, 0, 38)}, 0.2, Enum.EasingStyle.Back)
        TweenObject(triangle, {Size = UDim2.new(0, 23, 0, 21)}, 0.2)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleFrame, {Size = UDim2.new(0, 50, 0, 35)}, 0.2)
        TweenObject(triangle, {Size = UDim2.new(0, 20, 0, 18)}, 0.2)
    end)
    
    IcarusCore.ToggleButton = toggleFrame
    return toggleFrame
end

function IcarusCore:Notify(config)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 340, 1, 0)
        notifContainer.Position = UDim2.new(1, -350, 0, 50)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = ScreenGui
        
        local notifList = Instance.new("UIListLayout")
        notifList.Padding = UDim.new(0, 12)
        notifList.SortOrder = Enum.SortOrder.LayoutOrder
        notifList.VerticalAlignment = Enum.VerticalAlignment.Top
        notifList.Parent = notifContainer
    end
    
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(1, 0, 0, 0)
    notification.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = notifContainer
    CreateCorner(notification, 12)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Accent, 2)
    CreateShadow(notification, 35, 0.35)
    CreateGlow(notification, self.Themes[self.CurrentTheme].Accent, 0.75, 60)
    
    CreateGradient(notification, {
        self.Themes[self.CurrentTheme].Secondary,
        self.Themes[self.CurrentTheme].Tertiary
    }, 135)
    
    CreateLightReflection(notification, UDim2.new(0.65, 0, 0.32, 0))
    
    local typeColor = self.Themes[self.CurrentTheme].Accent
    if config.type == "success" then
        typeColor = self.Themes[self.CurrentTheme].Success
    elseif config.type == "warning" then
        typeColor = self.Themes[self.CurrentTheme].Warning
    elseif config.type == "error" then
        typeColor = self.Themes[self.CurrentTheme].Danger
    end
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 5, 1, 0)
    accentBar.BackgroundColor3 = typeColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notification
    
    CreateGradient(accentBar, {
        typeColor,
        Color3.fromRGB(
            math.min(255, typeColor.R * 255 + 50),
            math.min(255, typeColor.G * 255 + 50),
            math.min(255, typeColor.B * 255 + 50)
        )
    }, 90)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -28, 0, 26)
    title.Position = UDim2.new(0, 16, 0, 12)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -28, 0, 42)
    description.Position = UDim2.new(0, 16, 0, 38)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    description.Font = Enum.Font.Gotham
    description.TextSize = 13
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 82)}, 0.4, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3.5, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.35)
        task.wait(0.35)
        if notification.Parent then notification:Destroy() end
        local idx = table.find(self.Notifications, notification)
        if idx then table.remove(self.Notifications, idx) end
    end)
end

function IcarusCore:CreateDialog(title, message, callback)
    local dialogBg = Instance.new("Frame")
    dialogBg.Name = "DialogBackground"
    dialogBg.Size = UDim2.new(1, 0, 1, 0)
    dialogBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dialogBg.BackgroundTransparency = 0.25
    dialogBg.BorderSizePixel = 0
    dialogBg.ZIndex = 200
    dialogBg.Parent = ScreenGui
    
    local dialog = Instance.new("Frame")
    dialog.Name = "Dialog"
    dialog.Size = UDim2.new(0, 360, 0, 170)
    dialog.Position = UDim2.new(0.5, -180, 0.5, -85)
    dialog.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 201
    dialog.Parent = dialogBg
    CreateCorner(dialog, 14)
    CreateStroke(dialog, self.Themes[self.CurrentTheme].Accent, 2.5)
    CreateShadow(dialog, 60, 0.3)
    CreateGlow(dialog, self.Themes[self.CurrentTheme].Accent, 0.7, 80)
    
    CreateGradient(dialog, {
        self.Themes[self.CurrentTheme].Secondary,
        self.Themes[self.CurrentTheme].Background
    }, 135)
    
    CreateLightReflection(dialog, UDim2.new(0.7, 0, 0.35, 0))
    
    local dialogTitle = Instance.new("TextLabel")
    dialogTitle.Size = UDim2.new(1, -32, 0, 38)
    dialogTitle.Position = UDim2.new(0, 16, 0, 16)
    dialogTitle.BackgroundTransparency = 1
    dialogTitle.Text = title
    dialogTitle.TextColor3 = self.Themes[self.CurrentTheme].Text
    dialogTitle.Font = Enum.Font.GothamBold
    dialogTitle.TextSize = 17
    dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
    dialogTitle.ZIndex = 202
    dialogTitle.Parent = dialog
    
    local dialogMessage = Instance.new("TextLabel")
    dialogMessage.Size = UDim2.new(1, -32, 0, 54)
    dialogMessage.Position = UDim2.new(0, 16, 0, 58)
    dialogMessage.BackgroundTransparency = 1
    dialogMessage.Text = message
    dialogMessage.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    dialogMessage.Font = Enum.Font.Gotham
    dialogMessage.TextSize = 14
    dialogMessage.TextXAlignment = Enum.TextXAlignment.Left
    dialogMessage.TextYAlignment = Enum.TextYAlignment.Top
    dialogMessage.TextWrapped = true
    dialogMessage.ZIndex = 202
    dialogMessage.Parent = dialog
    
    local yesButton = Instance.new("TextButton")
    yesButton.Size = UDim2.new(0, 160, 0, 40)
    yesButton.Position = UDim2.new(0, 16, 1, -56)
    yesButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Danger
    yesButton.BorderSizePixel = 0
    yesButton.Text = "Yes"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.Font = Enum.Font.GothamBold
    yesButton.TextSize = 15
    yesButton.AutoButtonColor = false
    yesButton.ZIndex = 202
    yesButton.Parent = dialog
    CreateCorner(yesButton, 9)
    
    local noButton = Instance.new("TextButton")
    noButton.Size = UDim2.new(0, 160, 0, 40)
    noButton.Position = UDim2.new(1, -176, 1, -56)
    noButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary
    noButton.BorderSizePixel = 0
    noButton.Text = "No"
    noButton.TextColor3 = self.Themes[self.CurrentTheme].Text
    noButton.Font = Enum.Font.GothamBold
    noButton.TextSize = 15
    noButton.AutoButtonColor = false
    noButton.ZIndex = 202
    noButton.Parent = dialog
    CreateCorner(noButton, 9)
    
    yesButton.MouseButton1Click:Connect(function()
        dialogBg:Destroy()
        if callback then callback(true) end
    end)
    
    noButton.MouseButton1Click:Connect(function()
        dialogBg:Destroy()
        if callback then callback(false) end
    end)
    
    yesButton.MouseEnter:Connect(function()
        TweenObject(yesButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.18)
    end)
    
    yesButton.MouseLeave:Connect(function()
        TweenObject(yesButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Danger}, 0.18)
    end)
    
    noButton.MouseEnter:Connect(function()
        TweenObject(noButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary}, 0.18)
    end)
    
    noButton.MouseLeave:Connect(function()
        TweenObject(noButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary}, 0.18)
    end)
end

function IcarusLibrary:AddTheme(config)
    if not config.name or not config.colors then
        warn("Theme requires name and colors table")
        return self
    end
    
    IcarusCore.Themes[config.name] = {
        Background = config.colors.background or Color3.fromRGB(10, 15, 25),
        Secondary = config.colors.secondary or Color3.fromRGB(15, 22, 35),
        Tertiary = config.colors.tertiary or Color3.fromRGB(20, 28, 42),
        Border = config.colors.border or Color3.fromRGB(35, 50, 75),
        Text = config.colors.text or Color3.fromRGB(240, 245, 255),
        TextDim = config.colors.textdim or Color3.fromRGB(150, 165, 190),
        Accent = config.colors.accent or Color3.fromRGB(59, 130, 246),
        AccentHover = config.colors.accenthover or Color3.fromRGB(79, 150, 255),
        Success = config.colors.success or Color3.fromRGB(34, 197, 94),
        Warning = config.colors.warning or Color3.fromRGB(251, 191, 36),
        Danger = config.colors.danger or Color3.fromRGB(239, 68, 68),
        Glow = config.colors.glow or Color3.fromRGB(96, 165, 250)
    }
    
    IcarusCore:Notify({
        text = "Theme Added",
        description = "Custom theme '" .. config.name .. "' has been added",
        type = "success",
        duration = 2
    })
    
    return self
end

function IcarusLibrary:SetWindows(config)
    local windowSize = config.size or UDim2.fromOffset(480, 300)
    local width = windowSize.X.Offset
    local height = windowSize.Y.Offset
    local autoshow = config.autoshow ~= false
    local searchTopbar = config.searchtopbar ~= false
    local themeName = config.theme or "DeepBlue"
    
    IcarusCore.CurrentTheme = themeName
    IcarusCore.WindowVisible = autoshow
    
    CreateTriangleToggle()
    
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = windowSize
    window.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    window.BackgroundColor3 = IcarusCore.Themes[themeName].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = false
    window.Parent = ScreenGui
    CreateCorner(window, 16)
    CreateStroke(window, IcarusCore.Themes[themeName].Accent, 2.5)
    CreateShadow(window, 70, 0.35)
    CreateGlow(window, IcarusCore.Themes[themeName].Accent, 0.65, 90)
    
    CreateGradient(window, {
        IcarusCore.Themes[themeName].Background,
        IcarusCore.Themes[themeName].Secondary
    }, 135)
    
    CreateLightReflection(window, UDim2.new(0.75, 0, 0.38, 0))
    
    if config.settransparent and config.settransparent > 0 then
        window.BackgroundTransparency = config.settransparent
    end
    
    local cornerTopRight = Instance.new("Frame")
    cornerTopRight.Size = UDim2.new(0, 45, 0, 45)
    cornerTopRight.Position = UDim2.new(1, -2, 0, -2)
    cornerTopRight.AnchorPoint = Vector2.new(1, 0)
    cornerTopRight.BackgroundColor3 = IcarusCore.Themes[themeName].Glow
    cornerTopRight.BorderSizePixel = 0
    cornerTopRight.ZIndex = window.ZIndex + 1
    cornerTopRight.Parent = window
    CreateCorner(cornerTopRight, 16)
    
    CreateGradient(cornerTopRight, {
        IcarusCore.Themes[themeName].Accent,
        IcarusCore.Themes[themeName].AccentHover
    }, 45)
    
    local cornerGlow = CreateGlow(cornerTopRight, IcarusCore.Themes[themeName].Accent, 0.55, 50)
    
    local cornerBottomLeft = Instance.new("Frame")
    cornerBottomLeft.Size = UDim2.new(0, 45, 0, 45)
    cornerBottomLeft.Position = UDim2.new(0, -2, 1, 2)
    cornerBottomLeft.AnchorPoint = Vector2.new(0, 1)
    cornerBottomLeft.BackgroundColor3 = IcarusCore.Themes[themeName].Glow
    cornerBottomLeft.BorderSizePixel = 0
    cornerBottomLeft.ZIndex = window.ZIndex + 1
    cornerBottomLeft.Parent = window
    CreateCorner(cornerBottomLeft, 16)
    
    CreateGradient(cornerBottomLeft, {
        IcarusCore.Themes[themeName].AccentHover,
        IcarusCore.Themes[themeName].Accent
    }, 45)
    
    local cornerGlow2 = CreateGlow(cornerBottomLeft, IcarusCore.Themes[themeName].Accent, 0.55, 50)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 44)
    topbar.BackgroundColor3 = IcarusCore.Themes[themeName].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 16)
    
    CreateGradient(topbar, {
        IcarusCore.Themes[themeName].Secondary,
        IcarusCore.Themes[themeName].Tertiary
    }, 90)
    
    CreateLightReflection(topbar, UDim2.new(0.75, 0, 0.38, 0))
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 16)
    topbarCover.Position = UDim2.new(0, 0, 1, -16)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[themeName].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    MakeDraggable(window, topbar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, searchTopbar and -250 or -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 16, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[themeName].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 75, 0, 22)
    buttonContainer.Position = UDim2.new(1, -85, 0.5, -11)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(0, 53, 0, 0)
    closeBtn.BackgroundColor3 = IcarusCore.Themes[themeName].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    minimizeBtn.Position = UDim2.new(0, 27, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[themeName].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 22, 0, 22)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[themeName].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    if searchTopbar then
        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(0, 160, 0, 30)
        searchBox.Position = UDim2.new(1, -245, 0, 7)
        searchBox.BackgroundColor3 = IcarusCore.Themes[themeName].Tertiary
        searchBox.BorderSizePixel = 0
        searchBox.Text = ""
        searchBox.PlaceholderText = "  🔍 Search..."
        searchBox.TextColor3 = IcarusCore.Themes[themeName].Text
        searchBox.PlaceholderColor3 = IcarusCore.Themes[themeName].TextDim
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 13
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = topbar
        CreateCorner(searchBox, 8)
        CreateStroke(searchBox, IcarusCore.Themes[themeName].Border, 1.5)
    end
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 125, 1, -52)
    tabContainer.Position = UDim2.new(0, 9, 0, 50)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[themeName].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 5
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[themeName].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 12)
    CreateStroke(tabContainer, IcarusCore.Themes[themeName].Border, 2)
    
    CreateGradient(tabContainer, {
        IcarusCore.Themes[themeName].Secondary,
        IcarusCore.Themes[themeName].Tertiary
    }, 180)
    
    CreateLightReflection(tabContainer, UDim2.new(0.7, 0, 0.35, 0))
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 6)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 8)
    tabPadding.PaddingBottom = UDim.new(0, 8)
    tabPadding.PaddingLeft = UDim.new(0, 8)
    tabPadding.PaddingRight = UDim.new(0, 8)
    tabPadding.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 16)
    end)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -141, 1, -52)
    contentContainer.Position = UDim2.new(0, 141, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    closeBtn.MouseButton1Click:Connect(function()
        IcarusCore:CreateDialog(
            "Close GUI",
            "Are you sure you want to close this GUI?",
            function(result)
                if result then
                    TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.35, Enum.EasingStyle.Back)
                    task.wait(0.35)
                    window:Destroy()
                    if IcarusCore.ToggleButton then
                        IcarusCore.ToggleButton:Destroy()
                    end
                end
            end
        )
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, 51.5, 0, -1.5)}, 0.18)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 53, 0, 0)}, 0.18)
    end)
    
    local minimized = false
    local originalSize = windowSize
    local originalPos = window.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            originalSize = window.Size
            originalPos = window.Position
            TweenObject(window, {
                Size = UDim2.new(0, width, 0, 44),
                Position = UDim2.new(0.5, -width / 2, 1, -54)
            }, 0.35, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = originalSize,
                Position = originalPos
            }, 0.35, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, 25.5, 0, -1.5)}, 0.18)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 27, 0, 0)}, 0.18)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        IcarusCore.WindowVisible = false
        window.Visible = false
        IcarusCore:Notify({
            text = "GUI Hidden",
            description = "Use triangle toggle to show GUI",
            type = "info",
            duration = 2
        })
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 25, 0, 25), Position = UDim2.new(0, -1.5, 0, -1.5)}, 0.18)
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 22, 0, 22), Position = UDim2.new(0, 0, 0, 0)}, 0.18)
    end)
    
    IcarusCore.MainWindow = window
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[themeName].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 16)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 55, 0, 55)
        loadingRing.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[themeName].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingGlow = CreateGlow(loadingRing, IcarusCore.Themes[themeName].Accent, 0.65, 35)
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 240, 0, 30)
        loadingText.Position = UDim2.new(0.5, -120, 0.5, 40)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[themeName].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 15
        loadingText.Parent = loadingScreen
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1.6, Enum.EasingStyle.Linear)
                task.wait(1.6)
                loadingRing.Rotation = 0
            end
        end)
        
        task.delay(2, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.45)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.45)
            TweenObject(loadingGlow, {ImageTransparency = 1}, 0.45)
            TweenObject(loadingText, {TextTransparency = 1}, 0.45)
            task.wait(0.45)
            loadingScreen:Destroy()
            
            if autoshow then
                window.Visible = true
                IcarusCore.WindowVisible = true
            end
        end)
    else
        task.wait(0.15)
        if autoshow then
            window.Visible = true
            IcarusCore.WindowVisible = true
        end
    end
    
    local windowObj = {
        Window = window,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil,
        Theme = themeName
    }
    
    setmetatable(windowObj, IcarusLibrary)
    return windowObj
end

function IcarusLibrary:AddTab(config)
    return {
        AddLeftGroupbox = function() return {} end,
        AddRightGroupbox = function() return {} end
    }
end

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp then
        for _, keybind in pairs(IcarusCore.Keybinds) do
            if input.KeyCode == keybind.Key then
                keybind.Callback()
            end
        end
    end
end)

task.spawn(function()
    task.wait(0.4)
    IcarusCore:Notify({
        text = "Icarus Library Premium",
        description = "Multi-Theme System Loaded • v5.0",
        type = "success",
        duration = 3.5
    })
end)

return IcarusLibrary
