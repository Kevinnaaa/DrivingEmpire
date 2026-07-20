-- ============================================
-- RAYFIELD UI - Auto-Refresh Players (0.5s)
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
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ============================================
-- STATE VARIABLES
-- ============================================
local isAttached = false
local attachedPlayer = nil
local attachmentConnection = nil
local selectedTarget = nil
local ATTACH_DISTANCE = 10
local Dropdown = nil
local StatusLabel = nil

-- ============================================
-- TELEPORT FUNCTION
-- ============================================
local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or targetPlayer == "No players found" then
        print("❌ No valid player selected")
        return false
    end
    
    local target = Players:FindFirstChild(targetPlayer)
    if not target then
        print("❌ Player not found: " .. targetPlayer)
        return false
    end
    
    local targetChar = target.Character
    if not targetChar then
        target.CharacterAdded:Wait()
        task.wait(0.5)
        targetChar = target.Character
        if not targetChar then
            print("❌ Target character failed to load")
            return false
        end
    end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
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
    
    local targetPos = targetHRP.Position
    local myPos = myHRP.Position
    local direction = (myPos - targetPos).Unit
    
    if (myPos - targetPos).Magnitude < 5 then
        direction = (targetHRP.CFrame.LookVector * -1).Unit
    end
    
    local newPos = targetPos + direction * ATTACH_DISTANCE
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {myChar, targetChar}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local rayOrigin = newPos + Vector3.new(0, 50, 0)
    local rayDirection = Vector3.new(0, -100, 0)
    local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if result then
        local groundPos = result.Position
        if (groundPos - newPos).Magnitude < 10 then
            newPos = groundPos + Vector3.new(0, 3, 0)
        end
    end
    
    local cframe = CFrame.new(newPos, targetHRP.Position)
    myHRP.CFrame = cframe
    
    print("✅ Teleported to: " .. target.Name .. " (10 studs away)")
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
    
    if isAttached then
        DetachFromPlayer()
    end
    
    attachedPlayer = target
    isAttached = true
    
    TeleportToPlayer(targetPlayer)
    
    attachmentConnection = RunService.Heartbeat:Connect(function()
        if not isAttached or not attachedPlayer then
            DetachFromPlayer()
            return
        end
        
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
            local targetPos = targetHRP.Position
            local myPos = myHRP.Position
            local currentDistance = (myPos - targetPos).Magnitude
            
            if currentDistance < (ATTACH_DISTANCE - 2) or currentDistance > (ATTACH_DISTANCE + 2) then
                local direction = (myPos - targetPos).Unit
                
                if currentDistance < 3 then
                    direction = (targetHRP.CFrame.LookVector * -1).Unit
                end
                
                local newPos = targetPos + direction * ATTACH_DISTANCE
                
                local raycastParams = RaycastParams.new()
                raycastParams.FilterDescendantsInstances = {myChar, attachedPlayer.Character}
                raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local rayOrigin = newPos + Vector3.new(0, 50, 0)
                local rayDirection = Vector3.new(0, -100, 0)
                local result = Workspace:Raycast(rayOrigin, rayDirection, raycastParams)
                
                if result then
                    local groundPos = result.Position
                    if (groundPos - newPos).Magnitude < 10 then
                        newPos = groundPos + Vector3.new(0, 3, 0)
                    end
                end
                
                local cframe = CFrame.new(newPos, targetHRP.Position)
                myHRP.CFrame = cframe
            end
            
            local lookAtCFrame = CFrame.lookAt(myHRP.Position, targetHRP.Position)
            myHRP.CFrame = lookAtCFrame
        end
    end)
    
    print("✅ Attached to: " .. target.Name .. " (10 studs away)")
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
-- AUTO-REFRESH PLAYER LIST (Every 0.5s)
-- ============================================
local function RefreshPlayerList()
    if not Dropdown then return end
    
    local currentNames = GetPlayerNames()
    local currentSelected = selectedTarget
    
    -- Check if current selected still exists
    local stillExists = false
    for _, name in ipairs(currentNames) do
        if name == currentSelected then
            stillExists = true
            break
        end
    end
    
    -- Update dropdown options
    Dropdown:Refresh(currentNames)
    
    -- If selected player no longer exists, select first available
    if not stillExists and currentSelected and currentSelected ~= "No players found" then
        if #currentNames > 0 and currentNames[1] ~= "No players found" then
            selectedTarget = currentNames[1]
            Dropdown:Set({selectedTarget})
            if StatusLabel then
                StatusLabel:Set("📌 Status: Selected " .. selectedTarget)
            end
        else
            selectedTarget = "No players found"
            Dropdown:Set({"No players found"})
            if StatusLabel then
                StatusLabel:Set("📌 Status: No players found")
            end
        end
    end
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
-- SECURITY TAB
-- ============================================
SecurityTab:CreateSection("Teleport & Attach")

-- Player selection dropdown
Dropdown = SecurityTab:CreateDropdown({
    Name = "Select Player",
    Options = GetPlayerNames(),
    CurrentOption = {GetPlayerNames()[1]},
    Flag = "SelectedPlayer",
    Callback = function(Options)
        selectedTarget = Options[1]
        print("📌 Selected:", selectedTarget)
        
        if isAttached and attachedPlayer and attachedPlayer.Name == selectedTarget then
            StatusLabel:Set("📌 Status: Attached to " .. selectedTarget .. " (10 studs)")
        else
            StatusLabel:Set("📌 Status: Selected " .. selectedTarget)
        end
    end
})

SecurityTab:CreateDivider()

-- Status Label
StatusLabel = SecurityTab:CreateLabel("📌 Status: No player selected", 0, Color3.fromRGB(200, 200, 220), false)

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
            StatusLabel:Set("✅ Teleported to " .. selectedTarget .. " (10 studs)")
            Rayfield:Notify({
                Title = "Success",
                Content = "Teleported to " .. selectedTarget .. " (10 studs away)",
                Duration = 3
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
    Name = "🔗 Attach to Player (10 studs)",
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
            StatusLabel:Set("🔗 Attached to " .. selectedTarget .. " (10 studs)")
            Rayfield:Notify({
                Title = "Success",
                Content = "Attached to " .. selectedTarget .. " (10 studs away)",
                Duration = 3
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

-- Distance Display
SecurityTab:CreateLabel("📏 Attach Distance: 10 studs", 0, Color3.fromRGB(150, 200, 255), false)
SecurityTab:CreateLabel("🔄 Auto-refresh: Every 0.5s", 0, Color3.fromRGB(150, 200, 150), false)

-- ============================================
-- START AUTO-REFRESH (Every 0.5 seconds)
-- ============================================
task.spawn(function()
    while true do
        task.wait(0.5) -- Refresh every 0.5 seconds
        if not Rayfield or not Dropdown then break end
        pcall(RefreshPlayerList)
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
-- SETTINGS TAB
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
-- CLEANUP
-- ============================================
player.CharacterAdded:Connect(function()
    if isAttached and attachedPlayer then
        task.wait(1)
        if attachedPlayer and attachedPlayer.Character then
            local targetHRP = attachedPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetHRP then
                local myChar = player.Character
                if myChar then
                    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        local targetPos = targetHRP.Position
                        local direction = (myHRP.Position - targetPos).Unit
                        if (myHRP.Position - targetPos).Magnitude < 3 then
                            direction = (targetHRP.CFrame.LookVector * -1).Unit
                        end
                        local newPos = targetPos + direction * ATTACH_DISTANCE
                        myHRP.CFrame = CFrame.new(newPos, targetHRP.Position)
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
    Content = "UI Loaded Successfully! (10 studs, 0.5s refresh)",
    Duration = 3
})

print("✨ Modern UI loaded successfully!")
print("📌 Script by QueezZy123")
print("🎮 Games: Driving Empire")
print("📌 Press K to toggle the UI")
print("📏 Attach Distance: 10 studs")
print("🔄 Auto-refresh: Every 0.5 seconds")
