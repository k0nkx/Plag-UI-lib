-- Modified UI Library
-- Maintains original visual style with improved structure

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Main UI Container
local GUI = Instance.new("ScreenGui")
GUI.Name = "PCR_1"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false
GUI.Parent = CoreGui

-- Utility Functions
local Utility = {}

function Utility.Create(class, properties)
    local instance = Instance.new(class)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

function Utility.RoundCorners(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 4)
    corner.Parent = object
    return corner
end

function Utility.AddStroke(object, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(52, 52, 52)
    stroke.Thickness = thickness or 1
    stroke.LineJoinMode = Enum.LineJoinMode.Round
    stroke.Parent = object
    return stroke
end

function Utility.Tween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(duration or 0.26, easingStyle or Enum.EasingStyle.Quad, easingDirection or Enum.EasingDirection.InOut)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- UI Library
local UILibrary = {}
UILibrary.Windows = {}
UILibrary.CurrentWindow = nil
UILibrary.Dragging = false
UILibrary.CurrentZIndex = 0

-- Color Constants
local COLORS = {
    Background = Color3.fromRGB(33, 33, 33),
    Section = Color3.fromRGB(25, 25, 25),
    Dark = Color3.fromRGB(18, 18, 18),
    Text = Color3.fromRGB(197, 197, 197),
    TextDisabled = Color3.fromRGB(138, 138, 138),
    Accent = Color3.fromRGB(91, 133, 197),
    Border = Color3.fromRGB(52, 52, 52),
    ToggleOn = Color3.fromRGB(84, 122, 181),
    ToggleOff = Color3.fromRGB(25, 25, 25)
}

-- Main Window
local MainWindow = Utility.Create("Frame", {
    Name = "MAIN",
    Parent = GUI,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = COLORS.Background,
    BorderSizePixel = 0,
    Position = UDim2.new(0.285, 0, 0.65, 0),
    Size = UDim2.new(0, 588, 0, 415),
    ZIndex = 2
})

local Background = Utility.Create("Frame", {
    Name = "BG",
    Parent = MainWindow,
    BackgroundColor3 = COLORS.Section,
    BorderColor3 = COLORS.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.062, 0),
    Size = UDim2.new(0, 588, 0, 365),
    ClipsDescendants = true
})

local Header = Utility.Create("Frame", {
    Name = "Header",
    Parent = MainWindow,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 23),
    ZIndex = 2
})

local HeaderLayout = Utility.Create("UIListLayout", {
    Parent = Header,
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Center
})

local HeaderDivider = Utility.Create("Frame", {
    Name = "HeaderDivider",
    Parent = MainWindow,
    BackgroundColor3 = COLORS.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.059, 0),
    Size = UDim2.new(1, 0, 0, 1),
    ZIndex = 3
})

local Footer = Utility.Create("Frame", {
    Name = "Footer",
    Parent = MainWindow,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0.943, 0),
    Size = UDim2.new(1, 0, 0, 23),
    ZIndex = 2
})

local WebsiteLabel = Utility.Create("TextLabel", {
    Name = "Website",
    Parent = Footer,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.177, 0, 0.5, 0),
    Size = UDim2.new(0, 197, 0, 23),
    ZIndex = 3,
    Font = Enum.Font.ArialBold,
    Text = "NerdsInc.gq",
    TextColor3 = COLORS.Text,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Left
})

local StatusLabel = Utility.Create("TextLabel", {
    Name = "Status",
    Parent = Footer,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.796, 0, 0.5, 0),
    Size = UDim2.new(0, 197, 0, 23),
    ZIndex = 3,
    Font = Enum.Font.ArialBold,
    Text = "Alpha build / ∞ days left",
    TextColor3 = COLORS.Text,
    TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Right
})

local FooterDivider = Utility.Create("Frame", {
    Name = "FooterDivider",
    Parent = MainWindow,
    BackgroundColor3 = COLORS.Accent,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0.941, 0),
    Size = UDim2.new(1, 0, 0, 1),
    ZIndex = 10
})

local FPSCounter = Utility.Create("TextLabel", {
    Name = "FPSCounter",
    Parent = MainWindow,
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    Position = UDim2.new(0.907, 0, 0.027, 0),
    Size = UDim2.new(0, 84, 0, 23),
    ZIndex = 3,
    Font = Enum.Font.SourceSansSemibold,
    Text = "Not loaded.",
    TextColor3 = COLORS.Text,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Right
})

local ContentContainer = Utility.Create("Frame", {
    Name = "Content",
    Parent = MainWindow,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0.062, 0),
    Size = UDim2.new(0, 588, 0, 364),
    ZIndex = 5
})

-- Dragging System
local function MakeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function Update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            Update(input)
        end
    end)
end

-- Ripple Effect
local function AddRippleEffect(button, textLabel, rippleColor)
    button.ClipsDescendants = true
    
    button.MouseButton1Click:Connect(function()
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local ripple = Instance.new("ImageLabel")
        ripple.Name = "Ripple"
        ripple.Parent = button
        ripple.BackgroundTransparency = 1
        ripple.ZIndex = 10
        ripple.Image = "rbxassetid://266543268"
        ripple.ImageColor3 = rippleColor or Color3.fromRGB(211, 211, 211)
        ripple.ImageTransparency = 0.6
        
        local x, y = mouse.X - ripple.AbsolutePosition.X, mouse.Y - ripple.AbsolutePosition.Y
        ripple.Position = UDim2.new(0, x, 0, y)
        
        local size = 0
        if button.AbsoluteSize.X > button.AbsoluteSize.Y then
            size = button.AbsoluteSize.X * 1.5
        else
            size = button.AbsoluteSize.Y * 1.5
        end
        
        Utility.Tween(ripple, {
            Size = UDim2.new(0, size, 0, size),
            Position = UDim2.new(0.5, -size/2, 0.5, -size/2)
        }, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        for i = 1, 15 do
            ripple.ImageTransparency = ripple.ImageTransparency + 0.05
            task.wait()
        end
        ripple:Destroy()
    end)
    
    if textLabel then
        button.MouseEnter:Connect(function()
            Utility.Tween(textLabel, {TextColor3 = Color3.fromRGB(152, 152, 152)}, 0.2)
        end)
        
        button.MouseLeave:Connect(function()
            Utility.Tween(textLabel, {TextColor3 = COLORS.Text}, 0.2)
        end)
    end
end

-- Color Picker
local ColorPicker = {}
ColorPicker.__index = ColorPicker

function ColorPicker.Create(title, defaultColor, callback)
    local self = setmetatable({}, ColorPicker)
    
    self.Title = title or "Color Picker"
    self.CurrentColor = defaultColor or Color3.new(1, 1, 1)
    self.Callback = callback or function() end
    self.IsOpen = false
    
    self:Build()
    return self
end

function ColorPicker:Build()
    self.Container = Utility.Create("Frame", {
        Name = "ColorPicker",
        Parent = GUI,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 272, 0, 150),
        ZIndex = 2,
        Visible = false
    })
    
    -- Animation frame
    self.AnimFrame = Utility.Create("Frame", {
        Name = "AnimFrame",
        Parent = self.Container,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        Position = UDim2.new(-0.026, 0, -0.007, 0),
        Size = UDim2.new(0, 285, 0, 159),
        ZIndex = 99,
        BorderSizePixel = 0
    })
    
    -- Main content
    self.Main = Utility.Create("Frame", {
        Name = "Main",
        Parent = self.Container,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 283, 0, 157)
    })
    
    self.Background = Utility.Create("Frame", {
        Name = "Background",
        Parent = self.Main,
        BackgroundColor3 = COLORS.Section,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.158, 0),
        Size = UDim2.new(0, 272, 0, 125)
    })
    
    -- Color wheel section
    local wheelContainer = Utility.Create("Frame", {
        Name = "WheelContainer",
        Parent = self.Background,
        BackgroundColor3 = COLORS.Dark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 16, 0, 7),
        Size = UDim2.new(0, 156, 0, 107),
        ZIndex = 23
    })
    
    self.ColorWheel = Utility.Create("ImageButton", {
        Name = "ColorWheel",
        Parent = wheelContainer,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.419, 0, 0.492, 0),
        Size = UDim2.new(0.6, 0, 0.867, 0),
        ZIndex = 25,
        Image = "http://www.roblox.com/asset/?id=6020299385"
    })
    
    Utility.Create("UIAspectRatioConstraint", {Parent = self.ColorWheel, AspectRatio = 1})
    
    self.Picker = Utility.Create("ImageLabel", {
        Name = "Picker",
        Parent = self.ColorWheel,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0.09, 0, 0.09, 0),
        Image = "http://www.roblox.com/asset/?id=3678860011"
    })
    
    -- Darkness slider
    self.DarknessSlider = Utility.Create("ImageButton", {
        Name = "DarknessSlider",
        Parent = wheelContainer,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.855, 0, 0.555, 0),
        Size = UDim2.new(0.094, 0, 0.88, 0),
        ZIndex = 25,
        Image = "rbxassetid://3570695787",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.12
    })
    
    local gradient = Utility.Create("UIGradient", {
        Parent = self.DarknessSlider,
        Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
        },
        Rotation = 90
    })
    
    self.SliderHandle = Utility.Create("ImageLabel", {
        Name = "SliderHandle",
        Parent = self.DarknessSlider,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.491, 0, 0.073, 0),
        Size = UDim2.new(1.287, 0, 0.027, 0),
        ZIndex = 2,
        Image = "rbxassetid://3570695787",
        ImageColor3 = Color3.fromRGB(255, 74, 74),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.12
    })
    
    Utility.Create("UIAspectRatioConstraint", {Parent = self.DarknessSlider, AspectRatio = 0.157})
    
    -- Color display
    local displayContainer = Utility.Create("Frame", {
        Name = "DisplayContainer",
        Parent = self.Background,
        BackgroundColor3 = COLORS.Dark,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 182, 0, 7),
        Size = UDim2.new(0, 79, 0, 109),
        ZIndex = 23
    })
    
    self.ColorDisplay = Utility.Create("ImageLabel", {
        Name = "ColorDisplay",
        Parent = displayContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.255, 0, 0.159, 0),
        Size = UDim2.new(0.473, 0, 0.53, 0),
        ZIndex = 25,
        Image = "rbxassetid://3570695787",
        ImageColor3 = self.CurrentColor,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.12
    })
    
    Utility.Create("UIAspectRatioConstraint", {Parent = self.ColorDisplay})
    
    self.SetButton = Utility.Create("ImageButton", {
        Name = "SetButton",
        Parent = displayContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.232, 0, 0.73, 0),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 23,
        Image = "rbxassetid://1489284025"
    })
    
    self.ResetButton = Utility.Create("ImageButton", {
        Name = "ResetButton",
        Parent = displayContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.622, 0, 0.73, 0),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 23,
        Image = "rbxassetid://5640320478"
    })
    
    -- Header
    local header = Utility.Create("Frame", {
        Name = "Header",
        Parent = self.Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 271, 0, 23),
        ZIndex = 2
    })
    
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Parent = header,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.01, 0, 0.217, 0),
        Size = UDim2.new(0, 258, 0, 13),
        ZIndex = 3,
        Font = Enum.Font.SourceSansSemibold,
        Text = self.Title,
        TextColor3 = COLORS.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local divider = Utility.Create("Frame", {
        Name = "Divider",
        Parent = self.Main,
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.151, 0),
        Size = UDim2.new(0.961, 0, 0, 1),
        ZIndex = 3
    })
    
    MakeDraggable(self.Container)
    self:SetupInteractions()
end

function ColorPicker:SetupInteractions()
    local isDraggingWheel = false
    local isDraggingSlider = false
    
    self.ColorWheel.MouseButton1Down:Connect(function()
        isDraggingWheel = true
    end)
    
    self.DarknessSlider.MouseButton1Down:Connect(function()
        isDraggingSlider = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDraggingWheel = false
            isDraggingSlider = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        
        local mousePos = UserInputService:GetMouseLocation()
        local wheelCenter = Vector2.new(
            self.ColorWheel.AbsolutePosition.X + self.ColorWheel.AbsoluteSize.X/2,
            self.ColorWheel.AbsolutePosition.Y + self.ColorWheel.AbsoluteSize.Y/2
        )
        
        if isDraggingWheel then
            local pickerPos = mousePos - self.ColorWheel.AbsolutePosition
            self.Picker.Position = UDim2.new(0, pickerPos.X, 0, pickerPos.Y)
        elseif isDraggingSlider then
            local sliderPos = math.clamp(
                mousePos.Y - self.DarknessSlider.AbsolutePosition.Y,
                0,
                self.DarknessSlider.AbsoluteSize.Y
            )
            self.SliderHandle.Position = UDim2.new(0.491, 0, 0, sliderPos)
        end
        
        self:UpdateColor(wheelCenter)
    end)
    
    self.SetButton.MouseButton1Click:Connect(function()
        self:Close()
        self.Callback(self.CurrentColor)
    end)
    
    self.ResetButton.MouseButton1Click:Connect(function()
        self:Close()
    end)
end

function ColorPicker:UpdateColor(wheelCenter)
    local pickerCenter = Vector2.new(
        self.Picker.AbsolutePosition.X + self.Picker.AbsoluteSize.X/2,
        self.Picker.AbsolutePosition.Y + self.Picker.AbsoluteSize.Y/2
    )
    
    local h = (math.pi - math.atan2(pickerCenter.Y - wheelCenter.Y, pickerCenter.X - wheelCenter.X)) / (math.pi * 2)
    local s = (wheelCenter - pickerCenter).Magnitude / (self.ColorWheel.AbsoluteSize.X/2)
    local v = 1 - math.abs((self.SliderHandle.AbsolutePosition.Y - self.DarknessSlider.AbsolutePosition.Y) / self.DarknessSlider.AbsoluteSize.Y)
    
    self.CurrentColor = Color3.fromHSV(math.clamp(h, 0, 1), math.clamp(s, 0, 1), math.clamp(v, 0, 1))
    self.ColorDisplay.ImageColor3 = self.CurrentColor
end

function ColorPicker:Open()
    if self.IsOpen then return end
    self.IsOpen = true
    
    self.Container.Visible = true
    self.Container.BackgroundTransparency = 1
    self.AnimFrame.Visible = true
    self.AnimFrame.Position = UDim2.new(-1.085, 0, -0.013, 0)
    self.Main.Visible = false
    
    Utility.Tween(self.AnimFrame, {Position = UDim2.new(-0.026, 0, -0.007, 0)}, 0.2)
    task.wait(0.2)
    
    self.Container.BackgroundTransparency = 0
    self.Main.Visible = true
    
    Utility.Tween(self.AnimFrame, {Position = UDim2.new(1.077, 0, -0.007, 0)}, 0.2)
    task.wait(0.2)
    
    self.AnimFrame.Position = UDim2.new(-1.085, 0, -0.013, 0)
end

function ColorPicker:Close()
    if not self.IsOpen then return end
    self.IsOpen = false
    
    self.Container.BackgroundTransparency = 1
    self.Main.Visible = false
    self.AnimFrame.Visible = false
    self.Container.Visible = false
end

-- Window Class
local Window = {}
Window.__index = Window

function Window.Create(title)
    local self = setmetatable({}, Window)
    
    self.Title = title or "Window"
    self.Sections = {}
    self.TabButtons = {}
    self.Content = nil
    
    self:Build()
    return self
end

function Window:Build()
    -- Create tab button
    self.TabButton = Utility.Create("TextButton", {
        Name = self.Title,
        Parent = Header,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, self:CalculateTextWidth(self.Title), 0, 13),
        Font = Enum.Font.SourceSansSemibold,
        Text = self.Title,
        TextColor3 = COLORS.TextDisabled,
        TextSize = 16
    })
    
    -- Create content container
    self.Content = Utility.Create("ScrollingFrame", {
        Name = self.Title,
        Parent = ContentContainer,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0.019, 0),
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        ScrollBarThickness = 5,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    })
    
    local layout = Utility.Create("UIListLayout", {
        Parent = self.Content,
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    self.LeftColumn = Utility.Create("Frame", {
        Name = "Left",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        ZIndex = 3,
        ClipsDescendants = true
    })
    
    self.LeftLayout = Utility.Create("UIListLayout", {
        Parent = self.LeftColumn,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    self.RightColumn = Utility.Create("Frame", {
        Name = "Right",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.5, 0, 1, 0),
        ZIndex = 3,
        ClipsDescendants = true
    })
    
    self.RightLayout = Utility.Create("UIListLayout", {
        Parent = self.RightColumn,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 5)
    })
    
    -- Connect tab button
    self.TabButton.MouseButton1Click:Connect(function()
        self:Activate()
    end)
    
    table.insert(UILibrary.Windows, self)
    
    -- Activate first window
    if #UILibrary.Windows == 1 then
        self:Activate()
    end
end

function Window:CalculateTextWidth(text)
    local baseWidth = #text * 7
    return math.max(baseWidth, 50)
end

function Window:Activate()
    if UILibrary.CurrentWindow == self then return end
    
    -- Deactivate current window
    if UILibrary.CurrentWindow then
        UILibrary.CurrentWindow.Content.Visible = false
        Utility.Tween(UILibrary.CurrentWindow.TabButton, {TextColor3 = COLORS.TextDisabled}, 0.26)
    end
    
    -- Activate this window
    UILibrary.CurrentWindow = self
    self.Content.Visible = true
    Utility.Tween(self.TabButton, {TextColor3 = Color3.fromRGB(210, 210, 210)}, 0.26)
end

function Window:UpdateSize()
    local leftHeight = self.LeftLayout.AbsoluteContentSize.Y
    local rightHeight = self.RightLayout.AbsoluteContentSize.Y
    local maxHeight = math.max(leftHeight, rightHeight)
    
    self.Content.CanvasSize = UDim2.new(0, 0, 0, maxHeight + 15)
end

function Window:AddSection(title, side)
    local section = Section.Create(title, side == 2 and self.RightColumn or self.LeftColumn)
    table.insert(self.Sections, section)
    
    -- Update window size after adding section
    task.wait()
    self:UpdateSize()
    
    return section
end

-- Section Class
local Section = {}
Section.__index = Section

function Section.Create(title, parent)
    local self = setmetatable({}, Section)
    
    self.Title = title or "Section"
    self.Parent = parent
    self.Elements = {}
    
    self:Build()
    return self
end

function Section:Build()
    self.Container = Utility.Create("Frame", {
        Name = self.Title,
        Parent = self.Parent,
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        Size = UDim2.new(0.9, 0, 0, 138)
    })
    
    self.Main = Utility.Create("Frame", {
        Name = "Main",
        Parent = self.Container,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = COLORS.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 4
    })
    
    Utility.AddStroke(self.Main, COLORS.Border, 1)
    
    self.Content = Utility.Create("Frame", {
        Name = "Content",
        Parent = self.Main,
        BackgroundColor3 = Color3.fromRGB(29, 29, 29),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0.965, 0),
        ZIndex = 4
    })
    
    self.ElementHolder = Utility.Create("Frame", {
        Name = "Elements",
        Parent = self.Content,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 4, 0, 5),
        Size = UDim2.new(0.982, 0, 0.957, 0),
        ZIndex = 5
    })
    
    self.ElementLayout = Utility.Create("UIListLayout", {
        Parent = self.ElementHolder,
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 5)
    })
    
    self.Divider = Utility.Create("Frame", {
        Name = "Divider",
        Parent = self.Main,
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.1, 0),
        Size = UDim2.new(1, 0, 0, 1),
        ZIndex = 6
    })
    
    self.TitleLabel = Utility.Create("TextLabel", {
        Name = "Title",
        Parent = self.Main,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.512, 0, 0.055, 0),
        Size = UDim2.new(1, -20, 0, 22),
        ZIndex = 3,
        Font = Enum.Font.SourceSansSemibold,
        Text = self.Title,
        TextColor3 = Color3.fromRGB(221, 221, 221),
        TextSize = 17,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    -- Update size when elements change
    self.ElementLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        self:UpdateSize()
    end)
end

function Section:UpdateSize()
    local contentHeight = self.ElementLayout.AbsoluteContentSize.Y
    self.Container.Size = UDim2.new(0.9, 0, 0, contentHeight + 30)
end

function Section:AddLabel(text)
    local label = Utility.Create("TextLabel", {
        Parent = self.ElementHolder,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 11),
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 18,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    return label
end

function Section:AddButton(text, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 21),
        ZIndex = 14,
        ClipsDescendants = true
    })
    
    Utility.RoundCorners(container, 4)
    local stroke = Utility.AddStroke(container, COLORS.Border, 1)
    
    local label = Utility.Create("TextLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 19),
        Font = Enum.Font.SourceSansBold,
        Text = text,
        TextColor3 = Color3.fromRGB(84, 84, 84),
        TextSize = 17
    })
    
    local button = Utility.Create("TextButton", {
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 20
    })
    
    AddRippleEffect(button, label, Color3.fromRGB(180, 180, 180))
    
    button.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    return button
end

function Section:AddToggle(text, defaultValue, keybind, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        ZIndex = 14
    })
    
    local label = Utility.Create("TextLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.083, 0, 0.013, 0),
        Size = UDim2.new(0.92, 0, 0, 15),
        ZIndex = 15,
        Font = Enum.Font.SourceSansBold,
        Text = text,
        TextColor3 = Color3.fromRGB(84, 84, 84),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local toggleButton = Utility.Create("Frame", {
        Parent = container,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = defaultValue and COLORS.ToggleOn or COLORS.ToggleOff,
        BorderSizePixel = 0,
        Position = UDim2.new(0.019, 0, 0.387, 0),
        Size = UDim2.new(0, 15, 0, 15),
        ZIndex = 15
    })
    
    local stroke = Utility.AddStroke(toggleButton, COLORS.Border, 1)
    
    local button = Utility.Create("TextButton", {
        Parent = container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 20
    })
    
    local state = defaultValue or false
    
    local function UpdateToggle()
        state = not state
        Utility.Tween(toggleButton, {
            BackgroundColor3 = state and COLORS.ToggleOn or COLORS.ToggleOff
        }, 0.26)
        
        Utility.Tween(label, {
            TextColor3 = state and Color3.fromRGB(152, 152, 152) or Color3.fromRGB(84, 84, 84)
        }, 0.26)
        
        if callback then callback(state) end
    end
    
    button.MouseButton1Click:Connect(UpdateToggle)
    
    -- Keybind support
    if keybind then
        local keybindButton = self:CreateKeybindButton(keybind, container, function()
            UpdateToggle()
        end)
    end
    
    AddRippleEffect(button, label)
    
    return {
        Update = function(value)
            state = value
            UpdateToggle()
        end,
        GetState = function() return state end
    }
end

function Section:CreateKeybindButton(keybind, parent, callback)
    local button = Utility.Create("TextButton", {
        Parent = parent,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(1.003, 0, 0.367, 0),
        Size = UDim2.new(0, 45, 0, 15),
        ZIndex = 22,
        AutoButtonColor = false,
        Font = Enum.Font.ArialBold,
        Text = keybind.Name or "...",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10
    })
    
    Utility.RoundCorners(button, 3)
    
    local isChanging = false
    
    button.MouseButton1Click:Connect(function()
        if isChanging then return end
        
        Utility.Tween(button, {BackgroundColor3 = Color3.fromRGB(34, 34, 34)}, 0.1)
        button.Text = "..."
        
        local input = UserInputService.InputBegan:Wait()
        if input.KeyCode.Name ~= "Unknown" then
            isChanging = true
            Utility.Tween(button, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.1)
            button.Text = input.KeyCode.Name
            keybind = input.KeyCode
            isChanging = false
        end
    end)
    
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == keybind then
            if callback then callback() end
        end
    end)
    
    return button
end

function Section:AddSlider(text, min, max, defaultValue, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 32),
        ZIndex = 20
    })
    
    local label = Utility.Create("TextLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.005, 0, 0.044, 0),
        Size = UDim2.new(0.794, 0, 0, 10),
        ZIndex = 21,
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local valueBox = Utility.Create("TextBox", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.798, 0, 0, 0),
        Size = UDim2.new(0.202, 0, 0, 11),
        ZIndex = 23,
        ClearTextOnFocus = false,
        Font = Enum.Font.SourceSansBold,
        Text = tostring(defaultValue or math.floor((max + min) / 2)),
        TextColor3 = Color3.fromRGB(90, 90, 90),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local sliderTrack = Utility.Create("Frame", {
        Parent = container,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(-0.002, 0, 0.491, 0),
        Size = UDim2.new(1.002, 0, 0, 13),
        ZIndex = 23
    })
    
    local sliderFill = Utility.Create("Frame", {
        Parent = sliderTrack,
        BackgroundColor3 = COLORS.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(
            (defaultValue - min) / (max - min),
            1
        ),
        ZIndex = 23
    })
    
    local stroke = Utility.AddStroke(sliderTrack, COLORS.Border, 1)
    
    local isDragging = false
    local currentValue = defaultValue or math.floor((max + min) / 2)
    
    local function UpdateSlider(value)
        value = math.clamp(value, min, max)
        currentValue = value
        valueBox.Text = string.format("%.2f", value)
        sliderFill.Size = UDim2.fromScale((value - min) / (max - min), 1)
        
        if callback then callback(value) end
    end
    
    local sliderButton = Utility.Create("TextButton", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 1, 0, 19),
        Size = UDim2.new(1, -2, 0, 13),
        ZIndex = 21,
        Text = "",
        AutoButtonColor = false
    })
    
    sliderButton.MouseButton1Down:Connect(function()
        isDragging = true
        Utility.Tween(stroke, {Color = Color3.fromRGB(115, 115, 115)}, 0.26)
        Utility.Tween(valueBox, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.3)
        
        local mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local percent = math.clamp((mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
        UpdateSlider(min + (max - min) * percent)
        
        local moveConnection
        moveConnection = mouse.Move:Connect(function()
            local percent = math.clamp((mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            UpdateSlider(min + (max - min) * percent)
        end)
        
        local releaseConnection
        releaseConnection = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                isDragging = false
                Utility.Tween(stroke, {Color = COLORS.Border}, 0.26)
                Utility.Tween(valueBox, {TextColor3 = Color3.fromRGB(126, 126, 126)}, 0.3)
                
                moveConnection:Disconnect()
                releaseConnection:Disconnect()
            end
        end)
    end)
    
    valueBox.FocusLost:Connect(function(enterPressed)
        local num = tonumber(valueBox.Text)
        if num then
            UpdateSlider(num)
        else
            valueBox.Text = string.format("%.2f", currentValue)
        end
    end)
    
    return {
        Update = UpdateSlider,
        GetValue = function() return currentValue end
    }
end

function Section:AddDropdown(text, options, defaultValue, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 27
    })
    
    Utility.RoundCorners(container, 4)
    
    local toggleButton = Utility.Create("TextButton", {
        Parent = container,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 22),
        AutoButtonColor = false,
        Text = " ",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        Font = Enum.Font.SourceSansSemibold
    })
    
    Utility.RoundCorners(toggleButton, 4)
    
    local label = Utility.Create("TextLabel", {
        Parent = toggleButton,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.448, 0, 0.455, 0),
        Size = UDim2.new(0.826, 0, 0, 18),
        ZIndex = 30,
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local arrow = Utility.Create("TextLabel", {
        Parent = toggleButton,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.917, 0, 0.55, 0),
        Size = UDim2.new(0, 14, 0, 14),
        ZIndex = 30,
        Font = Enum.Font.SourceSansSemibold,
        Text = "+",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Right
    })
    
    local optionsLayout = Utility.Create("UIListLayout", {
        Parent = container,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 3)
    })
    
    local isOpen = false
    local selected = defaultValue or options[1]
    
    local function CreateOption(option)
        local optionButton = Utility.Create("TextButton", {
            Parent = container,
            BackgroundColor3 = Color3.fromRGB(37, 37, 37),
            BorderSizePixel = 0,
            Size = UDim2.new(0.925, 0, 0, 16),
            ZIndex = 29,
            AutoButtonColor = false,
            Text = "",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            Font = Enum.Font.SourceSansSemibold
        })
        
        Utility.RoundCorners(optionButton, 4)
        
        local optionLabel = Utility.Create("TextLabel", {
            Parent = optionButton,
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(0.502, 0, 0.441, 0),
            Size = UDim2.new(0.536, 0, 0, 15),
            Font = Enum.Font.SourceSansSemibold,
            Text = option,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 15
        })
        
        optionButton.MouseButton1Click:Connect(function()
            selected = option
            if callback then callback(option) end
        end)
        
        AddRippleEffect(optionButton, optionLabel)
        
        return optionButton
    end
    
    for _, option in ipairs(options) do
        CreateOption(option)
    end
    
    toggleButton.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        
        if isOpen then
            Utility.Tween(arrow, {Rotation = 180}, 0.26)
            Utility.Tween(container, {
                Size = UDim2.new(1, 0, 0, optionsLayout.AbsoluteContentSize.Y + 11)
            }, 0.2)
        else
            Utility.Tween(arrow, {Rotation = 0}, 0.26)
            Utility.Tween(container, {
                Size = UDim2.new(1, 0, 0, 25)
            }, 0.2)
        end
    end)
    
    AddRippleEffect(toggleButton, arrow, Color3.fromRGB(180, 180, 180))
    
    return {
        GetSelected = function() return selected end,
        SetSelected = function(value)
            selected = value
            if callback then callback(value) end
        end
    }
end

function Section:AddColorPicker(text, defaultColor, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = UDim2.new(1, 0, 0, 22),
        ZIndex = 22
    })
    
    Utility.RoundCorners(container, 6)
    
    local button = Utility.Create("TextButton", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 7, 0, 2),
        Size = UDim2.new(1, -14, 0, 18),
        ZIndex = 23,
        AutoButtonColor = false,
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    Utility.RoundCorners(button, 5)
    
    local colorDisplay = Utility.Create("ImageLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.853, 0, 0.182, 0),
        Size = UDim2.new(0, 29, 0, 14),
        ZIndex = 23,
        Image = "rbxassetid://3570695787",
        ImageColor3 = defaultColor or Color3.new(1, 1, 1),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(100, 100, 100, 100),
        SliceScale = 0.12
    })
    
    button.MouseButton1Click:Connect(function()
        local picker = ColorPicker.Create(text, defaultColor, function(color)
            colorDisplay.ImageColor3 = color
            if callback then callback(color) end
        end)
        picker:Open()
    end)
end

function Section:AddTextBox(text, placeholder, clearOnFocus, inputType, callback)
    local container = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 22),
        ZIndex = 14
    })
    
    local label = Utility.Create("TextLabel", {
        Parent = container,
        BackgroundTransparency = 1,
        Position = UDim2.new(-0.009, 0, 0.013, 0),
        Size = UDim2.new(0.708, 0, 0, 24),
        ZIndex = 15,
        Font = Enum.Font.SourceSansBold,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local inputContainer = Utility.Create("Frame", {
        Parent = container,
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Position = UDim2.new(1.027, 0, 0.546, 0),
        Size = UDim2.new(0, 70, 0, 16),
        ZIndex = 25
    })
    
    local stroke = Utility.AddStroke(inputContainer, Color3.fromRGB(52, 52, 52), 1)
    
    local textBox = Utility.Create("TextBox", {
        Parent = inputContainer,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 28,
        ClearTextOnFocus = clearOnFocus or false,
        Font = Enum.Font.ArialBold,
        PlaceholderText = placeholder or "Input here",
        Text = "",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10
    })
    
    -- Input filtering
    local filters = {
        [1] = "%D+", -- Numbers only
        [2] = "%p+", -- No special characters
        [3] = "%W+", -- No special characters or spaces
        [4] = "%A+", -- Letters only
        [5] = "" -- No filter
    }
    
    local filter = filters[inputType or 5]
    
    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        if filter ~= "" then
            textBox.Text = textBox.Text:gsub(filter, "")
        end
        
        if #textBox.Text > 21 then
            textBox.Text = textBox.Text:sub(1, 21)
        end
        
        -- Auto-size input box
        local textWidth = #textBox.Text * 7
        if textWidth < 70 then
            textWidth = #placeholder * 6
        end
        
        Utility.Tween(inputContainer, {
            Size = UDim2.new(0, math.clamp(textWidth, 70, 150), 0, 16)
        }, 0.4)
        
        if callback then callback(textBox.Text) end
    end)
    
    return {
        SetText = function(text)
            textBox.Text = text
        end,
        GetText = function()
            return textBox.Text
        end
    }
end

function Section:AddSeparator()
    local separator = Utility.Create("Frame", {
        Parent = self.ElementHolder,
        BackgroundColor3 = Color3.fromRGB(50, 50, 50),
        Position = UDim2.new(0.016, 0, 0.491, 0),
        Size = UDim2.new(0.968, 0, 0, 2),
        ZIndex = 22
    })
    
    Utility.RoundCorners(separator, 10)
end

-- Public API
function UILibrary:AddWindow(title)
    return Window.Create(title)
end

function UILibrary:SetWebsite(text)
    WebsiteLabel.Text = text
end

function UILibrary:SetStatus(text)
    StatusLabel.Text = text
end

function UILibrary:AddWatermark(text)
    local watermark = Utility.Create("Frame", {
        Parent = GUI,
        AnchorPoint = Vector2.new(0, 0.5),
        BackgroundColor3 = Color3.fromRGB(22, 22, 22),
        BorderSizePixel = 0,
        Position = UDim2.new(0.011, 0, 0.973, 0),
        Size = UDim2.new(0, #text * 7, 0, 28),
        ZIndex = 8,
        ClipsDescendants = true
    })
    
    Utility.AddStroke(watermark, COLORS.Accent, 1)
    
    local inner = Utility.Create("Frame", {
        Parent = watermark,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(29, 29, 29),
        BorderSizePixel = 0,
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(1, -6, 1, -6),
        ZIndex = 7
    })
    
    local label = Utility.Create("TextLabel", {
        Parent = inner,
        BackgroundTransparency = 1,
        Position = UDim2.new(0.022, 0, 0, 0),
        Size = UDim2.new(1, -10, 1, 0),
        Font = Enum.Font.SourceSansSemibold,
        Text = text,
        TextColor3 = COLORS.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    return {
        SetText = function(newText)
            label.Text = newText
            watermark.Size = UDim2.new(0, #newText * 7, 0, 28)
        end,
        SetVisible = function(visible)
            watermark.Visible = visible
        end
    }
end

-- FPS Counter
local function SetupFPSCounter()
    local timeFunction = RunService:IsRunning() and time or os.clock
    local lastIteration, start
    local frameUpdateTable = {}
    
    local function UpdateFPS()
        lastIteration = timeFunction()
        
        for i = #frameUpdateTable, 1, -1 do
            frameUpdateTable[i + 1] = frameUpdateTable[i] >= lastIteration - 1 and frameUpdateTable[i] or nil
        end
        
        frameUpdateTable[1] = lastIteration
        local fps = math.floor(timeFunction() - start >= 1 and #frameUpdateTable or #frameUpdateTable / (timeFunction() - start))
        FPSCounter.Text = fps .. " FPS"
    end
    
    start = timeFunction()
    RunService.Heartbeat:Connect(UpdateFPS)
end

-- Initialize
MakeDraggable(MainWindow)
SetupFPSCounter()

-- Return library
UILibrary.GUI = GUI
return UILibrary
