local CoreUI = loadstring(readfile("GabbarHub/Gabbar_CoreUI.lua"))()
local Teleport = loadstring(readfile("GabbarHub/Gabbar_Teleport.lua"))()
local Events = loadstring(readfile("GabbarHub/Gabbar_Events.lua"))()
local Fruits = loadstring(readfile("GabbarHub/Gabbar_FruitHunter.lua"))()
local Combat = loadstring(readfile("GabbarHub/Gabbar_Combat.lua"))()
local Utils = loadstring(readfile("GabbarHub/Gabbar_Utils.lua"))()
local Tracker = loadstring(readfile("GabbarHub/Gabbar_Tracker.lua"))()

local main = CoreUI:CreateMain("Gabbar Hub Mobile")
Utils:AntiAFK()

local btn = Instance.new("TextButton", main)
btn.Size = UDim2.new(1, 0, 0, 40)
btn.Position = UDim2.new(0, 0, 0, 50)
btn.Text = "Fast Kill"
btn.MouseButton1Click:Connect(function()
    Combat:FastKill()
end)

local btn2 = Instance.new("TextButton", main)
btn2.Size = UDim2.new(1, 0, 0, 40)
btn2.Position = UDim2.new(0, 0, 0, 100)
btn2.Text = "Grab All Fruits"
btn2.MouseButton1Click:Connect(function()
    Fruits:FindFruits()
end)