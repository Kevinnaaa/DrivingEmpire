-- ============================================
-- RAYFIELD UI - Working Teleport & Attach
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

if not Rayfield then
    Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kevinnaaa/BloxStrike/main/ref.lua"))()
end

if not Rayfield then
    error("❌ Failed to load Rayfield!")
end

-- ============================================
-- SERVICES
-- ============================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ============================================
-- STATE VARIABLES
-- ============================================
local isAttached = false
local attachedPlayer = nil
local attachmentConnection = nil
local selectedTarget = nil

-- ============================================
-- TELEPORT FUNCTION
-- ============================================
local function TeleportToPlayer(targetPlayer)
    if not targetPlayer then
        print("❌ No target player selected")
        return false
    end
    
    if targetPlayer == "No players found" then
        print("❌ No players found in the game")
        return false
    end
    
    local target = Players:FindFirstChild(targetPlayer)
    if not target then
        print("❌ Player not found: " .. targetPlayer)
        return false
    end
    
    if not target.Character then
        print("❌ Target has no character: " .. targetPlayer)
        return false
    end
    
    local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        print("❌ Target has no HumanoidRootPart")
        return false
    end
    
    local myChar = player.Character
    if not myChar then
        print("❌ You have no character")
        return false
    end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        print("❌ You have no HumanoidRootPart")
        return false
    end
    
    -- Teleport to target (slightly above to avoid clipping)
    myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    print("✅ Teleported to: " .. target.Name)
    return true
end

-- ============================================
-- ATTACH FUNCTION
-- ============================================
local function AttachToPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == "No players found" then
        print("❌ No valid player selected")
        return false
    end
    
    local target = Players:FindFirstChild(targetPlayer)
    if not target then
        print("❌ Player not found: " .. targetPlayer)
        return false
    end
    
    if not target.Character then
        print("❌ Target has no character")
        return false
    end
    
    -- Detach first if already attached
    if isAttached then
        DetachFromPlayer()
    end
    
    attachedPlayer = target
    isAttached = true
    
    -- Create attachment connection
    attachmentConnection = RunService.Heartbeat:Connect(function()
        if not isAttached or not attachedPlayer then
            DetachFromPlayer()
            return
        end
        
        -- Check if target still exists and has a character
        if not attachedPlayer.Parent or not attachedPlayer.Character then
            print("⚠️ Target left the game or died, detaching...")
            DetachFromPlayer()
            return
        end
        
        local myChar = player.Character
        if not myChar then
            return
        end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = attachedPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if myHRP and targetHRP then
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        end
    end)
    
    print("✅ Attached to: " .. target.Name)
    return true
end

-- ============================================
-- DETACH FUNCTION
-- ============================================
local function DetachFromPlayer()
    if attachmentConnection then
        attachmentConnection:Disconnect()
        attachmentConnection = nil
    end
    
    local oldAttached = attachedPlayer
    isAttached = false
    attachedPlayer = nil
    
    if oldAttached then
        print("✅ Detached from: " .. oldAttached.Name)
    else
        print("✅ Detached from player")
    end
    return true
end

-- ============================================
-- GET PLAYER LIST
-- ============================================
local function GetPlayerNames()
    local names = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            table.insert(names, plr.Name)
        end
    end
    if #names == 0 then
        table.insert(names, "No players found")
    end
    return names
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

-- Player selection dropdown (refreshes list)
local function RefreshDropdown()
    local names = GetPlayerNames()
    Dropdown:Refresh(names)
    if #names > 0 and names[1] ~= "No players found" then
        Dropdown:Set({names[1]})
        selectedTarget = names[1]
    else
        Dropdown:Set({"No players found"})
        selectedTarget = "No players found"
    end
end

local Dropdown = SecurityTab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    CurrentOption = {GetPlayerNames()[1]},
    Flag = "SelectedPlayer",
    Callback = function(Options)
        selectedTarget = Options[1]
        print("📌 Selected:", selectedTarget)
        
        -- Update status label
        if isAttached and attachedPlayer and attachedPlayer.Name == selectedTarget then
            StatusLabel:Set("📌 Status: Attached to " .. selectedTarget)
        else
            StatusLabel:Set("📌 Status: Selected " .. selectedTarget)
        end
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
            Rayfield:Notify({
                Title = "Error",
                Content = "No player selected!",
                Duration = 2
            })
            return
        end
        
        local success = TeleportToPlayer(selectedTarget)
        
        if success then
            StatusLabel:Set("✅ Teleported to " .. selectedTarget)
            Rayfield:Notify({
                Title = "Success",
                Content = "Teleported to " .. selectedTarget,
                Duration = 2
            })
        else
            StatusLabel:Set("❌ Failed to teleport")
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to teleport!",
                Duration = 2
            })
        end
    end
})

-- Attach Button
SecurityTab:CreateButton({
    Name = "🔗 Attach to Player",
    Callback = function()
        if not selectedTarget or selectedTarget == "No players found" then
            print("❌ No player selected")
            Rayfield:Notify({
                Title = "Error",
                Content = "No player selected!",
                Duration = 2
            })
            return
        end
        
        if isAttached then
            DetachFromPlayer()
        end
        
        local success = AttachToPlayer(selectedTarget)
        
        if success then
            StatusLabel:Set("🔗 Attached to " .. selectedTarget)
            Rayfield:Notify({
                Title = "Success",
                Content = "Attached to " .. selectedTarget,
                Duration = 2
            })
        else
            StatusLabel:Set("❌ Failed to attach")
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to attach!",
                Duration = 2
            })
        end
    end
})

-- Detach Button
SecurityTab:CreateButton({
    Name = "🔓 Detach from Player",
    Callback = function()
        if not isAttached then
            print("❌ Not attached to anyone")
            Rayfield:Notify({
                Title = "Info",
                Content = "Not attached to anyone",
                Duration = 2
            })
            return
        end
        
        local oldName = attachedPlayer and attachedPlayer.Name or "unknown"
        DetachFromPlayer()
        StatusLabel:Set("🔓 Detached from " .. oldName)
        
        Rayfield:Notify({
            Title = "Success",
            Content = "Detached from " .. oldName,
            Duration = 2
        })
    end
})

SecurityTab:CreateDivider()

-- Refresh Player List Button
SecurityTab:CreateButton({
    Name = "🔄 Refresh Player List",
    Callback = function()
        RefreshDropdown()
        Rayfield:Notify({
            Title = "Info",
            Content = "Player list refreshed!",
            Duration = 2
        })
    end
})

-- Auto-refresh player list every 5 seconds
task.spawn(function()
    while true do
        task.wait(5)
        if not Rayfield then break end
        -- Only refresh if dropdown exists and no one is selected
        if Dropdown and selectedTarget then
            local currentNames = GetPlayerNames()
            -- Check if current selected still exists
            local stillExists = false
            for _, name in ipairs(currentNames) do
                if name == selectedTarget then
                    stillExists = true
                    break
                end
            end
            if not stillExists and selectedTarget ~= "No players found" and #currentNames > 0 then
                selectedTarget = currentNames[1]
                Dropdown:Set({selectedTarget})
                StatusLabel:Set("📌 Status: Selected " .. selectedTarget)
            end
        end
    end
end)

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
        -- Confirm before terminating
        Rayfield:Notify({
            Title = "⚠️ Terminating...",
            Content = "Script will be terminated!",
            Duration = 2
        })
        task.wait(1)
        -- Clean up attachment
        if isAttached then
            DetachFromPlayer()
        end
        Rayfield:Destroy()
        error("Script terminated by user", 0)
    end
})

SettingsTab:CreateDivider()
SettingsTab:CreateLabel("Made with ❤️ by QueezZy123", 0, Color3.fromRGB(100, 100, 140), false)
SettingsTab:CreateLabel("Press K to toggle UI", 0, Color3.fromRGB(80, 80, 120), false)

-- ============================================
-- CLEANUP ON SCRIPT END
-- ============================================
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function()
    -- If attached, re-attach after respawn
    if isAttached and attachedPlayer then
        task.wait(0.5)
        if attachedPlayer and attachedPlayer.Character then
            -- Re-attach after respawn
            local targetHRP = attachedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local myChar = player.Character
                if myChar then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
                    end
                end
            end
        end
    end
end)

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
print("📌 Select a player and use Teleport/Attach/Detach")
