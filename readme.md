# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

local win = Icarus:SetToggleGui({
    text = "Main Toggle",
    geometry = "square"
}):SetWindows({
    text = "My GUI",
    theme = "DeepBlue",
    size = UDim2.fromOffset(480, 300),
    settransparent = 0.2,
    autoshow = true,
    searchtopbar = true,
    loadinggui = true
})

local tab = win:AddTab({text = "Home"})
local gb = tab:AddLeftGroupbox({text = "Settings"})
```
