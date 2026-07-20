-- ============================================
-- MODERN UI - FULLY ROUNDED CORNERS (Top & Bottom)
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ============================================
-- STATE
-- ============================================
local isMinimized = false
local isHidden = false

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
RoundCorners(MainFrame, 14) -- Rounded on ALL corners

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
-- MINIMIZED BAR - FULLY ROUNDED
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
RoundCorners(MinBar, 14) -- Rounded on ALL corners

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
-- UI ELEMENTS (Same as before - all functions unchanged)
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

-- [All AddSection, AddDivider, AddButton, AddToggle, AddSlider, AddLabel functions remain the same as before]
-- I'll include them but shortened for space - you can copy from your working version

-- ============================================
-- COPY YOUR EXISTING UI FUNCTIONS HERE
-- ============================================
-- (AddSection, AddDivider, AddButton, AddToggle, AddSlider, AddLabel)
-- These are exactly the same as in your working code

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
local combatTab = CreateTab("Combat", "⚔️")
local visualsTab = CreateTab("Visuals", "👁️")
local settingsTab = CreateTab("Settings", "⚙️")

-- [Rest of your content here - same as before]

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
-- KEYBIND
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
print("📌 Press RightShift to toggle the UI")
print("📌 Click '─' to minimize to bottom bar")
print("📌 Click '□' on the bar to expand back")
