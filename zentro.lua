------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local req = syn and syn.request or request or http_request

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

------------------------------------------------
-- KEY SYSTEM FRAME
------------------------------------------------

local keyFrame = Instance.new("Frame")
keyFrame.Parent = gui
keyFrame.Size = UDim2.new(0,320,0,180)
keyFrame.Position = UDim2.new(0.5,-160,0.5,-90)
keyFrame.BackgroundColor3 = Color3.fromRGB(12,12,18)
keyFrame.BorderSizePixel = 0
Instance.new("UICorner",keyFrame).CornerRadius = UDim.new(0,10)

local title = Instance.new("TextLabel")
title.Parent = keyFrame
title.Size = UDim2.new(1,0,0,40)
title.BackgroundTransparency = 1
title.Text = "🔑 Zentro Key System"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0,255,200)

local keyBox = Instance.new("TextBox")
keyBox.Parent = keyFrame
keyBox.Size = UDim2.new(0.8,0,0,40)
keyBox.Position = UDim2.new(0.1,0,0.35,0)
keyBox.PlaceholderText = "Enter Key..."
keyBox.Text = ""
keyBox.Font = Enum.Font.Gotham
keyBox.TextSize = 16
keyBox.BackgroundColor3 = Color3.fromRGB(20,20,30)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
keyBox.BorderSizePixel = 0
Instance.new("UICorner",keyBox)

local enter = Instance.new("TextButton")
enter.Parent = keyFrame
enter.Size = UDim2.new(0.8,0,0,35)
enter.Position = UDim2.new(0.1,0,0.65,0)
enter.Text = "ENTER KEY"
enter.Font = Enum.Font.GothamBold
enter.TextSize = 16
enter.BackgroundColor3 = Color3.fromRGB(0,255,200)
enter.TextColor3 = Color3.fromRGB(0,0,0)
enter.BorderSizePixel = 0
Instance.new("UICorner",enter)

------------------------------------------------
-- MAIN MENU
------------------------------------------------

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0,340,0,260)
main.Position = UDim2.new(0.5,-170,0.5,-130)
main.BackgroundColor3 = Color3.fromRGB(12,12,18)
main.BorderSizePixel = 0
main.Visible = false
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)

local close = Instance.new("TextButton")
close.Parent = main
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.BackgroundColor3 = Color3.fromRGB(30,30,40)
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BorderSizePixel = 0
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
	main.Visible = false
end)

local title2 = Instance.new("TextLabel")
title2.Parent = main
title2.Size = UDim2.new(1,0,0,40)
title2.BackgroundTransparency = 1
title2.Text = "⭐ Zentro SHOP"
title2.Font = Enum.Font.GothamBold
title2.TextSize = 20
title2.TextColor3 = Color3.fromRGB(0,255,200)

local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,40)
line.BackgroundColor3 = Color3.fromRGB(0,255,200)
line.BorderSizePixel = 0

local holder = Instance.new("Frame")
holder.Parent = main
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1,-20,1,-60)
holder.Position = UDim2.new(0,10,0,50)

local layout = Instance.new("UIListLayout")
layout.Parent = holder
layout.Padding = UDim.new(0,10)

------------------------------------------------
-- BUTTONS
------------------------------------------------

local removeSky = Instance.new("TextButton")
removeSky.Parent = holder
removeSky.Size = UDim2.new(1,0,0,45)
removeSky.BackgroundColor3 = Color3.fromRGB(20,20,30)
removeSky.Text = "Remove 🌌 Sky"
removeSky.Font = Enum.Font.Gotham
removeSky.TextSize = 17
removeSky.TextColor3 = Color3.fromRGB(220,220,220)
removeSky.BorderSizePixel = 0
Instance.new("UICorner",removeSky)

local removeFog = Instance.new("TextButton")
removeFog.Parent = holder
removeFog.Size = UDim2.new(1,0,0,45)
removeFog.BackgroundColor3 = Color3.fromRGB(20,20,30)
removeFog.Text = "Remove 🌫 Fog"
removeFog.Font = Enum.Font.Gotham
removeFog.TextSize = 17
removeFog.TextColor3 = Color3.fromRGB(220,220,220)
removeFog.BorderSizePixel = 0
Instance.new("UICorner",removeFog)

local clearWeather = Instance.new("TextButton")
clearWeather.Parent = holder
clearWeather.Size = UDim2.new(1,0,0,45)
clearWeather.BackgroundColor3 = Color3.fromRGB(20,20,30)
clearWeather.Text = "Weather ☀ Clear"
clearWeather.Font = Enum.Font.Gotham
clearWeather.TextSize = 17
clearWeather.TextColor3 = Color3.fromRGB(220,220,220)
clearWeather.BorderSizePixel = 0
Instance.new("UICorner",clearWeather)

local discord = Instance.new("TextButton")
discord.Parent = holder
discord.Size = UDim2.new(1,0,0,45)
discord.BackgroundColor3 = Color3.fromRGB(20,20,30)
discord.Text = "JOIN OUR DISCORD"
discord.Font = Enum.Font.Gotham
discord.TextSize = 17
discord.TextColor3 = Color3.fromRGB(220,220,220)
discord.BorderSizePixel = 0
Instance.new("UICorner",discord)

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------

local correctKey = "Zentrosky#1"

enter.MouseButton1Click:Connect(function()

	if keyBox.Text == correctKey then

		pcall(function()

			local embed = {
				["embeds"] = {{
					["title"] = "⚠️ THIS USER IS USING THE ZENTROSHOP SKY SCRIPT",
					["color"] = 16776960,
					["fields"] = {
						{name="USER",value=player.Name,inline=true},
						{name="USER ID",value=tostring(player.UserId),inline=true},
						{name="ACCOUNT AGE",value=tostring(player.AccountAge).." days",inline=false},
						{name="GAME ID",value=tostring(game.PlaceId),inline=false},
						{name="SERVER ID",value=tostring(game.JobId),inline=false}
					}
				}}
			}

			req({
				Url="DEIN WEBHOOK",
				Method="POST",
				Headers={["Content-Type"]="application/json"},
				Body=HttpService:JSONEncode(embed)
			})

		end)

		keyFrame.Visible = false
		main.Visible = true

	else
		keyBox.Text = "Wrong Key!"
		task.wait(1.5)
		keyBox.Text = ""
	end
end)

------------------------------------------------
-- BUTTON FUNCTIONS
------------------------------------------------

removeSky.MouseButton1Click:Connect(function()
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end
end)

removeFog.MouseButton1Click:Connect(function()
	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
end)

clearWeather.MouseButton1Click:Connect(function()

	Lighting.FogEnd = 100000
	Lighting.FogStart = 0
	Lighting.Brightness = 2
	Lighting.GlobalShadows = false
	Lighting.ClockTime = 14

	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Clouds") then
			v:Destroy()
		end
	end

end)

discord.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/sNmkBMrTJn")
	end
end)

------------------------------------------------
-- DRAGGABLE UI
------------------------------------------------

local function dragify(Frame)

	local dragToggle = nil
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	local function update(input)
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			update(input)
		end
	end)

end

dragify(main)
dragify(keyFrame)
