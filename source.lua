



getgenv().settings = {
    TeamCheck = true,
    CheckIfDead = true,
    HighlightColor = Color3.fromRGB(255, 255, 255),
    NotifyTarget = true
}

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "ℹ️ RAYCAST SILENT AIM V2",
    Text = "Loading Silent Aim please wait!"
})

for i,v in next, getgenv().settings do print(i,v) end

-- SETTINGS

function returnclp()
    local player = game.Players.LocalPlayer
    local maxdis = math.huge
    local opp

    for _, v in ipairs(game.Players:GetChildren()) do
        local teamCheck = not getgenv().settings.TeamCheck or (v.Team ~= player.Team)
        local deadCheck = not getgenv().settings.CheckIfDead or (v.Character and v.Character.Humanoid.Health > 0)

        if teamCheck and deadCheck then
            local hrp = player.Character:WaitForChild("HumanoidRootPart").Position
            local mag = (hrp - v.Character.HumanoidRootPart.Position).Magnitude

            if mag < maxdis then
                opp = v
                maxdis = mag
            end
        end
    end
    return opp
end

local char = returnclp()
game:GetService("RunService").RenderStepped:Connect(function()
   
    char = returnclp()
        local hi = Instance.new("Highlight", char.Character)
        hi.FillColor = getgenv().settings.HighlightColor
        hi.OutlineColor = getgenv().settings.HighlightColor
        if getgenv().settings.NotifyTarget then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "ℹ️ TARGET NOTIFIER!",
                Text = "Current target is: " .. char.Name
            })
        end
        game.Debris:AddItem(hi, 0.1)
end)

-- TARGETTING

local hi;

hi = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local args = {...}
    local method = getnamecallmethod():lower()

    if tostring(method) == "raycast" then
        args[2] = (char.Character.HumanoidRootPart.Position - args[1]).Unit * 1000
        return hi(Self, unpack(args))
    end
    return hi(Self, ...)
end))

-- HOOKING

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ RAYCAST SILENT AIM V2",
    Text = "Silent aim succesfully loaded!"
})
