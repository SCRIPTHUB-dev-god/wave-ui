# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local Icarus = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

local win = Icarus:SetWindows({
    text = "My GUI",
    theme = "DeepBlue",
    size = UDim2.fromOffset(480, 300),
    autoshow = true,
    searchtopbar = true,
    loadinggui = true
})

local tab = win:AddTab({
    name = "Main",
    icon = "home"
})

local gb = tab:AddLeftGroupbox({
    name = "Features",
    icon = "star"
})

gb:AddLabel({text = "Welcome!"})

gb:AddButton({
    text = "Click Me",
    callback = function()
        print("Button clicked!")
    end
})

gb:AddParagraph({
    text = "Info",
    description = "This is a paragraph with description"
})

gb:AddToggle({
    text = "Enable Feature",
    default = true,
    callback = function(value)
        print("Toggled:", value)
    end
})

gb:AddSlider({
    text = "Speed",
    min = 0,
    max = 100,
    default = 50,
    callback = function(value)
        print("Slider:", value)
    end
})

gb:AddDropdown({
    text = "Select Option",
    callback = function()
        print("Dropdown clicked")
    end
})

gb:AddDivider()

gb:AddTextbox({
    placeholder = "Type here...",
    callback = function(text)
        print("Text:", text)
    end
})```
