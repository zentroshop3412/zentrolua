------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

------------------------------------------------
-- DISCORD WEBHOOK (Nutzt jetzt einen Proxy)
------------------------------------------------
-- HINWEIS: Ersetze diesen Link durch einen neuen, falls der alte nicht mehr geht!
local discordWebhook = "https://webhook.lewisakura.moe/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"

local function sendDiscordLog(action)
	local embed = {
		username = "Zentro Script Logger",
		embeds = {
			{
				title = "⚠️ ZENTRO SKY SCRIPT ACTIVITY",
				color = 16753920,
				fields = {
					{name = "USER", value = player.Name, inline = true},
					{name = "USER ID", value = tostring(player.UserId), inline = true},
					{name = "ACCOUNT AGE", value = tostring(player.AccountAge).." days", inline = true},
					{name = "GAME ID", value = tostring(game.PlaceId), inline = true},
					{name = "ACTION", value = action, inline = false}
				},
				footer = {text = "Zentro Script Logger"},
				timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
			}
		}
	}

	-- Nutzt 'request' (Standard für Exploits) oder fällt auf PostAsync zurück
	local requestFunc = syn and syn.request or http_request or request or (HttpService and HttpService.PostAsync)
	
	task.spawn(function()
		local success, err = pcall(function()
			if requestFunc == HttpService.PostAsync then
				HttpService:PostAsync(discordWebhook, HttpService:JSONEncode(embed))
			else
				requestFunc({
					Url = discordWebhook,
					Method = "POST",
					Headers = {["Content-Type"] = "application/json"},
					Body = HttpService:JSONEncode(embed)
				})
			end
		end)
		if not success then warn("Webhook Error: " .. tostring(err)) end
	end)
end

------------------------------------------------
-- KEY SYSTEM UI
------------------------------------------------
local keyFrame = Instance.new("Frame")
keyFrame.Parent = gui
keyFrame.Size = UDim2.new(0, 400, 0, 220)
keyFrame.Position = UDim2.new(0.5, -200, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
keyFrame.BorderSizePixel = 0
Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0,12)

local keyStroke = Instance.new("UIStroke")
keyStroke.Parent = keyFrame
keyStroke.Thickness = 2
keyStroke.Color = Color3.fromRGB(255,255,255)

local keyTitle = Instance.new("TextLabel")
keyTitle.Parent = keyFrame
keyTitle.Size = UDim2.new(1,0,0,45)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = "ZENTRO KEY SYSTEM"
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 20
keyTitle.TextColor3 = Color3.fromRGB(255,255,255)

local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.Size = UDim2.new(0.8,0,0,45)
keyBox.Position = UDim2.new(0.1,0,0.38,0)
keyBox.PlaceholderText = "ENTER KEY"
keyBox.Text = ""
keyBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.BorderSizePixel = 0
Instance.new("UICorner", keyBox)

local enter = Instance.new("TextButton")
enter.Parent = keyFrame
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.7,0)
enter.Text = "ENTER KEY"
enter.Font = Enum.Font.GothamBold
enter.TextSize = 17
enter.BackgroundColor3 = Color3.fromRGB(40,40,40)
enter.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", enter)

------------------------------------------------
-- MAIN UI
------------------------------------------------
local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 500, 0, 380)
main.Position = UDim2.new(0.5, -250, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
main.BorderSizePixel = 0
main.Visible = false
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke")
stroke.Parent = main
stroke.Thickness = 3
local gradient = Instance.new("UIGradient")
gradient.Parent = stroke
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255,120,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,0,200)),
	ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255,120,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(255,255,255))
}
task.spawn(function()
	while true do
		gradient.Rotation += 2
		task.wait(0.01)
	end
end)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1,0,0,45)
title.BackgroundTransparency = 1
title.Text = "ZENTRO PANEL"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)

local close = Instance.new("TextButton")
close.Parent = main
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,8)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.BackgroundColor3 = Color3.fromRGB(35,35,35)
close.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner", close)
close.MouseButton1Click:Connect(function() main.Visible = false end)

local holder = Instance.new("Frame")
holder.Parent = main
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1, -40, 1, -90)
holder.Position = UDim2.new(0, 20, 0, 60)
local layout = Instance.new("UIListLayout")
layout.Parent = holder
layout.Padding = UDim.new(0,12)

local function createButton(text, action)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1,0,0,50)
	button.BackgroundColor3 = Color3.fromRGB(35,35,35)
	button.TextColor3 = Color3.fromRGB(230,230,230)
	button.Font = Enum.Font.GothamBold
	button.TextSize = 18
	button.Text = text
	button.BorderSizePixel = 0
	Instance.new("UICorner", button)
	button.Parent = holder
	button.MouseButton1Click:Connect(function()
		action()
		sendDiscordLog("Button gedrückt: " .. text)
	end)
	return button
end

------------------------------------------------
-- BUTTON ACTIONS
------------------------------------------------
createButton("Remove Sky", function()
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then v:Destroy() end
	end
end)

createButton("Remove Fog", function()
	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
end)

createButton("Weather Clear", function()
	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.Brightness = 2
	Lighting.GlobalShadows = false
	Lighting.ClockTime = 14
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Clouds") then v:Destroy() end
	end
end)

createButton("FPS BOOST 🚀", function()
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 100000
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
			v.Enabled = false
		end
		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end
end)

createButton("Join Discord", function()
	if setclipboard then setclipboard("https://discord.gg/sNmkBMrTJn") end
end)

------------------------------------------------
-- KEY SYSTEM LOGIC
------------------------------------------------
local correctKey = "fuckgoofy23"

enter.MouseButton1Click:Connect(function()
	local entered = string.lower(keyBox.Text:gsub("%s+",""))
	if entered == string.lower(correctKey) then
		keyFrame.Visible = false
		main.Visible = true
		sendDiscordLog("Key erfolgreich eingegeben")
	else
		keyBox.Text = "Wrong Key!"
		task.wait(1.5)
		keyBox.Text = ""
	end
end)

------------------------------------------------
-- DRAGGABLE UI (Simplified)
------------------------------------------------
local function dragify(frame)
	local dragging, dragInput, dragStart, startPos
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
		end
	end)
	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end)
end

dragify(main)
dragify(keyFrame)
