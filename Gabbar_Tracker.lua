local Tracker = {}

function Tracker:Start()
    local kills = 0
    game:GetService("Players").LocalPlayer.Character.Humanoid.Died:Connect(function()
        kills = kills + 1
        warn("Kills: ", kills)
    end)
end

return Tracker