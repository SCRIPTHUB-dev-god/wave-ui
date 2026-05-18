local IcarusLibrary = {}
IcarusLibrary.__index = IcarusLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

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
            Background = Color3.fromRGB(18, 18, 24),
            Secondary = Color3.fromRGB(24, 24, 32),
            Tertiary = Color3.fromRGB(32, 32, 42),
            Border = Color3.fromRGB(45, 45, 60),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 180, 200),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentHover = Color3.fromRGB(158, 63, 246),
            AccentDark = Color3.fromRGB(118, 23, 206),
            Success = Color3.fromRGB(40, 201, 64),
            Warning = Color3.fromRGB(255, 189, 68),
            Danger = Color3.fromRGB(255, 95, 86),
            Info = Color3.fromRGB(52, 152, 219)
        },
        Purple = {
            Background = Color3.fromRGB(22, 15, 32),
            Secondary = Color3.fromRGB(28, 20, 40),
            Tertiary = Color3.fromRGB(35, 25, 50),
            Border = Color3.fromRGB(60, 40, 85),
            Text = Color3.fromRGB(245, 240, 255),
            TextDim = Color3.fromRGB(190, 180, 210),
            Accent = Color3.fromRGB(160, 80, 240),
            AccentHover = Color3.fromRGB(180, 100, 255),
            AccentDark = Color3.fromRGB(140, 60, 220),
            Success = Color3.fromRGB(50, 211, 74),
            Warning = Color3.fromRGB(255, 199, 78),
            Danger = Color3.fromRGB(255, 105, 96),
            Info = Color3.fromRGB(62, 162, 229)
        },
        Blue = {
            Background = Color3.fromRGB(15, 20, 28),
            Secondary = Color3.fromRGB(20, 26, 36),
            Tertiary = Color3.fromRGB(26, 33, 45),
            Border = Color3.fromRGB(40, 55, 75),
            Text = Color3.fromRGB(255, 255, 255),
            TextDim = Color3.fromRGB(180, 190, 210),
            Accent = Color3.fromRGB(52, 152, 219),
            AccentHover = Color3.fromRGB(72, 172, 239),
            AccentDark = Color3.fromRGB(32, 132, 199),
            Success = Color3.fromRGB(40, 201, 64),
            Warning = Color3.fromRGB(255, 189, 68),
            Danger = Color3.fromRGB(255, 95, 86),
            Info = Color3.fromRGB(52, 152, 219)
        }
    },
    CurrentTheme = "Dark",
    Keybinds = {},
    Notifications = {},
    ToggleButton = nil,
    MainWindow = nil,
    Watermark = nil,
    FpsCounter = nil,
    Elements = {}
}

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
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

local function TweenObject(object, properties, duration, style, direction)
    if not object or not object.Parent then return end
    local tween = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.25,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    tween:Play()
    return tween
end

local function CreateShadow(parent)
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = parent.ZIndex - 1
    shadow.Parent = parent
    return shadow
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
    
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            TweenObject(frame, {
                Position = UDim2.new(
                    framePos.X.Scale,
                    framePos.X.Offset + delta.X,
                    framePos.Y.Scale,
                    framePos.Y.Offset + delta.Y
                )
            }, 0.1)
        end
    end)
end

local function GetTextSize(text, font, textSize)
    local params = Instance.new("GetTextBoundsParams")
    params.Text = text
    params.Font = font
    params.Size = textSize
    params.Width = math.huge
    return TextService:GetTextBoundsAsync(params)
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
    
    local typeColor = self.Themes[self.CurrentTheme].Info
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
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 12, 0, 8)
    icon.BackgroundTransparency = 1
    icon.ImageColor3 = typeColor
    icon.Parent = notification
    
    if config.type == "success" then
        icon.Image = "rbxassetid://7733955511"
    elseif config.type == "warning" then
        icon.Image = "rbxassetid://7743873633"
    elseif config.type == "error" then
        icon.Image = "rbxassetid://7743878857"
    else
        icon.Image = "rbxassetid://7733911816"
    end
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -45, 0, 24)
    title.Position = UDim2.new(0, 35, 0, 6)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Name = "Description"
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
    
    TweenObject(notification, {Size = UDim2.new(1, 0, 0, 72)}, 0.3, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        task.wait(0.25)
        if notification.Parent then
            notification:Destroy()
        end
        local index = table.find(self.Notifications, notification)
        if index then
            table.remove(self.Notifications, index)
        end
    end)
end

function IcarusCore:SaveConfig()
    local config = {}
    for flag, value in pairs(self.Flags) do
        if type(value) == "table" then
            config[flag] = value
        elseif type(value) == "Color3" then
            config[flag] = {value.R, value.G, value.B}
        else
            config[flag] = value
        end
    end
    writefile(self.ConfigPath, HttpService:JSONEncode(config))
    self:Notify({
        text = "Configuration Saved",
        description = "All settings saved successfully",
        type = "success",
        duration = 2
    })
end

function IcarusCore:LoadConfig()
    if isfile(self.ConfigPath) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(self.ConfigPath))
        end)
        if success and data then
            for flag, value in pairs(data) do
                if type(value) == "table" and #value == 3 then
                    self.Flags[flag] = Color3.new(value[1], value[2], value[3])
                else
                    self.Flags[flag] = value
                end
            end
            self:Notify({
                text = "Configuration Loaded",
                description = "Settings restored successfully",
                type = "success",
                duration = 2
            })
            return true
        end
    end
    return false
end

function IcarusCore:AddKeybind(key, callback)
    table.insert(self.Keybinds, {Key = key, Callback = callback})
end

function IcarusCore:RemoveKeybind(key)
    for i, keybind in ipairs(self.Keybinds) do
        if keybind.Key == key then
            table.remove(self.Keybinds, i)
            return true
        end
    end
    return false
end

function IcarusCore:CreateToggleButton(windowRef)
    if self.ToggleButton then
        self.ToggleButton:Destroy()
    end
    
    local toggleBtn = Instance.new("Frame")
    toggleBtn.Name = "IcarusToggle"
    toggleBtn.Size = UDim2.new(0, 45, 0, 45)
    toggleBtn.Position = UDim2.new(0, 15, 0.5, -22)
    toggleBtn.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Active = true
    toggleBtn.Parent = ScreenGui
    CreateCorner(toggleBtn, 8)
    CreateStroke(toggleBtn, self.Themes[self.CurrentTheme].Accent, 2)
    CreateShadow(toggleBtn)
    
    MakeDraggable(toggleBtn)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 24, 0, 24)
    icon.Position = UDim2.new(0.5, -12, 0.5, -12)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://7734053426"
    icon.ImageColor3 = self.Themes[self.CurrentTheme].Accent
    icon.Parent = toggleBtn
    
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
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary}, 0.2)
                TweenObject(icon, {ImageColor3 = self.Themes[self.CurrentTheme].Accent, Rotation = 0}, 0.2)
            else
                TweenObject(toggleBtn, {BackgroundColor3 = self.Themes[self.CurrentTheme].Accent}, 0.2)
                TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255), Rotation = 90}, 0.2)
            end
        end
    end)
    
    clickDetector.MouseEnter:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 50, 0, 50)}, 0.15, Enum.EasingStyle.Back)
    end)
    
    clickDetector.MouseLeave:Connect(function()
        TweenObject(toggleBtn, {Size = UDim2.new(0, 45, 0, 45)}, 0.15)
    end)
    
    self.ToggleButton = toggleBtn
    return toggleBtn
end

function IcarusCore:CreateWatermark(text)
    if self.Watermark then
        self.Watermark:Destroy()
    end
    
    local watermark = Instance.new("Frame")
    watermark.Name = "Watermark"
    watermark.Size = UDim2.new(0, 200, 0, 30)
    watermark.Position = UDim2.new(0.5, -100, 0, 10)
    watermark.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    watermark.BorderSizePixel = 0
    watermark.Parent = ScreenGui
    CreateCorner(watermark, 6)
    CreateStroke(watermark, self.Themes[self.CurrentTheme].Border, 1)
    
    local watermarkText = Instance.new("TextLabel")
    watermarkText.Size = UDim2.new(1, -20, 1, 0)
    watermarkText.Position = UDim2.new(0, 10, 0, 0)
    watermarkText.BackgroundTransparency = 1
    watermarkText.Text = text or "Icarus Library"
    watermarkText.TextColor3 = self.Themes[self.CurrentTheme].Text
    watermarkText.Font = Enum.Font.GothamBold
    watermarkText.TextSize = 12
    watermarkText.Parent = watermark
    
    self.Watermark = watermark
    return watermark
end

function IcarusCore:CreateFpsCounter()
    if self.FpsCounter then
        self.FpsCounter:Destroy()
    end
    
    local fpsFrame = Instance.new("Frame")
    fpsFrame.Name = "FpsCounter"
    fpsFrame.Size = UDim2.new(0, 80, 0, 30)
    fpsFrame.Position = UDim2.new(1, -90, 0, 10)
    fpsFrame.BackgroundColor3 = self.Themes[self.CurrentTheme].Secondary
    fpsFrame.BorderSizePixel = 0
    fpsFrame.Parent = ScreenGui
    CreateCorner(fpsFrame, 6)
    CreateStroke(fpsFrame, self.Themes[self.CurrentTheme].Border, 1)
    
    local fpsLabel = Instance.new("TextLabel")
    fpsLabel.Size = UDim2.new(1, 0, 1, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: 60"
    fpsLabel.TextColor3 = self.Themes[self.CurrentTheme].Success
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 12
    fpsLabel.Parent = fpsFrame
    
    local lastTime = tick()
    local fps = 60
    
    RunService.RenderStepped:Connect(function()
        local currentTime = tick()
        local delta = currentTime - lastTime
        lastTime = currentTime
        
        fps = math.floor(1 / delta)
        fpsLabel.Text = "FPS: " .. fps
        
        if fps >= 55 then
            fpsLabel.TextColor3 = self.Themes[self.CurrentTheme].Success
        elseif fps >= 30 then
            fpsLabel.TextColor3 = self.Themes[self.CurrentTheme].Warning
        else
            fpsLabel.TextColor3 = self.Themes[self.CurrentTheme].Danger
        end
    end)
    
    self.FpsCounter = fpsFrame
    return fpsFrame
end

function IcarusLibrary:SetWindows(config)
    local windowSize = config.size or UDim2.new(0, 480, 0, 300)
    
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = windowSize
    window.Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 0.5, -windowSize.Y.Offset / 2)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = false
    window.Active = true
    window.Visible = true
    window.Parent = ScreenGui
    CreateCorner(window, 10)
    CreateStroke(window, IcarusCore.Themes[config.theme or "Dark"].Border, 1)
    CreateShadow(window)
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 35)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 10)
    
    local topbarCover = Instance.new("Frame")
    topbarCover.Size = UDim2.new(1, 0, 0, 10)
    topbarCover.Position = UDim2.new(0, 0, 1, -10)
    topbarCover.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    topbarCover.BorderSizePixel = 0
    topbarCover.Parent = topbar
    
    MakeDraggable(window, topbar)
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 12, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
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
    closeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Danger
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 18, 0, 18)
    minimizeBtn.Position = UDim2.new(0, 24, 0, 0)
    minimizeBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Warning
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = ""
    minimizeBtn.AutoButtonColor = false
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(0, 18, 0, 18)
    toggleBtn.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Success
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = ""
    toggleBtn.AutoButtonColor = false
    toggleBtn.Parent = buttonContainer
    CreateCorner(toggleBtn, 999)
    
    local tabContainer = Instance.new("ScrollingFrame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 130, 1, -43)
    tabContainer.Position = UDim2.new(0, 8, 0, 43)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Secondary
    tabContainer.BorderSizePixel = 0
    tabContainer.ScrollBarThickness = 3
    tabContainer.ScrollBarImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
    tabContainer.Parent = window
    CreateCorner(tabContainer, 6)
    
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
    contentContainer.Size = UDim2.new(1, -146, 1, -43)
    contentContainer.Position = UDim2.new(0, 146, 0, 43)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0, 150, 0, 24)
    searchBox.Position = UDim2.new(1, -160, 0, 5.5)
    searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Tertiary
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "  🔍 Search..."
    searchBox.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    searchBox.PlaceholderColor3 = IcarusCore.Themes[config.theme or "Dark"].TextDim
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = topbar
    CreateCorner(searchBox, 5)
    CreateStroke(searchBox, IcarusCore.Themes[config.theme or "Dark"].Border, 1)
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        local searchText = searchBox.Text:lower()
        for _, tab in pairs(contentContainer:GetChildren()) do
            if tab:IsA("ScrollingFrame") then
                for _, element in pairs(tab:GetChildren()) do
                    if element:IsA("GuiObject") and element.Name ~= "UIListLayout" and element.Name ~= "UIPadding" then
                        local textLabel = element:FindFirstChildWhichIsA("TextLabel", true)
                        if textLabel then
                            local elementText = textLabel.Text:lower()
                            element.Visible = searchText == "" or elementText:find(searchText) ~= nil
                        end
                    end
                end
            end
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back)
        task.wait(0.25)
        window:Destroy()
        if IcarusCore.ToggleButton then
            IcarusCore.ToggleButton:Destroy()
        end
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
                Size = UDim2.new(0, windowSize.X.Offset, 0, 35),
                Position = UDim2.new(0.5, -windowSize.X.Offset / 2, 1, -45)
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
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.25, Enum.EasingStyle.Back)
        task.wait(0.25)
        window.Visible = false
        TweenObject(window, {Size = windowSize}, 0.01)
        
        IcarusCore:CreateToggleButton(window)
        IcarusCore:Notify({
            text = "Toggle Mode",
            description = "Use square button to toggle GUI",
            type = "info",
            duration = 2
        })
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
        loadingScreen.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        CreateCorner(loadingScreen, 10)
        
        local loadingRing = Instance.new("ImageLabel")
        loadingRing.Size = UDim2.new(0, 50, 0, 50)
        loadingRing.Position = UDim2.new(0.5, -25, 0.5, -25)
        loadingRing.BackgroundTransparency = 1
        loadingRing.Image = "rbxassetid://4965945816"
        loadingRing.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        loadingRing.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 200, 0, 25)
        loadingText.Position = UDim2.new(0.5, -100, 0.5, 35)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 13
        loadingText.Parent = loadingScreen
        
        local progressBar = Instance.new("Frame")
        progressBar.Size = UDim2.new(0, 0, 0, 2)
        progressBar.Position = UDim2.new(0.5, -80, 0.5, 65)
        progressBar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        progressBar.BorderSizePixel = 0
        progressBar.Parent = loadingScreen
        CreateCorner(progressBar, 999)
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingRing, {Rotation = 360}, 1.2, Enum.EasingStyle.Linear)
                task.wait(1.2)
                loadingRing.Rotation = 0
            end
        end)
        
        TweenObject(progressBar, {Size = UDim2.new(0, 160, 0, 2)}, 1.3)
        
        task.delay(1.5, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.3)
            TweenObject(loadingRing, {ImageTransparency = 1}, 0.3)
            TweenObject(loadingText, {TextTransparency = 1}, 0.3)
            TweenObject(progressBar, {BackgroundTransparency = 1}, 0.3)
            task.wait(0.3)
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
    tabButton.Size = UDim2.new(1, 0, 0, 32)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 5)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 18, 0, 18)
    icon.Position = UDim2.new(0, 8, 0.5, -9)
    icon.BackgroundTransparency = 1
    icon.Image = config.icon or "rbxassetid://7734053426"
    icon.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
    icon.Parent = tabButton
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -35, 1, 0)
    label.Position = UDim2.new(0, 30, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text
    label.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = config.text
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 3
    contentFrame.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer
    
    local contentList = Instance.new("UIListLayout")
    contentList.Padding = UDim.new(0, 6)
    contentList.SortOrder = Enum.SortOrder.LayoutOrder
    contentList.Parent = contentFrame
    
    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 6)
    padding.PaddingBottom = UDim.new(0, 6)
    padding.PaddingLeft = UDim.new(0, 6)
    padding.PaddingRight = UDim.new(0, 8)
    padding.Parent = contentFrame
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 12)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            TweenObject(tab.Button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.15)
            TweenObject(tab.Icon, {ImageColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.15)
            TweenObject(tab.Label, {TextColor3 = IcarusCore.Themes[self.Theme].TextDim}, 0.15)
            tab.Content.Visible = false
        end
        TweenObject(tabButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.15)
        TweenObject(icon, {ImageColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
        TweenObject(label, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.15)
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
        Icon = icon,
        Label = label,
        Elements = {}
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end
    
    local tabFunctions = {Theme = self.Theme}
    
    function tabFunctions:AddGroupbox(config)
        local groupbox = Instance.new("Frame")
        groupbox.Name = config.text
        groupbox.Size = UDim2.new(1, 0, 0, 45)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        groupbox.BorderSizePixel = 0
        groupbox.Parent = contentFrame
        CreateCorner(groupbox, 6)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].Border, 1)
        
        local groupboxIcon = Instance.new("ImageLabel")
        groupboxIcon.Size = UDim2.new(0, 16, 0, 16)
        groupboxIcon.Position = UDim2.new(0, 8, 0, 8)
        groupboxIcon.BackgroundTransparency = 1
        groupboxIcon.Image = config.icon or "rbxassetid://7734053426"
        groupboxIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Accent
        groupboxIcon.Parent = groupbox
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -35, 0, 24)
        groupboxLabel.Position = UDim2.new(0, 28, 0, 6)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 12
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -16, 1, -34)
        groupboxContent.Position = UDim2.new(0, 8, 0, 32)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 5)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 45)
        end)
        
        return {
            Groupbox = groupbox,
            Content = groupboxContent,
            Theme = self.Theme
        }
    end
    
    function tabFunctions:AddLabel(config)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 18)
        label.BackgroundTransparency = 1
        label.Text = config.text
        label.TextColor3 = IcarusCore.Themes[self.Theme].Text
        label.Font = Enum.Font.Gotham
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        return {
            Label = label,
            UpdateText = function(newText)
                label.Text = newText
            end
        }
    end
    
    function tabFunctions:AddButton(config)
        local button = Instance.new("TextButton")
        button.Name = "Button"
        button.Size = UDim2.new(1, 0, 0, 32)
        button.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 12
        button.AutoButtonColor = false
        button.Parent = contentFrame
        CreateCorner(button, 5)
        
        button.MouseButton1Click:Connect(function()
            if config.callback then
                config.callback()
            end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].AccentHover}, 0.12)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.12)
        end)
        
        return {
            Button = button,
            UpdateText = function(newText)
                button.Text = newText
            end
        }
    end
    
    function tabFunctions:AddParagraph(config)
        local paragraph = Instance.new("Frame")
        paragraph.Name = "Paragraph"
        paragraph.Size = UDim2.new(1, 0, 0, 55)
        paragraph.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        paragraph.BorderSizePixel = 0
        paragraph.Parent = contentFrame
        CreateCorner(paragraph, 5)
        CreateStroke(paragraph, IcarusCore.Themes[self.Theme].Border, 1)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -16, 0, 18)
        title.Position = UDim2.new(0, 8, 0, 6)
        title.BackgroundTransparency = 1
        title.Text = config.text
        title.TextColor3 = IcarusCore.Themes[self.Theme].Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 12
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = paragraph
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -16, 0, 28)
        desc.Position = UDim2.new(0, 8, 0, 24)
        desc.BackgroundTransparency = 1
        desc.Text = config.description or ""
        desc.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 10
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextYAlignment = Enum.TextYAlignment.Top
        desc.TextWrapped = true
        desc.Parent = paragraph
        
        return {
            Paragraph = paragraph,
            UpdateTitle = function(newTitle)
                title.Text = newTitle
            end,
            UpdateDescription = function(newDesc)
                desc.Text = newDesc
            end
        }
    end
    
    function tabFunctions:AddToggle(config)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 32)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = contentFrame
        CreateCorner(toggleFrame, 5)
        CreateStroke(toggleFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -55, 1, 0)
        toggleLabel.Position = UDim2.new(0, 8, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 11
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 40, 0, 20)
        toggleButton.Position = UDim2.new(1, -48, 0.5, -10)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
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
        
        if config.flag then
            IcarusCore.Flags[config.flag] = toggled
        end
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            
            if config.flag then
                IcarusCore.Flags[config.flag] = toggled
            end
            
            TweenObject(toggleButton, {
                BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
            }, 0.15)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }, 0.15, Enum.EasingStyle.Quad)
            
            if config.callback then
                config.callback(toggled)
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetValue = function(value)
                toggled = value
                
                if config.flag then
                    IcarusCore.Flags[config.flag] = value
                end
                
                TweenObject(toggleButton, {
                    BackgroundColor3 = value and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Tertiary
                }, 0.15)
                TweenObject(toggleCircle, {
                    Position = value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                }, 0.15)
            end,
            GetValue = function()
                return toggled
            end
        }
    end
    
    function tabFunctions:AddSlider(config)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 45)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = contentFrame
        CreateCorner(sliderFrame, 5)
        CreateStroke(sliderFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -55, 0, 18)
        sliderLabel.Position = UDim2.new(0, 8, 0, 4)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 11
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 45, 0, 18)
        valueLabel.Position = UDim2.new(1, -53, 0, 4)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[self.Theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 11
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Size = UDim2.new(1, -16, 0, 5)
        sliderTrack.Position = UDim2.new(0, 8, 1, -13)
        sliderTrack.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderFrame
        CreateCorner(sliderTrack, 999)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        CreateCorner(sliderFill, 999)
        
        local sliderDot = Instance.new("Frame")
        sliderDot.Size = UDim2.new(0, 12, 0, 12)
        sliderDot.Position = UDim2.new(1, -6, 0.5, -6)
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
        
        if config.flag then
            IcarusCore.Flags[config.flag] = currentValue
        end
        
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            currentValue = math.floor(config.min + (config.max - config.min) * relativeX)
            valueLabel.Text = tostring(currentValue)
            sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            
            if config.flag then
                IcarusCore.Flags[config.flag] = currentValue
            end
            
            if config.callback then
                config.callback(currentValue)
            end
        end
        
        sliderInput.MouseButton1Down:Connect(function()
            dragging = true
            TweenObject(sliderDot, {Size = UDim2.new(0, 14, 0, 14), Position = UDim2.new(1, -7, 0.5, -7)}, 0.08)
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                TweenObject(sliderDot, {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new(1, -6, 0.5, -6)}, 0.12)
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
        
        return {
            Frame = sliderFrame,
            SetValue = function(value)
                currentValue = math.clamp(value, config.min, config.max)
                valueLabel.Text = tostring(currentValue)
                local ratio = (currentValue - config.min) / (config.max - config.min)
                sliderFill.Size = UDim2.new(ratio, 0, 1, 0)
                
                if config.flag then
                    IcarusCore.Flags[config.flag] = currentValue
                end
            end,
            GetValue = function()
                return currentValue
            end
        }
    end
    
    function tabFunctions:AddDropdown(config)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 32)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = false
        dropdownFrame.ZIndex = 5
        dropdownFrame.Parent = contentFrame
        CreateCorner(dropdownFrame, 5)
        CreateStroke(dropdownFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 32)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.ZIndex = 6
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -35, 0, 32)
        dropdownLabel.Position = UDim2.new(0, 8, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 11
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.ZIndex = 6
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 14, 0, 14)
        dropdownIcon.Position = UDim2.new(1, -22, 0, 9)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[self.Theme].TextDim
        dropdownIcon.Rotation = 0
        dropdownIcon.ZIndex = 6
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownContainer = Instance.new("ScrollingFrame")
        dropdownContainer.Name = "DropdownContainer"
        dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
        dropdownContainer.Position = UDim2.new(0, 0, 0, 36)
        dropdownContainer.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        dropdownContainer.BorderSizePixel = 0
        dropdownContainer.ClipsDescendants = true
        dropdownContainer.ScrollBarThickness = 2
        dropdownContainer.ScrollBarImageColor3 = IcarusCore.Themes[self.Theme].Accent
        dropdownContainer.ZIndex = 50
        dropdownContainer.Parent = dropdownFrame
        CreateCorner(dropdownContainer, 5)
        CreateStroke(dropdownContainer, IcarusCore.Themes[self.Theme].Accent, 1)
        
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
        
        if config.flag then
            IcarusCore.Flags[config.flag] = config.multi and {} or nil
        end
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.15)
            
            local targetHeight = opened and math.min(#config.options * 26 + 8, 150) or 0
            TweenObject(dropdownContainer, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2, Enum.EasingStyle.Quad)
            dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, #config.options * 26 + 8)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 24)
            optionButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[self.Theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 10
            optionButton.AutoButtonColor = false
            optionButton.ZIndex = 51
            optionButton.Parent = dropdownContainer
            CreateCorner(optionButton, 4)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local index = table.find(selectedValues, option)
                    if index then
                        table.remove(selectedValues, index)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.12)
                    else
                        table.insert(selectedValues, option)
                        TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.12)
                    end
                    
                    if config.flag then
                        IcarusCore.Flags[config.flag] = selectedValues
                    end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            TweenObject(btn, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.12)
                        end
                    end
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.12)
                    
                    if config.flag then
                        IcarusCore.Flags[config.flag] = option
                    end
                end
                
                if config.callback then
                    config.callback(config.multi and selectedValues or selectedValues[1])
                end
            end)
            
            optionButton.MouseEnter:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary}, 0.12)
                end
            end)
            
            optionButton.MouseLeave:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary}, 0.12)
                end
            end)
        end
        
        return {
            Frame = dropdownFrame,
            SetValue = function(value)
                if config.multi and type(value) == "table" then
                    selectedValues = value
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            if table.find(value, btn.Text) then
                                btn.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
                            else
                                btn.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
                            end
                        end
                    end
                elseif not config.multi then
                    selectedValues = {value}
                    for _, btn in pairs(dropdownContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = btn.Text == value and IcarusCore.Themes[self.Theme].Accent or IcarusCore.Themes[self.Theme].Secondary
                        end
                    end
                end
                
                if config.flag then
                    IcarusCore.Flags[config.flag] = config.multi and selectedValues or value
                end
            end,
            GetValue = function()
                return config.multi and selectedValues or selectedValues[1]
            end
        }
    end
    
    function tabFunctions:AddTextbox(config)
        local textboxFrame = Instance.new("Frame")
        textboxFrame.Name = "Textbox"
        textboxFrame.Size = UDim2.new(1, 0, 0, 32)
        textboxFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        textboxFrame.BorderSizePixel = 0
        textboxFrame.Parent = contentFrame
        CreateCorner(textboxFrame, 5)
        CreateStroke(textboxFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local textboxLabel = Instance.new("TextLabel")
        textboxLabel.Size = UDim2.new(0.4, 0, 1, 0)
        textboxLabel.Position = UDim2.new(0, 8, 0, 0)
        textboxLabel.BackgroundTransparency = 1
        textboxLabel.Text = config.text
        textboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        textboxLabel.Font = Enum.Font.Gotham
        textboxLabel.TextSize = 11
        textboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        textboxLabel.Parent = textboxFrame
        
        local textbox = Instance.new("TextBox")
        textbox.Size = UDim2.new(0.55, 0, 0, 24)
        textbox.Position = UDim2.new(0.42, 0, 0.5, -12)
        textbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        textbox.BorderSizePixel = 0
        textbox.Text = config.default or ""
        textbox.PlaceholderText = config.placeholder or "Enter text..."
        textbox.TextColor3 = IcarusCore.Themes[self.Theme].Text
        textbox.PlaceholderColor3 = IcarusCore.Themes[self.Theme].TextDim
        textbox.Font = Enum.Font.Gotham
        textbox.TextSize = 10
        textbox.Parent = textboxFrame
        CreateCorner(textbox, 4)
        
        if config.flag then
            IcarusCore.Flags[config.flag] = textbox.Text
        end
        
        textbox.FocusLost:Connect(function()
            if config.flag then
                IcarusCore.Flags[config.flag] = textbox.Text
            end
            
            if config.callback then
                config.callback(textbox.Text)
            end
        end)
        
        return {
            Frame = textboxFrame,
            SetValue = function(value)
                textbox.Text = value
                if config.flag then
                    IcarusCore.Flags[config.flag] = value
                end
            end,
            GetValue = function()
                return textbox.Text
            end
        }
    end
    
    function tabFunctions:AddColorpicker(config)
        local colorFrame = Instance.new("Frame")
        colorFrame.Name = "Colorpicker"
        colorFrame.Size = UDim2.new(1, 0, 0, 32)
        colorFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        colorFrame.BorderSizePixel = 0
        colorFrame.Parent = contentFrame
        CreateCorner(colorFrame, 5)
        CreateStroke(colorFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local colorLabel = Instance.new("TextLabel")
        colorLabel.Size = UDim2.new(1, -55, 1, 0)
        colorLabel.Position = UDim2.new(0, 8, 0, 0)
        colorLabel.BackgroundTransparency = 1
        colorLabel.Text = config.text
        colorLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        colorLabel.Font = Enum.Font.Gotham
        colorLabel.TextSize = 11
        colorLabel.TextXAlignment = Enum.TextXAlignment.Left
        colorLabel.Parent = colorFrame
        
        local currentColor = config.default or Color3.fromRGB(138, 43, 226)
        
        local colorDisplay = Instance.new("TextButton")
        colorDisplay.Size = UDim2.new(0, 40, 0, 22)
        colorDisplay.Position = UDim2.new(1, -48, 0.5, -11)
        colorDisplay.BackgroundColor3 = currentColor
        colorDisplay.BorderSizePixel = 0
        colorDisplay.Text = ""
        colorDisplay.AutoButtonColor = false
        colorDisplay.Parent = colorFrame
        CreateCorner(colorDisplay, 4)
        CreateStroke(colorDisplay, IcarusCore.Themes[self.Theme].Border, 1)
        
        if config.flag then
            IcarusCore.Flags[config.flag] = currentColor
        end
        
        local pickerOpen = false
        
        colorDisplay.MouseButton1Click:Connect(function()
            if not pickerOpen then
                pickerOpen = true
                
                local pickerFrame = Instance.new("Frame")
                pickerFrame.Name = "ColorPicker"
                pickerFrame.Size = UDim2.new(0, 200, 0, 180)
                pickerFrame.Position = UDim2.new(0.5, -100, 0.5, -90)
                pickerFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
                pickerFrame.BorderSizePixel = 0
                pickerFrame.ZIndex = 100
                pickerFrame.Parent = ScreenGui
                CreateCorner(pickerFrame, 8)
                CreateStroke(pickerFrame, IcarusCore.Themes[self.Theme].Border, 1)
                CreateShadow(pickerFrame)
                
                MakeDraggable(pickerFrame)
                
                local pickerTitle = Instance.new("TextLabel")
                pickerTitle.Size = UDim2.new(1, -40, 0, 30)
                pickerTitle.Position = UDim2.new(0, 10, 0, 5)
                pickerTitle.BackgroundTransparency = 1
                pickerTitle.Text = "Color Picker"
                pickerTitle.TextColor3 = IcarusCore.Themes[self.Theme].Text
                pickerTitle.Font = Enum.Font.GothamBold
                pickerTitle.TextSize = 12
                pickerTitle.TextXAlignment = Enum.TextXAlignment.Left
                pickerTitle.ZIndex = 101
                pickerTitle.Parent = pickerFrame
                
                local closeButton = Instance.new("TextButton")
                closeButton.Size = UDim2.new(0, 24, 0, 24)
                closeButton.Position = UDim2.new(1, -30, 0, 5)
                closeButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Danger
                closeButton.BorderSizePixel = 0
                closeButton.Text = "×"
                closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                closeButton.Font = Enum.Font.GothamBold
                closeButton.TextSize = 16
                closeButton.ZIndex = 101
                closeButton.Parent = pickerFrame
                CreateCorner(closeButton, 4)
                
                local hueSlider = Instance.new("Frame")
                hueSlider.Size = UDim2.new(0.9, 0, 0, 20)
                hueSlider.Position = UDim2.new(0.05, 0, 0, 45)
                hueSlider.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                hueSlider.BorderSizePixel = 0
                hueSlider.ZIndex = 101
                hueSlider.Parent = pickerFrame
                CreateCorner(hueSlider, 4)
                CreateGradient(hueSlider, {
                    Color3.fromRGB(255, 0, 0),
                    Color3.fromRGB(255, 255, 0),
                    Color3.fromRGB(0, 255, 0),
                    Color3.fromRGB(0, 255, 255),
                    Color3.fromRGB(0, 0, 255),
                    Color3.fromRGB(255, 0, 255),
                    Color3.fromRGB(255, 0, 0)
                })
                
                local satSlider = Instance.new("Frame")
                satSlider.Size = UDim2.new(0.9, 0, 0, 20)
                satSlider.Position = UDim2.new(0.05, 0, 0, 75)
                satSlider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                satSlider.BorderSizePixel = 0
                satSlider.ZIndex = 101
                satSlider.Parent = pickerFrame
                CreateCorner(satSlider, 4)
                
                local valSlider = Instance.new("Frame")
                valSlider.Size = UDim2.new(0.9, 0, 0, 20)
                valSlider.Position = UDim2.new(0.05, 0, 0, 105)
                valSlider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                valSlider.BorderSizePixel = 0
                valSlider.ZIndex = 101
                valSlider.Parent = pickerFrame
                CreateCorner(valSlider, 4)
                
                local preview = Instance.new("Frame")
                preview.Size = UDim2.new(0.9, 0, 0, 30)
                preview.Position = UDim2.new(0.05, 0, 0, 135)
                preview.BackgroundColor3 = currentColor
                preview.BorderSizePixel = 0
                preview.ZIndex = 101
                preview.Parent = pickerFrame
                CreateCorner(preview, 4)
                CreateStroke(preview, IcarusCore.Themes[self.Theme].Border, 1)
                
                local h, s, v = currentColor:ToHSV()
                
                local function updateColor()
                    local newColor = Color3.fromHSV(h, s, v)
                    preview.BackgroundColor3 = newColor
                    colorDisplay.BackgroundColor3 = newColor
                    currentColor = newColor
                    
                    if config.flag then
                        IcarusCore.Flags[config.flag] = newColor
                    end
                    
                    if config.callback then
                        config.callback(newColor)
                    end
                end
                
                local function createSliderInput(slider, updateFunc)
                    local sliderInput = Instance.new("TextButton")
                    sliderInput.Size = UDim2.new(1, 0, 1, 0)
                    sliderInput.BackgroundTransparency = 1
                    sliderInput.Text = ""
                    sliderInput.ZIndex = 102
                    sliderInput.Parent = slider
                    
                    local dragging = false
                    
                    sliderInput.MouseButton1Down:Connect(function()
                        dragging = true
                    end)
                    
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                        end
                    end)
                    
                    UserInputService.InputChanged:Connect(function(input)
                        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                            local relativeX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                            updateFunc(relativeX)
                            updateColor()
                        end
                    end)
                    
                    sliderInput.MouseButton1Click:Connect(function()
                        local relativeX = math.clamp((Mouse.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
                        updateFunc(relativeX)
                        updateColor()
                    end)
                end
                
                createSliderInput(hueSlider, function(value) h = value end)
                createSliderInput(satSlider, function(value) s = value end)
                createSliderInput(valSlider, function(value) v = value end)
                
                closeButton.MouseButton1Click:Connect(function()
                    pickerFrame:Destroy()
                    pickerOpen = false
                end)
            end
        end)
        
        return {
            Frame = colorFrame,
            SetValue = function(color)
                currentColor = color
                colorDisplay.BackgroundColor3 = color
                if config.flag then
                    IcarusCore.Flags[config.flag] = color
                end
            end,
            GetValue = function()
                return currentColor
            end
        }
    end
    
    function tabFunctions:AddKeybind(config)
        local keybindFrame = Instance.new("Frame")
        keybindFrame.Name = "Keybind"
        keybindFrame.Size = UDim2.new(1, 0, 0, 32)
        keybindFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].Secondary
        keybindFrame.BorderSizePixel = 0
        keybindFrame.Parent = contentFrame
        CreateCorner(keybindFrame, 5)
        CreateStroke(keybindFrame, IcarusCore.Themes[self.Theme].Border, 1)
        
        local keybindLabel = Instance.new("TextLabel")
        keybindLabel.Size = UDim2.new(1, -70, 1, 0)
        keybindLabel.Position = UDim2.new(0, 8, 0, 0)
        keybindLabel.BackgroundTransparency = 1
        keybindLabel.Text = config.text
        keybindLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        keybindLabel.Font = Enum.Font.Gotham
        keybindLabel.TextSize = 11
        keybindLabel.TextXAlignment = Enum.TextXAlignment.Left
        keybindLabel.Parent = keybindFrame
        
        local currentKey = config.default or Enum.KeyCode.Unknown
        
        local keybindButton = Instance.new("TextButton")
        keybindButton.Size = UDim2.new(0, 60, 0, 22)
        keybindButton.Position = UDim2.new(1, -68, 0.5, -11)
        keybindButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
        keybindButton.BorderSizePixel = 0
        keybindButton.Text = currentKey.Name
        keybindButton.TextColor3 = IcarusCore.Themes[self.Theme].Text
        keybindButton.Font = Enum.Font.GothamBold
        keybindButton.TextSize = 10
        keybindButton.AutoButtonColor = false
        keybindButton.Parent = keybindFrame
        CreateCorner(keybindButton, 4)
        
        if config.flag then
            IcarusCore.Flags[config.flag] = currentKey
        end
        
        local listening = false
        
        keybindButton.MouseButton1Click:Connect(function()
            if not listening then
                listening = true
                keybindButton.Text = "..."
                keybindButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
                
                local connection
                connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                        keybindButton.Text = currentKey.Name
                        keybindButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Tertiary
                        listening = false
                        connection:Disconnect()
                        
                        if config.flag then
                            IcarusCore.Flags[config.flag] = currentKey
                        end
                        
                        if config.callback then
                            IcarusCore:AddKeybind(currentKey, config.callback)
                        end
                    end
                end)
            end
        end)
        
        if config.callback and currentKey ~= Enum.KeyCode.Unknown then
            IcarusCore:AddKeybind(currentKey, config.callback)
        end
        
        return {
            Frame = keybindFrame,
            SetValue = function(key)
                currentKey = key
                keybindButton.Text = key.Name
                if config.flag then
                    IcarusCore.Flags[config.flag] = key
                end
            end,
            GetValue = function()
                return currentKey
            end
        }
    end
    
    function tabFunctions:AddDivider(text)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, text and 22 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
        divider.BackgroundTransparency = text and 1 or 0.5
        divider.BorderSizePixel = 0
        divider.Parent = contentFrame
        
        if text then
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.3, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            line1.BackgroundTransparency = 0.5
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.Position = UDim2.new(0.3, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = IcarusCore.Themes[self.Theme].TextDim
            label.Font = Enum.Font.GothamBold
            label.TextSize = 11
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.3, 0, 0, 1)
            line2.Position = UDim2.new(0.7, 0, 0.5, 0)
            line2.BackgroundColor3 = IcarusCore.Themes[self.Theme].Border
            line2.BackgroundTransparency = 0.5
            line2.BorderSizePixel = 0
            line2.Parent = divider
        end
        
        return divider
    end
    
    return tabFunctions
end

function IcarusLibrary:AddTheme(themeConfig)
    local themeName = themeConfig.name or "Custom"
    IcarusCore.Themes[themeName] = {
        Background = themeConfig.background and (type(themeConfig.background) == "string" and Color3.fromHex(themeConfig.background) or themeConfig.background) or Color3.fromRGB(18, 18, 24),
        Secondary = themeConfig.secondary and (type(themeConfig.secondary) == "string" and Color3.fromHex(themeConfig.secondary) or themeConfig.secondary) or Color3.fromRGB(24, 24, 32),
        Tertiary = themeConfig.tertiary and (type(themeConfig.tertiary) == "string" and Color3.fromHex(themeConfig.tertiary) or themeConfig.tertiary) or Color3.fromRGB(32, 32, 42),
        Border = themeConfig.border and (type(themeConfig.border) == "string" and Color3.fromHex(themeConfig.border) or themeConfig.border) or Color3.fromRGB(45, 45, 60),
        Text = themeConfig.text and (type(themeConfig.text) == "string" and Color3.fromHex(themeConfig.text) or themeConfig.text) or Color3.fromRGB(255, 255, 255),
        TextDim = themeConfig.text_dim and (type(themeConfig.text_dim) == "string" and Color3.fromHex(themeConfig.text_dim) or themeConfig.text_dim) or Color3.fromRGB(180, 180, 200),
        Accent = themeConfig.accent and (type(themeConfig.accent) == "string" and Color3.fromHex(themeConfig.accent) or themeConfig.accent) or Color3.fromRGB(138, 43, 226),
        AccentHover = themeConfig.accent_hover and (type(themeConfig.accent_hover) == "string" and Color3.fromHex(themeConfig.accent_hover) or themeConfig.accent_hover) or Color3.fromRGB(158, 63, 246),
        AccentDark = themeConfig.accent_dark and (type(themeConfig.accent_dark) == "string" and Color3.fromHex(themeConfig.accent_dark) or themeConfig.accent_dark) or Color3.fromRGB(118, 23, 206),
        Success = Color3.fromRGB(40, 201, 64),
        Warning = Color3.fromRGB(255, 189, 68),
        Danger = Color3.fromRGB(255, 95, 86),
        Info = Color3.fromRGB(52, 152, 219)
    }
    IcarusCore.CurrentTheme = themeName
end

function IcarusLibrary:SetTheme(themeName)
    if IcarusCore.Themes[themeName] then
        IcarusCore.CurrentTheme = themeName
        IcarusCore:Notify({
            text = "Theme Changed",
            description = "Theme set to " .. themeName,
            type = "info",
            duration = 2
        })
    end
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

task.spawn(function()
    task.wait(0.3)
    IcarusCore:Notify({
        text = "Icarus Library Loaded",
        description = "Ultra Premium System Ready - v3.0",
        type = "success",
        duration = 2.5
    })
end)

return IcarusLibrary
