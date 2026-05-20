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
            AccentDark = Color3.fromRGB(37, 99, 235),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68),
            Glow = Color3.fromRGB(96, 165, 250)
        }
    },
    CurrentTheme = "DeepBlue",
    Keybinds = {},
    Notifications = {},
    ToggleButtons = {},
    MainWindow = nil,
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

local function CreateShadow(parent, size)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, size or 30, 1, size or 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

local function CreateGlow(parent, color, intensity)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 60, 1, 60)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5554236805"
    glow.ImageColor3 = color or Color3.fromRGB(59, 130, 246)
    glow.ImageTransparency = intensity or 0.7
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.ZIndex = parent.ZIndex - 1
    glow.Parent = parent
    return glow
end

local function CreateLightReflection(parent)
    local reflection = Instance.new("Frame")
    reflection.Name = "LightReflection"
    reflection.Size = UDim2.new(0.6, 0, 0.3, 0)
    reflection.Position = UDim2.new(0, 0, 0, 0)
    reflection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    reflection.BackgroundTransparency = 0.92
    reflection.BorderSizePixel = 0
    reflection.ZIndex = parent.ZIndex + 1
    reflection.Parent = parent
    
    CreateGradient(reflection, {
        Color3.fromRGB(255, 255, 255),
        Color3.fromRGB(96, 165, 250)
    }, 135)
    
    CreateCorner(reflection, 8)
    
    return reflection
end

function IcarusCore:Notify(config)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 320, 1, 0)
        notifContainer.Position = UDim2.new(1, -330, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = ScreenGui
        
        local notifList = Instance.new("UIListLayout")
        notifList.Padding = UDim.new(0, 10)
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
    CreateCorner(notification, 10)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Accent, 1.5)
    CreateShadow(notification, 30)
    CreateGlow(notification, self.Themes[self.CurrentTheme].Accent, 0.8)
    
    CreateGradient(notification, {
        self.Themes[self.CurrentTheme].Secondary,
        self.Themes[self.CurrentTheme].Tertiary
    }, 135)
    
    CreateLightReflection(notification)
    
    local typeColor = self.Themes[self.CurrentTheme].Accent
    if config.type == "success" then
        typeColor = self.Themes[self.CurrentTheme].Success
    elseif config.type == "warning" then
        typeColor = self.Themes[self.CurrentTheme].Warning
    elseif config.type == "error" then
        typeColor = self.Themes[self.CurrentTheme].Danger
    end
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = typeColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notification
    
    CreateGradient(accentBar, {
        typeColor,
        Color3.fromRGB(
            math.min(255, typeColor.R * 255 + 40),
            math.min(255, typeColor.G * 255 + 40),
            math.min(255, typeColor.B * 255 + 40)
        )
    }, 90)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 24)
    title.Position = UDim2.new(0, 14, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -24, 0, 38)
    description.Position = UDim2.new(0, 14, 0, 34)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    description.Font = Enum.Font.Gotham
    description.TextSize = 12
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 75)}, 0.35, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.wait(0.3)
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
    dialogBg.BackgroundTransparency = 0.3
    dialogBg.BorderSizePixel = 0
    dialogBg.ZIndex = 200
    dialogBg.Parent = ScreenGui
    
    local dialog = Instance.new("Frame")
    dialog.Name = "Dialog"
    dialog.Size = UDim2.new(0, 340, 0, 160)
    dialog.Position = UDim2.new(0.5, -170, 0.5, -80)
    dialog.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 201
    dialog.Parent = dialogBg
    CreateCorner(dialog, 12)
    CreateStroke(dialog, self.Themes[self.CurrentTheme].Accent, 2)
    CreateShadow(dialog, 50)
    CreateGlow(dialog, self.Themes[self.CurrentTheme].Accent, 0.75)
    
    CreateGradient(dialog, {
        self.Themes[self.CurrentTheme].Secondary,
        self.Themes[self.CurrentTheme].Background
    }, 135)
    
    CreateLightReflection(dialog)
    
    local dialogTitle = Instance.new("TextLabel")
    dialogTitle.Size = UDim2.new(1, -28, 0, 36)
    dialogTitle.Position = UDim2.new(0, 14, 0, 14)
    dialogTitle.BackgroundTransparency = 1
    dialogTitle.Text = title
    dialogTitle.TextColor3 = self.Themes[self.CurrentTheme].Text
    dialogTitle.Font = Enum.Font.GothamBold
    dialogTitle.TextSize = 16
    dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
    dialogTitle.ZIndex = 202
    dialogTitle.Parent = dialog
    
    local dialogMessage = Instance.new("TextLabel")
    dialogMessage.Size = UDim2.new(1, -28, 0, 50)
    dialogMessage.Position = UDim2.new(0, 14, 0, 54)
    dialogMessage.BackgroundTransparency = 1
    dialogMessage.Text = message
    dialogMessage.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    dialogMessage.Font = Enum.Font.Gotham
    dialogMessage.TextSize = 13
    dialogMessage.TextXAlignment = Enum.TextXAlignment.Left
    dialogMessage.TextYAlignment = Enum.TextYAlignment.Top
    dialogMessage.TextWrapped = true
    dialogMessage.ZIndex = 202
    dialogMessage.Parent = dialog
    
    local yesButton = Instance.new("TextButton")
    yesButton.Size = UDim2.new(0, 150, 0, 38)
    yesButton.Position = UDim2.new(0, 14, 1, -52)
    yesButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Danger
    yesButton.BorderSizePixel = 0
    yesButton.Text = "Yes"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.Font = Enum.Font.GothamBold
    yesButton.TextSize = 14
    yesButton.AutoButtonColor = false
    yesButton.ZIndex = 202
    yesButton.Parent = dialog
    CreateCorner(yesButton, 8)
    
    local noButton = Instance.new("TextButton")
    noButton.Size = UDim2.new(0, 150, 0, 38)
    noButton.Position = UDim2.new(1, -164, 1, -52)
    noButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary
    noButton.BorderSizePixel = 0
    noButton.Text = "No"
    noButton.TextColor3 = self.Themes[self.CurrentTheme].Text
    noButton.Font = Enum.Font.GothamBold
    noButton.TextSize = 14
    noButton.AutoButtonColor = false
    noButton.ZIndex = 202
    noButton.Parent = dialog
    CreateCorner(noButton, 8)
    
    yesButton.MouseButton1Click:Connect(function()
        dialogBg:Destroy()
        if callback then callback(true) end
    end)
    
    noButton.MouseButton1Click:Connect(function()
        dialogBg:Destroy()
        if callback then callback(false) end
    end)
    
    yesButton.MouseEnter:Connect(function()
        TweenObject(yesButton, {BackgroundColor3 = Color3.fromRGB(220, 50, 50)}, 0.15)
    end)
    
    yesButton.MouseLeave:Connect(function()
        TweenObject(yesButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Danger}, 0.15)
    end)
    
    noButton.MouseEnter:Connect(function()
        TweenObject(noButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary}, 0.15)
    end)
    
    noButton.MouseLeave:Connect(function()
        TweenObject(noButton, {BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary}, 0.15)
    end)
end

function IcarusLibrary:SetToggleGui(config)
    local text = config.text or "Toggle"
    local cornerColor = config.cornercolor and HexToRgb(config.cornercolor) or IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
    
    local width = 55
    local height = 55
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle_" .. text
    toggleBtn.Size = UDim2.new(0, width, 0, height)
    toggleBtn.Position = UDim2.new(0, 15 + (#IcarusCore.ToggleButtons * (width + 12)), 0.5, -height / 2)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Visible = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 12)
    CreateStroke(toggleBtn, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent, 2.5)
    CreateShadow(toggleBtn, 35)
    CreateGlow(toggleBtn, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent, 0.75)
    
    CreateGradient(toggleBtn, {
        IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary,
        IcarusCore.Themes[IcarusCore.CurrentTheme].Tertiary
    }, 135)
    
    CreateLightReflection(toggleBtn)
    
    local cornerAccent = Instance.new("Frame")
    cornerAccent.Size = UDim2.new(0, 25, 0, 25)
    cornerAccent.Position = UDim2.new(1, -1, 0, -1)
    cornerAccent.AnchorPoint = Vector2.new(1, 0)
    cornerAccent.BackgroundColor3 = cornerColor
    cornerAccent.BorderSizePixel = 0
    cornerAccent.ZIndex = toggleBtn.ZIndex + 1
    cornerAccent.Parent = toggleBtn
    CreateCorner(cornerAccent, 12)
    
    CreateGradient(cornerAccent, {
        cornerColor,
        Color3.fromRGB(
            math.min(255, cornerColor.R * 255 + 40),
            math.min(255, cornerColor.G * 255 + 40),
            math.min(255, cornerColor.B * 255 + 40)
        )
    }, 45)
    
    local cornerGlow = CreateGlow(cornerAccent, cornerColor, 0.7)
    cornerGlow.Size = UDim2.new(1, 20, 1, 20)
    
    MakeDraggable(toggleBtn)
    
    local iconGlow = Instance.new("Frame")
    iconGlow.Size = UDim2.new(0, 35, 0, 35)
    iconGlow.Position = UDim2.new(0.5, -17.5, 0.5, -17.5)
    iconGlow.BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
    iconGlow.BackgroundTransparency = 0.85
    iconGlow.BorderSizePixel = 0
    iconGlow.Parent = toggleBtn
    CreateCorner(iconGlow, 999)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0.5, -15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7734053426"
    icon.ImageColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
    icon.Parent = toggleBtn
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleBtn
    
    clickDetector.MouseButton1Click:Connect(function()
        if IcarusCore.MainWindow then
            IcarusCore.WindowVisible = not IcarusCore.WindowVisible
            IcarusCore.MainWindow.Visible = IcarusCore.WindowVisible
            
            if IcarusCore.WindowVisible then
                TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary}, 0.2)
                TweenObject(icon, {ImageColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent, Rotation = 0}, 0.2)
                TweenObject(iconGlow, {BackgroundTransparency = 0.85}, 0.2)
            else
                TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent}, 0.2)
                TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), Rotation = 90}, 0.2)
                TweenObject(iconGlow, {BackgroundTransparency = 0.6}, 0.2)
            end
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, width + 6, 0, height + 6)}, 0.18, Enum.EasingStyle.Back)
        TweenObject(icon, {Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0.5, -17.5, 0.5, -17.5)}, 0.18)
        TweenObject(iconGlow, {BackgroundTransparency = 0.7}, 0.18)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, width, 0, height)}, 0.18)
        TweenObject(icon, {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0.5, -15, 0.5, -15)}, 0.18)
        TweenObject(iconGlow, {BackgroundTransparency = IcarusCore.WindowVisible and 0.85 or 0.6}, 0.18)
    end)
    
    table.insert(IcarusCore.ToggleButtons, toggleBtn)
    return self
end

function IcarusLibrary:SetWindows(config)
    local windowSize = config.size or UDim2.fromOffset(480, 300)
    local width = windowSize.X.Offset
    local height = windowSize.Y.Offset
    local autoshow = config.autoshow ~= false
    local searchTopbar = config.searchtopbar ~= false
    
    IcarusCore.WindowVisible = autoshow
    
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = windowSize
    window.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = false
    window.Parent = ScreenGui
    CreateCorner(window, 14)
    CreateStroke(window, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 2)
    CreateShadow(window, 60)
    CreateGlow(window, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 0.7)
    
    CreateGradient(window, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Background,
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    }, 135)
    
    CreateLightReflection(window)
    
    if config.settransparent and config.settransparent > 0 then
        window.BackgroundTransparency = config.settransparent
    end
    
    local cornerTopRight = Instance.new("Frame")
    cornerTopRight.Size = UDim2.new(0, 40, 0, 40)
    cornerTopRight.Position = UDim2.new(1, -1, 0, -1)
    cornerTopRight.AnchorPoint = Vector2.new(1, 0)
    cornerTopRight.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Glow
    cornerTopRight.BorderSizePixel = 0
    cornerTopRight.ZIndex = window.ZIndex + 1
    cornerTopRight.Parent = window
    CreateCorner(cornerTopRight, 14)
    
    CreateGradient(cornerTopRight, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Accent,
        IcarusCore.Themes[config.theme or "DeepBlue"].AccentHover
    }, 45)
    
    local cornerGlow = CreateGlow(cornerTopRight, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 0.6)
    cornerGlow.Size = UDim2.new(1, 40, 1, 40)
    
    local cornerBottomLeft = Instance.new("Frame")
    cornerBottomLeft.Size = UDim2.new(0, 40, 0, 40)
    cornerBottomLeft.Position = UDim2.new(0, -1, 1, 1)
    cornerBottomLeft.AnchorPoint = Vector2.new(0, 1)
    cornerBottomLeft.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Glow
    cornerBottomLeft.BorderSizePixel = 0
    cornerBottomLeft.ZIndex = window.ZIndex + 1
    cornerBottomLeft.Parent = window
    CreateCorner(cornerBottomLeft, 14)
    
    CreateGradient(cornerBottomLeft, {
        IcarusCore.Themes[config.theme or "DeepBlue"].AccentHover,
        IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    }, 45)
    
    local cornerGlow2 = CreateGlow(cornerBottomLeft, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 0.6)
    cornerGlow2.Size = UDim2.new(1, 40, 1, 40)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 14)
    
    CreateGradient(topbar, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary,
        IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
    }, 90)
    
    CreateLightReflection(topbar)
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 14)
    topbarCover.Position = UDim2.new(0, 0, 1, -14)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    MakeDraggable(window, topbar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, searchTopbar and -240 or -110, 1, 0)
    titleLabel.Position = UDim2.new(0, 14, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 15
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 70, 0, 20)
    buttonContainer.Position = UDim2.new(1, -80, 0.5, -10)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(0, 50, 0, 0)
    closeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.Position = UDim2.new(0, 25, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 20, 0, 20)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    if searchTopbar then
        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(0, 150, 0, 28)
        searchBox.Position = UDim2.new(1, -235, 0, 6)
        searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
        searchBox.BorderSizePixel = 0
        searchBox.Text = ""
        searchBox.PlaceholderText = "  🔍 Search..."
        searchBox.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
        searchBox.PlaceholderColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].TextDim
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 12
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = topbar
        CreateCorner(searchBox, 7)
        CreateStroke(searchBox, IcarusCore.Themes[config.theme or "DeepBlue"].Border, 1)
    end
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 120, 1, -48)
    tabContainer.Position = UDim2.new(0, 8, 0, 46)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 4
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 10)
    CreateStroke(tabContainer, IcarusCore.Themes[config.theme or "DeepBlue"].Border, 1.5)
    
    CreateGradient(tabContainer, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary,
        IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
    }, 180)
    
    CreateLightReflection(tabContainer)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 7)
    tabPadding.PaddingBottom = UDim.new(0, 7)
    tabPadding.PaddingLeft = UDim.new(0, 7)
    tabPadding.PaddingRight = UDim.new(0, 7)
    tabPadding.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 14)
    end)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -135, 1, -48)
    contentContainer.Position = UDim2.new(0, 135, 0, 46)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    closeBtn.MouseButton1Click:Connect(function()
        IcarusCore:CreateDialog(
            "Close GUI",
            "Are you sure you want to close this GUI?",
            function(result)
                if result then
                    TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
                    task.wait(0.3)
                    window:Destroy()
                    for _, btn in pairs(IcarusCore.ToggleButtons) do
                        btn:Destroy()
                    end
                end
            end
        )
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 23, 0, 23), Position = UDim2.new(0, 48.5, 0, -1.5)}, 0.15)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 50, 0, 0)}, 0.15)
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
                Size = UDim2.new(0, width, 0, 40),
                Position = UDim2.new(0.5, -width / 2, 1, -50)
            }, 0.3, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = originalSize,
                Position = originalPos
            }, 0.3, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 23, 0, 23), Position = UDim2.new(0, 23.5, 0, -1.5)}, 0.15)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 25, 0, 0)}, 0.15)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        IcarusCore.WindowVisible = false
        window.Visible = false
        IcarusCore:Notify({
            text = "GUI Hidden",
            description = "Use toggle button to show GUI",
            type = "info",
            duration = 2
        })
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 23, 0, 23), Position = UDim2.new(0, -1.5, 0, -1.5)}, 0.15)
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 0, 0, 0)}, 0.15)
    end)
    
    IcarusCore.MainWindow = window
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 14)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 50, 0, 50)
        loadingRing.Position = UDim2.new(0.5, -25, 0.5, -25)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingGlow = CreateGlow(loadingRing, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 0.7)
        loadingGlow.Size = UDim2.new(1, 30, 1, 30)
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 220, 0, 28)
        loadingText.Position = UDim2.new(0.5, -110, 0.5, 36)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 14
        loadingText.Parent = loadingScreen
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1.5, Enum.EasingStyle.Linear)
                task.wait(1.5)
                loadingRing.Rotation = 0
            end
        end)
        
        task.delay(1.8, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.4)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.4)
            TweenObject(loadingGlow, {ImageTransparency = 1}, 0.4)
            TweenObject(loadingText, {TextTransparency = 1}, 0.4)
            task.wait(0.4)
            loadingScreen:Destroy()
            
            if autoshow then
                window.Visible = true
                IcarusCore.WindowVisible = true
            end
        end)
    else
        task.wait(0.1)
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
        Theme = config.theme or "DeepBlue"
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
    task.wait(0.3)
    IcarusCore:Notify({
        text = "Icarus Library",
        description = "Toggle GUI Fixed - v4.1",
        type = "success",
        duration = 3
    })
end)

return IcarusLibrary
