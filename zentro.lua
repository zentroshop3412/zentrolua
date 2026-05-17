local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local guiParent = player:WaitForChild("PlayerGui")

-- Bereinige alte Versionen
if guiParent:FindFirstChild("NEXUS_V3_ULTRA") then
	guiParent["NEXUS_V3_ULTRA"]:Destroy()
end

------------------------------------------------
-- CONFIGURATION & STYLING
------------------------------------------------
local Config = {
	AimbotEnabled = false,
	AimbotSmoothness = 1,
	TeamCheck = false,
	AimbotFOV = 100, -- Standard FOV Größe
	ShowFOV = true
}

local Theme = {
	MainBG = Color3.fromRGB(11, 11, 18),
	SidebarBG = Color3.fromRGB(16, 16, 26),
	Accent = Color3.fromRGB(0, 190, 255),
	AccentGlow = Color3.fromRGB(0, 100, 255),
	ButtonBG = Color3.fromRGB(24, 24, 37),
	ButtonHover = Color3.fromRGB(35, 35, 55),
	TextMain = Color3.fromRGB(255, 255, 255),
	TextDark = Color3.fromRGB(150, 155, 170),
	FontBold = Enum.Font.BuilderSansBold,
	FontMedium = Enum.Font.BuilderSansMedium
}

------------------------------------------------
-- SKYBOX DATA (Inklusive Blue & Night)
------------------------------------------------
local Skyboxes = {
	["🔵 lightgrey"] = {
		SkyboxBk="rbxassetid://600830446", SkyboxDn="rbxassetid://600831635", SkyboxFt="rbxassetid://600832720", SkyboxLf="rbxassetid://600886090", SkyboxRt="rbxassetid://600833862", SkyboxUp="rbxassetid://600835177"
	},
	["⭐ Night"] = {
		SkyboxBk="rbxassetid://12064152", SkyboxDn="rbxassetid://12064152", SkyboxFt="rbxassetid://12064152", SkyboxLf="rbxassetid://12064152", SkyboxRt="rbxassetid://12064152", SkyboxUp="rbxassetid://12064152"
	},
	["🟣 Purple"] = {
		SkyboxBk="rbxassetid://16553658937", SkyboxDn="rbxassetid://16553660713", SkyboxFt="rbxassetid://16553662144", SkyboxLf="rbxassetid://16553664042", SkyboxRt="rbxassetid://16553665766", SkyboxUp="rbxassetid://16553667750"
	},
	["🌠 Aurora"] = {
		SkyboxBk="rbxassetid://128600713462148", SkyboxDn="rbxassetid://129205524771926", SkyboxFt="rbxassetid://91295549823939", SkyboxLf="rbxassetid://78049621027692", SkyboxRt="rbxassetid://97339481871314", SkyboxUp="rbxassetid://85412515491070"
	},
	["🟠 Orange"] = {
		SkyboxBk="rbxassetid://75806894209584", SkyboxDn="rbxassetid://88955070832523", SkyboxFt="rbxassetid://137588397191887", SkyboxLf="rbxassetid://124955584991258", SkyboxRt="rbxassetid://140343245463200", SkyboxUp="rbxassetid://134383800716949"
	},
	["🌙 Moonlight"] = {
		SkyboxBk="rbxassetid://116261899350523", SkyboxDn="rbxassetid://92257816837512", SkyboxFt="rbxassetid://108326981730305", SkyboxLf="rbxassetid://131834280163741", SkyboxRt="rbxassetid://99525277797873", SkyboxUp="rbxassetid://125425274451894"
	},
	["🟥 Red Sky"] = {
		SkyboxBk="rbxassetid://401664839", SkyboxDn="rbxassetid://401664862", SkyboxFt="rbxassetid://401664960", SkyboxLf="rbxassetid://401664881", SkyboxRt="rbxassetid://401664901", SkyboxUp="rbxassetid://401664936"
	}
}

------------------------------------------------
-- CORE SCREEN GUI & VISUAL FOV RING
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "NEXUS_V3_ULTRA"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = guiParent

-- Visueller FOV Kreis für den Aimbot
local fovRing = Instance.new("Frame")
fovRing.AnchorPoint = Vector2.new(0.5, 0.5)
fovRing.BackgroundColor3 = Theme.Accent
fovRing.BackgroundTransparency = 1
fovRing.Size = UDim2.new(0, Config.AimbotFOV * 2, 0, Config.AimbotFOV * 2)
fovRing.Position = UDim2.new(0.5, 0, 0.5, 0)
fovRing.Visible = Config.ShowFOV
fovRing.Parent = gui

local fovCorner = Instance.new("UICorner", fovRing)
fovCorner.CornerRadius = UDim.new(1, 0)

local fovStroke = Instance.new("UIStroke", fovRing)
fovStroke.Color = Theme.Accent
fovStroke.Thickness = 1
fovStroke.Transparency = 0.5

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 850, 0, 500)
main.Position = UDim2.new(0.5, -425, 0.5, -250)
main.BackgroundColor3 = Theme.MainBG
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = Theme.Accent
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.3

------------------------------------------------
-- SMOOTH DRAG SYSTEM
------------------------------------------------
local function enableSmoothDrag(frame, handle)
	local dragging, dragInput, dragStart, startPosition
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true; dragStart = input.Position; startPosition = frame.Position
			input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
		end
	end)
	handle.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput then
			local delta = input.Position - dragStart
			local targetPos = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
			TweenService:Create(frame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
		end
	end)
end

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 50); top.BackgroundTransparency = 1; top.Parent = main
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0); title.Position = UDim2.new(0, 20, 0, 0); title.BackgroundTransparency = 1
title.Text = "NEXUS HUB <font color='rgb(0, 190, 255)'>v3 ULTRA</font>"
title.RichText = true; title.Font = Theme.FontBold; title.TextSize = 22; title.TextColor3 = Theme.TextMain; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = top
enableSmoothDrag(main, top)

------------------------------------------------
-- NOTIFICATION SYSTEM (STACKABLE)
------------------------------------------------
local notifyContainer = Instance.new("Frame")
notifyContainer.Size = UDim2.new(0, 300, 1, -20); notifyContainer.Position = UDim2.new(1, -310, 0, 10); notifyContainer.BackgroundTransparency = 1; notifyContainer.Parent = gui
local notifyLayout = Instance.new("UIListLayout", notifyContainer)
notifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom; notifyLayout.SortOrder = Enum.SortOrder.LayoutOrder; notifyLayout.Padding = UDim.new(0, 10)

local function notify(txt)
	local n = Instance.new("Frame")
	n.Size = UDim2.new(1, 0, 0, 50); n.BackgroundColor3 = Theme.SidebarBG; n.BackgroundTransparency = 1; n.Parent = notifyContainer
	Instance.new("UICorner", n).CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke", n); s.Color = Theme.Accent; s.Thickness = 1; s.Transparency = 1
	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -20, 1, 0); t.Position = UDim2.new(0, 10, 0, 0); t.BackgroundTransparency = 1
	t.Text = txt; t.Font = Theme.FontMedium; t.TextSize = 14; t.TextColor3 = Theme.TextMain; t.TextXAlignment = Enum.TextXAlignment.Left; t.TextTransparency = 1; t.Parent = n
	TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
	TweenService:Create(s, TweenInfo.new(0.3), {Transparency = 0.4}):Play()
	TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	task.delay(3, function()
		if n then
			TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(s, TweenInfo.new(0.3), {Transparency = 1}):Play()
			TweenService:Create(t, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
			task.wait(0.3); if n then n:Destroy() end
		end
	end)
end

------------------------------------------------
-- SIDEBAR & AUTOMATIC PAGES
------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 200, 1, -50); sidebar.Position = UDim2.new(0, 0, 0, 50); sidebar.BackgroundColor3 = Theme.SidebarBG; sidebar.Parent = main
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 12)
local sidebarFix = Instance.new("Frame", sidebar)
sidebarFix.Size = UDim2.new(1, 0, 0, 15); sidebarFix.BackgroundColor3 = Theme.SidebarBG; sidebarFix.BorderSizePixel = 0
local sidebarLayout = Instance.new("UIListLayout", sidebar)
sidebarLayout.Padding = UDim.new(0, 6); sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Instance.new("UIPadding", sidebar).PaddingTop = UDim.new(0, 15)

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -215, 1, -65); contentContainer.Position = UDim2.new(0, 210, 0, 55); contentContainer.BackgroundTransparency = 1; contentContainer.Parent = main

local pages = {}
local tabButtons = {}
local activePage = nil

local function createPage(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, 0); scroll.BackgroundTransparency = 1; scroll.Visible = false
	scroll.ScrollBarThickness = 3; scroll.ScrollBarImageColor3 = Theme.Accent; scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.Parent = contentContainer
	local layout = Instance.new("UIListLayout", scroll)
	layout.Padding = UDim.new(0, 10); layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 20) end)
	pages[name] = scroll
	return scroll
end

local function switchTab(name)
	for pageName, pageFrame in pairs(pages) do
		if pageName == name then
			pageFrame.Visible = true; pageFrame.Size = UDim2.new(1, 0, 1, 20)
			TweenService:Create(pageFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {Size = UDim2.new(1, 0, 1, 0)}):Play()
		else pageFrame.Visible = false end
	end
	for btnName, btn in pairs(tabButtons) do
		if btnName == name then TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonHover, TextColor3 = Theme.Accent}):Play()
		else TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SidebarBG, TextColor3 = Theme.TextDark}):Play() end
	end
end

local function createTabButton(text, pageName)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 180, 0, 40); b.Text = "  " .. text; b.Font = Theme.FontMedium; b.TextSize = 14
	b.TextColor3 = Theme.TextDark; b.BackgroundColor3 = Theme.SidebarBG; b.TextXAlignment = Enum.TextXAlignment.Left; b.Parent = sidebar
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
	tabButtons[pageName] = b
	b.MouseEnter:Connect(function() if activePage ~= pageName then TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonBG, TextColor3 = Theme.TextMain}):Play() end end)
	b.MouseLeave:Connect(function() if activePage ~= pageName then TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.SidebarBG, TextColor3 = Theme.TextDark}):Play() end end)
	b.MouseButton1Click:Connect(function() activePage = pageName; switchTab(pageName); notify("Tab: " .. pageName) end)
end

------------------------------------------------
-- PREMIUM UI COMPONENTS (BUTTON, TOGGLE, SLIDER)
------------------------------------------------
local function createActionButton(parent, text, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1, -10, 0, 45); b.Text = text; b.Font = Theme.FontBold; b.TextSize = 14
	b.TextColor3 = Theme.TextMain; b.BackgroundColor3 = Theme.ButtonBG; b.Parent = parent
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", b); stroke.Color = Theme.Accent; stroke.Thickness = 1; stroke.Transparency = 0.8
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonHover}):Play(); TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Theme.ButtonBG}):Play(); TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.8}):Play() end)
	b.MouseButton1Down:Connect(function() TweenService:Create(b, TweenInfo.new(0.05), {Size = UDim2.new(1, -15, 0, 42)}):Play() end)
	b.MouseButton1Up:Connect(function() TweenService:Create(b, TweenInfo.new(0.1), {Size = UDim2.new(1, -10, 0, 45)}):Play(); func(); notify("Executed: " .. text) end)
end

local function createToggle(parent, text, default, callback)
	local state = default
	local tFrame = Instance.new("Frame")
	tFrame.Size = UDim2.new(1, -10, 0, 50); tFrame.BackgroundColor3 = Theme.ButtonBG; tFrame.Parent = parent
	Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", tFrame); stroke.Color = Theme.Accent; stroke.Thickness = 1; stroke.Transparency = 0.8
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -70, 1, 0); label.Position = UDim2.new(0, 15, 0, 0); label.BackgroundTransparency = 1
	label.Text = text; label.Font = Theme.FontMedium; label.TextSize = 14; label.TextColor3 = Theme.TextMain; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = tFrame
	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 45, 0, 24); switch.Position = UDim2.new(1, -60, 0.5, -12); switch.BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40, 40, 55); switch.Text = ""; switch.Parent = tFrame
	Instance.new("UICorner", switch).CornerRadius = UDim.new(1, 0)
	local dot = Instance.new("Frame")
	dot.Size = UDim2.new(0, 18, 0, 18); dot.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9); dot.BackgroundColor3 = Color3.new(1, 1, 1); dot.Parent = switch
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	switch.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(40, 40, 55)}):Play()
		TweenService:Create(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
		callback(state)
		notify(text .. ": " .. (state and "ON" or "OFF"))
	end)
end

local function createSlider(parent, text, min, max, default, callback)
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Size = UDim2.new(1, -10, 0, 65); sliderFrame.BackgroundColor3 = Theme.ButtonBG; sliderFrame.Parent = parent
	Instance.new("UICorner", sliderFrame).CornerRadius = UDim.new(0, 8)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -30, 0, 30); label.Position = UDim2.new(0, 15, 0, 5); label.BackgroundTransparency = 1
	label.Text = text .. ": " .. tostring(default); label.Font = Theme.FontMedium; label.TextSize = 14; label.TextColor3 = Theme.TextMain; label.TextXAlignment = Enum.TextXAlignment.Left; label.Parent = sliderFrame
	local container = Instance.new("TextButton")
	container.Size = UDim2.new(1, -30, 0, 6); container.Position = UDim2.new(0, 15, 0, 45); container.BackgroundColor3 = Color3.fromRGB(40, 40, 55); container.Text = ""; container.Parent = sliderFrame
	Instance.new("UICorner", container)
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Theme.Accent; fill.Parent = container
	Instance.new("UICorner", fill)
	local trigger = Instance.new("TextButton")
	trigger.Size = UDim2.new(0, 14, 0, 14); trigger.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7); trigger.BackgroundColor3 = Theme.TextMain; trigger.Text = ""; trigger.Parent = container
	Instance.new("UICorner", trigger); Instance.new("UIStroke", trigger).Color = Theme.Accent
	local dragging = false
	local function updateSlider()
		local mousePos = UserInputService:GetMouseLocation().X
		local barPos = container.AbsolutePosition.X
		local barWidth = container.AbsoluteSize.X
		local percentage = math.clamp((mousePos - barPos) / barWidth, 0, 1)
		local value = math.floor(min + (max - min) * percentage)
		label.Text = text .. ": " .. tostring(value)
		fill.Size = UDim2.new(percentage, 0, 1, 0)
		trigger.Position = UDim2.new(percentage, -7, 0.5, -7)
		callback(value)
	end
	trigger.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
	UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
	UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then updateSlider() end end)
end

------------------------------------------------
-- CAMERA BASED AIMBOT ENGINE (NO MOUSE MOVEMENT)
------------------------------------------------
local function getClosestPlayerToCenter()
	local closestTarget = nil
	local shortestDistance = Config.AimbotFOV -- Filtert automatisch nach Zielen im FOV-Radius

	for _, v in pairs(Players:GetPlayers()) do
		if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
			if Config.TeamCheck and v.Team == player.Team then continue end
			
			local screenPos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
			if onScreen then
				local screenSize = camera.ViewportSize
				local center = Vector2.new(screenSize.X / 2, screenSize.Y / 2)
				local distance = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
				
				if distance < shortestDistance then
					closestTarget = v
					shortestDistance = distance
				end
			end
		end
	end
	return closestTarget
end

RunService.RenderStepped:Connect(function()
	-- Hält den FOV Ring exakt in der Mitte des Bildschirms zentriert
	local screenSize = camera.ViewportSize
	fovRing.Position = UDim2.new(0, screenSize.X / 2, 0, screenSize.Y / 2)

	if Config.AimbotEnabled then
		local target = getClosestPlayerToCenter()
		if target and target.Character and target.Character:FindFirstChild("Head") then
			-- Kameraausrichtung (Smooth über CFrame anstatt die Maus zu bewegen)
			local targetCFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
			camera.CFrame = camera.CFrame:Lerp(targetCFrame, 1 / Config.AimbotSmoothness)
		end
	end
end)

------------------------------------------------
-- GENERATE TABS & PAGES
------------------------------------------------
local Home = createPage("Home")
local AimbotTab = createPage("Aimbot")
local Visual = createPage("Visual")
local SkinchangerTab = createPage("Skinchanger")
local SkyboxTab = createPage("Skybox")
local PlayerTab = createPage("Player")
local Settings = createPage("Settings")
local Discord = createPage("Discord")

createTabButton("HOME", "Home")
createTabButton("AIMBOT", "Aimbot")
createTabButton("VISUALS", "Visual")
createTabButton("SKINCHANGER", "Skinchanger")
createTabButton("SKYBOX", "Skybox")
createTabButton("PLAYER", "Player")
createTabButton("SETTINGS", "Settings")
createTabButton("DISCORD", "Discord")

-- 1. Home Module
local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, 0, 0, 35); welcome.BackgroundTransparency = 1; welcome.Text = "Welcome to NEXUS HUB v3"; welcome.Font = Theme.FontBold; welcome.TextSize = 24; welcome.TextColor3 = Theme.TextMain; welcome.TextXAlignment = Enum.TextXAlignment.Left; welcome.Parent = Home

-- 2. Aimbot Module
createToggle(AimbotTab, "Enable Aimbot", false, function(state) Config.AimbotEnabled = state end)
createSlider(AimbotTab, "Aimbot Smoothness", 1, 15, 1, function(val) Config.AimbotSmoothness = val end)
createSlider(AimbotTab, "Aimbot FOV Size", 30, 500, 100, function(val) 
	Config.AimbotFOV = val 
	fovRing.Size = UDim2.new(0, val * 2, 0, val * 2)
end)
createToggle(AimbotTab, "Show FOV Ring", true, function(state) 
	Config.ShowFOV = state 
	fovRing.Visible = state
end)
createToggle(AimbotTab, "Team Check", false, function(state) Config.TeamCheck = state end)

-- 3. Visuals Module
createSlider(Visual, "Field of View (FOV)", 30, 120, 70, function(value) camera.FieldOfView = value end)
createActionButton(Visual, "FULLBRIGHT", function() Lighting.Brightness = 3; Lighting.ClockTime = 14; Lighting.GlobalShadows = false end)
createToggle(Visual, "Night Vision", false, function(state)
	if state then
		Lighting.Ambient = Color3.fromRGB(160, 160, 200)
		if not Lighting:FindFirstChild("NEXUS_NV") then
			local nv = Instance.new("ColorCorrectionEffect", Lighting)
			nv.Name = "NEXUS_NV"; nv.Brightness = 0.2; nv.Contrast = 0.3
		end
	else
		Lighting.Ambient = Color3.fromRGB(128, 128, 128)
		if Lighting:FindFirstChild("NEXUS_NV") then Lighting["NEXUS_NV"]:Destroy() end
	end
end)

-- 4. Skinchanger Module
createActionButton(SkinchangerTab, "Equip Classic Suit", function()
	local char = player.Character
	if char then
		for _, obj in pairs(char:GetChildren()) do
			if obj:IsA("Shirt") or obj:IsA("Pants") then obj:Destroy() end
		end
		local shirt = Instance.new("Shirt", char)
		shirt.ShirtTemplate = "rbxassetid://382538081"
		local pants = Instance.new("Pants", char)
		pants.PantsTemplate = "rbxassetid://382537433"
	end
end)
createActionButton(SkinchangerTab, "Clear Accessories (FPS Boost)", function()
	local char = player.Character
	if char then
		for _, obj in pairs(char:GetChildren()) do if obj:IsA("Accessory") then obj:Destroy() end end
	end
end)

-- 5. Skybox Module
createActionButton(SkyboxTab, "♻️ Reset Skybox to Default", function()
	for _, v in pairs(Lighting:GetChildren()) do 
		if v:IsA("Sky") then v:Destroy() end 
	end
end)

for skyName, skyData in pairs(Skyboxes) do
	createActionButton(SkyboxTab, "Apply " .. skyName, function()
		for _, v in pairs(Lighting:GetChildren()) do 
			if v:IsA("Sky") then v:Destroy() end 
		end
		
		local s = Instance.new("Sky", Lighting)
		s.SkyboxBk = skyData.SkyboxBk
		s.SkyboxDn = skyData.SkyboxDn
		s.SkyboxFt = skyData.SkyboxFt
		s.SkyboxLf = skyData.SkyboxLf
		s.SkyboxRt = skyData.SkyboxRt
		s.SkyboxUp = skyData.SkyboxUp
	end)
end

-- 6. Player Module
createActionButton(PlayerTab, "RESET CHARACTER", function() player:LoadCharacter() end)

-- 7. Settings Module
createActionButton(Settings, "RESET UI", function()
	if Lighting:FindFirstChild("NEXUS_NV") then Lighting["NEXUS_NV"]:Destroy() end
	gui:Destroy()
end)

-- 8. Discord Module
local discordText = Instance.new("TextLabel")
discordText.Size = UDim2.new(1, -10, 0, 100); discordText.BackgroundColor3 = Theme.ButtonBG; discordText.Font = Theme.FontMedium; discordText.TextSize = 15; discordText.TextColor3 = Theme.TextMain; discordText.Text = "Need support or updates?\n\nJoin our official community:\ndsc.gg/ehnexus"; discordText.Parent = Discord
Instance.new("UICorner", discordText).CornerRadius = UDim.new(0, 8); Instance.new("UIStroke", discordText).Color = Theme.Accent

------------------------------------------------
-- INITIAL LOAD EXECUTED
------------------------------------------------
activePage = "Home"
switchTab("Home")
notify("NEXUS HUB v3 ULTRA INITIALIZED")
