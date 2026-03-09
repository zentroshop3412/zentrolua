------------------------------------------------
-- LOGGER (NEUER WEBHOOK)
------------------------------------------------
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local req = syn and syn.request or request or http_request

pcall(function()
    req({
        Url = "https://discord.com/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json"
        },
        Body = HttpService:JSONEncode({
            ["content"] = player.Name.." is using Zentro Script | UserID: "..player.UserId.." | GameID: "..game.PlaceId
        })
    })
end)

------------------------------------------------
-- SERVICES
------------------------------------------------
local Lighting = game:GetService("Lighting")

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

-- CLOSE BUTTON
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

-- TITLE
local title2 = Instance.new("TextLabel")
title2.Parent = main
title2.Size = UDim2.new(1,0,0,40)
title2.BackgroundTransparency = 1
title2.Text = "⭐ Zentro SHOP"
title2.Font = Enum.Font.GothamBold
title2.TextSize = 20
title2.TextColor3 = Color3.fromRGB(0,255,200)

-- LINE
local line = Instance.new("Frame")
line.Parent = main
line.Size = UDim2.new(1,0,0,2)
line.Position = UDim2.new(0,0,0,40)
line.BackgroundColor3 = Color3.fromRGB(0,255,200)
line.BorderSizePixel = 0

-- BUTTON HOLDER
local holder = Instance.new("Frame")
holder.Parent = main
holder.BackgroundTransparency = 1
holder.Size = UDim2.new(1,-20,1,-60)
holder.Position = UDim2.new(0,10,0,50)

local layout = Instance.new("UIListLayout")
layout.Parent = holder
layout.Padding = UDim.new(0,10)

-- REMOVE SKY BUTTON
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

-- DISCORD BUTTON
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
-- FUNCTIONS
------------------------------------------------
local correctKey = "zentroshopsky33"

enter.MouseButton1Click:Connect(function()
	if keyBox.Text == correctKey then
		keyFrame.Visible = false
		main.Visible = true
	else
		keyBox.Text = "Wrong Key!"
		wait(1.5)
		keyBox.Text = ""
	end
end)

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
