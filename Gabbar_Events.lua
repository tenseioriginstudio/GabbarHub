local Events = {}

function Events:AutoSeaBeast()
    while true do
        wait(1)
        for _, v in pairs(workspace.SeaBeasts:GetChildren()) do
            if v:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 10, 0)
            end
        end
    end
end

return Events