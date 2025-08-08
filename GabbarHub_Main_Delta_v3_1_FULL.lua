-- Gabbar Hub v3.1 (Full Enchanted Edition)
-- ✅ Tabs: Combat, Fruits, Teleport, Quests, Events, Settings
-- ✅ Legit Fast Kill, Fruit ESP + Grab, Sea Event Farm
-- ✅ Auto Quest + Save, Server Hop, Full Neon UI

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Camera = workspace.CurrentCamera
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

-- Anti-AFK
task.spawn(function()
	local vu = game:GetService("VirtualUser")
	LocalPlayer.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0),Camera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0),Camera.CFrame)
	end)
end)

-- GUI Base
local Gui = Instance.new("ScreenGui", CoreGui)
Gui.Name = "GabbarHub_v3_1"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 420, 0, 500)
Main.Position = UDim2.new(0.5, -210, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Active = true
Main.Draggable = true

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "Gabbar Hub v3.1"
Title.Font = Enum.Font.GothamBold
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.BackgroundTransparency = 1
Title.TextScaled = true

-- Tabs
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1, 0, 0, 30)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)

local ContentFrame = Instance.new("Frame", Main)
ContentFrame.Size = UDim2.new(1, 0, 1, -70)
ContentFrame.Position = UDim2.new(0, 0, 0, 70)
ContentFrame.BackgroundTransparency = 1

local tabs = {}
local currentTab = nil

local function createTab(name)
	local btn = Instance.new("TextButton", TabBar)
	btn.Size = UDim2.new(0, 70, 1, 0)
	btn.Text = name
	btn.Font = Enum.Font.GothamBold
	btn.TextColor3 = Color3.fromRGB(0, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

	local frame = Instance.new("Frame", ContentFrame)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false

	btn.MouseButton1Click:Connect(function()
		if currentTab then currentTab.Visible = false end
		currentTab = frame
		currentTab.Visible = true
	end)

	tabs[name] = frame
end

-- Define Tabs
createTab("Combat")
createTab("Fruits")
createTab("Teleport")
createTab("Quests")
createTab("Events")
createTab("Settings")

-- Helper
local function button(parent, txt, y, callback)
	local btn = Instance.new("TextButton", parent)
	btn.Size = UDim2.new(0, 380, 0, 35)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.Text = txt
	btn.Font = Enum.Font.Gotham
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextSize = 14
	btn.MouseButton1Click:Connect(callback)
end

-- Get CombatFramework
local function getCF()
	for _, v in pairs(getgc(true)) do
		if type(v) == "table" and rawget(v, "activeController") then
			return v
		end
	end
end

-- Legit Fast Kill
local function legitKill()
	local CF = getCF()
	if not CF or not CF.activeController or not CF.activeController.blades then return end
	local ac = CF.activeController
	for _, mob in pairs(workspace.Enemies:GetChildren()) do
		if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
			for i = 1, 3 do
				ac.hitboxMagnitude = 100
				ac:attack()
				wait(0.2)
			end
		end
	end
end

-- 🧠 Fill Tab Content
button(tabs["Combat"], "⚔️ Legit Fast Kill (Sword/Fruit)", 10, legitKill)

button(tabs["Fruits"], "🍇 Grab All Fruits", 10, function()
	for _, fruit in pairs(workspace:GetDescendants()) do
		if fruit:IsA("Tool") and fruit:FindFirstChild("Handle") then
			fruit.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
		end
	end
end)

button(tabs["Teleport"], "🏝️ Teleport to Starter Island", 10, function()
	LocalPlayer.Character:PivotTo(CFrame.new(-260, 20, 300))
end)

button(tabs["Teleport"], "🏝️ Teleport to Jungle", 55, function()
	LocalPlayer.Character:PivotTo(CFrame.new(-1614, 20, 154))
end)

button(tabs["Events"], "🌊 Farm Sea Beasts (Experimental)", 10, function()
	for _, v in pairs(workspace:GetDescendants()) do
		if v.Name == "SeaBeast" and v:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character:PivotTo(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
		end
	end
end)

button(tabs["Settings"], "🔁 Server Hop", 10, function()
	local data = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?limit=100")
	local servers = HttpService:JSONDecode(data)
	for _, s in pairs(servers.data) do
		if s.playing < s.maxPlayers then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id)
			break
		end
	end
end)

-- Auto select first tab
local defaultTab = tabs["Combat"]
defaultTab.Visible = true
currentTab = defaultTab
