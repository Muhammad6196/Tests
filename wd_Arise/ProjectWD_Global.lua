if not game.Loaded then
    game.Loaded:wait()
end

local Global = getgenv() and getgenv()
Global.player = Players.LocalPlayer
Global.players = game.Players
Global.idled = Player.Idled
Global.wait = task.wait
Global.spawn = task.spawn
Global.gameid = game.GameId
Global.character = player.Character or player.CharacterAdded:Wait()
Global.dev = "W41K3R"
Global.HUB = "Project WD"
Global.WD = {}
Global.allplayers = {}
Global.pr = print
Global.rq = require
Global.gs = getsenv


WD.IsA = function(parent, Instance)
    return parent:FindFirstChildWhichIsA(target)
end

WD.GetHumanoid = function()
    return WD.IsA(player, "Humanoid")
end

WD.GetChar = function()
    return player.Character
end

WD.GetRoot = function()
    return Player.Character.PrimaryPart
end

WD.GetChar = function()
    return player and Player.Character
end

WD.Mag = function(pos1, pos2)
    return (pos1-pos2).magnitude
end

WD.GetNearestPlayer = function()
    local target = nil
    local distance = math.huge
    for i,v in pairs(players:GetChildren()) do
        if v.Character ~= nil and v ~= player then
            local mag = WD.Mag(v.Character:GetModelCFrame().Position , WD.GetChar():GetModelCFrame().Position)
            if mag < distance then
                target = v
                distance = mag
            end
        end
    end
    return target
end

WD.Teleport = function(target)
    player.Character:PivotTo(CFrame.new(target))
end

WD.DisableConnection = function(Signal)
    if not getconnections then
        print("Get Better Exploit XD")
    else
        for i,v in next, getconnections(Signal) do
            v:Disable()
        end
    end
end
