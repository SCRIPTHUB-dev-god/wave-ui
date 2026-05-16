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
ScreenGui.Parent = CoreGui

local IcarusCore = {
    Flags = {},
    ConfigPath = "IcarusConfig.json",
    Themes = {
        Dark = {
            Background = Color3.fromRGB(15, 15, 20),
            Corners = Color3.fromRGB(60, 60, 80),
            Text = Color3.fromRGB(255, 255, 255),
            CornersGroupbox = Color3.fromRGB(45, 45, 65),
            BackgroundGroupbox = Color3.fromRGB(20, 20, 30),
            Accent = Color3.fromRGB(138, 43, 226),
            AccentHover = Color3.fromRGB(168, 73, 255)
        },
        Purple = {
            Background = Color3.fromRGB(25, 15, 35),
            Corners = Color3.fromRGB(80, 50, 100),
            Text = Color3.fromRGB(240, 230, 255),
            CornersGroupbox = Color3.fromRGB(60, 40, 80),
            BackgroundGroupbox = Color3.fromRGB(30, 20, 45),
            Accent = Color3.fromRGB(160, 80, 240),
            AccentHover = Color3.fromRGB(190, 110, 255)
        }
    },
    CurrentTheme = "Dark",
    Keybinds = {},
    Notifications = {},
    SearchActive = false
}

local function CreateBlur(parent, intensity)
    local blur = Instance.new("ImageLabel")
    blur.Name = "AcrylicBlur"
    blur.Size = UDim2.new(1, 0, 1, 0)
    blur.BackgroundTransparency = 1
    blur.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    blur.ImageTransparency = 1 - (intensity or 0.3)
    blur.Parent = parent
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
    stroke.Parent = parent
    return stroke
end

local function CreateCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function TweenObject(object, properties, duration, style)
    local tween = TweenService:Create(
        object,
        TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        properties
    )
    tween:Play()
    return tween
end

local function CreateRipple(parent, mousePos)
    local ripple = Instance.new("Frame")
    ripple.Name = "Ripple"
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, mousePos.X, 0, mousePos.Y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ripple.BackgroundTransparency = 0.5
    ripple.ZIndex = 10
    ripple.Parent = parent
    CreateCorner(ripple, 999)
    
    local maxSize = math.max(parent.AbsoluteSize.X, parent.AbsoluteSize.Y) * 2
    TweenObject(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.6)
    
    task.delay(0.6, function()
        ripple:Destroy()
    end)
end

function IcarusCore:Notify(config)
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 300, 0, 0)
    notification.Position = UDim2.new(1, -320, 0, 20 + (#self.Notifications * 90))
    notification.BackgroundColor3 = self.Themes[self.CurrentTheme].Background
    notification.BorderSizePixel = 0
    notification.ClipsDescendants = true
    notification.Parent = ScreenGui
    CreateCorner(notification, 10)
    CreateStroke(notification, self.Themes[self.CurrentTheme].Accent, 2)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -20, 0, 25)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = config.text or "Notification"
    title.TextColor3 = self.Themes[self.CurrentTheme].Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = notification
    
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -20, 0, 35)
    description.Position = UDim2.new(0, 10, 0, 35)
    description.BackgroundTransparency = 1
    description.Text = config.description or ""
    description.TextColor3 = self.Themes[self.CurrentTheme].Text
    description.Font = Enum.Font.Gotham
    description.TextSize = 12
    description.TextXAlignment = Enum.TextXAlignment.Left
    description.TextWrapped = true
    description.TextTransparency = 0.5
    description.Parent = notification
    
    table.insert(self.Notifications, notification)
    
    TweenObject(notification, {Size = UDim2.new(0, 300, 0, 80)}, 0.4, Enum.EasingStyle.Back)
    
    task.delay(config.duration or 3, function()
        TweenObject(notification, {Size = UDim2.new(0, 300, 0, 0)}, 0.3)
        task.wait(0.3)
        notification:Destroy()
        table.remove(self.Notifications, table.find(self.Notifications, notification))
        for i, notif in ipairs(self.Notifications) do
            TweenObject(notif, {Position = UDim2.new(1, -320, 0, 20 + ((i - 1) * 90))}, 0.3)
        end
    end)
end

function IcarusCore:SaveConfig()
    local config = {}
    for flag, value in pairs(self.Flags) do
        config[flag] = value
    end
    writefile(self.ConfigPath, HttpService:JSONEncode(config))
    self:Notify({text = "Configuration Saved", description = "Settings saved successfully", duration = 2})
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
            self:Notify({text = "Configuration Loaded", description = "Settings loaded successfully", duration = 2})
            return true
        end
    end
    return false
end

function IcarusCore:AddKeybind(key, callback)
    table.insert(self.Keybinds, {Key = key, Callback = callback})
end

function IcarusLibrary:SetWindows(config)
    local window = Instance.new("Frame")
    window.Name = "IcarusWindow"
    window.Size = UDim2.new(0, 600, 0, 400)
    window.Position = UDim2.new(0.5, -300, 0.5, -200)
    window.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Background
    window.BorderSizePixel = 0
    window.ClipsDescendants = true
    window.Active = true
    window.Draggable = false
    window.Visible = false
    window.Parent = ScreenGui
    CreateCorner(window, 12)
    
    if config.transparent then
        window.BackgroundTransparency = config.settransparent or 0.3
        CreateBlur(window, 0.5)
    end
    
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 40, 1, 40)
    shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://5554236805"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.7
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(23, 23, 277, 277)
    shadow.ZIndex = -1
    shadow.Parent = window
    
    local topbar = Instance.new("Frame")
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Corners
    topbar.BorderSizePixel = 0
    topbar.Parent = window
    CreateCorner(topbar, 12)
    
    local topbarBottom = Instance.new("Frame")
    topbarBottom.Size = UDim2.new(1, 0, 0, 12)
    topbarBottom.Position = UDim2.new(0, 0, 1, -12)
    topbarBottom.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].Corners
    topbarBottom.BorderSizePixel = 0
    topbarBottom.Parent = topbar
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = config.text or "Icarus Library"
    titleLabel.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 16
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = topbar
    
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Name = "Buttons"
    buttonContainer.Size = UDim2.new(0, 70, 0, 20)
    buttonContainer.Position = UDim2.new(1, -85, 0.5, -10)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = topbar
    
    local minimizeBtn = Instance.new("Frame")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 68)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = buttonContainer
    CreateCorner(minimizeBtn, 999)
    
    local closeBtn = Instance.new("Frame")
    closeBtn.Name = "Close"
    closeBtn.Size = UDim2.new(0, 20, 0, 20)
    closeBtn.Position = UDim2.new(0, 50, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 86)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = buttonContainer
    CreateCorner(closeBtn, 999)
    
    local maxBtn = Instance.new("Frame")
    maxBtn.Name = "Maximize"
    maxBtn.Size = UDim2.new(0, 20, 0, 20)
    maxBtn.Position = UDim2.new(0, 25, 0, 0)
    maxBtn.BackgroundColor3 = Color3.fromRGB(40, 201, 64)
    maxBtn.BorderSizePixel = 0
    maxBtn.Parent = buttonContainer
    CreateCorner(maxBtn, 999)
    
    local minimizeInput = Instance.new("TextButton")
    minimizeInput.Size = UDim2.new(1, 0, 1, 0)
    minimizeInput.BackgroundTransparency = 1
    minimizeInput.Text = ""
    minimizeInput.Parent = minimizeBtn
    
    local closeInput = Instance.new("TextButton")
    closeInput.Size = UDim2.new(1, 0, 1, 0)
    closeInput.BackgroundTransparency = 1
    closeInput.Text = ""
    closeInput.Parent = closeBtn
    
    local maxInput = Instance.new("TextButton")
    maxInput.Size = UDim2.new(1, 0, 1, 0)
    maxInput.BackgroundTransparency = 1
    maxInput.Text = ""
    maxInput.Parent = maxBtn
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(0, 150, 1, -50)
    tabContainer.Position = UDim2.new(0, 10, 0, 50)
    tabContainer.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].BackgroundGroupbox
    tabContainer.BorderSizePixel = 0
    tabContainer.Parent = window
    CreateCorner(tabContainer, 10)
    
    local tabList = Instance.new("UIListLayout")
    tabList.Padding = UDim.new(0, 5)
    tabList.SortOrder = Enum.SortOrder.LayoutOrder
    tabList.Parent = tabContainer
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -170, 1, -50)
    contentContainer.Position = UDim2.new(0, 170, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = window
    
    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(0, 200, 0, 30)
    searchBox.Position = UDim2.new(1, -215, 0, 5)
    searchBox.BackgroundColor3 = IcarusCore.Themes[config.theme or "Dark"].BackgroundGroupbox
    searchBox.BorderSizePixel = 0
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search..."
    searchBox.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 12
    searchBox.Parent = topbar
    CreateCorner(searchBox, 8)
    
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
    
    local minimized = false
    minimizeInput.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenObject(window, {Size = UDim2.new(0, 600, 0, 40)}, 0.3)
        else
            TweenObject(window, {Size = UDim2.new(0, 600, 0, 400)}, 0.3)
        end
    end)
    
    closeInput.MouseButton1Click:Connect(function()
        TweenObject(window, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        window:Destroy()
    end)
    
    local maximized = false
    maxInput.MouseButton1Click:Connect(function()
        maximized = not maximized
        if maximized then
            TweenObject(window, {
                Size = UDim2.new(0, 900, 0, 600),
                Position = UDim2.new(0.5, -450, 0.5, -300)
            }, 0.3)
        else
            TweenObject(window, {
                Size = UDim2.new(0, 600, 0, 400),
                Position = UDim2.new(0.5, -300, 0.5, -200)
            }, 0.3)
        end
    end)
    
    if config.loadinggui then
        local loadingScreen = Instance.new("Frame")
        loadingScreen.Name = "LoadingScreen"
        loadingScreen.Size = UDim2.new(1, 0, 1, 0)
        loadingScreen.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
        loadingScreen.BorderSizePixel = 0
        loadingScreen.ZIndex = 100
        loadingScreen.Parent = window
        
        local loadingCircle = Instance.new("ImageLabel")
        loadingCircle.Size = UDim2.new(0, 60, 0, 60)
        loadingCircle.Position = UDim2.new(0.5, -30, 0.5, -30)
        loadingCircle.BackgroundTransparency = 1
        loadingCircle.Image = "rbxassetid://4965945816"
        loadingCircle.ImageColor3 = IcarusCore.Themes[config.theme or "Dark"].Accent
        loadingCircle.Parent = loadingScreen
        
        local loadingText = Instance.new("TextLabel")
        loadingText.Size = UDim2.new(0, 200, 0, 30)
        loadingText.Position = UDim2.new(0.5, -100, 0.5, 40)
        loadingText.BackgroundTransparency = 1
        loadingText.Text = "Loading Icarus..."
        loadingText.TextColor3 = IcarusCore.Themes[config.theme or "Dark"].Text
        loadingText.Font = Enum.Font.GothamBold
        loadingText.TextSize = 14
        loadingText.Parent = loadingScreen
        
        spawn(function()
            while loadingScreen.Parent do
                TweenObject(loadingCircle, {Rotation = 360}, 1, Enum.EasingStyle.Linear)
                task.wait(1)
                loadingCircle.Rotation = 0
            end
        end)
        
        task.delay(2, function()
            TweenObject(loadingScreen, {BackgroundTransparency = 1}, 0.5)
            TweenObject(loadingCircle, {ImageTransparency = 1}, 0.5)
            TweenObject(loadingText, {TextTransparency = 1}, 0.5)
            task.wait(0.5)
            loadingScreen:Destroy()
            window.Visible = true
        end)
    else
        window.Visible = true
    end
    
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
    tabButton.Size = UDim2.new(1, -10, 0, 35)
    tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].CornersGroupbox
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = self.TabContainer
    CreateCorner(tabButton, 8)
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 20, 0, 20)
    icon.Position = UDim2.new(0, 10, 0.5, -10)
    icon.BackgroundTransparency = 1
    icon.Image = config.icon or "rbxassetid://7733956210"
    icon.ImageColor3 = IcarusCore.Themes[self.Theme].Text
    icon.Parent = tabButton
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 35, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.text
    label.TextColor3 = IcarusCore.Themes[self.Theme].Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = tabButton
    
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = config.text
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
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
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = contentFrame
    
    contentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentList.AbsoluteContentSize.Y + 20)
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(self.Tabs) do
            tab.Button.BackgroundColor3 = IcarusCore.Themes[self.Theme].CornersGroupbox
            tab.Content.Visible = false
        end
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        contentFrame.Visible = true
        self.CurrentTab = config.text
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
        Elements = {}
    }
    
    table.insert(self.Tabs, tabObj)
    
    if #self.Tabs == 1 then
        tabButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        contentFrame.Visible = true
        self.CurrentTab = config.text
    end
    
    local tabFunctions = {}
    
    function tabFunctions:AddGroupbox(config)
        local groupbox = Instance.new("Frame")
        groupbox.Name = config.text
        groupbox.Size = UDim2.new(1, 0, 0, 50)
        groupbox.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        groupbox.BorderSizePixel = 0
        groupbox.Parent = contentFrame
        CreateCorner(groupbox, 10)
        CreateStroke(groupbox, IcarusCore.Themes[self.Theme].CornersGroupbox, 1)
        
        local groupboxIcon = Instance.new("ImageLabel")
        groupboxIcon.Size = UDim2.new(0, 18, 0, 18)
        groupboxIcon.Position = UDim2.new(0, 10, 0, 10)
        groupboxIcon.BackgroundTransparency = 1
        groupboxIcon.Image = config.icon or "rbxassetid://7733955511"
        groupboxIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Accent
        groupboxIcon.Parent = groupbox
        
        local groupboxLabel = Instance.new("TextLabel")
        groupboxLabel.Size = UDim2.new(1, -40, 0, 25)
        groupboxLabel.Position = UDim2.new(0, 35, 0, 6)
        groupboxLabel.BackgroundTransparency = 1
        groupboxLabel.Text = config.text
        groupboxLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        groupboxLabel.Font = Enum.Font.GothamBold
        groupboxLabel.TextSize = 14
        groupboxLabel.TextXAlignment = Enum.TextXAlignment.Left
        groupboxLabel.Parent = groupbox
        
        local groupboxContent = Instance.new("Frame")
        groupboxContent.Name = "Content"
        groupboxContent.Size = UDim2.new(1, -20, 1, -40)
        groupboxContent.Position = UDim2.new(0, 10, 0, 35)
        groupboxContent.BackgroundTransparency = 1
        groupboxContent.Parent = groupbox
        
        local groupboxList = Instance.new("UIListLayout")
        groupboxList.Padding = UDim.new(0, 8)
        groupboxList.SortOrder = Enum.SortOrder.LayoutOrder
        groupboxList.Parent = groupboxContent
        
        groupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            groupbox.Size = UDim2.new(1, 0, 0, groupboxList.AbsoluteContentSize.Y + 50)
        end)
        
        return {
            Groupbox = groupbox,
            Content = groupboxContent
        }
    end
    
    function tabFunctions:AddLabel(config)
        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.new(1, 0, 0, 20)
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
        button.Size = UDim2.new(1, 0, 0, 35)
        button.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        button.BorderSizePixel = 0
        button.Text = config.text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 13
        button.AutoButtonColor = false
        button.Parent = contentFrame
        CreateCorner(button, 8)
        
        button.MouseButton1Click:Connect(function()
            CreateRipple(button, button.AbsolutePosition + (button.AbsoluteSize / 2))
            if config.callback then
                config.callback()
            end
        end)
        
        button.MouseEnter:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].AccentHover}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            TweenObject(button, {BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent}, 0.2)
        end)
        
        return button
    end
    
    function tabFunctions:AddParagraph(config)
        local paragraph = Instance.new("Frame")
        paragraph.Name = "Paragraph"
        paragraph.Size = UDim2.new(1, 0, 0, 60)
        paragraph.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        paragraph.BorderSizePixel = 0
        paragraph.Parent = contentFrame
        CreateCorner(paragraph, 8)
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -20, 0, 20)
        title.Position = UDim2.new(0, 10, 0, 8)
        title.BackgroundTransparency = 1
        title.Text = config.text
        title.TextColor3 = IcarusCore.Themes[self.Theme].Text
        title.Font = Enum.Font.GothamBold
        title.TextSize = 13
        title.TextXAlignment = Enum.TextXAlignment.Left
        title.Parent = paragraph
        
        local desc = Instance.new("TextLabel")
        desc.Size = UDim2.new(1, -20, 0, 30)
        desc.Position = UDim2.new(0, 10, 0, 28)
        desc.BackgroundTransparency = 1
        desc.Text = config.description or ""
        desc.TextColor3 = IcarusCore.Themes[self.Theme].Text
        desc.Font = Enum.Font.Gotham
        desc.TextSize = 12
        desc.TextXAlignment = Enum.TextXAlignment.Left
        desc.TextWrapped = true
        desc.TextTransparency = 0.5
        desc.Parent = paragraph
        
        return paragraph
    end
    
    function tabFunctions:AddToggle(config)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = "Toggle"
        toggleFrame.Size = UDim2.new(1, 0, 0, 35)
        toggleFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = contentFrame
        CreateCorner(toggleFrame, 8)
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Size = UDim2.new(1, -60, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = config.text
        toggleLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.TextSize = 13
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Size = UDim2.new(0, 45, 0, 22)
        toggleButton.Position = UDim2.new(1, -55, 0.5, -11)
        toggleButton.BackgroundColor3 = config.type and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(60, 60, 80)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.AutoButtonColor = false
        toggleButton.Parent = toggleFrame
        CreateCorner(toggleButton, 999)
        
        local toggleCircle = Instance.new("Frame")
        toggleCircle.Size = UDim2.new(0, 18, 0, 18)
        toggleCircle.Position = config.type and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
        toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleCircle.BorderSizePixel = 0
        toggleCircle.Parent = toggleButton
        CreateCorner(toggleCircle, 999)
        
        local toggled = config.type or false
        
        toggleButton.MouseButton1Click:Connect(function()
            toggled = not toggled
            TweenObject(toggleButton, {
                BackgroundColor3 = toggled and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(60, 60, 80)
            }, 0.2)
            TweenObject(toggleCircle, {
                Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            }, 0.2)
            if config.callback then
                config.callback(toggled)
            end
        end)
        
        return {
            Frame = toggleFrame,
            SetValue = function(value)
                toggled = value
                TweenObject(toggleButton, {
                    BackgroundColor3 = value and IcarusCore.Themes[self.Theme].Accent or Color3.fromRGB(60, 60, 80)
                }, 0.2)
                TweenObject(toggleCircle, {
                    Position = value and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                }, 0.2)
            end
        }
    end
    
    function tabFunctions:AddSlider(config)
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = "Slider"
        sliderFrame.Size = UDim2.new(1, 0, 0, 50)
        sliderFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = contentFrame
        CreateCorner(sliderFrame, 8)
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Size = UDim2.new(1, -60, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = config.text
        sliderLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.TextSize = 13
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Parent = sliderFrame
        
        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(0, 50, 0, 20)
        valueLabel.Position = UDim2.new(1, -60, 0, 5)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = tostring(config.default or config.min)
        valueLabel.TextColor3 = IcarusCore.Themes[self.Theme].Accent
        valueLabel.Font = Enum.Font.GothamBold
        valueLabel.TextSize = 13
        valueLabel.TextXAlignment = Enum.TextXAlignment.Right
        valueLabel.Parent = sliderFrame
        
        local sliderBar = Instance.new("Frame")
        sliderBar.Size = UDim2.new(1, -20, 0, 6)
        sliderBar.Position = UDim2.new(0, 10, 1, -16)
        sliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        sliderBar.BorderSizePixel = 0
        sliderBar.Parent = sliderFrame
        CreateCorner(sliderBar, 999)
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Size = UDim2.new(0, 0, 1, 0)
        sliderFill.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderBar
        CreateCorner(sliderFill, 999)
        
        local sliderButton = Instance.new("TextButton")
        sliderButton.Size = UDim2.new(1, 0, 1, 0)
        sliderButton.BackgroundTransparency = 1
        sliderButton.Text = ""
        sliderButton.Parent = sliderBar
        
        local dragging = false
        local function updateSlider(input)
            local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(config.min + (config.max - config.min) * pos)
            valueLabel.Text = tostring(value)
            TweenObject(sliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.1)
            if config.callback then
                config.callback(value)
            end
        end
        
        sliderButton.MouseButton1Down:Connect(function()
            dragging = true
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        sliderButton.MouseButton1Click:Connect(function(input)
            updateSlider(input)
        end)
        
        local defaultPos = (config.default - config.min) / (config.max - config.min)
        sliderFill.Size = UDim2.new(defaultPos, 0, 1, 0)
        
        return sliderFrame
    end
    
    function tabFunctions:AddDropdown(config)
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(1, 0, 0, 35)
        dropdownFrame.BackgroundColor3 = IcarusCore.Themes[self.Theme].BackgroundGroupbox
        dropdownFrame.BorderSizePixel = 0
        dropdownFrame.ClipsDescendants = true
        dropdownFrame.Parent = contentFrame
        CreateCorner(dropdownFrame, 8)
        
        local dropdownButton = Instance.new("TextButton")
        dropdownButton.Size = UDim2.new(1, 0, 0, 35)
        dropdownButton.BackgroundTransparency = 1
        dropdownButton.Text = ""
        dropdownButton.Parent = dropdownFrame
        
        local dropdownLabel = Instance.new("TextLabel")
        dropdownLabel.Size = UDim2.new(1, -40, 0, 35)
        dropdownLabel.Position = UDim2.new(0, 10, 0, 0)
        dropdownLabel.BackgroundTransparency = 1
        dropdownLabel.Text = config.text
        dropdownLabel.TextColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownLabel.Font = Enum.Font.Gotham
        dropdownLabel.TextSize = 13
        dropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
        dropdownLabel.Parent = dropdownFrame
        
        local dropdownIcon = Instance.new("ImageLabel")
        dropdownIcon.Size = UDim2.new(0, 16, 0, 16)
        dropdownIcon.Position = UDim2.new(1, -26, 0, 10)
        dropdownIcon.BackgroundTransparency = 1
        dropdownIcon.Image = "rbxassetid://7733717447"
        dropdownIcon.ImageColor3 = IcarusCore.Themes[self.Theme].Text
        dropdownIcon.Rotation = 0
        dropdownIcon.Parent = dropdownFrame
        
        local dropdownList = Instance.new("Frame")
        dropdownList.Name = "List"
        dropdownList.Size = UDim2.new(1, -10, 0, 0)
        dropdownList.Position = UDim2.new(0, 5, 0, 40)
        dropdownList.BackgroundTransparency = 1
        dropdownList.Parent = dropdownFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 3)
        listLayout.Parent = dropdownList
        
        local opened = false
        local selectedValues = {}
        
        dropdownButton.MouseButton1Click:Connect(function()
            opened = not opened
            TweenObject(dropdownIcon, {Rotation = opened and 180 or 0}, 0.2)
            local targetSize = opened and (35 + (#config.options * 28) + 10) or 35
            TweenObject(dropdownFrame, {Size = UDim2.new(1, 0, 0, targetSize)}, 0.3)
        end)
        
        for _, option in ipairs(config.options) do
            local optionButton = Instance.new("TextButton")
            optionButton.Size = UDim2.new(1, 0, 0, 25)
            optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            optionButton.BorderSizePixel = 0
            optionButton.Text = option
            optionButton.TextColor3 = IcarusCore.Themes[self.Theme].Text
            optionButton.Font = Enum.Font.Gotham
            optionButton.TextSize = 12
            optionButton.AutoButtonColor = false
            optionButton.Parent = dropdownList
            CreateCorner(optionButton, 6)
            
            optionButton.MouseButton1Click:Connect(function()
                if config.multi then
                    local index = table.find(selectedValues, option)
                    if index then
                        table.remove(selectedValues, index)
                        optionButton.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                    else
                        table.insert(selectedValues, option)
                        optionButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
                    end
                else
                    selectedValues = {option}
                    for _, btn in pairs(dropdownList:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
                        end
                    end
                    optionButton.BackgroundColor3 = IcarusCore.Themes[self.Theme].Accent
                end
                
                if config.callback then
                    config.callback(selectedValues)
                end
            end)
            
            optionButton.MouseEnter:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = Color3.fromRGB(45, 45, 65)}, 0.2)
                end
            end)
            
            optionButton.MouseLeave:Connect(function()
                if not table.find(selectedValues, option) then
                    TweenObject(optionButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}, 0.2)
                end
            end)
        end
        
        return dropdownFrame
    end
    
    function tabFunctions:AddDivider(text)
        local divider = Instance.new("Frame")
        divider.Name = "Divider"
        divider.Size = UDim2.new(1, 0, 0, text and 25 or 1)
        divider.BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners
        divider.BorderSizePixel = 0
        divider.Parent = contentFrame
        
        if text then
            divider.BackgroundTransparency = 1
            local line1 = Instance.new("Frame")
            line1.Size = UDim2.new(0.3, 0, 0, 1)
            line1.Position = UDim2.new(0, 0, 0.5, 0)
            line1.BackgroundColor3 = IcarusCore.Themes[self.Theme].Corners
            line1.BorderSizePixel = 0
            line1.Parent = divider
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.4, 0, 1, 0)
            label.Position = UDim2.new(0.3, 0, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = IcarusCore.Themes[self.Theme].Text
            label.Font = Enum.Font.GothamBold
            label.TextSize = 12
            label.Parent = divider
            
            local line2 = Instance.new("Frame")
            line2.Size = UDim2.new(0.3, 0, 0, 1)
            line2.Position = UDim2.new(0.7, 0, 0.5, 0)
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
        Background = themeConfig.background and Color3.fromHex(themeConfig.background) or Color3.fromRGB(15, 15, 20),
        Corners = themeConfig.corners and Color3.fromHex(themeConfig.corners) or Color3.fromRGB(60, 60, 80),
        Text = themeConfig.text and Color3.fromHex(themeConfig.text) or Color3.fromRGB(255, 255, 255),
        CornersGroupbox = themeConfig.corners_groupbox and Color3.fromHex(themeConfig.corners_groupbox) or Color3.fromRGB(45, 45, 65),
        BackgroundGroupbox = themeConfig.background_groupbox and Color3.fromHex(themeConfig.background_groupbox) or Color3.fromRGB(20, 20, 30),
        Accent = themeConfig.accent and Color3.fromHex(themeConfig.accent) or Color3.fromRGB(138, 43, 226),
        AccentHover = themeConfig.accent_hover and Color3.fromHex(themeConfig.accent_hover) or Color3.fromRGB(168, 73, 255)
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
    description = "Ultra Premium GUI System initialized successfully",
    duration = 3
})

return IcarusLibrary
