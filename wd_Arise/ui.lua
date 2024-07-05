_G.Color = Color3.fromRGB(48, 95, 255)
IKAI = true
if IKAI then
    do
        local ui = game.CoreGui:FindFirstChild("ProjectWD")
        if ui then
            ui:Destroy()
        end
    end
    
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Mouse = LocalPlayer:GetMouse()
    local tween = game:GetService("TweenService")
    local Red = {RainbowColorValue = 0, HueSelectionPosition = 0}
    local LogoButton = [[7040391851]]
    
    
    local function Tween(instance, properties, style, wa)
        if style == nil or "" then
            return Back
        end
        tween:Create(instance, TweenInfo.new(wa, Enum.EasingStyle[style]), {properties}):Play()
    end
    
    local ActualTypes = {
        RoundFrame = "ImageLabel",
        Shadow = "ImageLabel",
        Circle = "ImageLabel",
        CircleButton = "ImageButton",
        Frame = "Frame",
        Label = "TextLabel",
        Button = "TextButton",
        SmoothButton = "ImageButton",
        Box = "TextBox",
        ScrollingFrame = "ScrollingFrame",
        Menu = "ImageButton",
        NavBar = "ImageButton"
    }
    
    local Properties = {
        RoundFrame = {
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=5554237731",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(3, 3, 297, 297)
        },
        SmoothButton = {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=5554237731",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(3, 3, 297, 297)
        },
        Shadow = {
            Name = "Shadow",
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=5554236805",
            ScaleType = Enum.ScaleType.Slice,
            SliceCenter = Rect.new(23, 23, 277, 277),
            Size = UDim2.fromScale(1, 1) + UDim2.fromOffset(30, 30),
            Position = UDim2.fromOffset(-15, -15)
        },
        Circle = {
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=5554831670"
        },
        CircleButton = {
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Image = "http://www.roblox.com/asset/?id=5554831670"
        },
        Frame = {
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1)
        },
        Label = {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 0),
            Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(5, 0),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        },
        Button = {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 0),
            Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(5, 0),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        },
        Box = {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(5, 0),
            Size = UDim2.fromScale(1, 1) - UDim2.fromOffset(5, 0),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left
        },
        ScrollingFrame = {
            BackgroundTransparency = 1,
            ScrollBarThickness = 0,
            CanvasSize = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1)
        },
        Menu = {
            Name = "More",
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            Image = "http://www.roblox.com/asset/?id=5555108481",
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromScale(1, 0.5) - UDim2.fromOffset(25, 10)
        },
        NavBar = {
            Name = "SheetToggle",
            Image = "http://www.roblox.com/asset/?id=5576439039",
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromOffset(5, 5),
            AutoButtonColor = false
        }
    }
    
    local Types = {
        "RoundFrame",
        "Shadow",
        "Circle",
        "CircleButton",
        "Frame",
        "Label",
        "Button",
        "SmoothButton",
        "Box",
        "ScrollingFrame",
        "Menu",
        "NavBar"
    }
    
    function FindType(String)
        for _, Type in next, Types do
            if Type:sub(1, #String):lower() == String:lower() then
                return Type
            end
        end
        return false
    end
    
    local Objects = {}
    
    function Objects.new(Type)
        local TargetType = FindType(Type)
        if TargetType then
            local NewImage = Instance.new(ActualTypes[TargetType])
            if Properties[TargetType] then
                for Property, Value in next, Properties[TargetType] do
                    NewImage[Property] = Value
                end
            end
            return NewImage
        else
            return Instance.new(Type)
        end
    end
    
    local function GetXY(GuiObject)
        local Max, May = GuiObject.AbsoluteSize.X, GuiObject.AbsoluteSize.Y
        local Px, Py = math.clamp(Mouse.X - GuiObject.AbsolutePosition.X, 0, Max), math.clamp(Mouse.Y - GuiObject.AbsolutePosition.Y, 0, May)
        return Px / Max, Py / May
    end
    
    local function CircleAnim(GuiObject, EndColour, StartColour)
        local PX, PY = GetXY(GuiObject)
        local Circle = Objects.new("Circle")
        Circle.Size = UDim2.fromScale(0, 0)
        Circle.Position = UDim2.fromScale(PX, PY)
        Circle.ImageColor3 = StartColour or GuiObject.ImageColor3
        Circle.ZIndex = 200
        Circle.Parent = GuiObject
        local Size = GuiObject.AbsoluteSize.X
        TweenService:Create(Circle, TweenInfo.new(0.7), {Position = UDim2.fromScale(PX, PY) - UDim2.fromOffset(Size / 2, Size / 2), ImageTransparency = 1, ImageColor3 = EndColour, Size = UDim2.fromOffset(Size, Size)}):Play()
        spawn(function()
            wait(0.5)
            Circle:Destroy()
        end)
    end
    
    
    local function MakeDraggable(topbarobject, object)
        local Dragging = nil
        local DragInput = nil
        local DragStart = nil
        local StartPosition = nil
        
        local function Update(input)
            local Delta = input.Position - DragStart
            local pos =
                UDim2.new(
                    StartPosition.X.Scale,
                    StartPosition.X.Offset + Delta.X,
                    StartPosition.Y.Scale,
                    StartPosition.Y.Offset + Delta.Y
            )
            local Tween = TweenService:Create(object, TweenInfo.new(0.2), {Position = pos})
            Tween:Play()
        end
        
        topbarobject.InputBegan:Connect(
            function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    Dragging = true
                    DragStart = input.Position
                    StartPosition = object.Position
                    
                    input.Changed:Connect(
                        function()
                            if input.UserInputState == Enum.UserInputState.End then
                                Dragging = false
                            end
                        end
                )
                end
            end
        )
        topbarobject.InputChanged:Connect(
            function(input)
                if
                    input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
                then
                    DragInput = input
                end
            end
        )
        UserInputService.InputChanged:Connect(
            function(input)
                if input == DragInput and Dragging then
                    Update(input)
                end
            end
    )
    end
    
    library1 = {}
    
    function library1:Window(text, text2, text3, logo, keybind)
        local uihide = false
        local abc = false
        local logo = logo or 0
        local currentpage = ""
        local keybind = keybind or Enum.KeyCode.RightControl
        local yoo = string.gsub(tostring(keybind), "Enum.KeyCode.", "")
        
        local RippleHUBLIB = Instance.new("ScreenGui")
        RippleHUBLIB.Name = "ProjectWD"
        RippleHUBLIB.Parent = game.CoreGui
        RippleHUBLIB.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        
        local Main = Instance.new("Frame")
        Main.Name = "Main"
        Main.Parent = RippleHUBLIB
        Main.ClipsDescendants = true
        Main.AnchorPoint = Vector2.new(0.5, 0.5)
        Main.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        Main.Position = UDim2.new(0.5, 0, 0.5, 0)
        Main.Size = UDim2.new(0, 0, 0, 0)
        
        Main:TweenSize(UDim2.new(0, 600, 0, 300), "Out", "Quad", 0.4, true)
        
        local MCNR = Instance.new("UICorner")
        MCNR.Name = "MCNR"
        MCNR.Parent = Main
        MCNR.CornerRadius = UDim.new(0, 3)
        
        local Top = Instance.new("Frame")
        Top.Name = "Top"
        Top.Parent = Main
        Top.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Top.Size = UDim2.new(0, 600, 0, 27)
        
        local TCNR = Instance.new("UICorner")
        TCNR.Name = "TCNR"
        TCNR.Parent = Top
        TCNR.CornerRadius = UDim.new(0, 3)
        
        --       local Logo = Instance.new("ImageLabel")
        --       Logo.Name = "Logo"
        --       Logo.Parent = Top
        --       Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        --       Logo.BackgroundTransparency = 1.000
        --       Logo.Position = UDim2.new(0, 14, 0, 2)
        --       Logo.Size = UDim2.new(0, 23, 0, 23)
        --       Logo.Image = "rbxassetid://..tostring(logo)"
        local Name = Instance.new("TextLabel")
        Name.Name = "Name"
        Name.Parent = Top
        Name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Name.BackgroundTransparency = 1.000
        Name.Position = UDim2.new(0, 5, 0, 0.5)
        Name.Size = UDim2.new(0, 61, 0, 27)
        Name.Font = Enum.Font.GothamSemibold
        Name.Text = text
        Name.TextColor3 = Color3.fromRGB(225, 225, 225)
        Name.TextSize = 16.000
        
        local Hub = Instance.new("TextLabel")
        Hub.Name = "Hub"
        Hub.Parent = Top
        Hub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Hub.BackgroundTransparency = 1.000
        Hub.Position = UDim2.new(0, 65, 0, 0.5)
        Hub.Size = UDim2.new(0, 81, 0, 27)
        Hub.Font = Enum.Font.GothamSemibold
        Hub.Text = text2
        Hub.TextColor3 = _G.Color
        Hub.TextSize = 16.000
        Hub.TextXAlignment = Enum.TextXAlignment.Left
        
        local Ver = Instance.new("TextLabel")
        Ver.Name = "Ver"
        Ver.Parent = Top
        Ver.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ver.BackgroundTransparency = 1.000
        Ver.Position = UDim2.new(0.847561002, 0, 0, 1)
        Ver.Size = UDim2.new(0, 47, 0, 27)
        Ver.Font = Enum.Font.GothamSemibold
        Ver.Text = text3
        Ver.TextColor3 = _G.Color
        Ver.TextSize = 15.000
        
        
        local BindButton = Instance.new("TextButton")
        BindButton.Name = "BindButton"
        BindButton.Parent = Top
        BindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        BindButton.BackgroundTransparency = 1.000
        BindButton.Position = UDim2.new(0.157561002, 0, 0, 1)
        BindButton.Size = UDim2.new(0, 100, 0, 27)
        BindButton.Font = Enum.Font.GothamSemibold
        BindButton.Text = "[ " .. string.gsub(tostring(keybind), "Enum.KeyCode.", "") .. " ]"
        BindButton.TextColor3 = Color3.fromRGB(100, 100, 100)
        BindButton.TextSize = 11.000
        
        BindButton.MouseButton1Click:Connect(function()
            BindButton.Text = "[ ... ]"
            local inputwait = game:GetService("UserInputService").InputBegan:wait()
            local shiba = inputwait.KeyCode == Enum.KeyCode.Unknown and inputwait.UserInputType or inputwait.KeyCode
            
            if shiba.Name ~= "Focus" and shiba.Name ~= "MouseMovement" then
                BindButton.Text = "[ " .. shiba.Name .. " ]"
                yoo = shiba.Name
            end
        end)
        
        do end
        
        toggled = false
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode[yoo] then
                if toggled == false then
                    toggled = true
                    game:GetService("CoreGui"):FindFirstChild("ProjectWD").Enabled = false
                else
                    toggled = false
                    game:GetService("CoreGui"):FindFirstChild("ProjectWD").Enabled = true
                end
            end
        end)
        
        
        
        
        
        local Tab = Instance.new("Frame")
        Tab.Name = "Tab"
        Tab.Parent = Main
        Tab.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Tab.Position = UDim2.new(0, 5, 0, 30)
        Tab.Size = UDim2.new(0, 140, 0, 265)
        
        local TCNR = Instance.new("UICorner")
        TCNR.Name = "TCNR"
        TCNR.Parent = Tab
        TCNR.CornerRadius = UDim.new(0, 5)
        
        local ScrollTab = Instance.new("ScrollingFrame")
        ScrollTab.Name = "ScrollTab"
        ScrollTab.Parent = Tab
        ScrollTab.Active = true
        ScrollTab.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ScrollTab.BackgroundTransparency = 1.000
        ScrollTab.Size = UDim2.new(0, 150, 0, 263)
        ScrollTab.CanvasSize = UDim2.new(0, 0, 0, 0)
        ScrollTab.ScrollBarThickness = 0
        
        local PLL = Instance.new("UIListLayout")
        PLL.Name = "PLL"
        PLL.Parent = ScrollTab
        PLL.SortOrder = Enum.SortOrder.LayoutOrder
        PLL.Padding = UDim.new(0, 1)
        PLL.HorizontalAlignment = "Center"
        local PPD = Instance.new("UIPadding")
        PPD.Name = "PPD"
        PPD.Parent = ScrollTab
        PPD.PaddingLeft = UDim.new(0, 0)
        PPD.PaddingTop = UDim.new(0, 0)
        
        local Page = Instance.new("Frame")
        Page.Name = "Page"
        Page.Parent = Main
        Page.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Page.Position = UDim2.new(0.245426834, 0, 0, 30)
        Page.Size = UDim2.new(0, 450, 0, 265)
        
        local PCNR = Instance.new("UICorner")
        PCNR.Name = "PCNR"
        PCNR.Parent = Page
        PCNR.CornerRadius = UDim.new(0, 5)
        local MainPage = Instance.new("Frame")
        MainPage.Name = "MainPage"
        MainPage.Parent = Page
        MainPage.ClipsDescendants = true
        MainPage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MainPage.BackgroundTransparency = 1.000
        MainPage.Size = UDim2.new(0, 490, 0, 365)
        
        local PageList = Instance.new("Folder")
        PageList.Name = "PageList"
        PageList.Parent = MainPage
        
        local UIPageLayout = Instance.new("UIPageLayout")
        
        UIPageLayout.Parent = PageList
        UIPageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIPageLayout.EasingDirection = Enum.EasingDirection.InOut
        UIPageLayout.EasingStyle = Enum.EasingStyle.Quad
        UIPageLayout.FillDirection = Enum.FillDirection.Vertical
        UIPageLayout.Padding = UDim.new(0, 15)
        UIPageLayout.TweenTime = 0.400
        UIPageLayout.GamepadInputEnabled = false
        UIPageLayout.ScrollWheelInputEnabled = false
        UIPageLayout.TouchInputEnabled = false
        
        MakeDraggable(Top, Main)
        
        
        local uitab = {}
        
        function uitab:Tab(text, logo1)
            local TabButton = Instance.new("TextButton")
            TabButton.Parent = ScrollTab
            TabButton.Name = text .. "Server"
            TabButton.Text = text
            TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            TabButton.BackgroundTransparency = 1.000
            TabButton.Size = UDim2.new(0, 130, 0, 23)
            TabButton.Font = Enum.Font.GothamSemibold
            TabButton.TextColor3 = Color3.fromRGB(225, 225, 225)
            TabButton.TextSize = 15.000
            TabButton.TextTransparency = 0.500
            
            -- local IDK = Instance.new("ImageLabel")
            -- IDK.Name = "LogoIDK"
            -- IDK.Parent = TabButton
            -- IDK.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            -- IDK.BackgroundTransparency = 1.000
            -- IDK.Position = UDim2.new(0, 15 - #text, 0, 1)
            -- IDK.Size = UDim2.new(0, 20, 0, 20)
            -- IDK.Image = "rbxassetid://" .. tostring(logo1)
            
            
            local MainFramePage = Instance.new("ScrollingFrame")
            MainFramePage.Name = text .. "_Page"
            MainFramePage.Parent = PageList
            MainFramePage.Active = true
            MainFramePage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            MainFramePage.BackgroundTransparency = 1.000
            MainFramePage.BorderSizePixel = 0
            MainFramePage.Size = UDim2.new(0, 450, 0, 263)
            MainFramePage.CanvasSize = UDim2.new(0, 0, 0, 0)
            MainFramePage.ScrollBarThickness = 0
            
            local UIPadding = Instance.new("UIPadding")
            local UIListLayout = Instance.new("UIListLayout")
            
            UIPadding.Parent = MainFramePage
            UIPadding.PaddingLeft = UDim.new(0, 0)
            UIPadding.PaddingTop = UDim.new(0, 0)
            
            UIListLayout.Padding = UDim.new(0, 4)
            UIListLayout.Parent = MainFramePage
            UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            UIListLayout.HorizontalAlignment = "Center"
            
            TabButton.MouseButton1Click:Connect(function()
                for i, v in next, ScrollTab:GetChildren() do
                    if v:IsA("TextButton") then
                        TweenService:Create(
                            v,
                            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.5}
                        ):Play()
                    end
                    TweenService:Create(
                        TabButton,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextTransparency = 0}
                    ):Play()
                end
                for i, v in next, PageList:GetChildren() do
                    currentpage = string.gsub(TabButton.Name, "Server", "") .. "_Page"
                    if v.Name == currentpage then
                        UIPageLayout:JumpTo(v)
                    end
                end
            end)
            
            if abc == false then
                for i, v in next, ScrollTab:GetChildren() do
                    if v:IsA("TextButton") then
                        TweenService:Create(
                            v,
                            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.5}
                        ):Play()
                    end
                    TweenService:Create(
                        TabButton,
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextTransparency = 0}
                    ):Play()
                end
                UIPageLayout:JumpToIndex(1)
                abc = true
            end
            
            game:GetService("RunService").Stepped:Connect(function()
                pcall(function()
                    MainFramePage.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 20)
                    ScrollTab.CanvasSize = UDim2.new(0, 0, 0, PLL.AbsoluteContentSize.Y + 20)
                end)
            end)
            
            
            local main = {}
            function main:Button(text, callback)
                local Button = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local TextBtn = Instance.new("TextButton")
                local UICorner_2 = Instance.new("UICorner")
                local Black = Instance.new("Frame")
                local UICorner_3 = Instance.new("UICorner")
                local IMGBUTTON = Instance.new("ImageLabel")
                
                Button.Name = "Button"
                Button.Parent = MainFramePage
                Button.BackgroundColor3 = _G.Color
                Button.Size = UDim2.new(0, 442, 0, 31)
                
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = Button
                
                
                
                TextBtn.Name = "TextBtn"
                TextBtn.Parent = Button
                TextBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                TextBtn.Position = UDim2.new(0, 3, 0, 1)
                TextBtn.Size = UDim2.new(0, 436, 0, 29)
                TextBtn.AutoButtonColor = false
                TextBtn.Font = Enum.Font.GothamSemibold
                TextBtn.Text = text
                TextBtn.TextColor3 = Color3.fromRGB(225, 225, 225)
                TextBtn.TextSize = 15.000
                TextBtn.ClipsDescendants = true
                
                UICorner_2.CornerRadius = UDim.new(0, 5)
                UICorner_2.Parent = TextBtn
                
                IMGBUTTON.Name = "IconB"
                IMGBUTTON.Parent = TextBtn
                IMGBUTTON.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                IMGBUTTON.BackgroundTransparency = 1.000
                IMGBUTTON.Position = UDim2.new(0, 10, 0, 5)
                IMGBUTTON.Size = UDim2.new(0, 20, 0, 20)
                IMGBUTTON.Image = "rbxassetid://8498776661"
                
                
                Black.Name = "Black"
                Black.Parent = Button
                Black.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                Black.BackgroundTransparency = 1.000
                Black.BorderSizePixel = 0
                Black.Position = UDim2.new(0, 1, 0, 1)
                Black.Size = UDim2.new(0, 468, 0, 29)
                
                UICorner_3.CornerRadius = UDim.new(0, 0)
                UICorner_3.Parent = Black
                
                TextBtn.MouseEnter:Connect(function()
                    TweenService:Create(
                        Black,
                        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 0.7}
                    ):Play()
                end)
                TextBtn.MouseLeave:Connect(function()
                    TweenService:Create(
                        Black,
                        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}
                    ):Play()
                end)
                TextBtn.MouseButton1Click:Connect(function()
                    Button.BackgroundColor3 = Color3.fromRGB(42, 235, 68)
                    CircleAnim(TextBtn, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                    TextBtn.TextSize = 1
                    TweenService:Create(
                        TextBtn,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextSize = 15}
                    ):Play()
                    callback()
                    task.wait(.3)
                    Button.BackgroundColor3 = _G.Color
                end)
            end
            function main:Toggle(text, Imgidicon, config, callback)
                config = config or false
                local toggled = config
                local Toggle = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local Button = Instance.new("TextButton")
                local UICorner_2 = Instance.new("UICorner")
                local Label = Instance.new("TextLabel")
                local ToggleImage = Instance.new("Frame")
                local UICorner_3 = Instance.new("UICorner")
                local Circle = Instance.new("Frame")
                local UICorner_4 = Instance.new("UICorner")
                local imgLabelIcon = Instance.new("ImageLabel")
                
                
                Toggle.Name = "Toggle"
                Toggle.Parent = MainFramePage
                Toggle.BackgroundColor3 = _G.Color
                Toggle.Size = UDim2.new(0, 442, 0, 31)
                
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = Toggle
                
                Button.Name = "Button"
                Button.Parent = Toggle
                Button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Button.Position = UDim2.new(0, 3, 0, 1)
                Button.Size = UDim2.new(0, 436, 0, 29)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.SourceSans
                Button.Text = ""
                Button.TextColor3 = Color3.fromRGB(0, 0, 0)
                Button.TextSize = 11.000
                
                UICorner_2.CornerRadius = UDim.new(0, 5)
                UICorner_2.Parent = Button
                
                Label.Name = "Label"
                Label.Parent = Toggle
                Label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Label.BackgroundTransparency = 1.000
                Label.Position = UDim2.new(0, 1, 0, 1)
                Label.Size = UDim2.new(0, 440, 0, 29)
                Label.Font = Enum.Font.GothamSemibold
                Label.Text = text
                Label.TextColor3 = Color3.fromRGB(225, 225, 225)
                Label.TextSize = 15.000
                
                ToggleImage.Name = "ToggleImage"
                ToggleImage.Parent = Toggle
                ToggleImage.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
                ToggleImage.Position = UDim2.new(0, 390, 0, 5)
                ToggleImage.Size = UDim2.new(0, 45, 0, 20)
                
                UICorner_3.CornerRadius = UDim.new(0, 5)
                UICorner_3.Parent = ToggleImage
                
                Circle.Name = "Circle"
                Circle.Parent = ToggleImage
                Circle.BackgroundColor3 = _G.Color
                Circle.Position = UDim2.new(0, 2, 0, 2)
                Circle.Size = UDim2.new(0, 16, 0, 16)
                
                UICorner_4.CornerRadius = UDim.new(0, 5)
                UICorner_4.Parent = Circle
                
                imgLabelIcon.Name = "Icon"
                imgLabelIcon.Parent = Toggle
                imgLabelIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                imgLabelIcon.BackgroundTransparency = 1.000
                imgLabelIcon.Position = UDim2.new(0, 10, 0, 5)
                imgLabelIcon.Size = UDim2.new(0, 20, 0, 20)
                imgLabelIcon.Image = "http://www.roblox.com/asset/?id=" .. Imgidicon
                
                Button.MouseButton1Click:Connect(function()
                    if toggled == false then
                        toggled = true
                        Circle:TweenPosition(UDim2.new(0, 27, 0, 2), "Out", "Sine", 0.2, true)
                        TweenService:Create(
                            Toggle,
                            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(42, 235, 68)}
                        ):Play()
                        TweenService:Create(
                            Circle,
                            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(42, 235, 68)}
                        ):Play()
                    else
                        toggled = false
                        Circle:TweenPosition(UDim2.new(0, 2, 0, 2), "Out", "Sine", 0.2, true)
                        TweenService:Create(
                            Toggle,
                            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = _G.Color}
                        ):Play()
                        TweenService:Create(
                            Circle,
                            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = _G.Color}
                        ):Play()
                    end
                    pcall(callback, toggled)
                end)
                
                if config == true then
                    toggled = true
                    Circle:TweenPosition(UDim2.new(0, 27, 0, 2), "Out", "Sine", 0.4, true)
                    TweenService:Create(
                        Toggle,
                        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(42, 235, 68)}
                    ):Play()
                    TweenService:Create(
                        Circle,
                        TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(42, 235, 68)}
                    ):Play()
                    pcall(callback, toggled)
                end
            end
            function main:Dropdown(text, old, option, callback)
                local isdropping = false
                local UICornerdrop = Instance.new("UICorner")
                local dropmain = Instance.new("Frame")
                local Dropdown = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local DropTitle = Instance.new("TextLabel")
                local DropScroll = Instance.new("ScrollingFrame")
                local UIListLayout = Instance.new("UIListLayout")
                local UIPadding = Instance.new("UIPadding")
                local DropButton = Instance.new("TextButton")
                local DropImage = Instance.new("ImageLabel")
                
                dropmain.Name = text
                dropmain.Parent = MainFramePage
                dropmain.BackgroundColor3 = _G.Color
                dropmain.Size = UDim2.new(0, 442, 0, 31)
                
                UICornerdrop.CornerRadius = UDim.new(0, 5)
                UICornerdrop.Parent = dropmain
                
                Dropdown.Name = "Dropdown"
                Dropdown.Parent = dropmain
                Dropdown.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Dropdown.ClipsDescendants = true
                Dropdown.Size = UDim2.new(0, 436, 0, 29)
                Dropdown.Position = UDim2.new(0, 3, 0, 1)
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = Dropdown
                
                if type(old) == "string" then
                    DropTitle.Name = "DropTitle"
                    DropTitle.Parent = Dropdown
                    DropTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    DropTitle.BackgroundTransparency = 1.000
                    DropTitle.Size = UDim2.new(0, 436, 0, 29)
                    DropTitle.Font = Enum.Font.GothamSemibold
                    DropTitle.Text = text .. " : " .. old
                    DropTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
                    DropTitle.TextSize = 15.000
                else
                    DropTitle.Name = "DropTitle"
                    DropTitle.Parent = Dropdown
                    DropTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    DropTitle.BackgroundTransparency = 1.000
                    DropTitle.Size = UDim2.new(0, 436, 0, 29)
                    DropTitle.Font = Enum.Font.GothamSemibold
                    DropTitle.Text = text .. " : "
                    DropTitle.TextColor3 = Color3.fromRGB(225, 225, 225)
                    DropTitle.TextSize = 15.000
                end
                
                DropScroll.Name = "DropScroll"
                DropScroll.Parent = DropTitle
                DropScroll.Active = true
                DropScroll.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropScroll.BackgroundTransparency = 1.000
                DropScroll.BorderSizePixel = 0
                DropScroll.Position = UDim2.new(0, 0, 0, 31)
                DropScroll.Size = UDim2.new(0, 436, 0, 100)
                DropScroll.CanvasSize = UDim2.new(0, 0, 0, 2)
                DropScroll.ScrollBarThickness = 3
                
                UIListLayout.Parent = DropScroll
                UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
                UIListLayout.Padding = UDim.new(0, 0)
                
                UIPadding.Parent = DropScroll
                UIPadding.PaddingLeft = UDim.new(0, 0)
                UIPadding.PaddingTop = UDim.new(0, 0)
                
                DropImage.Name = "DropImage"
                DropImage.Parent = Dropdown
                DropImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropImage.BackgroundTransparency = 1.000
                DropImage.Position = UDim2.new(0, 420, 0, 4)
                DropImage.Rotation = -90
                DropImage.Size = UDim2.new(0, 20, 0, 20)
                DropImage.Image = "rbxassetid://6031090990"
                
                DropButton.Name = "DropButton"
                DropButton.Parent = Dropdown
                DropButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropButton.BackgroundTransparency = 1.000
                DropButton.Size = UDim2.new(0, 436, 0, 29)
                DropButton.Font = Enum.Font.SourceSans
                DropButton.Text = ""
                DropButton.TextColor3 = Color3.fromRGB(0, 0, 0)
                DropButton.TextSize = 14.000
                
                local Dropsearch = Instance.new("Frame")
                Dropsearch.Name = "Drop_Search"
                Dropsearch.Parent = Dropdown
                Dropsearch.BackgroundColor3 = _G.Color
                Dropsearch.BackgroundTransparency = 0
                Dropsearch.Position = UDim2.new(0, 20, 0, 6)
                Dropsearch.Size = UDim2.new(0, 65, 0, 18)
                
                local Dropsearchcor = Instance.new("UICorner")
                Dropsearchcor.CornerRadius = UDim.new(0, 5)
                Dropsearchcor.Name = "Drop_Search_Corner"
                Dropsearchcor.Parent = Dropsearch
                
                local TextBox = Instance.new("TextBox")
                TextBox.Parent = Dropsearch
                TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                TextBox.Position = UDim2.new(0, 1, 0, 1)
                TextBox.Size = UDim2.new(0, 63, 0, 16)
                TextBox.Font = Enum.Font.GothamSemibold
                TextBox.TextColor3 = Color3.fromRGB(225, 225, 225)
                TextBox.TextSize = 9.000
                TextBox.Text = "Search"
                TextBox.TextTransparency = 0
                
                local UICorner_2 = Instance.new("UICorner")
                UICorner_2.CornerRadius = UDim.new(0, 5)
                UICorner_2.Parent = TextBox
                
                for i, v in next, option do
                    local Item = Instance.new("TextButton")
                    Item.Name = "Item"
                    Item.Parent = DropScroll
                    Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Item.BackgroundTransparency = 1.000
                    Item.Size = UDim2.new(0, 460, 0, 26)
                    Item.Font = Enum.Font.GothamSemibold
                    Item.Text = tostring(v)
                    Item.TextColor3 = Color3.fromRGB(225, 225, 225)
                    Item.TextSize = 13.000
                    Item.TextTransparency = 0.500
                    Item.ClipsDescendants = true
                    
                    
                    Item.MouseEnter:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0}
                        ):Play()
                    end)
                    
                    Item.MouseLeave:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.5}
                        ):Play()
                    end)
                    
                    Item.MouseButton1Click:Connect(function()
                        CircleAnim(Item, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                        isdropping = false
                        Dropdown:TweenSize(UDim2.new(0, 436, 0, 29), "Out", "Quad", 0.3, true)
                        dropmain:TweenSize(UDim2.new(0, 442, 0, 31), "Out", "Quad", 0.3, true)
                        TweenService:Create(
                            DropImage,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = -90}
                        ):Play()
                        DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                        callback(Item.Text)
                        DropTitle.Text = text .. " : " .. Item.Text
                    end)
                end
                
                DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                
                DropButton.MouseButton1Click:Connect(function()
                    if isdropping == false then
                        isdropping = true
                        Dropdown:TweenSize(UDim2.new(0, 436, 0, 131), "Out", "Quad", 0.3, true)
                        dropmain:TweenSize(UDim2.new(0, 442, 0, 133), "Out", "Quad", 0.3, true)
                        dropmain.BackgroundColor3 = Color3.fromRGB(42, 235, 68)
                        TweenService:Create(
                            DropImage,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = 180}
                        ):Play()
                        DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                    else
                        isdropping = false
                        Dropdown:TweenSize(UDim2.new(0, 436, 0, 29), "Out", "Quad", 0.3, true)
                        dropmain:TweenSize(UDim2.new(0, 442, 0, 31), "Out", "Quad", 0.3, true)
                        dropmain.BackgroundColor3 = _G.Color
                        TweenService:Create(
                            DropImage,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = -90}
                        ):Play()
                        DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                    end
                end)
                
                local dropfunc = {}
                function dropfunc:Add(t)
                    local Item = Instance.new("TextButton")
                    Item.Name = "Item"
                    Item.Parent = DropScroll
                    Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Item.BackgroundTransparency = 1.000
                    Item.Size = UDim2.new(0, 460, 0, 26)
                    Item.Font = Enum.Font.GothamSemibold
                    Item.Text = tostring(t)
                    Item.TextColor3 = Color3.fromRGB(225, 225, 225)
                    Item.TextSize = 13.000
                    Item.TextTransparency = 0.500
                    Item.ClipsDescendants = true
                    
                    Item.MouseEnter:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0}
                        ):Play()
                    end)
                    
                    Item.MouseLeave:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.5}
                        ):Play()
                    
                    end)
                    
                    Item.MouseButton1Click:Connect(function()
                        isdropping = false
                        CircleAnim(Item, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                        Dropdown:TweenSize(UDim2.new(0, 436, 0, 29), "Out", "Quad", 0.3, true)
                        dropmain:TweenSize(UDim2.new(0, 442, 0, 31), "Out", "Quad", 0.3, true)
                        TweenService:Create(
                            DropImage,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = -90}
                        ):Play()
                        DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                        callback(Item.Text)
                        DropTitle.Text = text .. " : " .. Item.Text
                    end)
                end
                
                function dropfunc:Clear()
                    DropTitle.Text = tostring(text) .. " : "
                    isdropping = false
                    Dropdown:TweenSize(UDim2.new(0, 436, 0, 29), "Out", "Quad", 0.3, true)
                    dropmain:TweenSize(UDim2.new(0, 442, 0, 31), "Out", "Quad", 0.3, true)
                    TweenService:Create(
                        DropImage,
                        TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Rotation = -90}
                    ):Play()
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                end
                function dropfunc:Clear2()
                    for i, v in next, DropScroll:GetChildren() do
                        if v:IsA("TextButton") then
                            v:Destroy()
                        end
                    end
                end
                
                function dropfunc:add2(t)
                    local Item = Instance.new("TextButton")
                    Item.Name = "Item"
                    Item.Parent = DropScroll
                    Item.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                    Item.BackgroundTransparency = 1.000
                    Item.Size = UDim2.new(0, 460, 0, 26)
                    Item.Font = Enum.Font.GothamSemibold
                    Item.Text = tostring(t)
                    Item.TextColor3 = Color3.fromRGB(225, 225, 225)
                    Item.TextSize = 13.000
                    Item.TextTransparency = 0.500
                    Item.ClipsDescendants = true
                    
                    Item.MouseEnter:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0}
                        ):Play()
                    end)
                    
                    Item.MouseLeave:Connect(function()
                        TweenService:Create(
                            Item,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {TextTransparency = 0.5}
                        ):Play()
                    end)
                    
                    Item.MouseButton1Click:Connect(function()
                        isdropping = false
                        CircleAnim(Item, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255))
                        Dropdown:TweenSize(UDim2.new(0, 436, 0, 29), "Out", "Quad", 0.3, true)
                        dropmain:TweenSize(UDim2.new(0, 442, 0, 31), "Out", "Quad", 0.3, true)
                        TweenService:Create(
                            DropImage,
                            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Rotation = -90}
                        ):Play()
                        DropScroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
                        callback(Item.Text)
                        DropTitle.Text = text .. " : " .. Item.Text
                    end)
                end
                TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                    dropfunc:Clear2()
                    for i, v in pairs(option) do
                        if string.lower(v):match(string.lower(TextBox.Text)) then
                            dropfunc:add2(v)
                        end
                    end
                end)
                return dropfunc
            end
            
            function main:Slider(text, min, max, set, callback)
                local Slider = Instance.new("Frame")
                local slidercorner = Instance.new("UICorner")
                local sliderr = Instance.new("Frame")
                local sliderrcorner = Instance.new("UICorner")
                local SliderLabel = Instance.new("TextLabel")
                local HAHA = Instance.new("Frame")
                local AHEHE = Instance.new("TextButton")
                local bar = Instance.new("Frame")
                local bar1 = Instance.new("Frame")
                local bar1corner = Instance.new("UICorner")
                local barcorner = Instance.new("UICorner")
                local circlebar = Instance.new("Frame")
                local UICorner = Instance.new("UICorner")
                local slidervalue = Instance.new("Frame")
                local valuecorner = Instance.new("UICorner")
                local TextBox = Instance.new("TextBox")
                local UICorner_2 = Instance.new("UICorner")
                
                Slider.Name = "Slider"
                Slider.Parent = MainFramePage
                Slider.BackgroundColor3 = _G.Color
                Slider.BackgroundTransparency = 0
                Slider.Size = UDim2.new(0, 442, 0, 51)
                
                slidercorner.CornerRadius = UDim.new(0, 5)
                slidercorner.Name = "slidercorner"
                slidercorner.Parent = Slider
                
                sliderr.Name = "sliderr"
                sliderr.Parent = Slider
                sliderr.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                sliderr.Position = UDim2.new(0, 3, 0, 1)
                sliderr.Size = UDim2.new(0, 436, 0, 49)
                
                sliderrcorner.CornerRadius = UDim.new(0, 5)
                sliderrcorner.Name = "sliderrcorner"
                sliderrcorner.Parent = sliderr
                
                SliderLabel.Name = "SliderLabel"
                SliderLabel.Parent = sliderr
                SliderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderLabel.BackgroundTransparency = 1.000
                SliderLabel.Position = UDim2.new(0, 7, 0, 0)
                SliderLabel.Size = UDim2.new(0, 180, 0, 26)
                SliderLabel.Font = Enum.Font.GothamSemibold
                SliderLabel.Text = text
                SliderLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
                SliderLabel.TextSize = 16.000
                SliderLabel.TextTransparency = 0
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                HAHA.Name = "HAHA"
                HAHA.Parent = sliderr
                HAHA.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                HAHA.BackgroundTransparency = 1.000
                HAHA.Size = UDim2.new(0, 468, 0, 29)
                
                AHEHE.Name = "AHEHE"
                AHEHE.Parent = sliderr
                AHEHE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                AHEHE.BackgroundTransparency = 1.000
                AHEHE.Position = UDim2.new(0, 10, 0, 35)
                AHEHE.Size = UDim2.new(0, 448, 0, 5)
                AHEHE.Font = Enum.Font.SourceSans
                AHEHE.Text = ""
                AHEHE.TextColor3 = Color3.fromRGB(0, 0, 0)
                AHEHE.TextSize = 14.000
                
                bar.Name = "bar"
                bar.Parent = AHEHE
                bar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                bar.Size = UDim2.new(0, 417, 0, 5)
                
                bar1.Name = "bar1"
                bar1.Parent = bar
                bar1.BackgroundColor3 = _G.Color
                bar1.BackgroundTransparency = 0
                bar1.Size = UDim2.new(0, 0, 0, 5)
                
                bar1corner.CornerRadius = UDim.new(0, 5)
                bar1corner.Name = "bar1corner"
                bar1corner.Parent = bar1
                
                barcorner.CornerRadius = UDim.new(0, 5)
                barcorner.Name = "barcorner"
                barcorner.Parent = bar
                
                circlebar.Name = "circlebar"
                circlebar.Parent = bar1
                circlebar.BackgroundColor3 = Color3.fromRGB(225, 225, 225)
                circlebar.Position = UDim2.new(1, -2, 0, -3)
                circlebar.Size = UDim2.new(0, 10, 0, 10)
                
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = circlebar
                
                slidervalue.Name = "slidervalue"
                slidervalue.Parent = sliderr
                slidervalue.BackgroundColor3 = _G.Color
                slidervalue.BackgroundTransparency = 0
                slidervalue.Position = UDim2.new(0, 362, 0, 5)
                slidervalue.Size = UDim2.new(0, 65, 0, 18)
                
                
                valuecorner.CornerRadius = UDim.new(0, 5)
                valuecorner.Name = "valuecorner"
                valuecorner.Parent = slidervalue
                
                TextBox.Parent = slidervalue
                TextBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                TextBox.Position = UDim2.new(0, 1, 0, 1)
                TextBox.Size = UDim2.new(0, 63, 0, 16)
                TextBox.Font = Enum.Font.GothamSemibold
                TextBox.TextColor3 = Color3.fromRGB(225, 225, 225)
                TextBox.TextSize = 9.000
                TextBox.Text = set
                TextBox.TextTransparency = 0
                
                UICorner_2.CornerRadius = UDim.new(0, 5)
                UICorner_2.Parent = TextBox
                
                local mouse = game.Players.LocalPlayer:GetMouse()
                local uis = game:GetService("UserInputService")
                
                if Value == nil then
                    Value = set
                    pcall(function()
                        callback(Value)
                    end)
                end
                
                AHEHE.MouseButton1Down:Connect(function()
                    slidervalue.BackgroundColor3 = Color3.fromRGB(42, 235, 68)
                    Slider.BackgroundColor3 = Color3.fromRGB(42, 235, 68)
                    Value = math.floor((((tonumber(max) - tonumber(min)) / 410) * bar1.AbsoluteSize.X) + tonumber(min)) or 0
                    pcall(function()
                        callback(Value)
                    end)
                    TweenService:Create(
                        bar1,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 410), 0, 5)}-- UDim2.new(0, 128, 0, 25)
                    ):Play()
                    --bar1.Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 448), 0, 5)
                    TweenService:Create(
                        circlebar,
                        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 410), 0, -3)}-- UDim2.new(0, 128, 0, 25)
                    ):Play()
                    --circlebar.Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 438), 0, -3)
                    moveconnection = mouse.Move:Connect(function()
                        TextBox.Text = Value
                        Value = math.floor((((tonumber(max) - tonumber(min)) / 410) * bar1.AbsoluteSize.X) + tonumber(min))
                        pcall(function()
                            callback(Value)
                        end)
                        TweenService:Create(
                            bar1,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 410), 0, 5)}-- UDim2.new(0, 128, 0, 25)
                        ):Play()
                        --bar1.Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 448), 0, 5)
                        TweenService:Create(
                            circlebar,
                            TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 410), 0, -3)}-- UDim2.new(0, 128, 0, 25)
                        ):Play()
                    --circlebar.Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 438), 0, -3)
                    end)
                    releaseconnection = uis.InputEnded:Connect(function(Mouse)
                        Slider.BackgroundColor3 = _G.Color
                        slidervalue.BackgroundColor3 = _G.Color
                        if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                            Value = math.floor((((tonumber(max) - tonumber(min)) / 410) * bar1.AbsoluteSize.X) + tonumber(min))
                            pcall(function()
                                callback(Value)
                            end)
                            TweenService:Create(
                                bar1,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 410), 0, 5)}-- UDim2.new(0, 128, 0, 25)
                            ):Play()
                            --bar1.Size = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X, 0, 448), 0, 5)
                            TweenService:Create(
                                circlebar,
                                TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                                {Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 410), 0, -3)}-- UDim2.new(0, 128, 0, 25)
                            ):Play()
                            --circlebar.Position = UDim2.new(0, math.clamp(mouse.X - bar1.AbsolutePosition.X - 2, 0, 438), 0, -3)
                            moveconnection:Disconnect()
                            releaseconnection:Disconnect()
                        end
                    end)
                end)
                releaseconnection = uis.InputEnded:Connect(function(Mouse)
                    if Mouse.UserInputType == Enum.UserInputType.MouseButton1 then
                        Value = math.floor((((tonumber(max) - tonumber(min)) / 410) * bar1.AbsoluteSize.X) + tonumber(min))
                        TextBox.Text = Value
                    end
                end)
                
                TextBox.FocusLost:Connect(function()
                    if tonumber(TextBox.Text) > max then
                        TextBox.Text = max
                    end
                    bar1.Size = UDim2.new((tonumber(TextBox.Text) or 0) / max, 0, 0, 5)
                    circlebar.Position = UDim2.new(1, -2, 0, -3)
                    TextBox.Text = tostring(TextBox.Text and math.floor((tonumber(TextBox.Text) / max) * (max - min) + min))
                    pcall(callback, tonumber(TextBox.Text))
                end)
            end
            
            function main:Textbox(text, text2, disappear, callback)
                local Textbox = Instance.new("Frame")
                local TextboxCorner = Instance.new("UICorner")
                local Textboxx = Instance.new("Frame")
                local TextboxxCorner = Instance.new("UICorner")
                local TextboxLabel = Instance.new("TextLabel")
                local txtbtn = Instance.new("TextButton")
                local RealTextbox = Instance.new("TextBox")
                local UICorner = Instance.new("UICorner")
                local textback = Instance.new("Frame")
                
                Textbox.Name = "Textbox"
                Textbox.Parent = MainFramePage
                Textbox.BackgroundColor3 = _G.Color
                Textbox.BackgroundTransparency = 0
                Textbox.Size = UDim2.new(0, 440, 0, 31)
                
                TextboxCorner.CornerRadius = UDim.new(0, 5)
                TextboxCorner.Name = "TextboxCorner"
                TextboxCorner.Parent = Textbox
                
                Textboxx.Name = "Textboxx"
                Textboxx.Parent = Textbox
                Textboxx.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Textboxx.Position = UDim2.new(0, 3, 0, 1)
                Textboxx.Size = UDim2.new(0, 434, 0, 29)
                
                TextboxxCorner.CornerRadius = UDim.new(0, 5)
                TextboxxCorner.Name = "TextboxxCorner"
                TextboxxCorner.Parent = Textboxx
                
                TextboxLabel.Name = "TextboxLabel"
                TextboxLabel.Parent = Textbox
                TextboxLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextboxLabel.BackgroundTransparency = 1.000
                TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
                TextboxLabel.Text = text
                TextboxLabel.Size = UDim2.new(0, 145, 0, 31)
                TextboxLabel.Font = Enum.Font.GothamSemibold
                TextboxLabel.TextColor3 = Color3.fromRGB(225, 225, 225)
                TextboxLabel.TextSize = 16.000
                TextboxLabel.TextTransparency = 0
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                
                txtbtn.Name = "txtbtn"
                txtbtn.Parent = Textbox
                txtbtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                txtbtn.BackgroundTransparency = 1.000
                txtbtn.Position = UDim2.new(0, 1, 0, 1)
                txtbtn.Size = UDim2.new(0, 468, 0, 29)
                txtbtn.Font = Enum.Font.SourceSans
                txtbtn.Text = ""
                txtbtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                txtbtn.TextSize = 14.000
                
                textback.Parent = Textbox
                textback.Name = "Textback"
                textback.Parent = Textbox
                textback.BackgroundColor3 = _G.Color
                textback.BackgroundTransparency = 0
                textback.Position = UDim2.new(0, 280, 0, 3)
                textback.Size = UDim2.new(0, 152, 0, 24)
                local textbackui = Instance.new("UICorner")
                textbackui.Parent = textback
                textbackui.CornerRadius = UDim.new(0, 5)
                
                RealTextbox.Name = "RealTextbox"
                RealTextbox.Parent = Textbox
                RealTextbox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                RealTextbox.BackgroundTransparency = 0
                RealTextbox.Position = UDim2.new(0, 281, 0, 5)
                RealTextbox.Size = UDim2.new(0, 150, 0, 20)
                RealTextbox.Font = Enum.Font.GothamSemibold
                RealTextbox.Text = text2
                RealTextbox.TextColor3 = Color3.fromRGB(225, 225, 225)
                RealTextbox.TextSize = 11.000
                RealTextbox.TextTransparency = 0
                RealTextbox:GetPropertyChangedSignal("Text"):Connect(function()
                    if RealTextbox.Text ~= "" then
                        textback.BackgroundColor3 = Color3.fromRGB(42, 235, 68)
                    else
                        textback.BackgroundColor3 = _G.Color
                    end
                end)
                
                RealTextbox.FocusLost:Connect(function()
                    callback(RealTextbox.Text)
                    if disappear then
                        RealTextbox.Text = ""
                    end
                end)
                
                UICorner.CornerRadius = UDim.new(0, 5)
                UICorner.Parent = RealTextbox
            
            end
            function main:Label(text)
                local LabelFrame = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                
                local Label = Instance.new("TextLabel")
                local LabelCorner1 = Instance.new("UICorner")
                local PaddingLabel = Instance.new("UIPadding")
                local labell = {}
                
                LabelFrame.Name = "Label"
                LabelFrame.Parent = MainFramePage
                LabelFrame.BackgroundColor3 = _G.Color
                LabelFrame.BackgroundTransparency = 0
                LabelFrame.Size = UDim2.new(0, 440, 0, 31)
                
                LabelCorner.CornerRadius = UDim.new(0, 5)
                LabelCorner.Name = "TextboxCorner"
                LabelCorner.Parent = LabelFrame
                
                Label.Name = "Label"
                Label.Parent = LabelFrame
                Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Label.BackgroundTransparency = 0
                Label.Size = UDim2.new(0, 434, 0, 27)
                Label.Font = Enum.Font.GothamSemibold
                Label.TextColor3 = Color3.fromRGB(225, 225, 225)
                Label.TextSize = 16.000
                Label.Text = text
                Label.TextXAlignment = Enum.TextXAlignment.Center
                Label.Position = UDim2.new(0, 3, 0, 2)
                LabelCorner1.CornerRadius = UDim.new(0, 5)
                LabelCorner1.Name = "TextboxCorner"
                LabelCorner1.Parent = Label
                
                PaddingLabel.PaddingLeft = UDim.new(0, 0)
                PaddingLabel.Parent = Label
                PaddingLabel.Name = "PaddingLabel"
                
                function labell:Set(newtext)
                    Label.Text = newtext
                end
                return labell
            end
            function main:LabelP(text)
                local LabelFrame = Instance.new("Frame")
                local LabelCorner = Instance.new("UICorner")
                
                local Label = Instance.new("TextLabel")
                local LabelCorner1 = Instance.new("UICorner")
                local PaddingLabel = Instance.new("UIPadding")
                local labell = {}
                
                LabelFrame.Name = "Label"
                LabelFrame.Parent = MainFramePage
                LabelFrame.BackgroundColor3 = _G.Color
                LabelFrame.BackgroundTransparency = 0
                LabelFrame.Size = UDim2.new(0, 440, 0, 31)
                
                LabelCorner.CornerRadius = UDim.new(0, 5)
                LabelCorner.Name = "TextboxCorner"
                LabelCorner.Parent = LabelFrame
                
                Label.Name = "Label"
                Label.Parent = LabelFrame
                Label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                Label.BackgroundTransparency = 0
                Label.Size = UDim2.new(0, 434, 0, 27)
                Label.Font = Enum.Font.GothamSemibold
                Label.TextColor3 = Color3.fromRGB(225, 225, 225)
                Label.TextSize = 15.000
                Label.Text = text
                Label.TextXAlignment = Enum.TextXAlignment.Left
                Label.Position = UDim2.new(0, 3, 0, 2)
                LabelCorner1.CornerRadius = UDim.new(0, 5)
                LabelCorner1.Name = "TextboxCorner"
                LabelCorner1.Parent = Label
                
                PaddingLabel.PaddingLeft = UDim.new(0, 0)
                PaddingLabel.Parent = Label
                PaddingLabel.Name = "PaddingLabel"
                
                function labell:Set(newtext)
                    Label.Text = newtext
                end
                return labell
            end
            function main:Seperator(text)
                local Seperator = Instance.new("Frame")
                local Sep1 = Instance.new("Frame")
                local Sep2 = Instance.new("TextLabel")
                local Sep3 = Instance.new("Frame")
                
                Seperator.Name = "Seperator"
                Seperator.Parent = MainFramePage
                Seperator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Seperator.BackgroundTransparency = 1.000
                Seperator.Size = UDim2.new(0, 470, 0, 20)
                
                Sep1.Name = "Sep1"
                Sep1.Parent = Seperator
                Sep1.BackgroundColor3 = _G.Color
                Sep1.BorderSizePixel = 0
                Sep1.Position = UDim2.new(0, 17, 0, 10)
                Sep1.Size = UDim2.new(0, 80, 0, 1)
                
                Sep2.Name = "Sep2"
                Sep2.Parent = Seperator
                Sep2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Sep2.BackgroundTransparency = 1.000
                Sep2.Position = UDim2.new(0, 185, 0, 0)
                Sep2.Size = UDim2.new(0, 100, 0, 20)
                Sep2.Font = Enum.Font.GothamSemibold
                Sep2.Text = text
                Sep2.TextColor3 = Color3.fromRGB(255, 255, 255)
                Sep2.TextSize = 14.000
                
                Sep3.Name = "Sep3"
                Sep3.Parent = Seperator
                Sep3.BackgroundColor3 = _G.Color
                Sep3.BorderSizePixel = 0
                Sep3.Position = UDim2.new(0, 373, 0, 10)
                Sep3.Size = UDim2.new(0, 80, 0, 1)
            end
            
            function main:Line()
                local Linee = Instance.new("Frame")
                local Line = Instance.new("Frame")
                
                Linee.Name = "Linee"
                Linee.Parent = MainFramePage
                Linee.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Linee.BackgroundTransparency = 1.000
                Linee.Position = UDim2.new(0, 0, 0.119999997, 0)
                Linee.Size = UDim2.new(0, 470, 0, 20)
                
                Line.Name = "Line"
                Line.Parent = Linee
                Line.BackgroundColor3 = _G.Color
                Line.BorderSizePixel = 0
                Line.Position = UDim2.new(0, 017, 0, 10)
                Line.Size = UDim2.new(0, 435, 0, 1)
            end
            return main
        end
        return uitab
    end
end

return library1
