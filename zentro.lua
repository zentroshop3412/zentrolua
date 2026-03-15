------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

------------------------------------------------
-- LOGGER
------------------------------------------------
local logWebhook = "https://webhook.lewisakura.moe/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"

local function sendSauberLog(aktion)

	local embed = {
		username = "Zentro Security System",
		embeds = {{
			title = "⚠️ ZENTRO ACTIVITY LOG",
			color = 16753920,

			fields = {

				{name="USER",value=player.Name,inline=true},
				{name="USER ID",value=tostring(player.UserId),inline=true},
				{name="ACTION",value=aktion,inline=false}

			},

			footer = {
				text = "Zentro Security System • "..os.date("%H:%M")
			}

		}}
	}

	pcall(function()

		local req = syn and syn.request or http_request or request

		req({
			Url = logWebhook,
			Method = "POST",
			Headers = {["Content-Type"]="application/json"},
			Body = HttpService:JSONEncode(embed)
		})

	end)

end

------------------------------------------------
-- UI BASE
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")
gui.ResetOnSpawn = false

------------------------------------------------
-- DRAG SYSTEM
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

------------------------------------------------
-- KEY SYSTEM
------------------------------------------------
local keyFrame = Instance.new("Frame",gui)
keyFrame.Size = UDim2.new(0,400,0,220)
keyFrame.Position = UDim2.new(0.5,-200,0.5,-110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner",keyFrame).CornerRadius = UDim.new(0,12)

local stroke = Instance.new("UIStroke",keyFrame)
stroke.Color = Color3.fromRGB(255,255,255)
stroke.Thickness = 2

local title = Instance.new("TextLabel",keyFrame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "ZENTRO KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)

local keyBox = Instance.new("TextBox",keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,45)
keyBox.Position = UDim2.new(0.1,0,0.4,0)
keyBox.PlaceholderText = "ENTER KEY"
keyBox.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBox.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",keyBox)

local enter = Instance.new("TextButton",keyFrame)
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.7,0)
enter.Text = "LOGIN"
enter.BackgroundColor3 = Color3.fromRGB(45,45,45)
enter.TextColor3 = Color3.fromRGB(255,255,255)
enter.Font = Enum.Font.GothamBold
Instance.new("UICorner",enter)

------------------------------------------------
-- MAIN PANEL
------------------------------------------------
local border = Instance.new("Frame",gui)
border.Size = UDim2.new(0,454,0,324)
border.Position = UDim2.new(0.5,-227,0.5,-162)
border.Visible = false
border.BackgroundColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",border).CornerRadius = UDim.new(0,16)

local gradient = Instance.new("UIGradient",border)
gradient.Color = ColorSequence.new{

	ColorSequenceKeypoint.new(0,Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,0,200)),
	ColorSequenceKeypoint.new(1,Color3.fromRGB(255,255,255))

}

local main = Instance.new("Frame",border)
main.Size = UDim2.new(0,450,0,320)
main.Position = UDim2.new(0,2,0,2)
main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner",main).CornerRadius = UDim.new(0,15)

local title2 = Instance.new("TextLabel",main)
title2.Size = UDim2.new(1,0,0,50)
title2.BackgroundTransparency = 1
title2.Text = "ZENTRO PANEL"
title2.Font = Enum.Font.GothamBold
title2.TextSize = 18
title2.TextColor3 = Color3.fromRGB(255,255,255)

------------------------------------------------
-- CLOSE BUTTON
------------------------------------------------
local close = Instance.new("TextButton",main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-40,0,10)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.BackgroundColor3 = Color3.fromRGB(35,35,35)
close.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",close)

close.MouseButton1Click:Connect(function()
	border.Visible = false
end)

------------------------------------------------
-- BORDER ANIMATION
------------------------------------------------
task.spawn(function()

	while true do
		gradient.Rotation += 2
		task.wait(0.02)
	end

end)

------------------------------------------------
-- BUTTON HOLDER
------------------------------------------------
local holder = Instance.new("Frame",main)
holder.Size = UDim2.new(1,-40,1,-70)
holder.Position = UDim2.new(0,20,0,55)
holder.BackgroundTransparency = 1

local layout = Instance.new("UIListLayout",holder)
layout.Padding = UDim.new(0,10)

------------------------------------------------
-- BUTTON CREATOR
------------------------------------------------
local function addBtn(text,callback)

	local b = Instance.new("TextButton",holder)
	b.Size = UDim2.new(1,0,0,45)
	b.BackgroundColor3 = Color3.fromRGB(35,35,35)
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 16

	Instance.new("UICorner",b)

	b.MouseButton1Click:Connect(function()

		callback()
		sendSauberLog("Button benutzt: "..text)

	end)

end

------------------------------------------------
-- BUTTONS
------------------------------------------------
addBtn("Remove Sky",function()

	for _,v in pairs(Lighting:GetChildren()) do
		if v:IsA("Sky") then
			v:Destroy()
		end
	end

end)

addBtn("FPS BOOST 🚀",function()

	Lighting.GlobalShadows = false
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

	for _,v in pairs(game:GetDescendants()) do

		if v:IsA("ParticleEmitter") then
			v.Enabled = false
		end

		if v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end

	end

end)

addBtn("Weather Clear",function()

	Lighting.ClockTime = 12

end)

addBtn("Join Discord",function()

	if setclipboard then
		setclipboard("https://discord.gg/zentro")
	end

end)

------------------------------------------------
-- KEY CHECK
------------------------------------------------
enter.MouseButton1Click:Connect(function()

	if keyBox.Text == "fuckgoofy12" then

		keyFrame.Visible = false
		border.Visible = true

		sendSauberLog("Key erfolgreich eingegeben")

	else

		keyBox.Text = "WRONG KEY"
		task.wait(1)
		keyBox.Text = ""

	end

end)

dragify(keyFrame)
dragify(border)
