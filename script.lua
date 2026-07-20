-- ============================================
-- MODERN UI - Custom Functions (Teleport & Attach)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ============================================
-- STATE
-- ============================================
local isMinimized = false
local isHidden = false
local isAttached = false
local attachedPlayer = nil
local attachmentConnection = nil

-- ============================================
-- CORNER ROUNDING FUNCTION
-- ============================================
local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, radius or 14)
end

-- ============================================
-- MAIN FRAME - FULLY ROUNDED
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
MainFrame.Size = UDim2.new(0, 640, 0, 440)
MainFrame.ClipsDescendants = true
MainFrame.BackgroundTransparency = 0
MainFrame.ZIndex = 10
MainFrame.Visible = true
RoundCorners(MainFrame, 14)

-- Border
local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(80, 80, 120)
Stroke.Thickness = 1
Stroke.Transparency = 0.3

-- Shadow
local Shadow = Instance.new("Frame")
Shadow.Parent = MainFrame
Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Shadow.BackgroundTransparency = 0.6
Shadow.BorderSizePixel = 0
Shadow.Position = UDim2.new(0, 8, 0, 8)
Shadow.Size = UDim2.new(1, -16, 1, -16)
RoundCorners(Shadow, 14)

-- ============================================
-- MINIMIZED BAR
-- ============================================
local MinBar = Instance.new("Frame")
MinBar.Name = "MinBar"
MinBar.Parent = ScreenGui
MinBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MinBar.BackgroundTransparency = 0
MinBar.BorderSizePixel = 0
MinBar.Position = UDim2.new(0.5, -150, 0.95, -20)
MinBar.Size = UDim2.new(0, 300, 0, 40)
MinBar.Visible = false
MinBar.ZIndex = 20
RoundCorners(MinBar, 14)

-- MinBar Border
local MinStroke = Instance.new("UIStroke")
MinStroke.Parent = MinBar
MinStroke.Color = Color3.fromRGB(80, 80, 120)
MinStroke.Thickness = 1
MinStroke.Transparency = 0.3

-- MinBar Shadow
local MinShadow = Instance.new("Frame")
MinShadow.Parent = MinBar
MinShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinShadow.BackgroundTransparency = 0.6
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
MinExpandBtn.BackgroundTransparency = 0.3
MinExpandBtn.BorderSizePixel = 0
MinExpandBtn.Position = UDim2.new(1, -45, 0.5, -15)
MinExpandBtn.Size = UDim2.new(0, 30, 0, 30)
MinExpandBtn.Font = Enum.Font.GothamBold
MinExpandBtn.Text = "□"
MinExpandBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinExpandBtn.TextSize = 16
RoundCorners(MinExpandBtn, 15)

MinExpandBtn.MouseEnter:Connect(function()
    TweenService:Create(MinExpandBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)
MinExpandBtn.MouseLeave:Connect(function()
    TweenService:Create(MinExpandBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
end)

-- ============================================
-- TOP BAR
-- ============================================
local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BackgroundTransparency = 0
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
MinBtn.BackgroundTransparency = 0.3
MinBtn.BorderSizePixel = 0
MinBtn.Position = UDim2.new(1, -45, 0.5, -15)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "─"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 18
RoundCorners(MinBtn, 15)

MinBtn.MouseEnter:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TweenService:Create(MinBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
end)

-- ============================================
-- TABS
-- ============================================
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TabContainer.BackgroundTransparency = 0
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.Size = UDim2.new(0, 160, 1, -55)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Parent = MainFrame
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Content.BackgroundTransparency = 0
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
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 5, 0, #TabContainer:GetChildren() * 48 + 10)
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(btn, 8)
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Visible = false
    RoundCorners(indicator, 2)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
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
                child.TextColor3 = Color3.fromRGB(180, 180, 200)
                local ind = child:FindFirstChildWhichIsA("Frame")
                if ind then ind.Visible = false end
            end
        end
        
        btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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

local function AddLabel(text, color, size)
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
    label.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    label.TextSize = size or 16
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    contentY = contentY + 38
    return frame
end

local function AddSmallLabel(text, color)
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

local function AddButton(text, desc, callback)
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 50)
    RoundCorners(frame, 10)
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = Color3.fromRGB(60, 60, 80)
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.3
    
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
    btn.BackgroundTransparency = 0
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
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 100, 220)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 80, 200)}):Play()
    end)
    
    contentY = contentY + 58
    return frame
end

local function AddToggle(text, default, callback)
    local state = default or false
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 10)
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = Color3.fromRGB(60, 60, 80)
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.3
    
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
    toggle.BackgroundTransparency = 0
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
    contentY = contentY + 53
    return frame
end

local function AddDropdown(text, options, default, callback)
    local selected = default or options[1] or "Select"
    local isOpen = false
    
    local frame = Instance.new("Frame")
    frame.Parent = Content
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, contentY)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 10)
    frame.ClipsDescendants = true
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = Color3.fromRGB(60, 60, 80)
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 235, 250)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = frame
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    dropdownBtn.BackgroundTransparency = 0
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Position = UDim2.new(0, 120, 0.5, -15)
    dropdownBtn.Size = UDim2.new(1, -135, 0, 30)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = selected
    dropdownBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownBtn.TextSize = 13
    dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(dropdownBtn, 8)
    
    local arrow = Instance.new("TextLabel")
    arrow.Parent = dropdownBtn
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 180)
    arrow.TextSize = 12
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Parent = frame
    listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    listFrame.BackgroundTransparency = 0
    listFrame.BorderSizePixel = 0
    listFrame.Position = UDim2.new(0, 120, 0, 15)
    listFrame.Size = UDim2.new(1, -135, 0, 0)
    listFrame.Visible = false
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.ScrollBarThickness = 3
    RoundCorners(listFrame, 6)
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = listFrame
    listLayout.Padding = UDim.new(0, 2)
    
    local function updateList()
        for _, child in pairs(listFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        
        local totalHeight = 0
        for _, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Parent = listFrame
            optBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            optBtn.BackgroundTransparency = 0
            optBtn.BorderSizePixel = 0
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Font = Enum.Font.Gotham
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 220)
            optBtn.TextSize = 13
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.Text = "  " .. option
            RoundCorners(optBtn, 4)
            
            if option == selected then
                optBtn.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
            
            optBtn.MouseEnter:Connect(function()
                if option ~= selected then
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(55, 55, 75)}):Play()
                end
            end)
            optBtn.MouseLeave:Connect(function()
                if option ~= selected then
                    TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 60)}):Play()
                end
            end)
            
            optBtn.MouseButton1Click:Connect(function()
                selected = option
                dropdownBtn.Text = option
                if callback then callback(option) end
                isOpen = false
                listFrame.Visible = false
                frame.Size = UDim2.new(1, -30, 0, 45)
                for _, child in pairs(listFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                        child.TextColor3 = Color3.fromRGB(200, 200, 220)
                        if child.Text == "  " .. selected then
                            child.BackgroundColor3 = Color3.fromRGB(60, 80, 200)
                            child.TextColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                end
                arrow.Text = "▼"
            end)
            
            totalHeight = totalHeight + 32
        end
        
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        listFrame.Size = UDim2.new(1, -135, 0, math.min(totalHeight, 150))
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            frame.Size = UDim2.new(1, -30, 0, 45 + listFrame.Size.Y.Offset + 10)
            listFrame.Visible = true
            arrow.Text = "▲"
            updateList()
        else
            frame.Size = UDim2.new(1, -30, 0, 45)
            listFrame.Visible = false
            arrow.Text = "▼"
        end
    end)
    
    contentY = contentY + 55
    return {set = function(val) selected = val; dropdownBtn.Text = val; if callback then callback(val) end end}
end

-- ============================================
-- TELEPORT & ATTACH FUNCTIONS
-- ============================================
local function TeleportToPlayer(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then
        print("❌ Player not found or no character")
        return
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        print("❌ Target has no HumanoidRootPart")
        return
    end
    
    local myChar = player.Character
    if not myChar then
        print("❌ You have no character")
        return
    end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then
        print("❌ You have no HumanoidRootPart")
        return
    end
    
    -- Teleport to target
    myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
    print("✅ Teleported to: " .. targetPlayer.Name)
end

local function AttachToPlayer(targetPlayer)
    -- Detach first if already attached
    if isAttached then
        DetachFromPlayer()
    end
    
    if not targetPlayer or not targetPlayer.Character then
        print("❌ Player not found or no character")
        return false
    end
    
    local targetHRP = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetHRP then
        print("❌ Target has no HumanoidRootPart")
        return false
    end
    
    attachedPlayer = targetPlayer
    isAttached = true
    
    -- Create attachment connection
    if attachmentConnection then
        attachmentConnection:Disconnect()
        attachmentConnection = nil
    end
    
    attachmentConnection = RunService.Heartbeat:Connect(function()
        if not isAttached or not attachedPlayer or not attachedPlayer.Character then
            DetachFromPlayer()
            return
        end
        
        local myChar = player.Character
        if not myChar then return end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = attachedPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if myHRP and targetHRP then
            myHRP.CFrame = targetHRP.CFrame + Vector3.new(0, 3, 0)
        end
    end)
    
    print("✅ Attached to: " .. targetPlayer.Name)
    return true
end

local function DetachFromPlayer()
    isAttached = false
    attachedPlayer = nil
    
    if attachmentConnection then
        attachmentConnection:Disconnect()
        attachmentConnection = nil
    end
    
    print("✅ Detached from player")
end

-- ============================================
-- MINIMIZE / EXPAND FUNCTIONS
-- ============================================
local function MinimizeUI()
    if isMinimized then return end
    isMinimized = true
    
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.2)
    MainFrame.Visible = false
    
    MinBar.Visible = true
    MinBar.Position = UDim2.new(0.5, -150, 0.95, 20)
    MinBar.Size = UDim2.new(0, 0, 0, 40)
    MinBar.BackgroundTransparency = 1
    
    TweenService:Create(MinBar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -150, 0.95, -20),
        Size = UDim2.new(0, 300, 0, 40),
        BackgroundTransparency = 0
    }):Play()
    
    for _, child in pairs(MinBar:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            child.Visible = true
        end
    end
end

local function ExpandUI()
    if not isMinimized then return end
    isMinimized = false
    
    TweenService:Create(MinBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 40),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.2)
    MinBar.Visible = false
    
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.BackgroundTransparency = 1
    MainFrame.Position = UDim2.new(0.5, -320, 0.5, -220)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 640, 0, 440),
        BackgroundTransparency = 0
    }):Play()
end

-- ============================================
-- CREATE TABS
-- ============================================
local mainTab = CreateTab("Main", "🏠")
local securityTab = CreateTab("Security", "🛡️")
local visualsTab = CreateTab("Visuals", "👁️")
local settingsTab = CreateTab("Settings", "⚙️")

-- ============================================
-- MAIN TAB CONTENT
-- ============================================
mainTab.select()

-- Welcome Section
AddLabel("═══════════════════════════════════", Color3.fromRGB(60, 80, 200), 14)
AddLabel("✨ Script by QueezZy123 (Maryyy) ✨", Color3.fromRGB(255, 200, 100), 18)
AddLabel("🎮 Games: Driving Empire", Color3.fromRGB(150, 200, 255), 14)
AddLabel("═══════════════════════════════════", Color3.fromRGB(60, 80, 200), 14)

AddDivider()
AddSection("Welcome")
AddSmallLabel("👋 Welcome to Script Hub!", Color3.fromRGB(200, 200, 220))
AddSmallLabel("🔧 Use the Security tab for teleport features", Color3.fromRGB(150, 150, 180))
AddSmallLabel("📌 Press RightShift to toggle this UI", Color3.fromRGB(150, 150, 180))

AddDivider()
AddSection("Quick Actions")
AddButton("Print Hello", "Test the script is working", function()
    print("Hello from QueezZy123!")
end)

-- ============================================
-- SECURITY TAB CONTENT (Teleport & Attach)
-- ============================================
securityTab.select()

AddSection("Teleport & Attach")

-- Get online players list
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

-- Player selection dropdown
local selectedTargetName = nil
local playerDropdown = AddDropdown("Select Player", GetPlayerNames(), GetPlayerNames()[1], function(value)
    selectedTargetName = value
    print("📌 Selected:", value)
    
    -- Update status label if it exists
    local statusLabel = Content:FindFirstChild("StatusLabel")
    if statusLabel and statusLabel:IsA("TextLabel") then
        if isAttached and attachedPlayer and attachedPlayer.Name == value then
            statusLabel.Text = "📌 Status: Attached to " .. value
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        else
            statusLabel.Text = "📌 Status: Selected " .. value
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
    end
end)

-- Status label (will be updated)
AddDivider()
local statusFrame = Instance.new("Frame")
statusFrame.Parent = Content
statusFrame.BackgroundTransparency = 1
statusFrame.Position = UDim2.new(0, 15, 0, contentY)
statusFrame.Size = UDim2.new(1, -30, 0, 30)

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Parent = statusFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 1, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "📌 Status: No player selected"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
statusLabel.TextSize = 13
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
contentY = contentY + 35

AddDivider()

-- Teleport Button
AddButton("📍 Teleport to Player", "Instantly teleports you to the selected player", function()
    if not selectedTargetName or selectedTargetName == "No players found" then
        print("❌ No player selected")
        return
    end
    
    local target = Players:FindFirstChild(selectedTargetName)
    if not target then
        print("❌ Player not found: " .. selectedTargetName)
        return
    end
    
    -- Update status
    if statusLabel then
        statusLabel.Text = "📍 Teleporting to " .. selectedTargetName .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    TeleportToPlayer(target)
    
    task.wait(0.5)
    if statusLabel then
        if isAttached and attachedPlayer and attachedPlayer.Name == selectedTargetName then
            statusLabel.Text = "📌 Status: Attached to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        else
            statusLabel.Text = "✅ Teleported to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        end
    end
end)

-- Attach Button
AddButton("🔗 Attach to Player", "Follows the selected player continuously", function()
    if not selectedTargetName or selectedTargetName == "No players found" then
        print("❌ No player selected")
        return
    end
    
    local target = Players:FindFirstChild(selectedTargetName)
    if not target then
        print("❌ Player not found: " .. selectedTargetName)
        return
    end
    
    -- Update status
    if statusLabel then
        statusLabel.Text = "🔗 Attaching to " .. selectedTargetName .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    local success = AttachToPlayer(target)
    
    if success then
        if statusLabel then
            statusLabel.Text = "🔗 Attached to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        end
    else
        if statusLabel then
            statusLabel.Text = "❌ Failed to attach to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end
end)

-- Detach Button
AddButton("🔓 Detach from Player", "Stops following the attached player", function()
    if not isAttached then
        print("❌ Not attached to anyone")
        if statusLabel then
            statusLabel.Text = "❌ Not attached to anyone"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    DetachFromPlayer()
    
    if statusLabel then
        statusLabel.Text = "🔓 Detached from player"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end)

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
    box.BackgroundTransparency = 0
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
    yesBtn.BackgroundTransparency = 0
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
    noBtn.BackgroundTransparency = 0
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
AddSmallLabel("Made with ❤️ by QueezZy123", Color3.fromRGB(100, 100, 140))
AddSmallLabel("Press RightShift to toggle", Color3.fromRGB(80, 80, 120))

-- ============================================
-- WINDOW CONTROLS
-- ============================================
MinBtn.MouseButton1Click:Connect(function()
    MinimizeUI()
end)

MinExpandBtn.MouseButton1Click:Connect(function()
    ExpandUI()
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
print("📌 Script by QueezZy123")
print("🎮 Games: Driving Empire")
print("📌 Press RightShift to toggle the UI")
