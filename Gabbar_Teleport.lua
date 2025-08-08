local Teleport = {}

function Teleport:ToIsland(name)
    local hrp = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") and v.Name == name then
            hrp.CFrame = v.CFrame + Vector3.new(0, 5, 0)
            return
        end
    end
end

return Teleport