local Fruits = {}

function Fruits:FindFruits()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            warn("Fruit Found:", fruit.Name)
            fruit.Handle.CFrame = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame
        end
    end
end

return Fruits