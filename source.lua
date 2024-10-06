getgenv().settings = {
    TeamCheck = true,
    CheckIfDead = true,
}

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
