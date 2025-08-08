-- Gabbar Hub - Delta Optimized (Single File)
-- No readfile, fully inline

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Create GUI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GabbarHub_UI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Gabbar Hub Mobile"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextScaled = true

-- Anti AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
    end)
end)

-- Fast Kill Function
local function FastKill()
    for _, enemy in pairs(workspace:GetDescendants()) do
        if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
            enemy.Humanoid.Health = 0
        end
    end
end

-- Grab All Fruits
local function GrabAllFruits()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

-- BUTTON: Fast Kill
local btn = Instance.new("TextButton", Frame)
btn.Size = UDim2.new(1, 0, 0, 40)
btn.Position = UDim2.new(0, 0, 0, 50)
btn.Text = "Fast Kill Enemies"
btn.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
btn.TextColor3 = Color3.new(1,1,1)
btn.MouseButton1Click:Connect(FastKill)

-- BUTTON: Grab Fruits
local btn2 = Instance.new("TextButton", Frame)
btn2.Size = UDim2.new(1, 0, 0, 40)
btn2.Position = UDim2.new(0, 0, 0, 100)
btn2.Text = "Grab All Fruits"
btn2.BackgroundColor3 = Color3.fromRGB(100, 0, 100)
btn2.TextColor3 = Color3.new(1,1,1)
btn2.MouseButton1Click:Connect(GrabAllFruits)
