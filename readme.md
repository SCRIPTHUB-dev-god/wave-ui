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

local tab = win:AddTab({text = "Main"})

local leftGb = tab:AddLeftGroupbox({text = "Left Group"})
leftGb:AddToggle({text = "Toggle", callback = function(v) end})

local rightGb = tab:AddRightGroupbox({text = "Right Group"})

local tabbox = leftGb:AddTabbox({text = "Settings"})
local tab1 = tabbox:AddTab({text = "General"})
tab1:AddButton({text = "Click"})
```
