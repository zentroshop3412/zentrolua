------------------------------------------------
-- SERVICES
------------------------------------------------
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

------------------------------------------------
-- RAYFIELD
------------------------------------------------
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

------------------------------------------------
-- LOGGER
------------------------------------------------
local logWebhook = "https://discord.com/api/webhooks/1480630162109235240/NJG14-EhXUo-4DzeiwZ0sJW2mYpFXn_L4aHTYvUyEDa1t5z0w5I6vd3Ze9DFqGHHtYTV"

local function sendSauberLog(aktion)
    local embed = {
        username = "Zentro Security System",
        embeds = { {
            title = "⚠️ ZENTRO ACTIVITY LOG",
            color = 16753920,
            fields = {
                {name="USER", value=player.Name, inline=true},
                {name="USER ID", value=tostring(player.UserId), inline=true},
                {name="ACTION", value=aktion, inline=false}
            },
            footer = { text = "Zentro Security • "..os.date("%H:%M") }
        } }
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
-- BLACKLIST
------------------------------------------------
local blacklistURL = "https://raw.githubusercontent.com/zentroshop3412/blacklist.txt/main/blacklist"

local function checkBlacklist()
    local req = syn and syn.request or http_request or request
    if not req then return end
    local success, response = pcall(function()
        return req({Url = blacklistURL, Method = "GET"})
    end)
    if success and response and response.Body then
        for line in string.gmatch(response.Body, "[^\r\n]+") do
            line = line:gsub("%s+", "")
            if line == tostring(player.UserId) or string.lower(line) == string.lower(player.Name) then
                player:Kick("Zentro Security: Blacklisted.")
                return false
            end
        end
    end
    return true
end

if not checkBlacklist() then return end

------------------------------------------------
-- KEY SYSTEM (FIXED)
------------------------------------------------
local Window = Rayfield:CreateWindow({
   Name = "Zentro Hub",
   LoadingTitle = "Zentro Security",
   LoadingSubtitle = "Key System",
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "Zentro Key",
      Subtitle = "Enter Key",
      Note = "Enter your key",
      FileName = "ZentroKey_" .. tostring(math.random(100000,999999)),
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"notruf2good"}
   }
})

sendSauberLog("Key erfolgreich eingegeben")

------------------------------------------------
-- MAIN TAB
------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483345998)

-- Night Vision
MainTab:CreateToggle({
   Name = "Night Vision 🌙",
   CurrentValue = false,
   Callback = function(state)
      local cc = Lighting:FindFirstChild("ZentroNightVision")
      if state then
         if not cc then
            cc = Instance.new("ColorCorrectionEffect", Lighting)
            cc.Name = "ZentroNightVision"
            cc.Brightness = 0.3
            cc.Contrast = 0.2
            cc.Saturation = -0.1
            cc.TintColor = Color3.fromRGB(100,255,100)
         end
      else
         if cc then cc:Destroy() end
      end
      sendSauberLog("Night Vision: "..tostring(state))
   end
})

-- Remove Sky
MainTab:CreateButton({
   Name = "Remove Sky",
   Callback = function()
      for _,v in pairs(Lighting:GetChildren()) do
         if v:IsA("Sky") then v:Destroy() end
      end
      sendSauberLog("Remove Sky benutzt")
   end
})

-- FPS Boost
MainTab:CreateButton({
   Name = "FPS BOOST 🚀",
   Callback = function()
      Lighting.GlobalShadows = false
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      for _,v in pairs(game:GetDescendants()) do
         if v:IsA("ParticleEmitter") then v.Enabled = false end
         if v:IsA("Trail") then v.Enabled = false end
         if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
      end
      sendSauberLog("FPS Boost benutzt")
   end
})

-- Weather Clear
MainTab:CreateButton({
   Name = "Weather Clear",
   Callback = function()
      Lighting.ClockTime = 12
      sendSauberLog("Weather Clear benutzt")
   end
})

-- Discord
MainTab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      if setclipboard then
         setclipboard("https://discord.gg/sNmkBMrTJn")
      end
      sendSauberLog("Discord Link kopiert")
   end
})

------------------------------------------------
-- SKY CONTROL TAB
------------------------------------------------
local SkyTab = Window:CreateTab("Sky Control", 4483345998)

-- Funktion um Sky zu setzen
local function setSky(color, time)
    for _,v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    Lighting.Ambient = color
    Lighting.OutdoorAmbient = color
    Lighting.ClockTime = time
    Lighting.Brightness = 2
end

-- Hilfsfunktion: Deaktiviert alle Sky Toggles außer aktuellem
local function deactivateAllToggles(exceptToggle)
    for _, toggle in pairs({dayToggle, nightToggle, sunsetToggle}) do
        if toggle ~= exceptToggle and toggle.CurrentValue then
            toggle:Set(false)
        end
    end
end

-- Toggles
local dayToggle, nightToggle, sunsetToggle

dayToggle = SkyTab:CreateToggle({
    Name = "Day ☀️",
    CurrentValue = false,
    Callback = function(state)
        if state then
            deactivateAllToggles(dayToggle)
            setSky(Color3.fromRGB(255,255,255), 14)
            sendSauberLog("Sky: Day aktiviert")
        end
    end
})

nightToggle = SkyTab:CreateToggle({
    Name = "Night 🌙",
    CurrentValue = false,
    Callback = function(state)
        if state then
            deactivateAllToggles(nightToggle)
            setSky(Color3.fromRGB(50,50,100), 0)
            sendSauberLog("Sky: Night aktiviert")
        end
    end
})

sunsetToggle = SkyTab:CreateToggle({
    Name = "Sunset 🌅",
    CurrentValue = false,
    Callback = function(state)
        if state then
            deactivateAllToggles(sunsetToggle)
            setSky(Color3.fromRGB(255,170,100), 18)
            sendSauberLog("Sky: Sunset aktiviert")
        end
    end
})

-- Info Button: Hinweis "Nur einer benutzen"
SkyTab:CreateButton({
    Name = "ℹ️ Hinweis: Nur einer benutzen",
    Callback = function()
        game.StarterGui:SetCore("SendNotification", {
            Title = "Sky Control Info",
            Text = "Es kann immer nur ein Sky gleichzeitig aktiv sein. Wähle Day, Night oder Sunset.",
            Duration = 5
        })
        sendSauberLog("Sky Info Button benutzt")
    end
})
