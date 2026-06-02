local Library = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

Library.Themes = {
    Dark = {
        Background = Color3.fromRGB(18, 18, 22),
        Accent = Color3.fromRGB(100, 150, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Dark = Color3.fromRGB(13, 13, 17),
        Stroke = Color3.fromRGB(60, 60, 70)
    },
    Light = {
        Background = Color3.fromRGB(245, 245, 250),
        Accent = Color3.fromRGB(70, 120, 230),
        Text = Color3.fromRGB(20, 20, 25),
        Dark = Color3.fromRGB(230, 230, 235),
        Stroke = Color3.fromRGB(180, 180, 190)
    },
    Purple = {
        Background = Color3.fromRGB(22, 15, 35),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Dark = Color3.fromRGB(15, 10, 25),
        Stroke = Color3.fromRGB(120, 70, 180)
    }
}

local CurrentTheme = Library.Themes.Dark

Library.Icons = {
    Home = "rbxassetid://10709791437",
    Search = "rbxassetid://10709791980",
    Settings = "rbxassetid://10709792143",
    User = "rbxassetid://10709792505",
    Heart = "rbxassetid://10709792603",
    Star = "rbxassetid://10709792241",
    Trash = "rbxassetid://10709792394",
    Edit = "rbxassetid://10709789417",
    Plus = "rbxassetid://10709790948",
    Play = "rbxassetid://10709791048",
    Close = "rbxassetid://10709788811",
    Menu = "rbxassetid://10709790649",
    ArrowLeft = "rbxassetid://10709788292",
}

function Library:GetIcon(name)
    return Library.Icons[name] or Library.Icons["Home"]
end

function Library:SetTheme(themeName)
    if typeof(themeName) == "string" and Library.Themes[themeName] then
        CurrentTheme = Library.Themes[themeName]
    elseif typeof(themeName) == "table" then
        CurrentTheme = themeName
    else
        warn("[ModernLibrary] Theme tidak ditemukan!")
    end
end

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "Modern Library"
    local Size = config.Size or (UserInputService.TouchEnabled and UDim2.new(0.92, 0, 0.85, 0) or UDim2.new(0, 720, 0, 480))

    -- Loading Screen (sama seperti sebelumnya)
    local LoadingGui = Instance.new("ScreenGui")
    LoadingGui.Name = "ModernLoading"
    LoadingGui.ResetOnSpawn = false
    LoadingGui.Parent = PlayerGui

    local LoadingFrame = Instance.new("Frame")
    LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
    LoadingFrame.BackgroundColor3 = CurrentTheme.Background
    LoadingFrame.Parent = LoadingGui

    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.Size = UDim2.new(0.5, 0, 0.12, 0)
    LoadingTitle.Position = UDim2.new(0.25, 0, 0.38, 0)
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Text = Title
    LoadingTitle.TextColor3 = CurrentTheme.Text
    LoadingTitle.TextScaled = true
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Parent = LoadingFrame

    local ProgressBG = Instance.new("Frame")
    ProgressBG.Size = UDim2.new(0.4, 0, 0.006, 0)
    ProgressBG.Position = UDim2.new(0.3, 0, 0.55, 0)
    ProgressBG.BackgroundColor3 = CurrentTheme.Dark
    ProgressBG.Parent = LoadingFrame

    local Progress = Instance.new("Frame")
    Progress.Size = UDim2.new(0, 0, 1, 0)
    Progress.BackgroundColor3 = CurrentTheme.Accent
    Progress.Parent = ProgressBG

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 999)
    Corner:Clone().Parent = ProgressBG
    Corner:Clone().Parent = Progress

    TweenService:Create(Progress, TweenInfo.new(2.3, Enum.EasingStyle.Quint), {Size = UDim2.new(1,0,1,0)}):Play()
    task.wait(2.6)
    TweenService:Create(LoadingFrame, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
    TweenService:Create(LoadingTitle, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
    task.wait(0.7)
    LoadingGui:Destroy()

    -- Main Window
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernLibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "Window"
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset/2, 0.5, -Size.Y.Offset/2)
    MainFrame.BackgroundColor3 = CurrentTheme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 14)
    UICorner.Parent = MainFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = CurrentTheme.Stroke
    Stroke.Thickness = 1.5
    Stroke.Transparency = 0.65
    Stroke.Parent = MainFrame

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 55)
    TitleBar.BackgroundColor3 = CurrentTheme.Dark
    TitleBar.Parent = MainFrame

    local TitleText = Instance.new("TextLabel")
    TitleText.Text = Title
    TitleText.TextColor3 = CurrentTheme.Text
    TitleText.TextScaled = true
    TitleText.Font = Enum.Font.GothamBold
    TitleText.BackgroundTransparency = 1
    TitleText.Position = UDim2.new(0, 20, 0, 0)
    TitleText.Size = UDim2.new(0.7, 0, 1, 0)
    TitleText.Parent = TitleBar

    -- Left Sidebar (Tabs)
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 160, 1, -55)
    Sidebar.Position = UDim2.new(0, 0, 0, 55)
    Sidebar.BackgroundColor3 = CurrentTheme.Dark
    Sidebar.Parent = MainFrame

    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 14)
    SidebarCorner.Parent = Sidebar

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 4)
    SidebarList.Parent = Sidebar

    local SidebarPadding = Instance.new("UIPadding")
    SidebarPadding.PaddingTop = UDim.new(0, 8)
    SidebarPadding.PaddingLeft = UDim.new(0, 8)
    SidebarPadding.PaddingRight = UDim.new(0, 8)
    SidebarPadding.Parent = Sidebar

    -- Content Area
    local Content = Instance.new("Frame")
    Content.Size = UDim2.new(1, -160, 1, -55)
    Content.Position = UDim2.new(0, 160, 0, 55)
    Content.BackgroundTransparency = 1
    Content.Parent = MainFrame

    -- Dragging
    local dragging = false
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            local startPos = MainFrame.Position
            local startInput = input.Position

            local conn = UserInputService.InputChanged:Connect(function(move)
                if dragging and (move.UserInputType == Enum.UserInputType.MouseMovement or move.UserInputType == Enum.UserInputType.Touch) then
                    local delta = move.Position - startInput
                    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                end
            end)

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    conn:Disconnect()
                end
            end)
        end
    end)

    local Window = {
        Main = MainFrame,
        Sidebar = Sidebar,
        Content = Content,
        Tabs = {},
        CurrentTab = nil
    }

    function Window:CreateTab(name, icon)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundTransparency = 1
        TabButton.Text = ""
        TabButton.Parent = Sidebar

        local Icon = Instance.new("ImageLabel")
        Icon.Size = UDim2.new(0, 20, 0, 20)
        Icon.Position = UDim2.new(0, 10, 0.5, -10)
        Icon.BackgroundTransparency = 1
        Icon.Image = Library:GetIcon(icon or "Home")
        Icon.ImageColor3 = CurrentTheme.Text
        Icon.Parent = TabButton

        local TabName = Instance.new("TextLabel")
        TabName.Size = UDim2.new(1, -50, 1, 0)
        TabName.Position = UDim2.new(0, 40, 0, 0)
        TabName.BackgroundTransparency = 1
        TabName.Text = name
        TabName.TextColor3 = CurrentTheme.Text
        TabName.TextXAlignment = Enum.TextXAlignment.Left
        TabName.Font = Enum.Font.GothamSemibold
        TabName.TextSize = 14
        TabName.Parent = TabButton

        local TabContent = Instance.new("Frame")
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.Visible = false
        TabContent.Parent = Content

        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Content.Visible = false
            end
            TabContent.Visible = true
            Window.CurrentTab = {Button = TabButton, Content = TabContent}
        end)

        if not Window.CurrentTab then
            TabContent.Visible = true
            Window.CurrentTab = {Button = TabButton, Content = TabContent}
        end

        table.insert(Window.Tabs, {Button = TabButton, Content = TabContent})
        return TabContent
    end

    return Window
end

return Library
