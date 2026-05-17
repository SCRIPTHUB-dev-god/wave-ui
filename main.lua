local IcarusLibrary = {}
IcarusLibrary.__index = IcarusLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "IcarusLibrary"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local IcarusCore = {
    Flags = {},
    ConfigPath = "IcarusConfig.json",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(12, 12, 18),
            Corners = Color3.fromRGB(55, 55, 75),
            Text = Color3.fromRGB(255, 255, 255),
            CornersGroupbox = Color3.fromRGB(40, 40, 60),
            BackgroundGroupbox = Color3.fromRGB(18, 18, 28),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentHover = Color3.fromRGB(168, 73, 255),
            Shadow = Color3.fromRGB(0, 0, 0)
        },
        Purple = {
            Background = Color3.fromRGB(20, 10, 30),
            Corners = Color3.fromRGB(75, 45, 95),
            Text = Color3.fromRGB(240, 230, 255),
            CornersGroupbox = Color3.fromRGB(55, 35, 75),
            BackgroundGroupbox = Color3.fromRGB(25, 15, 40),
            Accent = Color3.fromRGB(160, 80, 240),
            AccentHover = Color3.fromRGB(190, 110, 255),
            Shadow = Color3.fromRGB(10, 0, 20)
        }
    },
    CurrentTheme = "Dark",
    Keybinds = {},
    Notifications = {},
    SearchActive = false,
    ToggleButton = nil,
    MainWindow = nil
}

local function CreateBlur(parent, intensity)
    local blur = Instance.new("ImageLabel")
    blur.Name = "AcrylicBlur"
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    blur.ImageTransparency = 1 - (intensity or 0.3)
    blur.ZIndex = -1
    blur.Parent = parent
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 220))
    })
    gradient.Rotation = 45
    gradient.Parent = blur
    
    spawn(function()
        while blur.Parent do
            for i = 0, 360, 2 do
                if not blur.Parent then break end
                gradient.Rotation = i
                task.wait(0.05)
            end
        end
    end)
    
    return blur
end

local function CreateGradient(parent, colors, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(colors)
    gradient.Rotation = rotation or 0
    gradient.Parent = parent
    return gradient
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Transparency = 0.3
    stroke.Parent = parent
    return stroke
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function TweenObject(object, properties, duration, style, direction)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.3,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function CreateRipple(parent, mousePos)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, mousePos.X - parent.AbsolutePosition.X, 0, mousePos.Y - parent.AbsolutePosition.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.ZIndex = 100
    ripple.Parent = parent
    CreateCorner(ripple, 999)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2.5
    TweenObject(ripple, {
        Size = UDim2.new(0, maxSize, 0, maxSize),
        BackgroundTransparency = 1
    }, 0.6, Enum.EasingStyle.Exponential)
    
    task.delay(0.6, function()
        ripple:Destroy()
    end)
end

local function CreateGlow(parent, color, size)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, size or 30, 1, size or 30)
    glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    glow.AnchorPoint = Vector2.new(0.5, 0.5)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5554236805"
    glow.ImageColor3 = color
    glow.ImageTransparency = 0.6
    glow.ScaleType = Enum.ScaleType.Slice
    glow.SliceCenter = Rect.new(23, 23, 277, 277)
    glow.ZIndex = -2
    glow.Parent = parent
    return glow
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
    notification.BackgroundColor3 = self.Themes[self.CurrentTheme].Background
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = notifContainer
    CreateCorner(notification, 10)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Accent, 2)
    CreateGlow(notification, self.Themes[self.CurrentTheme].Accent, 25)
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notification
    CreateGradient(accentBar, {
        self.Themes[self.CurrentTheme].Accent,
        self.Themes[self.CurrentTheme].AccentHover
    }, 90)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -25, 0, 28)
    title.Position = UDim2.new(0, 15, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -25, 0, 40)
    description.Position = UDim2.new(0, 15, 0, 36)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].Text
    description.Font = Enum.Font.Gotham
    description.TextSize = 13
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.TextTransparency = 0.4
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 85)}, 0.4, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        notification:Destroy()
        table.remove(self.Notifications, table.find(self.Notifications, notification))
    end)
end

function IcarusCore:SaveConfig()
    local config = {}
    for flag, value in pairs(self.Flags) do
        config[flag] = value
    end
    writefile(self.ConfigPath, HttpService:JSONEncode(config))
    self:Notify({text = "Configuration Saved", description = "All settings saved successfully", duration = 2})
end

function IcarusCore:LoadConfig()
    if isfile(self.ConfigPath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.ConfigPath))
        end)
        if success and data then
            for flag, value in pairs(data) do
                self.Flags[flag] = value
            end
            self:Notify({text = "Configuration Loaded", description = "Settings restored successfully", duration = 2})
            return true
        end
    end
    return false
end

function IcarusCore:AddKeybind(key, callback)
    table.insert(self.Keybinds, {Key = key, Callback = callback})
end

function IcarusCore:CreateToggleButton(windowRef)
    if self.ToggleButton then
        self.ToggleButton:Destroy()
    end
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle"
    toggleBtn.Size = UDim2.new(0, 55, 0, 55)
    toggleBtn.Position = UDim2.new(0, 20, 0.5, -27)
    toggleBtn.BackgroundColor3 = self.Themes[self.CurrentTheme].Background
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 12)
    CreateStroke(toggleBtn, self.Themes[self.CurrentTheme].Accent, 2.5)
    CreateGlow(toggleBtn, self.Themes[self.CurrentTheme].Accent, 40)
    
    local gradient = CreateGradient(toggleBtn, {
        self.Themes[self.CurrentTheme].Background,
        self.Themes[self.CurrentTheme].Corners
    }, 45)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 30, 0, 30)
    icon.Position = UDim2.new(0.5, -15, 0.5, -15)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7733955511"
    icon.ImageColor3 = self.Themes[self.CurrentTheme].Accent
    icon.Parent = toggleBtn
    
    local pulseGlow = CreateGlow(toggleBtn, self.Themes[self.CurrentTheme].Accent, 50)
    pulseGlow.ImageTransparency = 1
    
    spawn(function()
        while toggleBtn.Parent do
            TweenObject(pulseGlow, {ImageTransparency = 0.4}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
            TweenObject(pulseGlow, {ImageTransparency = 1}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(1.5)
        end
    end)
    
    local clickDetector = Instance.new("TextButton")
    clickDetector.Size = UDim2.new(1, 0, 1, 0)
    clickDetector.BackgroundTransparency = 1
    clickDetector.Text = ""
    clickDetector.Parent = toggleBtn
    
    local isVisible = true
    clickDetector.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        if windowRef then
            windowRef.Visible = isVisible
            
            if isVisible then
                TweenObject(toggleBtn, {
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Background
                }, 0.3)
                TweenObject(icon, {
                    ImageColor3 = self.Themes[self.CurrentTheme].Accent,
                    Rotation = 0
                }, 0.3)
            else
                TweenObject(toggleBtn, {
                    BackgroundColor3 = self.Themes[self.CurrentTheme].Accent
                }, 0.3)
                TweenObject(icon, {
                    ImageColor3 = Color3.fromRGB(255, 255, 255),
                    Rotation = 180
                }, 0.3)
            end
            
            CreateRipple(toggleBtn, Vector2.new(
                toggleBtn.AbsolutePosition.X + toggleBtn.AbsoluteSize.X / 2,
                toggleBtn.AbsolutePosition.Y + toggleBtn.AbsoluteSize.Y / 2
            ))
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 60, 0, 60)}, 0.2, Enum.EasingStyle.Back)
        TweenObject(icon, {Size = UDim2.new(0, 35, 0, 35), Position = UDim2.new(0.5, -17.5, 0.5, -17.5)}, 0.2)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 55, 0, 55)}, 0.2)
        TweenObject(icon, {Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(0.5, -15, 0.5, -15)}, 0.2)
    end)
    
    self.ToggleButton = toggleBtn
    return toggleBtn
end

function IcarusLibrary:SetWindows(config)
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = UDim2.new(0, 650, 0, 450)
    window.Position = UDim2.new(0.5, -325, 0.5, -225)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = false
    window.Parent = ScreenGui
    CreateCorner(window, 14)
    
    if config.transparent then
        window.BackgroundTransparency = config.settransparent or 0.2
        CreateBlur(window, 0.6)
    end
    
    local mainShadow = Instance.new("ImageLabel")
    mainShadow.Name = "Shadow"
    mainShadow.Size = UDim2.new(1, 60, 1, 60)
    mainShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    mainShadow.BackgroundTransparency = 1
    mainShadow.Image = "rbxassetid://5554236805"
    mainShadow.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Shadow
    mainShadow.ImageTransparency = 0.5
    mainShadow.ScaleType = Enum.ScaleType.Slice
    mainShadow.SliceCenter = Rect.new(23, 23, 277, 277)
    mainShadow.ZIndex = -3
    mainShadow.Parent = window
    
    local outerGlow = CreateGlow(window, IcarusCore.Themes[config.theme or "Dark"].Accent, 80)
    outerGlow.ImageTransparency = 0.8
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 45)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Corners
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 14)
    
    local topbarGradient = CreateGradient(topbar, {
        IcarusCore.Themes[config.theme or "Dark"].Corners,
        IcarusCore.Themes[config.theme or "Dark"].Background
    }, 90)
    
    local topbarBottom = Instance.new("Frame")
    topbarBottom.Size = UDim2.new(1, 0, 0, 14)
    topbarBottom.Position = UDim2.new(0, 0, 1, -14)
    topbarBottom.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Corners
    topbarBottom.BorderSizePixel = 0
    topbarBottom.Parent = topbar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -120, 1, 0)
    titleLabel.Position = UDim2.new(0, 18, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 17
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local titleGlow = Instance.new("TextLabel")
    titleGlow.Size = titleLabel.Size
    titleGlow.Position = titleLabel.Position
    titleGlow.BackgroundTransparency = 1
    titleGlow.Text = titleLabel.Text
    titleGlow.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
    titleGlow.Font = titleLabel.Font
    titleGlow.TextSize = titleLabel.TextSize
    titleGlow.TextXAlignment = titleLabel.TextXAlignment
    titleGlow.TextTransparency = 0.8
    titleGlow.ZIndex = 0
    titleGlow.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 80, 0, 22)
    buttonContainer.Position = UDim2.new(1, -95, 0.5, -11)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("Frame")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(0, 58, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    CreateGlow(closeBtn, Color3.fromRGB(255, 95, 86), 15)
    
    local minimizeBtn = Instance.new("Frame")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
    minimizeBtn.Position = UDim2.new(0, 29, 0, 0)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 68)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    CreateGlow(minimizeBtn, Color3.fromRGB(255, 189, 68), 15)
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 22, 0, 22)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 201, 64)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    CreateGlow(toggleBtn, Color3.fromRGB(40, 201, 64), 15)
    
    local closeInput = Instance.new("TextButton")
    closeInput.Size = UDim2.new(1, 0, 1, 0)
    closeInput.BackgroundTransparency = 1
    closeInput.Text = ""
    closeInput.Parent = closeBtn
    
    local minimizeInput = Instance.new("TextButton")
    minimizeInput.Size = UDim2.new(1, 0, 1, 0)
    minimizeInput.BackgroundTransparency = 1
    minimizeInput.Text = ""
    minimizeInput.Parent = minimizeBtn
    
    local toggleInput = Instance.new("TextButton")
    toggleInput.Size = UDim2.new(1, 0, 1, 0)
    toggleInput.BackgroundTransparency = 1
    toggleInput.Text = ""
    toggleInput.Parent = toggleBtn
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 160, 1, -55)
    tabContainer.Position = UDim2.new(0, 10, 0, 55)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].BackgroundGroupbox
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 3
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 10)
    CreateStroke(tabContainer, IcarusCore.Themes[config.theme or "Dark"].CornersGroupbox, 1.5)
    
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
    contentContainer.Size = UDim2.new(1, -180, 1, -55)
    contentContainer.Position = UDim2.new(0, 180, 0, 55)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0, 210, 0, 32)
    searchBox.Position = UDim2.new(1, -225, 0, 6.5)
    searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].BackgroundGroupbox
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "  🔍 Search elements..."
    searchBox.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    searchBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 160)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 13
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = topbar
    CreateCorner(searchBox, 8)
    CreateStroke(searchBox, IcarusCore.Themes[config.theme or "Dark"].Accent, 1)
    
    local dragging = false
    local dragStart, startPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    closeInput.MouseButton1Click:Connect(function()
        CreateRipple(closeBtn, Vector2.new(
            closeBtn.AbsolutePosition.X + closeBtn.AbsoluteSize.X / 2,
            closeBtn.AbsolutePosition.Y + closeBtn.AbsoluteSize.Y / 2
        ))
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        TweenObject(mainShadow, {ImageTransparency = 1}, 0.4)
        task.wait(0.4)
        window:Destroy()
        if IcarusCore.ToggleButton then
            IcarusCore.ToggleButton:Destroy()
        end
    end)
    
    closeInput.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 25, 0, 25)}, 0.2, Enum.EasingStyle.Back)
    end)
    
    closeInput.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 22, 0, 22)}, 0.2)
    end)
    
    local minimized = false
    minimizeInput.MouseButton1Click:Connect(function()
        minimized = not minimized
        CreateRipple(minimizeBtn, Vector2.new(
            minimizeBtn.AbsolutePosition.X + minimizeBtn.AbsoluteSize.X / 2,
            minimizeBtn.AbsolutePosition.Y + minimizeBtn.AbsoluteSize.Y / 2
        ))
        
        if minimized then
            TweenObject(window, {
                Size = UDim2.new(0, 650, 0, 45),
                Position = UDim2.new(0.5, -325, 1, -55)
            }, 0.4, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = UDim2.new(0, 650, 0, 450),
                Position = UDim2.new(0.5, -325, 0.5, -225)
            }, 0.4, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeInput.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 25, 0, 25)}, 0.2, Enum.EasingStyle.Back)
    end)
    
    minimizeInput.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 22, 0, 22)}, 0.2)
    end)
    
    toggleInput.MouseButton1Click:Connect(function()
        CreateRipple(toggleBtn, Vector2.new(
            toggleBtn.AbsolutePosition.X + toggleBtn.AbsoluteSize.X / 2,
            toggleBtn.AbsolutePosition.Y + toggleBtn.AbsoluteSize.Y / 2
        ))
        
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
        task.wait(0.4)
        window.Visible = false
        TweenObject(window, {Size = UDim2.new(0, 650, 0, 450)}, 0.01)
        
        IcarusCore:CreateToggleButton(window)
        IcarusCore:Notify({
            text = "Toggle Mode Activated",
            description = "Use the square button to show/hide the GUI",
            duration = 3
        })
    end)
    
    toggleInput.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 25, 0, 25)}, 0.2, Enum.EasingStyle.Back)
    end)
    
    toggleInput.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 22, 0, 22)}, 0.2)
    end)
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 200
        loadingScreen.Parent = window
        
        local loadingGradient = CreateGradient(loadingScreen, {
            Color3.fromRGB(8, 8, 12),
            Color3.fromRGB(15, 10, 20)
        }, 45)
        
        local particleContainer = Instance.new("Frame")
        particleContainer.Size = UDim2.new(1, 0, 1, 0)
        particleContainer.BackgroundTransparency = 1
        particleContainer.Parent = loadingScreen
        
        for i = 1, 15 do
            local particle = Instance.new("Frame")
            particle.Size = UDim2.new(0, math.random(2, 4), 0, math.random(2, 4))
            particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
            particle.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
            particle.BackgroundTransparency = math.random(30, 70) / 100
            particle.BorderSizePixel = 0
            particle.Parent = particleContainer
            CreateCorner(particle, 999)
            
            spawn(function()
                while particle.Parent do
                    local targetPos = UDim2.new(math.random(), 0, math.random(), 0)
                    TweenObject(particle, {Position = targetPos}, math.random(3, 6), Enum.EasingStyle.Sine)
                    task.wait(math.random(3, 6))
                end
            end)
        end
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 70, 0, 70)
        loadingRing.Position = UDim2.new(0.5, -35, 0.5, -35)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        loadingRing.Parent = loadingScreen
        
        local innerRing = Instance.new("ImageLabel")
        innerRing.Size = UDim2.new(0, 50, 0, 50)
        innerRing.Position = UDim2.new(0.5, -25, 0.5, -25)
        innerRing.BackgroundTransparency = 1
        innerRing.Image = "rbxassetid://4965945816"
        innerRing.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].AccentHover
        innerRing.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 250, 0, 35)
        loadingText.Position = UDim2.new(0.5, -125, 0.5, 50)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading Icarus Library..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 16
        loadingText.Parent = loadingScreen
        
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(0, 0, 0, 3)
        progressBar.Position = UDim2.new(0.5, -100, 0.5, 90)
        progressBar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        progressBar.BorderSizePixel = 0
        progressBar.Parent = loadingScreen
        CreateCorner(progressBar, 999)
        CreateGlow(progressBar, IcarusCore.Themes[config.theme or "Dark"].Accent, 20)
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 2, Enum.EasingStyle.Linear)
                task.wait(2)
                loadingRing.Rotation = 0
            end
        end)
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(innerRing, {Rotation = -360}, 3, Enum.EasingStyle.Linear)
                task.wait(3)
                innerRing.Rotation = 0
            end
        end)
        
        TweenObject(progressBar, {Size = UDim2.new(0, 200, 0, 3)}, 1.8, Enum.EasingStyle.Exponential)
        
        task.delay(2, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.5)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.5)
            TweenObject(innerRing, {ImageTransparency = 1}, 0.5)
            TweenObject(loadingText, {TextTransparency = 1}, 0.5)
            TweenObject(progressBar, {BackgroundTransparency = 1}, 0.5)
            task.wait(0.5)
            loadingScreen:Destroy()
            window.Visible = true
        end)
    else
        window.Visible = true
    end
    
    IcarusCore.MainWindow = window
    
    local windowObj = {
        Window = window,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        Tabs = {},
        CurrentTab = nil,
        Theme = config.theme or "Dark"
    }
    
    setmetatable(windowObj, IcarusLibrary)
    return windowObj
end

function IcarusLibrary:AddTab(config)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = config.text
    tabButton.Size = UDim2.new(1, 0, 0, 38)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].CornersGroupbox
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 8)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 22, 0, 22)
    icon.Position = UDim2.new(0, 12, 0.5, -11)
    icon.BackgroundTransparency = 1
    icon.Image = config.icon or "rbxassetid://7733956210"
    icon.ImageColor3 = IcarusCore.Themes[self.Theme].Text
    icon.Parent = tabButton
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -45, 1, 0)
    label.Position = UDim2.new(0, 40, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text
    label.TextColor3 = IcarusCore.Themes[self.Theme].Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = config.text
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 5
    contentFrame.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 10)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 15)
    padding.Parent = contentFrame
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Button.BackgroundColor3 = IcarusCore.Themes[self.Theme].CornersGroupbox
            tab.Content.Visible = false
            TweenObject(tab.Icon, {ImageColor3 = IcarusCore.Themes[self.Theme].Text}, 0.2)
        end
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        contentFrame.Visible = true
        self.CurrentTab = config.text
        TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
        CreateRipple(tabButton, Vector2.new(
            tabButton.AbsolutePosition.X + tabButton.AbsoluteSize.X / 2,
            tabButton.AbsolutePosition.Y + tabButton.AbsoluteSize.Y / 2
        ))
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners}, 0.2)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].CornersGroupbox}, 0.2)
        end
    end)
    
    local tabObj = {
        Button = tabButton,
        Content = contentFrame,
        Icon = icon,
        Elements = {}
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        contentFrame.Visible = true
        self.CurrentTab = config.text
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    local tabFunctions = {}
    
    function tabFunctions:AddGroupbox(config)
        local groupbox = Instance.new("Frame")
        groupbox.Name = config.text
        groupbox.Size = UDim2.new(1, 0, 0, 55)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        groupbox.BorderSizePixel = 0
        groupbox.Parent = contentFrame
        CreateCorner(groupbox, 10)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].CornersGroupbox, 1.5)
        
        local groupboxIcon = Instance.new("ImageLabel")
        groupboxIcon.Size = UDim2.new(0, 20, 0, 20)
        groupboxIcon.Position = UDim2.new(0, 12, 0, 12)
        groupboxIcon.BackgroundTransparency = 1
        groupboxIcon.Image = config.icon or "rbxassetid://7733955511"
        groupboxIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Accent
        groupboxIcon.Parent = groupbox
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -45, 0, 28)
        groupboxLabel.Position = UDim2.new(0, 38, 0, 8)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 15
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -24, 1, -48)
        groupboxContent.Position = UDim2.new(0, 12, 0, 42)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 8)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 58)
        end)
        
        return {
            Groupbox = groupbox,
            Content = groupboxContent
        }
    end
    
    function tabFunctions:AddLabel(config)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = config.text
        label.TextColor3 = IcarusCore.Themes[self.Theme].Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        return label
    end
    
    function tabFunctions:AddButton(config)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 38)
        button.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.AutoButtonColor = false
        button.Parent = contentFrame
        CreateCorner(button, 8)
        CreateGlow(button, IcarusCore.Themes[self.Theme].Accent, 20)
        
        local buttonGradient = CreateGradient(button, {
            IcarusCore.Themes[self.Theme].Accent,
            IcarusCore.Themes[self.Theme].AccentHover
        }, 90)
        
        button.MouseButton1Click:Connect(function()
            CreateRipple(button, Mouse)
            if config.callback then
                config.callback()
            end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {Size = UDim2.new(1, 0, 0, 40)}, 0.2, Enum.EasingStyle.Back)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {Size = UDim2.new(1, 0, 0, 38)}, 0.2)
        end)
        
        return button
    end
    
    function tabFunctions:AddParagraph(config)
        local paragraph = Instance.new("Frame")
        paragraph.Name = "Paragraph"
        paragraph.Size = UDim2.new(1, 0, 0, 65)
        paragraph.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        paragraph.BorderSizePixel = 0
        paragraph.Parent = contentFrame
        CreateCorner(paragraph, 8)
        CreateStroke(paragraph, IcarusCore.Themes[self.Theme].CornersGroupbox, 1)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -24, 0, 22)
        title.Position = UDim2.new(0, 12, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = config.text
        title.TextColor3 = IcarusCore.Themes[self.Theme].Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = paragraph
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -24, 0, 32)
        desc.Position = UDim2.new(0, 12, 0, 30)
        desc.BackgroundTransparency = 1
        desc.Text = config.description or ""
        desc.TextColor3 = IcarusCore.Themes[self.Theme].Text
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.TextTransparency = 0.4
        desc.Parent = paragraph
        
        return paragraph
    end
    
    function tabFunctions:AddToggle(config)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 38)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = contentFrame
        CreateCorner(toggleFrame, 8)
        CreateStroke(toggleFrame, IcarusCore.Themes[self.Theme].CornersGroupbox, 1)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -65, 1, 0)
        toggleLabel.Position = UDim2.new(0, 12, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 48, 0, 24)
        toggleButton.Position = UDim2.new(1, -60, 0.5, -12)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(50, 50, 70)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.Parent = toggleFrame
        CreateCorner(toggleButton, 999)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 20, 0, 20)
        toggleCircle.Position = config.type and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        CreateCorner(toggleCircle, 999)
        CreateGlow(toggleCircle, Color3.fromRGB(255, 255, 255), 12)
        
        local toggled = config.type or false
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenObject(toggleButton, {
                BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(50, 50, 70)
            }, 0.2)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
            }, 0.2, Enum.EasingStyle.Back)
            if config.callback then
                config.callback(toggled)
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetValue = function(value)
                toggled = value
                TweenObject(toggleButton, {
                    BackgroundColor3 = value and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(50, 50, 70)
                }, 0.2)
                TweenObject(toggleCircle, {
                    Position = value and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
                }, 0.2)
            end
        }
    end
    
    function tabFunctions:AddSlider(config)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 55)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = contentFrame
        CreateCorner(sliderFrame, 8)
        CreateStroke(sliderFrame, IcarusCore.Themes[self.Theme].CornersGroupbox, 1)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -70, 0, 22)
        sliderLabel.Position = UDim2.new(0, 12, 0, 6)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 55, 0, 22)
        valueLabel.Position = UDim2.new(1, -67, 0, 6)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[self.Theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, -24, 0, 7)
        sliderTrack.Position = UDim2.new(0, 12, 1, -18)
        sliderTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderFrame
        CreateCorner(sliderTrack, 999)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        CreateCorner(sliderFill, 999)
        CreateGlow(sliderFill, IcarusCore.Themes[self.Theme].Accent, 15)
        
        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 15, 0, 15)
        sliderDot.Position = UDim2.new(0, -7.5, 0.5, -7.5)
        sliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderDot.BorderSizePixel = 0
        sliderDot.Parent = sliderFill
        CreateCorner(sliderDot, 999)
        CreateGlow(sliderDot, Color3.fromRGB(255, 255, 255), 12)
        
        local sliderInput = Instance.new("TextButton")
        sliderInput.Size = UDim2.new(1, 0, 1, 10)
        sliderInput.Position = UDim2.new(0, 0, 0, -5)
        sliderInput.BackgroundTransparency = 1
        sliderInput.Text = ""
        sliderInput.Parent = sliderTrack
        
        local dragging = false
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = math.floor(config.min + (config.max - config.min) * relativeX)
            valueLabel.Text = tostring(value)
            
            local targetSize = UDim2.new(relativeX, 0, 1, 0)
            if dragging then
                sliderFill.Size = targetSize
            else
                TweenObject(sliderFill, {Size = targetSize}, 0.15)
            end
            
            if config.callback then
                config.callback(value)
            end
        end
        
        sliderInput.MouseButton1Down:Connect(function(x, y)
            dragging = true
            TweenObject(sliderDot, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, -9, 0.5, -9)}, 0.1)
        end)
        
        sliderInput.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                TweenObject(sliderDot, {Size = UDim2.new(0, 15, 0, 15), Position = UDim2.new(0, -7.5, 0.5, -7.5)}, 0.2, Enum.EasingStyle.Back)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        sliderInput.MouseButton1Click:Connect(updateSlider)
        
        local defaultRatio = (config.default - config.min) / (config.max - config.min)
        sliderFill.Size = UDim2.new(defaultRatio, 0, 1, 0)
        
        return sliderFrame
    end
    
    function tabFunctions:AddDropdown(config)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 38)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = false
        dropdownFrame.ZIndex = 10
        dropdownFrame.Parent = contentFrame
        CreateCorner(dropdownFrame, 8)
        CreateStroke(dropdownFrame, IcarusCore.Themes[self.Theme].CornersGroupbox, 1)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 38)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.ZIndex = 11
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -45, 0, 38)
        dropdownLabel.Position = UDim2.new(0, 12, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 13
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.ZIndex = 11
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 18, 0, 18)
        dropdownIcon.Position = UDim2.new(1, -30, 0, 10)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownIcon.Rotation = 0
        dropdownIcon.ZIndex = 11
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownContainer = Instance.new("Frame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 0, 0, 42)
        dropdownContainer.BackgroundColor3 = IcarusCore.Themes[self.Theme].Background
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.ZIndex = 100
        dropdownContainer.Parent = dropdownFrame
        CreateCorner(dropdownContainer, 8)
        CreateStroke(dropdownContainer, IcarusCore.Themes[self.Theme].Accent, 1.5)
        
        local dropdownList = Instance.new("UIListLayout")
        dropdownList.Padding = UDim.new(0, 4)
        dropdownList.Parent = dropdownContainer
        
        local dropdownPadding = Instance.new("UIPadding")
        dropdownPadding.PaddingTop = UDim.new(0, 6)
        dropdownPadding.PaddingBottom = UDim.new(0, 6)
        dropdownPadding.PaddingLeft = UDim.new(0, 6)
        dropdownPadding.PaddingRight = UDim.new(0, 6)
        dropdownPadding.Parent = dropdownContainer
        
        local opened = false
        local selectedValues = {}
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.2)
            
            local targetHeight = opened and math.min(#config.options * 32 + 12, 200) or 0
            TweenObject(dropdownContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.3, Enum.EasingStyle.Back)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 28)
            optionButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[self.Theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 12
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 101
            optionButton.Parent = dropdownContainer
            CreateCorner(optionButton, 6)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local index = table.find(selectedValues, option)
                    if index then
                        table.remove(selectedValues, index)
                        TweenObject(optionButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                    else
                        table.insert(selectedValues, option)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.2)
                    end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            TweenObject(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                        end
                    end
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.2)
                end
                
                if config.callback then
                    config.callback(selectedValues)
                end
            end)
            
            optionButton.MouseEnter:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 60)}, 0.2)
                end
            end)
            
            optionButton.MouseLeave:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}, 0.2)
                end
            end)
        end
        
        return dropdownFrame
    end
    
    function tabFunctions:AddDivider(text)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, text and 28 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners
        divider.BackgroundTransparency = text and 1 or 0.5
        divider.BorderSizePixel = 0
        divider.Parent = contentFrame
        
        if text then
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.35, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.3, 0, 1, 0)
            label.Position = UDim2.new(0.35, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = IcarusCore.Themes[self.Theme].Text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.TextTransparency = 0.5
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.35, 0, 0, 1)
            line2.Position = UDim2.new(0.65, 0, 0.5, 0)
            line2.BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners
            line2.BorderSizePixel = 0
            line2.Parent = divider
        end
        
        return divider
    end
    
    return tabFunctions
end

function IcarusLibrary:AddTheme(themeConfig)
    IcarusCore.Themes.Custom = {
        Background = themeConfig.background and Color3.fromHex(themeConfig.background) or Color3.fromRGB(12, 12, 18),
        Corners = themeConfig.corners and Color3.fromHex(themeConfig.corners) or Color3.fromRGB(55, 55, 75),
        Text = themeConfig.text and Color3.fromHex(themeConfig.text) or Color3.fromRGB(255, 255, 255),
        CornersGroupbox = themeConfig.corners_groupbox and Color3.fromHex(themeConfig.corners_groupbox) or Color3.fromRGB(40, 40, 60),
        BackgroundGroupbox = themeConfig.background_groupbox and Color3.fromHex(themeConfig.background_groupbox) or Color3.fromRGB(18, 18, 28),
        Accent = themeConfig.accent and Color3.fromHex(themeConfig.accent) or Color3.fromRGB(138, 43, 226),
        AccentHover = themeConfig.accent_hover and Color3.fromHex(themeConfig.accent_hover) or Color3.fromRGB(168, 73, 255),
        Shadow = Color3.fromRGB(0, 0, 0)
    }
    IcarusCore.CurrentTheme = "Custom"
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        for _, keybind in pairs(IcarusCore.Keybinds) do
            if input.KeyCode == keybind.Key then
                keybind.Callback()
            end
        end
    end
end)

IcarusCore:Notify({
    text = "Icarus Library Loaded",
    description = "Ultra Premium GUI System - All systems operational",
    duration = 3
})

return IcarusLibrary
