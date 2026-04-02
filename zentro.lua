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
local logWebhook = "DEIN WEBHOOK"

local function sendSauberLog(aktion)
    local embed = {
        username = "Zentro Security System",
        embeds = {{
            title = "⚠️ ZENTRO ACTIVITY LOG",
            color = 16753920,
            fields = {
                {name="USER", value=player.Name, inline=true},
                {name="USER ID", value=tostring(player.UserId), inline=true},
                {name="ACTION", value=aktion, inline=false}
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
-- KEY SYSTEM (IMMER NEU EINGEBEN)
------------------------------------------------
local key = "notruf2good"

local Window = Rayfield:CreateWindow({
   Name = "Zentro Hub",
   LoadingTitle = "Zentro Security",
   LoadingSubtitle = "Key System",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ZentroHub",
      FileName = "Settings"
   },
   KeySystem = true,
   KeySettings = {
      Title = "Zentro Key",
      Subtitle = "Enter Key",
      Note = "Key bekommst du vom Owner",
      FileName = "ZentroKey",
      SaveKey = false, -- WICHTIG → muss immer neu eingegeben werden
      GrabKeyFromSite = false,
      Key = {key}
   }
})

sendSauberLog("Key erfolgreich eingegeben")

------------------------------------------------
-- TAB
------------------------------------------------
local MainTab = Window:CreateTab("Main", 4483345998)

------------------------------------------------
-- BUTTONS
------------------------------------------------

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

MainTab:CreateButton({
   Name = "Remove Sky",
   Callback = function()
      for _,v in pairs(Lighting:GetChildren()) do
         if v:IsA("Sky") then v:Destroy() end
      end
      sendSauberLog("Remove Sky benutzt")
   end
})

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

MainTab:CreateButton({
   Name = "Weather Clear",
   Callback = function()
      Lighting.ClockTime = 12
      sendSauberLog("Weather Clear benutzt")
   end
})

MainTab:CreateButton({
   Name = "Join Discord",
   Callback = function()
      if setclipboard then
         setclipboard("https://discord.gg/sNmkBMrTJn")
      end
      sendSauberLog("Discord Link kopiert")
   end
})
