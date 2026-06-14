local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

local oldGui = playerGui:FindFirstChild("PremiumMobileGui")
if oldGui then
	oldGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PremiumMobileGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainUI = Instance.new("Frame")
mainUI.Name = "MainUI"
mainUI.Size = UDim2.new(0, 560, 0, 360)
mainUI.AnchorPoint = Vector2.new(0.5, 0.5)
mainUI.Position = UDim2.new(0.5, 0, 0.5, -25)
mainUI.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
mainUI.BorderSizePixel = 0
mainUI.Parent = screenGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainUI

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainUI

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(55, 55, 60)
mainStroke.Thickness = 1.5
mainStroke.Parent = mainUI

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 36)
topBar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainUI

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarHide = Instance.new("Frame")
topBarHide.Size = UDim2.new(1, 0, 0, 16)
topBarHide.Position = UDim2.new(0, 0, 1, -16)
topBarHide.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
topBarHide.BorderSizePixel = 0
topBarHide.Parent = topBar

local pfpLabel = Instance.new("ImageLabel")
pfpLabel.Name = "PlayerPfp"
pfpLabel.Size = UDim2.new(0, 24, 0, 24)
pfpLabel.Position = UDim2.new(0, 14, 0.5, -12)
pfpLabel.BackgroundTransparency = 1
pfpLabel.Parent = topBar

local pfpCorner = Instance.new("UICorner")
pfpCorner.CornerRadius = UDim.new(1, 0)
pfpCorner.Parent = pfpLabel

task.spawn(function()
	local success, content = pcall(function()
		return players:GetUserThumbnailAsync(localPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if success then
		pfpLabel.Image = content
	end
end)

local animFrame = Instance.new("Frame")
animFrame.Name = "AnimFrame"
animFrame.Size = UDim2.new(0, 120, 1, 0)
animFrame.Position = UDim2.new(0, 44, 0, 0)
animFrame.BackgroundTransparency = 1
animFrame.ClipsDescendants = true
animFrame.Parent = topBar

local waveText = Instance.new("TextLabel")
waveText.Name = "WaveText"
waveText.Size = UDim2.new(0, 100, 1, 0)
waveText.Position = UDim2.new(0, -100, 0, 0)
waveText.BackgroundTransparency = 1
waveText.Text = "wave ui"
waveText.TextColor3 = Color3.fromRGB(255, 255, 255)
waveText.TextSize = 14
waveText.Font = Enum.Font.GothamBold
waveText.TextXAlignment = Enum.TextXAlignment.Left
waveText.Parent = animFrame

task.spawn(function()
	while true do
		waveText.Position = UDim2.new(0, -100, 0, 0)
		local tween = tweenService:Create(waveText, TweenInfo.new(6, Enum.EasingStyle.Linear), {Position = UDim2.new(1, 0, 0, 0)})
		tween:Play()
		tween.Completed:Wait()
		task.wait(0.2)
	end
end)

local waveDivider = Instance.new("Frame")
waveDivider.Name = "WaveDivider"
waveDivider.Size = UDim2.new(0, 1, 0, 18)
waveDivider.Position = UDim2.new(0, 168, 0.5, -9)
waveDivider.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
waveDivider.BorderSizePixel = 0
waveDivider.Parent = topBar

local tagsContainer = Instance.new("Frame")
tagsContainer.Name = "TagsContainer"
tagsContainer.Size = UDim2.new(0, 130, 0, 18)
tagsContainer.Position = UDim2.new(0, 175, 0.5, -9)
tagsContainer.BackgroundTransparency = 1
tagsContainer.Parent = topBar

local tagsLayout = Instance.new("UIListLayout")
tagsLayout.FillDirection = Enum.FillDirection.Horizontal
tagsLayout.SortOrder = Enum.SortOrder.LayoutOrder
tagsLayout.Padding = UDim.new(0, 5)
tagsLayout.Parent = tagsContainer

local redBtn = Instance.new("TextButton")
redBtn.Size = UDim2.new(0, 13, 0, 13)
redBtn.Position = UDim2.new(1, -26, 0, 11)
redBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 85)
redBtn.Text = ""
redBtn.Parent = topBar

local redCorner = Instance.new("UICorner")
redCorner.CornerRadius = UDim.new(1, 0)
redCorner.Parent = redBtn

local redStroke = Instance.new("UIStroke")
redStroke.Color = Color3.fromRGB(180, 50, 50)
redStroke.Thickness = 1
redStroke.Parent = redBtn

local yellowBtn = Instance.new("TextButton")
yellowBtn.Size = UDim2.new(0, 13, 0, 13)
yellowBtn.Position = UDim2.new(1, -52, 0, 11)
yellowBtn.BackgroundColor3 = Color3.fromRGB(255, 190, 45)
yellowBtn.Text = ""
yellowBtn.Parent = topBar

local yellowCorner = Instance.new("UICorner")
yellowCorner.CornerRadius = UDim.new(1, 0)
yellowCorner.Parent = yellowBtn

local yellowStroke = Instance.new("UIStroke")
yellowStroke.Color = Color3.fromRGB(190, 130, 30)
yellowStroke.Thickness = 1
yellowStroke.Parent = yellowBtn

local sideBar = Instance.new("Frame")
sideBar.Name = "SideBar"
sideBar.Size = UDim2.new(0, 165, 1, -60)
sideBar.Position = UDim2.new(0, 0, 0, 36)
sideBar.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBar.BorderSizePixel = 0
sideBar.Parent = mainUI

local sideBarCorner = Instance.new("UICorner")
sideBarCorner.CornerRadius = UDim.new(0, 12)
sideBarCorner.Parent = sideBar

local sideBarHide = Instance.new("Frame")
sideBarHide.Size = UDim2.new(0, 16, 1, 0)
sideBarHide.Position = UDim2.new(1, -16, 0, 0)
sideBarHide.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBarHide.BorderSizePixel = 0
sideBarHide.Parent = sideBar

local sideBarHideTop = Instance.new("Frame")
sideBarHideTop.Size = UDim2.new(1, 0, 0, 16)
sideBarHideTop.Position = UDim2.new(0, 0, 0, 0)
sideBarHideTop.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
sideBarHideTop.BorderSizePixel = 0
sideBarHideTop.Parent = sideBar

local sideBarStroke = Instance.new("UIStroke")
sideBarStroke.Color = Color3.fromRGB(45, 45, 48)
sideBarStroke.Thickness = 1
sideBarStroke.Parent = sideBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -24, 0, 24)
title.Position = UDim2.new(0, 14, 0, 14)
title.BackgroundTransparency = 1
title.Text = "MAIN UI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = sideBar

local desc = Instance.new("TextLabel")
desc.Size = UDim2.new(1, -24, 0, 14)
desc.Position = UDim2.new(0, 14, 0, 38)
desc.BackgroundTransparency = 1
desc.Text = "Mobile Optimization"
desc.TextColor3 = Color3.fromRGB(115, 115, 125)
desc.TextSize = 11
desc.Font = Enum.Font.GothamMedium
desc.TextXAlignment = Enum.TextXAlignment.Left
desc.Parent = sideBar

local mainDivider = Instance.new("Frame")
mainDivider.Size = UDim2.new(1, -28, 0, 1)
mainDivider.Position = UDim2.new(0, 14, 0, 60)
mainDivider.BackgroundColor3 = Color3.fromRGB(45, 45, 48)
mainDivider.BorderSizePixel = 0
mainDivider.Parent = sideBar

local tabContainer = Instance.new("ScrollingFrame")
tabContainer.Size = UDim2.new(1, -20, 1, -78)
tabContainer.Position = UDim2.new(0, 10, 0, 68)
tabContainer.BackgroundTransparency = 1
tabContainer.BorderSizePixel = 0
tabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabContainer.ScrollBarThickness = 0
tabContainer.Parent = sideBar

local tabLayout = Instance.new("UIListLayout")
tabLayout.Padding = UDim.new(0, 6)
tabLayout.Parent = tabContainer

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -195, 1, -74)
contentContainer.Position = UDim2.new(0, 182, 0, 42)
contentContainer.BackgroundTransparency = 1
contentContainer.ClipsDescendants = true
contentContainer.Parent = mainUI

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 24)
footer.Position = UDim2.new(0, 0, 1, -24)
footer.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
footer.BorderSizePixel = 0
footer.Parent = mainUI

local footerCorner = Instance.new("UICorner")
footerCorner.CornerRadius = UDim.new(0, 12)
footerCorner.Parent = footer

local footerText = Instance.new("TextLabel")
footerText.Size = UDim2.new(1, -40, 1, 0)
footerText.Position = UDim2.new(0, 14, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "wave ui: v1.3"
footerText.TextColor3 = Color3.fromRGB(115, 115, 125)
footerText.TextSize = 11
footerText.Font = Enum.Font.GothamMedium
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footer

local resizeBtn = Instance.new("TextButton")
resizeBtn.Name = "ResizeBtn"
resizeBtn.Size = UDim2.new(0, 16, 0, 16)
resizeBtn.Position = UDim2.new(1, -22, 0, 4)
resizeBtn.BackgroundTransparency = 1
resizeBtn.Text = "◢"
resizeBtn.TextColor3 = Color3.fromRGB(110, 110, 115)
resizeBtn.TextSize = 11
resizeBtn.Font = Enum.Font.GothamBold
resizeBtn.Parent = footer

local dialog = Instance.new("Frame")
dialog.Name = "DialogFrame"
dialog.Size = UDim2.new(0, 280, 0, 140)
dialog.Position = UDim2.new(0.5, -140, 0.5, -70)
dialog.BackgroundColor3 = Color3.fromRGB(30, 30, 32)
dialog.BorderSizePixel = 0
dialog.Visible = false
dialog.ZIndex = 20
dialog.Parent = screenGui

local dialogCorner = Instance.new("UICorner")
dialogCorner.CornerRadius = UDim.new(0, 10)
dialogCorner.Parent = dialog

local dialogStroke = Instance.new("UIStroke")
dialogStroke.Color = Color3.fromRGB(70, 70, 75)
dialogStroke.Thickness = 1.5
dialogStroke.Parent = dialog

local dialogTitle = Instance.new("TextLabel")
dialogTitle.Size = UDim2.new(1, -24, 0, 50)
dialogTitle.Position = UDim2.new(0, 12, 0, 14)
dialogTitle.BackgroundTransparency = 1
dialogTitle.Text = "Are you sure you want to completely destroy the interface?"
dialogTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
dialogTitle.TextSize = 13
dialogTitle.Font = Enum.Font.GothamBold
dialogTitle.TextWrapped = true
dialogTitle.ZIndex = 21
dialogTitle.Parent = dialog

local yesBtn = Instance.new("TextButton")
yesBtn.Size = UDim2.new(0, 110, 0, 36)
yesBtn.Position = UDim2.new(0, 20, 0, 82)
yesBtn.BackgroundColor3 = Color3.fromRGB(235, 80, 80)
yesBtn.Text = "Yes"
yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
yesBtn.TextSize = 13
yesBtn.Font = Enum.Font.GothamBold
yesBtn.ZIndex = 21
yesBtn.Parent = dialog

local yesCorner = Instance.new("UICorner")
yesCorner.CornerRadius = UDim.new(0, 8)
yesCorner.Parent = yesBtn

local noBtn = Instance.new("TextButton")
noBtn.Size = UDim2.new(0, 110, 0, 36)
noBtn.Position = UDim2.new(1, -130, 0, 82)
noBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
noBtn.Text = "No"
noBtn.TextColor3 = Color3.fromRGB(230, 230, 235)
noBtn.TextSize = 13
noBtn.Font = Enum.Font.GothamBold
noBtn.ZIndex = 21
noBtn.Parent = dialog

local noCorner = Instance.new("UICorner")
noCorner.CornerRadius = UDim.new(0, 8)
noCorner.Parent = noBtn

local toggleUI = Instance.new("Frame")
toggleUI.Name = "ToggleUI"
toggleUI.Size = UDim2.new(0, 140, 0, 36)
toggleUI.Position = UDim2.new(0, 25, 0, 25)
toggleUI.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
toggleUI.Visible = false
toggleUI.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 18)
toggleCorner.Parent = toggleUI

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.8
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Parent = toggleUI

local toggleGradient = Instance.new("UIGradient")
toggleGradient.Color = ColorSequence.new({ 
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 180, 185)), 
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(75, 75, 80)), 
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 185)) 
})
toggleGradient.Parent = toggleStroke

task.spawn(function()
	local rot = 0
	while true do
		rot = (rot + 4) % 360
		toggleGradient.Rotation = rot
		task.wait(0.02)
	end
end)

local dragBtnToggle = Instance.new("TextButton")
dragBtnToggle.Name = "DragButton"
dragBtnToggle.Size = UDim2.new(0, 34, 1, 0)
dragBtnToggle.Position = UDim2.new(0, 0, 0, 0)
dragBtnToggle.BackgroundTransparency = 1
dragBtnToggle.Text = ""
dragBtnToggle.Parent = toggleUI

local iconColor = Color3.fromRGB(140, 140, 145)
local line1 = Instance.new("Frame")
line1.Name = "Line1"
line1.Size = UDim2.new(0, 12, 0, 2)
line1.Position = UDim2.new(0.5, -6, 0.5, -4)
line1.BackgroundColor3 = iconColor
line1.BorderSizePixel = 0
line1.Parent = dragBtnToggle
Instance.new("UICorner", line1).CornerRadius = UDim.new(1, 0)

local line2 = Instance.new("Frame")
line2.Name = "Line2"
line2.Size = UDim2.new(0, 12, 0, 2)
line2.Position = UDim2.new(0.5, -6, 0.5, -1)
line2.BackgroundColor3 = iconColor
line2.BorderSizePixel = 0
line2.Parent = dragBtnToggle
Instance.new("UICorner", line2).CornerRadius = UDim.new(1, 0)

local line3 = Instance.new("Frame")
line3.Name = "Line3"
line3.Size = UDim2.new(0, 12, 0, 2)
line3.Position = UDim2.new(0.5, -6, 0.5, 2)
line3.BackgroundColor3 = iconColor
line3.BorderSizePixel = 0
line3.Parent = dragBtnToggle
Instance.new("UICorner", line3).CornerRadius = UDim.new(1, 0)

local toggleLine = Instance.new("Frame")
toggleLine.Size = UDim2.new(0, 1, 0, 18)
toggleLine.Position = UDim2.new(0, 34, 0.5, -9)
toggleLine.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
toggleLine.BorderSizePixel = 0
toggleLine.Parent = toggleUI

local toggleClickBtn = Instance.new("TextButton")
toggleClickBtn.Name = "ToggleClickButton"
toggleClickBtn.Size = UDim2.new(1, -40, 1, 0)
toggleClickBtn.Position = UDim2.new(0, 40, 0, 0)
toggleClickBtn.BackgroundTransparency = 1
toggleClickBtn.Text = "Open UI"
toggleClickBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
toggleClickBtn.TextSize = 12
toggleClickBtn.Font = Enum.Font.GothamBold
toggleClickBtn.TextXAlignment = Enum.TextXAlignment.Center
toggleClickBtn.Parent = toggleUI

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	mainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = mainUI.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)

topBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)

local tDragging = false
local tDragStart, tStartPos
dragBtnToggle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		tDragging = true
		tDragStart = input.Position
		tStartPos = toggleUI.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then tDragging = false end
		end)
	end
end)

local scaleChangedBindable = Instance.new("BindableEvent")
local resizing = false
local resizeStart, startScale
resizeBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		resizing = true
		resizeStart = input.Position
		startScale = uiScale.Scale
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then resizing = false end
		end)
	end
end)

userInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		update(input)
	elseif tDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - tDragStart
		toggleUI.Position = UDim2.new(tStartPos.X.Scale, tStartPos.X.Offset + delta.X, tStartPos.Y.Scale, tStartPos.Y.Offset + delta.Y)
	elseif resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - resizeStart
		local deltaX = delta.X
		local newScale = startScale + (deltaX / 300)
		uiScale.Scale = math.clamp(newScale, 0.8, 1.5)
		scaleChangedBindable:Fire()
	end
end)

redBtn.MouseButton1Click:Connect(function()
	dialog.Size = UDim2.new(0, 240, 0, 120)
	dialog.Position = UDim2.new(0.5, -120, 0.5, -60)
	dialog.Visible = true
	tweenService:Create(dialog, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 280, 0, 140),
		Position = UDim2.new(0.5, -140, 0.5, -70)
	}):Play()
end)

yesBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)
noBtn.MouseButton1Click:Connect(function() dialog.Visible = false end)

yellowBtn.MouseButton1Click:Connect(function()
	mainUI.Visible = false
	toggleUI.Visible = true
end)

toggleClickBtn.MouseButton1Click:Connect(function()
	toggleUI.Visible = false
	mainUI.Visible = true
end)

tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	tabContainer.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y)
end)

local pages = {}
local tabs = {}
local currentTabIndex = 1
local isTransitioning = false
local library = {}

function library:CreateWindow(config)
	if config.title then
		title.Text = string.upper(config.title)
	end
	if config.desc then
		desc.Text = config.desc
	end
	if config.footer then
		footerText.Text = config.footer
	end
	if config.open ~= nil then
		if config.open == true then
			mainUI.Visible = true
			toggleUI.Visible = false
		elseif config.open == false then
			mainUI.Visible = false
			toggleUI.Visible = true
		end
	else
		mainUI.Visible = true
		toggleUI.Visible = false
	end
	
	local windowApi = {}
	
	function windowApi:SetTitle(newTitle)
		title.Text = string.upper(newTitle)
	end
	
	function windowApi:SetDesc(newDesc)
		desc.Text = newDesc
	end
	function windowApi:SetFooter(newFooterText)
		footerText.Text = newFooterText
	end
	function windowApi:Open(state)
		if state == true then
			mainUI.Visible = true
			toggleUI.Visible = false
		elseif state == false then
			mainUI.Visible = false
			toggleUI.Visible = true
		end
	end
	
	return windowApi
end

function library:SetTopTags(tagsList)
	for _, child in pairs(tagsContainer:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	local count = #tagsList
	if count < 1 then return end
	if count > 3 then count = 3 end
	local totalWidth = 130
	local padding = 5
	local itemWidth = 0
	if count == 1 then
		itemWidth = totalWidth
	elseif count == 2 then
		itemWidth = (totalWidth - padding) / 2
	elseif count == 3 then
		itemWidth = (totalWidth - (padding * 2)) / 3
	end
	for i = 1, count do
		local tagFrame = Instance.new("Frame")
		tagFrame.Size = UDim2.new(0, itemWidth, 1, 0)
		tagFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 38)
		tagFrame.BorderSizePixel = 0
		tagFrame.Parent = tagsContainer
		
		local tagCorner = Instance.new("UICorner")
		tagCorner.CornerRadius = UDim.new(0, 14)
		tagCorner.Parent = tagFrame
		
		local tagStroke = Instance.new("UIStroke")
		tagStroke.Color = Color3.fromRGB(60, 60, 65)
		tagStroke.Thickness = 1
		tagStroke.Parent = tagFrame
		
		local tagLabel = Instance.new("TextLabel")
		tagLabel.Size = UDim2.new(1, -6, 1, 0)
		tagLabel.Position = UDim2.new(0, 3, 0, 0)
		tagLabel.BackgroundTransparency = 1
		tagLabel.Text = tostring(tagsList[i])
		tagLabel.TextColor3 = Color3.fromRGB(230, 230, 235)
		tagLabel.TextSize = 9
		tagLabel.Font = Enum.Font.GothamBold
		tagLabel.TextWrapped = true
		tagLabel.Parent = tagFrame
	end
end

function library:CreateTab(tabName)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 34)
	tabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	tabBtn.Text = " " .. tabName
	tabBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
	tabBtn.TextSize = 12
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.Parent = tabContainer
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = tabBtn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(48, 48, 52)
	btnStroke.Thickness = 1
	btnStroke.Parent = tabBtn
	
	local page = Instance.new("ScrollingFrame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.Visible = false
	page.ScrollBarThickness = 0
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.ClipsDescendants = true
	page.Parent = contentContainer
	
	local pagePadding = Instance.new("UIPadding")
	pagePadding.PaddingLeft = UDim.new(0, 6)
	pagePadding.PaddingRight = UDim.new(0, 6)
	pagePadding.PaddingTop = UDim.new(0, 6)
	pagePadding.PaddingBottom = UDim.new(0, 6)
	pagePadding.Parent = page
	
	local pageLayout = Instance.new("UIListLayout")
	pageLayout.Padding = UDim.new(0, 10)
	pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
	pageLayout.Parent = page
	
	pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		page.CanvasSize = UDim2.new(0, 0, 0, pageLayout.AbsoluteContentSize.Y + 20)
	end)
	
	table.insert(pages, page)
	table.insert(tabs, tabBtn)
	local thisTabIndex = #pages
	
	tabBtn.MouseButton1Click:Connect(function()
		if thisTabIndex == currentTabIndex or isTransitioning then return end
		isTransitioning = true
		local oldPage = pages[currentTabIndex]
		local newPage = page
		for _, t in pairs(tabs) do
			t.TextColor3 = Color3.fromRGB(160, 160, 165)
			t.UIStroke.Color = Color3.fromRGB(48, 48, 52)
		end
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
		if thisTabIndex < currentTabIndex then
			newPage.Position = UDim2.new(-1, 0, 0, 0)
			newPage.Visible = true
			tweenService:Create(oldPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
			local tweenNew = tweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
			tweenNew:Play()
			tweenNew.Completed:Wait()
			oldPage.Visible = false
		else
			newPage.Position = UDim2.new(1, 0, 0, 0)
			newPage.Visible = true
			tweenService:Create(oldPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 0)}):Play()
			local tweenNew = tweenService:Create(newPage, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
			tweenNew:Play()
			tweenNew.Completed:Wait()
			oldPage.Visible = false
		end
		currentTabIndex = thisTabIndex
		isTransitioning = false
	end)
	
	if #pages == 1 then
		page.Visible = true
		tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
	end
	
	local currentDualRow = nil
	local pageElements = {}
	
	function pageElements:CreateGroupBox(boxTitle, layoutType, initialState)
		local isExpanded = true
		if initialState == "close" then
			isExpanded = false
		end
		local groupBox = Instance.new("Frame")
		groupBox.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
		groupBox.BorderSizePixel = 0
		groupBox.ClipsDescendants = true
		
		local groupCorner = Instance.new("UICorner")
		groupCorner.CornerRadius = UDim.new(0, 8)
		groupCorner.Parent = groupBox
		
		local groupStroke = Instance.new("UIStroke")
		groupStroke.Color = Color3.fromRGB(48, 48, 52)
		groupStroke.Thickness = 1
		groupStroke.Parent = groupBox
		
		local groupLabel = Instance.new("TextLabel")
		groupLabel.Size = UDim2.new(1, -40, 0, 20)
		groupLabel.Position = UDim2.new(0, 10, 0, 6)
		groupLabel.BackgroundTransparency = 1
		groupLabel.Text = string.upper(boxTitle)
		groupLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
		groupLabel.TextSize = 10
		groupLabel.Font = Enum.Font.GothamBold
		groupLabel.TextXAlignment = Enum.TextXAlignment.Left
		groupLabel.Parent = groupBox
		
		local groupDivider = Instance.new("Frame")
		groupDivider.Size = UDim2.new(1, -20, 0, 1)
		groupDivider.Position = UDim2.new(0, 10, 0, 28)
		groupDivider.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
		groupDivider.BorderSizePixel = 0
		groupDivider.Parent = groupBox
		
		local toggleBtn = Instance.new("TextButton")
		toggleBtn.Size = UDim2.new(0, 16, 0, 16)
		toggleBtn.Position = UDim2.new(1, -26, 0, 8)
		toggleBtn.BackgroundTransparency = 1
		toggleBtn.Text = isExpanded and "-" or "+"
		toggleBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
		toggleBtn.TextSize = 12
		toggleBtn.Font = Enum.Font.GothamBold
		toggleBtn.Parent = groupBox
		
		local boxContent = Instance.new("Frame")
		boxContent.Name = "ElementsContainer"
		boxContent.Size = UDim2.new(1, 0, 1, -32)
		boxContent.Position = UDim2.new(0, 0, 0, 30)
		boxContent.BackgroundTransparency = 1
		boxContent.BorderSizePixel = 0
		boxContent.Visible = isExpanded
		boxContent.Parent = groupBox
		
		local boxLayout = Instance.new("UIListLayout")
		boxLayout.Padding = UDim.new(0, 5)
		boxLayout.SortOrder = Enum.SortOrder.LayoutOrder
		boxLayout.Parent = boxContent
		
		local boxPadding = Instance.new("UIPadding")
		boxPadding.PaddingLeft = UDim.new(0, 10)
		boxPadding.PaddingRight = UDim.new(0, 10)
		boxPadding.PaddingTop = UDim.new(0, 5)
		boxPadding.PaddingBottom = UDim.new(0, 5)
		boxPadding.Parent = boxContent
		
		local currentCalculatedHeight = 36
		local collapsedHeight = 30
		local hasTabs = false
		local groupTabBar = nil
		local groupPagesContainer = nil
		local tabBoxPages = {}
		local tabBoxButtons = {}
		local currentTabBoxIndex = 1
		local activeTabPageLayout = nil
		
		local function updateDimensions()
			local currentScale = uiScale.Scale
			local adjustedContentHeight = 0
			if hasTabs then
				if activeTabPageLayout then
					groupPagesContainer.Size = UDim2.new(1, 0, 0, activeTabPageLayout.AbsoluteContentSize.Y)
					adjustedContentHeight = groupTabBar.Size.Y.Offset + 4 + (activeTabPageLayout.AbsoluteContentSize.Y / currentScale)
				end
			else
				adjustedContentHeight = boxLayout.AbsoluteContentSize.Y / currentScale
			end
			local totalNeeded = adjustedContentHeight + 40
			currentCalculatedHeight = totalNeeded
			
			if isExpanded then
				groupBox.Size = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, currentCalculatedHeight)
				
				if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
					local row = groupBox.Parent
					local maxTarget = 30
					for _, child in pairs(row:GetChildren()) do
						if child:IsA("Frame") and child.Size.Y.Offset > maxTarget then
							maxTarget = child.Size.Y.Offset
						end
					end
					row.Size = UDim2.new(1, 0, 0, maxTarget)
				end
			end
		end
		
		boxLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateDimensions)
		scaleChangedBindable.Event:Connect(updateDimensions)
		
		toggleBtn.MouseButton1Click:Connect(function()
			isExpanded = not isExpanded
			toggleBtn.Text = isExpanded and "-" or "+"
			boxContent.Visible = isExpanded
			
			local targetHeight = isExpanded and currentCalculatedHeight or collapsedHeight
			local targetSize = UDim2.new(groupBox.Size.X.Scale, groupBox.Size.X.Offset, 0, targetHeight)
			
			tweenService:Create(groupBox, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
			
			if layoutType ~= "allside" and groupBox.Parent:IsA("Frame") then
				local row = groupBox.Parent
				local maxTarget = collapsedHeight
				for _, child in pairs(row:GetChildren()) do
					if child:IsA("Frame") then
						local currentH = (child == groupBox) and targetHeight or child.Size.Y.Offset
						if currentH > maxTarget then
							maxTarget = currentH
						end
					end
				end
				tweenService:Create(row, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, maxTarget)}):Play()
			end
		end)
		
		if layoutType == "allside" then
			currentDualRow = nil
			groupBox.Size = UDim2.new(1, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
			groupBox.Parent = page
		else
			local canReuse = false
			if currentDualRow then
				if layoutType == "left" and not currentDualRow:GetAttribute("LeftTaken") then
					canReuse = true
				elseif layoutType == "right" and not currentDualRow:GetAttribute("RightTaken") then
					canReuse = true
				end
			end
			if not canReuse then
				currentDualRow = Instance.new("Frame")
				currentDualRow.Size = UDim2.new(1, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
				currentDualRow.BackgroundTransparency = 1
				currentDualRow.Parent = page
				currentDualRow:SetAttribute("LeftTaken", false)
				currentDualRow:SetAttribute("RightTaken", false)
			end
			groupBox.Size = UDim2.new(0.49, 0, 0, isExpanded and currentCalculatedHeight or collapsedHeight)
			if layoutType == "left" then
				groupBox.Position = UDim2.new(0, 0, 0, 0)
				groupBox.Parent = currentDualRow
				currentDualRow:SetAttribute("LeftTaken", true)
			elseif layoutType == "right" then
				groupBox.Position = UDim2.new(0.51, 0, 0, 0)
				groupBox.Parent = currentDualRow
				currentDualRow:SetAttribute("RightTaken", true)
			end
		end
		
		local innerElements = {}
		
		function innerElements:CreateButton(text, callback)
			if hasTabs then return end
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 24)
			btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			btn.Text = text
			btn.TextColor3 = Color3.fromRGB(230, 230, 235)
			btn.TextSize = 11
			btn.Font = Enum.Font.GothamMedium
			btn.Parent = boxContent
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", btn)
			str.Color = Color3.fromRGB(52, 52, 56)
			btn.MouseButton1Click:Connect(function() if callback then callback() end end)
			return btn
		end
		
		function innerElements:CreateToggle(text, default, callback)
			if hasTabs then return end
			local toggleFrame = Instance.new("Frame")
			toggleFrame.Size = UDim2.new(1, 0, 0, 24)
			toggleFrame.BackgroundTransparency = 1
			toggleFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, -35, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = toggleFrame
			
			local switch = Instance.new("TextButton")
			switch.Size = UDim2.new(0, 28, 0, 15)
			switch.Position = UDim2.new(1, -28, 0.5, -7)
			switch.BackgroundColor3 = default and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
			switch.Text = ""
			switch.Parent = toggleFrame
			Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
			
			local indicator = Instance.new("Frame")
			indicator.Size = UDim2.new(0, 11, 0, 11)
			indicator.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
			indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			indicator.Parent = switch
			Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
			
			local toggled = default
			switch.MouseButton1Click:Connect(function()
				toggled = not toggled
				tweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = toggled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)}):Play()
				tweenService:Create(indicator, TweenInfo.new(0.12), {Position = toggled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
				if callback then callback(toggled) end
			end)
			return toggleFrame
		end
		
		function innerElements:CreateSlider(text, min, max, default, callback)
			if hasTabs then return end
			local sliderFrame = Instance.new("Frame")
			sliderFrame.Size = UDim2.new(1, 0, 0, 32)
			sliderFrame.BackgroundTransparency = 1
			sliderFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1, 0, 0, 12)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 10
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = sliderFrame
			
			local valLbl = Instance.new("TextLabel")
			valLbl.Size = UDim2.new(0, 40, 0, 12)
			valLbl.Position = UDim2.new(1, -40, 0, 0)
			valLbl.BackgroundTransparency = 1
			valLbl.Text = tostring(default)
			valLbl.TextColor3 = Color3.fromRGB(150, 150, 155)
			valLbl.TextSize = 10
			valLbl.Font = Enum.Font.GothamMedium
			valLbl.TextXAlignment = Enum.TextXAlignment.Right
			valLbl.Parent = sliderFrame
			
			local bar = Instance.new("TextButton")
			bar.Size = UDim2.new(1, 0, 0, 5)
			bar.Position = UDim2.new(0, 0, 0, 18)
			bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			bar.Text = ""
			bar.Parent = sliderFrame
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
			
			local fill = Instance.new("Frame")
			local pct = (default - min) / (max - min)
			fill.Size = UDim2.new(pct, 0, 1, 0)
			fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
			fill.Parent = bar
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
			
			local sliding = false
			local function updateSlider(input)
				local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
				fill.Size = UDim2.new(movePct, 0, 1, 0)
				local val = math.floor(min + (max - min) * movePct)
				valLbl.Text = tostring(val)
				if callback then callback(val) end
			end
			
			bar.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
					sliding = true
					updateSlider(input)
				end
			end)
			userInputService.InputChanged:Connect(function(input)
				if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
			end)
			userInputService.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
			end)
			return sliderFrame
		end
		
		function innerElements:CreateDropdown(text, optionsList, callback)
			if hasTabs then return end
			local dropFrame = Instance.new("Frame")
			dropFrame.Size = UDim2.new(1, 0, 0, 24)
			dropFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
			dropFrame.ClipsDescendants = true
			dropFrame.Parent = dropFrame
			Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", dropFrame)
			str.Color = Color3.fromRGB(50, 50, 55)
			
			local mainBtn = Instance.new("TextButton")
			mainBtn.Size = UDim2.new(1, 0, 0, 24)
			mainBtn.BackgroundTransparency = 1
			mainBtn.Text = " " .. text .. " : Select..."
			mainBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
			mainBtn.TextSize = 10
			mainBtn.Font = Enum.Font.GothamMedium
			mainBtn.TextXAlignment = Enum.TextXAlignment.Left
			mainBtn.Parent = dropFrame
			
			local listFrame = Instance.new("Frame")
			listFrame.Size = UDim2.new(1, 0, 0, #optionsList * 20)
			listFrame.Position = UDim2.new(0, 0, 0, 24)
			listFrame.BackgroundTransparency = 1
			listFrame.Parent = dropFrame
			local listLayout = Instance.new("UIListLayout")
			listLayout.Parent = listFrame
			
			for _, option in pairs(optionsList) do
				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1, 0, 0, 20)
				optBtn.BackgroundTransparency = 1
				optBtn.Text = " " .. tostring(option)
				optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
				optBtn.TextSize = 10
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextXAlignment = Enum.TextXAlignment.Left
				optBtn.Parent = listFrame
				optBtn.MouseButton1Click:Connect(function()
					mainBtn.Text = " " .. text .. " : " .. tostring(option)
					dropFrame.Size = UDim2.new(1, 0, 0, 24)
					updateDimensions()
					if callback then callback(option) end
				end)
			end
			
			local isOpened = false
			mainBtn.MouseButton1Click:Connect(function()
				isOpened = not isOpened
				local targetH = isOpened and (24 + #optionsList * 20) or 24
				dropFrame.Size = UDim2.new(1, 0, 0, targetH)
				updateDimensions()
			end)
			return dropFrame
		end
		
		function innerElements:CreateInput(text, placeholder, callback)
			if hasTabs then return end
			local inputFrame = Instance.new("Frame")
			inputFrame.Size = UDim2.new(1, 0, 0, 24)
			inputFrame.BackgroundTransparency = 1
			inputFrame.Parent = boxContent
			
			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.4, 0, 1, 0)
			lbl.BackgroundTransparency = 1
			lbl.Text = text
			lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
			lbl.TextSize = 11
			lbl.Font = Enum.Font.GothamMedium
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = inputFrame
			
			local box = Instance.new("TextBox")
			box.Size = UDim2.new(0.6, -4, 1, 0)
			box.Position = UDim2.new(0.4, 4, 0, 0)
			box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			box.Text = ""
			box.PlaceholderText = placeholder
			box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
			box.TextColor3 = Color3.fromRGB(230, 230, 235)
			box.TextSize = 10
			box.Font = Enum.Font.Gotham
			box.ClearTextOnFocus = false
			box.Parent = inputFrame
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
			local str = Instance.new("UIStroke", box)
			str.Color = Color3.fromRGB(50, 50, 55)
			
			box.FocusLost:Connect(function(enterPressed) if callback then callback(box.Text, enterPressed) end end)
			return inputFrame
		end
		
		function innerElements:CreateParagraph(text)
			if hasTabs then return end
			local para = Instance.new("TextLabel")
			para.Size = UDim2.new(1, 0, 0, 28)
			para.BackgroundTransparency = 1
			para.Text = text
			para.TextColor3 = Color3.fromRGB(140, 140, 145)
			para.TextSize = 10
			para.Font = Enum.Font.Gotham
			para.TextWrapped = true
			para.TextXAlignment = Enum.TextXAlignment.Left
			para.TextYAlignment = Enum.TextYAlignment.Top
			para.Parent = boxContent
			return para
		end
		
		function innerElements:CreateLabel(text)
			if hasTabs then return end
			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1, 0, 0, 16)
			label.BackgroundTransparency = 1
			label.Text = text
			label.TextColor3 = Color3.fromRGB(240, 240, 245)
			label.TextSize = 11
			label.Font = Enum.Font.GothamMedium
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = boxContent
			return label
		end
		
		function innerElements:CreateDivider()
			if hasTabs then return end
			local div = Instance.new("Frame")
			div.Size = UDim2.new(1, 0, 0, 1)
			div.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
			div.BorderSizePixel = 0
			div.Parent = boxContent
			return div
		end
		
		function innerElements:tabbox(tabName)
			local allowedMax = (layoutType == "allside") and 5 or 3
			if #tabBoxPages >= allowedMax then
				return nil
			end
			if not hasTabs then
				hasTabs = true
				for _, child in pairs(boxContent:GetChildren()) do
					if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
						child:Destroy()
					end
				end
				groupTabBar = Instance.new("Frame")
				groupTabBar.Size = UDim2.new(1, 0, 0, 22)
				groupTabBar.BackgroundTransparency = 1
				groupTabBar.LayoutOrder = 1
				groupTabBar.Parent = boxContent
				
				local groupTabLayout = Instance.new("UIListLayout")
				groupTabLayout.FillDirection = Enum.FillDirection.Horizontal
				groupTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
				groupTabLayout.Padding = UDim.new(0, 4)
				groupTabLayout.Parent = groupTabBar
				
				groupPagesContainer = Instance.new("Frame")
				groupPagesContainer.Size = UDim2.new(1, 0, 0, 0)
				groupPagesContainer.BackgroundTransparency = 1
				groupPagesContainer.LayoutOrder = 2
				groupPagesContainer.Parent = boxContent
				
				boxLayout.Padding = UDim.new(0, 4)
			end
			
			local tabBtn = Instance.new("TextButton")
			tabBtn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
			tabBtn.Text = tabName
			tabBtn.TextColor3 = Color3.fromRGB(150, 150, 155)
			tabBtn.TextSize = 10
			tabBtn.Font = Enum.Font.GothamBold
			tabBtn.LayoutOrder = #tabBoxButtons + 1
			tabBtn.Parent = groupTabBar
			
			local tCorner = Instance.new("UICorner")
			tCorner.CornerRadius = UDim.new(0, 4)
			tCorner.Parent = tabBtn
			
			local tStroke = Instance.new("UIStroke")
			tStroke.Color = Color3.fromRGB(50, 50, 55)
			tStroke.Thickness = 1
			tStroke.Parent = tabBtn
			
			local tPage = Instance.new("Frame")
			tPage.Size = UDim2.new(1, 0, 1, 0)
			tPage.BackgroundTransparency = 1
			tPage.Visible = false
			tPage.Parent = groupPagesContainer
			
			local tLayout = Instance.new("UIListLayout")
			tLayout.Padding = UDim.new(0, 5)
			tLayout.SortOrder = Enum.SortOrder.LayoutOrder
			tLayout.Parent = tPage
			
			table.insert(tabBoxPages, tPage)
			table.insert(tabBoxButtons, tabBtn)
			local thisIdx = #tabBoxPages
			local totalTabs = #tabBoxButtons
			local padTotal = (totalTabs - 1) * 4
			
			if totalTabs >= 2 then
				groupTabBar.Size = UDim2.new(1, 0, 0, 14)
				for _, btn in pairs(tabBoxButtons) do
					btn.Size = UDim2.new(1 / totalTabs, -(padTotal / totalTabs), 1, 0)
					btn.TextSize = 9
				end
			else
				groupTabBar.Size = UDim2.new(1, 0, 0, 22)
				tabBtn.Size = UDim2.new(1, 0, 1, 0)
			end
			
			if thisIdx == 1 then
				tPage.Visible = true
				tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
				activeTabPageLayout = tLayout
			end
			
			tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if currentTabBoxIndex == thisIdx then
					updateDimensions()
				end
			end)
			
			tabBtn.MouseButton1Click:Connect(function()
				if currentTabBoxIndex == thisIdx then return end
				for i, btn in pairs(tabBoxButtons) do
					btn.TextColor3 = Color3.fromRGB(150, 150, 155)
					btn.UIStroke.Color = Color3.fromRGB(50, 50, 55)
					tabBoxPages[i].Visible = false
				end
				tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
				tabBtn.UIStroke.Color = Color3.fromRGB(90, 90, 95)
				tPage.Visible = true
				currentTabBoxIndex = thisIdx
				activeTabPageLayout = tLayout
				updateDimensions()
			end)
			
			local tabElements = {}
			
			function tabElements:CreateButton(text, callback)
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, 24)
				btn.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				btn.Text = text
				btn.TextColor3 = Color3.fromRGB(230, 230, 235)
				btn.TextSize = 11
				btn.Font = Enum.Font.GothamMedium
				btn.Parent = tPage
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", btn)
				str.Color = Color3.fromRGB(52, 52, 56)
				btn.MouseButton1Click:Connect(function() if callback then callback() end end)
				return btn
			end
			
			function tabElements:CreateToggle(text, default, callback)
				local toggleFrame = Instance.new("Frame")
				toggleFrame.Size = UDim2.new(1, 0, 0, 24)
				toggleFrame.BackgroundTransparency = 1
				toggleFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, -35, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 11
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = toggleFrame
				
				local switch = Instance.new("TextButton")
				switch.Size = UDim2.new(0, 28, 0, 15)
				switch.Position = UDim2.new(1, -28, 0.5, -7)
				switch.BackgroundColor3 = default and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)
				switch.Text = ""
				switch.Parent = toggleFrame
				Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
				
				local indicator = Instance.new("Frame")
				indicator.Size = UDim2.new(0, 11, 0, 11)
				indicator.Position = default and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)
				indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				indicator.Parent = switch
				Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
				
				local toggled = default
				switch.MouseButton1Click:Connect(function()
					toggled = not toggled
					tweenService:Create(switch, TweenInfo.new(0.12), {BackgroundColor3 = toggled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(50, 50, 55)}):Play()
					tweenService:Create(indicator, TweenInfo.new(0.12), {Position = toggled and UDim2.new(1, -13, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
					if callback then callback(toggled) end
				end)
				return toggleFrame
			end
			
			function tabElements:CreateSlider(text, min, max, default, callback)
				local sliderFrame = Instance.new("Frame")
				sliderFrame.Size = UDim2.new(1, 0, 0, 32)
				sliderFrame.BackgroundTransparency = 1
				sliderFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(1, 0, 0, 12)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 10
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = sliderFrame
				
				local valLbl = Instance.new("TextLabel")
				valLbl.Size = UDim2.new(0, 40, 0, 12)
				valLbl.Position = UDim2.new(1, -40, 0, 0)
				valLbl.BackgroundTransparency = 1
				valLbl.Text = tostring(default)
				valLbl.TextColor3 = Color3.fromRGB(150, 150, 155)
				valLbl.TextSize = 10
				valLbl.Font = Enum.Font.GothamMedium
				valLbl.TextXAlignment = Enum.TextXAlignment.Right
				valLbl.Parent = sliderFrame
				
				local bar = Instance.new("TextButton")
				bar.Size = UDim2.new(1, 0, 0, 5)
				bar.Position = UDim2.new(0, 0, 0, 18)
				bar.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
				bar.Text = ""
				bar.Parent = tPage
				Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
				
				local fill = Instance.new("Frame")
				local pct = (default - min) / (max - min)
				fill.Size = UDim2.new(pct, 0, 1, 0)
				fill.BackgroundColor3 = Color3.fromRGB(0, 140, 255)
				fill.Parent = bar
				Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
				
				local sliding = false
				local function updateSlider(input)
					local movePct = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					fill.Size = UDim2.new(movePct, 0, 1, 0)
					local val = math.floor(min + (max - min) * movePct)
					valLbl.Text = tostring(val)
					if callback then callback(val) end
				end
				
				bar.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						sliding = true
						updateSlider(input)
					end
				end)
				userInputService.InputChanged:Connect(function(input)
					if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
				end)
				userInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
				end)
				return sliderFrame
			end
			
			function tabElements:CreateDropdown(text, optionsList, callback)
				local dropFrame = Instance.new("Frame")
				dropFrame.Size = UDim2.new(1, 0, 0, 24)
				dropFrame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
				dropFrame.ClipsDescendants = true
				dropFrame.Parent = tPage
				Instance.new("UICorner", dropFrame).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", dropFrame)
				str.Color = Color3.fromRGB(50, 50, 55)
				
				local mainBtn = Instance.new("TextButton")
				mainBtn.Size = UDim2.new(1, 0, 0, 24)
				mainBtn.BackgroundTransparency = 1
				mainBtn.Text = " " .. text .. " : Select..."
				mainBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
				mainBtn.TextSize = 10
				mainBtn.Font = Enum.Font.GothamMedium
				mainBtn.TextXAlignment = Enum.TextXAlignment.Left
				mainBtn.Parent = dropFrame
				
				local listFrame = Instance.new("Frame")
				listFrame.Size = UDim2.new(1, 0, 0, #optionsList * 20)
				listFrame.Position = UDim2.new(0, 0, 0, 24)
				listFrame.BackgroundTransparency = 1
				listFrame.Parent = dropFrame
				local listLayout = Instance.new("UIListLayout")
				listLayout.Parent = listFrame
				
				for _, option in pairs(optionsList) do
					local optBtn = Instance.new("TextButton")
					optBtn.Size = UDim2.new(1, 0, 0, 20)
					optBtn.BackgroundTransparency = 1
					optBtn.Text = " " .. tostring(option)
					optBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
					optBtn.TextSize = 10
					optBtn.Font = Enum.Font.Gotham
					optBtn.TextXAlignment = Enum.TextXAlignment.Left
					optBtn.Parent = listFrame
					optBtn.MouseButton1Click:Connect(function()
						mainBtn.Text = " " .. text .. " : " .. tostring(option)
						dropFrame.Size = UDim2.new(1, 0, 0, 24)
						updateDimensions()
						if callback then callback(option) end
					end)
				end
				
				local isOpened = false
				mainBtn.MouseButton1Click:Connect(function()
					isOpened = not isOpened
					local targetH = isOpened and (24 + #optionsList * 20) or 24
					dropFrame.Size = UDim2.new(1, 0, 0, targetH)
					updateDimensions()
				end)
				return dropFrame
			end
			
			function tabElements:CreateInput(text, placeholder, callback)
				local inputFrame = Instance.new("Frame")
				inputFrame.Size = UDim2.new(1, 0, 0, 24)
				inputFrame.BackgroundTransparency = 1
				inputFrame.Parent = tPage
				
				local lbl = Instance.new("TextLabel")
				lbl.Size = UDim2.new(0.4, 0, 1, 0)
				lbl.BackgroundTransparency = 1
				lbl.Text = text
				lbl.TextColor3 = Color3.fromRGB(210, 210, 215)
				lbl.TextSize = 11
				lbl.Font = Enum.Font.GothamMedium
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.Parent = inputFrame
				
				local box = Instance.new("TextBox")
				box.Size = UDim2.new(0.6, -4, 1, 0)
				box.Position = UDim2.new(0.4, 4, 0, 0)
				box.BackgroundColor3 = Color3.fromRGB(36, 36, 38)
				box.Text = ""
				box.PlaceholderText = placeholder
				box.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
				box.TextColor3 = Color3.fromRGB(230, 230, 235)
				box.TextSize = 10
				box.Font = Enum.Font.Gotham
				box.ClearTextOnFocus = false
				box.Parent = inputFrame
				Instance.new("UICorner", box).CornerRadius = UDim.new(0, 5)
				local str = Instance.new("UIStroke", box)
				str.Color = Color3.fromRGB(50, 50, 55)
				
				box.FocusLost:Connect(function(enterPressed) if callback then callback(box.Text, enterPressed) end end)
				return inputFrame
			end
			
			function tabElements:CreateParagraph(text)
				local para = Instance.new("TextLabel")
				para.Size = UDim2.new(1, 0, 0, 28)
				para.BackgroundTransparency = 1
				para.Text = text
				para.TextColor3 = Color3.fromRGB(140, 140, 145)
				para.TextSize = 10
				para.Font = Enum.Font.Gotham
				para.TextWrapped = true
				para.TextXAlignment = Enum.TextXAlignment.Left
				para.TextYAlignment = Enum.TextYAlignment.Top
				para.Parent = tPage
				return para
			end
			
			function tabElements:CreateLabel(text)
				local label = Instance.new("TextLabel")
				label.Size = UDim2.new(1, 0, 0, 16)
				label.BackgroundTransparency = 1
				label.Text = text
				label.TextColor3 = Color3.fromRGB(240, 240, 245)
				label.TextSize = 11
				label.Font = Enum.Font.GothamMedium
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.Parent = tPage
				return label
			end
			
			function tabElements:CreateDivider()
				local div = Instance.new("Frame")
				div.Size = UDim2.new(1, 0, 0, 1)
				div.BackgroundColor3 = Color3.fromRGB(48, 48, 52)
				div.BorderSizePixel = 0
				div.Parent = tPage
				return div
			end
			
			return tabElements
		end
		
		updateDimensions()
		return innerElements
	end
	return pageElements
end
