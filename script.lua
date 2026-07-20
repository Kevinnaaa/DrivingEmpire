-- ============================================
-- MODERN UI - Fixed Minimize Position
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game:GetService("CoreGui")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- STATE
-- ============================================
local isMinimized = false
local isHidden = false
local barPosition = UDim2.new(0.5, -150, 0.95, -20) -- Bottom center

-- ============================================
-- MAIN FRAME
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
MainFrame.Size = UDim2.new(0, 640, 0, 440)
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0.25
MainFrame.ZIndex = 10

-- Open animation
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    BackgroundTransparency = 0.25
}):Play()

-- Corner rounding
local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, radius or 8)
end
RoundCorners(MainFrame, 14)

-- Glow effect
local Glow = Instance.new("ImageLabel")
Glow.Parent = MainFrame
Glow.BackgroundTransparency = 1
Glow.Position = UDim2.new(-0.1, 0, -0.1, 0)
Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
Glow.Image = "rbxassetid://5028857083"
Glow.ImageColor3 = Color3.fromRGB(60, 80, 200)
Glow.ImageTransparency = 0.85
Glow.ZIndex = 0

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Parent = MainFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.5
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0, 8, 0, 8)
Shadow.Size = UDim2.new(1, -16, 1, -16)
RoundCorners(Shadow, 14)

-- ============================================
-- MINIMIZED BAR (Positioned at bottom center)
-- ============================================
local MinBar = Instance.new("Frame")
MinBar.Name = "MinBar"
MinBar.Parent = ScreenGui
MinBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MinBar.BackgroundTransparency = 0.25
MinBar.BorderSizePixel = 0
MinBar.Position = UDim2.new(0.5, -150, 0.95, -20) -- Bottom center
MinBar.Size = UDim2.new(0, 300, 0, 40)
MinBar.Visible = false
MinBar.ZIndex = 20
RoundCorners(MinBar, 14)

-- MinBar Shadow
local MinShadow = Instance.new("Frame")
MinShadow.Parent = MinBar
MinShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinShadow.BackgroundTransparency = 0.5
MinShadow.BorderSizePixel = 0
MinShadow.Position = UDim2.new(0, 4, 0, 4)
MinShadow.Size = UDim2.new(1, -8, 1, -8)
RoundCorners(MinShadow, 14)

-- MinBar Icon
local MinIcon = Instance.new("TextLabel")
MinIcon.Parent = MinBar
MinIcon.BackgroundTransparency = 1
MinIcon.Position = UDim2.new(0, 12, 0, 0)
MinIcon.Size = UDim2.new(0, 25, 1, 0)
MinIcon.Font = Enum.Font.GothamBold
MinIcon.Text = "⚡"
MinIcon.TextColor3 = Color3.fromRGB(60, 80, 200)
MinIcon.TextSize = 18
MinIcon.TextXAlignment = Enum.TextXAlignment.Center

-- MinBar Title
local MinTitle = Instance.new("TextLabel")
MinTitle.Parent = MinBar
MinTitle.BackgroundTransparency = 1
MinTitle.Position = UDim2.new(0, 42, 0, 0)
MinTitle.Size = UDim2.new(0, 150, 1, 0)
MinTitle.Font = Enum.Font.GothamBold
MinTitle.Text = "Script Hub"
MinTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
MinTitle.TextSize = 14
MinTitle.TextXAlignment = Enum.TextXAlignment.Left

-- MinBar Status
local MinStatus = Instance.new("TextLabel")
MinStatus.Parent = MinBar
MinStatus.BackgroundTransparency = 1
MinStatus.Position = UDim2.new(0, 180, 0, 0)
MinStatus.Size = UDim2.new(0, 80, 1, 0)
MinStatus.Font = Enum.Font.Gotham
MinStatus.Text = "● Running"
MinStatus.TextColor3 = Color3.fromRGB(60, 200, 120)
MinStatus.TextSize = 11
MinStatus.TextXAlignment = Enum.TextXAlignment.Left

-- MinBar Expand Button
local MinExpandBtn = Instance.new("TextButton")
MinExpandBtn.Parent = MinBar
MinExpandBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
MinExpandBtn.BackgroundTransparency = 0.6
MinExpandBtn.BorderSizePixel = 0
MinExpandBtn.Position = UDim2.new(1, -45, 0.5, -15)
MinExpandBtn.Size = UDim2.new(0, 30, 0, 30)
MinExpandBtn.Font = Enum.Font.GothamBold
MinExpandBtn.Text = "□"
MinExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinExpandBtn.TextSize = 16
RoundCorners(MinExpandBtn, 15)

-- MinBar Close Button
local MinCloseBtn = Instance.new("TextButton")
MinCloseBtn.Parent = MinBar
MinCloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
MinCloseBtn.BackgroundTransparency = 0.6
MinCloseBtn.BorderSizePixel = 0
MinCloseBtn.Position = UDim2.new(1, -85, 0.5, -15)
MinCloseBtn.Size = UDim2.new(0, 30, 0, 30)
MinCloseBtn.Font = Enum.Font.GothamBold
MinCloseBtn.Text = "✕"
MinCloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinCloseBtn.TextSize = 16
RoundCorners(MinCloseBtn, 15)

-- MinBar hover effects
local function AddMinHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
    end)
end
AddMinHoverEffect(MinExpandBtn)
AddMinHoverEffect(MinCloseBtn)

-- ============================================
-- TOP BAR
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BackgroundTransparency = 0.15
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 55)
RoundCorners(TopBar, 14)

-- Accent line
local AccentLine = Instance.new("Frame")
AccentLine.Parent = TopBar
AccentLine.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
AccentLine.BorderSizePixel = 0
AccentLine.Position = UDim2.new(0, 0, 1, -2)
AccentLine.Size = UDim2.new(1, 0, 0, 2)

-- Icon
local Icon = Instance.new("TextLabel")
Icon.Parent = TopBar
Icon.BackgroundTransparency = 1
Icon.Position = UDim2.new(0, 15, 0, 0)
Icon.Size = UDim2.new(0, 35, 1, 0)
Icon.Font = Enum.Font.GothamBold
Icon.Text = "⚡"
Icon.TextColor3 = Color3.fromRGB(60, 80, 200)
Icon.TextSize = 22
Icon.TextXAlignment = Enum.TextXAlignment.Center

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 55, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = TopBar
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 55, 0, 26)
Subtitle.Size = UDim2.new(0, 200, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "v1.0"
Subtitle.TextColor3 = Color3.fromRGB(150, 150, 180)
Subtitle.TextSize = 12
Subtitle.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
MinBtn.BackgroundTransparency = 0.6
MinBtn.BorderSizePixel = 0
MinBtn.Position = UDim2.new(1, -85, 0.5, -15)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 18
RoundCorners(MinBtn, 15)

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 0.6
CloseBtn.BorderSizePixel = 0
CloseBtn.Position = UDim2.new(1, -45, 0.5, -15)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 16
RoundCorners(CloseBtn, 15)

-- Button hover effects
local function AddHoverEffect(button)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundTransparency = 0.6}):Play()
    end)
end
AddHoverEffect(MinBtn)
AddHoverEffect(CloseBtn)

-- ============================================
-- TABS
-- ============================================
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BackgroundTransparency = 0.15
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.Size = UDim2.new(0, 160, 1, -55)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Content.BackgroundTransparency = 0.15
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 160, 0, 55)
Content.Size = UDim2.new(1, -160, 1, -55)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = Color3.fromRGB(60, 60, 80)

-- Tab system
local currentTab = nil
local contentY = 15

-- ============================================
-- UI ELEMENTS
-- ============================================
local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 5, 0, #TabContainer:GetChildren() * 48 + 10)
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(btn, 8)
    
    -- Tab indicator
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Visible = false
    RoundCorners(indicator, 2)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
    end)
    
    local function select()
        if currentTab == name then return end
        currentTab = name
        
        Content:ClearAllChildren()
        contentY = 15
        
        for _, child in pairs(TabContainer:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                child.BackgroundTransparency = 0.3
                child.TextColor3 = Color3.fromRGB(180, 180, 200)
                local ind = child:FindFirstChildWhichIsA("Frame")
                if ind then ind.Visible = false end
            end
        end
        
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        btn.BackgroundTransparency = 0.1
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        indicator.Visible = true
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
    label.Text = "▸ " .. text
    label.TextColor3 = Color3.fromRGB(200, 200, 230)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    contentY = contentY + 38
    return frame
end

local function AddDivider()
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 20, 0, contentY)
    frame.Size = UDim2.new(1, -40, 0, 1)
    contentY = contentY + 10
    return frame
end

local function AddButton(text, desc, callback)
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 50)
    RoundCorners(frame, 10)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 250, 0, 22)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 235, 250)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    if desc then
        local descLabel = Instance.new("TextLabel")
        descLabel.Parent = frame
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 12, 0, 24)
        descLabel.Size = UDim2.new(0, 250, 0, 20)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = desc
        descLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(1, -110, 0.5, -18)
    btn.Size = UDim2.new(0, 95, 0, 36)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "Execute"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    RoundCorners(btn, 8)
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.15}):Play()
    end)
    
    contentY = contentY + 58
    return frame
end

local function AddToggle(text, default, callback)
    local state = default or false
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 10)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 280, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 235, 250)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("Frame")
    toggle.Parent = frame
    toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    toggle.BackgroundTransparency = 0.2
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
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(60, 200, 120), BackgroundTransparency = 0.1}):Play()
            TweenService:Create(indicator, TweenInfo.new(0.3), {Position = UDim2.new(1, -27, 0.5, -12)}):Play()
        else
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 80, 100), BackgroundTransparency = 0.2}):Play()
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
    contentY = contentY + 53
    return frame
end

local function AddSlider(text, min, max, default, callback)
    local value = default or 50
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = 0.25
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 55)
    RoundCorners(frame, 10)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 280, 0, 22)
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(235, 235, 250)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local valDisplay = Instance.new("TextLabel")
    valDisplay.Parent = frame
    valDisplay.BackgroundTransparency = 1
    valDisplay.Position = UDim2.new(1, -55, 0, 0)
    valDisplay.Size = UDim2.new(0, 40, 0, 22)
    valDisplay.Font = Enum.Font.GothamBold
    valDisplay.Text = tostring(value)
    valDisplay.TextColor3 = Color3.fromRGB(60, 80, 200)
    valDisplay.TextSize = 14
    valDisplay.TextXAlignment = Enum.TextXAlignment.Right
    
    local bg = Instance.new("Frame")
    bg.Parent = frame
    bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    bg.BackgroundTransparency = 0.2
    bg.BorderSizePixel = 0
    bg.Position = UDim2.new(0, 12, 0.65, 0)
    bg.Size = UDim2.new(1, -24, 0, 6)
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
            valDisplay.Text = tostring(value)
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
            valDisplay.Text = tostring(value)
            if callback then callback(value) end
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    contentY = contentY + 63
    return frame
end

local function AddLabel(text, color)
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 25)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or Color3.fromRGB(150, 150, 180)
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    contentY = contentY + 30
    return frame
end

-- ============================================
-- MINIMIZE / EXPAND FUNCTIONS
-- ============================================
local function MinimizeUI()
    if isMinimized then return end
    isMinimized = true
    
    -- Hide main frame with animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.2)
    MainFrame.Visible = false
    
    -- Show min bar at bottom center
    MinBar.Visible = true
    MinBar.Position = UDim2.new(0.5, -150, 0.95, 20)
    MinBar.Size = UDim2.new(0, 0, 0, 40)
    MinBar.BackgroundTransparency = 1
    
    TweenService:Create(MinBar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0.95, -20),
        Size = UDim2.new(0, 300, 0, 40),
        BackgroundTransparency = 0.25
    }):Play()
    
    -- Show min bar contents
    for _, child in pairs(MinBar:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child.Visible = true
        end
    end
end

local function ExpandUI()
    if not isMinimized then return end
    isMinimized = false
    
    -- Hide min bar
    TweenService:Create(MinBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.2)
    MinBar.Visible = false
    
    -- Show main frame
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 640, 0, 440),
        BackgroundTransparency = 0.25
    }):Play()
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
AddDivider()
AddSection("Actions")
AddButton("Print Hello", "Prints a message to console", function() 
    print("Hello World!")
end)
AddButton("Kill All", "Removes all NPCs", function()
    print("Killing all NPCs...")
end)

-- ============================================
-- COMBAT TAB CONTENT
-- ============================================
combatTab.select()
AddSection("Combat Settings")
AddToggle("Aimbot", false, function(v) print("Aimbot:", v) end)
AddToggle("Triggerbot", false, function(v) print("Triggerbot:", v) end)
AddSlider("FOV Radius", 50, 500, 100, function(v) print("FOV:", v) end)
AddSlider("Smoothing", 1, 10, 3, function(v) print("Smoothing:", v) end)
AddDivider()
AddSection("Hitbox")
AddToggle("Hitbox Extender", false, function(v) print("Hitbox Extender:", v) end)
AddSlider("Hitbox Size", 1, 5, 3, function(v) print("Hitbox Size:", v) end)

-- ============================================
-- VISUALS TAB CONTENT
-- ============================================
visualsTab.select()
AddSection("ESP Settings")
AddToggle("Enable ESP", false, function(v) print("ESP:", v) end)
AddToggle("Box ESP", true, function(v) print("Box ESP:", v) end)
AddToggle("Name ESP", true, function(v) print("Name ESP:", v) end)
AddToggle("Health ESP", true, function(v) print("Health ESP:", v) end)
AddDivider()
AddSection("World Effects")
AddButton("Full Bright", "Toggles lighting brightness", function()
    local lighting = game:GetService("Lighting")
    lighting.Brightness = lighting.Brightness == 1 and 10 or 1
end)
AddButton("No Fog", "Removes fog from the game", function()
    game:GetService("Lighting").FogEnd = 999999
end)

-- ============================================
-- SETTINGS TAB CONTENT
-- ============================================
settingsTab.select()
AddSection("UI Settings")
AddButton("Hide UI", "Hides the interface completely", function()
    isHidden = true
    MainFrame.Visible = false
    MinBar.Visible = false
end)
AddButton("Show UI", "Shows the interface", function()
    isHidden = false
    if isMinimized then
        MinBar.Visible = true
    else
        MainFrame.Visible = true
    end
end)
AddButton("Minimize UI", "Collapses to a small bar at bottom", function()
    if not isMinimized then
        MinimizeUI()
    end
end)
AddButton("Expand UI", "Expands from minimized state", function()
    if isMinimized then
        ExpandUI()
    end
end)
AddDivider()
AddSection("Script Control")
AddButton("Terminate Script", "⚠️ Stops all script execution", function()
    -- Show confirmation
    local confirm = Instance.new("Frame")
    confirm.Parent = MainFrame
    confirm.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    confirm.BackgroundTransparency = 0.5
    confirm.BorderSizePixel = 0
    confirm.Position = UDim2.new(0, 0, 0, 0)
    confirm.Size = UDim2.new(1, 0, 1, 0)
    confirm.ZIndex = 999
    
    local box = Instance.new("Frame")
    box.Parent = confirm
    box.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    box.BackgroundTransparency = 0.1
    box.BorderSizePixel = 0
    box.Position = UDim2.new(0.5, -150, 0.5, -60)
    box.Size = UDim2.new(0, 300, 0, 120)
    RoundCorners(box, 12)
    box.ZIndex = 1000
    
    local warnLabel = Instance.new("TextLabel")
    warnLabel.Parent = box
    warnLabel.BackgroundTransparency = 1
    warnLabel.Position = UDim2.new(0, 0, 0, 10)
    warnLabel.Size = UDim2.new(1, 0, 0, 30)
    warnLabel.Font = Enum.Font.GothamBold
    warnLabel.Text = "⚠️ Terminate Script?"
    warnLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    warnLabel.TextSize = 18
    
    local descLabel = Instance.new("TextLabel")
    descLabel.Parent = box
    descLabel.BackgroundTransparency = 1
    descLabel.Position = UDim2.new(0, 10, 0, 45)
    descLabel.Size = UDim2.new(1, -20, 0, 20)
    descLabel.Font = Enum.Font.Gotham
    descLabel.Text = "This will stop all script execution."
    descLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    descLabel.TextSize = 13
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Parent = box
    yesBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    yesBtn.BackgroundTransparency = 0.2
    yesBtn.BorderSizePixel = 0
    yesBtn.Position = UDim2.new(0.5, -110, 1, -45)
    yesBtn.Size = UDim2.new(0, 100, 0, 35)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.Text = "Terminate"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.TextSize = 14
    RoundCorners(yesBtn, 8)
    
    local noBtn = Instance.new("TextButton")
    noBtn.Parent = box
    noBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 120)
    noBtn.BackgroundTransparency = 0.3
    noBtn.BorderSizePixel = 0
    noBtn.Position = UDim2.new(0.5, 10, 1, -45)
    noBtn.Size = UDim2.new(0, 100, 0, 35)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.Text = "Cancel"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.TextSize = 14
    RoundCorners(noBtn, 8)
    
    yesBtn.MouseButton1Click:Connect(function()
        confirm:Destroy()
        print("Script terminated!")
        ScreenGui:Destroy()
        error("Script terminated by user", 0)
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        confirm:Destroy()
    end)
    
    confirm.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            confirm:Destroy()
        end
    end)
end)

AddDivider()
AddLabel("Made with ❤️", Color3.fromRGB(100, 100, 140))
AddLabel("Press RightShift to toggle", Color3.fromRGB(80, 80, 120))

-- ============================================
-- WINDOW CONTROLS
-- ============================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    MinimizeUI()
end)

MinExpandBtn.MouseButton1Click:Connect(function()
    ExpandUI()
end)

MinCloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- KEYBIND (RightShift to toggle)
-- ============================================
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isHidden then
            isHidden = false
            if isMinimized then
                MinBar.Visible = true
            else
                MainFrame.Visible = true
            end
        else
            if isMinimized then
                MinBar.Visible = not MinBar.Visible
            else
                MainFrame.Visible = not MainFrame.Visible
            end
        end
    end
end)

-- ============================================
-- DRAGGABLE WINDOW
-- ============================================
local dragging = false
local dragInput, dragStart, startPos

-- Main window drag
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

-- MinBar drag
MinBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MinBar.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MinBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        if isMinimized then
            MinBar.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        else
            MainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end
end)

print("✨ Modern UI loaded successfully!")
print("📌 Press RightShift to toggle the UI")
print("📌 Click '─' to minimize to bottom bar")
print("📌 Click '□' on the bar to expand back")
