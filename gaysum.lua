    local network = require(game:GetService("ReplicatedStorage").Framework.Client["2 | Network"])

    e = getupvalues(network.Invoke)[2]
    f = getupvalues(network.Invoke)[3]
    g = getupvalues(network.Fire)[2]
    h = getupvalues(network.Fire)[3]
    local cap = hookfunction(network.Invoke, function(a, ...)
        local c = e(a);
        if c then
            return c:InvokeServer(...);
        end
        return f(a):Invoke(...);
    end)
    local tap = hookfunction(network.Fire, function(a, ...)
        local c = g(a);
        if c then
            return c:FireServer(...);
        end
        return h(a):Fire(...);
    end)

local updateinv = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs.Inventory)
    local pica = hookfunction(updateinv.isVisible, function()
        return true
    end)
    updateinv.Update()

local cmod = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Lootbags)
    
    local function lootsike()
         for i,v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do
            v:SetAttribute("Collected")
            cmod.Collect(v)
        end
    end
    cmod.ScanForCollection = lootsike
