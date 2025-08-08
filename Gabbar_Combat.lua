local Combat = {}

function Combat:FastKill()
    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") then
            enemy.Humanoid.Health = 0
        end
    end
end

return Combat