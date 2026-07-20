-- ============================================
-- RAYFIELD UI - Using sirius.menu/rayfield
-- ============================================

-- Load Rayfield from sirius.menu
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Check if loaded
if not Rayfield then
    warn("Failed to load Rayfield from sirius.menu")
    -- Fallback to working source
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kevinnaaa/BloxStrike/main/ref.lua"))()
end

if not Rayfield then
    error("❌ Failed to load Rayfield from any source!")
end

-- ============================================
-- CREATE WINDOW
-- ============================================
local Window = Rayfield:CreateWindow({
    Name = "Script Hub",
    LoadingTitle = "Loading Script Hub...",
    LoadingSubtitle = "by QueezZy123",
    Theme = "Amethyst",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ScriptHub",
        FileName = "MainConfig"
    },
    KeySystem = false,
    ToggleUIKeybind = "K"
})

-- ============================================
-- CREATE TABS
-- ============================================
local MainTab = Window:CreateTab("Main", "home")
local SecurityTab = Window:CreateTab("Security", "shield")
local VisualsTab = Window:CreateTab("Visuals", "eye")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- ============================================
-- MAIN TAB
-- ============================================
MainTab:CreateSection("Welcome")

MainTab:CreateLabel("═══════════════════════════════════", 0, Color3.fromRGB(150, 80, 200), false)
MainTab:CreateLabel("✨ Script by QueezZy123 (Maryyy) ✨", 0, Color3.fromRGB(255, 200, 100), false)
MainTab:CreateLabel("🎮 Games: Driving Empire", 0, Color3.fromRGB(150, 200, 255), false)
MainTab:CreateLabel("═══════════════════════════════════", 0, Color3.fromRGB(150, 80, 200), false)

MainTab:CreateSection("Quick Actions")

MainTab:CreateButton({
    Name = "Print Hello",
    Callback = function()
        print("Hello from QueezZy123!")
        Rayfield:Notify({
            Title = "Success",
            Content = "Hello World!",
            Duration = 3
        })
    end
})

-- ============================================
-- SECURITY TAB (Teleport & Attach)
-- ============================================
SecurityTab:CreateSection("Teleport & Attach")

-- Player selection dropdown
local selectedTarget = nil

local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
        if plr ~= game:GetService("Players").LocalPlayer then
            table.insert(names, plr.Name)
        end
    end
    if #names == 0 then
        table.insert(names, "No players found")
    end
    return names
end

local Dropdown = SecurityTab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    CurrentOption = {GetPlayerNames()[1]},
    Flag = "SelectedPlayer",
    Callback = function(Options)
        selectedTarget = Options[1]
        print("📌 Selected:", selectedTarget)
    end
})

SecurityTab:CreateDivider()

-- Status Label
local StatusLabel = SecurityTab:CreateLabel("📌 Status: No player selected", 0, Color3.fromRGB(200, 200, 220), false)

SecurityTab:CreateDivider()

-- Teleport Button
SecurityTab:CreateButton({
    Name = "📍 Teleport to Player",
    Callback = function()
        if not selectedTarget or selectedTarget == "No players found" then
            print("❌ No player selected")
            return
        end
        
        local target = game:GetService("Players"):FindFirstChild(selectedTarget)
        if not target or not target.Character then
            print("❌ Player not found or no character")
            return
        end
        
        local player = game:GetService("Players").LocalPlayer
        local myChar = player.Character
        if not myChar then
            print("❌ You have no character")
            return
        end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        
        if myHRP and targetHRP then
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
            print("✅ Teleported to:", target.Name)
            StatusLabel:Set("✅ Teleported to " .. target.Name)
        end
    end
})

-- Attach Button
local isAttached = false
local attachedPlayer = nil
local attachmentConnection = nil

SecurityTab:CreateButton({
    Name = "🔗 Attach to Player",
    Callback = function()
        if not selectedTarget or selectedTarget == "No players found" then
            print("❌ No player selected")
            return
        end
        
        local target = game:GetService("Players"):FindFirstChild(selectedTarget)
        if not target or not target.Character then
            print("❌ Player not found or no character")
            return
        end
        
        -- Detach first if already attached
        if isAttached then
            if attachmentConnection then
                attachmentConnection:Disconnect()
                attachmentConnection = nil
            end
            isAttached = false
            attachedPlayer = nil
        end
        
        attachedPlayer = target
        isAttached = true
        
        attachmentConnection = game:GetService("RunService").Heartbeat:Connect(function()
            if not isAttached or not attachedPlayer or not attachedPlayer.Character then
                return
            end
            
            local player = game:GetService("Players").LocalPlayer
            local myChar = player.Character
            if not myChar then return end
            
            local myHRP = myChar:FindFirstChild("HumanoidRootPart")
            local targetHRP = attachedPlayer.Character:FindFirstChild("HumanoidRootPart")
            
            if myHRP and targetHRP then
                myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
            end
        end)
        
        print("✅ Attached to:", target.Name)
        StatusLabel:Set("🔗 Attached to " .. target.Name)
    end
})

-- Detach Button
SecurityTab:CreateButton({
    Name = "🔓 Detach from Player",
    Callback = function()
        if not isAttached then
            print("❌ Not attached to anyone")
            return
        end
        
        if attachmentConnection then
            attachmentConnection:Disconnect()
            attachmentConnection = nil
        end
        isAttached = false
        attachedPlayer = nil
        
        print("✅ Detached from player")
        StatusLabel:Set("🔓 Detached from player")
    end
})

-- ============================================
-- VISUALS TAB
-- ============================================
VisualsTab:CreateSection("ESP Settings")

VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        print("ESP:", Value)
    end
})

VisualsTab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = true,
    Flag = "BoxESP",
    Callback = function(Value)
        print("Box ESP:", Value)
    end
})

VisualsTab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = true,
    Flag = "NameESP",
    Callback = function(Value)
        print("Name ESP:", Value)
    end
})

VisualsTab:CreateToggle({
    Name = "Health ESP",
    CurrentValue = true,
    Flag = "HealthESP",
    Callback = function(Value)
        print("Health ESP:", Value)
    end
})

VisualsTab:CreateSection("World Effects")

VisualsTab:CreateButton({
    Name = "Full Bright",
    Callback = function()
        local lighting = game:GetService("Lighting")
        lighting.Brightness = lighting.Brightness == 1 and 10 or 1
        Rayfield:Notify({
            Title = "Full Bright",
            Content = lighting.Brightness == 10 and "Enabled" or "Disabled",
            Duration = 2
        })
    end
})

-- ============================================
-- SETTINGS TAB (Only Terminate)
-- ============================================
SettingsTab:CreateSection("Script Control")

SettingsTab:CreateButton({
    Name = "⚠️ Terminate Script",
    Callback = function()
        Rayfield:Notify({
            Title = "⚠️ Terminating...",
            Content = "Script will be terminated!",
            Duration = 2
        })
        task.wait(1)
        Rayfield:Destroy()
        error("Script terminated by user", 0)
    end
})

SettingsTab:CreateDivider()
SettingsTab:CreateLabel("Made with ❤️ by QueezZy123", 0, Color3.fromRGB(100, 100, 140), false)
SettingsTab:CreateLabel("Press K to toggle UI", 0, Color3.fromRGB(80, 80, 120), false)

-- ============================================
-- LOAD CONFIGURATION
-- ============================================
Rayfield:LoadConfiguration()

-- ============================================
-- WELCOME NOTIFICATION
-- ============================================
Rayfield:Notify({
    Title = "Success",
    Content = "UI Loaded Successfully!",
    Duration = 3
})

print("✨ Modern UI loaded successfully!")
print("📌 Script by QueezZy123")
print("🎮 Games: Driving Empire")
print("📌 Press K to toggle the UI")
