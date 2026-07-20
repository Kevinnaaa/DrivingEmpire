-- ============================================
-- RAYFIELD GEN2 UI SCRIPT
-- Using: https://sirius.menu/gen2
-- ============================================

-- Load Rayfield Gen2
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/gen2"))()

-- Check if loaded
if not Rayfield then
    warn("Failed to load Rayfield Gen2!")
    return
end

-- ============================================
-- CREATE WINDOW
-- ============================================
local Window = Rayfield:CreateWindow({
    name = "My Script Hub",
    subtitle = "Rayfield Gen2",
    configurationSaving = {
        enabled = true,
        folderName = "MyScriptHub",
        fileName = "MainConfig"
    }
})

-- ============================================
-- CREATE TABS
-- ============================================
local MainTab = Window:CreateTab({ 
    name = "Main", 
    icon = "home" 
})

local CombatTab = Window:CreateTab({ 
    name = "Combat", 
    icon = "crosshair" 
})

local VisualsTab = Window:CreateTab({ 
    name = "Visuals", 
    icon = "eye" 
})

local SettingsTab = Window:CreateTab({ 
    name = "Settings", 
    icon = "settings" 
})

-- ============================================
-- MAIN TAB
-- ============================================
MainTab:CreateSection({ name = "Main Features" })

-- Toggle
MainTab:CreateToggle({
    name = "Auto Farm",
    callback = function(value)
        print("Auto Farm:", value)
        if value then
            -- Start auto farm
            print("Auto Farm Enabled")
        else
            -- Stop auto farm
            print("Auto Farm Disabled")
        end
    end
})

-- Toggle with default value
MainTab:CreateToggle({
    name = "Speed Hack",
    default = false,
    callback = function(value)
        print("Speed Hack:", value)
    end
})

-- Slider
MainTab:CreateSlider({
    name = "Walk Speed",
    min = 16,
    max = 100,
    default = 16,
    suffix = "Speed",
    callback = function(value)
        print("Walk Speed:", value)
        if game.Players.LocalPlayer.Character then
            local hum = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = value
            end
        end
    end
})

-- Slider with increment
MainTab:CreateSlider({
    name = "Jump Power",
    min = 0,
    max = 100,
    default = 50,
    increment = 5,
    callback = function(value)
        print("Jump Power:", value)
    end
})

-- Button
MainTab:CreateButton({
    name = "Click Me",
    callback = function()
        print("Button clicked!")
        Rayfield:Notify({
            title = "Notification",
            content = "Hello World!",
            duration = 3
        })
    end
})

-- Dropdown
MainTab:CreateDropdown({
    name = "Select Option",
    options = {"Option 1", "Option 2", "Option 3"},
    default = "Option 1",
    callback = function(value)
        print("Selected:", value)
    end
})

-- Input
MainTab:CreateInput({
    name = "Enter Text",
    placeholder = "Type something...",
    default = "",
    callback = function(value)
        print("Input:", value)
    end
})

-- Keybind
MainTab:CreateKeybind({
    name = "Toggle Feature",
    key = Enum.KeyCode.G,
    callback = function()
        print("Keybind pressed!")
    end
})

-- ============================================
-- COMBAT TAB
-- ============================================
CombatTab:CreateSection({ name = "Aimbot Settings" })

CombatTab:CreateToggle({
    name = "Enable Aimbot",
    default = false,
    callback = function(value)
        print("Aimbot:", value)
    end
})

CombatTab:CreateSlider({
    name = "FOV Radius",
    min = 50,
    max = 500,
    default = 100,
    suffix = "px",
    callback = function(value)
        print("FOV Radius:", value)
    end
})

CombatTab:CreateSlider({
    name = "Aimbot Smoothing",
    min = 1,
    max = 10,
    default = 3,
    suffix = "Smooth",
    callback = function(value)
        print("Smoothing:", value)
    end
})

CombatTab:CreateSection({ name = "Triggerbot Settings" })

CombatTab:CreateToggle({
    name = "Enable Triggerbot",
    default = false,
    callback = function(value)
        print("Triggerbot:", value)
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================
VisualsTab:CreateSection({ name = "ESP Settings" })

VisualsTab:CreateToggle({
    name = "Enable ESP",
    default = false,
    callback = function(value)
        print("ESP:", value)
    end
})

VisualsTab:CreateToggle({
    name = "Show Box ESP",
    default = true,
    callback = function(value)
        print("Box ESP:", value)
    end
})

VisualsTab:CreateToggle({
    name = "Show Name ESP",
    default = true,
    callback = function(value)
        print("Name ESP:", value)
    end
})

VisualsTab:CreateToggle({
    name = "Show Health ESP",
    default = true,
    callback = function(value)
        print("Health ESP:", value)
    end
})

VisualsTab:CreateSection({ name = "World Effects" })

VisualsTab:CreateButton({
    name = "Toggle Full Bright",
    callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = lighting.Brightness == 1 and 10 or 1
        Rayfield:Notify({
            title = "Full Bright",
            content = lighting.Brightness == 10 and "Enabled" or "Disabled",
            duration = 2
        })
    end
})

-- ============================================
-- SETTINGS TAB
-- ============================================
SettingsTab:CreateSection({ name = "UI Settings" })

SettingsTab:CreateButton({
    name = "Hide UI",
    callback = function()
        Window:SetVisibility(false)
    end
})

SettingsTab:CreateButton({
    name = "Show UI",
    callback = function()
        Window:SetVisibility(true)
    end
})

SettingsTab:CreateButton({
    name = "Destroy UI",
    callback = function()
        Rayfield:Destroy()
    end
})

SettingsTab:CreateSection({ name = "About" })

SettingsTab:CreateLabel({ 
    name = "Rayfield Gen2 UI" 
})

SettingsTab:CreateLabel({ 
    name = "By Sirius Software" 
})

-- ============================================
-- NOTIFICATION ON LOAD
-- ============================================
Rayfield:Notify({
    title = "Success",
    content = "UI Loaded Successfully!",
    duration = 3
})

print("Rayfield Gen2 loaded successfully!")
