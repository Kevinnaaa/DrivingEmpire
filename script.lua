-- Rayfield UI Loader Script (Using Sirius.menu)
-- This script fetches and loads the Rayfield UI library from sirius.menu

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Check if Rayfield loaded successfully
if not Rayfield then
    warn("Failed to load Rayfield UI from sirius.menu")
    -- Try alternative source if first fails
    local success, result = pcall(function()
        return loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
    end)
    if success and result then
        Rayfield = result
        print("Loaded Rayfield from GitHub backup")
    else
        warn("All sources failed to load Rayfield!")
        return
    end
end

-- Create a new window (No Key System)
local Window = Rayfield:CreateWindow({
    Name = "My Script Hub",
    LoadingTitle = "Loading Script Hub...",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "MyScriptHub",
        FileName = "MainConfig"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = false
})

-- Create a main tab
local MainTab = Window:CreateTab("Main", 4483362458)

-- Create a section in the main tab
local MainSection = MainTab:CreateSection("Main Features")

-- Create a button
MainTab:CreateButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello from Rayfield UI!")
        Rayfield:Notify({
            Title = "Notification",
            Content = "Hello World!",
            Duration = 3,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay",
                    Callback = function()
                        print("User clicked Okay")
                    end
                }
            }
        })
    end
})

-- Create a toggle
MainTab:CreateToggle({
    Name = "Enable Feature",
    CurrentValue = false,
    Callback = function(Value)
        print("Toggle value changed to: " .. tostring(Value))
        -- Your toggle logic here
    end
})

-- Create a slider
MainTab:CreateSlider({
    Name = "Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Callback = function(Value)
        print("Slider value: " .. tostring(Value))
        -- Your slider logic here
    end
})

-- Create a dropdown
MainTab:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    MultipleOptions = false,
    Callback = function(Option)
        print("Selected option: " .. Option)
    end
})

-- Create an input field
MainTab:CreateInput({
    Name = "Enter Text",
    PlaceholderText = "Type something...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        print("Input text: " .. Text)
    end
})

-- Create a color picker
MainTab:CreateColorPicker({
    Name = "Color Picker",
    Color = Color3.fromRGB(255, 255, 255),
    Callback = function(Color)
        print("Selected color: R:" .. Color.R * 255 .. " G:" .. Color.G * 255 .. " B:" .. Color.B * 255)
    end
})

-- Create a keybind
MainTab:CreateKeybind({
    Name = "Toggle Feature",
    CurrentKeybind = "G",
    HoldToInteract = false,
    Callback = function()
        print("Keybind pressed!")
        -- Your keybind logic here
    end
})

-- Create a second tab for settings
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Create a section in settings tab
local SettingsSection = SettingsTab:CreateSection("UI Settings")

-- Add a button to destroy the UI
SettingsTab:CreateButton({
    Name = "Destroy UI",
    Callback = function()
        Rayfield:Destroy()
        print("UI destroyed")
    end
})

-- Add a button to reload the UI
SettingsTab:CreateButton({
    Name = "Reload UI",
    Callback = function()
        Rayfield:Destroy()
        wait(0.5)
        local NewRayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
        if NewRayfield then
            print("UI reloaded successfully!")
        else
            warn("Failed to reload UI")
        end
    end
})

-- Add buttons to show/hide UI
SettingsTab:CreateButton({
    Name = "Hide UI",
    Callback = function()
        Window:Hide()
        print("UI hidden")
    end
})

SettingsTab:CreateButton({
    Name = "Show UI",
    Callback = function()
        Window:Show()
        print("UI shown")
    end
})

-- Custom notification example
Rayfield:Notify({
    Title = "Success",
    Content = "UI Loaded Successfully from sirius.menu!",
    Duration = 3,
    Image = 4483362458
})

print("Rayfield UI script loaded successfully from sirius.menu!")

-- Optional: Cleanup function
local function Cleanup()
    if Rayfield then
        Rayfield:Destroy()
        print("UI cleaned up")
    end
end

-- Auto-run cleanup when script is stopped (optional)
-- game:GetService("RunService").Stepped:Connect(function()
--     if not game:IsLoaded() then
--         Cleanup()
--     end
-- end)
