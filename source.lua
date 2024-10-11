-- CREDITS TO GLOBE!

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

for i, v in next, getgenv().settings do print(i, v) end

-- SETTINGS

function returnclp()
    local player = game:GetService("Players").LocalPlayer
    local maxdis = math.huge
    local opp

    for _, v in ipairs(game:GetService("Players"):GetChildren()) do
        local teamCheck = not getgenv().settings.TeamCheck or (v.Team ~= player.Team)
        local deadCheck = not getgenv().settings.CheckIfDead or (v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0)

        if teamCheck and deadCheck and v ~= player then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            if hrp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local mag = (hrp.Position - v.Character.HumanoidRootPart.Position).Magnitude

                if mag < maxdis then
                    opp = v
                    maxdis = mag
                end
            end
        end
    end
    return opp
end

local char = returnclp()
game:GetService("RunService").RenderStepped:Connect(function()
    char = returnclp()
    if char and char.Character then
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
    end
end)

-- TARGETTING

local hi;

hi = hookmetamethod(game, "__namecall", newcclosure(function(Self, ...)
    local args = {...}
    local method = getnamecallmethod():lower()

    if tostring(method) == "raycast" then
        if char and char.Character and char.Character:FindFirstChild("HumanoidRootPart") then
            args[2] = (char.Character.HumanoidRootPart.Position - args[1]).Unit * 1000
            return hi(Self, unpack(args))
        end
    end
    return hi(Self, ...)
end))

-- HOOKING

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✅ RAYCAST SILENT AIM V2",
    Text = "Silent aim successfully loaded!"
})
