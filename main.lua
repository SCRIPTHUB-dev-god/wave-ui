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
    WindowVisible = true,
    LucideIcons = {
        home = "rbxassetid://10723434711",
        settings = "rbxassetid://10734950309",
        user = "rbxassetid://10734943633",
        shield = "rbxassetid://10723407389",
        star = "rbxassetid://10723424505",
        heart = "rbxassetid://10723359328",
        box = "rbxassetid://10723342881",
        menu = "rbxassetid://10723395665",
        search = "rbxassetid://10723407389",
        bell = "rbxassetid://10723345088",
        check = "rbxassetid://10734896302",
        x = "rbxassetid://10747384394",
        plus = "rbxassetid://10723424505",
        minus = "rbxassetid://10723395055",
        edit = "rbxassetid://10734924532",
        trash = "rbxassetid://10723417155",
        download = "rbxassetid://10723356829",
        upload = "rbxassetid://10723404337",
        folder = "rbxassetid://10723345088",
        file = "rbxassetid://10723354532",
        image = "rbxassetid://10723372167",
        code = "rbxassetid://10709790948",
        zap = "rbxassetid://10747377612",
        crown = "rbxassetid://10709791437",
        trophy = "rbxassetid://10723424505",
        target = "rbxassetid://10723417155",
        lock = "rbxassetid://10723387563",
        unlock = "rbxassetid://10723404337",
        eye = "rbxassetid://10723345088",
        eyeoff = "rbxassetid://10723356829",
        info = "rbxassetid://10723366434",
        alert = "rbxassetid://10723345088",
        rocket = "rbxassetid://10723407389",
        flame = "rbxassetid://10723345088",
        gamepad = "rbxassetid://10723359328",
        sword = "rbxassetid://10723417155"
    }
}

local function HexToRgb(hex)
    hex = hex:gsub("#", "")
    local r = tonumber("0x" .. hex:sub(1, 2))
    local g = tonumber("0x" .. hex:sub(3, 4))
    local b = tonumber("0x" .. hex:sub(5, 6))
    return Color3.fromRGB(r, g, b)
end

local function GetLucideIcon(name)
    return IcarusCore.LucideIcons[name] or IcarusCore.LucideIcons.box
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
    toggleFrame.Size = UDim2.new(0, 70, 0, 35)
    toggleFrame.Position = UDim2.new(0.5, -35, 0, 5)
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
        TweenObject(toggleFrame, {Size = UDim2.new(0, 76, 0, 38)}, 0.2, Enum.EasingStyle.Back)
        TweenObject(triangle, {Size = UDim2.new(0, 23, 0, 21)}, 0.2)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleFrame, {Size = UDim2.new(0, 70, 0, 35)}, 0.2)
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
    window.Visible = autoshow
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
    
    CreateGlow(cornerTopRight, IcarusCore.Themes[themeName].Accent, 0.55, 50)
    
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
    
    CreateGlow(cornerBottomLeft, IcarusCore.Themes[themeName].Accent, 0.55, 50)
    
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
        window.Visible = false
        
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
        
        CreateGlow(loadingRing, IcarusCore.Themes[themeName].Accent, 0.65, 35)
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 240, 0, 30)
        loadingText.Position = UDim2.new(0.5, -120, 0.5, 40)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[themeName].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 15
        loadingText.Parent = loadingScreen
        
        window.Visible = true
        
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
            TweenObject(loadingText, {TextTransparency = 1}, 0.45)
            task.wait(0.45)
            loadingScreen:Destroy()
            
            window.Visible = autoshow
            IcarusCore.WindowVisible = autoshow
        end)
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
    local tabButton = Instance.new("TextButton")
    tabButton.Name = config.name
    tabButton.Size = UDim2.new(1, 0, 0, 36)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 8)
    
    if config.icon then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 18, 0, 18)
        icon.Position = UDim2.new(0, 10, 0.5, -9)
        icon.BackgroundTransparency = 1
        icon.Image = GetLucideIcon(config.icon)
        icon.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
        icon.Parent = tabButton
    end
    
    local tabLabel = Instance.new("TextLabel")
    tabLabel.Size = UDim2.new(1, config.icon and -38 or -20, 1, 0)
    tabLabel.Position = UDim2.new(0, config.icon and 32 or 10, 0, 0)
    tabLabel.BackgroundTransparency = 1
    tabLabel.Text = config.name
    tabLabel.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
    tabLabel.Font = Enum.Font.GothamBold
    tabLabel.TextSize = 13
    tabLabel.TextXAlignment = Enum.TextXAlignment.Left
    tabLabel.Parent = tabButton
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = config.name
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local leftColumn = Instance.new("ScrollingFrame")
    leftColumn.Name = "LeftColumn"
    leftColumn.Size = UDim2.new(0.5, -5, 1, 0)
    leftColumn.Position = UDim2.new(0, 0, 0, 0)
    leftColumn.BackgroundTransparency = 1
    leftColumn.BorderSizePixel = 0
    leftColumn.ScrollBarThickness = 5
    leftColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    leftColumn.Parent = contentFrame
    
    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, 8)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Parent = leftColumn
    
    local leftPadding = Instance.new("UIPadding")
    leftPadding.PaddingTop = UDim.new(0, 8)
    leftPadding.PaddingBottom = UDim.new(0, 8)
    leftPadding.PaddingLeft = UDim.new(0, 8)
    leftPadding.PaddingRight = UDim.new(0, 4)
    leftPadding.Parent = leftColumn
    
    leftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftList.AbsoluteContentSize.Y + 16)
    end)
    
    local rightColumn = Instance.new("ScrollingFrame")
    rightColumn.Name = "RightColumn"
    rightColumn.Size = UDim2.new(0.5, -5, 1, 0)
    rightColumn.Position = UDim2.new(0.5, 5, 0, 0)
    rightColumn.BackgroundTransparency = 1
    rightColumn.BorderSizePixel = 0
    rightColumn.ScrollBarThickness = 5
    rightColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    rightColumn.Parent = contentFrame
    
    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, 8)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Parent = rightColumn
    
    local rightPadding = Instance.new("UIPadding")
    rightPadding.PaddingTop = UDim.new(0, 8)
    rightPadding.PaddingBottom = UDim.new(0, 8)
    rightPadding.PaddingLeft = UDim.new(0, 4)
    rightPadding.PaddingRight = UDim.new(0, 8)
    rightPadding.Parent = rightColumn
    
    rightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightList.AbsoluteContentSize.Y + 16)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.18)
            TweenObject(tab.Label, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.18)
            if tab.Icon then
                TweenObject(tab.Icon, {ImageColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.18)
            end
            tab.Content.Visible = false
        end
        TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.18)
        TweenObject(tabLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.18)
        if config.icon then
            local icon = tabButton:FindFirstChild("ImageLabel")
            if icon then
                TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.18)
            end
        end
        contentFrame.Visible = true
        self.CurrentTab = config.name
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= config.name then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= config.name then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
        end
    end)
    
    local tabObj = {
        Button = tabButton,
        Label = tabLabel,
        Icon = config.icon and tabButton:FindFirstChild("ImageLabel") or nil,
        Content = contentFrame,
        LeftColumn = leftColumn,
        RightColumn = rightColumn,
        Theme = self.Theme
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        tabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        if config.icon then
            local icon = tabButton:FindFirstChild("ImageLabel")
            if icon then
                icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
        contentFrame.Visible = true
        self.CurrentTab = config.name
    end
    
    local tabFunctions = {
        Theme = self.Theme,
        LeftColumn = leftColumn,
        RightColumn = rightColumn
    }
    
    function tabFunctions:AddLeftGroupbox(cfg)
        return self:CreateGroupbox(cfg, self.LeftColumn)
    end
    
    function tabFunctions:AddRightGroupbox(cfg)
        return self:CreateGroupbox(cfg, self.RightColumn)
    end
    
    function tabFunctions:CreateGroupbox(cfg, parent)
        local groupbox = Instance.new("Frame")
        groupbox.Name = cfg.name
        groupbox.Size = UDim2.new(1, 0, 0, 48)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        groupbox.BorderSizePixel = 0
        groupbox.Parent = parent
        CreateCorner(groupbox, 10)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].Border, 1.8)
        
        CreateGradient(groupbox, {
            IcarusCore.Themes[self.Theme].Secondary,
            IcarusCore.Themes[self.Theme].Tertiary
        }, 90)
        
        CreateLightReflection(groupbox, UDim2.new(0.7, 0, 0.32, 0))
        
        local headerFrame = Instance.new("Frame")
        headerFrame.Size = UDim2.new(1, 0, 0, 30)
        headerFrame.BackgroundTransparency = 1
        headerFrame.Parent = groupbox
        
        if cfg.icon then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.new(0, 16, 0, 16)
            icon.Position = UDim2.new(0, 10, 0, 7)
            icon.BackgroundTransparency = 1
            icon.Image = GetLucideIcon(cfg.icon)
            icon.ImageColor3 = IcarusCore.Themes[self.Theme].Accent
            icon.Parent = headerFrame
        end
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, cfg.icon and -36 or -20, 0, 30)
        groupboxLabel.Position = UDim2.new(0, cfg.icon and 30 or 10, 0, 0)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = cfg.name
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 14
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = headerFrame
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -16, 1, -38)
        groupboxContent.Position = UDim2.new(0, 8, 0, 36)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 7)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 48)
        end)
        
        local groupboxFunctions = {
            Groupbox = groupbox,
            Content = groupboxContent,
            Theme = self.Theme
        }
        
        function groupboxFunctions:AddLabel(cfg)
            local label = Instance.new("TextLabel")
            label.Name = "Label"
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.Text = cfg.text
            label.TextColor3 = IcarusCore.Themes[self.Theme].Text
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = self.Content
            return label
        end
        
        function groupboxFunctions:AddButton(cfg)
            local button = Instance.new("TextButton")
            button.Name = "Button"
            button.Size = UDim2.new(1, 0, 0, 32)
            button.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            button.BorderSizePixel = 0
            button.Text = cfg.text
            button.TextColor3 = IcarusCore.Themes[self.Theme].Text
            button.Font = Enum.Font.GothamBold
            button.TextSize = 13
            button.AutoButtonColor = false
            button.Parent = self.Content
            CreateCorner(button, 7)
            CreateStroke(button, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            button.MouseButton1Click:Connect(function()
                TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.1)
                task.wait(0.1)
                TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.1)
                if cfg.callback then
                    cfg.callback()
                end
            end)
            
            button.MouseEnter:Connect(function()
                TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.15)
            end)
            
            button.MouseLeave:Connect(function()
                TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
            end)
            
            return button
        end
        
        function groupboxFunctions:AddParagraph(cfg)
            local paragraphFrame = Instance.new("Frame")
            paragraphFrame.Name = "Paragraph"
            paragraphFrame.Size = UDim2.new(1, 0, 0, 50)
            paragraphFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            paragraphFrame.BorderSizePixel = 0
            paragraphFrame.Parent = self.Content
            CreateCorner(paragraphFrame, 7)
            CreateStroke(paragraphFrame, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -16, 0, 18)
            titleLabel.Position = UDim2.new(0, 8, 0, 6)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = cfg.text
            titleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.TextSize = 13
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.Parent = paragraphFrame
            
            local descLabel = Instance.new("TextLabel")
            descLabel.Size = UDim2.new(1, -16, 0, 24)
            descLabel.Position = UDim2.new(0, 8, 0, 24)
            descLabel.BackgroundTransparency = 1
            descLabel.Text = cfg.description
            descLabel.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
            descLabel.Font = Enum.Font.Gotham
            descLabel.TextSize = 11
            descLabel.TextXAlignment = Enum.TextXAlignment.Left
            descLabel.TextYAlignment = Enum.TextYAlignment.Top
            descLabel.TextWrapped = true
            descLabel.Parent = paragraphFrame
            
            return paragraphFrame
        end
        
        function groupboxFunctions:AddToggle(cfg)
            local toggleFrame = Instance.new("Frame")
            toggleFrame.Name = "Toggle"
            toggleFrame.Size = UDim2.new(1, 0, 0, 32)
            toggleFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            toggleFrame.BorderSizePixel = 0
            toggleFrame.Parent = self.Content
            CreateCorner(toggleFrame, 7)
            CreateStroke(toggleFrame, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            local toggleLabel = Instance.new("TextLabel")
            toggleLabel.Size = UDim2.new(1, -50, 1, 0)
            toggleLabel.Position = UDim2.new(0, 10, 0, 0)
            toggleLabel.BackgroundTransparency = 1
            toggleLabel.Text = cfg.text
            toggleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
            toggleLabel.Font = Enum.Font.Gotham
            toggleLabel.TextSize = 12
            toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            toggleLabel.Parent = toggleFrame
            
            local toggled = cfg.default or false
            
            local toggleButton = Instance.new("TextButton")
            toggleButton.Size = UDim2.new(0, 38, 0, 20)
            toggleButton.Position = UDim2.new(1, -44, 0.5, -10)
            toggleButton.BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Success or IcarusCore.Themes[self.Theme].Border
            toggleButton.BorderSizePixel = 0
            toggleButton.Text = ""
            toggleButton.AutoButtonColor = false
            toggleButton.Parent = toggleFrame
            CreateCorner(toggleButton, 999)
            
            local toggleIndicator = Instance.new("Frame")
            toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
            toggleIndicator.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            toggleIndicator.BorderSizePixel = 0
            toggleIndicator.Parent = toggleButton
            CreateCorner(toggleIndicator, 999)
            
            toggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                TweenObject(toggleButton, {
                    BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Success or IcarusCore.Themes[self.Theme].Border
                }, 0.2)
                TweenObject(toggleIndicator, {
                    Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, 0.2, Enum.EasingStyle.Back)
                if cfg.callback then
                    cfg.callback(toggled)
                end
            end)
            
            return toggleFrame
        end
        
        function groupboxFunctions:AddSlider(cfg)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Name = "Slider"
            sliderFrame.Size = UDim2.new(1, 0, 0, 42)
            sliderFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            sliderFrame.BorderSizePixel = 0
            sliderFrame.Parent = self.Content
            CreateCorner(sliderFrame, 7)
            CreateStroke(sliderFrame, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            local sliderLabel = Instance.new("TextLabel")
            sliderLabel.Size = UDim2.new(1, -50, 0, 16)
            sliderLabel.Position = UDim2.new(0, 10, 0, 6)
            sliderLabel.BackgroundTransparency = 1
            sliderLabel.Text = cfg.text
            sliderLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
            sliderLabel.Font = Enum.Font.Gotham
            sliderLabel.TextSize = 12
            sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            sliderLabel.Parent = sliderFrame
            
            local sliderValue = Instance.new("TextLabel")
            sliderValue.Size = UDim2.new(0, 40, 0, 16)
            sliderValue.Position = UDim2.new(1, -46, 0, 6)
            sliderValue.BackgroundTransparency = 1
            sliderValue.Text = tostring(cfg.default or cfg.min)
            sliderValue.TextColor3 = IcarusCore.Themes[self.Theme].Accent
            sliderValue.Font = Enum.Font.GothamBold
            sliderValue.TextSize = 12
            sliderValue.TextXAlignment = Enum.TextXAlignment.Right
            sliderValue.Parent = sliderFrame
            
            local sliderBar = Instance.new("Frame")
            sliderBar.Size = UDim2.new(1, -20, 0, 6)
            sliderBar.Position = UDim2.new(0, 10, 1, -14)
            sliderBar.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            sliderBar.BorderSizePixel = 0
            sliderBar.Parent = sliderFrame
            CreateCorner(sliderBar, 999)
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0, 0, 1, 0)
            sliderFill.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBar
            CreateCorner(sliderFill, 999)
            
            local currentValue = cfg.default or cfg.min
            local percentage = (currentValue - cfg.min) / (cfg.max - cfg.min)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            
            local dragging = false
            
            sliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = true
                end
            end)
            
            sliderBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    local mousePos = input.Position.X
                    local barPos = sliderBar.AbsolutePosition.X
                    local barSize = sliderBar.AbsoluteSize.X
                    local percentage = math.clamp((mousePos - barPos) / barSize, 0, 1)
                    currentValue = math.floor(cfg.min + (cfg.max - cfg.min) * percentage)
                    sliderValue.Text = tostring(currentValue)
                    TweenObject(sliderFill, {Size = UDim2.new(percentage, 0, 1, 0)}, 0.1)
                    if cfg.callback then
                        cfg.callback(currentValue)
                    end
                end
            end)
            
            return sliderFrame
        end
        
        function groupboxFunctions:AddDropdown(cfg)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Name = "Dropdown"
            dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
            dropdownFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            dropdownFrame.BorderSizePixel = 0
            dropdownFrame.Parent = self.Content
            CreateCorner(dropdownFrame, 7)
            CreateStroke(dropdownFrame, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            local dropdownLabel = Instance.new("TextLabel")
            dropdownLabel.Size = UDim2.new(1, -30, 1, 0)
            dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
            dropdownLabel.BackgroundTransparency = 1
            dropdownLabel.Text = cfg.text
            dropdownLabel.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
            dropdownLabel.Font = Enum.Font.Gotham
            dropdownLabel.TextSize = 12
            dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            dropdownLabel.Parent = dropdownFrame
            
            local dropdownArrow = Instance.new("ImageLabel")
            dropdownArrow.Size = UDim2.new(0, 14, 0, 14)
            dropdownArrow.Position = UDim2.new(1, -20, 0.5, -7)
            dropdownArrow.BackgroundTransparency = 1
            dropdownArrow.Image = "rbxassetid://7733992358"
            dropdownArrow.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
            dropdownArrow.Rotation = 180
            dropdownArrow.Parent = dropdownFrame
            
            return dropdownFrame
        end
        
        function groupboxFunctions:AddDivider()
            local divider = Instance.new("Frame")
            divider.Name = "Divider"
            divider.Size = UDim2.new(1, 0, 0, 1)
            divider.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            divider.BorderSizePixel = 0
            divider.Parent = self.Content
            return divider
        end
        
        function groupboxFunctions:AddTextbox(cfg)
            local textboxFrame = Instance.new("Frame")
            textboxFrame.Name = "Textbox"
            textboxFrame.Size = UDim2.new(1, 0, 0, 32)
            textboxFrame.BackgroundTransparency = 1
            textboxFrame.Parent = self.Content
            
            local textbox = Instance.new("TextBox")
            textbox.Size = UDim2.new(1, 0, 1, 0)
            textbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            textbox.BorderSizePixel = 0
            textbox.Text = ""
            textbox.PlaceholderText = cfg.placeholder or "Enter text..."
            textbox.TextColor3 = IcarusCore.Themes[self.Theme].Text
            textbox.PlaceholderColor3 = IcarusCore.Themes[self.Theme].TextDim
            textbox.Font = Enum.Font.Gotham
            textbox.TextSize = 12
            textbox.TextXAlignment = Enum.TextXAlignment.Left
            textbox.Parent = textboxFrame
            CreateCorner(textbox, 7)
            CreateStroke(textbox, IcarusCore.Themes[self.Theme].Border, 1.5)
            
            local textboxPadding = Instance.new("UIPadding")
            textboxPadding.PaddingLeft = UDim.new(0, 10)
            textboxPadding.PaddingRight = UDim.new(0, 10)
            textboxPadding.Parent = textbox
            
            textbox.FocusLost:Connect(function(enter)
                if enter and cfg.callback then
                    cfg.callback(textbox.Text)
                end
            end)
            
            return textboxFrame
        end
        
        return groupboxFunctions
    end
    
    return tabFunctions
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
    task.wait(0.5)
    IcarusCore:Notify({
        text = "Icarus Library Premium",
        description = "Full Element System • v5.0",
        type = "success",
        duration = 3.5
    })
end)

return IcarusLibrary
