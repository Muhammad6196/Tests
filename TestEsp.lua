local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ESP = {}
ESP.__index = ESP

if _G.ESP_LOADED then
    _G.ESP_LOADED:Destroy()
end
_G.ESP_LOADED = ESP

ESP.Settings = {
    Enabled = false,
    Box2D = false,
    Name = false,
    Distance = false,
    Box3D = false,
    Skeleton = false,
    ItemESP = false,
    Chams = false,
    ItemChams = false,
    ChamFillTransparency = 1,
    ChamOutlineTransparency = 0,

    NameSize = 16,
    DistanceSize = 14,

    Outline = true,
    OutlineColor = Color3.fromRGB(0, 0, 0),
    OutlineThickness = 6,

    Colors = {
        Default = Color3.fromRGB(255, 255, 255),
    },

    Teams = {
        Team = {
            Color = Color3.fromRGB(0, 150, 255),
            State = "Team"
        },
        Enemy = {
            Color = Color3.fromRGB(255, 0, 0),
            State = "Enemy"
        },
    }
}



ESP.Objects = {}
ESP.Chams = {}
ESP.ItemChams = {}
ESP.ItemObjects = {}
ESP.Connection = nil
ESP.ItemWatchConnection = nil

local skeletonParts = {
    {"Head","UpperTorso"},
    {"UpperTorso","LowerTorso"},

    {"UpperTorso","LeftUpperArm"},
    {"LeftUpperArm","LeftLowerArm"},
    {"LeftLowerArm","LeftHand"},

    {"UpperTorso","RightUpperArm"},
    {"RightUpperArm","RightLowerArm"},
    {"RightLowerArm","RightHand"},

    {"LowerTorso","LeftUpperLeg"},
    {"LeftUpperLeg","LeftLowerLeg"},
    {"LeftLowerLeg","LeftFoot"},

    {"LowerTorso","RightUpperLeg"},
    {"RightUpperLeg","RightLowerLeg"},
    {"RightLowerLeg","RightFoot"},
}

local skeletonPartsR6 = {
    {"Head","Torso"},
    {"Torso","Left Arm"},
    {"Left Arm","LeftHand"},
    {"Torso","Right Arm"},
    {"Right Arm","RightHand"},
    {"Torso","Left Leg"},
    {"Left Leg","LeftFoot"},
    {"Torso","Right Leg"},
    {"Right Leg","RightFoot"},
}

local function getRootPart(char)
    return char and (char:FindFirstChild("HumanoidRootPart")
        or char:FindFirstChild("Torso")
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("LowerTorso"))
end

local function getRigType(char)
    local humanoid = char and char:FindFirstChild("Humanoid")
    return humanoid and humanoid.RigType or nil
end

local function createOutlineText(original)
    local outline = Drawing.new("Text")
    outline.Center = original.Center
    outline.Outline = true
    outline.Size = original.Size
    outline.ZIndex = (original.ZIndex or 1) - 1
    return outline
end


local function createOutlineBox(original)
    local outline = Drawing.new("Square")
    outline.Thickness = ESP.Settings.OutlineThickness
    outline.Filled = false
    outline.ZIndex = (original.ZIndex or 1) - 1
    return outline
end

function ESP:Create(player)
    local drawings = {
        Character = nil,

        Box = Drawing.new("Square"),
        BoxOutline = nil,
        Name = Drawing.new("Text"),
        NameOutline = nil,
        Distance = Drawing.new("Text"),
        DistanceOutline = nil,

        Box3D = {},
        Skeleton = {}
    }

    drawings.Box.Thickness = 1
    drawings.Box.Filled = false
    
    if ESP.Settings.Outline then
        drawings.BoxOutline = createOutlineBox(drawings.Box)
    end

    drawings.Name.Center = true
    drawings.Name.Outline = true
    drawings.Name.Size = self.Settings.NameSize
    
    if ESP.Settings.Outline then
        drawings.NameOutline = createOutlineText(drawings.Name)
        drawings.NameOutline.Color = ESP.Settings.OutlineColor
    end

    drawings.Distance.Size = self.Settings.DistanceSize
    drawings.Distance.Center = true
    drawings.Distance.Outline = true
    
    if ESP.Settings.Outline then
        drawings.DistanceOutline = createOutlineText(drawings.Distance)
        drawings.DistanceOutline.Color = ESP.Settings.OutlineColor
    end

    for i = 1, 12 do
        local line = Drawing.new("Line")
        line.Thickness = 1
        drawings.Box3D[i] = line
    end

    for i = 1, #skeletonParts do
        local line = Drawing.new("Line")
        line.Thickness = 1
        drawings.Skeleton[i] = line
    end

    local function setChar(char)
        drawings.Character = char
    end

    if player.Character then
        setChar(player.Character)
    end

    player.CharacterAdded:Connect(function(char)
        setChar(char)
    end)
    
    self.Objects[player] = drawings
end

function ESP:Remove(player)
    local drawings = self.Objects[player]
    if self.Chams[player] then
        self.Chams[player]:Destroy()
        self.Chams[player] = nil
    end
    if drawings then
        if drawings.Box then drawings.Box:Remove() end
        if drawings.BoxOutline then drawings.BoxOutline:Remove() end
        if drawings.Name then drawings.Name:Remove() end
        if drawings.NameOutline then drawings.NameOutline:Remove() end
        if drawings.Distance then drawings.Distance:Remove() end
        if drawings.DistanceOutline then drawings.DistanceOutline:Remove() end
        
        for _, l in pairs(drawings.Box3D) do if l then l:Remove() end end
        for _, l in pairs(drawings.Skeleton) do if l then l:Remove() end end
        
        self.Objects[player] = nil
    end
end

function ESP:CreateItem(item, itemType)
    if self.ItemObjects[item] then
        self:RemoveItem(item)
    end
    
    local d = {
        Object = item,
        Type = itemType,
        Name = Drawing.new("Text"),
        NameOutline = nil,
        Distance = Drawing.new("Text"),
        DistanceOutline = nil
    }

    d.Name.Center = true
    d.Name.Outline = true
    d.Name.Size = self.Settings.NameSize
    d.Name.Visible = false
    
    if ESP.Settings.Outline then
        d.NameOutline = createOutlineText(d.Name)
        d.NameOutline.Color = ESP.Settings.OutlineColor
        d.NameOutline.Visible = false
    end

    d.Distance.Center = true
    d.Distance.Outline = true
    d.Distance.Size = self.Settings.DistanceSize
    d.Distance.Visible = false
    
    if ESP.Settings.Outline then
        d.DistanceOutline = createOutlineText(d.Distance)
        d.DistanceOutline.Color = ESP.Settings.OutlineColor
        d.DistanceOutline.Visible = false
    end

    self.ItemObjects[item] = d
end

function ESP:AddItem(item)
    if self.ItemObjects[item] then return end

   local t = "Default"
    local customColor = nil

    if ESP.ItemLogic then
        local a, b = ESP.ItemLogic(item)

        if a == false then return end

        if typeof(a) == "string" then
            t = a
        end

        if typeof(b) == "Color3" then
            customColor = b
        end
    end

    self:CreateItem(item, t)
    self:CreateItemCham(item)
    if customColor then
        self.ItemObjects[item].CustomColor = customColor
    end
end

function ESP:RemoveItem(item)
    local d = self.ItemObjects[item]
    if self.ItemChams[item] then
        self.ItemChams[item]:Destroy()
        self.ItemChams[item] = nil
    end
    if d then
        if d.Name then d.Name:Remove() end
        if d.NameOutline then d.NameOutline:Remove() end
        if d.Distance then d.Distance:Remove() end
        if d.DistanceOutline then d.DistanceOutline:Remove() end
        self.ItemObjects[item] = nil
    end
end

function ESP:WatchItems(func)
    if self.ItemWatchConnection then
        self.ItemWatchConnection:Disconnect()
    end
    
    self.ItemWatchConnection = game:GetService("RunService").Stepped:Connect(function()
        if not ESP.Settings.ItemESP then
            for item in pairs(self.ItemObjects) do
                self:RemoveItem(item)
            end
            return
        end
        
        local items = {}
        local ok, res = pcall(func)
        if ok and typeof(res) == "table" then 
            items = res 
        end
        
        -- Track current items
        local currentItems = {}
        for _, it in ipairs(items) do
            currentItems[it] = true
        end
        
        -- Add new items
        for _, it in ipairs(items) do
            if not self.ItemObjects[it] then
                self:AddItem(it)
            end
        end
        
        -- CRITICAL FIX: Check existing items for state changes
        for item, drawings in pairs(self.ItemObjects) do
            -- If item no longer exists in world
            if not currentItems[item] then
                self:RemoveItem(item)
            else
                -- Re-check if item should still be visible
                local shouldShow = pcall(function()
                    local result = ESP.ItemLogic(item)
                    return result ~= false
                end)
                
                if not shouldShow or not ESP.ItemLogic(item) then
                    -- Item should be hidden now (like inserted fusebox)
                    self:RemoveItem(item)
                end
            end
        end
    end)
end

function ESP:CreateCham(player, char, color)
    if not self.Settings.Chams then return end
    if not char then return end

    if self.Chams[player] then
        self.Chams[player]:Destroy()
        self.Chams[player] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPCham"
    highlight.Adornee = char
    highlight.FillTransparency = ESP.Settings.ChamFillTransparency
    highlight.OutlineTransparency = ESP.Settings.ChamOutlineTransparency
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Enabled = true
    
    highlight.Parent = game.CoreGui
    self.Chams[player] = highlight
end

function ESP:CreateItemCham(item)
    if not self.Settings.ItemChams then return end
    if not item or not item.Parent then return end

    if self.ItemChams[item] then
        self.ItemChams[item]:Destroy()
        self.ItemChams[item] = nil
    end

    local highlight = Instance.new("Highlight")
    highlight.Name = "ItemCham"
    highlight.Adornee = item
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.FillColor = ESP.Settings.Colors.Default
    highlight.OutlineColor = ESP.Settings.Colors.Default
    
    highlight.Parent = game.CoreGui
    self.ItemChams[item] = highlight
end

function ESP:Destroy()
    if self.Connection then
        self.Connection:Disconnect()
        self.Connection = nil
    end
    
    if self.ItemWatchConnection then
        self.ItemWatchConnection:Disconnect()
        self.ItemWatchConnection = nil
    end

    for _, drawings in pairs(self.Objects) do
        if drawings.Box then drawings.Box:Remove() end
        if drawings.BoxOutline then drawings.BoxOutline:Remove() end
        if drawings.Name then drawings.Name:Remove() end
        if drawings.NameOutline then drawings.NameOutline:Remove() end
        if drawings.Distance then drawings.Distance:Remove() end
        if drawings.DistanceOutline then drawings.DistanceOutline:Remove() end
        for _, l in pairs(drawings.Box3D) do if l then l:Remove() end end
        for _, l in pairs(drawings.Skeleton) do if l then l:Remove() end end
    end
    
    for _, d in pairs(self.ItemObjects) do
        if d.Name then d.Name:Remove() end
        if d.NameOutline then d.NameOutline:Remove() end
        if d.Distance then d.Distance:Remove() end
        if d.DistanceOutline then d.DistanceOutline:Remove() end
    end

    for _, cham in pairs(self.Chams) do
        if cham then cham:Destroy() end
    end
    
    for _, cham in pairs(self.ItemChams) do
        if cham then cham:Destroy() end
    end

    self.Objects = {}
    self.ItemObjects = {}
    self.Chams = {}
    self.ItemChams = {}
end

function ESP:Init()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            self:Create(player)
        end
    end

    Players.PlayerAdded:Connect(function(player)
        if player ~= Players.LocalPlayer then
            self:Create(player)
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        self:Remove(player)
    end)
end

local function Hide(drawings)
    if not drawings then return end

    if drawings.Box then
        drawings.Box.Visible = false
    end

    if drawings.BoxOutline then
        drawings.BoxOutline.Visible = false
    end

    if drawings.Name then
        drawings.Name.Visible = false
    end

    if drawings.NameOutline then
        drawings.NameOutline.Visible = false
    end

    if drawings.Distance then
        drawings.Distance.Visible = false
    end

    if drawings.DistanceOutline then
        drawings.DistanceOutline.Visible = false
    end

    if drawings.Box3D then
        for _, line in pairs(drawings.Box3D) do
            if line then
                line.Visible = false
            end
        end
    end

    if drawings.Skeleton then
        for _, line in pairs(drawings.Skeleton) do
            if line then
                line.Visible = false
            end
        end
    end
end

local edges = {
    {1,2},{2,4},{4,3},{3,1},
    {5,6},{6,8},{8,7},{7,5},
    {1,5},{2,6},{3,7},{4,8}
}

ESP.Connection = RunService.RenderStepped:Connect(function()
    if not ESP.Settings.Enabled then return end

    local viewportX = Camera.ViewportSize.X
    local viewportY = Camera.ViewportSize.Y

    for player,d in pairs(ESP.Objects) do
        local char = d.Character
        local hrp = getRootPart(char)

        if not char or not hrp or not char.Parent then
            Hide(d) 
            continue
        end

        local state = ESP.Logic and ESP.Logic(player)

        local cham = ESP.Chams[player]
        
        local color

        local visible = state and true or false

        if visible then
            color = ESP.Settings.Teams[state] and ESP.Settings.Teams[state].Color or ESP.Settings.Colors.Default
        end

        if color and visible then
            ESP:CreateCham(player, char, color)
        end
        if cham then
            if not state then
                cham.Enabled = false
                cham.FillTransparency = 1
                cham.OutlineTransparency = 1
            else
                
                cham.Enabled = ESP.Settings.Chams
                cham.FillTransparency = ESP.Settings.ChamFillTransparency
                cham.OutlineTransparency = ESP.Settings.ChamOutlineTransparency
                cham.FillColor = color
                cham.OutlineColor = color
            end
        end
        
        if not visible then
            Hide(d)
            continue
        end
        
        if d.Box then d.Box.Color = color end
        if d.Name then d.Name.Color = color end
        if d.Distance then d.Distance.Color = color end
        
        if d.BoxOutline then d.BoxOutline.Color = ESP.Settings.OutlineColor end
        if d.NameOutline then d.NameOutline.Color = ESP.Settings.OutlineColor end
        if d.DistanceOutline then d.DistanceOutline.Color = ESP.Settings.OutlineColor end
        
        for _,l in pairs(d.Box3D) do if l then l.Color = color end end
        for _,l in pairs(d.Skeleton) do if l then l.Color = color end end

        local pos, isOnScreen = Camera:WorldToViewportPoint(hrp.Position)
        
        local onScreen = isOnScreen and pos.X >= 0 and pos.X <= viewportX and pos.Y >= 0 and pos.Y <= viewportY and pos.Z > 0
        
        local dist = (Camera.CFrame.Position - hrp.Position).Magnitude

        
        if not onScreen then 
            Hide(d) 
            continue 
        end

        local scale = 1/(dist/100)
        local size2D = Vector2.new(35,50)*scale

        if d.Box then
            d.Box.Size = size2D
            d.Box.Position = Vector2.new(pos.X-size2D.X/2,pos.Y-size2D.Y/2)
            d.Box.Visible = ESP.Settings.Box2D
        end
        
        if d.BoxOutline and ESP.Settings.Box2D then
            d.BoxOutline.Size = size2D
            d.BoxOutline.Position = Vector2.new(pos.X-size2D.X/2,pos.Y-size2D.Y/2)
            d.BoxOutline.Visible = ESP.Settings.Outline
        elseif d.BoxOutline then
            d.BoxOutline.Visible = false
        end

        if d.Name then
            d.Name.Text = player.Name
            d.Name.Position = Vector2.new(pos.X,pos.Y-size2D.Y/2-24)
            d.Name.Visible = ESP.Settings.Name
        end
        
        if d.NameOutline and ESP.Settings.Name then
            d.NameOutline.Text = player.Name
            d.NameOutline.Position = Vector2.new(pos.X,pos.Y-size2D.Y/2-24)
            d.NameOutline.Visible = ESP.Settings.Outline
        elseif d.NameOutline then
            d.NameOutline.Visible = false
        end

        if d.Distance then
            d.Distance.Text = math.floor(dist).."m"
            d.Distance.Position = Vector2.new(pos.X,pos.Y+size2D.Y/2)
            d.Distance.Visible = ESP.Settings.Distance
        end
        
        if d.DistanceOutline and ESP.Settings.Distance then
            d.DistanceOutline.Text = math.floor(dist).."m"
            d.DistanceOutline.Position = Vector2.new(pos.X,pos.Y+size2D.Y/2)
            d.DistanceOutline.Visible = ESP.Settings.Outline
        elseif d.DistanceOutline then
            d.DistanceOutline.Visible = false
        end

        if ESP.Settings.Box3D then
            local cf,size = char:GetBoundingBox()
            local corners = {
                Vector3.new(-size.X,-size.Y,-size.Z),
                Vector3.new(-size.X,-size.Y,size.Z),
                Vector3.new(-size.X,size.Y,-size.Z),
                Vector3.new(-size.X,size.Y,size.Z),
                Vector3.new(size.X,-size.Y,-size.Z),
                Vector3.new(size.X,-size.Y,size.Z),
                Vector3.new(size.X,size.Y,-size.Z),
                Vector3.new(size.X,size.Y,size.Z),
            }

            local points={}
            for i,c in ipairs(corners) do
                local world = cf:PointToWorldSpace(c/2)
                local s,v = Camera:WorldToViewportPoint(world)
                points[i]={s,v}
            end

            for i,e in ipairs(edges) do
                local p1,p2 = points[e[1]],points[e[2]]
                local line = d.Box3D[i]

                if line and p1[2] and p2[2] and p1[1].Z > 0 and p2[1].Z > 0 then
                    line.From = Vector2.new(p1[1].X,p1[1].Y)
                    line.To = Vector2.new(p2[1].X,p2[1].Y)
                    line.Visible = true
                elseif line then
                    line.Visible = false
                end
            end
        else
            for _,l in pairs(d.Box3D) do if l then l.Visible = false end end
        end

        if ESP.Settings.Skeleton then
            local rig = getRigType(char)
            local pairsList = rig==Enum.HumanoidRigType.R6 and skeletonPartsR6 or skeletonParts

            for i,pair in ipairs(pairsList) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])
                local line = d.Skeleton[i]

                if line and p1 and p2 then
                    local a,va = Camera:WorldToViewportPoint(p1.Position)
                    local b,vb = Camera:WorldToViewportPoint(p2.Position)

                    if va and vb and a.Z > 0 and b.Z > 0 then
                        line.From = Vector2.new(a.X,a.Y)
                        line.To = Vector2.new(b.X,b.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                elseif line then
                    line.Visible = false
                end
            end
        else
            for _,l in pairs(d.Skeleton) do if l then l.Visible = false end end
        end
    end

    for item,d in pairs(ESP.ItemObjects) do
        if not ESP.Settings.ItemESP then
            if d.Name then d.Name.Visible = false end
            if d.NameOutline then d.NameOutline.Visible = false end
            if d.Distance then d.Distance.Visible = false end
            if d.DistanceOutline then d.DistanceOutline.Visible = false end
            
            local cham = ESP.ItemChams[item]
            if cham then cham.Enabled = false end
            continue
        end

        local pos3D
        if item:IsA("BasePart") then
            pos3D = item.Position
        elseif item:IsA("Model") then
            local primary = item.PrimaryPart
            if primary then
                pos3D = primary.Position
            else
                local parts = item:GetChildren()
                local anyPart = nil
                for _, child in ipairs(parts) do
                    if child:IsA("BasePart") then
                        anyPart = child
                        break
                    end
                end
                if anyPart then
                    pos3D = anyPart.Position
                else
                    if d.Name then d.Name.Visible = false end
                    if d.NameOutline then d.NameOutline.Visible = false end
                    if d.Distance then d.Distance.Visible = false end
                    if d.DistanceOutline then d.DistanceOutline.Visible = false end
                    continue
                end
            end
        else
            if d.Name then d.Name.Visible = false end
            if d.NameOutline then d.NameOutline.Visible = false end
            if d.Distance then d.Distance.Visible = false end
            if d.DistanceOutline then d.DistanceOutline.Visible = false end
            continue
        end
        
        local pos, isOnScreen = Camera:WorldToViewportPoint(pos3D)
        
        local onScreen = isOnScreen and pos.X >= 0 and pos.X <= viewportX and pos.Y >= 0 and pos.Y <= viewportY and pos.Z > 0
        
        local dist = (Camera.CFrame.Position - pos3D).Magnitude

        
        if onScreen then
            local label = d.Type
            local color = d.CustomColor or ESP.Settings.Colors[d.Type] or ESP.Settings.Colors.Default

            if ESP.ItemLogic then
                local a, b = ESP.ItemLogic(item)

                if a ~= false then
                    if typeof(a) == "string" then
                        label = a
                    end

                    if typeof(b) == "Color3" then
                        color = b
                    end
                end
            end

            local cham = ESP.ItemChams[item]
            if cham then
                cham.Enabled = ESP.Settings.ItemChams
                cham.FillColor = color
                cham.OutlineColor = color
            end
            
            if d.Name then
                d.Name.Text = label
                d.Name.Position = Vector2.new(pos.X, pos.Y - 10)
                d.Name.Color = color
                d.Name.Visible = ESP.Settings.Name
            end
            
            if d.NameOutline and ESP.Settings.Name then
                d.NameOutline.Text = label
                d.NameOutline.Position = Vector2.new(pos.X, pos.Y - 10)
                d.NameOutline.Color = ESP.Settings.OutlineColor
                d.NameOutline.Visible = ESP.Settings.Outline
            end

            if d.Distance then
                d.Distance.Text = math.floor(dist).."m"
                d.Distance.Position = Vector2.new(pos.X, pos.Y + 5)
                d.Distance.Color = color
                d.Distance.Visible = ESP.Settings.Distance
            end
            
            if d.DistanceOutline and ESP.Settings.Distance then
                d.DistanceOutline.Text = math.floor(dist).."m"
                d.DistanceOutline.Position = Vector2.new(pos.X, pos.Y + 5)
                d.DistanceOutline.Color = ESP.Settings.OutlineColor
                d.DistanceOutline.Visible = ESP.Settings.Outline
            end
        else
            if d.Name then d.Name.Visible = false end
            if d.NameOutline then d.NameOutline.Visible = false end
            if d.Distance then d.Distance.Visible = false end
            if d.DistanceOutline then d.DistanceOutline.Visible = false end
            
            local cham = ESP.ItemChams[item]
            if cham then cham.Enabled = false end
        end
    end
end)

return ESP
