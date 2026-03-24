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
            footer = { text = "Zentro Security • "..os.date("%H:%M") }
        }}
    }

    pcall(function()
        local req = syn and syn.request or http_request or request
        if req then
            req({
                Url = logWebhook,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(embed)
            })
        end
    end)
end

------------------------------------------------
-- BLACKLIST SYSTEM
------------------------------------------------
local blacklistWebhook = "https://discord.com/api/webhooks/1482495661223186674/ZhfAWFNRZLbcch8FuGgRx8hX-M9baaXtiMUSzNbRE1aet2ILJTa1OUnYmAOeZg7fopE8"
local blacklistURL = "https://raw.githubusercontent.com/zentroshop3412/blacklist.txt/refs/heads/main/blacklist"

local function sendBlacklistLog(reason)
    local embed = {
        username = "Zentro Blacklist System",
        embeds = {{
            title = "🚫 ZENTRO BLACKLIST",
            color = 16711680,
            fields = {
                {name="USER", value=player.Name, inline=true},
                {name="USER ID", value=tostring(player.UserId), inline=true},
                {name="REASON", value=reason, inline=false}
            },
            footer = { text = "Zentro Security • "..os.date("%H:%M") }
        }}
    }

    pcall(function()
        local req = syn and syn.request or http_request or request
        if req then
            req({
                Url = blacklistWebhook,
                Method = "POST",
                Headers = {["Content-Type"]="application/json"},
                Body = HttpService:JSONEncode(embed)
            })
        end
    end)
end

local function checkBlacklist()
    local req = syn and syn.request or http_request or request
    if not req then return end

    local success, response = pcall(function()
        return req({Url = blacklistURL, Method = "GET"})
    end)

    if success and response and response.Body then
        for line in string.gmatch(response.Body, "[^\r\n]+") do
            line = line:gsub("%s+", "")

            if line == tostring(player.UserId) then
                sendBlacklistLog("UserId Match")
                player:Kick("Zentro Security: Blacklisted.")
                return
            end

            if string.lower(line) == string.lower(player.Name) then
                sendBlacklistLog("Username Match")
                player:Kick("Zentro Security: Blacklisted.")
                return
            end
        end
    end
end

task.spawn(checkBlacklist)

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
    local dragToggle, dragInput, dragStart, startPos

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
local keyFrame = Instance.new("Frame", gui)
keyFrame.Size = UDim2.new(0, 450, 0, 260)
keyFrame.Position = UDim2.new(0.5, -225, 0.5, -130)
keyFrame.BackgroundColor3 = Color3.fromRGB(15,15,15)
Instance.new("UICorner", keyFrame)

local title = Instance.new("TextLabel", keyFrame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "ZENTRO KEY SYSTEM"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255,255,255)

local keyBox = Instance.new("TextBox", keyFrame)
keyBox.Size = UDim2.new(0.8,0,0,45)
keyBox.Position = UDim2.new(0.1,0,0.4,0)

local enter = Instance.new("TextButton", keyFrame)
enter.Size = UDim2.new(0.8,0,0,40)
enter.Position = UDim2.new(0.1,0,0.7,0)
enter.Text = "LOGIN"

------------------------------------------------
-- MAIN PANEL
------------------------------------------------
local border = Instance.new("Frame", gui)
border.Size = UDim2.new(0, 500, 0, 360)
border.Position = UDim2.new(0.5, -250, 0.5, -180)
border.Visible = false

local main = Instance.new("Frame", border)
main.Size = UDim2.new(1,0,1,0)

------------------------------------------------
-- BUTTON SYSTEM
------------------------------------------------
local holder = Instance.new("Frame", main)
holder.Size = UDim2.new(1,-40,1,-70)
holder.Position = UDim2.new(0,20,0,55)

local layout = Instance.new("UIListLayout", holder)
layout.Padding = UDim.new(0,10)

local function addButton(text, isToggle, state, callback)
    local b = Instance.new("Frame", holder)
    b.Size = UDim2.new(1,0,0,50)

    local toggled = state
    local box

    if isToggle then
        box = Instance.new("Frame", b)
        box.Size = UDim2.new(0,25,0,25)
        box.Position = UDim2.new(1,-35,0.5,-12)
        box.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end

    b.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if isToggle then
                toggled = not toggled
                box.BackgroundColor3 = toggled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
                callback(toggled)
            else
                callback()
            end
        end
    end)
end

------------------------------------------------
-- BUTTONS
------------------------------------------------
addButton("Night Vision 🌙", true, false, function(state)
    local cc = Lighting:FindFirstChild("ZentroNightVision")
    if state then
        if not cc then
            cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "ZentroNightVision"
            cc.Parent = Lighting
        end
    else
        if cc then cc:Destroy() end
    end
end)

addButton("Remove Sky", false, false, function()
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
end)

addButton("FPS BOOST 🚀", false, false, function()
    Lighting.GlobalShadows = false
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    for _,v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") then v.Enabled = false end
        if v:IsA("Trail") then v.Enabled = false end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end)

addButton("Weather Clear", false, false, function()
    Lighting.ClockTime = 12
end)

addButton("Join Discord", false, false, function()
    if setclipboard then
        setclipboard("https://discord.gg/sNmkBMrTJn")
    end
end)

------------------------------------------------
-- KEY CHECK
------------------------------------------------
enter.MouseButton1Click:Connect(function()
    if keyBox.Text == "fuckgoofy12" then
        checkBlacklist()
        keyFrame.Visible = false
        border.Visible = true
        sendSauberLog("Key erfolgreich eingegeben")
    else
        keyBox.Text = "WRONG KEY"
        task.wait(1)
        keyBox.Text = ""
    end
end)

------------------------------------------------
-- DRAG
------------------------------------------------
dragify(keyFrame)
dragify(border)
