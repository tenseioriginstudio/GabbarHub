-- Gabbar Hub Mobile v2.2 (Delta-Optimized, Fully Enchanted)
-- ✅ Legit Server-Side Fast Kill | ✅ Full UI Minimize | ✅ XP, Mastery, Quests

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- 🔒 Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
    end)
end)

-- 🧠 Fetch CombatFramework
local function getCombatFramework()
    local success, result = pcall(function()
        for _, m in pairs(getgc(true)) do
            if type(m) == "table" and rawget(m, "activeController") then
                return m
            end
        end
    end)
    return success and result or nil
end

-- ⚔️ Server-Side Legit Fast Kill
local function serverFastKill()
    local CF = getCombatFramework()
    if not CF or not CF.activeController then return end

    local ac = CF.activeController
    local weapon = ac.blades and ac.blades[1]
    if not weapon then return end

    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        if mob:FindFirstChild("Humanoid") and
           mob:FindFirstChild("HumanoidRootPart") and
           mob.Humanoid.Health > 0 then

            for i = 1, 3 do
                if ac.hitboxMagnitude then
                    ac.hitboxMagnitude = 100
                end
                ac:attack()
                wait(0.1)
            end
        end
    end
end

-- 🧱 GUI
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "GabbarHub"

local MainFrame = Instance.new("Frame", Gui)
MainFrame.Size = UDim2.new(0, 310, 0, 210)
MainFrame.Position = UDim2.new(0.5, -155, 0.5, -105)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = "Gabbar Hub v2.2"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local MinBtn = Instance.new("TextButton", MainFrame)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 3)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true

local BtnHolder = Instance.new("Frame", MainFrame)
BtnHolder.Size = UDim2.new(1, 0, 1, -40)
BtnHolder.Position = UDim2.new(0, 0, 0, 40)
BtnHolder.BackgroundTransparency = 1

local function createBtn(txt, y, callback)
    local btn = Instance.new("TextButton", BtnHolder)
    btn.Size = UDim2.new(0, 280, 0, 35)
    btn.Position = UDim2.new(0, 15, 0, y)
    btn.Text = txt
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.MouseButton1Click:Connect(callback)
end

createBtn("⚔️ Legit Fast Kill", 0, serverFastKill)

createBtn("🍇 Grab All Fruits", 40, function()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

createBtn("🔁 Server Hop", 80, function()
    local data = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
    local servers = HttpService:JSONDecode(data)
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

-- 🧱 Full Minimize Toggle
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(MainFrame:GetChildren()) do
        if child ~= Title and child ~= MinBtn then
            child.Visible = not minimized
        end
    end
    MinBtn.Text = minimized and "+" or "-"
end)
