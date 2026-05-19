# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

-- Buat toggle button dulu
local win = Icarus:SetToggleGui({
    text = "Main Toggle",
    geometry = "square"  -- atau "rectangle"
}):SetWindows({
    text = "My GUI",
    size = UDim2.fromOffset(480, 300),
    autoshow = true,  -- true = GUI muncul, false = hanya toggle
    searchtopbar = true,
    loadinggui = true
})

local tab = win:AddTab({text = "Home"})
local gb = tab:AddLeftGroupbox({text = "Settings"})
```
