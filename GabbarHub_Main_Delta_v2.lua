-- Gabbar Hub Mobile - Delta Optimized v2.0
-- Everything in one file: kill, fruits, teleport, sea event, quests, server hop, save/load

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera

-- Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
    end)
end)

-- UI Setup
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GabbarHub_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 350, 0, 400)
Main.Position = UDim2.new(0.5, -175, 0.5, -200)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "Gabbar Hub Mobile v2"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local Tabs = {"Combat", "Fruits", "Teleport", "Events", "Server"}
local CurrentTab = "Combat"

local ButtonHolder = Instance.new("Frame", Main)
ButtonHolder.Position = UDim2.new(0, 0, 0, 40)
ButtonHolder.Size = UDim2.new(1, 0, 0, 30)
ButtonHolder.BackgroundTransparency = 1

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 0, 0, 70)
Content.Size = UDim2.new(1, 0, 1, -70)
Content.BackgroundTransparency = 1

local function ClearContent()
    for _, c in pairs(Content:GetChildren()) do
        c:Destroy()
    end
end

-- Helper to make button
local function CreateButton(text, callback)
    local b = Instance.new("TextButton", Content)
    b.Size = UDim2.new(1, -20, 0, 40)
    b.Position = UDim2.new(0, 10, 0, #Content:GetChildren() * 45)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 14
    b.Text = text
    b.MouseButton1Click:Connect(callback)
end

-- Save / Load Profile
local saveFile = "gabbarhub_profile.json"
local settings = {autoQuest = false, serverHop = false}

local function SaveSettings()
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(settings))
    end
end

local function LoadSettings()
    if isfile and isfile(saveFile) then
        local data = readfile(saveFile)
        settings = HttpService:JSONDecode(data)
    end
end

LoadSettings()

-- Features
local function FastKill()
    for _, enemy in pairs(workspace:GetDescendants()) do
        if enemy:FindFirstChild("Humanoid") and enemy ~= LocalPlayer.Character then
            enemy.Humanoid.Health = 0
        end
    end
end

local function GrabAllFruits()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end

local function TeleportTo(name)
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("Part") and part.Name:lower():find(name:lower()) then
            LocalPlayer.Character:MoveTo(part.Position + Vector3.new(0,5,0))
            break
        end
    end
end

local function AutoQuest()
    task.spawn(function()
        while settings.autoQuest do
            local npc = workspace:FindFirstChild("QuestGiver")
            if npc then
                fireproximityprompt(npc.ProximityPrompt)
            end
            wait(5)
        end
    end)
end

local function ServerHop()
    local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end

-- Tabs Logic
for i, name in ipairs(Tabs) do
    local t = Instance.new("TextButton", ButtonHolder)
    t.Size = UDim2.new(0, 70, 1, 0)
    t.Position = UDim2.new(0, (i - 1) * 72, 0, 0)
    t.Text = name
    t.TextScaled = true
    t.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    t.TextColor3 = Color3.fromRGB(0, 255, 255)
    t.MouseButton1Click:Connect(function()
        CurrentTab = name
        ClearContent()
        if name == "Combat" then
            CreateButton("Fast Kill Enemies", FastKill)
        elseif name == "Fruits" then
            CreateButton("Grab All Fruits", GrabAllFruits)
        elseif name == "Teleport" then
            CreateButton("To Starter Island", function() TeleportTo("Starter") end)
            CreateButton("To Jungle", function() TeleportTo("Jungle") end)
        elseif name == "Events" then
            CreateButton("Auto Quest [Toggle]", function()
                settings.autoQuest = not settings.autoQuest
                SaveSettings()
                if settings.autoQuest then AutoQuest() end
            end)
        elseif name == "Server" then
            CreateButton("Server Hop", ServerHop)
        end
    end)
end

-- Default tab
ButtonHolder:FindFirstChild(Tabs[1]):Fire() -- Show default tab

-- Save when closed (only in PC)
if syn and syn.queue_on_teleport then
    syn.queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/YOUR_USERNAME/GabbarHub/main/GabbarHub_Main_Delta_v2.lua'))()")
end
