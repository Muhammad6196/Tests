local netmod = getsenv(game:GetService("ReplicatedStorage").Framework.Client["2 | Network"])
    for i,v in pairs(getgc(true)) do
        if type(v) == "function" and getfenv(v).script == game:GetService("ReplicatedStorage").Framework.Client["2 | Network"] then
            if table.find(getconstants(v), "settings") then
                local Hook = hookfunction(v, function(...)
                    return true
                end)
            end
        end
    end
