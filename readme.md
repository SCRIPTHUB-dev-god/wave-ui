# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

-- Gunakan theme bawaan
local win = Icarus:SetWindows({
    text = "My GUI",
    theme = "DeepBlue",  -- DeepBlue, Purple, Dark, Midnight, Ocean, Rose
    size = UDim2.fromOffset(480, 300),
    settransparent = 0.1,
    autoshow = true,
    searchtopbar = true,
    loadinggui = true
})

-- Atau buat custom theme
Icarus:AddTheme({
    name = "CustomRed",
    colors = {
        background = Color3.fromRGB(20, 10, 10),
        secondary = Color3.fromRGB(30, 15, 15),
        tertiary = Color3.fromRGB(40, 20, 20),
        border = Color3.fromRGB(60, 30, 30),
        text = Color3.fromRGB(255, 240, 240),
        textdim = Color3.fromRGB(200, 160, 160),
        accent = Color3.fromRGB(239, 68, 68),
        accenthover = Color3.fromRGB(255, 88, 88),
        success = Color3.fromRGB(34, 197, 94),
        warning = Color3.fromRGB(251, 191, 36),
        danger = Color3.fromRGB(220, 38, 38),
        glow = Color3.fromRGB(255, 100, 100)
    }
}):SetWindows({
    text = "Custom Theme GUI",
    theme = "CustomRed",
    size = UDim2.fromOffset(480, 300)
})

local tab = win:AddTab({text = "Home"})
local gb = tab:AddLeftGroupbox({text = "Settings"})
gb:AddTextbox({text = "Name", placeholder = "Enter name..."})
```
