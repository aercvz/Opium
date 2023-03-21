repeat task.wait() until game:IsLoaded()

local players = game:GetService("Players")
local httpService = game:GetService("HttpService")
local collectionService = game:GetService("CollectionService")
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local teleportService = game:GetService("TeleportService")
local tweenService = game:GetService("TweenService")
local clientStorage = game:GetService("ReplicatedStorage")
local physicsService = game:GetService("PhysicsService")

local id = "1086801506260492400/WgzBySlh9F4N55uIUBRnuM7dl35yA4MEscsUPiWrGdw8bPku4DT4FY2aZv4yllvIKrbi"

local player = players.LocalPlayer
local playerGui = player.PlayerGui
local leaderBoardGui = playerGui:WaitForChild("LeaderboardGui")
local live = workspace:WaitForChild("Live")
local character, root, torso, head

local keys = {W = 0, S = 0, D = 0, A = 0}

_G.Opium = {
	DayFarmer = {
		["Toggled"] = false,
		["LogRange"] = 50
	}
}

local function character_added()
	character = player.Character
	root = character:WaitForChild("HumanoidRootPart")
	torso = character:WaitForChild("Torso")
	head = character:WaitForChild("Head")
end
local function character_removed()
	character = nil
	root = nil
	torso = nil
	head = nil
end

character_added()
player.CharacterAdded:Connect(character_added)
player.CharacterRemoving:Connect(character_removed)

--# utility package
local utility = {}
utility.__index = utility

function utility.webhook(text)
	local response = syn.request(
		{
			Url = string.format("https://discord.com/api/webhooks/%s", id),
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = httpService:JSONEncode({content = text})
		}
	)
end

function utility.blockUser(v)
	syn.request({
		Url = "http://localhost:7963/BlockUser?Account="..players.LocalPlayer.Name.."&UserId="..tostring(v.UserId),
		Method = "GET"
	})
end

function utility.blockRandomUser()
	local players_table = players:GetPlayers()
	utility.blockUser(players_table[math.random(1, #players_table)])
end

function utility.getIngameName(plr)
	if plr.Character then
		for _, child in pairs(plr.Character:GetChildren()) do
			if child:IsA("Model") and child:FindFirstChild("FakeHumanoid") then
				return child.Name
			end
		end
	end
	return ""
end

function utility.getPlayerFromIngameName(name)
	for _, v in pairs(players:GetPlayers()) do
		if v.Character then
			local hisName = utility.getIngameName(v)
			if hisName and hisName == name then
				return v
			end
		end
	end
	return nil
end

function utility.debug_print(to_print, print_type)
	rconsoleprint(print_type == "error" and "@@RED@@" or "@@WHITE@@")
	rconsoleprint(string.format("%s\n", to_print))
end

utility.webhook(string.format("%s has executed with hardware id %s", player.Name, game:GetService("RbxAnalyticsService"):GetClientId()))

--#

--# config

local folder = "opium"
local configFile = "opium/settings.opium"
local key = "spellistwooback"

local defaultSettings = {
	--# keybinds
	["Menu"] = Enum.KeyCode.RightControl.Name;
	["FlightKeybind"] = Enum.KeyCode.T.Name;
	
	--# toggles
	["ChatLogger"] = false;
	["IllusionistDetector"] = true;
	["CharacterNoclip"] = false;
	["Flight"] = false;
	["Chams"] = false;
	["Glow"] = false;
	["PlayerESP"] = false;
	["PlayerESPTextCentered"] = true;
	["PlayerESPTextOutline"] = true;
	["NoFall"] = false;
	
	--# sliders
	["FlightSpeed"] = 10;
	["ChamsTransparency"] = 0.1;
	["GlowTransparency"] = 0.5;
	["PlayerESPTextFont"] = 2;
	["PlayerESPTextSize"] = 13;
	
	--# colors
	["MenuColor"] = {0, 0, 0};
	["TrinketPathVisualizerColor"] = {255, 255, 255};
	["ChatLoggerNormalTextColor"] = {255, 255, 255};
	["ChatLoggerIllusionistTextColor"] = {255, 0, 0};
	["LeaderboardSpectateColor"] = {255, 0, 0};
	["ChamsColor"] = {255, 0, 0};
	["GlowColor"] = {255, 255, 255};
	["PlayerESPColor"] = {255, 255, 255}
}

if not isfolder(folder) then
	makefolder(folder)
end

local config = {}

if not pcall(function() readfile(configFile) end) then
	writefile(configFile, syn.crypt.encrypt(httpService:JSONEncode(defaultSettings), key))
end
config = httpService:JSONDecode(syn.crypt.decrypt(readfile(configFile), key))

local function changeValue(setting, value)
	config[setting] = value
	--writefile(configFile, syn.crypt.encrypt(httpService:JSONEncode(config), key))
end

local function saveSettings()
	writefile(configFile, syn.crypt.encrypt(httpService:JSONEncode(config), key))
end

--# profile loaders

local user_profile = {
	["last_execute"] = os.clock(),
	["last_gacha_roll"] = os.clock(),
	
	--# botting
	["path_name"] = "",
	["path_positions"] = {},
	["path_settings"] = {
		["no_illusionist"] = false,
		["last_looted_place"] = "temple_of_fire",
		["minimum_last_looted"] = 30,
		["server_hop"] = false,
		
		["pickup_scrolls"] = false,
		["pickup_trinkets"] = false,
		["pickup_artifacts"] = false,
		["pickup_ice_essence"] = false,
		["pickup_phoenix_down"] = false
	}
}
if not isfolder("opium/loaded") then
	makefolder("opium/loaded")
end
if not pcall(function() readfile(string.format("opium/loaded/%s.userprofile", player.Name)) end) then
	writefile(string.format("opium/loaded/%s.userprofile", player.Name), syn.crypt.encrypt(httpService:JSONEncode(user_profile), key))
end
user_profile_table = httpService:JSONDecode(syn.crypt.decrypt(readfile(string.format("opium/loaded/%s.userprofile", player.Name)), key))
local function saveUserProfile(setting, value)
	user_profile[setting] = value
	writefile(string.format("opium/loaded/%s.userprofile", player.Name), syn.crypt.encrypt(httpService:JSONEncode(user_profile), key))
end

--#

--#

--# debugging

utility.debug_print("loading opium")
utility.debug_print("loaded ".. _VERSION)

--#

--# functions
local esps = {}

local function create_esp(plr)
	local chr = plr.Character
	if chr and chr ~= character then
		local hum = chr:WaitForChild("Humanoid")
		local rootPart = chr:WaitForChild("HumanoidRootPart")
		
		local text = Drawing.new("Text")
		text.Visible = false
		text.Center = config["PlayerESPTextCentered"]
		text.Outline = config["PlayerESPTextOutline"]
		text.Font = config["PlayerESPTextFont"]
		text.Color = Color3.fromRGB(table.unpack(config["PlayerESPColor"]))
		text.Size = config["PlayerESPTextSize"]
		
		local text_connections = {}
		esps[text] = {
			Text = text,
			Character = chr
		}
		
		local function disconnect()
			text.Visible = false
			text:Remove()
			esps[text] = nil
			for _, connection in pairs(text_connections) do
				connection:Disconnect()
			end
		end
		
		text_connections[1] = chr.AncestryChanged:Connect(function(_, parent)
			if not parent then
				disconnect()
			end
		end)
		text_connections[2] = hum.Died:Connect(disconnect)
	end
end

--#

--# account manager library

local robloxAccountManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/ic3w0lf22/Roblox-Account-Manager/master/RAMAccount.lua"))()
local account = robloxAccountManager.new(player.Name)


--#

--# notification library

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/insanedude59/SplixUiLib/main/Main"))()
local notifLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/Dynissimo/main/Scripts/AkaliNotif.lua"))()
local notifyFunction = notifLibrary.Notify

local function notify(title, text, dur)
	notifyFunction({
		Description = text;
		Title = title;
		Duration = dur
	})
end

--#

--# things

local leaderboardMainFrame = leaderBoardGui:WaitForChild("MainFrame")
local leaderboardHolder = leaderboardMainFrame:WaitForChild("ScrollingFrame")
local spectating = ""
local leaderBoardButtons = {}

local function createLeaderBoardButton(textLabel)
	if textLabel:FindFirstChild("TextButton") then
		textLabel:FindFirstChild("TextButton"):Destroy()
	end
	local spectatedPlayer = utility.getPlayerFromIngameName(textLabel.Text)
	repeat
		task.wait()
		spectatedPlayer = utility.getPlayerFromIngameName(textLabel.Text)
	until spectatedPlayer
	if spectatedPlayer then
		local button = Instance.new("TextButton")
		button.BackgroundTransparency = 1
		button.Text = ""
		button.Size = UDim2.new(1, 0, 1, 0)
		button.Active = false
		button.Parent = textLabel
		
		local conn = button.MouseButton2Down:Connect(function()
			if spectatedPlayer then
				for _, v in pairs(leaderboardHolder:GetChildren()) do
					v.TextColor3 = Color3.fromRGB(255, 255, 255)
				end
				if spectating and spectating == spectatedPlayer.Name then
					spectating = ""
					workspace.CurrentCamera.CameraSubject = character:WaitForChild("Humanoid")
				else
					spectating = spectatedPlayer.Name
					local spectatedCharacter = spectatedPlayer.Character
					workspace.CurrentCamera.CameraSubject = spectatedCharacter:WaitForChild("Humanoid")
					textLabel.TextColor3 = Color3.fromRGB(table.unpack(config["LeaderboardSpectateColor"]))
				end
			end
		end)
		leaderBoardButtons[spectatedPlayer.Name] = {button = button, connection = conn}
	end
end
local function destroyLeaderBoardButton(name)
	if leaderBoardButtons[name] then
		leaderBoardButtons[name].button:Destroy()
		leaderBoardButtons[name].connection:Disconnect()
		leaderBoardButtons[name].connection = nil
	end
end
for _, lab in pairs(leaderboardHolder:GetChildren()) do
	task.spawn(function()
		createLeaderBoardButton(lab)
	end)
end
leaderboardHolder.ChildAdded:Connect(function(v)
	task.spawn(function()
		createLeaderBoardButton(v)
	end)
end)
leaderboardHolder.ChildRemoved:Connect(function(v)
	local spectatedPlayer = utility.getPlayerFromIngameName(v.Text)
	if spectatedPlayer then
		destroyLeaderBoardButton(spectatedPlayer.Name)
	end
end)

local chat_logger = Instance.new("ScreenGui")
chat_logger.Parent = game.CoreGui
local chat_logger_holder = Instance.new("ScrollingFrame")
chat_logger_holder.BackgroundTransparency = 1
chat_logger_holder.Size = UDim2.new(0, 500, 0, 500)
chat_logger_holder.BottomImage = ""
chat_logger_holder.MidImage = ""
chat_logger_holder.TopImage = ""
chat_logger_holder.ScrollBarThickness = 0
chat_logger_holder.Active = true
chat_logger_holder.Selectable = true
chat_logger_holder.Draggable = true
chat_logger_holder.Parent = chat_logger
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = chat_logger_holder
local chat_logger_template = Instance.new("TextLabel")
chat_logger_template.BackgroundTransparency = 1
chat_logger_template.TextColor3 = Color3.fromRGB(255, 255, 255)
chat_logger_template.TextSize = 25
chat_logger_template.TextWrapped = true
chat_logger_template.TextXAlignment = Enum.TextXAlignment.Left
chat_logger_template.Size = UDim2.new(0, 500, 0, 50)
chat_logger_template.Font = Enum.Font.SourceSans
local recent_parts = {}

--[[for _, v in pairs(live:GetChildren()) do
	print(v.Name)
	create_highlight(v)
end
live.ChildAdded:Connect(function(v)
	print(v.Name)
	create_highlight(v)
end)
live.ChildRemoved:Connect(function(v)
	print(v.Name)
	destroy_highlight(v)
end)]]
local function get_distance(part)
	return (part.Position - workspace.CurrentCamera.CFrame.Position).magnitude
end
local function player_added(plr)
	if plr.Character then
		create_esp(plr)
	end
	plr.CharacterAdded:Connect(function(chr)
		create_esp(plr)
	end)
end
for _, v in pairs(players:GetPlayers()) do
	player_added(v)
end
players.PlayerAdded:Connect(player_added)

runService.RenderStepped:Connect(function()
	for _, esp in pairs(esps) do
		local chr = esp.Character
		local hrp = chr:WaitForChild("HumanoidRootPart")
		local hum = chr:WaitForChild("Humanoid")
		local root_position, root_visible = workspace.CurrentCamera:WorldToViewportPoint(hrp.Position)
		if root_visible and config["PlayerESP"] == true then
			esp.Text.Position = Vector2.new(root_position.X, root_position.Y)
			esp.Text.Text = string.format("%s [%s]\n[%s][%s/%s]", utility.getIngameName(players:GetPlayerFromCharacter(chr)), chr.Name, tostring(math.floor(get_distance(hrp))), math.floor(hum.Health), math.floor(hum.MaxHealth))
			esp.Text.Visible = true
			
			esp.Text.Color = Color3.fromRGB(table.unpack(config["PlayerESPColor"]))
			esp.Text.Center = config["PlayerESPTextCentered"]
			esp.Text.Outline = config["PlayerESPTextOutline"]
			esp.Text.Font = config["PlayerESPTextFont"]
			esp.Text.Size = config["PlayerESPTextSize"]
		else
			esp.Text.Visible = false
		end
	end
	if config["Flight"] == true and character and torso and root then
		local direction = (workspace.CurrentCamera.CFrame.RightVector * (keys.D - keys.A) + workspace.CurrentCamera.CFrame.LookVector * (keys.W - keys.S));
		player.Character.HumanoidRootPart.Velocity = (direction * config["FlightSpeed"]);
	end
	if config["CharacterNoclip"] then
		character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Freefall)
		character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)

		local partsInPart = workspace:GetPartsInPart(root)
		for _, part in pairs(partsInPart) do
			if recent_parts[part] or (not part:IsDescendantOf(character) and part.CanCollide == true) then
				recent_parts[part] = tick()
				physicsService:SetPartCollisionGroup(part, "WalkThrough")
				part.CanCollide = false
			end
		end
	else
		for i, v in pairs(recent_parts) do
			physicsService:SetPartCollisionGroup(i, "Default")
			i.CanCollide = true
		end
		table.clear(recent_parts)
	end
	--[[if config["CharacterNoclip"] == true then
		root.CanCollide = false
		head.CanCollide = false
	else
		root.CanCollide = true
	end]]
	if config["CharacterNoclip"] == true then
		for _, v in pairs(character:GetDescendants()) do
			pcall(function()
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end)
		end
	end
	
	chat_logger.Enabled = config["ChatLogger"]
	local totalSize = UDim2.new(0, 0, 0, 0)
	for _, textLabel in pairs(chat_logger_holder:GetChildren()) do
		if textLabel:IsA("TextLabel") then
			totalSize = totalSize + UDim2.new(0, 0, 0, textLabel.Size.Y.Offset)
			if totalSize.Y.Offset >= chat_logger_holder.CanvasSize.Y.Offset then
				chat_logger_holder.CanvasSize = UDim2.new(totalSize.X.Scale, totalSize.X.Offset, totalSize.Y.Scale, totalSize.Y.Offset + 100)
				chat_logger_holder.CanvasPosition = chat_logger_holder.CanvasPosition + Vector2.new(0, totalSize.Y.Offset)
			end
			textLabel.TextColor3 = Color3.fromRGB(table.unpack(config["ChatLoggerNormalTextColor"]))
			if textLabel:GetAttribute("Illusionist") then
				textLabel.TextColor3 = Color3.fromRGB(table.unpack(config["ChatLoggerIllusionistTextColor"]))
			end
		end
	end
	
	if _G.Opium.DayFarmer["Toggled"] == true then
		for _, opp in pairs(workspace.Live:GetChildren()) do
			if opp ~= character and opp:FindFirstChild("HumanoidRootPart") and (opp.HumanoidRootPart.Position - root.Position).magnitude <= _G.Opium.DayFarmer.LogRange then
				if account then
					player:Kick("Serverhopping")
					utility.blockRandomUser()
					teleportService:Teleport(3016661674, player)
					return
				else
					player:Kick("")
				end
			end
		end
	end
end)

clientStorage:WaitForChild("DefaultChatSystemChatEvents").OnMessageDoneFiltering.OnClientEvent:Connect(function(object)
	if object.Message ~= "" then
		local plr = players:WaitForChild(object.FromSpeaker)
		local text_label = chat_logger_template:Clone()
		text_label.Name = object.FromSpeaker
		text_label.Text = string.format("%s [%s]: %s", object.FromSpeaker, utility.getIngameName(plr), object.Message)
		text_label.Parent = chat_logger_holder
		
		text_label.TextColor3 = Color3.fromRGB(table.unpack(config["ChatLoggerNormalTextColor"]))
		if plr.Character and plr.Character:FindFirstChild("Observe") then
			text_label.TextColor3 = Color3.fromRGB(table.unpack(config["ChatLoggerIllusionistTextColor"]))
			text_label:SetAttribute("Illusionist", true)
		end
	end
end)

local function illusionist_check(plr, bool)
	if config["IllusionistDetector"] == true and plr.Backpack:FindFirstChild("Observe") then
		notify("opium", bool == false and string.format("%s has observe but he left", plr.Name) or string.format("%s has observe", plr.Name), 5)
	end
end

for _, plr in pairs(players:GetPlayers()) do
	if plr.Character then
		illusionist_check(plr, true)
	end
end
players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		illusionist_check(plr, true)
	end)
end)
players.PlayerRemoving:Connect(function(plr)
	illusionist_check(plr, false)
end)

local toggles = {
	["FlightKeybind"] = {
		connection = nil,
		value = config["Flight"]
	}
}

userInput.InputBegan:Connect(function(input, gpe)
	if gpe then
		return
	end
	for name, keycodeName in pairs(config) do
		if type(keycodeName) == "string" and Enum.KeyCode[keycodeName] and input.KeyCode == Enum.KeyCode[keycodeName] then
			if toggles[name] then
				toggles[name].value = not toggles[name].value
				toggles[name].connection:set(toggles[name].value)
			end
		end
	end

	if input.KeyCode and keys[input.KeyCode.Name] then
		keys[input.KeyCode.Name] = 1
	end

	--[[if input.KeyCode == Enum.KeyCode.W then 
		keys.W = 1
	end
	if input.KeyCode == Enum.KeyCode.A then 
		keys.A = 1
	end
	if input.KeyCode == Enum.KeyCode.S then 
		keys.S = 1
	end
	if input.KeyCode == Enum.KeyCode.D then 
		keys.D = 1
	end]]
end)
userInput.InputEnded:Connect(function(input, gpe)
	if gpe then
		return
	end

	if input.KeyCode and keys[input.KeyCode.Name] then
		keys[input.KeyCode.Name] = 0
	end
end)

--# remote spoofa


--#

--# dialogue remote getter

local clientStorageDescendants = clientStorage:GetDescendants()	
if #clientStorageDescendants > 0 then
	for _, v in pairs(clientStorageDescendants) do
		if v:IsA("RemoteEvent") then
			v.OnClientEvent:Connect(function(args)
				if typeof(args) == "table" and args.msg then
					if args.msg == "...This one is a fine scroll." then
						saveUserProfile("last_gacha_roll", os.clock())
						return
					end
				end
			end)
		end
	end
end

--#

--#

--# library

local window = library:new({
	textsize = 13.5,
	font = Enum.Font.RobotoMono,
	name = "opium",
	color = Color3.fromRGB(table.unpack(config["MenuColor"])),
})
window.key = Enum.KeyCode[config["Menu"]]

--# player

local playerTab = window:page({
	name = "Player"
})

local playerLeft = playerTab:section({
	name = "",
	side = "left",
	size = 250,
})

playerLeft:toggle({
	name = "NoFall",
	def = config["NoFall"],
	callback = function(value)
		changeValue("NoFall", value)
	end,
})

toggles["FlightKeybind"].connection = playerLeft:toggle({
	name = "Flight",
	def = config["Flight"],
	callback = function(value)
		changeValue("Flight", value)
	end,
})

playerLeft:slider({
	name = "Flight Speed",
	def = config["FlightSpeed"],
	min = 1,
	max = 100,
	rounding = true,
	ticking = false,
	measuring = "",
	callback = function(value)
		changeValue("FlightSpeed", value)
	end,
})

playerLeft:toggle({
	name = "Character Noclip",
	def = config["CharacterNoclip"],
	callback = function(value)
		changeValue("CharacterNoclip", value)
	end,
})

playerLeft:button({
	name = "Headless",
	callback = function()
		if not collectionService:HasTag(character, "Knocked") then
			notify("opium", "headless requires you to be ragdolled in order to use it", 2.5)
		else
			head:Destroy()
		end
	end,
})

playerLeft:button({
	name = "Reset",
	callback = function()
		character:BreakJoints()
	end,
})

playerLeft:button({
	name = "Serverhop",
	callback = function()
		if account then
			player:Kick("Serverhopping")
			utility.blockRandomUser()
			task.wait(0.5)
			teleportService:Teleport(3016661674, player)
		else
			notify("opium", "roblox account manager is required for this feature", 5)
			return
		end
	end,
})

--#
--# esp

local espTab = window:page({
	name = "ESP"
})

local esp = espTab:section({
	name = "Player ESP",
	side = "left",
	size = 250,
})
esp:toggle({
	name = "Enabled",
	def = config["PlayerESP"],
	callback = function(value)
		changeValue("PlayerESP", value)
	end,
})
esp:toggle({
	name = "Centered",
	def = config["PlayerESPTextCentered"],
	callback = function(value)
		changeValue("PlayerESPTextCentered", value)
	end,
})
esp:toggle({
	name = "Outline",
	def = config["PlayerESPTextOutline"],
	callback = function(value)
		changeValue("PlayerESPTextOutline", value)
	end,
})
esp:slider({
	name = "Text Font",
	def = config["PlayerESPTextFont"],
	min = 0,
	max = 3,
	rounding = true,
	ticking = false,
	callback = function(value)
		changeValue("PlayerESPTextFont", value)
	end,
})
esp:slider({
	name = "Text Size",
	def = config["PlayerESPTextSize"],
	min = 1,
	max = 100,
	rounding = true,
	ticking = false,
	callback = function(value)
		changeValue("PlayerESPTextSize", value)
	end,
})
esp:colorpicker({
	name = "Player ESP Color",
	def = Color3.fromRGB(table.unpack(config["PlayerESPColor"])),
	callback = function(value)
		config["PlayerESPColor"][1] = math.floor(value.r * 255)
		config["PlayerESPColor"][2] = math.floor(value.g * 255)
		config["PlayerESPColor"][3] = math.floor(value.b * 255)
	end,
})

--[[local chams = espTab:section({
	name = "Chams",
	side = "right",
	size = 250,
})
local glow = espTab:section({
	name = "Glow",
	side = "left",
	size = 250,
})

chams:toggle({
	name = "Chams",
	def = config["Chams"],
	callback = function(value)
		changeValue("Chams", value)
	end,
})
chams:slider({
	name = "Chams Transparency",
	def = config["ChamsTransparency"],
	min = 0,
	max = 1,
	rounding = false,
	ticking = false,
	measuring = "",
	callback = function(value)
		changeValue("ChamsTransparency", value)
	end,
})
chams:colorpicker({
	name = "Chams Color",
	def = Color3.fromRGB(table.unpack(config["ChamsColor"])),
	callback = function(value)
		config["ChamsColor"][1] = math.floor(value.r * 255)
		config["ChamsColor"][2] = math.floor(value.g * 255)
		config["ChamsColor"][3] = math.floor(value.b * 255)
	end,
})

glow:toggle({
	name = "Glow",
	def = config["Glow"],
	callback = function(value)
		changeValue("Glow", value)
	end,
})
glow:slider({
	name = "Glow Transparency",
	def = config["GlowTransparency"],
	min = 0,
	max = 1,
	rounding = false,
	ticking = false,
	measuring = "",
	callback = function(value)
		changeValue("GlowTransparency", value)
	end,
})
glow:colorpicker({
	name = "Glow Color",
	def = Color3.fromRGB(table.unpack(config["GlowColor"])),
	callback = function(value)
		config["GlowColor"][1] = math.floor(value.r * 255)
		config["GlowColor"][2] = math.floor(value.g * 255)
		config["GlowColor"][3] = math.floor(value.b * 255)
	end,
})]]

--#
--# misc

local misc = window:page({
	name = "Misc"
})

local miscLeft = misc:section({
	name = "",
	side = "left",
	size = 250
})

miscLeft:toggle({
	name = "Illusionist Detector",
	def = config["IllusionistDetector"],
	callback = function(value)
		changeValue("IllusionistDetector", value)
	end,
})

miscLeft:toggle({
	name = "Chat Logger",
	def = config["ChatLogger"],
	callback = function(value)
		changeValue("ChatLogger", value)
	end,
})

miscLeft:button({
	name = "Last Gacha Roll",
	callback = function()
		notify("opium", string.format("you rolled gacha %s minutes ago while having opium on", tostring((os.time() - user_profile_table["last_gacha_roll"]) / 60)))
	end,
})

--#
--# trinket bot

local pointVisualizers = {}
local points = {}
local speed = 1

local trinketBot = window:page({
	name = "Trinket Bot"
})

local trinketBotLeft = trinketBot:section({
	name = "",
	side = "left",
	size = 150
})

local function noclip()
	return runService.RenderStepped:Connect(function()
		torso.CanCollide = false
		character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Freefall)
		character:WaitForChild("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end

trinketBotLeft:button({
	name = "Start Path",
	callback = function()
		for _, point in pairs(points) do
			local conn = noclip()
			local tween = tweenService:Create(root, TweenInfo.new((root.Position - point.Position).magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
				CFrame = point
			})
			tween:Play()
			tween.Completed:wait()
			conn:Disconnect()
		end
	end,
})
trinketBotLeft:button({
	name = "Create Point",
	callback = function()
		local cf = root.CFrame
		points[#points + 1] = cf
	end,
})
trinketBotLeft:button({
	name = "Reset Points",
	callback = function()
		table.clear(points)
	end,
})
trinketBotLeft:button({
	name = "Visualize Points",
	callback = function()
		for _, visualizer in pairs(pointVisualizers) do
			visualizer:Destroy()
			visualizer = nil
		end
		for index, point in pairs(points) do
			local pointPart = Instance.new("Part")
			pointPart.Size = Vector3.new(1, 1, 1) * 1
			pointPart.Transparency = 0.5
			pointPart.Anchored = true
			pointPart.CanCollide = false
			pointPart.CFrame = point
			pointPart.Color = Color3.fromRGB(table.unpack(config["TrinketPathVisualizerColor"]))
			pointPart.Parent = workspace.CurrentCamera
			table.insert(pointVisualizers, pointPart)
			local nextPoint = points[index + 1]
			if nextPoint then
				local distance = (point.Position - nextPoint.Position).Magnitude
				local link = Instance.new("Part")
				link.Anchored = true
				link.CanCollide = false
				link.Size = Vector3.new(0.1, 0.1, distance)
				link.Transparency = 0.5
				link.Color = Color3.fromRGB(table.unpack(config["TrinketPathVisualizerColor"]))
				link.CFrame = CFrame.lookAt(point.Position, nextPoint.Position) * CFrame.new(0, 0, -distance/2)
				link.Parent = workspace.CurrentCamera
				table.insert(pointVisualizers, link)
			end
		end
	end,
})
trinketBotLeft:slider({
	name = "Path Speed",
	def = speed,
	min = 1,
	max = 100,
	rounding = true,
	ticking = false,
	measuring = "",
	callback = function(value)
		speed = value
	end,
})
trinketBotLeft:colorpicker({
	name = "Visualizer Color",
	def = Color3.fromRGB(table.unpack(config["TrinketPathVisualizerColor"])),
	callback = function(value)
		config["TrinketPathVisualizerColor"][1] = math.floor(value.r * 255)
		config["TrinketPathVisualizerColor"][2] = math.floor(value.g * 255)
		config["TrinketPathVisualizerColor"][3] = math.floor(value.b * 255)
		for _, vis in pairs(pointVisualizers) do
			vis.Color = Color3.fromRGB(table.unpack(config["TrinketPathVisualizerColor"]))
		end
	end,
})
--#
--# day farmer

local dayFarmer = window:page({
	name = "Day Farmer"
})
local dayFarmerLeft = dayFarmer:section({
	name = "",
	side = "left",
	size = 150
})
dayFarmerLeft:button({
	name = "Start Day Farmer",
	callback = function()
		if account then
			_G.Opium.DayFarmer["Toggled"] = true
		else
			notify("spellware", "roblox account manager is required for this feature", 5)
			return
		end
	end,
})
dayFarmerLeft:slider({
	name = "Log Range",
	def = _G.Opium.DayFarmer.LogRange,
	min = 1,
	max = 10000,
	rounding = true,
	ticking = false,
	measuring = "",
	callback = function(value)
		_G.Opium.DayFarmer.LogRange = value
	end,
})

--#
--# keybinds

local keybinds = window:page({
	name = "Keybinds"
})

local keybindsLeft = keybinds:section({
	name = "Keybinds",
	side = "left",
	size = 150
})

keybindsLeft:keybind({
	name = "Flight",
	def = Enum.KeyCode[config["FlightKeybind"]],
	callback = function(key)
		toggles["FlightKeybind"][2] = true
		changeValue("FlightKeybind", key.Name)
	end,
})

keybindsLeft:keybind({
	name = "Menu",
	def = Enum.KeyCode[config["Menu"]],
	callback = function(key)
		changeValue("Menu", key.Name)
		window.key = key
	end,
})


--#
--# settings

local settingsTab = window:page({
	name = "Settings"
})

local settingsLeft = settingsTab:section({
	name = "",
	side = "left",
	size = 250
})

settingsLeft:button({
	name = "Save Default",
	callback = function()
		saveSettings()
	end,
})

settingsLeft:button({
	name = "Load Default",
	callback = function()
		config = httpService:JSONDecode(syn.crypt.decrypt(readfile(configFile), key))
	end,
})

local guiColors = settingsTab:section({
	name = "",
	side = "right",
	size = 250
})
guiColors:colorpicker({
	name = "Menu Color",
	def = Color3.fromRGB(table.unpack(config["MenuColor"])),
	callback = function(value)
		config["MenuColor"][1] = math.floor(value.r * 255)
		config["MenuColor"][2] = math.floor(value.g * 255)
		config["MenuColor"][3] = math.floor(value.b * 255)
		window:settheme("accent", Color3.fromRGB(table.unpack(config["MenuColor"])))
	end,
})
guiColors:colorpicker({
	name = "Leaderboard Spectate Color",
	def = Color3.fromRGB(table.unpack(config["LeaderboardSpectateColor"])),
	callback = function(value)
		config["LeaderboardSpectateColor"][1] = math.floor(value.r * 255)
		config["LeaderboardSpectateColor"][2] = math.floor(value.g * 255)
		config["LeaderboardSpectateColor"][3] = math.floor(value.b * 255)
	end,
})
guiColors:colorpicker({
	name = "Chat Logger Normal Text Color",
	def = Color3.fromRGB(table.unpack(config["ChatLoggerNormalTextColor"])),
	callback = function(value)
		config["ChatLoggerNormalTextColor"][1] = math.floor(value.r * 255)
		config["ChatLoggerNormalTextColor"][2] = math.floor(value.g * 255)
		config["ChatLoggerNormalTextColor"][3] = math.floor(value.b * 255)
	end,
})
guiColors:colorpicker({
	name = "Chat Logger Illusionist Text Color",
	def = Color3.fromRGB(table.unpack(config["ChatLoggerIllusionistTextColor"])),
	callback = function(value)
		config["ChatLoggerIllusionistTextColor"][1] = math.floor(value.r * 255)
		config["ChatLoggerIllusionistTextColor"][2] = math.floor(value.g * 255)
		config["ChatLoggerIllusionistTextColor"][3] = math.floor(value.b * 255)
	end,
})

--#
--#
