------------------------------------------------
-- DELETE SAVED KEYS (ANTI SAVE)
------------------------------------------------
pcall(function()
    if delfile then
        delfile("NoKeySave.txt")
        delfile("ZentroKey.txt")
        delfile("Key.txt")
    end
end)

------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

------------------------------------------------
-- DISCORD WEBHOOKS
------------------------------------------------
local activityWebhook = "https://discord.com/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"
local blacklistWebhook = "https://discord.com/api/webhooks/1482495661223186674/ZhfAWFNRZLbcch8FuGgRx8hX-M9baaXtiMUSzNbRE1aet2ILJTa1OUnYmAOeZg7fopE8"

------------------------------------------------
-- DISCORD EMBED FUNCTION
------------------------------------------------
local function sendEmbed(webhook, title, color, actionText)
    pcall(function()
        local req = syn and syn.request or http_request or request
        if req then
            local time = os.date("%d.%m.%Y | %H:%M:%S")

            req({
                Url = webhook,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = title,
                        color = color,
                        fields = {
                            {name = "👤 User", value = player.Name, inline = true},
                            {name = "🆔 User ID", value = tostring(player.UserId), inline = true},
                            {name = "📌 Action", value = actionText, inline = false}
                        },
                        footer = {
                            text = "🛡️ Zentro Security • "..time
                        }
                    }}
                })
            })
        end
    end)
end

local function sendActivityLog()
    sendEmbed(activityWebhook, "⚠️ ZENTRO ACTIVITY", 16753920, "Key erfolgreich eingegeben")
end

local function sendBlacklistLog()
    sendEmbed(blacklistWebhook, "🚫 BLACKLIST DETECTED", 16711680, "Blacklisted User tried to execute script")
end

------------------------------------------------
-- BLACKLIST
------------------------------------------------
local blacklistURL = "https://raw.githubusercontent.com/zentroshop3412/blacklist.txt/main/blacklist"

local function checkBlacklist()
    local req = syn and syn.request or http_request or request
    if not req then return true end

    local success, response = pcall(function()
        return req({Url = blacklistURL, Method = "GET"})
    end)

    if success and response and response.Body then
        for line in string.gmatch(response.Body, "[^\r\n]+") do
            line = line:gsub("%s+", "")

            if line == tostring(player.UserId) or string.lower(line) == string.lower(player.Name) then
                sendBlacklistLog()
                task.wait(1)
                player:Kick("⛔ Blacklisted.")
                return false
            end
        end
    end

    return true
end

if not checkBlacklist() then return end

------------------------------------------------
-- SKYBOX DATABASE
------------------------------------------------
local Skyboxes = {
    ["🌌 Universe"] = {
        SkyboxBk="rbxassetid://159454299",
        SkyboxDn="rbxassetid://159454296",
        SkyboxFt="rbxassetid://159454293",
        SkyboxLf="rbxassetid://159454286",
        SkyboxRt="rbxassetid://159454300",
        SkyboxUp="rbxassetid://159454288"
    },
    ["🟣 Purple"] = {
        SkyboxBk="rbxassetid://16553658937",
        SkyboxDn="rbxassetid://16553660713",
        SkyboxFt="rbxassetid://16553662144",
        SkyboxLf="rbxassetid://16553664042",
        SkyboxRt="rbxassetid://16553665766",
        SkyboxUp="rbxassetid://16553667750"
    },
    ["🌠 Aurora"] = {
        SkyboxBk="rbxassetid://128600713462148",
        SkyboxDn="rbxassetid://129205524771926",
        SkyboxFt="rbxassetid://91295549823939",
        SkyboxLf="rbxassetid://78049621027692",
        SkyboxRt="rbxassetid://97339481871314",
        SkyboxUp="rbxassetid://85412515491070"
    },
    ["🟠 Orange"] = {
        SkyboxBk="rbxassetid://75806894209584",
        SkyboxDn="rbxassetid://88955070832523",
        SkyboxFt="rbxassetid://137588397191887",
        SkyboxLf="rbxassetid://124955584991258",
        SkyboxRt="rbxassetid://140343245463200",
        SkyboxUp="rbxassetid://134383800716949"
    },
    ["🌙 Moonlight"] = {
        SkyboxBk="rbxassetid://116261899350523",
        SkyboxDn="rbxassetid://92257816837512",
        SkyboxFt="rbxassetid://108326981730305",
        SkyboxLf="rbxassetid://131834280163741",
        SkyboxRt="rbxassetid://99525277797873",
        SkyboxUp="rbxassetid://125425274451894"
    },
    ["🟥 Red Sky"] = {
        SkyboxBk="rbxassetid://401664839",
        SkyboxDn="rbxassetid://401664862",
        SkyboxFt="rbxassetid://401664960",
        SkyboxLf="rbxassetid://401664881",
        SkyboxRt="rbxassetid://401664901",
        SkyboxUp="rbxassetid://401664936"
    }
}

------------------------------------------------
-- RAYFIELD
------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

------------------------------------------------
-- KEY SYSTEM (NO SAVE)
------------------------------------------------
local Window = Rayfield:CreateWindow({
   Name = "🛡️ Zentro Hub",
   LoadingTitle = "Zentro Security",
   LoadingSubtitle = "🔑 Key System",
   ConfigurationSaving = {Enabled = false},
   KeySystem = true,
   KeySettings = {
      Title = "🔑 Zentro Key",
      Subtitle = "Enter Key",
      Note = "Key wird nicht gespeichert",
      FileName = "NoKeySave",
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"notruf2good"}
   }
})

-- Activity Log wenn Key richtig
sendActivityLog()

------------------------------------------------
-- FUNCTIONS
------------------------------------------------
local function applySkybox(data)
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    local sky = Instance.new("Sky")
    for k,v in pairs(data) do
        sky[k] = v
    end
    sky.Parent = Lighting
end

------------------------------------------------
-- MAIN TAB
------------------------------------------------
local MainTab = Window:CreateTab("🏠 Main", 4483345998)

MainTab:CreateToggle({
   Name = "🌙 Night Vision",
   CurrentValue = false,
   Callback = function(state)
      local cc = Lighting:FindFirstChild("NightVision")
      if state then
         if not cc then
            cc = Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "NightVision"
            cc.Brightness = 0.3
            cc.TintColor = Color3.fromRGB(100,255,100)
         end
      else
         if cc then cc:Destroy() end
      end
   end
})

MainTab:CreateButton({
   Name = "🚀 FPS Boost",
   Callback = function()
      Lighting.GlobalShadows = false
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
   end
})

MainTab:CreateButton({
   Name = "☁️ Remove Sky",
   Callback = function()
      for _,v in pairs(Lighting:GetChildren()) do
         if v:IsA("Sky") then v:Destroy() end
      end
   end
})

------------------------------------------------
-- SKY CONTROL
------------------------------------------------
local SkyTab = Window:CreateTab("⏰ Sky Control", 4483345998)

SkyTab:CreateButton({Name="☀️ Day", Callback=function() Lighting.ClockTime = 14 end})
SkyTab:CreateButton({Name="🌙 Night", Callback=function() Lighting.ClockTime = 0 end})
SkyTab:CreateButton({Name="🌇 Sunset", Callback=function() Lighting.ClockTime = 18 end})

------------------------------------------------
-- SKY SELECT
------------------------------------------------
local SkySelectTab = Window:CreateTab("🌌 Sky Selection", 4483345998)

for name,data in pairs(Skyboxes) do
    SkySelectTab:CreateButton({
        Name = name,
        Callback = function()
            applySkybox(data)
        end
    })
end
