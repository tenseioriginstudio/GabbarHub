local Utils = {}

function Utils:AutoHaki()
    local player = game.Players.LocalPlayer
    player.Character:WaitForChild("Humanoid"):FindFirstChild("Haki"):FireServer()
end

function Utils:AntiAFK()
    local vu = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end

return Utils