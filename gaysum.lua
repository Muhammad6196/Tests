
local updateinv = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs.Inventory)
    hookfunction(updateinv.isVisible, function()
        return true
    end)
    updateinv.Update()

local cmod = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.Game.Lootbags)
    hookfunction(cmod.ScanForCollection, function(...)
        for i,v in pairs(game:GetService("Workspace")["__THINGS"].Lootbags:GetChildren()) do
            v:SetAttribute("Collected")
            cmod.Collect(v)
        end
    end)
