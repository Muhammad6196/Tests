local updateinv = getsenv(game:GetService("Players").LocalPlayer.PlayerScripts.Scripts.GUIs.Inventory)
    hookfunction(updateinv.isVisible, function()
        return true
    end)
    updateinv.Update()
