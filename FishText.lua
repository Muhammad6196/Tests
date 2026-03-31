task.spawn(function()
            local replicatedStorage = game:GetService("ReplicatedStorage");
            local collectionService = game:GetService("CollectionService");
            local localPlayer = game.Players.LocalPlayer;
            local client = require(localPlayer.PlayerScripts.Client);
            local fishingRod = require(replicatedStorage.Tools["Fishing Rod"]);
            local fishingAtLocation = fishingRod.StartFishingAtLocation;
            
            local function getClosestWater(instance)
                local dist, nearest = math.huge;
                for _,v in next, collectionService:GetTagged("Water") do
                    local distance = (v.Position - instance.Position).Magnitude;
                    if distance <= dist then
                        dist, nearest = distance, v;
                    end
                end;
                return nearest
            end

            local fishingRod = require(game:GetService("ReplicatedStorage").Tools["Fishing Rod"])
            local getconstants = getconstants

            local reel; reel = hookfunction(fishingRod.Reel, function(...)
                if getgenv().config.AutoFishing.enabled and table.find(getconstants(debug.info(3, "f")), "too far") then
                    return
                end
                return reel(...)
            end)

            local originalGetProjectileHit = client.CollisionUtility.GetProjectileHit

            client.CollisionUtility.GetProjectileHit = function(self, ...)
                if getgenv().config.AutoFishing.enabled then
                    for _, v in next, collectionService:GetTagged("FishHotspot") do
                        if v and v:GetAttribute("Active") == true and v.Position.Y > -10 and v.Position.Y < 10 then
                            local water = getClosestWater(v)
                            if water then
                                return {
                                    Instance = water,
                                    Position = v.Position
                                }
                            end
                        end
                    end
                    local nearest, dist = nil, math.huge
                    local root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")

                    for _, v in next, collectionService:GetTagged("Water") do
                        if v and root and v.Position.Y > -10 and v.Position.Y < 10 then
                            local d = (v.Position - root.Position).Magnitude
                            if d < dist then
                                dist = d
                                nearest = v
                            end
                        end
                    end

                    if nearest then
                        print("Fallback water:", nearest.Position)

                        return {
                            Instance = nearest,
                            Position = nearest.Position
                        }
                    end
                end

                return originalGetProjectileHit(self, ...)
            end
            
            local confirmevent = require(game.Players.LocalPlayer.PlayerScripts.Client)
            
            local pull = fishingRod.Pull
            fishingRod.Pull = function(self, ...)
                if getgenv().config.AutoFishing.enabled then
                    self.AlreadyClickedThisPass = false
                    self.CatchProgress = self.CatchProgress * self.CatchGoal
                    self.ItemCaught = true
                    confirmevent.Events.ConfirmCatchItem:FireServer()
                    self:Reel()
                    return
                end

                return pull(self, ...)
            end

            local flute = require(game:GetService("ReplicatedStorage").Tools["Taming Flute"])
            local flutefunc = flute.StartTamingMinigame

            setfenv(flutefunc, setmetatable({
                math = setmetatable({
                    clamp = function(x, min, max)
                        if min == 0 and max == 1 then
                            task.wait()
                            return 1
                        end
                        return math.clamp(x, min, max)
                    end
                }, {__index = math})
            }, {__index = getfenv(flutefunc)}))
        end)

        local vu = game:GetService("VirtualUser")
        game:GetService("Players").LocalPlayer.Idled:connect(function()
            vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
            wait(1)
            vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        end)
        
        local ProximityPromptService = game:GetService("ProximityPromptService")
        ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt, player)
            fireproximityprompt(prompt)
        end)
