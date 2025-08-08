-- Gabbar Hub Mobile - Delta Optimized v2.1 (Fully Enchanted)
-- Features: Clean UI, Minimize, Auto Quest, Server Hop, Fruit Grab, Legit Teleport, Anti-AFK, Save Settings

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

-- Create UI
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "GabbarHub_UI"

local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 400, 0, 450)
Main.Position = UDim2.new(0.5, -200, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BackgroundTransparency = 0.2
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Text = "Gabbar Hub v2.1 🔥"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -35, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextScaled = true

local Content = Instance.new("Frame", Main)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.Size = UDim2.new(1, 0, 1, -40)
Content.BackgroundTransparency = 1

-- Tab Buttons
local TabButtons = Instance.new("Frame", Content)
TabButtons.Size = UDim2.new(0, 100, 1, 0)
TabButtons.BackgroundTransparency = 1

local Pages = {
    Combat = {},
    Fruits = {},
    Teleport = {},
    Quests = {},
    Server = {}
}
local Settings = {autoQuest = false}

-- Save/Load Profile
local saveFile = "gabbarhub_profile.json"
local function SaveSettings()
    if writefile then
        writefile(saveFile, HttpService:JSONEncode(Settings))
    end
end
local function LoadSettings()
    if isfile and isfile(saveFile) then
        Settings = HttpService:JSONDecode(readfile(saveFile))
    end
end
LoadSettings()

-- Function Helpers
local function AddPage(tabName)
    local frame = Instance.new("Frame", Content)
    frame.Size = UDim2.new(1, -100, 1, 0)
    frame.Position = UDim2.new(0, 100, 0, 0)
    frame.BackgroundTransparency = 1
    frame.Visible = false
    Pages[tabName].Frame = frame
end

for tab in pairs(Pages) do AddPage(tab) end

local function SwitchPage(name)
    for t, data in pairs(Pages) do
        data.Frame.Visible = (t == name)
    end
end

local function CreateButton(text, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, #parent:GetChildren() * 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text
    btn.MouseButton1Click:Connect(callback)
end

local yPos = 0
for tab in pairs(Pages) do
    local t = Instance.new("TextButton", TabButtons)
    t.Size = UDim2.new(1, -10, 0, 35)
    t.Position = UDim2.new(0, 5, 0, yPos)
    yPos = yPos + 40
    t.Text = tab
    t.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    t.TextColor3 = Color3.fromRGB(0, 255, 255)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.MouseButton1Click:Connect(function()
        SwitchPage(tab)
    end)
end

-- Features
CreateButton("Fast Kill (Safe)", Pages.Combat.Frame, function()
    for _, mob in pairs(workspace:GetDescendants()) do
        if mob:FindFirstChild("Humanoid") and mob ~= LocalPlayer.Character then
            mob.Humanoid.Health = 0
        end
    end
end)

CreateButton("Grab All Fruits", Pages.Fruits.Frame, function()
    for _, fruit in pairs(workspace:GetDescendants()) do
        if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
            fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)

CreateButton("To Starter Island", Pages.Teleport.Frame, function()
    local pos = workspace:FindFirstChild("IslandSpawn") or LocalPlayer.Character.HumanoidRootPart
    LocalPlayer.Character:MoveTo(pos.Position + Vector3.new(0, 5, 0))
end)

CreateButton("To Jungle", Pages.Teleport.Frame, function()
    local jungle = workspace:FindFirstChild("Jungle")
    if jungle then LocalPlayer.Character:MoveTo(jungle.Position + Vector3.new(0,5,0)) end
end)

CreateButton("Toggle Auto Quest", Pages.Quests.Frame, function()
    Settings.autoQuest = not Settings.autoQuest
    SaveSettings()
    if Settings.autoQuest then
        task.spawn(function()
            while Settings.autoQuest do
                local npc = workspace:FindFirstChild("QuestGiver")
                if npc and npc:FindFirstChild("ProximityPrompt") then
                    fireproximityprompt(npc.ProximityPrompt)
                end
                wait(5)
            end
        end)
    end
end)

CreateButton("Server Hop", Pages.Server.Frame, function()
    local data = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
    local servers = HttpService:JSONDecode(data)
    for _, s in pairs(servers.data) do
        if s.playing < s.maxPlayers then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
        end
    end
end)

-- Final Setup
SwitchPage("Combat")

-- Minimize Function
local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    for _, child in pairs(Main:GetChildren()) do
        if child ~= Title and child ~= MinBtn then
            child.Visible = not minimized
        end
    end
    MinBtn.Text = minimized and "+" or "-"
end)
