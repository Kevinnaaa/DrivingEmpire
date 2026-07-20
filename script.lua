-- Simple Custom UI (Rayfield Alternative)
-- This creates a basic UI without needing to fetch external libraries

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local TabContainer = Instance.new("Frame")
local ContentContainer = Instance.new("Frame")

-- Setup the GUI
ScreenGui.Name = "CustomUI"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.ClipsDescendants = true

-- Title
Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Title.BorderSizePixel = 0
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Font = Enum.Font.GothamBold
Title.Text = "My Script Hub"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20

-- Close Button
CloseButton.Name = "CloseButton"
CloseButton.Parent = MainFrame
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.BorderSizePixel = 0
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tab Container
TabContainer.Name = "TabContainer"
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
TabContainer.BorderSizePixel = 0
TabContainer.Position = UDim2.new(0, 0, 0, 40)
TabContainer.Size = UDim2.new(0, 100, 1, -40)

-- Content Container
ContentContainer.Name = "ContentContainer"
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ContentContainer.BorderSizePixel = 0
ContentContainer.Position = UDim2.new(0, 100, 0, 40)
ContentContainer.Size = UDim2.new(1, -100, 1, -40)

-- Function to create a tab
local function CreateTab(name, content)
    -- Tab button
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name.."Tab"
    TabButton.Parent = TabContainer
    TabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabButton.BorderSizePixel = 0
    TabButton.Size = UDim2.new(1, 0, 0, 40)
    TabButton.Font = Enum.Font.Gotham
    TabButton.Text = name
    TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.TextSize = 14
    
    -- Content frame
    local ContentFrame = Instance.new("Frame")
    ContentFrame.Name = name.."Content"
    ContentFrame.Parent = ContentContainer
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    ContentFrame.Visible = false
    
    -- Tab button click function
    TabButton.MouseButton1Click:Connect(function()
        for _, child in pairs(ContentContainer:GetChildren()) do
            if child:IsA("Frame") then
                child.Visible = false
            end
        end
        ContentFrame.Visible = true
    end)
    
    return ContentFrame
end

-- Function to create a button
local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Parent = parent
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    Button.BorderSizePixel = 0
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45 + 10)
    Button.Font = Enum.Font.Gotham
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- Function to create a toggle
local function CreateToggle(parent, text, default)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Parent = parent
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
    ToggleFrame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45 + 10)
    
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.Text = text
    ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleLabel.TextSize = 14
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Parent = ToggleFrame
    ToggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    ToggleButton.BorderSizePixel = 0
    ToggleButton.Position = UDim2.new(0.85, -20, 0.15, 0)
    ToggleButton.Size = UDim2.new(0, 40, 0, 25)
    ToggleButton.Font = Enum.Font.Gotham
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.TextSize = 12
    
    local state = default or false
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
        ToggleButton.Text = state and "ON" or "OFF"
    end)
    
    return ToggleFrame, function() return state end
end

-- Function to create a slider
local function CreateSlider(parent, text, min, max, default)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Parent = parent
    SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Size = UDim2.new(0.9, 0, 0, 45)
    SliderFrame.Position = UDim2.new(0.05, 0, 0, #parent:GetChildren() * 45 + 10)
    
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Parent = SliderFrame
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Size = UDim2.new(1, 0, 0, 20)
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.Text = text..": "..tostring(default)
    SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SliderLabel.TextSize = 14
    
    local SliderBar = Instance.new("Frame")
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    SliderBar.BorderSizePixel = 0
    SliderBar.Position = UDim2.new(0, 0, 0.5, 0)
    SliderBar.Size = UDim2.new(1, 0, 0, 15)
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local value = default
    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local connection
            connection = game:GetService("UserInputService").InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    local pos = input.Position.X - SliderBar.AbsolutePosition.X
                    local percent = math.clamp(pos / SliderBar.AbsoluteSize.X, 0, 1)
                    value = min + (max - min) * percent
                    value = math.round(value)
                    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    SliderLabel.Text = text..": "..tostring(value)
                end
            end)
            input.InputEnded:Connect(function()
                connection:Disconnect()
            end)
        end
    end)
    
    return SliderFrame, function() return value end
end

-- Create tabs
local MainTab = CreateTab("Main")
local SettingsTab = CreateTab("Settings")

-- Add buttons to Main tab
CreateButton(MainTab, "Print Hello", function()
    print("Hello from Custom UI!")
    -- You can add notifications here
end)

CreateButton(MainTab, "Execute Script", function()
    print("Script executed!")
    -- Add your script logic here
end)

-- Add toggle to Main tab
local toggle, getToggleState = CreateToggle(MainTab, "Enable Feature", false)

-- Add slider to Main tab
local slider, getSliderValue = CreateSlider(MainTab, "Speed", 1, 100, 50)

-- Settings tab
CreateButton(SettingsTab, "Toggle UI", function()
    MainFrame.Visible = not MainFrame.Visible
end)

CreateButton(SettingsTab, "Reset UI", function()
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
end)

CreateButton(SettingsTab, "Close UI", function()
    ScreenGui:Destroy()
end)

-- Make the UI draggable
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
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

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("Custom UI created successfully!")
