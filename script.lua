-- ============================================
-- MODERN UI - Clean Template
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- MAIN FRAME
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 1

-- Open animation
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0
}):Play()

-- Corner rounding
local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, radius or 8)
end
RoundCorners(MainFrame, 12)

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Parent = MainFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.4
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0, 5, 0, 5)
Shadow.Size = UDim2.new(1, -10, 1, -10)
RoundCorners(Shadow, 12)

-- ============================================
-- TOP BAR
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 50)
RoundCorners(TopBar, 12)

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "My Script"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -45, 0.5, -15)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
RoundCorners(CloseBtn, 15)

-- Hide Button
local HideBtn = Instance.new("TextButton")
HideBtn.Parent = TopBar
HideBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
HideBtn.BackgroundTransparency = 0.8
HideBtn.BorderSizePixel = 0
HideBtn.Position = UDim2.new(1, -85, 0.5, -15)
HideBtn.Size = UDim2.new(0, 30, 0, 30)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.Text = "─"
HideBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
HideBtn.TextSize = 18
RoundCorners(HideBtn, 15)

-- ============================================
-- TABS
-- ============================================
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 50)
TabContainer.Size = UDim2.new(0, 150, 1, -50)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 150, 0, 50)
Content.Size = UDim2.new(1, -150, 1, -50)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

-- Tab system
local tabs = {}
local currentTab = nil
local contentY = 10

-- ============================================
-- UI ELEMENTS
-- ============================================
local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 0, 0, #TabContainer:GetChildren() * 45 + 10)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(btn, 8)
    
    local function select()
        if currentTab == name then return end
        currentTab = name
        Content:ClearAllChildren()
        contentY = 10
        
        for _, child in pairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                child.TextColor3 = Color3.fromRGB(180, 180, 200)
            end
        end
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    btn.MouseButton1Click:Connect(select)
    return {select = select}
end

local function AddSection(text)
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 220)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    contentY = contentY + 35
    return frame
end

local function AddButton(text, callback)
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(1, -100, 0.5, -17)
    btn.Size = UDim2.new(0, 85, 0, 34)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "Run"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    RoundCorners(btn, 8)
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    
    contentY = contentY + 50
    return frame
end

local function AddToggle(text, default, callback)
    local state = default or false
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0, 250, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("Frame")
    toggle.Parent = frame
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    toggle.BorderSizePixel = 0
    toggle.Position = UDim2.new(1, -55, 0.5, -15)
    toggle.Size = UDim2.new(0, 40, 0, 30)
    RoundCorners(toggle, 15)
    
    local indicator = Instance.new("Frame")
    indicator.Parent = toggle
    indicator.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 3, 0.5, -12)
    indicator.Size = UDim2.new(0, 24, 0, 24)
    RoundCorners(indicator, 12)
    
    local function update(val)
        state = val
        if state then
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 200, 120)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.3), {Position = UDim2.new(1, -27, 0.5, -12)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 80, 100)}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.3), {Position = UDim2.new(0, 3, 0.5, -12)}):Play()
        end
        if callback then callback(state) end
    end
    
    toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            update(not state)
        end
    end)
    
    update(state)
    contentY = contentY + 50
    return frame
end

local function AddSlider(text, min, max, default, callback)
    local value = default or 50
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 55)
    RoundCorners(frame, 8)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Size = UDim2.new(0, 250, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(220, 220, 240)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local bg = Instance.new("Frame")
    bg.Parent = frame
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    bg.BorderSizePixel = 0
    bg.Position = UDim2.new(0, 10, 0.65, 0)
    bg.Size = UDim2.new(1, -20, 0, 6)
    RoundCorners(bg, 3)
    
    local fill = Instance.new("Frame")
    fill.Parent = bg
    fill.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    RoundCorners(fill, 3)
    
    local dragging = false
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            local pos = input.Position.X - bg.AbsolutePosition.X
            local percent = math.clamp(pos / bg.AbsoluteSize.X, 0, 1)
            value = math.round(min + (max - min) * percent)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = input.Position.X - bg.AbsolutePosition.X
            local percent = math.clamp(pos / bg.AbsoluteSize.X, 0, 1)
            value = math.round(min + (max - min) * percent)
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. tostring(value)
            if callback then callback(value) end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    contentY = contentY + 60
    return frame
end

-- ============================================
-- CREATE TABS
-- ============================================
local mainTab = CreateTab("Main", "🏠")
local combatTab = CreateTab("Combat", "⚔️")
local visualsTab = CreateTab("Visuals", "👁️")
local settingsTab = CreateTab("Settings", "⚙️")

-- ============================================
-- MAIN TAB CONTENT
-- ============================================
mainTab.select()
AddSection("Main Features")
AddToggle("Auto Farm", false, function(v) print("Auto Farm:", v) end)
AddToggle("Speed Hack", false, function(v) 
    print("Speed Hack:", v)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and 50 or 16 end
    end
end)
AddSlider("Walk Speed", 16, 100, 50, function(v)
    if player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v end
    end
end)
AddSection("Actions")
AddButton("Print Hello", function() print("Hello World!") end)

-- ============================================
-- COMBAT TAB CONTENT
-- ============================================
combatTab.select()
AddSection("Combat Settings")
AddToggle("Aimbot", false, function(v) print("Aimbot:", v) end)
AddToggle("Triggerbot", false, function(v) print("Triggerbot:", v) end)
AddSlider("FOV Radius", 50, 500, 100, function(v) print("FOV:", v) end)
AddSlider("Smoothing", 1, 10, 3, function(v) print("Smoothing:", v) end)

-- ============================================
-- VISUALS TAB CONTENT
-- ============================================
visualsTab.select()
AddSection("ESP Settings")
AddToggle("Enable ESP", false, function(v) print("ESP:", v) end)
AddToggle("Box ESP", true, function(v) print("Box ESP:", v) end)
AddToggle("Name ESP", true, function(v) print("Name ESP:", v) end)
AddToggle("Health ESP", true, function(v) print("Health ESP:", v) end)
AddSection("World")
AddButton("Full Bright", function()
    local lighting = game:GetService("Lighting")
    lighting.Brightness = lighting.Brightness == 1 and 10 or 1
end)

-- ============================================
-- SETTINGS TAB CONTENT
-- ============================================
settingsTab.select()
AddSection("UI Settings")
AddButton("Hide UI", function() MainFrame.Visible = false end)
AddButton("Destroy UI", function() ScreenGui:Destroy() end)

-- ============================================
-- WINDOW CONTROLS
-- ============================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

HideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- ============================================
-- DRAGGABLE WINDOW
-- ============================================
local dragging = false
local dragInput, dragStart, startPos

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("Modern UI loaded!")
