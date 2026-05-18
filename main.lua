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
ScreenGui.DisplayOrder = 999999999
ScreenGui.Parent = CoreGui

local LucideIcons = {
    home = "rbxassetid://10723434711",
    settings = "rbxassetid://10734950309",
    user = "rbxassetid://10734896629",
    shield = "rbxassetid://10723407389",
    zap = "rbxassetid://10747372992",
    box = "rbxassetid://10723343321",
    activity = "rbxassetid://10723345088",
    command = "rbxassetid://10723362834",
    folder = "rbxassetid://10723369706",
    code = "rbxassetid://10723354657",
    cpu = "rbxassetid://10723363863",
    target = "rbxassetid://10723415097",
    eye = "rbxassetid://10723345118",
    star = "rbxassetid://10723434811",
    heart = "rbxassetid://10723370004",
    layers = "rbxassetid://10723385697",
    package = "rbxassetid://10723394478",
    check = "rbxassetid://10723343350",
    x = "rbxassetid://10747384394"
}

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
        },
        Blue = {
            Background = Color3.fromRGB(12, 18, 28),
            Secondary = Color3.fromRGB(18, 24, 36),
            Tertiary = Color3.fromRGB(24, 30, 44),
            Border = Color3.fromRGB(40, 50, 68),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(160, 175, 200),
            Accent = Color3.fromRGB(59, 130, 246),
            AccentHover = Color3.fromRGB(79, 150, 255),
            Success = Color3.fromRGB(34, 197, 94),
            Warning = Color3.fromRGB(251, 191, 36),
            Danger = Color3.fromRGB(239, 68, 68)
        }
    },
    CurrentTheme = "Dark",
    Keybinds = {},
    Notifications = {},
    ToggleButton = nil,
    MainWindow = nil
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = parent
    return corner
end

local function CreateStroke(parent, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness or 1
    stroke.Transparency = 0
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

function IcarusCore:Notify(config)
    local notifContainer = ScreenGui:FindFirstChild("NotificationContainer")
    if not notifContainer then
        notifContainer = Instance.new("Frame")
        notifContainer.Name = "NotificationContainer"
        notifContainer.Size = UDim2.new(0, 280, 1, 0)
        notifContainer.Position = UDim2.new(1, -290, 0, 10)
        notifContainer.BackgroundTransparency = 1
        notifContainer.Parent = ScreenGui
        
        local notifList = Instance.new("UIListLayout")
        notifList.Padding = UDim.new(0, 6)
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
    CreateCorner(notification, 6)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Border, 1)
    
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
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 20)
    title.Position = UDim2.new(0, 12, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Size = UDim2.new(1, -20, 0, 32)
    description.Position = UDim2.new(0, 12, 0, 26)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    description.Font = Enum.Font.Gotham
    description.TextSize = 10
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextYAlignment = Enum.TextYAlignment.Top
    description.TextWrapped = true
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 64)}, 0.25, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
        task.wait(0.2)
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
    dialogBg.BackgroundTransparency = 0.5
    dialogBg.BorderSizePixel = 0
    dialogBg.ZIndex = 200
    dialogBg.Parent = ScreenGui
    
    local dialog = Instance.new("Frame")
    dialog.Name = "Dialog"
    dialog.Size = UDim2.new(0, 300, 0, 140)
    dialog.Position = UDim2.new(0.5, -150, 0.5, -70)
    dialog.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    dialog.BorderSizePixel = 0
    dialog.ZIndex = 201
    dialog.Parent = dialogBg
    CreateCorner(dialog, 8)
    CreateStroke(dialog, self.Themes[self.CurrentTheme].Border, 1)
    
    local dialogTitle = Instance.new("TextLabel")
    dialogTitle.Size = UDim2.new(1, -20, 0, 30)
    dialogTitle.Position = UDim2.new(0, 10, 0, 10)
    dialogTitle.BackgroundTransparency = 1
    dialogTitle.Text = title
    dialogTitle.TextColor3 = self.Themes[self.CurrentTheme].Text
    dialogTitle.Font = Enum.Font.GothamBold
    dialogTitle.TextSize = 14
    dialogTitle.TextXAlignment = Enum.TextXAlignment.Left
    dialogTitle.ZIndex = 202
    dialogTitle.Parent = dialog
    
    local dialogMessage = Instance.new("TextLabel")
    dialogMessage.Size = UDim2.new(1, -20, 0, 40)
    dialogMessage.Position = UDim2.new(0, 10, 0, 45)
    dialogMessage.BackgroundTransparency = 1
    dialogMessage.Text = message
    dialogMessage.TextColor3 = self.Themes[self.CurrentTheme].TextDim
    dialogMessage.Font = Enum.Font.Gotham
    dialogMessage.TextSize = 11
    dialogMessage.TextXAlignment = Enum.TextXAlignment.Left
    dialogMessage.TextYAlignment = Enum.TextYAlignment.Top
    dialogMessage.TextWrapped = true
    dialogMessage.ZIndex = 202
    dialogMessage.Parent = dialog
    
    local yesButton = Instance.new("TextButton")
    yesButton.Size = UDim2.new(0, 130, 0, 32)
    yesButton.Position = UDim2.new(0, 10, 1, -42)
    yesButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Danger
    yesButton.BorderSizePixel = 0
    yesButton.Text = "Yes"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.Font = Enum.Font.GothamBold
    yesButton.TextSize = 12
    yesButton.AutoButtonColor = false
    yesButton.ZIndex = 202
    yesButton.Parent = dialog
    CreateCorner(yesButton, 5)
    
    local noButton = Instance.new("TextButton")
    noButton.Size = UDim2.new(0, 130, 0, 32)
    noButton.Position = UDim2.new(1, -140, 1, -42)
    noButton.BackgroundColor3 = self.Themes[self.CurrentTheme].Tertiary
    noButton.BorderSizePixel = 0
    noButton.Text = "No"
    noButton.TextColor3 = self.Themes[self.CurrentTheme].Text
    noButton.Font = Enum.Font.GothamBold
    noButton.TextSize = 12
    noButton.AutoButtonColor = false
    noButton.ZIndex = 202
    noButton.Parent = dialog
    CreateCorner(noButton, 5)
    
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

function IcarusCore:CreateToggleButton(windowRef)
    if self.ToggleButton then
        self.ToggleButton:Destroy()
    end
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle"
    toggleBtn.Size = UDim2.new(0, 120, 0, 40)
    toggleBtn.Position = UDim2.new(0, 15, 0.5, -20)
    toggleBtn.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 6)
    CreateStroke(toggleBtn, self.Themes[self.CurrentTheme].Accent, 2)
    
    MakeDraggable(toggleBtn)
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Size = UDim2.new(1, -10, 1, 0)
    toggleLabel.Position = UDim2.new(0, 5, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = "Toggle GUI"
    toggleLabel.TextColor3 = self.Themes[self.CurrentTheme].Accent
    toggleLabel.Font = Enum.Font.GothamBold
    toggleLabel.TextSize = 12
    toggleLabel.Parent = toggleBtn
    
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
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary}, 0.15)
                TweenObject(toggleLabel, {TextColor3 = self.Themes[self.CurrentTheme].Accent}, 0.15)
            else
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}, 0.15)
                TweenObject(toggleLabel, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
            end
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 125, 0, 42)}, 0.12, Enum.EasingStyle.Back)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 120, 0, 40)}, 0.12)
    end)
    
    self.ToggleButton = toggleBtn
    return toggleBtn
end

function IcarusLibrary:SetWindows(config)
    local width = 480
    local height = 300
    
    if config.size then
        if type(config.size) == "table" then
            width = config.size[1] or config.size.x or 480
            height = config.size[2] or config.size.y or 300
        end
    end
    
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = UDim2.new(0, width, 0, height)
    window.Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = true
    window.Parent = ScreenGui
    CreateCorner(window, 8)
    CreateStroke(window, IcarusCore.Themes[config.theme or "Dark"].Border, 1)
    
    if config.settransparent and config.settransparent > 0 then
        window.BackgroundTransparency = config.settransparent
    end
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 32)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 8)
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 8)
    topbarCover.Position = UDim2.new(0, 0, 1, -8)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    MakeDraggable(window, topbar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -90, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 60, 0, 16)
    buttonContainer.Position = UDim2.new(1, -70, 0.5, -8)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 16, 0, 16)
    closeBtn.Position = UDim2.new(0, 44, 0, 0)
    closeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 16, 0, 16)
    minimizeBtn.Position = UDim2.new(0, 22, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 16, 0, 16)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 110, 1, -40)
    tabContainer.Position = UDim2.new(0, 6, 0, 38)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 2
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 5)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 3)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local tabPadding = Instance.new("UIPadding")
    tabPadding.PaddingTop = UDim.new(0, 5)
    tabPadding.PaddingBottom = UDim.new(0, 5)
    tabPadding.PaddingLeft = UDim.new(0, 5)
    tabPadding.PaddingRight = UDim.new(0, 5)
    tabPadding.Parent = tabContainer
    
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabList.AbsoluteContentSize.Y + 10)
    end)
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -122, 1, -40)
    contentContainer.Position = UDim2.new(0, 122, 0, 38)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    closeBtn.MouseButton1Click:Connect(function()
        IcarusCore:CreateDialog(
            "Close GUI",
            "Are you sure you want to close this GUI?",
            function(result)
                if result then
                    TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Back)
                    task.wait(0.2)
                    window:Destroy()
                    if IcarusCore.ToggleButton then
                        IcarusCore.ToggleButton:Destroy()
                    end
                end
            end
        )
    end)
    
    closeBtn.MouseEnter:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 43, 0, -1)}, 0.1)
    end)
    
    closeBtn.MouseLeave:Connect(function()
        TweenObject(closeBtn, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 44, 0, 0)}, 0.1)
    end)
    
    local minimized = false
    local originalSize = window.Size
    local originalPos = window.Position
    
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            originalSize = window.Size
            originalPos = window.Position
            TweenObject(window, {
                Size = UDim2.new(0, width, 0, 32),
                Position = UDim2.new(0.5, -width / 2, 1, -42)
            }, 0.2, Enum.EasingStyle.Back)
        else
            TweenObject(window, {
                Size = originalSize,
                Position = originalPos
            }, 0.2, Enum.EasingStyle.Back)
        end
    end)
    
    minimizeBtn.MouseEnter:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, 21, 0, -1)}, 0.1)
    end)
    
    minimizeBtn.MouseLeave:Connect(function()
        TweenObject(minimizeBtn, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 22, 0, 0)}, 0.1)
    end)
    
    toggleBtn.MouseButton1Click:Connect(function()
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Back)
        task.wait(0.2)
        window.Visible = false
        TweenObject(window, {Size = UDim2.new(0, width, 0, height)}, 0.01)
        
        IcarusCore:CreateToggleButton(window)
        IcarusCore:Notify({
            text = "Toggle Mode",
            description = "GUI converted to toggle button",
            type = "success",
            duration = 2
        })
    end)
    
    toggleBtn.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 18, 0, 18), Position = UDim2.new(0, -1, 0, -1)}, 0.1)
    end)
    
    toggleBtn.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 16, 0, 16), Position = UDim2.new(0, 0, 0, 0)}, 0.1)
    end)
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 8)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 40, 0, 40)
        loadingRing.Position = UDim2.new(0.5, -20, 0.5, -20)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 180, 0, 22)
        loadingText.Position = UDim2.new(0.5, -90, 0.5, 28)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 12
        loadingText.Parent = loadingScreen
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1, Enum.EasingStyle.Linear)
                task.wait(1)
                loadingRing.Rotation = 0
            end
        end)
        
        task.delay(1.2, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.25)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.25)
            TweenObject(loadingText, {TextTransparency = 1}, 0.25)
            task.wait(0.25)
            loadingScreen:Destroy()
        end)
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
    tabButton.Size = UDim2.new(1, 0, 0, 28)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
    tabButton.BorderSizePixel = 0
    tabButton.Text = config.text
    tabButton.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
    tabButton.Font = Enum.Font.GothamBold
    tabButton.TextSize = 11
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 4)
    
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
    leftColumn.ScrollBarThickness = 2
    leftColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    leftColumn.Parent = contentFrame
    
    local leftList = Instance.new("UIListLayout")
    leftList.Padding = UDim.new(0, 5)
    leftList.SortOrder = Enum.SortOrder.LayoutOrder
    leftList.Parent = leftColumn
    
    local leftPadding = Instance.new("UIPadding")
    leftPadding.PaddingTop = UDim.new(0, 5)
    leftPadding.PaddingBottom = UDim.new(0, 5)
    leftPadding.PaddingLeft = UDim.new(0, 5)
    leftPadding.PaddingRight = UDim.new(0, 3)
    leftPadding.Parent = leftColumn
    
    leftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        leftColumn.CanvasSize = UDim2.new(0, 0, 0, leftList.AbsoluteContentSize.Y + 10)
    end)
    
    local rightColumn = Instance.new("ScrollingFrame")
    rightColumn.Name = "RightColumn"
    rightColumn.Size = UDim2.new(0.5, -4, 1, 0)
    rightColumn.Position = UDim2.new(0.5, 4, 0, 0)
    rightColumn.BackgroundTransparency = 1
    rightColumn.BorderSizePixel = 0
    rightColumn.ScrollBarThickness = 2
    rightColumn.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    rightColumn.Parent = contentFrame
    
    local rightList = Instance.new("UIListLayout")
    rightList.Padding = UDim.new(0, 5)
    rightList.SortOrder = Enum.SortOrder.LayoutOrder
    rightList.Parent = rightColumn
    
    local rightPadding = Instance.new("UIPadding")
    rightPadding.PaddingTop = UDim.new(0, 5)
    rightPadding.PaddingBottom = UDim.new(0, 5)
    rightPadding.PaddingLeft = UDim.new(0, 3)
    rightPadding.PaddingRight = UDim.new(0, 5)
    rightPadding.Parent = rightColumn
    
    rightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        rightColumn.CanvasSize = UDim2.new(0, 0, 0, rightList.AbsoluteContentSize.Y + 10)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.12)
            TweenObject(tab.Button, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.12)
            tab.Content.Visible = false
        end
        TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.12)
        TweenObject(tabButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.12)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end)
    
    tabButton.MouseEnter:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.1)
        end
    end)
    
    tabButton.MouseLeave:Connect(function()
        if self.CurrentTab ~= config.text then
            TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.1)
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
        groupbox.Size = UDim2.new(1, 0, 0, 40)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        groupbox.BorderSizePixel = 0
        groupbox.Parent = parent
        CreateCorner(groupbox, 5)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].Border, 1)
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -16, 0, 22)
        groupboxLabel.Position = UDim2.new(0, 8, 0, 6)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 11
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -12, 1, -32)
        groupboxContent.Position = UDim2.new(0, 6, 0, 30)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 4)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 40)
        end)
        
        local groupboxFunctions = {
            Groupbox = groupbox,
            Content = groupboxContent,
            Theme = self.Theme
        }
        
        function groupboxFunctions:AddTabbox(config)
            local tabboxFrame = Instance.new("Frame")
            tabboxFrame.Name = "Tabbox"
            tabboxFrame.Size = UDim2.new(1, 0, 0, 26)
            tabboxFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
            tabboxFrame.BorderSizePixel = 0
            tabboxFrame.Parent = groupboxContent
            CreateCorner(tabboxFrame, 4)
            
            local tabboxButtons = Instance.new("Frame")
            tabboxButtons.Name = "Buttons"
            tabboxButtons.Size = UDim2.new(1, -4, 0, 22)
            tabboxButtons.Position = UDim2.new(0, 2, 0, 2)
            tabboxButtons.BackgroundTransparency = 1
            tabboxButtons.Parent = tabboxFrame
            
            local buttonList = Instance.new("UIListLayout")
            buttonList.FillDirection = Enum.FillDirection.Horizontal
            buttonList.Padding = UDim.new(0, 2)
            buttonList.SortOrder = Enum.SortOrder.LayoutOrder
            buttonList.Parent = tabboxButtons
            
            local tabboxContent = Instance.new("Frame")
            tabboxContent.Name = "TabboxContent"
            tabboxContent.Size = UDim2.new(1, 0, 0, 0)
            tabboxContent.Position = UDim2.new(0, 0, 0, 30)
            tabboxContent.BackgroundTransparency = 1
            tabboxContent.Parent = groupboxContent
            
            local tabboxTabs = {}
            local currentTabboxTab = nil
            
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
                CreateCorner(tabButton, 3)
                
                local textSize = game:GetService("TextService"):GetTextSize(
                    tabConfig.text,
                    10,
                    Enum.Font.GothamSemibold,
                    Vector2.new(1000, 1000)
                )
                tabButton.Size = UDim2.new(0, textSize.X + 16, 1, 0)
                
                local tabContent = Instance.new("Frame")
                tabContent.Name = tabConfig.text
                tabContent.Size = UDim2.new(1, 0, 0, 0)
                tabContent.BackgroundTransparency = 1
                tabContent.Visible = false
                tabContent.Parent = tabboxContent
                
                local tabContentList = Instance.new("UIListLayout")
                tabContentList.Padding = UDim.new(0, 4)
                tabContentList.SortOrder = Enum.SortOrder.LayoutOrder
                tabContentList.Parent = tabContent
                
                tabContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                    tabContent.Size = UDim2.new(1, 0, 0, tabContentList.AbsoluteContentSize.Y)
                    
                    local totalHeight = 30
                    for _, tab in pairs(tabboxTabs) do
                        if tab.Content.Visible then
                            totalHeight = totalHeight + tab.Content.AbsoluteSize.Y
                        end
                    end
                    tabboxContent.Size = UDim2.new(1, 0, 0, totalHeight - 30)
                end)
                
                tabButton.MouseButton1Click:Connect(function()
                    for _, tab in pairs(tabboxTabs) do
                        TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.1)
                        TweenObject(tab.Button, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.1)
                        tab.Content.Visible = false
                    end
                    TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.1)
                    TweenObject(tabButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.1)
                    tabContent.Visible = true
                    currentTabboxTab = tabConfig.text
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
                    currentTabboxTab = tabConfig.text
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
        toggleFrame.Size = UDim2.new(1, 0, 0, 28)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        CreateCorner(toggleFrame, 4)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -50, 1, 0)
        toggleLabel.Position = UDim2.new(0, 7, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 10
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 36, 0, 18)
        toggleButton.Position = UDim2.new(1, -43, 0.5, -9)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[theme].Accent or IcarusCore.Themes[theme].Border
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.Parent = toggleFrame
        CreateCorner(toggleButton, 999)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 14, 0, 14)
        toggleCircle.Position = config.type and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
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
            }, 0.12)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
            }, 0.12)
            
            if config.callback then config.callback(toggled) end
        end)
        
        return {Frame = toggleFrame, SetValue = function(v) toggled = v end}
        
    elseif elementType == "Button" then
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 28)
        button.BackgroundColor3 = IcarusCore.Themes[theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 10
        button.AutoButtonColor = false
        button.Parent = parent
        CreateCorner(button, 4)
        
        button.MouseButton1Click:Connect(function()
            if config.callback then config.callback() end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[theme].AccentHover}, 0.1)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.1)
        end)
        
        return {Button = button}
        
    elseif elementType == "Slider" then
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 40)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = parent
        CreateCorner(sliderFrame, 4)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -50, 0, 16)
        sliderLabel.Position = UDim2.new(0, 7, 0, 4)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 10
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 40, 0, 16)
        valueLabel.Position = UDim2.new(1, -47, 0, 4)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 10
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, -14, 0, 4)
        sliderTrack.Position = UDim2.new(0, 7, 1, -11)
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
        
        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 10, 0, 10)
        sliderDot.Position = UDim2.new(1, -5, 0.5, -5)
        sliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderDot.BorderSizePixel = 0
        sliderDot.Parent = sliderFill
        CreateCorner(sliderDot, 999)
        
        local sliderInput = Instance.new("TextButton")
        sliderInput.Size = UDim2.new(1, 0, 1, 4)
        sliderInput.Position = UDim2.new(0, 0, 0, -2)
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
        
        return {Frame = sliderFrame, SetValue = function(v) currentValue = v end}
        
    elseif elementType == "Dropdown" then
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 28)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = false
        dropdownFrame.ZIndex = 5
        dropdownFrame.Parent = parent
        CreateCorner(dropdownFrame, 4)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 28)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.ZIndex = 6
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -30, 0, 28)
        dropdownLabel.Position = UDim2.new(0, 7, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 10
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.ZIndex = 6
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 12, 0, 12)
        dropdownIcon.Position = UDim2.new(1, -19, 0, 8)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[theme].TextDim
        dropdownIcon.Rotation = 0
        dropdownIcon.ZIndex = 6
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownContainer = Instance.new("ScrollingFrame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 0, 0, 32)
        dropdownContainer.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.ScrollBarThickness = 2
        dropdownContainer.ScrollBarImageColor3 = IcarusCore.Themes[theme].Accent
        dropdownContainer.ZIndex = 50
        dropdownContainer.Parent = dropdownFrame
        CreateCorner(dropdownContainer, 4)
        CreateStroke(dropdownContainer, IcarusCore.Themes[theme].Accent, 1)
        
        local dropdownList = Instance.new("UIListLayout")
        dropdownList.Padding = UDim.new(0, 2)
        dropdownList.Parent = dropdownContainer
        
        local dropdownPadding = Instance.new("UIPadding")
        dropdownPadding.PaddingTop = UDim.new(0, 3)
        dropdownPadding.PaddingBottom = UDim.new(0, 3)
        dropdownPadding.PaddingLeft = UDim.new(0, 3)
        dropdownPadding.PaddingRight = UDim.new(0, 3)
        dropdownPadding.Parent = dropdownContainer
        
        local opened = false
        local selectedValues = {}
        if config.flag then IcarusCore.Flags[config.flag] = config.multi and {} or nil end
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.12)
            
            local targetHeight = opened and math.min(#config.options * 24 + 6, 120) or 0
            TweenObject(dropdownContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.15)
            dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, #config.options * 24 + 6)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 22)
            optionButton.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 9
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 51
            optionButton.Parent = dropdownContainer
            CreateCorner(optionButton, 3)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local idx = table.find(selectedValues, option)
                    if idx then
                        table.remove(selectedValues, idx)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Tertiary}, 0.1)
                    else
                        table.insert(selectedValues, option)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.1)
                    end
                    if config.flag then IcarusCore.Flags[config.flag] = selectedValues end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            TweenObject(btn, {BackgroundColor3 = IcarusCore.Themes[theme].Tertiary}, 0.1)
                        end
                    end
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[theme].Accent}, 0.1)
                    if config.flag then IcarusCore.Flags[config.flag] = option end
                end
                
                if config.callback then
                    config.callback(config.multi and selectedValues or selectedValues[1])
                end
            end)
        end
        
        return {Frame = dropdownFrame}
        
    elseif elementType == "Textbox" then
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "Textbox"
        textboxFrame.Size = UDim2.new(1, 0, 0, 28)
        textboxFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        textboxFrame.BorderSizePixel = 0
        textboxFrame.Parent = parent
        CreateCorner(textboxFrame, 4)
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Size = UDim2.new(0.35, 0, 1, 0)
        textboxLabel.Position = UDim2.new(0, 7, 0, 0)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = config.text
        textboxLabel.TextColor3 = IcarusCore.Themes[theme].Text
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextSize = 10
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.6, 0, 0, 20)
        textbox.Position = UDim2.new(0.37, 0, 0.5, -10)
        textbox.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        textbox.BorderSizePixel = 0
        textbox.Text = config.default or ""
        textbox.PlaceholderText = config.placeholder or "..."
        textbox.TextColor3 = IcarusCore.Themes[theme].Text
        textbox.PlaceholderColor3 = IcarusCore.Themes[theme].TextDim
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 9
        textbox.Parent = textboxFrame
        CreateCorner(textbox, 3)
        
        if config.flag then IcarusCore.Flags[config.flag] = textbox.Text end
        
        textbox.FocusLost:Connect(function()
            if config.flag then IcarusCore.Flags[config.flag] = textbox.Text end
            if config.callback then config.callback(textbox.Text) end
        end)
        
        return {Frame = textboxFrame, SetValue = function(v) textbox.Text = v end}
        
    elseif elementType == "Colorpicker" then
        local colorFrame = Instance.new("Frame")
        colorFrame.Name = "Colorpicker"
        colorFrame.Size = UDim2.new(1, 0, 0, 28)
        colorFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        colorFrame.BorderSizePixel = 0
        colorFrame.Parent = parent
        CreateCorner(colorFrame, 4)
        
        local colorLabel = Instance.new("TextLabel")
        colorLabel.Size = UDim2.new(1, -50, 1, 0)
        colorLabel.Position = UDim2.new(0, 7, 0, 0)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Text = config.text
        colorLabel.TextColor3 = IcarusCore.Themes[theme].Text
        colorLabel.Font = Enum.Font.Gotham
        colorLabel.TextSize = 10
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = colorFrame
        
        local currentColor = config.default or Color3.fromRGB(138, 43, 226)
        
        local colorDisplay = Instance.new("TextButton")
        colorDisplay.Size = UDim2.new(0, 36, 0, 20)
        colorDisplay.Position = UDim2.new(1, -43, 0.5, -10)
        colorDisplay.BackgroundColor3 = currentColor
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Text = ""
        colorDisplay.AutoButtonColor = false
        colorDisplay.Parent = colorFrame
        CreateCorner(colorDisplay, 3)
        CreateStroke(colorDisplay, IcarusCore.Themes[theme].Border, 1)
        
        if config.flag then IcarusCore.Flags[config.flag] = currentColor end
        
        return {Frame = colorFrame, SetValue = function(c) currentColor = c; colorDisplay.BackgroundColor3 = c end}
        
    elseif elementType == "Keybind" then
        local keybindFrame = Instance.new("Frame")
        keybindFrame.Name = "Keybind"
        keybindFrame.Size = UDim2.new(1, 0, 0, 28)
        keybindFrame.BackgroundColor3 = IcarusCore.Themes[theme].Tertiary
        keybindFrame.BorderSizePixel = 0
        keybindFrame.Parent = parent
        CreateCorner(keybindFrame, 4)
        
        local keybindLabel = Instance.new("TextLabel")
        keybindLabel.Size = UDim2.new(1, -60, 1, 0)
        keybindLabel.Position = UDim2.new(0, 7, 0, 0)
        keybindLabel.BackgroundTransparency = 1
        keybindLabel.Text = config.text
        keybindLabel.TextColor3 = IcarusCore.Themes[theme].Text
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.TextSize = 10
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        keybindLabel.Parent = keybindFrame
        
        local currentKey = config.default or Enum.KeyCode.Unknown
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0, 50, 0, 20)
        keybindButton.Position = UDim2.new(1, -57, 0.5, -10)
        keybindButton.BackgroundColor3 = IcarusCore.Themes[theme].Secondary
        keybindButton.BorderSizePixel = 0
        keybindButton.Text = currentKey.Name
        keybindButton.TextColor3 = IcarusCore.Themes[theme].Text
        keybindButton.Font = Enum.Font.GothamBold
        keybindButton.TextSize = 9
        keybindButton.AutoButtonColor = false
        keybindButton.Parent = keybindFrame
        CreateCorner(keybindButton, 3)
        
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
        
        return {Frame = keybindFrame}
        
    elseif elementType == "Label" then
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 16)
        label.BackgroundTransparency = 1
        label.Text = config.text
        label.TextColor3 = IcarusCore.Themes[theme].Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = parent
        
        return {Label = label}
        
    elseif elementType == "Divider" then
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, config.text and 18 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[theme].Border
        divider.BackgroundTransparency = config.text and 1 or 0.5
        divider.BorderSizePixel = 0
        divider.Parent = parent
        
        if config.text then
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.25, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[theme].Border
            line1.BackgroundTransparency = 0.5
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.5, 0, 1, 0)
            label.Position = UDim2.new(0.25, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = config.text
            label.TextColor3 = IcarusCore.Themes[theme].TextDim
            label.Font = Enum.Font.GothamBold
            label.TextSize = 9
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.25, 0, 0, 1)
            line2.Position = UDim2.new(0.75, 0, 0.5, 0)
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
        description = "Successfully loaded v3.0",
        type = "success",
        duration = 2
    })
end)

return IcarusLibrary
