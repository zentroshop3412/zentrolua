------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local req = syn and syn.request or request or http_request

------------------------------------------------
-- WHITELIST SYSTEM
------------------------------------------------

local whitelist = {
8558469388
1819003775
10118561453
5378515057
10455152162
6022233102
7148052008
5691903188, -- DEINE USER ID
}

local allowed = false

for _,id in pairs(whitelist) do
	if player.UserId == id then
		allowed = true
	end
end

------------------------------------------------
-- DISCORD LOGGER FUNCTION
------------------------------------------------

local function sendLog(title)

	pcall(function()

		local embed = {
			["embeds"] = {{
				["title"] = title,
				["color"] = 16776960,
				["fields"] = {

					{
						["name"] = "USER",
						["value"] = player.Name,
						["inline"] = true
					},

					{
						["name"] = "USER ID",
						["value"] = tostring(player.UserId),
						["inline"] = true
					},

					{
						["name"] = "ACCOUNT AGE",
						["value"] = tostring(player.AccountAge).." days",
						["inline"] = false
					},

					{
						["name"] = "GAME ID",
						["value"] = tostring(game.PlaceId),
						["inline"] = false
					},

					{
						["name"] = "SERVER ID",
						["value"] = tostring(game.JobId),
						["inline"] = false
					}

				},

				["footer"] = {
					["text"] = "Zentro Script System"
				}
			}}
		}

		req({
			Url = "https://discord.com/api/webhooks/1481015588800303349/O4PHrHtrJPJk9b8uy_xrldwlkHhubVyrLpyHIGRoEr_LtrAGP3nGy9iQNaGUe4bFFoZs",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode(embed)
		})

	end)

end

------------------------------------------------
-- WHITELIST CHECK
------------------------------------------------

if not allowed then
	sendLog("🚫 NOT WHITELISTED USER TRIED ZENTRO SCRIPT")
	player:Kick("You are not whitelisted for Zentro Script")
	return
else
	sendLog("✅ WHITELISTED USER STARTED ZENTRO SCRIPT")
end

------------------------------------------------
-- GUI
------------------------------------------------

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
main.Size = UDim2.new(0,340,0,210)
main.Position = UDim2.new(0.5,-170,0.5,-105)
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

local remove = Instance.new("TextButton")
remove.Parent = holder
remove.Size = UDim2.new(1,0,0,45)
remove.BackgroundColor3 = Color3.fromRGB(20,20,30)
remove.Text = "Remove 🌌 Sky"
remove.Font = Enum.Font.Gotham
remove.TextSize = 17
remove.TextColor3 = Color3.fromRGB(220,220,220)
remove.BorderSizePixel = 0
Instance.new("UICorner",remove)

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

		sendLog("⚠️ USER USED ZENTRO SKY SCRIPT")

		keyFrame.Visible = false
		main.Visible = true

	else

		keyBox.Text = "Wrong Key!"
		wait(1.5)
		keyBox.Text = ""

	end

end)

------------------------------------------------
-- BUTTON FUNCTIONS
------------------------------------------------

remove.MouseButton1Click:Connect(function()
	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end
end)

discord.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/sNmkBMrTJn")
	end
	discord.Text = "LINK COPIED!"
	wait(2)
	discord.Text = "JOIN OUR DISCORD"
end)


