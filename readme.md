# load ui
```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()
```

```luau
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/SCRIPTHUB-dev-god/wave-ui/refs/heads/main/main.lua"))()

local window = library:CreateWindow({
	title = "Premium Hub Tester",
	desc = "Full API Integration Framework Inside Mobile Screen",
	footer = "wave ui: v1.3 loaded",
	open = true
})

library:SetTopTags({"MAIN", "VIP"})

local combatTab = library:CreateTab("Combat Frame")
local leftGroup = combatTab:CreateGroupBox("Self Options", "left", "open")
local rightGroup = combatTab:CreateGroupBox("Target Setup", "right", "open")
local allsideGroup = combatTab:CreateGroupBox("Subsystem Router", "allside", "open")

leftGroup:CreateToggle("Fly System", false, function(state)
	print("Fly state updated:", state)
end)

leftGroup:CreateSlider("Walkspeed Multiplier", 16, 500, 16, function(value)
	print("Walkspeed adjusted:", value)
end)

rightGroup:CreateInput("Target Player", "Username here...", function(text, enter)
	print("Input submitted:", text, "Enter key:", enter)
end)

rightGroup:CreateDropdown("Hit Priority", {"Head", "HumanoidRootPart", "Torso"}, function(selection)
	print("Dropdown selection:", selection)
end)

local subTab1 = allsideGroup:tabbox("Main Frame")
local subTab2 = allsideGroup:tabbox("Secondary Frame")

if subTab1 then
	subTab1:CreateLabel("Core Subsystem Status: Valid")
	subTab1:CreateDivider()
	subTab1:CreateButton("Initialize Script Processing", function()
		print("Subtab 1 system activation executed.")
	end)
end

if subTab2 then
	subTab2:CreateParagraph("This interface section processes visual and environmental overrides asynchronously inside the hub frame structure.")
	subTab2:CreateToggle("Full ESP Network", false, function(state)
		print("Subtab 2 feature status:", state)
	end)
end
```
