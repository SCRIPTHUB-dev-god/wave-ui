# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
local win = Icarus:SetWindows({
    text = "My GUI",
    theme = "Dark",
    size = UDim2.new(0, 480, 0, 300),
    loadinggui = true
})

local tab = win:AddTab({
    text = "Main",
    icon = "rbxassetid://..."
})

tab:AddButton({text = "Click", callback = function() end})
tab:AddToggle({text = "Enable", type = false, flag = "toggle1", callback = function(v) end})
tab:AddSlider({text = "Speed", min = 0, max = 100, default = 50, flag = "speed", callback = function(v) end})
tab:AddDropdown({text = "Select", options = {"A","B","C"}, multi = false, flag = "drop", callback = function(v) end})
tab:AddTextbox({text = "Name", default = "", placeholder = "Enter...", flag = "name", callback = function(v) end})
tab:AddColorpicker({text = "Color", default = Color3.new(1,1,1), flag = "color", callback = function(v) end})
tab:AddKeybind({text = "Toggle GUI", default = Enum.KeyCode.P, flag = "keybind", callback = function() end})
tab:AddParagraph({text = "Title", description = "Description here"})
tab:AddLabel({text = "Simple label"})
tab:AddDivider("Section Name")

local gb = tab:AddGroupbox({text = "Group", icon = "rbxassetid://..."})
```
