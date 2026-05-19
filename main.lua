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
        Dark = {
            Background = Color3.fromRGB(16, 16, 20),
            Secondary = Color3.fromRGB(22, 22, 28),
            Tertiary = Color3.fromRGB(28, 28, 36),
            Border = Color3.fromRGB(40, 40, 52),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(160, 160, 180),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentHover = Color3.fromRGB(158, 63, 246),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68)
        },
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
            CornerAccent = Color3.fromRGB(96, 165, 250)
        },
        Purple = {
            Background = Color3.fromRGB(20, 12, 28),
            Secondary = Color3.fromRGB(26, 18, 36),
            Tertiary = Color3.fromRGB(32, 24, 44),
            Border = Color3.fromRGB(52, 40, 68),
            Text = Color3.fromRGB(245, 240, 255),
            TextDim = Color3.fromRGB(180, 170, 200),
            Accent = Color3.fromRGB(168, 85, 247),
            AccentHover = Color3.fromRGB(192, 109, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68)
        }
    },
    CurrentTheme = "DeepBlue",
    Keybinds = {},
    Notifications = {},
    ToggleButtons = {},
    MainWindow = nil
}

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
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
end

function IcarusCore:Notify(config)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 300, 1, 0)
        notifContainer.Position = UDim2.new(1, -310, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = ScreenGui
        
        local notifList = Instance.new("UIListLayout")
        notifList.Padding = UDim.new(0, 8)
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
    CreateCorner(notification, 8)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Border, 1)
    CreateShadow(notification, 20)
    
    local typeColor = self.Themes[self.CurrentTheme].Accent
    if config.type == "success" then
        typeColor = self.Themes[self.CurrentTheme].Success
    elseif config.type == "warning" then
        typeColor = self.Themes[self.CurrentTheme].Warning
    elseif config.type == "error" then
        typeColor = self.Themes[self.CurrentTheme].Danger
    end
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, 0)
    accentBar.BackgroundColor3 = typeColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notification
    
    CreateGradient(accentBar, {typeColor, Color3.fromRGB(
        math.min(255, typeColor.R * 255 + 30),
        math.min(255, typeColor.G * 255 + 30),
        math.min(255, typeColor.B * 255 + 30)
    )}, 90)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 22)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 35)
    description.Position = UDim2.new(0, 12, 0, 30)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    description.Font = Enum.Font.Gotham
    description.TextSize = 11
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 70)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        task.wait(0.25)
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
    dialogBg.BackgroundTransparency = 0.4
    dialogBg.BorderSizePixel = 0
    dialogBg.ZIndex = 200
    dialogBg.Parent = ScreenGui
    
    local dialog = Instance.new("Frame")
    dialog.Name = "Dialog"
    dialog.Size = UDim2.new(0, 320, 0, 150)
    dialog.Position = UDim2.new(0.5, -160, 0.5, -75)
    dialog.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 201
    dialog.Parent = dialogBg
    CreateCorner(dialog, 10)
    CreateStroke(dialog, self.Themes[self.CurrentTheme].Accent, 1.5)
    CreateShadow(dialog, 40)
    
    CreateGradient(dialog, {
        self.Themes[self.CurrentTheme].Secondary,
        self.Themes[self.CurrentTheme].Background
    }, 90)
    
    local dialogTitle = Instance.new("TextLabel")
    dialogTitle.Size = UDim2.new(1, -24, 0, 32)
    dialogTitle.Position = UDim2.new(0, 12, 0, 12)
    dialogTitle.BackgroundTransparency = 1
    dialogTitle.Text = title
    dialogTitle.TextColor3 = self.Themes[self.CurrentTheme].Text
    dialogTitle.Font = Enum.Font.GothamBold
    dialogTitle.TextSize = 15
    dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
    dialogTitle.ZIndex = 202
    dialogTitle.Parent = dialog
    
    local dialogMessage = Instance.new("TextLabel")
    dialogMessage.Size = UDim2.new(1, -24, 0, 45)
    dialogMessage.Position = UDim2.new(0, 12, 0, 48)
    dialogMessage.BackgroundTransparency = 1
    dialogMessage.Text = message
    dialogMessage.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    dialogMessage.Font = Enum.Font.Gotham
    dialogMessage.TextSize = 12
    dialogMessage.TextXAlignment = Enum.TextXAlignment.Left
    dialogMessage.TextYAlignment = Enum.TextYAlignment.Top
    dialogMessage.TextWrapped = true
    dialogMessage.ZIndex = 202
    dialogMessage.Parent = dialog
    
    local yesButton = Instance.new("TextButton")
    yesButton.Size = UDim2.new(0, 140, 0, 36)
    yesButton.Position = UDim2.new(0, 12, 1, -48)
    yesButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Danger
    yesButton.BorderSizePixel = 0
    yesButton.Text = "Yes"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.Font = Enum.Font.GothamBold
    yesButton.TextSize = 13
    yesButton.AutoButtonColor = false
    yesButton.ZIndex = 202
    yesButton.Parent = dialog
    CreateCorner(yesButton, 6)
    
    local noButton = Instance.new("TextButton")
    noButton.Size = UDim2.new(0, 140, 0, 36)
    noButton.Position = UDim2.new(1, -152, 1, -48)
    noButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary
    noButton.BorderSizePixel = 0
    noButton.Text = "No"
    noButton.TextColor3 = self.Themes[self.CurrentTheme].Text
    noButton.Font = Enum.Font.GothamBold
    noButton.TextSize = 13
    noButton.AutoButtonColor = false
    noButton.ZIndex = 202
    noButton.Parent = dialog
    CreateCorner(noButton, 6)
    
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

function IcarusLibrary:AddToggleGui(config)
    local geometry = config.geometry or "square"
    local text = config.text or "Toggle"
    
    local width = geometry == "square" and 50 or 130
    local height = geometry == "square" and 50 or 45
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle_" .. text
    toggleBtn.Size = UDim2.new(0, width, 0, height)
    toggleBtn.Position = UDim2.new(0, 15 + (#IcarusCore.ToggleButtons * (width + 10)), 0.5, -height / 2)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, geometry == "square" and 10 or 8)
    CreateStroke(toggleBtn, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent, 2)
    CreateShadow(toggleBtn, 25)
    
    CreateGradient(toggleBtn, {
        IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary,
        IcarusCore.Themes[IcarusCore.CurrentTheme].Tertiary
    }, 135)
    
    MakeDraggable(toggleBtn)
    
    local cornerAccent = Instance.new("Frame")
    cornerAccent.Size = UDim2.new(0, geometry == "square" and 20 or 30, 0, geometry == "square" and 20 or 25)
    cornerAccent.Position = UDim2.new(1, -1, 0, -1)
    cornerAccent.AnchorPoint = Vector2.new(1, 0)
    cornerAccent.BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].CornerAccent or IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
    cornerAccent.BorderSizePixel = 0
    cornerAccent.Parent = toggleBtn
    CreateCorner(cornerAccent, geometry == "square" and 10 or 8)
    
    local cornerAccentGrad = CreateGradient(cornerAccent, {
        IcarusCore.Themes[IcarusCore.CurrentTheme].Accent,
        Color3.fromRGB(
            math.min(255, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent.R * 255 + 40),
            math.min(255, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent.G * 255 + 40),
            math.min(255, IcarusCore.Themes[IcarusCore.CurrentTheme].Accent.B * 255 + 40)
        )
    }, 45)
    
    if geometry == "square" then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 28, 0, 28)
        icon.Position = UDim2.new(0.5, -14, 0.5, -14)
        icon.BackgroundTransparency = 1
        icon.Image = "rbxassetid://7734053426"
        icon.ImageColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
        icon.Parent = toggleBtn
        
        local clickDetector = Instance.new("TextButton")
        clickDetector.Size = UDim2.new(1, 0, 1, 0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.Parent = toggleBtn
        
        local isVisible = true
        clickDetector.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            if IcarusCore.MainWindow then
                IcarusCore.MainWindow.Visible = isVisible
                
                if isVisible then
                    TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary}, 0.2)
                    TweenObject(icon, {ImageColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent, Rotation = 0}, 0.2)
                else
                    TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent}, 0.2)
                    TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), Rotation = 90}, 0.2)
                end
            end
        end)
        
        clickDetector.MouseEnter:Connect(function()
            TweenObject(toggleBtn, {Size = UDim2.new(0, width + 5, 0, height + 5)}, 0.15, Enum.EasingStyle.Back)
            TweenObject(icon, {Size = UDim2.new(0, 32, 0, 32), Position = UDim2.new(0.5, -16, 0.5, -16)}, 0.15)
        end)
        
        clickDetector.MouseLeave:Connect(function()
            TweenObject(toggleBtn, {Size = UDim2.new(0, width, 0, height)}, 0.15)
            TweenObject(icon, {Size = UDim2.new(0, 28, 0, 28), Position = UDim2.new(0.5, -14, 0.5, -14)}, 0.15)
        end)
    else
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -15, 1, 0)
        label.Position = UDim2.new(0, 8, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent
        label.Font = Enum.Font.GothamBold
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = toggleBtn
        
        local clickDetector = Instance.new("TextButton")
        clickDetector.Size = UDim2.new(1, 0, 1, 0)
        clickDetector.BackgroundTransparency = 1
        clickDetector.Text = ""
        clickDetector.Parent = toggleBtn
        
        local isVisible = true
        clickDetector.MouseButton1Click:Connect(function()
            isVisible = not isVisible
            if IcarusCore.MainWindow then
                IcarusCore.MainWindow.Visible = isVisible
                
                if isVisible then
                    TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Secondary}, 0.2)
                    TweenObject(label, {TextColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent}, 0.2)
                else
                    TweenObject(toggleBtn, {BackgroundColor3 = IcarusCore.Themes[IcarusCore.CurrentTheme].Accent}, 0.2)
                    TweenObject(label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                end
            end
        end)
        
        clickDetector.MouseEnter:Connect(function()
            TweenObject(toggleBtn, {Size = UDim2.new(0, width + 8, 0, height + 3)}, 0.15, Enum.EasingStyle.Back)
        end)
        
        clickDetector.MouseLeave:Connect(function()
            TweenObject(toggleBtn, {Size = UDim2.new(0, width, 0, height)}, 0.15)
        end)
    end
    
    table.insert(IcarusCore.ToggleButtons, toggleBtn)
    return toggleBtn
end

function IcarusLibrary:SetWindows(config)
    local windowSize = config.size or UDim2.fromOffset(480, 300)
    local width = windowSize.X.Offset
    local height = windowSize.Y.Offset
    local autoshow = config.autoshow ~= false
    local searchTopbar = config.searchtopbar ~= false
    
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
    CreateCorner(window, 12)
    CreateStroke(window, IcarusCore.Themes[config.theme or "DeepBlue"].Accent, 1.5)
    CreateShadow(window, 50)
    
    CreateGradient(window, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Background,
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    }, 135)
    
    if config.settransparent and config.settransparent > 0 then
        window.BackgroundTransparency = config.settransparent
    end
    
    local cornerTopRight = Instance.new("Frame")
    cornerTopRight.Size = UDim2.new(0, 35, 0, 35)
    cornerTopRight.Position = UDim2.new(1, -1, 0, -1)
    cornerTopRight.AnchorPoint = Vector2.new(1, 0)
    cornerTopRight.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].CornerAccent or IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    cornerTopRight.BorderSizePixel = 0
    cornerTopRight.Parent = window
    CreateCorner(cornerTopRight, 12)
    
    CreateGradient(cornerTopRight, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Accent,
        IcarusCore.Themes[config.theme or "DeepBlue"].AccentHover
    }, 45)
    
    local cornerBottomLeft = Instance.new("Frame")
    cornerBottomLeft.Size = UDim2.new(0, 35, 0, 35)
    cornerBottomLeft.Position = UDim2.new(0, -1, 1, 1)
    cornerBottomLeft.AnchorPoint = Vector2.new(0, 1)
    cornerBottomLeft.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].CornerAccent or IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    cornerBottomLeft.BorderSizePixel = 0
    cornerBottomLeft.Parent = window
    CreateCorner(cornerBottomLeft, 12)
    
    CreateGradient(cornerBottomLeft, {
        IcarusCore.Themes[config.theme or "DeepBlue"].AccentHover,
        IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    }, 45)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 36)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 12)
    
    CreateGradient(topbar, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary,
        IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
    }, 90)
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 12)
    topbarCover.Position = UDim2.new(0, 0, 1, -12)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    MakeDraggable(window, topbar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, searchTopbar and -230 or -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 65, 0, 18)
    buttonContainer.Position = UDim2.new(1, -75, 0.5, -9)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 18, 0, 18)
    closeBtn.Position = UDim2.new(0, 47, 0, 0)
    closeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 18, 0, 18)
    minimizeBtn.Position = UDim2.new(0, 24, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 18, 0, 18)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    if searchTopbar then
        local searchBox = Instance.new("TextBox")
        searchBox.Name = "SearchBox"
        searchBox.Size = UDim2.new(0, 140, 0, 26)
        searchBox.Position = UDim2.new(1, -220, 0, 5)
        searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
        searchBox.BorderSizePixel = 0
        searchBox.Text = ""
        searchBox.PlaceholderText = "  🔍 Search..."
        searchBox.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
        searchBox.PlaceholderColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].TextDim
        searchBox.Font = Enum.Font.Gotham
        searchBox.TextSize = 11
        searchBox.TextXAlignment = Enum.TextXAlignment.Left
        searchBox.Parent = topbar
        CreateCorner(searchBox, 6)
        CreateStroke(searchBox, IcarusCore.Themes[config.theme or "DeepBlue"].Border, 1)
    end
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 115, 1, -44)
    tabContainer.Position = UDim2.new(0, 7, 0, 42)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 3
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 8)
    CreateStroke(tabContainer, IcarusCore.Themes[config.theme or "DeepBlue"].Border, 1)
    
    CreateGradient(tabContainer, {
        IcarusCore.Themes[config.theme or "DeepBlue"].Secondary,
        IcarusCore.Themes[config.theme or "DeepBlue"].Tertiary
    }, 180)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 4)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 6)
    tabPadding.PaddingBottom = UDim.new(0, 6)
    tabPadding.PaddingLeft = UDim.new(0, 6)
    tabPadding.PaddingRight = UDim.new(0, 6)
    tabPadding.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 12)
    end)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -129, 1, -44)
    contentContainer.Position = UDim2.new(0, 129, 0, 42)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    closeBtn.MouseButton1Click:Connect(function()
        IcarusCore:CreateDialog(
            "Close GUI",
            "Are you sure you want to close this GUI?",
            function(result)
                if result then
                    TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back)
                    task.wait(0.25)
                    window:Destroy()
                    for _, btn in pairs(IcarusCore.ToggleButtons) do
                        btn:Destroy()
                    end
                end
            end
        )
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 46, 0, -1)}, 0.12)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 47, 0, 0)}, 0.12)
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
                Size = UDim2.new(0, width, 0, 36),
                Position = UDim2.new(0.5, -width / 2, 1, -46)
            }, 0.25, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = originalSize,
                Position = originalPos
            }, 0.25, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, 23, 0, -1)}, 0.12)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 24, 0, 0)}, 0.12)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        if not autoshow then
            IcarusCore:Notify({
                text = "Toggle Mode",
                description = "Use AddToggleGui to create toggle buttons",
                type = "info",
                duration = 2
            })
        else
            TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back)
            task.wait(0.25)
            window.Visible = false
            TweenObject(window, {Size = windowSize}, 0.01)
        end
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new(0, -1, 0, -1)}, 0.12)
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 0, 0, 0)}, 0.12)
    end)
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 12)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 45, 0, 45)
        loadingRing.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 200, 0, 25)
        loadingText.Position = UDim2.new(0.5, -100, 0.5, 32)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "DeepBlue"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 13
        loadingText.Parent = loadingScreen
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1.2, Enum.EasingStyle.Linear)
                task.wait(1.2)
                loadingRing.Rotation = 0
            end
        end)
        
        task.delay(1.5, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.3)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.3)
            TweenObject(loadingText, {TextTransparency = 1}, 0.3)
            task.wait(0.3)
            loadingScreen:Destroy()
            
            if autoshow then
                window.Visible = true
            end
        end)
    else
        if autoshow then
            window.Visible = true
        end
    end
    
    IcarusCore.MainWindow = window
    
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
    local tabButton = Instance.new("TextButton")
    tabButton.Name = config.text
    tabButton.Size = UDim2.new(1, 0, 0, 30)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
    tabButton.BorderSizePixel = 0
    tabButton.Text = config.text
    tabButton.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 11
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 6)
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = config.text
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local leftColumn = Instance.new("ScrollingFrame")
    leftColumn.Name = "LeftColumn"
    leftColumn.Size = UDim2.new(0.5, -4, 1, 0)
    leftColumn.Position = UDim2.new(0, 0, 0, 0)
    leftColumn.BackgroundTransparency = 1
    leftColumn.BorderSizePixel = 0
    leftColumn.ScrollBarThickness = 3
    leftColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    leftColumn.Parent = contentFrame
    
    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, 6)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Parent = leftColumn
    
    local leftPadding = Instance.new("UIPadding")
    leftPadding.PaddingTop = UDim.new(0, 6)
    leftPadding.PaddingBottom = UDim.new(0, 6)
    leftPadding.PaddingLeft = UDim.new(0, 6)
    leftPadding.PaddingRight = UDim.new(0, 3)
    leftPadding.Parent = leftColumn
    
    leftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftList.AbsoluteContentSize.Y + 12)
    end)
    
    local rightColumn = Instance.new("ScrollingFrame")
    rightColumn.Name = "RightColumn"
    rightColumn.Size = UDim2.new(0.5, -4, 1, 0)
    rightColumn.Position = UDim2.new(0.5, 4, 0, 0)
    rightColumn.BackgroundTransparency = 1
    rightColumn.BorderSizePixel = 0
    rightColumn.ScrollBarThickness = 3
    rightColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    rightColumn.Parent = contentFrame
    
    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, 6)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Parent = rightColumn
    
    local rightPadding = Instance.new("UIPadding")
    rightPadding.PaddingTop = UDim.new(0, 6)
    rightPadding.PaddingBottom = UDim.new(0, 6)
    rightPadding.PaddingLeft = UDim.new(0, 3)
    rightPadding.PaddingRight = UDim.new(0, 6)
    rightPadding.Parent = rightColumn
    
    rightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightList.AbsoluteContentSize.Y + 12)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
            TweenObject(tab.Button, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.15)
            tab.Content.Visible = false
        end
        TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.15)
        TweenObject(tabButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.12)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.12)
        end
    end)
    
    local tabObj = {
        Button = tabButton,
        Content = contentFrame,
        LeftColumn = leftColumn,
        RightColumn = rightColumn
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end
    
    local tabFunctions = {Theme = self.Theme, LeftColumn = leftColumn, RightColumn = rightColumn}
    
    function tabFunctions:AddLeftGroupbox(config)
        return self:CreateGroupbox(config, self.LeftColumn)
    end
    
    function tabFunctions:AddRightGroupbox(config)
        return self:CreateGroupbox(config, self.RightColumn)
    end
    
    function tabFunctions:CreateGroupbox(config, parent)
        local groupbox = Instance.new("Frame")
        groupbox.Name = config.text
        groupbox.Size = UDim2.new(1, 0, 0, 42)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        groupbox.BorderSizePixel = 0
        groupbox.Parent = parent
        CreateCorner(groupbox, 6)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].Border, 1)
        
        CreateGradient(groupbox, {
            IcarusCore.Themes[self.Theme].Secondary,
            IcarusCore.Themes[self.Theme].Tertiary
        }, 90)
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -16, 0, 24)
        groupboxLabel.Position = UDim2.new(0, 8, 0, 6)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 12
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -12, 1, -34)
        groupboxContent.Position = UDim2.new(0, 6, 0, 32)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 5)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 42)
        end)
        
        local groupboxFunctions = {
            Groupbox = groupbox,
            Content = groupboxContent,
            Theme = self.Theme
        }
        
        function groupboxFunctions:AddTabbox(config)
            local tabboxFrame = Instance.new("Frame")
            tabboxFrame.Name = "Tabbox"
            tabboxFrame.Size = UDim2.new(1, 0, 0, 28)
            tabboxFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            tabboxFrame.BorderSizePixel = 0
            tabboxFrame.Parent = groupboxContent
            CreateCorner(tabboxFrame, 5)
            
            local tabboxButtons = Instance.new("Frame")
            tabboxButtons.Name = "Buttons"
            tabboxButtons.Size = UDim2.new(1, -4, 0, 24)
            tabboxButtons.Position = UDim2.new(0, 2, 0, 2)
            tabboxButtons.BackgroundTransparency = 1
            tabboxButtons.Parent = tabboxFrame
            
            local buttonList = Instance.new("UIListLayout")
            buttonList.FillDirection = Enum.FillDirection.Horizontal
            buttonList.Padding = UDim.new(0, 3)
            buttonList.SortOrder = Enum.SortOrder.LayoutOrder
            buttonList.Parent = tabboxButtons
            
            local tabboxContent = Instance.new("Frame")
            tabboxContent.Name = "TabboxContent"
            tabboxContent.Size = UDim2.new(1, 0, 0, 0)
            tabboxContent.Position = UDim2.new(0, 0, 0, 32)
            tabboxContent.BackgroundTransparency = 1
            tabboxContent.Parent = groupboxContent
            
            local tabboxTabs = {}
            
            local tabboxFunctions = {
                Frame = tabboxFrame,
                Content = tabboxContent,
                Tabs = tabboxTabs,
                Theme = self.Theme
            }
            
            function tabboxFunctions:AddTab(tabConfig)
                local tabButton = Instance.new("TextButton")
                tabButton.Name = tabConfig.text
                tabButton.Size = UDim2.new(0, 0, 1, 0)
                tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
                tabButton.BorderSizePixel = 0
                tabButton.Text = tabConfig.text
                tabButton.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
                tabButton.Font = Enum.Font.GothamSemibold
                tabButton.TextSize = 10
                tabButton.AutoButtonColor = false
                tabButton.Parent = tabboxButtons
                CreateCorner(tabButton, 4)
                
                local textSize = game:GetService("TextService"):GetTextSize(
                    tabConfig.text,
                    10,
                    Enum.Font.GothamSemibold,
                    Vector2.new(1000, 1000)
                )
                tabButton.Size = UDim2.new(0, textSize.X + 18, 1, 0)
                
                local tabContent = Instance.new("Frame")
                tabContent.Name = tabConfig.text
                tabContent.Size = UDim2.new(1, 0, 0, 0)
                tabContent.BackgroundTransparency = 1
                tabContent.Visible = false
                tabContent.Parent = tabboxContent
                
                local tabContentList = Instance.new("UIListLayout")
                tabContentList.Padding = UDim.new(0, 5)
                tabContentList.SortOrder = Enum.SortOrder.LayoutOrder
                tabContentList.Parent = tabContent
                
                tabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.Size = UDim2.new(1, 0, 0, tabContentList.AbsoluteContentSize.Y)
                    
                    local totalHeight = 32
                    for _, tab in pairs(tabboxTabs) do
                        if tab.Content.Visible then
                            totalHeight = totalHeight + tab.Content.AbsoluteSize.Y
                        end
                    end
                    tabboxContent.Size = UDim2.new(1, 0, 0, totalHeight - 32)
                end)
                
                tabButton.MouseButton1Click:Connect(function()
                    for _, tab in pairs(tabboxTabs) do
                        TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.12)
                        TweenObject(tab.Button, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.12)
                        tab.Content.Visible = false
                    end
                    TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.12)
                    TweenObject(tabButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
                    tabContent.Visible = true
                end)
                
                local tabFuncs = {
                    Button = tabButton,
                    Content = tabContent,
                    Theme = self.Theme
                }
                
                table.insert(tabboxTabs, tabFuncs)
                
                if #tabboxTabs == 1 then
                    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
                    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                    tabContent.Visible = true
                end
                
                function tabFuncs:AddToggle(cfg)
                    return CreateElement("Toggle", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddButton(cfg)
                    return CreateElement("Button", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddSlider(cfg)
                    return CreateElement("Slider", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddDropdown(cfg)
                    return CreateElement("Dropdown", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddTextbox(cfg)
                    return CreateElement("Textbox", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddColorpicker(cfg)
                    return CreateElement("Colorpicker", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddKeybind(cfg)
                    return CreateElement("Keybind", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddLabel(cfg)
                    return CreateElement("Label", cfg, tabContent, self.Theme)
                end
                
                function tabFuncs:AddDivider(text)
                    return CreateElement("Divider", {text = text}, tabContent, self.Theme)
                end
                
                return tabFuncs
            end
            
            return tabboxFunctions
        end
        
        function groupboxFunctions:AddToggle(cfg)
            return CreateElement("Toggle", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddButton(cfg)
            return CreateElement("Button", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddSlider(cfg)
            return CreateElement("Slider", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddDropdown(cfg)
            return CreateElement("Dropdown", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddTextbox(cfg)
            return CreateElement("Textbox", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddColorpicker(cfg)
            return CreateElement("Colorpicker", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddKeybind(cfg)
            return CreateElement("Keybind", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddLabel(cfg)
            return CreateElement("Label", cfg, groupboxContent, self.Theme)
        end
        
        function groupboxFunctions:AddDivider(text)
            return CreateElement("Divider", {text = text}, groupboxContent, self.Theme)
        end
        
        return groupboxFunctions
    end
    
    return tabFunctions
end

function CreateElement(elementType, config, parent, theme)
    if elementType == "Toggle" then
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 30)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        CreateCorner(toggleFrame, 5)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -52, 1, 0)
        toggleLabel.Position = UDim2.new(0, 8, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 11
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 38, 0, 20)
        toggleButton.Position = UDim2.new(1, -46, 0.5, -10)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[theme].Accent or IcarusCore.Themes[theme].Border
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.Parent = toggleFrame
        CreateCorner(toggleButton, 999)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 16, 0, 16)
        toggleCircle.Position = config.type and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        CreateCorner(toggleCircle, 999)
        
        local toggled = config.type or false
        if config.flag then IcarusCore.Flags[config.flag] = toggled end
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            if config.flag then IcarusCore.Flags[config.flag] = toggled end
            
            TweenObject(toggleButton, {
                BackgroundColor3 = toggled and IcarusCore.Themes[theme].Accent or IcarusCore.Themes[theme].Border
            }, 0.15)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }, 0.15)
            
            if config.callback then config.callback(toggled) end
        end)
        
        return {Frame = toggleFrame, SetValue = function(v) toggled = v end, GetValue = function() return toggled end}
        
    elseif elementType == "Button" then
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 30)
        button.BackgroundColor3 = IcarusCore.Themes[theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 11
        button.AutoButtonColor = false
        button.Parent = parent
        CreateCorner(button, 5)
        
        CreateGradient(button, {
            IcarusCore.Themes[theme].Accent,
            IcarusCore.Themes[theme].AccentHover
        }, 90)
        
        button.MouseButton1Click:Connect(function()
            if config.callback then config.callback() end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[theme].AccentHover}, 0.12)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.12)
        end)
        
        return {Button = button}
        
    elseif elementType == "Slider" then
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 42)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = parent
        CreateCorner(sliderFrame, 5)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -52, 0, 18)
        sliderLabel.Position = UDim2.new(0, 8, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 11
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 42, 0, 18)
        valueLabel.Position = UDim2.new(1, -50, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, -16, 0, 5)
        sliderTrack.Position = UDim2.new(0, 8, 1, -12)
        sliderTrack.BackgroundColor3 = IcarusCore.Themes[theme].Border
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderFrame
        CreateCorner(sliderTrack, 999)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.BackgroundColor3 = IcarusCore.Themes[theme].Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        CreateCorner(sliderFill, 999)
        
        CreateGradient(sliderFill, {
            IcarusCore.Themes[theme].Accent,
            IcarusCore.Themes[theme].AccentHover
        }, 90)
        
        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 11, 0, 11)
        sliderDot.Position = UDim2.new(1, -5.5, 0.5, -5.5)
        sliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderDot.BorderSizePixel = 0
        sliderDot.Parent = sliderFill
        CreateCorner(sliderDot, 999)
        
        local sliderInput = Instance.new("TextButton")
        sliderInput.Size = UDim2.new(1, 0, 1, 6)
        sliderInput.Position = UDim2.new(0, 0, 0, -3)
        sliderInput.BackgroundTransparency = 1
        sliderInput.Text = ""
        sliderInput.Parent = sliderTrack
        
        local dragging = false
        local currentValue = config.default or config.min
        if config.flag then IcarusCore.Flags[config.flag] = currentValue end
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(config.min + (config.max - config.min) * relativeX)
            valueLabel.Text = tostring(currentValue)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            if config.flag then IcarusCore.Flags[config.flag] = currentValue end
            if config.callback then config.callback(currentValue) end
        end
        
        sliderInput.MouseButton1Down:Connect(function() dragging = true end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateSlider(input)
            end
        end)
        
        sliderInput.MouseButton1Click:Connect(updateSlider)
        
        local defaultRatio = (config.default - config.min) / (config.max - config.min)
        sliderFill.Size = UDim2.new(defaultRatio, 0, 1, 0)
        
        return {Frame = sliderFrame, SetValue = function(v) currentValue = v end, GetValue = function() return currentValue end}
        
    elseif elementType == "Dropdown" then
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 30)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = false
        dropdownFrame.ZIndex = 5
        dropdownFrame.Parent = parent
        CreateCorner(dropdownFrame, 5)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 30)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.ZIndex = 6
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -32, 0, 30)
        dropdownLabel.Position = UDim2.new(0, 8, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 11
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.ZIndex = 6
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 14, 0, 14)
        dropdownIcon.Position = UDim2.new(1, -22, 0, 8)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[theme].TextDim
        dropdownIcon.Rotation = 0
        dropdownIcon.ZIndex = 6
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownContainer = Instance.new("ScrollingFrame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 0, 0, 34)
        dropdownContainer.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.ScrollBarThickness = 2
        dropdownContainer.ScrollBarImageColor3 = IcarusCore.Themes[theme].Accent
        dropdownContainer.ZIndex = 50
        dropdownContainer.Parent = dropdownFrame
        CreateCorner(dropdownContainer, 5)
        CreateStroke(dropdownContainer, IcarusCore.Themes[theme].Accent, 1)
        
        local dropdownList = Instance.new("UIListLayout")
        dropdownList.Padding = UDim.new(0, 2)
        dropdownList.Parent = dropdownContainer
        
        local dropdownPadding = Instance.new("UIPadding")
        dropdownPadding.PaddingTop = UDim.new(0, 4)
        dropdownPadding.PaddingBottom = UDim.new(0, 4)
        dropdownPadding.PaddingLeft = UDim.new(0, 4)
        dropdownPadding.PaddingRight = UDim.new(0, 4)
        dropdownPadding.Parent = dropdownContainer
        
        local opened = false
        local selectedValues = {}
        if config.flag then IcarusCore.Flags[config.flag] = config.multi and {} or nil end
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.15)
            
            local targetHeight = opened and math.min(#config.options * 26 + 8, 130) or 0
            TweenObject(dropdownContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.18)
            dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, #config.options * 26 + 8)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 24)
            optionButton.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 10
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 51
            optionButton.Parent = dropdownContainer
            CreateCorner(optionButton, 4)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local idx = table.find(selectedValues, option)
                    if idx then
                        table.remove(selectedValues, idx)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Tertiary}, 0.12)
                    else
                        table.insert(selectedValues, option)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.12)
                    end
                    if config.flag then IcarusCore.Flags[config.flag] = selectedValues end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            TweenObject(btn, {BackgroundColor3 = IcarusCore.Themes[theme].Tertiary}, 0.12)
                        end
                    end
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.12)
                    if config.flag then IcarusCore.Flags[config.flag] = option end
                end
                
                if config.callback then
                    config.callback(config.multi and selectedValues or selectedValues[1])
                end
            end)
        end
        
        return {Frame = dropdownFrame, GetValue = function() return config.multi and selectedValues or selectedValues[1] end}
        
    elseif elementType == "Textbox" then
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "Textbox"
        textboxFrame.Size = UDim2.new(1, 0, 0, 30)
        textboxFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        textboxFrame.BorderSizePixel = 0
        textboxFrame.Parent = parent
        CreateCorner(textboxFrame, 5)
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Size = UDim2.new(0.35, 0, 1, 0)
        textboxLabel.Position = UDim2.new(0, 8, 0, 0)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = config.text
        textboxLabel.TextColor3 = IcarusCore.Themes[theme].Text
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextSize = 11
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.6, 0, 0, 22)
        textbox.Position = UDim2.new(0.37, 0, 0.5, -11)
        textbox.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        textbox.BorderSizePixel = 0
        textbox.Text = config.default or ""
        textbox.PlaceholderText = config.placeholder or "..."
        textbox.TextColor3 = IcarusCore.Themes[theme].Text
        textbox.PlaceholderColor3 = IcarusCore.Themes[theme].TextDim
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 10
        textbox.ClearTextOnFocus = false
        textbox.Parent = textboxFrame
        CreateCorner(textbox, 4)
        
        if config.flag then IcarusCore.Flags[config.flag] = textbox.Text end
        
        textbox.FocusLost:Connect(function()
            if config.flag then IcarusCore.Flags[config.flag] = textbox.Text end
            if config.callback then config.callback(textbox.Text) end
        end)
        
        return {
            Frame = textboxFrame,
            SetValue = function(v)
                textbox.Text = v
                if config.flag then IcarusCore.Flags[config.flag] = v end
            end,
            GetValue = function()
                return textbox.Text
            end
        }
        
    elseif elementType == "Colorpicker" then
        local colorFrame = Instance.new("Frame")
        colorFrame.Name = "Colorpicker"
        colorFrame.Size = UDim2.new(1, 0, 0, 30)
        colorFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        colorFrame.BorderSizePixel = 0
        colorFrame.Parent = parent
        CreateCorner(colorFrame, 5)
        
        local colorLabel = Instance.new("TextLabel")
        colorLabel.Size = UDim2.new(1, -52, 1, 0)
        colorLabel.Position = UDim2.new(0, 8, 0, 0)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Text = config.text
        colorLabel.TextColor3 = IcarusCore.Themes[theme].Text
        colorLabel.Font = Enum.Font.Gotham
        colorLabel.TextSize = 11
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = colorFrame
        
        local currentColor = config.default or Color3.fromRGB(59, 130, 246)
        
        local colorDisplay = Instance.new("TextButton")
        colorDisplay.Size = UDim2.new(0, 38, 0, 22)
        colorDisplay.Position = UDim2.new(1, -46, 0.5, -11)
        colorDisplay.BackgroundColor3 = currentColor
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Text = ""
        colorDisplay.AutoButtonColor = false
        colorDisplay.Parent = colorFrame
        CreateCorner(colorDisplay, 4)
        CreateStroke(colorDisplay, IcarusCore.Themes[theme].Border, 1)
        
        if config.flag then IcarusCore.Flags[config.flag] = currentColor end
        
        return {Frame = colorFrame, SetValue = function(c) currentColor = c; colorDisplay.BackgroundColor3 = c end, GetValue = function() return currentColor end}
        
    elseif elementType == "Keybind" then
        local keybindFrame = Instance.new("Frame")
        keybindFrame.Name = "Keybind"
        keybindFrame.Size = UDim2.new(1, 0, 0, 30)
        keybindFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        keybindFrame.BorderSizePixel = 0
        keybindFrame.Parent = parent
        CreateCorner(keybindFrame, 5)
        
        local keybindLabel = Instance.new("TextLabel")
        keybindLabel.Size = UDim2.new(1, -65, 1, 0)
        keybindLabel.Position = UDim2.new(0, 8, 0, 0)
        keybindLabel.BackgroundTransparency = 1
        keybindLabel.Text = config.text
        keybindLabel.TextColor3 = IcarusCore.Themes[theme].Text
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.TextSize = 11
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        keybindLabel.Parent = keybindFrame
        
        local currentKey = config.default or Enum.KeyCode.Unknown
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0, 54, 0, 22)
        keybindButton.Position = UDim2.new(1, -62, 0.5, -11)
        keybindButton.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        keybindButton.BorderSizePixel = 0
        keybindButton.Text = currentKey.Name
        keybindButton.TextColor3 = IcarusCore.Themes[theme].Text
        keybindButton.Font = Enum.Font.GothamBold
        keybindButton.TextSize = 10
        keybindButton.AutoButtonColor = false
        keybindButton.Parent = keybindFrame
        CreateCorner(keybindButton, 4)
        
        if config.flag then IcarusCore.Flags[config.flag] = currentKey end
        
        local listening = false
        
        keybindButton.MouseButton1Click:Connect(function()
            if not listening then
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = IcarusCore.Themes[theme].Accent
                
                local conn
                conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keybindButton.Text = currentKey.Name
                        keybindButton.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
                        listening = false
                        conn:Disconnect()
                        
                        if config.flag then IcarusCore.Flags[config.flag] = currentKey end
                        if config.callback then IcarusCore:AddKeybind(currentKey, config.callback) end
                    end
                end)
            end
        end)
        
        if config.callback and currentKey ~= Enum.KeyCode.Unknown then
            IcarusCore:AddKeybind(currentKey, config.callback)
        end
        
        return {Frame = keybindFrame, GetValue = function() return currentKey end}
        
    elseif elementType == "Label" then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = config.text
        label.TextColor3 = IcarusCore.Themes[theme].Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        
        return {Label = label}
        
    elseif elementType == "Divider" then
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, config.text and 20 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[theme].Border
        divider.BackgroundTransparency = config.text and 1 or 0.5
        divider.BorderSizePixel = 0
        divider.Parent = parent
        
        if config.text then
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.28, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[theme].Border
            line1.BackgroundTransparency = 0.5
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.44, 0, 1, 0)
            label.Position = UDim2.new(0.28, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.text
            label.TextColor3 = IcarusCore.Themes[theme].TextDim
            label.Font = Enum.Font.GothamBold
            label.TextSize = 10
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.28, 0, 0, 1)
            line2.Position = UDim2.new(0.72, 0, 0.5, 0)
            line2.BackgroundColor3 = IcarusCore.Themes[theme].Border
            line2.BackgroundTransparency = 0.5
            line2.BorderSizePixel = 0
            line2.Parent = divider
        end
        
        return {Divider = divider}
    end
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
    task.wait(0.2)
    IcarusCore:Notify({
        text = "Icarus Library",
        description = "Deep Blue Theme - v3.5 Loaded",
        type = "success",
        duration = 2.5
    })
end)

return IcarusLibrary
