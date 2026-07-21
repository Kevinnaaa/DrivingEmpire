-- ============================================
-- MODERN UI - Dark Purple Theme (#221C35)
-- FIXED: Proper Teleport & Attach Functions
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
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ============================================
-- DARK PURPLE COLORS (#221C35)
-- ============================================
local BACKGROUND = Color3.fromRGB(34, 28, 53)
local TOPBAR = Color3.fromRGB(45, 35, 65)
local TABBG = Color3.fromRGB(28, 22, 45)
local ELEMBG = Color3.fromRGB(50, 40, 72)
local ELEMBGHOVER = Color3.fromRGB(65, 50, 90)
local ACCENT = Color3.fromRGB(152, 29, 151)
local ACCENT_LIGHT = Color3.fromRGB(180, 60, 180)
local BORDER = Color3.fromRGB(100, 50, 130)
local TEXT = Color3.fromRGB(255, 255, 255)
local TEXTDIM = Color3.fromRGB(200, 180, 220)

-- ============================================
-- STATE
-- ============================================
local isMinimized = false
local isHidden = false
local isAttached = false
local isTeleporting = false
local attachedPlayer = nil
local attachmentConnection = nil
local deathConnection = nil
local teleportLoopConnection = nil
local selectedTargetName = nil
local selectedPlayer = nil
local useTween = true

-- ============================================
-- CORNER ROUNDING FUNCTION
-- ============================================
local function RoundCorners(frame, radius)
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, radius or 14)
end

-- ============================================
-- MAIN FRAME
-- ============================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = BACKGROUND
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
Stroke.Color = BORDER
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
MinBar.BackgroundColor3 = BACKGROUND
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
MinStroke.Color = BORDER
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
MinIcon.TextColor3 = ACCENT
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
MinTitle.TextColor3 = TEXT
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
MinExpandBtn.BackgroundColor3 = ACCENT
MinExpandBtn.BackgroundTransparency = 0.3
MinExpandBtn.BorderSizePixel = 0
MinExpandBtn.Position = UDim2.new(1, -45, 0.5, -15)
MinExpandBtn.Size = UDim2.new(0, 30, 0, 30)
MinExpandBtn.Font = Enum.Font.GothamBold
MinExpandBtn.Text = "□"
MinExpandBtn.TextColor3 = TEXT
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
TopBar.BackgroundColor3 = TOPBAR
TopBar.BackgroundTransparency = 0
TopBar.BorderSizePixel = 0
TopBar.Size = UDim2.new(1, 0, 0, 55)
RoundCorners(TopBar, 14)

-- Accent line
local AccentLine = Instance.new("Frame")
AccentLine.Parent = TopBar
AccentLine.BackgroundColor3 = ACCENT
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
Icon.TextColor3 = ACCENT
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
Title.TextColor3 = TEXT
Title.TextSize = 19
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Subtitle
local Subtitle = Instance.new("TextLabel")
Subtitle.Parent = TopBar
Subtitle.BackgroundTransparency = 1
Subtitle.Position = UDim2.new(0, 55, 0, 26)
Subtitle.Size = UDim2.new(0, 200, 0, 20)
Subtitle.Font = Enum.Font.Gotham
Subtitle.Text = "v2.0 - Fixed Teleport"
Subtitle.TextColor3 = TEXTDIM
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
MinBtn.TextColor3 = TEXT
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
TabContainer.BackgroundColor3 = TABBG
TabContainer.BackgroundTransparency = 0
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 55)
TabContainer.Size = UDim2.new(0, 160, 1, -55)

-- Content Area
local Content = Instance.new("ScrollingFrame")
Content.Parent = MainFrame
Content.BackgroundColor3 = BACKGROUND
Content.BackgroundTransparency = 0
Content.BorderSizePixel = 0
Content.Position = UDim2.new(0, 160, 0, 55)
Content.Size = UDim2.new(1, -160, 1, -55)
Content.CanvasSize = UDim2.new(0, 0, 0, 0)
Content.ScrollBarThickness = 4
Content.ScrollBarImageColor3 = BORDER
Content.ClipsDescendants = true

-- Tab system
local currentTab = nil
local tabContents = {}

-- ============================================
-- UI ELEMENTS
-- ============================================
local function CreateTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.BackgroundColor3 = TABBG
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0, 5, 0, #TabContainer:GetChildren() * 48 + 10)
    btn.Size = UDim2.new(1, -10, 0, 42)
    btn.Font = Enum.Font.Gotham
    btn.Text = "  " .. icon .. "  " .. name
    btn.TextColor3 = TEXTDIM
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(btn, 8)
    
    local indicator = Instance.new("Frame")
    indicator.Parent = btn
    indicator.BackgroundColor3 = ACCENT
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0.2, 0)
    indicator.Size = UDim2.new(0, 3, 0.6, 0)
    indicator.Visible = false
    RoundCorners(indicator, 2)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = ELEMBGHOVER}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= name then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = TABBG}):Play()
        end
    end)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = name .. "Content"
    tabContainer.Parent = Content
    tabContainer.BackgroundTransparency = 1
    tabContainer.Size = UDim2.new(1, 0, 0, 0)
    tabContainer.Visible = false
    tabContainer.ZIndex = 15
    tabContainer.ClipsDescendants = false
    
    tabContents[name] = {
        container = tabContainer,
        yPos = 15,
        btn = btn,
        indicator = indicator
    }
    
    local function select()
        if currentTab == name then return end
        currentTab = name
        
        for _, data in pairs(tabContents) do
            data.container.Visible = false
            data.btn.BackgroundColor3 = TABBG
            data.btn.TextColor3 = TEXTDIM
            data.indicator.Visible = false
        end
        
        local data = tabContents[name]
        if data then
            data.container.Visible = true
            data.btn.BackgroundColor3 = ELEMBGHOVER
            data.btn.TextColor3 = TEXT
            data.indicator.Visible = true
            task.wait(0.05)
            Content.CanvasSize = UDim2.new(0, 0, 0, data.yPos + 30)
        end
    end
    
    btn.MouseButton1Click:Connect(select)
    
    return {
        select = select,
        container = tabContainer,
        getY = function() return tabContents[name].yPos end,
        setY = function(val) tabContents[name].yPos = val end
    }
end

local function AddSection(text)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = "▸ " .. text
    label.TextColor3 = TEXTDIM
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    data.yPos = data.yPos + 38
    return frame
end

local function AddDivider()
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundColor3 = BORDER
    frame.BackgroundTransparency = 0.5
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 20, 0, y)
    frame.Size = UDim2.new(1, -40, 0, 1)
    
    data.yPos = data.yPos + 10
    return frame
end

local function AddLabel(text, color, size)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 30)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = color or TEXT
    label.TextSize = size or 16
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    data.yPos = data.yPos + 38
    return frame
end

local function AddSmallLabel(text, color)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundTransparency = 1
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 25)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = color or TEXTDIM
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Center
    
    data.yPos = data.yPos + 30
    return frame
end

local function AddButton(text, desc, callback)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundColor3 = ELEMBG
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 50)
    RoundCorners(frame, 10)
    frame.ClipsDescendants = false
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = BORDER
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 250, 0, 22)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = TEXT
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
        descLabel.TextColor3 = TEXTDIM
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = ACCENT
    btn.BackgroundTransparency = 0
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(1, -110, 0.5, -18)
    btn.Size = UDim2.new(0, 95, 0, 36)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "Execute"
    btn.TextColor3 = TEXT
    btn.TextSize = 13
    RoundCorners(btn, 8)
    btn.ZIndex = 51
    
    btn.MouseButton1Click:Connect(callback)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = ACCENT_LIGHT}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = ACCENT}):Play()
    end)
    
    data.yPos = data.yPos + 58
    return frame
end

local function AddToggle(text, default, callback)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    local state = default or false
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundColor3 = ELEMBG
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 45)
    RoundCorners(frame, 10)
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = BORDER
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.3
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 280, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = TEXT
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
            TweenService:Create(toggle, TweenInfo.new(0.3), {BackgroundColor3 = ACCENT}):Play()
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
    data.yPos = data.yPos + 53
    return frame
end

-- ============================================
-- PLAYER LIST DROPDOWN
-- ============================================
local function AddPlayerDropdown(text, options, default, callback)
    local data = tabContents[currentTab]
    if not data then return end
    
    local container = data.container
    local y = data.yPos
    local selected = default or options[1] or "Select"
    local isOpen = false
    
    local frame = Instance.new("Frame")
    frame.Parent = container
    frame.BackgroundColor3 = ELEMBG
    frame.BackgroundTransparency = 0
    frame.BorderSizePixel = 0
    frame.Position = UDim2.new(0, 15, 0, y)
    frame.Size = UDim2.new(1, -30, 0, 50)
    RoundCorners(frame, 10)
    frame.ClipsDescendants = false
    frame.ZIndex = 50
    
    local elemStroke = Instance.new("UIStroke")
    elemStroke.Parent = frame
    elemStroke.Color = BORDER
    elemStroke.Thickness = 1
    elemStroke.Transparency = 0.2
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0, 12, 0, 0)
    label.Size = UDim2.new(0, 100, 1, 0)
    label.Font = Enum.Font.Gotham
    label.Text = text
    label.TextColor3 = TEXTDIM
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 51
    
    local dropdownBtn = Instance.new("TextButton")
    dropdownBtn.Parent = frame
    dropdownBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 60)
    dropdownBtn.BackgroundTransparency = 0
    dropdownBtn.BorderSizePixel = 0
    dropdownBtn.Position = UDim2.new(0, 115, 0.5, -17)
    dropdownBtn.Size = UDim2.new(1, -140, 0, 34)
    dropdownBtn.Font = Enum.Font.Gotham
    dropdownBtn.Text = selected
    dropdownBtn.TextColor3 = TEXT
    dropdownBtn.TextSize = 13
    dropdownBtn.TextXAlignment = Enum.TextXAlignment.Left
    RoundCorners(dropdownBtn, 8)
    dropdownBtn.ZIndex = 51
    
    local textPad = Instance.new("UIPadding")
    textPad.Parent = dropdownBtn
    textPad.PaddingLeft = UDim.new(0, 10)
    
    local arrow = Instance.new("TextLabel")
    arrow.Parent = dropdownBtn
    arrow.BackgroundTransparency = 1
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Font = Enum.Font.GothamBold
    arrow.Text = "▼"
    arrow.TextColor3 = TEXTDIM
    arrow.TextSize = 12
    arrow.TextXAlignment = Enum.TextXAlignment.Center
    arrow.ZIndex = 52
    
    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Parent = frame
    listFrame.BackgroundColor3 = Color3.fromRGB(35, 18, 50)
    listFrame.BackgroundTransparency = 0
    listFrame.BorderSizePixel = 0
    listFrame.Position = UDim2.new(0, 115, 0, 17)
    listFrame.Size = UDim2.new(1, -140, 0, 0)
    listFrame.Visible = false
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 50, 130)
    listFrame.ZIndex = 100
    RoundCorners(listFrame, 8)
    
    local listStroke = Instance.new("UIStroke")
    listStroke.Parent = listFrame
    listStroke.Color = BORDER
    listStroke.Thickness = 1
    listStroke.Transparency = 0.3
    
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
        
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player then
                local optBtn = Instance.new("TextButton")
                optBtn.Parent = listFrame
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 22, 55)
                optBtn.BackgroundTransparency = 0
                optBtn.BorderSizePixel = 0
                optBtn.Size = UDim2.new(1, 0, 0, 32)
                optBtn.Font = Enum.Font.Gotham
                optBtn.Text = "  " .. plr.Name
                optBtn.TextColor3 = TEXT
                optBtn.TextSize = 13
                optBtn.TextXAlignment = Enum.TextXAlignment.Left
                RoundCorners(optBtn, 4)
                optBtn.ZIndex = 101
                
                optBtn.MouseEnter:Connect(function()
                    if plr.Name ~= selected then
                        TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = ELEMBGHOVER}):Play()
                    end
                end)
                optBtn.MouseLeave:Connect(function()
                    if plr.Name ~= selected then
                        TweenService:Create(optBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 22, 55)}):Play()
                    end
                end)
                
                if plr.Name == selected then
                    optBtn.BackgroundColor3 = ACCENT
                    optBtn.TextColor3 = TEXT
                end
                
                optBtn.MouseButton1Click:Connect(function()
                    selected = plr.Name
                    selectedPlayer = plr
                    dropdownBtn.Text = plr.Name
                    if callback then callback(plr.Name) end
                    isOpen = false
                    listFrame.Visible = false
                    frame.Size = UDim2.new(1, -30, 0, 50)
                    
                    for _, child in pairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child.BackgroundColor3 = Color3.fromRGB(40, 22, 55)
                            child.TextColor3 = TEXT
                            if child.Text == "  " .. selected then
                                child.BackgroundColor3 = ACCENT
                                child.TextColor3 = TEXT
                            end
                        end
                    end
                    arrow.Text = "▼"
                end)
                
                totalHeight = totalHeight + 34
            end
        end
        
        if totalHeight == 0 then
            local noPlayers = Instance.new("TextLabel")
            noPlayers.Parent = listFrame
            noPlayers.BackgroundTransparency = 1
            noPlayers.Size = UDim2.new(1, 0, 0, 32)
            noPlayers.Font = Enum.Font.Gotham
            noPlayers.Text = "  No players found"
            noPlayers.TextColor3 = TEXTDIM
            noPlayers.TextSize = 13
            noPlayers.TextXAlignment = Enum.TextXAlignment.Left
            totalHeight = 34
        end
        
        listFrame.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
        local listHeight = math.min(totalHeight, 150)
        listFrame.Size = UDim2.new(1, -140, 0, listHeight)
    end
    
    dropdownBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            updateList()
            local listHeight = listFrame.CanvasSize.Y.Offset
            local newHeight = 50 + math.min(listHeight, 150) + 10
            frame.Size = UDim2.new(1, -30, 0, newHeight)
            listFrame.Visible = true
            arrow.Text = "▲"
        else
            frame.Size = UDim2.new(1, -30, 0, 50)
            listFrame.Visible = false
            arrow.Text = "▼"
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isOpen then
                local mousePos = UserInputService:GetMouseLocation()
                local framePos = frame.AbsolutePosition
                local frameSize = frame.AbsoluteSize
                
                if not (mousePos.X >= framePos.X and mousePos.X <= framePos.X + frameSize.X and
                       mousePos.Y >= framePos.Y and mousePos.Y <= framePos.Y + frameSize.Y) then
                    isOpen = false
                    listFrame.Visible = false
                    frame.Size = UDim2.new(1, -30, 0, 50)
                    arrow.Text = "▼"
                end
            end
        end
    end)
    
    data.yPos = data.yPos + 58
    return {
        set = function(val) 
            selected = val
            dropdownBtn.Text = val
            if callback then callback(val) end
        end,
        refresh = function()
            updateList()
        end,
        getSelected = function() return selected end
    }
end

-- ============================================
-- FIXED TELEPORT FUNCTION (Actually works)
-- ============================================
local function TeleportToPlayer(targetName)
    if not targetName or targetName == "No players found" then
        warn("❌ No target player selected")
        return false
    end
    
    local target = Players:FindFirstChild(targetName)
    if not target then
        warn("❌ Player not found: " .. targetName)
        return false
    end
    
    -- Get target character and HRP
    local targetChar = target.Character or target.CharacterAdded:Wait()
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
    
    if not targetHRP then
        warn("❌ Target HRP missing")
        return false
    end
    
    -- Get your character and HRP
    local myChar = player.Character or player.CharacterAdded:Wait()
    local myHRP = myChar:WaitForChild("HumanoidRootPart", 5)
    
    if not myHRP then
        warn("❌ Your HRP missing")
        return false
    end
    
    -- Check if alive
    local humanoid = myChar:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then
        warn("❌ You are dead")
        return false
    end
    
    -- Target position (slightly above to avoid clipping)
    local targetCF = targetHRP.CFrame * CFrame.new(0, 5, 0)
    
    -- Try multiple times with verification
    local success = false
    
    for i = 1, 10 do
        -- Reset velocity to prevent anti-teleport
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        
        -- Direct CFrame teleport
        myHRP.CFrame = targetCF
        
        task.wait()
        
        -- Verify teleport worked
        if (myHRP.Position - targetHRP.Position).Magnitude < 15 then
            print("✅ Teleport successful on attempt " .. i)
            success = true
            break
        end
    end
    
    -- If still not successful, try forceful method
    if not success then
        warn("⚠️ Normal teleport failed, trying force method...")
        
        -- Force position for a short duration
        local connection
        local forceSuccess = false
        
        connection = RunService.Heartbeat:Connect(function()
            if not myHRP or not targetHRP then
                connection:Disconnect()
                return
            end
            
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.AssemblyAngularVelocity = Vector3.zero
            myHRP.CFrame = targetCF
            
            if (myHRP.Position - targetHRP.Position).Magnitude < 15 then
                forceSuccess = true
                connection:Disconnect()
            end
        end)
        
        task.wait(0.5)
        if connection then
            connection:Disconnect()
        end
        
        if forceSuccess then
            print("✅ Force teleport successful")
            success = true
        end
    end
    
    if success then
        print("✅ Teleported to: " .. target.Name)
        return true
    else
        warn("❌ Teleport failed after all attempts")
        return false
    end
end

-- ============================================
-- FIXED ATTACH FUNCTION (Actually attaches)
-- ============================================
local function StopFollowing()
    isAttached = false
    attachedPlayer = nil
    
    if attachmentConnection then
        attachmentConnection:Disconnect()
        attachmentConnection = nil
    end
    if deathConnection then
        deathConnection:Disconnect()
        deathConnection = nil
    end
    
    print("✅ Stopped following")
end

local function AttachToPlayer(targetName)
    if not targetName or targetName == "No players found" then
        warn("❌ No target player selected")
        return false
    end
    
    local target = Players:FindFirstChild(targetName)
    if not target then
        warn("❌ Player not found: " .. targetName)
        return false
    end
    
    -- Get target character and HRP
    local targetChar = target.Character or target.CharacterAdded:Wait()
    local targetHRP = targetChar:WaitForChild("HumanoidRootPart", 5)
    
    if not targetHRP then
        warn("❌ Target HRP missing")
        return false
    end
    
    -- Get your character
    local myChar = player.Character or player.CharacterAdded:Wait()
    
    if not myChar then
        warn("❌ You have no character")
        return false
    end
    
    -- Stop existing attachment
    if isAttached then
        StopFollowing()
    end
    
    attachedPlayer = target
    isAttached = true
    
    local function onPlayerDeath()
        warn("⚠️ Player died - detaching...")
        StopFollowing()
    end
    
    -- Connect death event
    local myHumanoid = myChar:FindFirstChild("Humanoid")
    if myHumanoid then
        if deathConnection then
            deathConnection:Disconnect()
        end
        deathConnection = myHumanoid.Died:Connect(onPlayerDeath)
    end
    
    -- Start attachment loop
    if attachmentConnection then
        attachmentConnection:Disconnect()
        attachmentConnection = nil
    end
    
    attachmentConnection = RunService.Heartbeat:Connect(function()
        if not isAttached or not attachedPlayer then
            StopFollowing()
            return
        end
        
        if not attachedPlayer.Parent then
            warn("⚠️ Target left the game - detaching...")
            StopFollowing()
            return
        end
        
        local targetChar = attachedPlayer.Character
        if not targetChar then
            return
        end
        
        local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
        if not targetHRP then
            -- Try alternative parts
            local parts = targetChar:GetChildren()
            for _, part in ipairs(parts) do
                if part:IsA("BasePart") and part.Name ~= "Head" then
                    targetHRP = part
                    break
                end
            end
            if not targetHRP then return end
        end
        
        local myChar = player.Character
        if not myChar then
            return
        end
        
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        if not myHRP then
            return
        end
        
        -- Check if alive
        local humanoid = myChar:FindFirstChild("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            return
        end
        
        -- Reset velocity and attach
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        
        -- Position: BEHIND target (super close)
        local targetPos = targetHRP.Position - (targetHRP.CFrame.LookVector * 1.5)
        local targetCF = CFrame.new(targetPos, targetHRP.Position)
        
        -- Direct CFrame attachment
        myHRP.CFrame = targetCF
    end)
    
    print("✅ Attached to: " .. target.Name)
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

AddLabel("═══════════════════════════════════", ACCENT, 14)
AddLabel("✨ Script by QueezZy123 (Maryyy) ✨", Color3.fromRGB(255, 200, 100), 18)
AddLabel("🎮 Games: Driving Empire", Color3.fromRGB(150, 200, 255), 14)
AddLabel("═══════════════════════════════════", ACCENT, 14)

AddDivider()
AddSection("Welcome")
AddSmallLabel("👋 Welcome to Script Hub!", Color3.fromRGB(200, 200, 220))
AddSmallLabel("🔧 Use the Security tab for teleport features", Color3.fromRGB(150, 150, 180))
AddSmallLabel("📌 Click '─' to minimize or expand the UI", Color3.fromRGB(150, 150, 180))

AddDivider()
AddSection("Quick Actions")
AddButton("Print Hello", "Test the script is working", function()
    print("Hello from QueezZy123!")
end)

-- ============================================
-- SECURITY TAB CONTENT
-- ============================================
securityTab.select()

AddSection("Teleport & Attach")

-- Player selection dropdown
local function RefreshDropdown()
    if playerDropdown then
        playerDropdown.refresh()
    end
end

local playerDropdown = AddPlayerDropdown("Select Player", GetPlayerNames(), GetPlayerNames()[1], function(value)
    selectedTargetName = value
    print("📌 Selected:", value)
    
    if statusLabel then
        if isAttached and attachedPlayer and attachedPlayer.Name == value then
            statusLabel.Text = "📌 Status: Attached to " .. value
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        else
            statusLabel.Text = "📌 Status: Selected " .. value
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
    end
end)

AddDivider()

-- Status label
local statusFrame = Instance.new("Frame")
statusFrame.Parent = securityTab.container
statusFrame.BackgroundTransparency = 1
statusFrame.Position = UDim2.new(0, 15, 0, securityTab.getY())
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
securityTab.setY(securityTab.getY() + 35)

AddDivider()

-- Teleport Button (FIXED)
AddButton("📍 Teleport to Player", "Instantly teleports you to the selected player", function()
    if not selectedTargetName or selectedTargetName == "No players found" then
        warn("❌ No player selected")
        return
    end
    
    if statusLabel then
        statusLabel.Text = "📍 Teleporting to " .. selectedTargetName .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    local success = TeleportToPlayer(selectedTargetName)
    
    if success then
        if isAttached and attachedPlayer and attachedPlayer.Name == selectedTargetName then
            statusLabel.Text = "📌 Status: Attached to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        else
            statusLabel.Text = "✅ Teleported to " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        end
    else
        statusLabel.Text = "❌ Failed to teleport - target may be dead"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Attach Button (FIXED)
AddButton("🔗 Attach to Player", "Follows the selected player continuously", function()
    if not selectedTargetName or selectedTargetName == "No players found" then
        warn("❌ No player selected")
        return
    end
    
    if statusLabel then
        statusLabel.Text = "🔗 Attaching to " .. selectedTargetName .. "..."
        statusLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    end
    
    local success = AttachToPlayer(selectedTargetName)
    
    if success then
        statusLabel.Text = "🔗 Attached to " .. selectedTargetName
        statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
    else
        statusLabel.Text = "❌ Failed to attach to " .. selectedTargetName
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end)

-- Detach Button
AddButton("🔓 Detach from Player", "Stops following the attached player", function()
    if not isAttached then
        warn("❌ Not attached to anyone")
        if statusLabel then
            statusLabel.Text = "❌ Not attached to anyone"
            statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
        return
    end
    
    local oldName = attachedPlayer and attachedPlayer.Name or "unknown"
    StopFollowing()
    
    if statusLabel then
        statusLabel.Text = "🔓 Detached from " .. oldName
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    end
end)

AddDivider()

-- Refresh Player List Button
AddButton("🔄 Refresh Players", "Updates the player list", function()
    RefreshDropdown()
    if statusLabel then
        statusLabel.Text = "✅ Player list refreshed!"
        statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        task.wait(1)
        if isAttached and attachedPlayer then
            statusLabel.Text = "📌 Status: Attached to " .. attachedPlayer.Name
            statusLabel.TextColor3 = Color3.fromRGB(60, 200, 120)
        elseif selectedTargetName and selectedTargetName ~= "No players found" then
            statusLabel.Text = "📌 Status: Selected " .. selectedTargetName
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        else
            statusLabel.Text = "📌 Status: No player selected"
            statusLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
        end
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
AddSection("Script Control")
AddButton("⚠️ Terminate Script", "Stops all script execution", function()
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
    box.BackgroundColor3 = ELEMBG
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
    descLabel.TextColor3 = TEXTDIM
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
    yesBtn.TextColor3 = TEXT
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
    noBtn.TextColor3 = TEXT
    noBtn.TextSize = 14
    RoundCorners(noBtn, 8)
    
    yesBtn.MouseButton1Click:Connect(function()
        confirm:Destroy()
        StopFollowing()
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
AddSmallLabel("Click '─' to minimize", Color3.fromRGB(80, 80, 120))

-- ============================================
-- SELECT DEFAULT TAB (Main)
-- ============================================
mainTab.select()

-- ============================================
-- AUTO-REFRESH PLAYER LIST (Every 0.5 seconds)
-- ============================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if not ScreenGui or not ScreenGui.Parent then break end
        pcall(RefreshDropdown)
    end
end)

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
print("📌 Features:")
print("  • Fixed Teleport - Actually works!")
print("  • Fixed Attach - Actually follows!")
print("  • Teleport verification")
print("  • Force teleport fallback")
print("📌 Click '─' to minimize/expand the UI")
